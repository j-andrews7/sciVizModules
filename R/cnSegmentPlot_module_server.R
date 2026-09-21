#' Server logic for the cnSegmentPlot module
#'
#' This module builds a genome-wide copy number segment plot with
#' [cnSegmentPlot()] from a `CNSegment` object (as returned by
#' [sesame::cnSegmentation()]), renders it as an interactive `plotly` figure,
#' and adds user-selected genes as draggable Plotly annotations.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `CNSegment` object (as returned by
#'   [sesame::cnSegmentation()]), or a named list of them to compare several
#'   samples stacked vertically over a shared genomic x-axis. Gene labels are
#'   taken from `seg$genomeInfo$genes` and chromosome tick/guide positions from
#'   `seg$genomeInfo$cytoBand`; genes overlapping each bin are read from the
#'   `bin.coords$genes` metadata column when present.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs. Individual entries may be a [shiny::reactive()]/`reactiveVal`, in
#'   which case the parameter follows the parent app's state and is resolved
#'   server-side (a single render, control kept in sync and still editable);
#'   see [VizModules::setup_reactive_defaults()].
#' @return The `moduleServer` function for the cnSegmentPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom methods is
#' @importFrom colourpicker updateColourInput
#' @importFrom GenomicRanges mcols
#' @importFrom stats complete.cases
#' @import VizModules
#'
#' @seealso [sciVizModules::cnSegmentPlot()],
#' [sciVizModules::cnSegmentPlotInputsUI()],
#' [sciVizModules::cnSegmentPlotOutputUI()], [sciVizModules::cnSegmentPlotApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) cnSegmentPlotApp()
#' @export
#' @author Jared Andrews
cnSegmentPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    base_defaults <- .cn_seg_base_defaults()

    if (!is.null(defaults)) {
        defaults <- modifyList(base_defaults, defaults)
    } else {
        defaults <- base_defaults
    }

    moduleServer(id, function(input, output, session) {
        # Resolve any reactive `defaults` entries (e.g. a parent-driven title)
        # into a server-side store so they update in the same reactive flush as
        # the data -> a single render. NULL when no defaults are reactive, in
        # which case behavior is unchanged. See setup_reactive_defaults().
        params <- setup_reactive_defaults(defaults, input, session)

        hide_input(session, hide.inputs)
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "cnSegmentPlotTabsetPanel", target = tab.name)
        }

        # The module consumes one CNSegment object per sample, normalized to a
        # named list so single- and multi-sample data take the same path. Gene
        # labels come from a `genomeInfo$genes` annotation; centromeres are
        # derived internally from `genomeInfo$cytoBand` by cnSegmentPlot().
        seg_obj <- reactive(.cn_seg_as_list(data_reactive()))
        genes_obj <- reactive(.cn_seg_genes(seg_obj()))

        observeEvent(input$reset, {
            seg.list <- seg_obj()
            req(seg.list)

            sample.choices <- names(seg.list)
            seq.choices <- .cn_seg_seq_choices(seg.list)
            hover.choices <- .cn_seg_hover_choices(seg.list)

            updateTextInput(session, "main", value = get_default(defaults, "main", ""))
            update_viz_select(session, "samples",
                choices = sample.choices, selected = get_default(defaults, "samples", sample.choices))
            update_viz_select(session, "to.plot",
                choices = seq.choices, selected = get_default(defaults, "to.plot", character(0)))
            update_viz_select(session, "hover.text.cols",
                choices = hover.choices, selected = get_default(defaults, "hover.text.cols", c("signal", "genes")))

            genes <- genes_obj()
            if (!is.null(genes) && length(genes) > 0 && !is.null(input$id.col)) {
                id.col.choices <- names(mcols(genes))
                default.id.col <- get_default(defaults, "id.col",
                    if ("hgnc_symbol" %in% id.col.choices) {
                        "hgnc_symbol"
                    } else if ("gene_name" %in% id.col.choices) {
                        "gene_name"
                    } else {
                        id.col.choices[1]
                    })
                update_viz_select(session, "id.col", choices = id.col.choices, selected = default.id.col)
                updateTextInput(session, "label.genes", value = get_default(defaults, "label.genes", ""))
            }

            updateNumericInput(session, "point.size", value = get_default(defaults, "point.size", 1.5))
            updateNumericInput(session, "point.alpha", value = get_default(defaults, "point.alpha", 0.8))
            updateColourInput(session, "color.low", value = get_default(defaults, "color.low", "#d400ff"))
            updateColourInput(session, "color.zero",
                value = get_default(defaults, "color.zero", "#C2C2C2"))
            updateColourInput(session, "color.high",
                value = get_default(defaults, "color.high", "#00b100"))
            updateNumericInput(session, "color.limit.low", value = get_default(defaults, "color.limit.low", -0.4))
            updateNumericInput(session, "color.limit.high", value = get_default(defaults, "color.limit.high", 0.4))
            updateColourInput(session, "color.seg", value = get_default(defaults, "color.seg", "#0000FF"))
            updateNumericInput(session, "seg.line.width", value = get_default(defaults, "seg.line.width", 1))
            updateColourInput(session, "centromere.color",
                value = get_default(defaults, "centromere.color", "#B3B3B3"))
            updateNumericInput(session, "centromere.width",
                value = get_default(defaults, "centromere.width", 0.3))
            update_viz_select(session, "centromere.linetype",
                selected = get_default(defaults, "centromere.linetype", "dashed"))
            updateColourInput(session, "border.color",
                value = get_default(defaults, "border.color", "#000000"))
            updateNumericInput(session, "border.width",
                value = get_default(defaults, "border.width", 0.3))
            update_viz_select(session, "border.linetype",
                selected = get_default(defaults, "border.linetype", "solid"))
            updateColourInput(session, "gene.line.color",
                value = get_default(defaults, "gene.line.color", "#666666"))
            updateNumericInput(session, "gene.line.width",
                value = get_default(defaults, "gene.line.width", 0.3))
            update_viz_select(session, "gene.line.linetype",
                selected = get_default(defaults, "gene.line.linetype", "dotted"))
            updateNumericInput(session, "label.size", value = get_default(defaults, "label.size", 10))
            updateNumericInput(session, "y.min", value = get_default(defaults, "y.min", NA))
            updateNumericInput(session, "y.max", value = get_default(defaults, "y.max", NA))
            updateCheckboxInput(session, "free.y", value = get_default(defaults, "free.y", FALSE))

            reset_axes_inputs(session, defaults)
            reset_plotly_inputs(session, defaults)
            reset_lines_inputs(session, defaults = defaults)
        })

        generate_cnSegmentPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

            seg.list <- seg_obj()
            req(seg.list)

            # Panels follow the order the samples were selected in; an empty or
            # absent selection plots every sample supplied.
            selected <- intersect(isolate_fn(input$samples), names(seg.list))
            if (length(selected) > 0) {
                seg.list <- seg.list[selected]
            }
            multi <- length(seg.list) > 1L

            to.plot <- isolate_fn(input$to.plot)
            hover.text.cols <- isolate_fn(input$hover.text.cols)
            if (is.null(hover.text.cols) || length(hover.text.cols) == 0) hover.text.cols <- "signal"

            id.col <- if (!is.null(input$id.col)) isolate_fn(input$id.col) else NULL
            if (!is.null(id.col) && !nzchar(id.col)) id.col <- NULL

            genes <- genes_obj()
            label.genes <- if (!is.null(input$label.genes)) isolate_fn(input$label.genes) else ""
            genes.to.label <- .cn_seg_select_genes(genes, id.col, label.genes)

            color.limit.low <- isolate_fn(input$color.limit.low)
            color.limit.high <- isolate_fn(input$color.limit.high)
            color.limits <- if (is.na(color.limit.low) || is.na(color.limit.high)) {
                NULL
            } else {
                c(color.limit.low, color.limit.high)
            }

            y.min <- isolate_fn(input$y.min)
            if (is.na(y.min)) y.min <- NULL
            y.max <- isolate_fn(input$y.max)
            if (is.na(y.max)) y.max <- NULL

            fig <- cnSegmentPlot(
                seg = seg.list,
                genes = genes.to.label,
                id.col = id.col,
                to.plot = to.plot,
                hover.text.cols = hover.text.cols,
                point.size = isolate_fn(input$point.size),
                point.alpha = isolate_fn(input$point.alpha),
                color.low = isolate_fn(input$color.low),
                color.zero = isolate_fn(input$color.zero),
                color.high = isolate_fn(input$color.high),
                color.limits = color.limits,
                color.seg = isolate_fn(input$color.seg),
                seg.line.width = isolate_fn(input$seg.line.width),
                centromere.color = isolate_fn(input$centromere.color),
                centromere.width = isolate_fn(input$centromere.width),
                centromere.linetype = isolate_fn(input$centromere.linetype),
                border.color = isolate_fn(input$border.color),
                border.width = isolate_fn(input$border.width),
                border.linetype = isolate_fn(input$border.linetype),
                gene.line.color = isolate_fn(input$gene.line.color),
                gene.line.width = isolate_fn(input$gene.line.width),
                gene.line.linetype = isolate_fn(input$gene.line.linetype),
                # Per-panel borders follow the Axes tab's axis border controls,
                # so a stacked plot boxes its panels the same way a single-panel
                # one boxes its axes -- one source of truth, no double-drawing.
                panel.border.color = isolate_fn(input$axis.linecolor),
                panel.border.width = if (isTRUE(isolate_fn(input$axis.showline))) {
                    isolate_fn(input$axis.linewidth)
                } else {
                    0
                },
                panel.border.mirror = isTRUE(isolate_fn(input$axis.mirror)),
                label.size = isolate_fn(input$label.size),
                free.y = isTRUE(isolate_fn(input$free.y)),
                y.min = y.min,
                y.max = y.max,
                main = isolate_fn(input$main)
            )

            fig <- apply_title_layout(
                fig, input, isolate_fn,
                title_y = 0.95,
                title_x = isolate_fn(input$axis.title.horizontal.position)
            )

            xaxis_style <- create_axis_styles(
                input,
                axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
            )

            yaxis_style <- create_axis_styles(
                input,
                axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
            )

            fig <- apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            fig <- add_reference_lines(fig,
                hline.intercepts = isolate_fn(input$hline.intercepts),
                hline.colors = isolate_fn(input$hline.colors),
                hline.widths = isolate_fn(input$hline.widths),
                hline.linetypes = isolate_fn(input$hline.linetypes),
                hline.opacities = isolate_fn(input$hline.opacities),
                vline.intercepts = isolate_fn(input$vline.intercepts),
                vline.colors = isolate_fn(input$vline.colors),
                vline.widths = isolate_fn(input$vline.widths),
                vline.linetypes = isolate_fn(input$vline.linetypes),
                vline.opacities = isolate_fn(input$vline.opacities),
                abline.slopes = isolate_fn(input$abline.slopes),
                abline.intercepts = isolate_fn(input$abline.intercepts),
                abline.colors = isolate_fn(input$abline.colors),
                abline.widths = isolate_fn(input$abline.widths),
                abline.linetypes = isolate_fn(input$abline.linetypes),
                abline.opacities = isolate_fn(input$abline.opacities)
            )

            config_list <- add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = TRUE,
                facet.by = if (multi) "sample" else NULL
            )

            fig <- do.call(config, c(list(p = fig), config_list))

            # A stacked plot is multi-panel, so ggplotly already renders its
            # shared axis titles as annotations (which axis_titles_as_annotations()
            # deliberately leaves alone); style those instead.
            fig <- if (multi) {
                apply_axis_title_to_annotations(fig, input, isolate_fn)
            } else {
                axis_titles_as_annotations(fig)
            }
            fig
        })

        output$cnSegmentPlot <- renderPlotly({
            # seg_obj() validates the supplied data, so it is inside the
            # tryCatch: a malformed `data` reactive should surface as the
            # module's message plot rather than a raw Shiny error. req()'s own
            # silent error is re-raised so it still cancels the render.
            tryCatch(
                {
                    req(seg_obj())
                    apply_render_margins(generate_cnSegmentPlot(), input)
                },
                shiny.silent.error = function(e) stop(e),
                error = function(e) {
                    empty_plot(text = conditionMessage(e), plotly = TRUE)
                }
            )
        })

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            source_data <- collect_source_data(
                plot_reactive = generate_cnSegmentPlot,
                inputs_reactive = AllInputs()
            )

            # collect_source_data() narrows the frame to the plotted aesthetics,
            # which drops the facet variable. Without it a stacked download is
            # just pooled bins with no way to tell the samples apart, so put the
            # column back, matching that function's own row filtering.
            full_data <- as.data.frame(plotly_data(source_data$plot))
            if (!is.null(full_data$sample) && is.null(source_data$plot_data$sample)) {
                keep_rows <- stats::complete.cases(
                    full_data[, names(source_data$plot_data), drop = FALSE]
                )
                source_data$plot_data <- cbind(
                    sample = full_data$sample[keep_rows], source_data$plot_data
                )
            }

            source_data
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "cnSegmentPlot_source"
        )

        return(plot_source_reactive)
    })
}
