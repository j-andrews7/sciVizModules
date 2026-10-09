#' Input UI components for the dittoDotPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoDotPlotServer()` and
#' `dittoDotPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoDotPlot()], the standard marker figure: for
#' each gene (or numeric metadata) and group, a dot whose colour is the mean
#' expression of the cells expressing it and whose size is the fraction of cells
#' expressing it. The resulting `ggplot` is converted to an interactive `plotly`
#' figure. `ggplotly()` drops ggplot's size legend, so the dot-size legend is
#' redrawn with [VizModules::add_size_legend()], as the VizModules DotPlot
#' module draws its own: circles sized from the plotted dots, labelled with the
#' percentage of cells expressing.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [dittoSeq::dittoDotPlot()] parameters are not available via UI inputs:
#'
#' - `summary.fxn.size` - Always the fraction of cells with a non-zero value
#' - `min`, `max`, `mid` - Colour-scale limits are left to dittoSeq ("make")
#' - `legend.size.title` - The size legend is titled "percent expression", as dittoSeq titles it
#' - `main`, `sub`, `xlab`, `ylab`, `legend.color.title` - Plotly allows interactive editing
#' - `y.labels`, `y.reorder`, `x.labels.rotate` - Not exposed; tick angles are on the Axes tab
#' - `cells.use`, `adjustment`, `swap.rownames`, `slot`, `split.adjust`,
#'   `categories.*`, `groupings.drop.unused`, `do.hover`, `data.out` - Not exposed
#'
#' @section Plot parameters and defaults:
#' The following [dittoSeq::dittoDotPlot()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `vars` - Genes or numeric metadata, one dot column each (UI: "Genes / Variables",
#'   default: the first five genes)
#' - `group.by` - Discrete metadata giving the groups (UI: "Group By", default:
#'   the first discrete metadata column)
#' - `split.by` - Discrete metadata to facet by (UI: "Split By (facet)", default: none)
#' - `scale` - Z-score each variable's colour values across groups (UI: "Scale",
#'   default: TRUE)
#' - `vars.dir` - Direction of the variables, `"x"` or `"y"` (UI: "Variables Along",
#'   default: `"x"`)
#' - `assay` - Assay (UI: "Assay", default: dittoSeq's default, `logcounts` when present)
#' - `summary.fxn.color` - `"nonzero.mean"` (dittoSeq's default: mean of the
#'   cells expressing), `"mean"` or `"median"` (UI: "Colour Summary")
#' - `min.color`, `max.color` - Colour-scale ends (UI: "Low Color", "High Color";
#'   default: "grey90", "#C51B7D")
#' - `mid.color` - `""` for a two-colour scale, or a dittoSeq preset `"ryb"`,
#'   `"rgb"`, `"rwb"` (UI: "Mid Color", default: `""`)
#' - `size` - Largest dot size (UI: "Max Dot Size", default: 6)
#' - `min.percent`, `max.percent` - Fraction expressing at which dots are
#'   smallest and largest; groups below `min.percent` get no dot (UI: "Min
#'   Fraction", "Max Fraction"; default: 0.01, NA)
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality are also available:
#'
#' - `size.legend.x` - Size legend x position, in paper coordinates (UI: "Size
#'   Legend X Position", default: 1.04); values just above 1 sit right of the plot
#' - `size.legend.y` - Size legend y position (UI: "Size Legend Y Position",
#'   default: 0.35); lower it to clear the colour bar
#'
#' Hiding the legend (`legend.show`) hides the size legend too. The Legend,
#' Axes, Lines and Plotly tabs carry the shared VizModules inputs (see
#' [VizModules::uniform_axes_inputs_ui()] and siblings).
#'
#' @param id The ID for the Shiny module.
#' @param data A `SingleCellExperiment`, `Seurat`, or `SummarizedExperiment` object
#'   used to populate the input choices.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [dittoSeq::dittoDotPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoDotPlotOutputUI()], [sciVizModules::dittoDotPlotServer()],
#' [sciVizModules::dittoDotPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoDotPlotInputsUI("dotplot", example_sce)
dittoDotPlotInputsUI <- function(id, data, defaults = NULL, title = "dittoDotPlot Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")
    d <- .ddp_defaults(data, defaults)
    disc <- .ditto_discrete_metas(data)
    assays <- .ditto_assays(data)

    documentParameters <- get_documentation(
        package_name = "dittoSeq::dittoDotPlot", type = "param",
        selected = list("vars", "group.by", "split.by", "scale", "vars.dir", "size", "min.percent", "max.percent"),
        cap = TRUE
    )
    tip <- function(tag, text) .sci_tip(tag, text %||% "")

    inputs <- list(
        "Data" = tagList(
            tip(viz_select_input(ns("vars"), "Genes / Variables",
                choices = .ditto_continuous_choices(data, include.blank = FALSE), selected = d$vars, multiple = TRUE
            ), documentParameters$vars),
            tip(viz_select_input(ns("group.by"), "Group By",
                choices = stats::setNames(disc, disc), selected = d$group.by
            ), documentParameters$group.by),
            tip(viz_select_input(ns("split.by"), "Split By (facet)",
                choices = c("None" = "", stats::setNames(disc, disc)), selected = d$split.by
            ), documentParameters$split.by),
            tip(materialSwitch(ns("scale"), "Scale", value = isTRUE(d$scale), status = "success"),
                documentParameters$scale),
            tip(viz_select_input(ns("vars.dir"), "Variables Along",
                choices = c("X axis" = "x", "Y axis" = "y"), selected = d$vars.dir
            ), documentParameters$vars.dir),
            if (length(assays)) {
                .sci_tip(viz_select_input(ns("assay"), "Assay", choices = assays, selected = d$assay),
                    "The assay the expression values are taken from.")
            },
            .sci_tip(viz_select_input(ns("summary.fxn.color"), "Colour Summary",
                choices = c("Mean of expressing cells" = "nonzero.mean", "Mean" = "mean", "Median" = "median"),
                selected = d$summary.fxn.color
            ), "How each group's values are summarised for the dot colour.")
        ),
        "Aesthetics" = tagList(
            .sci_tip(colourInput(ns("min.color"), "Low Color", value = d$min.color),
                "Colour of the lowest summarised value."),
            .sci_tip(colourInput(ns("max.color"), "High Color", value = d$max.color),
                "Colour of the highest summarised value."),
            .sci_tip(viz_select_input(ns("mid.color"), "Mid Color",
                choices = c("None (two colours)" = "", "Red-yellow-blue" = "ryb", "Red-grey-blue" = "rgb",
                    "Red-white-blue" = "rwb"),
                selected = d$mid.color
            ), "A dittoSeq three-colour preset, centred on zero when scaled; it replaces the low and high colours."),
            tip(numericInput(ns("size"), "Max Dot Size", value = d$size, min = 0.5, step = 0.5),
                documentParameters$size),
            tip(numericInput(ns("min.percent"), "Min Fraction", value = d$min.percent, min = 0, max = 1, step = 0.01),
                documentParameters$min.percent),
            tip(numericInput(ns("max.percent"), "Max Fraction", value = d$max.percent, min = 0, max = 1, step = 0.05),
                documentParameters$max.percent)
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
        "Legend" = tagList(
            .sci_tip(numericInput(ns("size.legend.x"), "Size Legend X Position",
                value = d$size.legend.x, step = 0.02
            ), paste(
                "Horizontal position (paper coordinates) of the dot-size legend. Values just above 1 sit",
                "to the right of the plot; lower it to pull the legend inward on narrow plots."
            )),
            .sci_tip(numericInput(ns("size.legend.y"), "Size Legend Y Position",
                value = d$size.legend.y, step = 0.05
            ), "Vertical position (paper coordinates) of the dot-size legend. Lower it to clear the colour bar."),
            uniform_legend_inputs_ui(ns, defaults)
        ),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )
    inputs$Data <- do.call(tagList, Filter(Negate(is.null), inputs$Data))

    organize_inputs(
        inputs,
        id = ns("dittoDotPlotTabsetPanel"),
        title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the dittoDotPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @examples
#' dittoDotPlotOutputUI("dotplot")
#' @export
#' @author Jared Andrews
dittoDotPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoDotPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}


#' Default inputs for the dittoDotPlot module
#'
#' Shared by the UI and the Reset handler. User values win.
#'
#' @param object A dittoSeq-compatible object.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ddp_defaults
#' @keywords internal
.ddp_defaults <- function(object, defaults = NULL) {
    disc <- .ditto_discrete_metas(object)
    base <- list(
        vars = utils::head(.ditto_genes(object), 5),
        group.by = if (length(disc)) disc[1] else "",
        split.by = "",
        scale = TRUE,
        vars.dir = "x",
        assay = .ditto_default_assay(object),
        summary.fxn.color = "nonzero.mean",
        min.color = "grey90",
        max.color = "#C51B7D",
        mid.color = "",
        size = 6,
        min.percent = 0.01,
        max.percent = NA,
        size.legend.x = 1.04,
        size.legend.y = 0.35
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}


#' The dots the size legend describes
#'
#' The dots dittoDotPlot draws: those whose fraction of cells expressing lies
#' within `min.percent` and `max.percent` (ggplot2 drops the rest).
#'
#' @param dat The `data` element of `dittoDotPlot(data.out = TRUE)`.
#' @param min.percent,max.percent The size-scale limits (`max.percent` may be `NA`).
#' @return A data frame with a `percent` column (0-100), one row per drawn dot.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ddp_size_legend_data
#' @keywords internal
.ddp_size_legend_data <- function(dat, min.percent = 0.01, max.percent = NA) {
    f <- dat$size
    keep <- !is.na(f) & f >= min.percent & (is.na(max.percent) | f <= max.percent)
    data.frame(percent = 100 * f[keep])
}


#' Keep the dot plot's colour bar in the upper half of the legend area
#'
#' `ggplotly()` gives the colour bar the full plot height, where the size
#' legend (default `size.legend.y` 0.35) would overlap it.
#'
#' @param fig The `ggplotly()` figure.
#' @return The figure with its colour bar anchored at the top, half the height.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ddp_colorbar_top
#' @keywords internal
.ddp_colorbar_top <- function(fig) {
    for (i in seq_along(fig$x$data)) {
        cb <- fig$x$data[[i]]$marker$colorbar
        if (is.list(cb)) {
            fig$x$data[[i]]$marker$colorbar <- utils::modifyList(cb,
                list(len = 0.5, lenmode = "fraction", y = 1, yanchor = "top"))
        }
    }
    fig
}


#' The colour summary function for dittoDotPlot
#'
#' @param name `"nonzero.mean"`, `"mean"` or `"median"`.
#' @return A function of a numeric vector.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ddp_summary_fxn
#' @keywords internal
.ddp_summary_fxn <- function(name) {
    switch(name %||% "nonzero.mean",
        mean = function(x) mean(x),
        median = function(x) stats::median(x),
        function(x) mean(x[x != 0])
    )
}
