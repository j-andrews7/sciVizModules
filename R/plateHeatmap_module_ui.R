#' Input UI components for the plateHeatmap module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plateHeatmapServer()` and
#' `plateHeatmapOutputUI()` functions.
#'
#' @details The module draws [plateHeatmap()]: each assay plate in its physical
#' layout, raw or normalised (percent of control, percent inhibition, z, robust
#' z or B-score), with control wells outlined, the Z'-factor in each plate's
#' title and optional row and column means for spotting edge effects. The
#' per-plate quality statistics are in the source-data download. Columns are
#' detected from the usual names (`well`, `plate`, `signal` / `value`, `type` /
#' `control`). The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `well.col`, `value.col` - Well identifier and readout columns (default: detected)
#' - `plate.col`, `control.col` - Plate and control-label columns (default: detected, else none)
#' - `positive`, `negative` - Control labels in `control.col` (default: the values starting "pos" / "neg")
#' - `normalise` - `"raw"`, `"percent.control"`, `"percent.inhibition"`, `"zscore"`, `"robust.z"` or
#'   `"bscore"` (default: `"raw"`)
#' - `plate.format` - `"auto"`, `"96"`, `"384"`, `"1536"`, ... (default: `"auto"`)
#' - `marginals` - Row and column means beside each plate (default: FALSE)
#' - `show.controls` - Outline the control wells (default: TRUE)
#' - `ncols` - Plates per row (default: 2)
#' - `color.low`, `color.mid`, `color.high` - Colour scale (default: blue, white, red)
#' - `midpoint` - Value at the mid colour; empty for automatic (default: NA)
#' - `positive.color`, `negative.color` - Control outline colours
#'
#' The Axes and Plotly tabs carry the shared VizModules inputs. Gridlines mean
#' nothing over a plate, so `show.grid.x` and `show.grid.y` default to FALSE and
#' [plateHeatmapServer()] hides them and `grid.color`. A caller can still turn
#' them on through `defaults`.
#'
#' @param id The ID for the Shiny module.
#' @param data The plate data frame, one row per well.
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
#' @seealso [plateHeatmap()], [sciVizModules::plateHeatmapOutputUI()],
#' [sciVizModules::plateHeatmapServer()], [sciVizModules::plateHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' data(example_plate)
#' plateHeatmapInputsUI("plate", example_plate)
plateHeatmapInputsUI <- function(id, data, defaults = NULL, title = "Plate Settings", columns = 2) {
    ns <- NS(id)
    data <- as.data.frame(data)
    d <- .plate_defaults(data, defaults)
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    none <- c("None" = "", stats::setNames(names(data), names(data)))
    labels <- .plate_control_labels(data, d$control.col)

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("well.col"), "Well Column", choices = names(data), selected = d$well.col),
            "Well identifiers such as A01 or B7."),
        .sci_tip(viz_select_input(ns("value.col"), "Value Column", choices = num, selected = d$value.col),
            "The readout to map."),
        .sci_tip(viz_select_input(ns("plate.col"), "Plate Column", choices = none, selected = d$plate.col),
            "Plate identifier; each plate is drawn and normalised separately."),
        .sci_tip(viz_select_input(ns("control.col"), "Control Column", choices = none, selected = d$control.col),
            "Column labelling the control wells."),
        .sci_tip(viz_select_input(ns("positive"), "Positive Control", choices = c("None" = "", labels),
            selected = d$positive), "Label of the positive (e.g. fully inhibited) control wells."),
        .sci_tip(viz_select_input(ns("negative"), "Negative Control", choices = c("None" = "", labels),
            selected = d$negative), "Label of the negative (e.g. vehicle) control wells."),
        .sci_tip(viz_select_input(ns("normalise"), "Normalisation", choices = .plate_methods, selected = d$normalise),
            "Per plate. Z-scores are against the sample wells; the B-score removes row and column effects."),
        .sci_tip(viz_select_input(ns("plate.format"), "Plate Format",
            choices = c("Auto" = "auto", stats::setNames(names(.plate_formats), paste(names(.plate_formats), "well"))),
            selected = d$plate.format
        ), "Auto picks the smallest standard plate that holds every well."),
        .sci_tip(materialSwitch(ns("marginals"), "Row/Column Means", value = isTRUE(d$marginals),
            status = "success"), "Sample-well means per row and column, for spotting edge effects."),
        .sci_tip(materialSwitch(ns("show.controls"), "Outline Controls", value = isTRUE(d$show.controls),
            status = "success"), "Outline the positive and negative control wells.")
    )
    aes_tab <- tagList(
        .sci_tip(colourInput(ns("color.low"), "Low Color", value = d$color.low), "Colour of the lowest values."),
        .sci_tip(colourInput(ns("color.mid"), "Mid Color", value = d$color.mid), "Colour at the midpoint."),
        .sci_tip(colourInput(ns("color.high"), "High Color", value = d$color.high), "Colour of the highest values."),
        .sci_tip(numericInput(ns("midpoint"), "Midpoint", value = d$midpoint),
            "Value at the mid colour. Empty for 0 (z, B-score), 50 or 100 (percentages) or the median (raw)."),
        .sci_tip(colourInput(ns("positive.color"), "Positive Outline", value = d$positive.color),
            "Outline colour of the positive control wells."),
        .sci_tip(colourInput(ns("negative.color"), "Negative Outline", value = d$negative.color),
            "Outline colour of the negative control wells."),
        .sci_tip(numericInput(ns("ncols"), "Plates per Row", value = d$ncols, min = 1, step = 1),
            "How many plates to draw side by side.")
    )

    .sci_plot_inputs_ui(ns, "plateHeatmap", data_tab, aes_tab, .plate_axes_defaults(defaults), title, columns,
        lines = FALSE, legend = FALSE)
}


#' Output UI components for the plateHeatmap module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' plateHeatmapOutputUI("plate")
#' @export
#' @author Jared Andrews
plateHeatmapOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "plateHeatmap", resizable = resizable, height = "550px")
}


#' Plate normalisation choices
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_defaults
#' @keywords internal
.plate_methods <- c(
    "Raw" = "raw", "Percent of negative control" = "percent.control", "Percent inhibition" = "percent.inhibition",
    "Z-score" = "zscore", "Robust z (median/MAD)" = "robust.z", "B-score" = "bscore"
)


#' Default inputs for the plateHeatmap module
#'
#' @param data The plate data frame.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_defaults
#' @keywords internal
.plate_defaults <- function(data, defaults = NULL) {
    cols <- .plate_columns(as.data.frame(data))
    base <- list(
        well.col = cols$well,
        value.col = cols$value,
        plate.col = cols$plate,
        control.col = cols$control,
        positive = cols$positive,
        negative = cols$negative,
        normalise = "raw",
        plate.format = "auto",
        marginals = FALSE,
        show.controls = TRUE,
        ncols = 2,
        color.low = "#2166AC",
        color.mid = "#F7F7F7",
        color.high = "#B2182B",
        midpoint = NA,
        positive.color = "#E7298A",
        negative.color = "#000000"
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}


#' The plateHeatmap defaults for the shared Axes tab
#'
#' Gridlines drawn over the wells (and the row and column means) carry no
#' information, so they are off unless the caller asks for them, and their
#' inputs (`.plate_grid_inputs`) are hidden.
#'
#' @param defaults A named list of user defaults, or `NULL`.
#' @return `defaults` with `show.grid.x` and `show.grid.y` set to FALSE where
#'   the caller did not set them.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_defaults
#' @keywords internal
.plate_axes_defaults <- function(defaults) {
    utils::modifyList(list(show.grid.x = FALSE, show.grid.y = FALSE), defaults %||% list())
}

# The Axes tab inputs plateHeatmapServer() always hides.
.plate_grid_inputs <- c("show.grid.x", "show.grid.y", "grid.color")


#' The labels in a plate's control column
#'
#' @param data The plate data frame.
#' @param col The control column, or `""`.
#' @return The sorted unique labels.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_defaults
#' @keywords internal
.plate_control_labels <- function(data, col) {
    if (!nz_value(col) || !col %in% names(data)) return(character(0))
    sort(unique(as.character(data[[col]][!is.na(data[[col]])])))
}
