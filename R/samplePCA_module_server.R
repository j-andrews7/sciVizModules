#' Server logic for the samplePCA module
#'
#' Transforms the assay of a `SummarizedExperiment`, keeps its most variable
#' genes, runs the PCA ([sample_pca()]) and draws the sample scores through
#' [pcaBiplotServer()]. The transformation is kept in its own step, so changing
#' the gene count or the centring does not repeat it.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SummarizedExperiment` of counts.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide. Default hides the
#'   scatter module's "Trajectory" tab.
#' @param defaults A named list of default values, typically the same list
#'   passed to [samplePCAInputsUI()].
#' @return The value returned by [pcaBiplotServer()].
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [sample_pca()], [sciVizModules::samplePCAInputsUI()], [sciVizModules::samplePCAOutputUI()],
#' [sciVizModules::samplePCAApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) samplePCAApp()
#' @export
#' @author Jared Andrews
samplePCAServer <- function(id, data, hide.inputs = NULL, hide.tabs = "Trajectory", defaults = NULL) {
    stopifnot(is.reactive(data))
    initial <- tryCatch(isolate(data()), error = function(e) NULL)
    if (!methods::is(initial, "SummarizedExperiment")) initial <- NULL
    d <- .spca_defaults(initial, defaults)

    prepared <- moduleServer(id, function(input, output, session) {
        observeEvent(input$reset, {
            dd <- .spca_defaults(data(), defaults)
            for (k in c("pca.assay", "pca.transform", "pca.labels")) update_viz_select(session, k, selected = dd[[k]])
            updateNumericInput(session, "pca.ntop", value = dd$pca.ntop)
            updateMaterialSwitch(session, "pca.center", value = isTRUE(dd$pca.center))
            updateMaterialSwitch(session, "pca.scale", value = isTRUE(dd$pca.scale))
        })

        transformed <- reactive({
            se <- data()
            req(se)
            isolate_fn <- setup_auto_update_logic(input)
            assay <- isolate_fn(input$pca.assay)
            transform <- isolate_fn(input$pca.transform)
            .sci_soft_errors({
                .assert_se(se)
                .se_transform(se, blank_to_null(assay %||% d$pca.assay), transform %||% d$pca.transform)
            })
        })

        reactive({
            mat <- transformed()
            isolate_fn <- setup_auto_update_logic(input)
            vals <- .sci_fill_inputs(list(
                pca.ntop = isolate_fn(input$pca.ntop),
                pca.center = isolate_fn(input$pca.center),
                pca.scale = isolate_fn(input$pca.scale),
                pca.labels = isolate_fn(input$pca.labels)
            ), d)
            .sci_soft_errors(.spca_build(data(), mat, vals))
        })
    })

    pcaBiplotServer(
        id = id,
        data = prepared,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = .spca_biplot_defaults(initial, defaults)
    )
}
