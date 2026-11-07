#' Create a standalone Shiny app for the methylationTrack module
#'
#' Generates a Shiny application with a selector over the supplied cohorts, a read-only
#' preview of the selected cohort's samples, and the track view with its settings.
#'
#' When `cohort_list` is not provided (or `NULL`), the app launches with the bundled
#' [example_methylation] cohort, on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param cohort_list An optional [methylationCohort()], anything that takes, or a named
#'   list of those.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [methylationTrack()], [methylationCohort()], [sciVizModules::methylationTrackInputsUI()],
#' [sciVizModules::methylationTrackOutputUI()], [sciVizModules::methylationTrackServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- methylationTrackApp()
#' if (interactive()) shiny::runApp(app)
methylationTrackApp <- function(cohort_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(cohort_list)) {
        example <- .sci_module_example("methylation", defaults)
        cohort_list <- example$data_list
        defaults <- example$defaults
    }
    # A cohort is a list too, so one on its own must not be read as a list of them.
    single <- inherits(cohort_list, "methylationCohort") || !is.list(cohort_list) ||
        is.data.frame(cohort_list)
    if (single) {
        cohort_list <- list(Cohort = cohort_list)
    }
    .sci_object_app(
        inputs_ui_fn = methylationTrackInputsUI,
        output_ui_fn = methylationTrackOutputUI,
        server_fn    = methylationTrackServer,
        object_list  = lapply(cohort_list, .meth_as_cohort),
        title        = "Methylation Track",
        validate     = .meth_as_cohort,
        preview      = .meth_preview,
        select_label = "Select Cohort:",
        preview_title = "Samples",
        preview_note = "Read-only preview of the selected cohort's sample information.",
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs
    )
}


#' The table previewed for a cohort
#'
#' @param cohort A `methylationCohort`.
#' @return Its sample table.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_server
#' @keywords internal
.meth_preview <- function(cohort) {
    cohort$samples
}
