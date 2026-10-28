#' Input UI components for the rocCurve module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `rocCurveServer()` and `rocCurveOutputUI()`
#' functions.
#'
#' @details The module draws [rocCurve()]: ROC curves for one or more numeric
#' predictors of a binary outcome, with each AUC (and its DeLong 95% CI when
#' pROC is installed) in the legend and the Youden-optimal cut-off marked. The
#' inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `response` - Binary outcome column (default: the first two-valued column)
#' - `positive` - The case value of the outcome (default: its second value)
#' - `predictors` - Numeric predictor columns (default: up to three)
#' - `direction` - `"auto"`, `"<"` (cases higher) or `">"` (cases lower) (default: `"auto"`)
#' - `ci` - Show the DeLong confidence interval of each AUC (default: TRUE; needs pROC)
#' - `show.youden` - Mark the Youden-optimal cut-off (default: TRUE)
#' - `palette.colours` - Named predictor colours (multiColorPicker)
#'
#' The Legend, Axes, Lines and Plotly tabs carry the shared VizModules inputs.
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
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
#' @seealso [rocCurve()], [sciVizModules::rocCurveOutputUI()], [sciVizModules::rocCurveServer()],
#' [sciVizModules::rocCurveApp()]
#' @examples
#' library(sciVizModules)
#' data(example_biomarkers)
#' rocCurveInputsUI("roc", example_biomarkers)
rocCurveInputsUI <- function(id, data, defaults = NULL, title = "ROC Curve Settings", columns = 2) {
    ns <- NS(id)
    d <- .roc_defaults(data, defaults)
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    levels_now <- if (nzchar(d$response)) {
        x <- data[[d$response]]
        as.character(if (is.factor(x)) levels(droplevels(x)) else sort(unique(x[!is.na(x)])))
    } else {
        character(0)
    }

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("response"), "Outcome", choices = names(data), selected = d$response),
            "Binary outcome column."),
        .sci_tip(viz_select_input(ns("positive"), "Case Value", choices = levels_now, selected = d$positive),
            "The outcome value that counts as a case."),
        .sci_tip(viz_select_input(ns("predictors"), "Predictors", choices = num, selected = d$predictors,
            multiple = TRUE), "Numeric predictors; each gets a curve."),
        .sci_tip(viz_select_input(ns("direction"), "Direction",
            choices = c("Automatic" = "auto", "Cases higher" = "<", "Cases lower" = ">"), selected = d$direction
        ), "Whether cases have higher or lower predictor values. Automatic compares the group medians."),
        .sci_tip(materialSwitch(ns("ci"), "AUC Confidence Interval", value = isTRUE(d$ci), status = "success"),
            "Show the DeLong 95% confidence interval of each AUC (needs the pROC package)."),
        .sci_tip(materialSwitch(ns("show.youden"), "Youden Cut-off", value = isTRUE(d$show.youden),
            status = "success"), "Mark the cut-off maximising sensitivity + specificity - 1.")
    )
    aes_tab <- tagList(uiOutput(ns("palette.selection")))

    .sci_plot_inputs_ui(ns, "rocCurve", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the rocCurve module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' rocCurveOutputUI("roc")
#' @export
#' @author Jared Andrews
rocCurveOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "rocCurve", resizable = resizable, height = "500px")
}
