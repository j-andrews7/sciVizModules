#' Fetch a default value for a survivalCurve input
#'
#' @param defaults A named list of defaults (may be `NULL`).
#' @param key The default name to look up.
#' @param fallback The value to return when `key` is absent.
#' @return The stored default or `fallback`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_sv_default
#' @keywords internal
.sv_default <- function(defaults, key, fallback = NULL) {
    if (!is.null(defaults) && key %in% names(defaults)) {
        return(defaults[[key]])
    }
    fallback
}


#' Auto-detect a follow-up time column
#'
#' @param data A data frame.
#' @param num.choices Character vector of numeric column names in `data`.
#' @return The name of the best-guess time column, or `NULL`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_detect_time_col
#' @keywords internal
.detect_time_col <- function(data, num.choices) {
    if (length(num.choices) == 0) {
        return(NULL)
    }
    patterns <- c("^time$", "^os$", "^os_time$", "^pfs$", "^fu", "time", "surv")
    for (p in patterns) {
        hit <- grep(p, num.choices, ignore.case = TRUE, value = TRUE)
        if (length(hit) > 0) {
            return(hit[1])
        }
    }
    num.choices[1]
}


#' Auto-detect an event/status column
#'
#' @param data A data frame.
#' @param num.choices Character vector of numeric column names in `data`.
#' @return The name of the best-guess status column, or `NULL`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_detect_status_col
#' @keywords internal
.detect_status_col <- function(data, num.choices) {
    patterns <- c("^status$", "^event$", "^vital", "^dead$", "censor", "status", "event")
    for (p in patterns) {
        hit <- grep(p, names(data), ignore.case = TRUE, value = TRUE)
        if (length(hit) > 0) {
            return(hit[1])
        }
    }
    # Fall back to a numeric column that looks like a 0/1 or 1/2 indicator.
    for (nm in num.choices) {
        vals <- unique(stats::na.omit(data[[nm]]))
        if (length(vals) > 0 && length(vals) <= 2 && all(vals %in% c(0, 1, 2))) {
            return(nm)
        }
    }
    if (length(num.choices) > 1) num.choices[2] else if (length(num.choices)) num.choices[1] else NULL
}
