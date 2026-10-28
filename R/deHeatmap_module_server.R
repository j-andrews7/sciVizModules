#' Server logic for the deHeatmap module
#'
#' Selects the top differentially expressed genes from a results table, takes
#' their transformed expression from the experiment, and draws it with
#' [VizModules::ComplexHeatmap_HeatmapServer()]. The transformation is kept in
#' its own step, so changing the cut-offs does not repeat it.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning
#'   `list(object = <SummarizedExperiment>, results = <data frame>)`, or a
#'   `SummarizedExperiment` whose `rowData` holds the results.
#' @param hide.inputs A character vector of input IDs to hide. The wrapped
#'   module's `matrix.cols` and `rowname.col` are always hidden, since the module
#'   sets them.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values, typically the same list
#'   passed to [deHeatmapInputsUI()].
#' @return The source-data reactive of [VizModules::ComplexHeatmap_HeatmapServer()]:
#'   the matrix drawn (unscaled), the inputs, and SVG/PNG renderers.
#'
#' @import shiny
#'
#' @seealso [sciVizModules::deHeatmapInputsUI()], [sciVizModules::deHeatmapOutputUI()],
#' [sciVizModules::deHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) deHeatmapApp()
#' @export
#' @author Jared Andrews
deHeatmapServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    initial <- tryCatch({
        x <- isolate(data())
        .de_resolve(x)
        x
    }, error = function(e) NULL)
    d <- .de_defaults(initial, defaults)

    frame <- if (!is.null(initial)) {
        r <- .de_resolve(initial)
        tryCatch(.de_heatmap_data(.se_stage(r$se, d$de.assay, d$de.transform), r$results, d), error = function(e) NULL)
    }
    heat_defaults <- if (is.null(frame)) {
        defaults[setdiff(names(defaults), .de_keys)]
    } else {
        .de_heat_defaults(frame, defaults)
    }

    .heatmap_wrapper_server(
        id, data, hide.inputs, hide.tabs, heat_defaults,
        stage = function(x, input, isolate_fn) {
            r <- .de_resolve(x)
            assay <- isolate_fn(input$de.assay)
            transform <- isolate_fn(input$de.transform)
            staged <- .se_stage(r$se, assay %||% d$de.assay, transform %||% d$de.transform)
            staged$results <- r$results
            staged
        },
        prepare = function(staged, input, isolate_fn) {
            .de_heatmap_data(staged, staged$results, .de_read_inputs(input, isolate_fn, d))
        },
        reset = function(session, x) {
            dd <- .de_defaults(x, defaults)
            for (k in c("de.id.col", "de.label.col", "de.padj.col", "de.lfc.col", "de.rank.by", "de.direction",
                "de.assay", "de.transform")) {
                update_viz_select(session, k, selected = dd[[k]])
            }
            for (k in c("de.padj.cutoff", "de.lfc.cutoff", "de.top.n")) updateNumericInput(session, k, value = dd[[k]])
        }
    )
}
