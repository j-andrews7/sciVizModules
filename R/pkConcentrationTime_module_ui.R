#' Input UI components for the pkConcentrationTime module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `pkConcentrationTimeServer()` and
#' `pkConcentrationTimeOutputUI()` functions.
#'
#' @details The module draws [pkConcentrationTime()]: concentration-time
#' profiles per subject or as group means with an interval, linear or log, with each
#' subject's non-compartmental parameters (Cmax, Tmax, AUC, half-life, CL/F,
#' Vz/F) in the source-data download. Columns are detected from the usual names
#' (`Subject` / `ID`, `Time` / `TAD`, `conc` / `DV`, `Dose` / `AMT`). The
#' inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `subject.col`, `time.col`, `conc.col` - Columns (default: detected)
#' - `group.col`, `dose.col` - Optional treatment group and dose columns (default: detected, else none)
#' - `mode` - `"individual"` or `"mean"` (UI: "Display", default: `"individual"`)
#' - `error.bar` - Draw the group-mean interval as error bars (UI: "Error Bars", default: TRUE; mean mode)
#' - `error.ribbon` - Draw the interval as a shaded band in each group's colour (UI: "Error Ribbon",
#'   default: FALSE; mean mode)
#' - `error.bar.type` - The interval: `"sd"`, `"sem"` or `"ci95"` (UI: "Error Type", default: `"sd"`;
#'   `error.type` in [pkConcentrationTime()]; mean mode)
#' - `error.bar.ci.method` - How a 95% CI is computed: `"t"` or `"normal"` (UI: "Confidence Interval Method",
#'   default: `"t"`; `error.ci.method` in [pkConcentrationTime()]; shown while the error type is `"ci95"`)
#' - `error.ribbon.opacity` - Band fill opacity, 0 to 1 (UI: "Ribbon Opacity", default: 0.25; mean mode)
#' - `log.y` - Log concentration axis (default: TRUE)
#' - `show.lambda` - Draw the terminal elimination fits (default: FALSE)
#' - `auc.method` - `"lin up/log down"` or `"linear"` (default: `"lin up/log down"`)
#' - `palette.colours` - Named subject or group colours (multiColorPicker)
#'
#' The Legend, Axes, Lines and Plotly tabs carry the shared VizModules inputs.
#'
#' @param id The ID for the Shiny module.
#' @param data The concentration-time data frame.
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
#' @seealso [pkConcentrationTime()], [sciVizModules::pkConcentrationTimeOutputUI()],
#' [sciVizModules::pkConcentrationTimeServer()], [sciVizModules::pkConcentrationTimeApp()]
#' @examples
#' library(sciVizModules)
#' pkConcentrationTimeInputsUI("pk", datasets::Theoph)
pkConcentrationTimeInputsUI <- function(id, data, defaults = NULL, title = "PK Settings", columns = 2) {
    ns <- NS(id)
    data <- as.data.frame(data)
    d <- .pk_defaults(data, defaults)
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    # Dose groups are often numeric; columns with too many levels to average over are left out.
    groups <- .sci_discrete_cols(data, numeric = TRUE)
    none <- c("None" = "", stats::setNames(groups, groups))

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("subject.col"), "Subject Column", choices = names(data), selected = d$subject.col),
            "Column identifying each subject."),
        .sci_tip(viz_select_input(ns("time.col"), "Time Column", choices = num, selected = d$time.col),
            "Sampling time after dose."),
        .sci_tip(viz_select_input(ns("conc.col"), "Concentration Column", choices = num, selected = d$conc.col),
            "Measured concentration."),
        .sci_tip(viz_select_input(ns("group.col"), "Group Column", choices = none, selected = d$group.col),
            "Optional treatment group, averaged separately in mean mode."),
        .sci_tip(viz_select_input(ns("dose.col"), "Dose Column", choices = c("None" = "", stats::setNames(num, num)),
            selected = d$dose.col), "Optional dose, for CL/F and Vz/F."),
        .sci_tip(viz_select_input(ns("mode"), "Display",
            choices = c("Individual subjects" = "individual", "Group mean" = "mean"), selected = d$mode
        ), "A line per subject, or each group's mean and its interval at each nominal sampling time."),
        .sci_tip(materialSwitch(ns("error.bar"), "Error Bars", value = isTRUE(d$error.bar), status = "success"),
            "Draw each mean's interval as error bars."),
        .sci_tip(materialSwitch(ns("error.ribbon"), "Error Ribbon", value = isTRUE(d$error.ribbon), status = "success"),
            "Draw the interval as a shaded band behind each group's line, in its colour."),
        .sci_tip(viz_select_input(ns("error.bar.type"), "Error Type",
            choices = .pk_error_type_choices, selected = d$error.bar.type
        ), "What the interval around each mean shows. A time with a single sample has none."),
        .sci_tip(viz_select_input(ns("error.bar.ci.method"), "Confidence Interval Method",
            choices = .pk_ci_method_choices, selected = d$error.bar.ci.method
        ), "The t interval is wider for the small groups typical of a PK study; the normal one uses 1.96 SEM."),
        .sci_tip(materialSwitch(ns("log.y"), "Log Scale", value = isTRUE(d$log.y), status = "success"),
            "Log concentration axis, on which the terminal phase is a straight line."),
        .sci_tip(materialSwitch(ns("show.lambda"), "Terminal Fits", value = isTRUE(d$show.lambda), status = "success"),
            "Draw each subject's terminal elimination fit (individual mode)."),
        .sci_tip(viz_select_input(ns("auc.method"), "AUC Method",
            choices = c("Linear up / log down" = "lin up/log down", "Linear" = "linear"), selected = d$auc.method
        ), "Trapezoid rule for the AUC.")
    )
    aes_tab <- tagList(
        uiOutput(ns("palette.selection")),
        .sci_tip(numericInput(ns("error.ribbon.opacity"), "Ribbon Opacity",
            value = d$error.ribbon.opacity, min = 0, max = 1, step = 0.05
        ), "Fill opacity of the error ribbon.")
    )

    .sci_plot_inputs_ui(ns, "pkConcentrationTime", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the pkConcentrationTime module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' pkConcentrationTimeOutputUI("pk")
#' @export
#' @author Jared Andrews
pkConcentrationTimeOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "pkConcentrationTime", resizable = resizable, height = "500px")
}


#' Default inputs for the pkConcentrationTime module
#'
#' @param data The concentration-time data frame.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pk_defaults
#' @keywords internal
.pk_defaults <- function(data, defaults = NULL) {
    cols <- .pk_columns(as.data.frame(data))
    base <- list(
        subject.col = cols$subject,
        time.col = cols$time,
        conc.col = cols$conc,
        group.col = cols$group,
        dose.col = cols$dose,
        mode = "individual",
        log.y = TRUE,
        show.lambda = FALSE,
        auc.method = "lin up/log down",
        error.bar = TRUE,
        error.ribbon = FALSE,
        error.bar.type = "sd",
        error.bar.ci.method = "t",
        error.ribbon.opacity = 0.25
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}
