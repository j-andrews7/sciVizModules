#' Input UI components for the goFanPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `goFanPlotServer()` and
#' `goFanPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to
#' allow for more flexible UI design.
#'
#' This module wraps [GOfan::sunburstGO()] to draw a Gene Ontology (GO)
#' enrichment **sunburst** ("fan") plot: the GO directed acyclic graph is
#' converted into a circular layout where each ring is a hierarchy level and each
#' segment is a GO term. The figure is rendered with `plotBy = "plotly"` so it is
#' interactive (hover to read labels, click a segment to zoom into its
#' offspring).
#'
#' The input data are inspected to pick sensible defaults: the GO-ID column, the
#' ontology category (from a `ONTOLOGY` column when present), a numeric fill
#' column (preferring `qvalue`), and an optional proportional sub-rectangle
#' column (preferring `Count`).
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the
#' `defaults` argument:
#'
#' - `term.id` - GO identifier column (auto-detected)
#' - `onto` - GO ontology category: BP, CC, or MF (auto-detected)
#' - `org` - Organism annotation package (e.g. `org.Hs.eg.db`)
#' - `fill` - Numeric column mapped to segment colour (default `qvalue`)
#' - `sub_rect` - Optional numeric column drawn as a proportional
#'   sub-rectangle (default: none)
#' - `go.annotation.level.cutoff` - GO annotation level cutoff
#'   (default 4)
#' - `filter.nodes.by.edge.number` - Filter sub-graphs by edge number
#'   (default 2)
#' - `fill.na.by.0` - Fill missing colour values with 0 (default TRUE)
#'
#' @param id The ID for the Shiny module.
#' @param data The enrichment results data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [GOfan::sunburstGO()], [VizModules::organize_inputs()],
#' [sciVizModules::goFanPlotOutputUI()], [sciVizModules::goFanPlotServer()],
#' [sciVizModules::goFanPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_enrichment)
#' goFanPlotInputsUI("goFanPlot", example_enrichment)
goFanPlotInputsUI <- function(id, data, defaults = NULL, title = "GO Sunburst Settings", columns = 2) {
    ns <- NS(id)
    stopifnot(is.data.frame(data))

    if (is.null(defaults)) defaults <- list()

    id.choices <- names(data)[vapply(data, function(x) !is.numeric(x), logical(1))]
    if (length(id.choices) == 0) id.choices <- names(data)
    num.choices <- names(data)[vapply(data, is.numeric, logical(1))]
    subrect.choices <- c("None" = "", stats::setNames(num.choices, num.choices))

    detected.id <- .gofan_id_col(data)
    if (is.null(detected.id)) detected.id <- if (length(id.choices)) id.choices[1] else ""
    default.id <- get_default(defaults, "term.id", detected.id)

    default.onto <- get_default(defaults, "onto", .gofan_onto(data))

    detected.fill <- .detect_column(data, .enrichment_pval_candidates, numeric = TRUE)
    if (is.null(detected.fill)) detected.fill <- if (length(num.choices)) num.choices[1] else ""
    default.fill <- get_default(defaults, "fill", detected.fill)
    default.subrect <- get_default(defaults, "sub_rect", "")

    org.choices <- c(
        "Human (org.Hs.eg.db)" = "org.Hs.eg.db",
        "Mouse (org.Mm.eg.db)" = "org.Mm.eg.db",
        "Rat (org.Rn.eg.db)" = "org.Rn.eg.db",
        "Zebrafish (org.Dr.eg.db)" = "org.Dr.eg.db",
        "Fly (org.Dm.eg.db)" = "org.Dm.eg.db",
        "Worm (org.Ce.eg.db)" = "org.Ce.eg.db",
        "Yeast (org.Sc.sgd.db)" = "org.Sc.sgd.db"
    )
    default.org <- get_default(defaults, "org", "org.Hs.eg.db")

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("term.id"), "GO ID Column",
                choices = id.choices, selected = default.id, selectize = FALSE
            ), "Column holding the GO identifiers (e.g. GO:0006955).",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("onto"), "Ontology",
                choices = c("Biological Process" = "BP", "Cellular Component" = "CC",
                    "Molecular Function" = "MF"),
                selected = default.onto, selectize = FALSE
            ), "GO ontology category of the supplied IDs.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("org"), "Organism",
                choices = org.choices, selected = default.org, selectize = FALSE
            ), paste(
                "Organism annotation package used to resolve the GO hierarchy.",
                "The corresponding OrgDb package must be installed."
            ), placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("fill"), "Colour By",
                choices = num.choices, selected = default.fill, selectize = FALSE
            ), "Numeric column mapped onto the segment fill colour (e.g. qvalue).",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("palette"), "Palette",
                choices = .gofan_palettes,
                selected = get_default(defaults, "palette", "Viridis"), selectize = FALSE
            ), "Colour palette used to map the 'Colour By' column onto the segments.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("sub_rect"), "Sub-rectangle (area)",
                choices = subrect.choices, selected = default.subrect, selectize = FALSE
            ), paste(
                "Optional numeric column drawn as a proportional sub-rectangle",
                "inside each segment (a count is converted to a proportion)."
            ), placement = "top", options = list(container = "body"))
        ),
        "Filtering" = tagList(
            tipify(numericInput(ns("go.annotation.level.cutoff"), "GO Level Cutoff",
                value = get_default(defaults, "go.annotation.level.cutoff", 4),
                min = 1, step = 1),
                "Cutoff of the GO annotation levels to display.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("filter.nodes.by.edge.number"), "Min Edges per Sub-graph",
                value = get_default(defaults, "filter.nodes.by.edge.number", 2),
                min = 0, step = 1),
                "Filter the sub-graphs by their edge number.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("fill.na.by.0"), "Fill NA colours with 0",
                value = get_default(defaults, "fill.na.by.0", TRUE), status = "success"),
                "Replace missing values in the colour column with 0.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("goFanPlotTabsetPanel"),
        title = if (is.null(title)) {
            NULL
        } else if (inherits(title, "shiny.tag") || inherits(title, "shiny.tag.list")) {
            title
        } else {
            h3(title)
        },
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the goFanPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the sunburst plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#'
#' @examples
#' goFanPlotOutputUI("plot")
#' @export
#' @author Jacob Martin, Jared Andrews
goFanPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("goFanPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
