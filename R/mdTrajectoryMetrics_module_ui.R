#' Input UI components for the mdTrajectoryMetrics module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `mdTrajectoryMetricsServer()` and
#' `mdTrajectoryMetricsOutputUI()` functions.
#'
#' @details The module draws [mdTrajectoryMetrics()]: molecular dynamics
#' summaries such as RMSD, radius of gyration or RMSF, one line per replica or
#' series, with optional smoothing and one panel per metric. It takes the long
#' data frame [read_xvg()] returns (GROMACS `.xvg`), several of which can be
#' combined with [rbind()], or any table with an x, a value and a grouping
#' column. The inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x.col`, `y.col` - x and value columns (default: `x`, `value` from [read_xvg()])
#' - `group.col` - One line per level (default: `series`)
#' - `facet.col` - One panel per level (default: `metric` when there is more than one)
#' - `smooth.window` - Running-mean width in points (default: 0, none)
#' - `time.unit` - `"as is"`, `"ps to ns"`, `"ns to ps"` (default: `"as is"`)
#' - `length.unit` - `"as is"`, `"nm to A"`, `"A to nm"` (default: `"as is"`)
#' - `show.raw` - Draw the raw trace under the smoothed one (default: TRUE)
#' - `raw.opacity` - Raw trace opacity when smoothing (default: 0.3)
#' - `palette.colours` - Named group colours (multiColorPicker)
#'
#' The Legend, Axes, Lines and Plotly tabs carry the shared VizModules inputs.
#'
#' @param id The ID for the Shiny module.
#' @param data A data frame, e.g. from [read_xvg()].
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jared Andrews
#' @seealso [mdTrajectoryMetrics()], [read_xvg()], [sciVizModules::mdTrajectoryMetricsOutputUI()],
#' [sciVizModules::mdTrajectoryMetricsServer()], [sciVizModules::mdTrajectoryMetricsApp()]
#' @examples
#' library(sciVizModules)
#' rmsd <- read_xvg(system.file("extdata", "example_rmsd_rep1.xvg.gz", package = "sciVizModules"))
#' mdTrajectoryMetricsInputsUI("md", rmsd)
mdTrajectoryMetricsInputsUI <- function(id, data, defaults = NULL, title = "MD Trajectory Settings", columns = 2) {
    ns <- NS(id)
    d <- .md_defaults(data, defaults)
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    cat_cols <- names(data)[!vapply(data, is.numeric, logical(1))]
    none <- c("None" = "", stats::setNames(cat_cols, cat_cols))

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("x.col"), "X Column", choices = num, selected = d$x.col),
            "Time, frame or residue column."),
        .sci_tip(viz_select_input(ns("y.col"), "Value Column", choices = num, selected = d$y.col),
            "The metric's values."),
        .sci_tip(viz_select_input(ns("group.col"), "Group By", choices = none, selected = d$group.col),
            "One line per level, e.g. replica."),
        .sci_tip(viz_select_input(ns("facet.col"), "Panel By", choices = none, selected = d$facet.col),
            "One stacked panel per level, e.g. metric."),
        .sci_tip(numericInput(ns("smooth.window"), "Smoothing Window", value = d$smooth.window, min = 0, step = 1),
            "Width, in points, of the centred running mean; 0 for none."),
        .sci_tip(viz_select_input(ns("time.unit"), "Time Units",
            choices = c("As is" = "as is", "ps to ns" = "ps to ns", "ns to ps" = "ns to ps"), selected = d$time.unit
        ), "Convert the x values when their label is in that unit."),
        .sci_tip(viz_select_input(ns("length.unit"), "Length Units",
            choices = c("As is" = "as is", "nm to Angstrom" = "nm to A", "Angstrom to nm" = "A to nm"),
            selected = d$length.unit
        ), "Convert the values when their label is in that unit.")
    )
    aes_tab <- tagList(
        uiOutput(ns("palette.selection")),
        .sci_tip(materialSwitch(ns("show.raw"), "Raw Trace", value = isTRUE(d$show.raw), status = "success"),
            "Draw the raw values under the smoothed line."),
        .sci_tip(numericInput(ns("raw.opacity"), "Raw Trace Opacity", value = d$raw.opacity, min = 0.05, max = 1,
            step = 0.05), "Opacity of the raw trace while smoothing.")
    )

    .sci_plot_inputs_ui(ns, "mdTrajectoryMetrics", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the mdTrajectoryMetrics module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' mdTrajectoryMetricsOutputUI("md")
#' @export
#' @author Jared Andrews
mdTrajectoryMetricsOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "mdTrajectoryMetrics", resizable = resizable, height = "550px")
}


#' Default inputs for the mdTrajectoryMetrics module
#'
#' Picks the [read_xvg()] columns when present, otherwise the first two numeric
#' columns, and panels by `metric` only when there is more than one.
#'
#' @param data The data frame.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_md_defaults
#' @keywords internal
.md_defaults <- function(data, defaults = NULL) {
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    pick <- function(pref, fallback) if (pref %in% names(data)) pref else fallback
    base <- list(
        x.col = pick("x", num[1] %||% ""),
        y.col = pick("value", num[2] %||% num[1] %||% ""),
        group.col = pick("series", ""),
        facet.col = if ("metric" %in% names(data) && length(unique(data$metric)) > 1) "metric" else "",
        smooth.window = 0,
        time.unit = "as is",
        length.unit = "as is",
        show.raw = TRUE,
        raw.opacity = 0.3
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}
