#' Non-compartmental analysis of one concentration-time profile
#'
#' Computes the standard NCA parameters the way PKNCA does by default:
#' \itemize{
#'   \item Cmax / Tmax (first time of the maximum), Clast / Tlast (last
#'     measurable concentration).
#'   \item AUC from the first to the last measurable time by the linear
#'     trapezoid, or "linear-up / log-down" (log trapezoid on decreasing
#'     segments between positive concentrations).
#'   \item lambda-z by log-linear regression on the terminal points after Tmax:
#'     the last 3 or more points with the best adjusted R-squared, preferring
#'     more points among fits within `adj.r2.tolerance` of the best, and
#'     requiring a positive slope estimate of elimination.
#'   \item Half-life = ln 2 / lambda-z; AUC to infinity = AUClast + Clast /
#'     lambda-z; CL/F = dose / AUCinf and Vz/F = dose / (lambda-z AUCinf) when
#'     a dose is given.
#' }
#'
#' @param time,conc Numeric vectors of one subject's sampling times and
#'   concentrations.
#' @param dose Dose, or `NULL`.
#' @param auc.method `"lin up/log down"` or `"linear"`.
#' @param min.points Minimum points in the terminal regression.
#' @param adj.r2.tolerance Tolerance on adjusted R-squared when preferring more points.
#' @return A one-row data frame of NCA parameters, with the terminal fit's
#'   intercept and first time for drawing it.
#'
#' @importFrom stats lm coef
#' @author Jared Andrews
#' @rdname INTERNAL_pk_nca
#' @keywords internal
.pk_nca <- function(time, conc, dose = NULL, auc.method = "lin up/log down", min.points = 3,
                    adj.r2.tolerance = 1e-4) {
    keep <- is.finite(time) & is.finite(conc)
    ord <- order(time[keep])
    t <- time[keep][ord]
    c <- conc[keep][ord]
    na_row <- data.frame(cmax = NA_real_, tmax = NA_real_, tlast = NA_real_, clast = NA_real_, auclast = NA_real_,
        lambda.z = NA_real_, half.life = NA_real_, r.squared.adj = NA_real_, lambda.z.points = NA_integer_,
        lambda.z.time.first = NA_real_, lambda.z.intercept = NA_real_, aucinf = NA_real_, cl.f = NA_real_,
        vz.f = NA_real_)
    if (length(t) < 2 || all(c <= 0)) {
        return(na_row)
    }

    out <- na_row
    out$cmax <- max(c)
    out$tmax <- t[which.max(c)]
    last <- max(which(c > 0))
    out$tlast <- t[last]
    out$clast <- c[last]

    seg <- seq_len(last - 1)
    dt <- diff(t[seq_len(last)])
    c1 <- c[seg]
    c2 <- c[seg + 1]
    lin <- dt * (c1 + c2) / 2
    if (identical(auc.method, "linear")) {
        out$auclast <- sum(lin)
    } else {
        logd <- c2 < c1 & c1 > 0 & c2 > 0
        logp <- ifelse(logd, dt * (c1 - c2) / (log(c1) - log(c2)), lin)
        out$auclast <- sum(logp)
    }

    post <- which(t > out$tmax & c > 0)
    if (length(post) >= min.points) {
        fits <- lapply(seq(min.points, length(post)), function(n) {
            idx <- utils::tail(post, n)
            y <- log(c[idx])
            fit <- stats::lm(y ~ t[idx])
            # Adjusted R-squared by hand: summary.lm() warns on an exact fit.
            r2 <- 1 - sum(stats::residuals(fit)^2) / sum((y - mean(y))^2)
            list(n = n, slope = unname(stats::coef(fit)[2]), intercept = unname(stats::coef(fit)[1]),
                adj = 1 - (1 - r2) * (n - 1) / (n - 2), first = t[idx[1]])
        })
        fits <- Filter(function(f) is.finite(f$slope) && f$slope < 0 && is.finite(f$adj), fits)
        if (length(fits)) {
            best <- max(vapply(fits, `[[`, 0, "adj"))
            ok <- Filter(function(f) f$adj >= best - adj.r2.tolerance, fits)
            chosen <- ok[[which.max(vapply(ok, `[[`, 0, "n"))]]
            out$lambda.z <- -chosen$slope
            out$half.life <- log(2) / out$lambda.z
            out$r.squared.adj <- chosen$adj
            out$lambda.z.points <- as.integer(chosen$n)
            out$lambda.z.time.first <- chosen$first
            out$lambda.z.intercept <- chosen$intercept
            out$aucinf <- out$auclast + out$clast / out$lambda.z
            if (!is.null(dose) && is.finite(dose)) {
                out$cl.f <- dose / out$aucinf
                out$vz.f <- dose / (out$lambda.z * out$aucinf)
            }
        }
    }
    out
}


#' Non-compartmental analysis per subject
#'
#' @param data The concentration-time data.
#' @param time,conc,subject Column names.
#' @param dose Dose column, or `NULL`.
#' @param group Group column, or `NULL`.
#' @param auc.method Passed to [.pk_nca()].
#' @return A data frame with one row per subject: `subject`, `group`, then the
#'   [.pk_nca()] parameters.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pk_nca_table
#' @keywords internal
.pk_nca_table <- function(data, time, conc, subject, dose = NULL, group = NULL, auc.method = "lin up/log down") {
    pieces <- split(data, as.character(data[[subject]]), drop = TRUE)
    rows <- lapply(names(pieces), function(s) {
        d <- pieces[[s]]
        dv <- if (!is.null(dose) && dose %in% names(d)) as.numeric(d[[dose]][1]) else NULL
        nca <- .pk_nca(as.numeric(d[[time]]), as.numeric(d[[conc]]), dv, auc.method)
        cbind(data.frame(subject = s, group = if (!is.null(group)) as.character(d[[group]][1]) else "All",
            stringsAsFactors = FALSE), nca)
    })
    out <- do.call(rbind, rows)
    rownames(out) <- NULL
    out
}


#' Nominal sampling times for averaging across subjects
#'
#' Sampling times often differ slightly between subjects (0.25 h nominal taken
#' at 0.27 h). Each subject's k-th sample is assigned the median time of all
#' subjects' k-th samples, which recovers the nominal schedule when subjects
#' share one.
#'
#' @param time Sampling times.
#' @param subject Subject ids.
#' @return Nominal times, aligned with `time`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pk_nominal_time
#' @keywords internal
.pk_nominal_time <- function(time, subject) {
    idx <- stats::ave(time, subject, FUN = function(v) rank(v, ties.method = "first"))
    nominal <- tapply(time, idx, stats::median)
    as.vector(nominal[as.character(idx)])
}


#' Detect the columns of concentration-time data
#'
#' @param data The data frame.
#' @return A list with `subject`, `time`, `conc`, `dose`, `group` (column names or `""`).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pk_columns
#' @keywords internal
.pk_columns <- function(data) {
    pick <- function(candidates, numeric = FALSE) {
        hit <- .detect_column(data, candidates, numeric = numeric)
        if (is.null(hit)) {
            idx <- match(tolower(candidates), tolower(names(data)))
            idx <- idx[!is.na(idx)]
            if (length(idx)) hit <- names(data)[idx[1]]
        }
        hit %||% ""
    }
    list(
        subject = pick(c("Subject", "ID", "USUBJID", "SUBJID", "Animal", "Individual")),
        time = pick(c("Time", "TIME", "TAD", "time_h", "Hour"), numeric = TRUE),
        conc = pick(c("conc", "Conc", "DV", "concentration", "CONC", "Concentration"), numeric = TRUE),
        dose = pick(c("Dose", "DOSE", "AMT", "dose_mg"), numeric = TRUE),
        group = pick(c("Treatment", "TRT", "ARM", "Group", "Cohort", "Formulation"))
    )
}
