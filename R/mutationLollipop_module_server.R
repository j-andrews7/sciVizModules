#' Server logic for the mutationLollipop module
#'
#' Renders [mutationLollipop()]. The plotted counts (one row per position,
#' protein change and class) are included in the source-data download as the
#' statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a maftools `MAF` object or a data frame in
#'   MAF columns.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [mutationLollipopInputsUI()].
#' @param domains Optional domain table used in place of maftools' (see
#'   [mutationLollipop()]): a data frame with `gene`, `start`, `end` and `label`
#'   columns, or a `reactive` returning one. Rows for the drawn gene are used.
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [mutationLollipop()], [sciVizModules::mutationLollipopInputsUI()],
#' [sciVizModules::mutationLollipopOutputUI()], [sciVizModules::mutationLollipopApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) mutationLollipopApp()
#' @export
#' @author Jared Andrews
mutationLollipopServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL,
                                   domains = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
    defaults <- .maf_color_defaults(defaults)

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "mutationLollipop",
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
            gene <- isolate_fn(input$gene)
            label.top <- isolate_fn(input$label.top)
            point.size <- isolate_fn(input$point.size)
            dom <- if (is.reactive(domains)) domains() else domains
            if (!is.null(dom)) {
                dom <- as.data.frame(dom)
                gcol <- names(dom)[tolower(names(dom)) %in% c("gene", "hugo_symbol", "hgnc")][1]
                if (!is.na(gcol)) dom <- dom[dom[[gcol]] %in% gene, , drop = FALSE]
                if (!nrow(dom)) dom <- NULL
            }
            mutationLollipop(
                m,
                gene = blank_to_null(gene),
                domains = dom,
                colors = isolate_fn(state$palette_store()),
                label.top = na_to_null(label.top) %||% 3,
                point.size = na_to_null(point.size) %||% 10,
                show.domains = !isFALSE(isolate_fn(input$show.domains))
            )
        },
        reset = function(session, m, defaults, state) {
            d <- .lollipop_defaults(m, defaults)
            update_viz_select(session, "gene", selected = d$gene)
            updateNumericInput(session, "label.top", value = d$label.top)
            updateNumericInput(session, "point.size", value = d$point.size)
            updateMaterialSwitch(session, "show.domains", value = isTRUE(d$show.domains))
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
