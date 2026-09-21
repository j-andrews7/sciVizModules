#' Server logic for maPlot module
#'
#' This module builds upon the [VizModules::dittoViz_scatterPlotServer()] to provide an MA plot
#' (log fold change versus mean abundance) with interactive significance and fold-change thresholding.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#'   Must contain a mean abundance (e.g., baseMean, logCPM, AveExpr), effect size
#'   (e.g., log2FoldChange, logFC), and significance (e.g., padj, FDR) columns.
#' @param hide.inputs A character vector of input IDs to hide. The continuous
#'   colour-scale and contour controls are always hidden, since an MA plot
#'   colours by the discrete `group` column.
#' @param hide.tabs A character vector of tab names to hide. Default hides:
#'   "Trajectory" and "Facet".
#' @param defaults A named list of default values. Merged over the module's
#'   MA defaults (user values win) and used to restore state on reset.
#'   Group colours are set with `color.up` / `color.down` / `color.ns`, or
#'   directly with a named `color.panel` vector.
#' @return The `moduleServer` function for the maPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [VizModules::dittoViz_scatterPlotServer()], [sciVizModules::maPlotInputsUI()],
#' [sciVizModules::maPlotOutputUI()], [sciVizModules::maPlotApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) maPlotApp()
#' @export
#' @author Jared Andrews
maPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facet"), defaults = NULL) {
    # MA defaults, shared with maPlotInputsUI so the initial state and the reset
    # state match. Computed once from a snapshot of the data.
    ma_defaults <- .ma_defaults(
        tryCatch(shiny::isolate(data()), error = function(e) data()),
        defaults
    )

    # Hand the wrapped scatter server only the keys it knows about, so its own
    # reset restores them. MA-only keys (sig.by, the thresholds) and multi-length
    # keys it does not read (hover.data) are reset separately in the observer
    # below. `color.panel` is the one non-scalar it does read.
    scatter_default_keys <- c(
        "x.by", "y.by", "color.by", "x.adj.fxn", "show.others", "color.panel"
    )
    scatter_defaults <- ma_defaults[intersect(scatter_default_keys, names(ma_defaults))]

    res <- moduleServer(id, function(input, output, session) {
        # Reactive data with group column based on thresholds
        data_reac <- reactive({
            req(data())

            isolate_fn <- setup_auto_update_logic(input)

            # Use isolate for threshold inputs so they don't trigger updates
            sig_thresh <- isolate_fn(input$sig.thresh)
            fc_thresh <- isolate_fn(input$fc.thresh)

            # x is mean abundance, y is the log fold change. The significance
            # column drives grouping but is not an axis, so read it directly.
            x_col <- isolate_fn(input$x.by)
            y_col <- isolate_fn(input$y.by)
            sig_col <- isolate_fn(input$sig.by)

            # Use !is.null() checks for threshold inputs since req(0) returns FALSE
            req(!is.null(sig_thresh), !is.null(fc_thresh), !is.null(x_col), !is.null(y_col), !is.null(sig_col))
            dat <- data()

            # Ensure the columns exist
            req(y_col %in% names(dat), x_col %in% names(dat), sig_col %in% names(dat))

            # Handle potential NA values in significance column
            dat[[sig_col]][is.na(dat[[sig_col]])] <- 1

            dat$group <- "n.s."
            # Fold change threshold logic - compare directly to fc.thresh since logFC is already log2 scale
            dat$group[dat[[sig_col]] < sig_thresh & dat[[y_col]] > fc_thresh] <- "Up"
            dat$group[dat[[sig_col]] < sig_thresh & dat[[y_col]] < -fc_thresh] <- "Down"

            # Ensure group is a factor for consistent coloring
            dat$group <- factor(dat$group, levels = c("n.s.", "Up", "Down"))
            dat
        })

        # Restore the MA-specific extra inputs when the module's reset button is
        # pressed. The wrapped scatter server resets its own inputs (using
        # ma_defaults, passed below); this handles the controls it does not know
        # about.
        observeEvent(input$reset, {
            update_viz_select(session, "sig.by",
                selected = VizModules::get_default(ma_defaults, "sig.by", ma_defaults$sig.by))
            updateNumericInput(session, "sig.thresh",
                value = VizModules::get_default(ma_defaults, "sig.thresh", 0.05))
            updateNumericInput(session, "fc.thresh",
                value = VizModules::get_default(ma_defaults, "fc.thresh", 0))
        })

        data_reac
    })

    # The group colours are the wrapped module's own "Color palette" picker,
    # seeded from scatter_defaults$color.panel, so they stay editable and reset
    # with everything else. The rest of its Colors tab describes a continuous
    # scale and contour lines, neither of which an MA plot uses.
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
