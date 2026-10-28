#' Server logic for survivalCurve module
#'
#' This module fits a Kaplan-Meier survival curve with [survival::survfit()] and
#' renders it as an interactive `plotly` figure via [survivalCurve()]. The
#' per-stratum summary (subjects, events, median survival, log-rank test) is
#' included in the source-data download as the statistics table
#' (`<name>_stats_strata.csv` while pairwise comparisons are on, beside the
#' comparison table, `<name>_stats_pairwise.csv`).
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Must contain a
#'   numeric follow-up time column and an event/status column. Values that are not
#'   data frames are coerced with [as.data.frame()]; a `NULL` value is treated as
#'   "not ready yet" and the module waits for data.
#' @param hide.inputs A character vector of input IDs to hide. These will still be
#'   initialized and their values passed to the plot function, but the user will
#'   not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs. Typically the same list passed to [survivalCurveInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [survival::survfit()], [sciVizModules::survivalCurve()],
#' [sciVizModules::survivalCurveInputsUI()], [sciVizModules::survivalCurveOutputUI()],
#' [sciVizModules::survivalCurveApp()]
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) survivalCurveApp()
#' @export
#' @author Jacob Martin, Jared Andrews
survivalCurveServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "survivalCurve",
        validate = .sci_require_df,
        setup = function(input, output, session, object, params) {
            # The strata that need colors depend on the grouping selection.
            palette_groups <- reactive({
                df <- object()
                group_col <- input$group.by
                if (!nz_value(group_col) || !group_col %in% names(df)) {
                    return("All")
                }
                grp <- .surv_levels(df[[group_col]])
                if (length(grp) == 0) "All" else grp
            })
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups, default_palette_values, defaults, params
            )
            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Curve Colors")

            # The band's and the comparisons' controls apply only while they are
            # on. What the app hid via hide.inputs is never shown again here.
            observeEvent(input$conf.int, {
                if (isTRUE(input$conf.int)) {
                    show_input(session, setdiff(.surv_band_inputs, hide.inputs))
                } else {
                    hide_input(session, .surv_band_inputs)
                }
            }, ignoreInit = FALSE)
            observeEvent(input$pairwise, {
                if (isTRUE(input$pairwise)) {
                    show_input(session, setdiff(.surv_pairwise_inputs, hide.inputs))
                } else {
                    hide_input(session, .surv_pairwise_inputs)
                }
            }, ignoreInit = FALSE)

            # The comparisons on offer follow the grouping. Frozen first, and
            # ahead of the plot, so the plot is not drawn for the old selection
            # and then again for the new one.
            pair_choices <- reactive({
                df <- object()
                group_col <- input$group.by
                .surv_pair_choices(if (nz_value(group_col) && group_col %in% names(df)) .surv_levels(df[[group_col]]))
            })
            observeEvent(pair_choices(), {
                choices <- pair_choices()
                freezeReactiveValue(input, "stat.pairs")
                update_viz_select(session, "stat.pairs", choices = choices,
                    selected = default_stat_pairs(defaults, choices))
            }, ignoreInit = TRUE, priority = 10)

            list(palette_groups = palette_groups, palette_store = palette_store, pair_choices = pair_choices)
        },
        build = function(df, input, isolate_fn, state) {
            time_col <- isolate_fn(input$time)
            status_col <- isolate_fn(input$status)
            req(time_col, status_col, time_col %in% names(df), status_col %in% names(df))

            fun <- isolate_fn(input$fun)
            break.time.by <- isolate_fn(input$break.time.by)
            if (length(break.time.by) != 1 || is.na(break.time.by)) break.time.by <- NULL
            conf.type <- isolate_fn(input$conf.type)
            if (!isTRUE(conf.type %in% .surv_conf_type_choices)) conf.type <- "log"
            pairwise <- isTRUE(isolate_fn(input$pairwise))
            # Read only while the comparisons are on, so their controls do not
            # redraw a plot that shows none.
            pairs <- if (pairwise) parse_pair_strings(isolate_fn(input$stat.pairs))
            p.adjust.method <- if (pairwise) isolate_fn(input$stat.p.adjust)

            fig <- survivalCurve(
                data = df,
                time = time_col,
                status = status_col,
                group.by = blank_to_null(isolate_fn(input$group.by)),
                conf.int = !isFALSE(isolate_fn(input$conf.int)),
                conf.level = isolate_fn(input$conf.level),
                conf.type = conf.type,
                conf.int.opacity = isolate_fn(input$conf.int.opacity) %||% 0.25,
                pval = isTRUE(isolate_fn(input$pval)),
                risk.table = isTRUE(isolate_fn(input$risk.table)),
                censor = isTRUE(isolate_fn(input$censor)),
                surv.median.line = isolate_fn(input$surv.median.line) %||% "none",
                fun = if (is.null(fun) || fun == "survival") NULL else fun,
                palette.selection = isolate_fn(state$palette_store()),
                line.size = isolate_fn(input$line.size) %||% 2,
                break.time.by = break.time.by,
                pairwise = pairwise,
                pairs = pairs,
                p.adjust.method = p.adjust.method %||% "holm"
            )
            # Two statistics tables, written to the source download as one CSV each.
            if (!is.null(attr(fig, "pairwise"))) {
                attr(fig, "table") <- list(strata = attr(fig, "table"), pairwise = attr(fig, "pairwise"))
            }
            fig
        },
        reset = function(session, df, defaults, state) {
            d <- .surv_defaults(df, defaults)
            for (k in c("time", "status", "group.by", "conf.type", "surv.median.line", "fun", "stat.p.adjust")) {
                update_viz_select(session, k, selected = d[[k]])
            }
            update_viz_select(session, "stat.pairs", selected = default_stat_pairs(defaults, state$pair_choices()))
            for (k in c("conf.int", "pval", "risk.table", "censor", "pairwise")) {
                updateMaterialSwitch(session, k, value = isTRUE(d[[k]]))
            }
            for (k in c("conf.int.opacity", "conf.level", "line.size", "break.time.by")) {
                updateNumericInput(session, k, value = d[[k]])
            }
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
