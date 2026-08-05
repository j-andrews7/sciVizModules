#' Server logic for the cnSegmentPlot module
#'
#' This module builds a genome-wide copy number segment plot with
#' [cnSegmentPlot()] from a `CNSegment` object (as returned by
#' [sesame::cnSegmentation()]), renders it as an interactive `plotly` figure,
#' and adds user-selected genes as draggable Plotly annotations.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a single `CNSegment` object (as returned
#'   by [sesame::cnSegmentation()]). Gene labels are taken from
#'   `seg$genomeInfo$genes` and chromosome tick/guide positions from
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
#' @importFrom shinyjs hide
#' @importFrom methods is
#' @importFrom colourpicker updateColourInput
#' @importFrom GenomicRanges seqinfo seqnames mcols
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

    base_defaults <- list(
            label.genes = "TP53, EGFR, MYC, TERT, PTCH1, MGMT, CCNE1, KRAS, CDK4, CDK6, CCND1, CCND2, FGFR1, PDGFRA, RB1, MYCN, MDM4, GLI2, MYB, CDKN2A, PTEN, MDM2, NF1, PPM1D, NF2, SMARCB1",
            label.size = 10,
            show.grid.x = FALSE,
            show.grid.y = FALSE,
            margin.top = 70,
            hline.intercepts = "0",
            hline.colors = "#adadad",
            hline.widths = "1",
            hline.linetypes = "solid",
            axis.tickangle.x = -45
        )

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

        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "cnSegmentPlotTabsetPanel", target = tab.name)
        }

        # The module consumes a single CNSegment object. Gene labels come from
        # its `genomeInfo$genes` annotation; centromeres are derived internally
        # from `genomeInfo$cytoBand` by cnSegmentPlot().
        seg_obj <- reactive(data_reactive())
        genes_obj <- reactive(seg_obj()$genomeInfo$genes)

        observeEvent(input$reset, {
            seg <- seg_obj()
            req(seg)

            seq.choices <- as.character(seqnames(seqinfo(seg$bin.coords)))
            seq.choices <- seq.choices[seq.choices %in% c(paste0("chr", 1:22), "chrX", "chrY")]
            hover.choices <- union(names(mcols(seg$bin.coords)), "signal")

            updateTextInput(session, "main", value = get_default(defaults, "main", ""))
            updateSelectInput(session, "to.plot",
                choices = seq.choices, selected = get_default(defaults, "to.plot", character(0)))
            updateSelectInput(session, "hover.text.cols",
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
                updateSelectInput(session, "id.col", choices = id.col.choices, selected = default.id.col)
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
            updateSelectInput(session, "centromere.linetype",
                selected = get_default(defaults, "centromere.linetype", "dashed"))
            updateColourInput(session, "border.color",
                value = get_default(defaults, "border.color", "#000000"))
            updateNumericInput(session, "border.width",
                value = get_default(defaults, "border.width", 0.3))
            updateSelectInput(session, "border.linetype",
                selected = get_default(defaults, "border.linetype", "solid"))
            updateNumericInput(session, "label.size", value = get_default(defaults, "label.size", 10))
            updateNumericInput(session, "y.min", value = get_default(defaults, "y.min", NA))
            updateNumericInput(session, "y.max", value = get_default(defaults, "y.max", NA))

            reset_axes_inputs(session, defaults)
            reset_plotly_inputs(session, defaults)
            reset_lines_inputs(session, defaults = defaults)
        })

        generate_cnSegmentPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

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
                label.size = isolate_fn(input$label.size),
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
