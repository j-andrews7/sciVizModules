#' Input UI components for the michaelisMenten module
#'
#' This should be placed in the UI where the inputs should be shown, with an
#' `id` that matches the `id` used in the `michaelisMentenServer()` and
#' `michaelisMentenOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to
#' allow for more flexible UI design. The module draws the observed points from
#' the plotting data and overlays a pre-computed fitted line (the `model` data
#' frame). When a `stats` object is supplied to the server, the estimated
#' Michaelis constant (K) and maximum velocity (Vmax) are annotated onto the
#' plotly figure.
#'
#' @param id The ID for the Shiny module.
#' @param data The plotting data frame used to populate the axis column choices.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jacob Martin
#' @seealso [sciVizModules::michaelisMentenPlot()],
#' [sciVizModules::michaelisMentenOutputUI()],
#' [sciVizModules::michaelisMentenServer()], [sciVizModules::michaelisMentenApp()]
#' @examples
#' library(sciVizModules)
#' michaelisMentenInputsUI("mm", mm)
michaelisMentenInputsUI <- function(id, data, defaults = NULL,
                                    title = "Michaelis-Menten Settings", columns = 2) {
    ns <- NS(id)
    stopifnot(is.data.frame(data))

    if (is.null(defaults)) defaults <- list()

    col.choices <- names(data)
    num.choices <- names(data)[vapply(data, is.numeric, logical(1))]
    if (length(num.choices) == 0) num.choices <- col.choices

    default.x <- get_default(defaults, "x", if ("S" %in% col.choices) "S" else num.choices[1])
    default.y <- get_default(defaults, "y", if ("v" %in% col.choices) "v" else num.choices[min(2, length(num.choices))])

    linetype.choices <- c(
        "Solid" = "solid", "Dashed" = "dashed", "Dotted" = "dotted",
        "Dot-dash" = "dotdash", "Long dash" = "longdash", "Two dash" = "twodash"
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x"), "X Column",
                choices = col.choices, selected = default.x, selectize = FALSE
            ), "Column plotted on the x-axis (substrate concentration).",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y"), "Y Column",
                choices = col.choices, selected = default.y, selectize = FALSE
            ), "Column plotted on the y-axis (velocity).",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("show_stats"), "Annotate K / Vmax",
                value = get_default(defaults, "show_stats", TRUE), status = "success"),
                "Annotate the estimated K and Vmax onto the plot (requires stats input).",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            tipify(materialSwitch(ns("jitter"), "Show points",
                value = get_default(defaults, "jitter", TRUE), status = "success"),
                "Show the observed points. When off, only the fitted line is drawn.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter_size"), "Point Size",
                value = get_default(defaults, "jitter_size", 1.5), min = 0, step = 0.5),
                "Size of the observed points.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("jitter_color"), "Point Colour",
                value = get_default(defaults, "jitter_color", "#000000")),
                "Colour of the observed points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter_alpha"), "Point Opacity",
                min = 0, max = 1,
                value = get_default(defaults, "jitter_alpha", 1.0), step = 0.05),
                "Opacity of the observed points.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("line_color"), "Line Colour",
                value = get_default(defaults, "line_color", "#FF0000")),
                "Colour of the fitted Michaelis-Menten curve.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("linetype"), "Line Type",
                choices = linetype.choices,
                selected = get_default(defaults, "linetype", "solid"), selectize = FALSE
            ), "Line style of the fitted curve.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("michaelisMentenTabsetPanel"),
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


#' Output UI components for the michaelisMenten module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the Michaelis-Menten plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
michaelisMentenOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("michaelisMentenPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
