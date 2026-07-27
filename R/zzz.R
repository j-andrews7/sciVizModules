#' @keywords internal
.onLoad <- function(libname, pkgname) {
    # Register the drc dose-response model backend with VizModules so the
    # scatter-plot modelling machinery can fit dose-response curves.
    try(.register_drm_backend(), silent = TRUE)
    invisible(NULL)
}
