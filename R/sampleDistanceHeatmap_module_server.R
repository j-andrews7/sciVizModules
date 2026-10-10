#' Server logic for the sampleDistanceHeatmap module
#'
#' Transforms the assay of a `SummarizedExperiment`, computes the distances
#' (or correlations) between samples over its most variable genes, orders the
#' samples by clustering those distances, and draws the result with
#' [VizModules::ComplexHeatmap_HeatmapServer()]. The transformation is kept in
#' its own step, so changing the measure or the gene count does not repeat it.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SummarizedExperiment` of counts.
#' @param hide.inputs A character vector of input IDs to hide. The wrapped
#'   module's `matrix.cols` and `rowname.col` are always hidden, since the module
#'   sets them.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values, typically the same list
#'   passed to [sampleDistanceHeatmapInputsUI()].
#' @return The source-data reactive of [VizModules::ComplexHeatmap_HeatmapServer()]:
#'   the matrix drawn, the inputs, and SVG/PNG renderers.
#'
#' @import shiny
#'
#' @seealso [sciVizModules::sampleDistanceHeatmapInputsUI()],
#' [sciVizModules::sampleDistanceHeatmapOutputUI()], [sciVizModules::sampleDistanceHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) sampleDistanceHeatmapApp()
#' @export
#' @author Jared Andrews
sampleDistanceHeatmapServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    initial <- tryCatch(isolate(data()), error = function(e) NULL)
    if (!methods::is(initial, "SummarizedExperiment")) initial <- NULL
    d <- .sd_defaults(initial, defaults)

    frame <- if (!is.null(initial)) {
        tryCatch(.sample_distance_data(.se_stage(initial, d$sd.assay, d$sd.transform), d$sd.ntop, d$sd.method,
            d$sd.order), error = function(e) NULL)
    }
    heat_defaults <- if (is.null(frame)) {
        c(defaults[setdiff(names(defaults), .sd_keys)], .sd_style(d$sd.method))
    } else {
        .sd_heat_defaults(frame, d, defaults)
    }

    .heatmap_wrapper_server(
        id, data, hide.inputs, hide.tabs, heat_defaults,
        stage = function(se, input, isolate_fn) {
            .assert_se(se)
            assay <- isolate_fn(input$sd.assay)
            transform <- isolate_fn(input$sd.transform)
            .se_stage(se, assay %||% d$sd.assay, transform %||% d$sd.transform)
        },
        prepare = function(staged, input, isolate_fn) {
            ntop <- isolate_fn(input$sd.ntop)
            method <- isolate_fn(input$sd.method)
            order <- isolate_fn(input$sd.order)
            .sample_distance_data(staged, na_to_null(ntop) %||% d$sd.ntop, method %||% d$sd.method,
                order %||% d$sd.order)
        },
        # The legend title and colour ramp follow the measure: a distance is dark
        # where samples are close, a correlation where they are similar.
        reactive.defaults = function(input, prepared) {
            style <- reactive(.sd_style(input$sd.method %||% d$sd.method))
            list(
                name = reactive(style()$name),
                low_color = reactive(style()$low_color),
                mid_color = reactive(style()$mid_color),
                high_color = reactive(style()$high_color)
            )
        },
        reset = function(session, se) {
            dd <- .sd_defaults(se, defaults)
            for (k in c("sd.assay", "sd.transform", "sd.method", "sd.order")) {
                update_viz_select(session, k, selected = dd[[k]])
            }
            updateNumericInput(session, "sd.ntop", value = dd$sd.ntop)
        }
    )
}
