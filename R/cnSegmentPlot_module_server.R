#' Server logic for the cnSegmentPlot module
#'
#' This module builds a genome-wide copy number segment plot with
#' [cnSegmentPlot()] from a `CNSegment` object (as returned by
#' [sesame::cnSegmentation()]), renders it as an interactive `plotly` figure,
#' and adds user-selected genes as draggable Plotly annotations.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a list with up to three elements:
#'   \describe{
#'     \item{`seg`}{A `CNSegment` object (required).}
#'     \item{`genes`}{Optional `GRanges` of gene coordinates for labeling.}
#'     \item{`centromere`}{Optional `GRanges` of per-chromosome centromere
#'       coordinates, used to position chromosome axis tick labels.}
#'   }
#'   The list may also be unnamed with positions 1 = seg, 2 = genes,
#'   3 = centromere.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs.
#' @return The `moduleServer` function for the cnSegmentPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom methods is
#' @import VizModules
#'
#' @seealso [sciVizModules::cnSegmentPlot()],
#' [sciVizModules::cnSegmentPlotInputsUI()],
#' [sciVizModules::cnSegmentPlotOutputUI()], [sciVizModules::cnSegmentPlotApp()]
#'
#' @export
#' @author Jared Andrews
cnSegmentPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "cnSegmentPlotTabsetPanel", target = tab.name)
        }

        # Pull the bundled inputs out of the reactive list (named or positional).
        get_part <- function(bundle, name, pos) {
            if (!is.null(bundle[[name]])) {
                bundle[[name]]
            } else if (length(bundle) >= pos) {
                bundle[[pos]]
            } else {
                NULL
            }
        }
        seg_obj <- reactive(get_part(data_reactive(), "seg", 1))
        genes_obj <- reactive(get_part(data_reactive(), "genes", 2))
        centromere_obj <- reactive(get_part(data_reactive(), "centromere", 3))

        observeEvent(input$reset, {
            seg <- seg_obj()
            req(seg)

            seq.choices <- as.character(GenomicRanges::seqinfo(seg$bin.coords)@seqnames)
            hover.choices <- union(names(GenomicRanges::mcols(seg$bin.coords)), "signal")

            updateSelectInput(session, "to.plot",
                choices = seq.choices, selected = get_default(defaults, "to.plot", character(0)))
            updateSelectInput(session, "hover.text.cols",
                choices = hover.choices, selected = get_default(defaults, "hover.text.cols", "signal"))

            genes <- genes_obj()
            if (!is.null(genes) && length(genes) > 0 && !is.null(input$id.col)) {
                id.col.choices <- names(GenomicRanges::mcols(genes))
                default.id.col <- get_default(defaults, "id.col",
                    if ("hgnc_symbol" %in% id.col.choices) {
                        "hgnc_symbol"
                    } else if ("gene_name" %in% id.col.choices) {
                        "gene_name"
                    } else {
                        id.col.choices[1]
                    })
                updateSelectInput(session, "id.col", choices = id.col.choices, selected = default.id.col)
                updateTextInput(session, "label.genes", value = get_default(defaults, "label.genes", ""))
            }

            updateNumericInput(session, "point.size", value = get_default(defaults, "point.size", 1.5))
            updateNumericInput(session, "point.alpha", value = get_default(defaults, "point.alpha", 0.8))
            colourpicker::updateColourInput(session, "color.low", value = get_default(defaults, "color.low", "#FF0000"))
            colourpicker::updateColourInput(session, "color.mid", value = get_default(defaults, "color.mid", "#808080"))
            colourpicker::updateColourInput(session, "color.high",
                value = get_default(defaults, "color.high", "#00FF00"))
            updateNumericInput(session, "color.limit.low", value = get_default(defaults, "color.limit.low", -0.4))
            updateNumericInput(session, "color.limit.high", value = get_default(defaults, "color.limit.high", 0.4))
            colourpicker::updateColourInput(session, "color.seg", value = get_default(defaults, "color.seg", "#0000FF"))
            updateNumericInput(session, "seg.line.width", value = get_default(defaults, "seg.line.width", 1))
            updateNumericInput(session, "label.size", value = get_default(defaults, "label.size", 3))
            updateNumericInput(session, "y.min", value = get_default(defaults, "y.min", NA))
            updateNumericInput(session, "y.max", value = get_default(defaults, "y.max", NA))

            reset_axes_inputs(session, defaults)
            reset_plotly_inputs(session, defaults)
            reset_lines_inputs(session, defaults = defaults)
        })

        generate_cnSegmentPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            seg <- seg_obj()
            req(seg)

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
                seg = seg,
                genes = genes.to.label,
                id.col = id.col,
                centromere = centromere_obj(),
                to.plot = to.plot,
                hover.text.cols = hover.text.cols,
                point.size = isolate_fn(input$point.size),
                point.alpha = isolate_fn(input$point.alpha),
                color.low = isolate_fn(input$color.low),
                color.mid = isolate_fn(input$color.mid),
                color.high = isolate_fn(input$color.high),
                color.limits = color.limits,
                color.seg = isolate_fn(input$color.seg),
                seg.line.width = isolate_fn(input$seg.line.width),
                label.size = isolate_fn(input$label.size),
                y.min = y.min,
                y.max = y.max
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
                include.modebar.buttons = TRUE, facet.by = NULL
            )
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- axis_titles_as_annotations(fig)
            fig
        })

        output$cnSegmentPlot <- renderPlotly({
            req(seg_obj())
            tryCatch(
                apply_render_margins(generate_cnSegmentPlot(), input),
                error = function(e) {
                    empty_plot(text = conditionMessage(e), plotly = TRUE)
                }
            )
        })

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_cnSegmentPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "cnSegmentPlot_source"
        )

        return(plot_source_reactive)
    })
}
