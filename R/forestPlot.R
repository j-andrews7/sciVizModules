#' Forest plot of model effect estimates
#'
#' Fits a Cox proportional hazards, logistic, or linear regression model to
#' `data` and draws each covariate's effect estimate with its confidence interval
#' as an interactive forest plot. Hazard and odds ratios are drawn on a log axis
#' with a reference line at 1; linear coefficients on a linear axis with a
#' reference line at 0.
#'
#' Covariates may be numeric (one row, the effect per unit) or categorical (one
#' row per level, plus a row for the reference level, which is the first factor
#' level). Character and logical columns are treated as factors. With
#' `multivariable = TRUE` all covariates enter one model, so each estimate is
#' adjusted for the others; with `FALSE` each covariate is fitted on its own
#' (univariable estimates). Rows with a missing value in any variable a model uses
#' are dropped from that model.
#'
#' Confidence intervals are Wald intervals for every model type, so the three
#' are comparable; for logistic models these can differ slightly from the
#' profile-likelihood intervals `confint()` gives.
#'
#' @param data A data frame.
#' @param model One of `"cox"`, `"logistic"` or `"linear"`.
#' @param covariates Character vector of covariate column names.
#' @param time,status For `model = "cox"`, the follow-up time column and the
#'   event column. The event column may be 0/1 (1 = event), 1/2 (2 = event, the
#'   [survival::Surv()] convention), logical, or a factor/character with an
#'   event label such as `"dead"`.
#' @param outcome For `"logistic"`, a binary outcome column (0/1, logical, or a
#'   two-level factor/character whose second level is the event); for
#'   `"linear"`, a numeric outcome column.
#' @param multivariable Logical; fit all covariates in one model (`TRUE`) or
#'   each on its own (`FALSE`).
#' @param conf.level Confidence level for the intervals.
#' @param show.reference Logical; include a row for each factor's reference level.
#' @param show.table Logical; print the estimate, interval and p-value beside
#'   each row.
#' @param sort.by `"input"` keeps the covariate order given; `"estimate"` sorts
#'   the rows by effect size.
#' @param digits Number of decimal places in the printed estimates.
#' @param point.color,ci.color Colours of the estimate markers and the interval
#'   lines.
#' @param point.size Marker size.
#' @param ci.width Interval line width.
#' @param main Optional plot title.
#'
#' @return A `plotly` object. The estimates table it draws is attached as the
#'   `"estimates"` attribute.
#'
#' @importFrom stats as.formula coef confint confint.default glm binomial lm
#'   complete.cases
#' @importFrom survival coxph Surv
#' @import plotly
#'
#' @seealso [forestPlotInputsUI()], [forestPlotServer()], [forestPlotApp()],
#'   [survival::coxph()], [stats::glm()], [stats::lm()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' data(survival_lung)
#' forestPlot(survival_lung,
#'     model = "cox", time = "time", status = "status",
#'     covariates = c("age", "sex", "ph.ecog")
#' )
forestPlot <- function(data,
                       model = c("cox", "logistic", "linear"),
                       covariates,
                       time = NULL,
                       status = NULL,
                       outcome = NULL,
                       multivariable = TRUE,
                       conf.level = 0.95,
                       show.reference = TRUE,
                       show.table = TRUE,
                       sort.by = c("input", "estimate"),
                       digits = 2,
                       point.color = "#000000",
                       point.size = 10,
                       ci.color = "#000000",
                       ci.width = 2,
                       main = NULL) {
    model <- match.arg(model)
    sort.by <- match.arg(sort.by)

    est <- .forest_estimates(
        data,
        model = model, covariates = covariates, time = time, status = status,
        outcome = outcome, multivariable = multivariable, conf.level = conf.level
    )

    .forest_figure(
        est,
        model = model, conf.level = conf.level, show.reference = show.reference,
        show.table = show.table, sort.by = sort.by, digits = digits,
        point.color = point.color, point.size = point.size,
        ci.color = ci.color, ci.width = ci.width, main = main
    )
}


#' Fit the forest plot's model(s) and tidy the estimates
#'
#' Covariates are renamed to syntactic placeholders before fitting so that any
#' column name works in the formula and every coefficient maps back to exactly
#' one covariate and level.
#'
#' @inheritParams forestPlot
#' @return A data frame with one row per estimate: `variable`, `level`, `label`,
#'   `estimate`, `conf.low`, `conf.high`, `p.value`, `n`, `reference`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_forest_estimates
#' @keywords internal
.forest_estimates <- function(data, model, covariates, time = NULL, status = NULL, outcome = NULL,
                              multivariable = TRUE, conf.level = 0.95) {
    data <- as.data.frame(data)
    response <- if (identical(model, "cox")) c(time, status) else outcome
    if (length(response) != (if (identical(model, "cox")) 2L else 1L) ||
        !all(response %in% names(data))) {
        stop(if (identical(model, "cox")) {
            "A Cox model needs a time and a status column."
        } else {
            "Choose an outcome column."
        }, call. = FALSE)
    }

    covariates <- setdiff(unique(covariates[nzchar(covariates)]), response)
    covariates <- intersect(covariates, names(data))
    if (length(covariates) == 0) {
        stop("Choose at least one covariate.", call. = FALSE)
    }
    if (!is.numeric(conf.level) || length(conf.level) != 1 || is.na(conf.level) ||
        conf.level <= 0 || conf.level >= 1) {
        stop("The confidence level must be between 0 and 1.", call. = FALSE)
    }

    fits <- if (isTRUE(multivariable)) {
        list(covariates)
    } else {
        as.list(covariates)
    }
    rows <- lapply(fits, function(covs) {
        .forest_fit_one(data, model, covs, time, status, outcome, conf.level)
    })
    est <- do.call(rbind, rows)
    rownames(est) <- NULL
    est
}


#' Fit one forest model and return its tidy rows
#'
#' @inheritParams forestPlot
#' @param covs The covariates in this model.
#' @return A data frame as described in [.forest_estimates()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_forest_fit_one
#' @keywords internal
.forest_fit_one <- function(data, model, covs, time, status, outcome, conf.level) {
    safe <- paste0("cov", seq_along(covs), "__")
    df <- data.frame(row.names = seq_len(nrow(data)))
    for (i in seq_along(covs)) {
        x <- data[[covs[i]]]
        if (is.character(x) || is.logical(x)) {
            x <- factor(x)
        }
        if (is.factor(x)) {
            x <- droplevels(x)
        }
        df[[safe[i]]] <- x
    }

    if (identical(model, "cox")) {
        df$.time <- as.numeric(data[[time]])
        df$.status <- .normalize_survival_status(data[[status]])
        lhs <- "survival::Surv(.time, .status)"
    } else if (identical(model, "logistic")) {
        df$.outcome <- .forest_binary_outcome(data[[outcome]], outcome)
        lhs <- ".outcome"
    } else {
        if (!is.numeric(data[[outcome]])) {
            stop("A linear model needs a numeric outcome; '", outcome, "' is not numeric.", call. = FALSE)
        }
        df$.outcome <- data[[outcome]]
        lhs <- ".outcome"
    }

    df <- df[stats::complete.cases(df), , drop = FALSE]
    for (s in safe) {
        if (is.factor(df[[s]])) df[[s]] <- droplevels(df[[s]])
    }
    if (nrow(df) < 2) {
        stop("Too few complete rows to fit the model.", call. = FALSE)
    }

    # A factor left with a single level after dropping incomplete rows has no
    # contrast to estimate.
    single <- vapply(safe, function(s) is.factor(df[[s]]) && nlevels(df[[s]]) < 2, logical(1))
    if (any(single)) {
        stop("'", paste(covs[single], collapse = "', '"),
            "' has fewer than two levels among the complete rows.", call. = FALSE)
    }

    form <- stats::as.formula(paste(lhs, "~", paste(safe, collapse = " + ")))
    fit <- switch(model,
        cox = survival::coxph(form, data = df),
        logistic = stats::glm(form, data = df, family = stats::binomial()),
        linear = stats::lm(form, data = df)
    )

    cf <- stats::coef(summary(fit))
    ci <- if (identical(model, "linear")) {
        stats::confint(fit, level = conf.level)
    } else {
        stats::confint.default(fit, level = conf.level)
    }
    p.col <- grep("^Pr\\(", colnames(cf), value = TRUE)[1]
    # Name explicitly: a one-coefficient model would otherwise drop to an unnamed scalar.
    beta <- stats::setNames(cf[, if (identical(model, "cox")) "coef" else "Estimate"], rownames(cf))
    ratio <- !identical(model, "linear")
    tf <- if (ratio) exp else identity
    null <- if (ratio) 1 else 0

    rows <- list()
    for (i in seq_along(covs)) {
        x <- df[[safe[i]]]
        if (is.factor(x)) {
            lv <- levels(x)
            ref <- data.frame(
                variable = covs[i], level = lv[1], label = paste0(covs[i], ": ", lv[1]),
                estimate = null, conf.low = NA_real_, conf.high = NA_real_, p.value = NA_real_,
                n = sum(x == lv[1]), reference = TRUE, stringsAsFactors = FALSE
            )
            rows[[length(rows) + 1]] <- ref
            for (l in lv[-1]) {
                nm <- paste0(safe[i], l)
                rows[[length(rows) + 1]] <- data.frame(
                    variable = covs[i], level = l, label = paste0(covs[i], ": ", l),
                    estimate = tf(unname(beta[nm])),
                    conf.low = tf(unname(ci[nm, 1])), conf.high = tf(unname(ci[nm, 2])),
                    p.value = unname(cf[nm, p.col]), n = sum(x == l), reference = FALSE,
                    stringsAsFactors = FALSE
                )
            }
        } else {
            nm <- safe[i]
            rows[[length(rows) + 1]] <- data.frame(
                variable = covs[i], level = "", label = covs[i],
                estimate = tf(unname(beta[nm])),
                conf.low = tf(unname(ci[nm, 1])), conf.high = tf(unname(ci[nm, 2])),
                p.value = unname(cf[nm, p.col]), n = nrow(df), reference = FALSE,
                stringsAsFactors = FALSE
            )
        }
    }
    do.call(rbind, rows)
}


#' Coerce a binary outcome to 0/1
#'
#' @param x The outcome column.
#' @param name The column's name, for the error message.
#' @return An integer vector of 0/1 (and `NA`).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_forest_binary_outcome
#' @keywords internal
.forest_binary_outcome <- function(x, name) {
    if (is.logical(x)) {
        return(as.integer(x))
    }
    if (is.numeric(x)) {
        vals <- sort(unique(x[!is.na(x)]))
        if (all(vals %in% c(0, 1))) {
            return(as.integer(x))
        }
        if (length(vals) == 2) {
            return(as.integer(x == vals[2]))
        }
    } else {
        f <- factor(x)
        if (nlevels(f) == 2) {
            return(as.integer(f == levels(f)[2]))
        }
    }
    stop("A logistic model needs a binary outcome; '", name, "' has more than two values.", call. = FALSE)
}


#' Axis label for a forest plot's estimates
#'
#' @param model The model type.
#' @param conf.level The confidence level.
#' @return A character scalar.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_forest_axis_label
#' @keywords internal
.forest_axis_label <- function(model, conf.level) {
    what <- switch(model,
        cox = "Hazard ratio",
        logistic = "Odds ratio",
        linear = "Coefficient"
    )
    sprintf("%s (%s%% CI)", what, format(100 * conf.level))
}


#' Draw a forest plot from a tidy estimates table
#'
#' @param est A data frame from [.forest_estimates()].
#' @inheritParams forestPlot
#' @return A `plotly` object with `est` (as drawn) attached as attribute
#'   `"estimates"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_forest_figure
#' @keywords internal
.forest_figure <- function(est, model, conf.level = 0.95, show.reference = TRUE, show.table = TRUE,
                           sort.by = "input", digits = 2, point.color = "#000000", point.size = 10,
                           ci.color = "#000000", ci.width = 2, main = NULL) {
    if (!isTRUE(show.reference)) {
        est <- est[!est$reference, , drop = FALSE]
    }
    if (identical(sort.by, "estimate")) {
        est <- est[order(est$estimate), , drop = FALSE]
    }
    est$label <- make.unique(est$label, sep = " ")
    ratio <- !identical(model, "linear")
    null <- if (ratio) 1 else 0

    fmt <- function(x) ifelse(is.na(x), "", formatC(x, digits = digits, format = "f"))
    est$ci.text <- ifelse(
        est$reference, "Reference",
        paste0(fmt(est$estimate), " (", fmt(est$conf.low), ", ", fmt(est$conf.high), ")")
    )
    est$p.text <- ifelse(is.na(est$p.value), "", format.pval(est$p.value, digits = 2, eps = 0.001))
    est$hover <- paste0(
        "<b>", est$label, "</b><br>", est$ci.text,
        ifelse(nzchar(est$p.text), paste0("<br>p = ", est$p.text), ""),
        "<br>n = ", est$n
    )

    # plotly cannot take NA in an error array, so a reference row gets no bar.
    upper <- ifelse(est$reference, 0, est$conf.high - est$estimate)
    lower <- ifelse(est$reference, 0, est$estimate - est$conf.low)

    fig <- plot_ly(
        est,
        x = ~estimate, y = ~label, type = "scatter", mode = "markers",
        text = ~hover, hoverinfo = "text", showlegend = FALSE,
        marker = list(
            color = ifelse(est$reference, "rgba(0,0,0,0)", point.color),
            size = point.size, symbol = "square",
            line = list(color = point.color, width = 1.5)
        ),
        error_x = list(
            type = "data", symmetric = FALSE, array = upper, arrayminus = lower,
            color = ci.color, thickness = ci.width, width = 0
        )
    )

    fig <- layout(
        fig,
        title = list(text = main %||% ""),
        xaxis = list(
            title = list(text = .forest_axis_label(model, conf.level)),
            type = if (ratio) "log" else "linear", zeroline = FALSE
        ),
        yaxis = list(
            title = list(text = ""), type = "category",
            categoryorder = "array", categoryarray = rev(est$label)
        ),
        shapes = list(list(
            type = "line", x0 = null, x1 = null, xref = "x", y0 = 0, y1 = 1, yref = "paper",
            line = list(color = "#7F7F7F", dash = "dash", width = 1)
        ))
    )

    if (isTRUE(show.table)) {
        annos <- lapply(seq_len(nrow(est)), function(i) {
            list(
                x = 1.02, xref = "paper", xanchor = "left", y = est$label[i], yref = "y",
                text = paste0(est$ci.text[i], if (nzchar(est$p.text[i])) paste0("   p = ", est$p.text[i])),
                showarrow = FALSE, align = "left"
            )
        })
        fig <- layout(fig, annotations = annos)
    }

    attr(fig, "estimates") <- est[, c(
        "variable", "level", "label", "estimate", "conf.low", "conf.high", "p.value", "n", "reference"
    )]
    fig
}


#' Default inputs for the forest plot module
#'
#' Shared by [forestPlotInputsUI()] and [forestPlotServer()] so the initial and
#' reset states agree. Time and status are detected the way the survival curve
#' module detects them, and the first three remaining columns become the
#' covariates. User-supplied values win.
#'
#' @param data The data frame.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_forest_defaults
#' @keywords internal
.forest_defaults <- function(data, defaults = NULL) {
    if (is.null(defaults)) defaults <- list()
    num.choices <- names(data)[vapply(data, is.numeric, logical(1))]

    base <- list(
        model = "cox",
        time = .detect_time_col(data, num.choices) %||% "",
        status = .detect_status_col(data, num.choices) %||% "",
        multivariable = TRUE,
        conf.level = 0.95,
        show.reference = TRUE,
        show.table = TRUE,
        sort.by = "input",
        digits = 2,
        point.color = "#000000",
        point.size = 10,
        ci.color = "#000000",
        ci.width = 2,
        # The estimate table sits in the right margin.
        margin.r = 260
    )
    base$outcome <- if (nzchar(base$status)) base$status else names(data)[1]
    base$covariates <- utils::head(setdiff(names(data), c(base$time, base$status)), 3)

    utils::modifyList(base, defaults)
}
