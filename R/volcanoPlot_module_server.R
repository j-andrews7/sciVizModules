#' Server logic for volcanoPlot module
#'
#' This module builds upon the [VizModules::dittoViz_scatterPlotServer()] to provide a volcano plot
#' with interactive significance and fold-change thresholding.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#'   Must contain effect size (e.g., log2FoldChange) and significance (e.g., padj) columns.
#' @param hide.inputs A character vector of input IDs to hide. The continuous
#'   colour-scale and contour controls are always hidden, since a volcano plot
#'   colours by the discrete `group` column.
#' @param hide.tabs A character vector of tab names to hide. Default hides:
#'   "Trajectory" and "Facet".
#' @param defaults A named list of default values. Merged over the module's
#'   volcano defaults (user values win) and used to restore state on reset.
#'   Group colours are set with `color.up` / `color.down` / `color.ns`, or
#'   directly with a named `color.panel` vector.
#' @return The `moduleServer` function for the volcanoPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [VizModules::dittoViz_scatterPlotServer()], [sciVizModules::volcanoPlotInputsUI()],
#' [sciVizModules::volcanoPlotOutputUI()], [sciVizModules::volcanoPlotApp()]
#' 
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) volcanoPlotApp()
#' @export
#' @author Jacob Martin
volcanoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facet"), defaults = NULL) {
    # Volcano defaults, shared with volcanoPlotInputsUI so the initial state and
    # the reset state match. Computed once from a snapshot of the data.
    vol_defaults <- .volcano_defaults(
        tryCatch(shiny::isolate(data()), error = function(e) data()),
        defaults
    )

    # Hand the wrapped scatter server only the keys it knows about, so its own
    # reset restores them. Volcano-only keys (the thresholds) and multi-length
    # keys it does not read (hover.data) are reset separately in the observer
    # below. `color.panel` is the one non-scalar it does read.
    scatter_default_keys <- c(
        "x.by", "y.by", "color.by", "y.adj.fxn", "show.others", "color.panel"
    )
    scatter_defaults <- vol_defaults[intersect(scatter_default_keys, names(vol_defaults))]

    res <- moduleServer(id, function(input, output, session) {
        # Reactive data with group column based on thresholds
        data_reac <- reactive({
            req(data())
            
            isolate_fn <- setup_auto_update_logic(input)

            # Use isolate for threshold inputs so they don't trigger updates
            sig_thresh <- isolate_fn(input$sig.thresh)
            fc_thresh <- isolate_fn(input$fc.thresh)

            # Determine which columns to use for effect size (x) and significance (y)
            # We use the selected x and y inputs mostly likely, as those should be valid columns
            x_col <- isolate_fn(input$x.by)
            y_col <- isolate_fn(input$y.by)

            # Use !is.null() checks for threshold inputs since req(0) returns FALSE
            req(!is.null(sig_thresh), !is.null(fc_thresh), !is.null(x_col), !is.null(y_col))
            dat <- data()

            # Ensure the columns exist
            req(y_col %in% names(dat), x_col %in% names(dat))

            # Handle potential NA values in p-value column
            dat[[y_col]][is.na(dat[[y_col]])] <- 1

            dat$group <- "n.s."
            # Fold change threshold logic - compare directly to fc.thresh since log2FoldChange is already log2 scale
            # Using abs() comparison handles both up/down in one check, then assign direction
            dat$group[dat[[y_col]] < sig_thresh & dat[[x_col]] > fc_thresh] <- "Up"
            dat$group[dat[[y_col]] < sig_thresh & dat[[x_col]] < -fc_thresh] <- "Down"

            # Ensure group is a factor for consistent coloring
            dat$group <- factor(dat$group, levels = c("n.s.", "Up", "Down"))
            dat
        })

        # Restore the volcano-specific extra inputs when the module's reset
        # button is pressed. The wrapped scatter server resets its own inputs
        # (using vol_defaults, passed below); this handles the controls it does
        # not know about.
        observeEvent(input$reset, {
            updateNumericInput(session, "sig.thresh",
                value = VizModules::get_default(vol_defaults, "sig.thresh", 0.05))
            updateNumericInput(session, "fc.thresh",
                value = VizModules::get_default(vol_defaults, "fc.thresh", 0))
        })

        data_reac
    })

    # The group colours are the wrapped module's own "Color palette" picker,
    # seeded from scatter_defaults$color.panel, so they stay editable and reset
    # with everything else. The rest of its Colors tab describes a continuous
    # scale and contour lines, neither of which a volcano plot uses.
    hide.inputs <- c(
        hide.inputs,
        "custom.models", "custom.model.enable",
        "min.color", "max.color", "contour.color", "contour.linetype"
    )

    dittoViz_scatterPlotServer(
        id = id,
        data = res,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = scatter_defaults
    )
}
