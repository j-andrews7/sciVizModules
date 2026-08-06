#' Input UI components for the oncoPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `oncoPlotServer()` and
#' `oncoPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to
#' allow for more flexible UI design.
#'
#' This module wraps [ComplexHeatmap::oncoPrint()] (via [oncoPlot()]) to draw a
#' mutation-landscape **oncoprint**: genes in rows, samples in columns, and
#' coloured tiles encoding the alteration(s) observed in each gene/sample pair.
#' The drawn oncoprint is made interactive with
#' [InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()], which adds a
#' zoomable sub-heatmap and a click-info panel (see [oncoPlotOutputUI()]).
#'
#' The incoming data are expected in **tidy (long)** form: one row per observed
#' alteration with a sample, gene, and alteration-type column. These columns are
#' auto-detected (see [.onco_sample_col()], [.onco_gene_col()], and
#' [.onco_alteration_col()]) to seed the default selections; the user can
#' override them.
#'
#' @section Plot parameters and defaults:
#' - `sample` - Sample column (auto-detected)
#' - `gene` - Gene column (auto-detected)
#' - `alteration` - Alteration-type column (auto-detected)
#' - `top.n` - Keep only the N most-altered genes (default: all)
#' - `remove.empty.columns` - Drop samples with no alterations
#'   (default `FALSE`)
#' - `remove.empty.rows` - Drop genes with no alterations (default `FALSE`)
#' - `show.column.names` - Show sample names (default `FALSE`)
#' - `show.pct` - Show per-gene alteration percentages (default `TRUE`)
#'
#' @section Aesthetics:
#' A dedicated **Aesthetics** tab exposes finer control over the plot's
#' appearance:
#'
#' - `alteration.colors` - A [VizModules::multiColorPicker()] with one row per
#'   alteration type, letting the user recolour each alteration (and the
#'   legend). The rows are kept in sync with the selected alteration column by
#'   [oncoPlotServer()]; user-chosen colours for still-present types are
#'   preserved when the column changes.
#' - `background.color` - Colour of empty (no-alteration) cells.
#' - `border` - Draw a thin border around every cell.
#' - `row.font.size` / `column.font.size` - Gene and sample label font sizes.
#'
#' @param id The ID for the Shiny module.
#' @param data The tidy mutation data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @importFrom VizModules organize_inputs get_default multiColorPicker default_palettes
#'   multiDynamicInput
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [ComplexHeatmap::oncoPrint()], [sciVizModules::oncoPlot()],
#' [sciVizModules::oncoPlotOutputUI()], [sciVizModules::oncoPlotServer()],
#' [sciVizModules::oncoPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_mutations)
#' oncoPlotInputsUI("oncoPlot", example_mutations)
oncoPlotInputsUI <- function(id, data, defaults = NULL, title = "Oncoplot Settings", columns = 2) {
    ns <- NS(id)
    stopifnot(is.data.frame(data))

    if (is.null(defaults)) defaults <- list()

    col.choices <- names(data)

    detected.sample <- .onco_sample_col(data)
    detected.gene <- .onco_gene_col(data, exclude = detected.sample)
    detected.alt <- .onco_alteration_col(
        data,
        exclude = c(detected.sample, detected.gene)
    )
    if (is.null(detected.sample)) detected.sample <- col.choices[1]
    if (is.null(detected.gene)) detected.gene <- col.choices[min(2, length(col.choices))]
    if (is.null(detected.alt)) detected.alt <- col.choices[min(3, length(col.choices))]

    default.sample <- get_default(defaults, "sample", detected.sample)
    default.gene <- get_default(defaults, "gene", detected.gene)
    default.alt <- get_default(defaults, "alteration", detected.alt)

    # Seed the per-alteration colour picker from the alteration types present in
    # the initial data. The server keeps these rows in sync if the user changes
    # the alteration column (see oncoPlotServer()).
    alt.types <- .onco_types_from_df(data, default.alt)
    if (!length(alt.types)) alt.types <- "alteration"
    default.colors <- get_default(defaults, "alteration.colors", .onco_default_colors(alt.types))

    # Annotation data sources (per-sample and per-gene), used to seed the
    # dynamic annotation adder's "Data" dropdown. Keys are "<space>:<id>".
    ann.sources <- .onco_annotation_sources(data, default.sample, default.gene, default.alt)
    ann.choices <- c(ann.sources$sample, ann.sources$gene)

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("sample"), "Sample Column",
                choices = col.choices, selected = default.sample, selectize = FALSE
            ), "Column identifying the sample / patient for each alteration.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("gene"), "Gene Column",
                choices = col.choices, selected = default.gene, selectize = FALSE
            ), "Column identifying the altered gene.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("alteration"), "Alteration Column",
                choices = col.choices, selected = default.alt, selectize = FALSE
            ), "Column giving the alteration type (e.g. MUT, AMP, HOMDEL).",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("top.n"), "Top N Genes",
                value = get_default(defaults, "top.n", NA), min = 1, step = 1
            ), "Keep only the N most-frequently-altered genes. Leave blank for all.",
                placement = "top", options = list(container = "body")),
            tipify(multiDynamicInput(
                ns("annotations"),
                label = "Annotation",
                row_spec = list(
                    side = list(type = "select", args = list(
                        label = "Side",
                        choices = c("top", "bottom", "left", "right")
                    )),
                    source = list(type = "select", args = list(
                        label = "Data", choices = ann.choices
                    )),
                    type = list(type = "select", args = list(
                        label = "Type",
                        choices = c("Bar", "Points", "Lines", "Simple")
                    )),
                    colour = list(type = "colour", args = list(
                        label = "Colour", value = "#4C78A8"
                    ))
                ),
                max_per_row = 4
            ), paste(
                "Add annotation tracks around the oncoprint from the extra",
                "columns in your data. Top/bottom tracks aggregate a column to",
                "one value per sample; left/right to one value per gene. A track",
                "whose data space does not match its side is skipped. Colour",
                "applies to numeric tracks; categorical data uses an automatic",
                "palette."
            ), placement = "top", options = list(container = "body"))
        ),
        "Display" = tagList(
            tipify(materialSwitch(ns("show.pct"), "Show Percentages",
                value = get_default(defaults, "show.pct", TRUE), status = "success"
            ), "Show the per-gene alteration percentage.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("show.column.names"), "Show Sample Names",
                value = get_default(defaults, "show.column.names", FALSE), status = "success"
            ), "Show sample names along the bottom axis.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("remove.empty.columns"), "Drop Empty Samples",
                value = get_default(defaults, "remove.empty.columns", FALSE), status = "success"
            ), "Remove samples with no alterations.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("remove.empty.rows"), "Drop Empty Genes",
                value = get_default(defaults, "remove.empty.rows", FALSE), status = "success"
            ), "Remove genes with no alterations.",
                placement = "top", options = list(container = "body")),
            tipify(textInput(ns("column.title"), "Plot Title",
                value = get_default(defaults, "column.title", "")
            ), "Optional title drawn above the oncoprint.",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            tipify(multiColorPicker(
                inputId = ns("alteration.colors"),
                label = "Alteration Colors",
                groups = alt.types,
                colors = default.colors,
                palette_options = default_palettes()[["choices"]],
                compact = TRUE
            ), "Assign a colour to each alteration type. Applies to the tiles and the legend.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("background.color"), "Empty-cell Colour",
                value = get_default(defaults, "background.color", "#CCCCCC")
            ), "Background colour of cells with no alteration.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("border"), "Cell Borders",
                value = get_default(defaults, "border", FALSE), status = "success"
            ), "Draw a thin border around every cell.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("row.font.size"), "Gene Font Size",
                value = get_default(defaults, "row.font.size", 12), min = 1, step = 1
            ), "Font size (points) of the gene (row) names and percentages.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("column.font.size"), "Sample Font Size",
                value = get_default(defaults, "column.font.size", 10), min = 1, step = 1
            ), "Font size (points) of the sample (column) names.",
                placement = "top", options = list(container = "body"))
        )
    )

    organize_inputs(
        inputs,
        id = ns("oncoPlotTabsetPanel"),
        title = if (is.null(title)) {
            NULL
        } else if (inherits(title, "shiny.tag") || inherits(title, "shiny.tag.list")) {
            title
        } else {
            h3(title)
        },
        columns = columns
    )
}


#' Output UI components for the oncoPlot module
#'
#' This should be placed in the UI where the plot should be shown. It lays out
#' the three [InteractiveComplexHeatmap] output panels: the original oncoprint,
#' a zoomable sub-heatmap, and a click-info panel.
#'
#' @param id The ID for the Shiny module.
#' @param width,height Pixel dimensions of the main oncoprint panel.
#'
#' @return A Shiny tagList containing the interactive oncoprint outputs.
#'
#' @import shiny
#' @importFrom InteractiveComplexHeatmap originalHeatmapOutput subHeatmapOutput
#'   HeatmapInfoOutput
#'
#' @examples
#' oncoPlotOutputUI("plot")
#' @export
#' @author Jacob Martin, Jared Andrews
oncoPlotOutputUI <- function(id, width = 600, height = 450) {
    ns <- NS(id)
    heatmap.id <- ns("ht")
    tagList(
        fluidRow(
            column(7, originalHeatmapOutput(heatmap.id, width = width, height = height)),
            column(5, subHeatmapOutput(heatmap.id))
        ),
        HeatmapInfoOutput(heatmap.id)
    )
}
