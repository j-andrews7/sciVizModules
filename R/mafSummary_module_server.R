#' Server logic for the mafSummary module
#'
#' Renders [mafSummary()]. The per-sample variant counts by classification are
#' included in the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a maftools `MAF` object or a data frame in
#'   MAF columns.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [mafSummaryInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [mafSummary()], [sciVizModules::mafSummaryInputsUI()], [sciVizModules::mafSummaryOutputUI()],
#' [sciVizModules::mafSummaryApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) mafSummaryApp()
#' @export
#' @author Jared Andrews
mafSummaryServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
    defaults <- .maf_color_defaults(defaults)

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "mafSummary",
        validate = .maf_validate,
        setup = function(input, output, session, object, params) {
            palette_groups <- reactive(.maf_vc_levels(object()))
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups, default_palette_values, defaults, params
            )
            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Variant Class Colors")
            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(m, input, isolate_fn, state) {
            panels <- isolate_fn(input$panels)
            top.n <- isolate_fn(input$top.n)
            if (!length(panels)) stop("Choose at least one panel.", call. = FALSE)
            mafSummary(
                m,
                panels = panels,
                top.n = na_to_null(top.n) %||% 10,
                colors = isolate_fn(state$palette_store()),
                show.median = !isFALSE(isolate_fn(input$show.median))
            )
        },
        reset = function(session, m, defaults, state) {
            d <- .mafsum_defaults(defaults)
            update_viz_select(session, "panels", selected = d$panels)
            updateNumericInput(session, "top.n", value = d$top.n)
            updateMaterialSwitch(session, "show.median", value = isTRUE(d$show.median))
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
