#' Server logic for the dittoHeatmap module
#'
#' Pulls the expression of the chosen genes with [dittoSeq::dittoHeatmap()]
#' and draws it with [VizModules::ComplexHeatmap_HeatmapServer()], ordering the
#' cells by the chosen metadata column (with column clustering off, as by
#' default).
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`,
#'   `SummarizedExperiment` or `Seurat` object.
#' @param hide.inputs A character vector of input IDs to hide. The wrapped
#'   module's `matrix.cols` and `rowname.col` are always hidden, since the module
#'   sets them.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values, typically the same list
#'   passed to [dittoHeatmapInputsUI()].
#' @return The source-data reactive of [VizModules::ComplexHeatmap_HeatmapServer()]:
#'   the matrix drawn (unscaled), the inputs, and SVG/PNG renderers.
#'
#' @import shiny
#'
#' @seealso [dittoSeq::dittoHeatmap()], [sciVizModules::dittoHeatmapInputsUI()],
#' [sciVizModules::dittoHeatmapOutputUI()], [sciVizModules::dittoHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) dittoHeatmapApp()
#' @export
#' @author Jared Andrews
dittoHeatmapServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    initial <- tryCatch(isolate(data()), error = function(e) NULL)
    d <- .dh_defaults(initial, defaults)

    frame <- if (!is.null(initial)) {
        tryCatch(.ditto_heatmap_data(initial, d$dh.genes, blank_to_null(d$dh.assay), d$dh.order.by),
            error = function(e) NULL)
    }
    heat_defaults <- if (is.null(frame)) {
        defaults[setdiff(names(defaults), .dh_keys)]
    } else {
        .dh_heat_defaults(frame, initial, d, defaults)
    }

    .heatmap_wrapper_server(
        id, data, hide.inputs, hide.tabs, heat_defaults,
        prepare = function(obj, input, isolate_fn) {
            genes <- isolate_fn(input$dh.genes)
            assay <- isolate_fn(input$dh.assay)
            order.by <- isolate_fn(input$dh.order.by)
            .ditto_heatmap_data(obj, genes %||% d$dh.genes, blank_to_null(assay %||% d$dh.assay),
                order.by %||% d$dh.order.by)
        },
        reset = function(session, obj) {
            dd <- .dh_defaults(obj, defaults)
            update_viz_select(session, "dh.genes", selected = dd$dh.genes)
            if (length(.ditto_assays(obj))) update_viz_select(session, "dh.assay", selected = dd$dh.assay)
            update_viz_select(session, "dh.order.by", selected = dd$dh.order.by)
        }
    )
}
