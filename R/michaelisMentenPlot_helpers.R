#' Extract Michaelis-Menten parameters (K and Vmax) from a stats object
#'
#' Pulls the Michaelis constant (`K`) and maximum velocity (`Vmax`) from a
#' fitted model or a supplied set of coefficients, for use in plot annotations.
#'
#' @param stats A fitted model whose [stats::coef()] returns named `K` and `Vm`
#'   / `Vmax` coefficients (e.g. an `nls` fit of `v ~ Vm * S / (K + S)`), or a
#'   named numeric vector / list containing those values. `NULL` returns
#'   `NULL`.
#' @return A named list with elements `K` and `Vmax` (each possibly `NA` when
#'   not found), or `NULL` when `stats` is `NULL`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_mm_params
#' @keywords internal
.mm_params <- function(stats) {
    if (is.null(stats)) {
        return(NULL)
    }

    co <- tryCatch(stats::coef(stats), error = function(e) NULL)
    if (is.null(co)) {
        co <- unlist(stats)
    }
    nm <- names(co)
    if (is.null(nm)) {
        return(NULL)
    }

    k_idx <- grep("^k$", nm, ignore.case = TRUE)
    vm_idx <- grep("^(vm|vmax)$", nm, ignore.case = TRUE)

    list(
        K = if (length(k_idx)) unname(co[k_idx[1]]) else NA_real_,
        Vmax = if (length(vm_idx)) unname(co[vm_idx[1]]) else NA_real_
    )
}
