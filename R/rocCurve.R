#' ROC curves
#'
#' Receiver operating characteristic curves for one or more numeric predictors
#' of a binary outcome, with the area under each curve (AUC), its DeLong 95%
#' confidence interval (when pROC is installed), and the Youden-optimal cut-off.
#' The curves and AUCs are computed in the package and match [pROC::roc()]; the
#' AUC is the Mann-Whitney estimate, so ties count one half.
#'
#' @param data A data frame.
#' @param response The binary outcome column (two distinct values).
#' @param predictors Numeric predictor columns.
#' @param positive The level of `response` that is a case. Default: the second
#'   factor level, `TRUE`, `1`, or the larger of two values.
#' @param direction `"auto"`, `"<"` (cases have higher values) or `">"` (cases
#'   have lower values). `"auto"` compares the medians, as pROC does.
#' @param ci Logical; compute the DeLong confidence interval (needs pROC).
#' @param show.youden Logical; mark each curve's Youden-optimal cut-off.
#' @param colors Named vector of colours for the predictors.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the per-predictor table (AUC, CI, direction,
#'   Youden cut-off, sensitivity and specificity there, cases and controls) as
#'   attribute `"table"`.
#'
#' @import plotly
#' @seealso [rocCurveServer()], [pROC::roc()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_biomarkers)
#' rocCurve(example_biomarkers, response = "disease",
#'     predictors = c("marker_strong", "marker_moderate", "marker_weak"))
rocCurve <- function(data, response, predictors, positive = NULL, direction = "auto", ci = TRUE,
                     show.youden = TRUE, colors = NULL, main = NULL) {
    data <- as.data.frame(data)
    if (!nz_value(response) || !response %in% names(data)) stop("Choose a response column.", call. = FALSE)
    predictors <- intersect(predictors, names(data))
    predictors <- predictors[vapply(data[predictors], is.numeric, logical(1))]
    predictors <- setdiff(predictors, response)
    if (length(predictors) == 0) stop("Choose at least one numeric predictor.", call. = FALSE)

    outcome <- .roc_outcome(data[[response]], positive)
    palette <- resolve_palette(predictors, NULL, default_palettes()[["choices"]][["Defaults"]][["dittoColors"]], colors)

    rows <- list()
    fig <- plot_ly()
    for (p in predictors) {
        keep <- !is.na(outcome$case) & is.finite(data[[p]])
        roc <- .roc_curve(outcome$case[keep], data[[p]][keep], direction)
        ci_vals <- if (isTRUE(ci)) .roc_ci(outcome$case[keep], data[[p]][keep], roc$direction) else c(NA, NA)
        yd <- roc$youden
        label <- if (all(is.finite(ci_vals))) {
            sprintf("%s (AUC %.3f, 95%% CI %.3f-%.3f)", p, roc$auc, ci_vals[1], ci_vals[2])
        } else {
            sprintf("%s (AUC %.3f)", p, roc$auc)
        }
        fig <- add_trace(fig,
            x = 1 - roc$curve$specificity, y = roc$curve$sensitivity, type = "scatter", mode = "lines",
            name = label, legendgroup = p, line = list(color = palette[[p]], width = 2),
            text = sprintf("%s<br>cut-off %s<br>sensitivity %.3f<br>specificity %.3f", p,
                signif(roc$curve$threshold, 4), roc$curve$sensitivity, roc$curve$specificity),
            hoverinfo = "text"
        )
        if (isTRUE(show.youden)) {
            fig <- add_trace(fig,
                x = 1 - yd$specificity, y = yd$sensitivity, type = "scatter", mode = "markers",
                legendgroup = p, showlegend = FALSE,
                marker = list(color = palette[[p]], size = 10, line = list(color = "#000000", width = 1)),
                text = sprintf("%s: Youden cut-off %s<br>sensitivity %.3f<br>specificity %.3f", p,
                    signif(yd$threshold, 4), yd$sensitivity, yd$specificity),
                hoverinfo = "text"
            )
        }
        rows[[p]] <- data.frame(
            predictor = p, auc = roc$auc, ci.lower = ci_vals[1], ci.upper = ci_vals[2], direction = roc$direction,
            youden.threshold = yd$threshold, sensitivity = yd$sensitivity, specificity = yd$specificity,
            cases = sum(outcome$case[keep]), controls = sum(!outcome$case[keep]), stringsAsFactors = FALSE
        )
    }

    fig <- layout(fig,
        title = list(text = main %||% ""),
        xaxis = list(title = list(text = "1 - Specificity"), range = c(-0.02, 1.02), zeroline = FALSE),
        yaxis = list(title = list(text = "Sensitivity"), range = c(-0.02, 1.02), zeroline = FALSE),
        shapes = list(list(type = "line", x0 = 0, y0 = 0, x1 = 1, y1 = 1, xref = "x", yref = "y",
            line = list(color = "#9E9E9E", dash = "dash", width = 1)))
    )
    table <- do.call(rbind, unname(rows))
    attr(table, "positive") <- outcome$positive
    attr(fig, "table") <- table
    fig
}


#' Code a binary outcome as case / control
#'
#' @param x The outcome column.
#' @param positive The case level, or `NULL` for the default.
#' @return A list with logical `case` and the `positive` level used.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_roc_outcome
#' @keywords internal
.roc_outcome <- function(x, positive = NULL) {
    lv <- if (is.factor(x)) levels(droplevels(x)) else sort(unique(x[!is.na(x)]))
    if (length(lv) != 2) {
        stop("The response must have exactly two values; it has ", length(lv), ".", call. = FALSE)
    }
    positive <- if (is.null(positive) || !nz_value(as.character(positive))) lv[2] else positive
    if (!as.character(positive) %in% as.character(lv)) {
        stop("'", positive, "' is not a value of the response.", call. = FALSE)
    }
    list(case = ifelse(is.na(x), NA, as.character(x) == as.character(positive)), positive = as.character(positive))
}


#' ROC curve, AUC and Youden cut-off of one predictor
#'
#' Thresholds are the midpoints between consecutive distinct predictor values,
#' plus -Inf and Inf, as in pROC. With direction `"<"`, a value above the
#' threshold is called a case.
#'
#' @param case Logical vector, `TRUE` for cases.
#' @param x Numeric predictor.
#' @param direction `"auto"`, `"<"` or `">"`.
#' @return A list with `curve` (threshold, sensitivity, specificity, from (0, 0)
#'   to (1, 1)), `auc`, `direction` and `youden` (the row maximising
#'   sensitivity + specificity - 1).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_roc_curve
#' @keywords internal
.roc_curve <- function(case, x, direction = "auto") {
    cases <- x[case]
    controls <- x[!case]
    if (length(cases) == 0 || length(controls) == 0) {
        stop("Both cases and controls are needed for a ROC curve.", call. = FALSE)
    }
    if (identical(direction, "auto") || !direction %in% c("<", ">")) {
        direction <- if (stats::median(controls) <= stats::median(cases)) "<" else ">"
    }
    v <- sort(unique(x))
    thr <- c(-Inf, (v[-1] + v[-length(v)]) / 2, Inf)
    if (direction == "<") {
        sens <- vapply(thr, function(t) mean(cases > t), numeric(1))
        spec <- vapply(thr, function(t) mean(controls <= t), numeric(1))
        thr <- rev(thr)
        sens <- rev(sens)
        spec <- rev(spec)
    } else {
        sens <- vapply(thr, function(t) mean(cases < t), numeric(1))
        spec <- vapply(thr, function(t) mean(controls >= t), numeric(1))
    }
    n1 <- length(cases)
    n0 <- length(controls)
    r <- rank(c(cases, controls))
    auc_lt <- (sum(r[seq_len(n1)]) - n1 * (n1 + 1) / 2) / (n1 * n0)
    auc <- if (direction == "<") auc_lt else 1 - auc_lt

    curve <- data.frame(threshold = thr, sensitivity = sens, specificity = spec)
    best <- which.max(curve$sensitivity + curve$specificity - 1)
    list(curve = curve, auc = auc, direction = direction, youden = curve[best, , drop = FALSE])
}


#' DeLong confidence interval of an AUC
#'
#' @param case Logical vector, `TRUE` for cases.
#' @param x Numeric predictor.
#' @param direction `"<"` or `">"`.
#' @param level Confidence level.
#' @return The lower and upper bounds, or `c(NA, NA)` when pROC is not installed.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_roc_ci
#' @keywords internal
.roc_ci <- function(case, x, direction, level = 0.95) {
    if (!requireNamespace("pROC", quietly = TRUE)) {
        return(c(NA_real_, NA_real_))
    }
    roc <- pROC::roc(case, x, levels = c(FALSE, TRUE), direction = direction, quiet = TRUE)
    ci <- pROC::ci.auc(roc, conf.level = level, method = "delong")
    c(ci[1], ci[3])
}


#' Default inputs for the rocCurve module
#'
#' The response is the first two-valued column (preferring names such as
#' outcome, disease, status, class or label), the case its second value, and the
#' predictors up to three numeric columns.
#'
#' @param data The data frame.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_roc_defaults
#' @keywords internal
.roc_defaults <- function(data, defaults = NULL) {
    binary <- names(data)[vapply(data, function(v) length(unique(v[!is.na(v)])) == 2, logical(1))]
    preferred <- binary[grepl("outcome|disease|status|class|label|response|case|group", binary, ignore.case = TRUE)]
    response <- c(preferred, binary)[1] %||% ""
    num <- setdiff(names(data)[vapply(data, is.numeric, logical(1))], response)
    positive <- if (nzchar(response)) .roc_outcome(data[[response]])$positive else ""
    base <- list(
        response = response,
        positive = positive,
        predictors = utils::head(num, 3),
        direction = "auto",
        ci = TRUE,
        show.youden = TRUE
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}
