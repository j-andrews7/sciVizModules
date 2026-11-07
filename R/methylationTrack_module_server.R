#' Server logic for the methylationTrack module
#'
#' Renders [methylationTrack()]. The plotted beta values, with each CpG's position and
#' probes, and the samples in plotted order are included in the source-data download
#' as the statistics tables.
#'
#' @details A lookup runs only when what it depends on changes, so changing the strips,
#' the transcripts or the grouping redraws the figure without reading the arrays again.
#' A change to the colour scale, the empty-cell colours, the sample font size or the
#' Axes tab's lines needs no redraw at all.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing a [methylationCohort()], or anything it takes.
#' @param hide.inputs A character vector of input IDs to hide. The gridline inputs
#'   (`show.grid.x`, `show.grid.y`, `grid.color`) are always hidden.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [methylationTrackInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [methylationTrack()], [sciVizModules::methylationTrackInputsUI()],
#' [sciVizModules::methylationTrackOutputUI()], [sciVizModules::methylationTrackApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) methylationTrackApp()
#' @export
#' @author Jared Andrews
methylationTrackServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    given.colors <- defaults$anno.colors
    hidden <- union(hide.inputs, .meth_grid_inputs)
    .sci_plot_server(
        id, data, hidden, hide.tabs, .meth_axes_defaults(defaults),
        name = "methylationTrack",
        validate = .meth_as_cohort,
        setup = function(input, output, session, object, params) {
            .meth_lookup_toggle(input, session, hidden)
            .meth_filter_updates(input, session, object)
            .meth_state(input, output, session, object, params, given.colors)
        },
        build = function(cohort, input, isolate_fn, state) {
            q <- isolate_fn(state$region_data())
            cpg.labels <- isolate_fn(input$cpg.labels)
            group.by <- blank_to_null(isolate_fn(input$group.by))
            .meth_figure(
                q,
                # A column can outlive its cohort for a flush when the cohort changes.
                group.by = if (isTRUE(group.by %in% names(q$samples))) group.by,
                group.gap = na_to_null(isolate_fn(input$group.gap)) %||% 1,
                cluster.samples = isTRUE(isolate_fn(input$cluster.samples)),
                dist.method = isolate_fn(input$dist.method) %||% "euclidean",
                hclust.method = isolate_fn(input$hclust.method) %||% "ward.D2",
                show.dendrogram = !isFALSE(isolate_fn(input$show.dendrogram)),
                anno.left = intersect(isolate_fn(input$anno.left), names(q$samples)),
                anno.right = intersect(isolate_fn(input$anno.right), names(q$samples)),
                anno.colors = isolate_fn(state$palette_store()),
                anno.low = isolate_fn(input$anno.low) %||% .meth_colors$anno.low,
                anno.high = isolate_fn(input$anno.high) %||% .meth_colors$anno.high,
                show.sample.names = !isFALSE(isolate_fn(input$show.sample.names)),
                txn.view = isolate_fn(input$txn.view) %||% "full",
                txn.types = isolate_fn(input$txn.types),
                txn.labels = !isFALSE(isolate_fn(input$txn.labels)),
                txn.font.size = na_to_null(isolate_fn(input$txn.font.size)) %||% 8,
                exon.color = isolate_fn(input$exon.color) %||% .meth_colors$exon,
                cds.color = isolate_fn(input$cds.color) %||% .meth_colors$cds,
                intron.color = isolate_fn(input$intron.color) %||% .meth_colors$intron,
                show.cytoband = !isFALSE(isolate_fn(input$show.cytoband)),
                show.map.lines = !isFALSE(isolate_fn(input$show.map.lines)),
                show.coverage = !isFALSE(isolate_fn(input$show.coverage)),
                cpg.tracks = isolate_fn(input$cpg.tracks),
                cpg.labels = if (nz_value(cpg.labels)) cpg.labels else "none"
            )
        },
        style = function(fig, input, isolate_fn, state) {
            fig <- .meth_apply_scale(
                fig,
                colors = isolate_fn(input$colorscale.colors),
                min = isolate_fn(input$colorscale.min),
                mid = isolate_fn(input$colorscale.mid),
                max = isolate_fn(input$colorscale.max),
                reverse = isTRUE(isolate_fn(input$colorscale.reverse)),
                title = isolate_fn(input$colorbar.title),
                absent.color = isolate_fn(input$absent.color) %||% .meth_colors$absent,
                na.color = isolate_fn(input$na.color) %||% .meth_colors$na
            )
            .meth_apply_frame(
                fig,
                font.size = na_to_null(isolate_fn(input$sample.font.size)),
                showline = isolate_fn(input$axis.showline),
                mirror = isolate_fn(input$axis.mirror),
                linecolor = isolate_fn(input$axis.linecolor),
                linewidth = isolate_fn(input$axis.linewidth)
            )
        },
        reset = function(session, cohort, defaults, state) {
            d <- .meth_defaults(cohort, defaults)
            selects <- c(
                "locate.by", "gene", "cpg.scope", "filter.col", "filter.levels", "group.by", "dist.method",
                "hclust.method", "anno.left", "anno.right", "txn.view", "txn.types", "cpg.tracks", "cpg.labels"
            )
            for (k in selects) update_viz_select(session, k, selected = d[[k]])
            for (k in c("region", "sample.filter")) updateTextInput(session, k, value = d[[k]])
            updateTextAreaInput(session, "probes", value = d$probes)
            numbers <- c("upstream", "downstream", "max.cpgs", "group.gap", "sample.font.size", "txn.font.size")
            for (k in numbers) updateNumericInput(session, k, value = d[[k]])
            switches <- c(
                "cluster.samples", "show.dendrogram", "show.sample.names", "txn.labels", "show.cytoband",
                "show.map.lines", "show.coverage"
            )
            for (k in switches) updateMaterialSwitch(session, k, value = isTRUE(d[[k]]))
            colors <- c("anno.low", "anno.high", "exon.color", "cds.color", "intron.color", "absent.color", "na.color")
            for (k in colors) updateColourInput(session, k, value = d[[k]])
            reset_colorscale_inputs(session, defaults)
            reset_group_colors(session, "anno.colors", state$anno.defaults, state$palette_groups(), state$palette)
        }
    )
}


#' Show the lookup inputs that apply
#'
#' @param input,session The module's input and session.
#' @param hidden Inputs the app hides, which stay hidden.
#' @return An observer.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_server
#' @keywords internal
.meth_lookup_toggle <- function(input, session, hidden) {
    observeEvent(input$locate.by, {
        used <- .meth_lookup_inputs[[input$locate.by]]
        hide_input(session, setdiff(unique(unlist(.meth_lookup_inputs)), used))
        show_input(session, setdiff(used, hidden))
    })
}


#' Offer the levels of the column chosen to filter on
#'
#' Neither this nor the gene select is frozen around an update: a value that does not
#' change is never echoed back, which would hold the plot forever. Stale levels are
#' ignored where they are read, by [.meth_select_samples()].
#'
#' @param input,session The module's input and session.
#' @param object The reactive cohort.
#' @return An observer.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_server
#' @keywords internal
.meth_filter_updates <- function(input, session, object) {
    observeEvent(input$filter.col, {
        # An observer's error would end the session, so a bad object waits for the plot.
        cohort <- tryCatch(object(), error = function(e) NULL)
        req(cohort)
        update_viz_select(session, "filter.levels",
            choices = .meth_filter_levels(cohort$samples, input$filter.col), selected = character(0)
        )
    }, ignoreInit = TRUE)
}


#' The module's reactive state
#'
#' Each reactive here is a step between the inputs and the draw function. All are named
#' in the cache key, as `.sci_plot_server()` does for anything in `state`, and each
#' reads its inputs as the draw function does, so Auto Update and reactive defaults
#' reach them too.
#'
#' @param input,output,session The module's input, output and session.
#' @param object The reactive cohort.
#' @param params The store of reactive defaults.
#' @param given.colors The `anno.colors` in `defaults`, or `NULL`.
#' @return A list of `selected_samples`, `target`, `region_data`, `palette_groups`,
#'   `palette_store`, `anno.defaults` and `palette`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_state
#' @keywords internal
.meth_state <- function(input, output, session, object, params, given.colors = NULL) {
    region.text <- .sci_debounced_input(input, "region", params)
    probes.text <- .sci_debounced_input(input, "probes", params)
    filter.text <- .sci_debounced_input(input, "sample.filter", params)

    selected_samples <- reactive({
        isolate_fn <- setup_auto_update_logic(input, params)
        samples <- object()$samples
        keep <- .meth_select_samples(
            samples, isolate_fn(input$filter.col), isolate_fn(input$filter.levels), isolate_fn(filter.text())
        )
        samples$sample[keep]
    })
    output$sample.status <- renderText({
        samples <- object()$samples
        # One handler, for the reason .sci_rendered_figure() gives.
        tryCatch(
            .meth_sample_status(samples, samples$sample %in% selected_samples()),
            error = function(e) {
                if (inherits(e, "shiny.silent.error")) stop(e)
                conditionMessage(e)
            }
        )
    })

    target <- reactive({
        isolate_fn <- setup_auto_update_logic(input, params)
        locate.by <- isolate_fn(input$locate.by)
        # The inputs of a rendered UI arrive a flush after the first draw.
        req(locate.by, cancelOutput = TRUE)
        .meth_target(
            object(), locate.by, isolate_fn(input$gene), isolate_fn(region.text()), isolate_fn(probes.text()),
            isolate_fn(input$upstream), isolate_fn(input$downstream)
        )
    })

    region_data <- reactive({
        isolate_fn <- setup_auto_update_logic(input, params)
        scope <- isolate_fn(input$cpg.scope)
        .meth_query(
            object(), target(), selected_samples(), if (nz_value(scope)) scope else "all",
            na_to_null(isolate_fn(input$max.cpgs)) %||% 1000
        )
    })

    palette_groups <- reactive({
        isolate_fn <- setup_auto_update_logic(input, params)
        .meth_anno_groups(
            object(), c(isolate_fn(input$anno.left), isolate_fn(input$anno.right), isolate_fn(input$cpg.tracks))
        )
    })
    # A map over the whole cohort seeds the picker, so a strip added later brings
    # colours of its own rather than the palette's first few again.
    anno.defaults <- list(anno.colors = reactive({
        colors <- c(given.colors, .meth_level_colors(object()))
        colors[!duplicated(names(colors))]
    }))
    palette <- .meth_palette(40)
    palette_store <- setup_group_colors(input, "anno.colors", palette_groups, palette, anno.defaults, params)
    output$palette.selection <- .sci_palette_picker_ui(
        input, session, palette_groups, palette_store, palette, anno.defaults, "Annotation Colors", "anno.colors"
    )

    list(
        selected_samples = selected_samples, target = target, region_data = region_data,
        palette_groups = palette_groups, palette_store = palette_store, anno.defaults = anno.defaults,
        palette = palette
    )
}
