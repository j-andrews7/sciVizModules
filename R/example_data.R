#' Load a bundled example dataset
#'
#' The package's example datasets live in `data/` and `DESCRIPTION` sets no
#' `LazyData`, deliberately: Bioconductor asks packages not to, and these
#' `.rda` files are large. That means they are *not* promises in the package
#' namespace, so package code cannot reach them by name -- a `*App()` whose
#' default data is a bare `example_sce` fails with "object not found" for
#' anyone who has not run [utils::data()] themselves first.
#'
#' This loads one into a throwaway environment and returns it, so the default
#' arguments and `data_list` fallbacks in the `*App()` functions work without
#' attaching anything to the caller's workspace.
#'
#' @param name Character string naming a dataset in this package's `data/`.
#'
#' @return The dataset object.
#'
#' @importFrom utils data
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_example_data
#' @keywords internal
.sci_example_data <- function(name) {
    env <- new.env(parent = emptyenv())
    utils::data(list = name, package = "sciVizModules", envir = env)
    if (!exists(name, envir = env, inherits = FALSE)) {
        stop(
            sprintf("Example dataset '%s' could not be loaded from sciVizModules.", name),
            call. = FALSE
        )
    }
    get(name, envir = env, inherits = FALSE)
}
