#' Server logic for the oncoPlot module
#'
#' This module builds a mutation-landscape oncoprint with
#' [ComplexHeatmap::oncoPrint()] (via [oncoPlot()]) and renders it as an
#' **interactive** heatmap using
#' [InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()]. Hovering shows
#' cell information, clicking / brushing populates a zoomable sub-heatmap, and
#' the info panel reports the selected gene, sample, and alteration.
#'
#' The incoming data are expected in tidy (long) form (one row per alteration).
#' The selected sample / gene / alteration columns are pivoted into the
#' character matrix `oncoPrint()` expects (see [oncoPlotInputsUI()]).
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the tidy mutation data frame.
#' @param hide.inputs A character vector of input IDs to hide. These will still
#'   be initialized and their values passed to the plot function.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs. Typically the same list passed to [oncoPlotInputsUI()].
#' @return The `moduleServer` function for the oncoPlot module. Returns a
#'   reactive carrying the oncoprint source matrix for download.
#'
#' @import shiny
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#' @importFrom InteractiveComplexHeatmap makeInteractiveComplexHeatmap
#' @importFrom VizModules get_default create_source_download_handler
#'   updateMultiColorPicker updateMultiDynamicInput
#'
#' @seealso [ComplexHeatmap::oncoPrint()], [sciVizModules::oncoPlot()],
#' [sciVizModules::oncoPlotInputsUI()], [sciVizModules::oncoPlotOutputUI()],
#' [sciVizModules::oncoPlotApp()]
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) oncoPlotApp()
#' @export
#' @author Jacob Martin, Jared Andrews
oncoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "oncoPlotTabsetPanel", target = tab.name)
        }

        observeEvent(input$reset, {
            df <- data_reactive()
            req(df)

            detected.sample <- .onco_sample_col(df)
            detected.gene <- .onco_gene_col(df, exclude = detected.sample)
            detected.alt <- .onco_alteration_col(df, exclude = c(detected.sample, detected.gene))

            updateSelectInput(session, "sample", selected = get_default(defaults, "sample", detected.sample))
            updateSelectInput(session, "gene", selected = get_default(defaults, "gene", detected.gene))
            updateSelectInput(session, "alteration", selected = get_default(defaults, "alteration", detected.alt))
            updateNumericInput(session, "top.n", value = get_default(defaults, "top.n", NA))
            updateTextInput(session, "column.title", value = get_default(defaults, "column.title", ""))
            updateMaterialSwitch(session, "show.pct", value = get_default(defaults, "show.pct", TRUE))
            updateMaterialSwitch(session, "show.column.names", value = get_default(defaults, "show.column.names", FALSE))
            updateMaterialSwitch(session, "remove.empty.columns", value = get_default(defaults, "remove.empty.columns", FALSE))
            updateMaterialSwitch(session, "remove.empty.rows", value = get_default(defaults, "remove.empty.rows", FALSE))

            types <- .onco_types_from_df(df, get_default(defaults, "alteration", detected.alt))
            if (!length(types)) types <- "alteration"
            updateMultiColorPicker(session, "alteration.colors",
                colors = get_default(defaults, "alteration.colors", .onco_default_colors(types)))
            updateColourInput(session, "background.color",
                value = get_default(defaults, "background.color", "#CCCCCC"))
            updateMaterialSwitch(session, "border", value = get_default(defaults, "border", FALSE))
            updateNumericInput(session, "row.font.size", value = get_default(defaults, "row.font.size", 12))
            updateNumericInput(session, "column.font.size", value = get_default(defaults, "column.font.size", 10))
            updateMultiDynamicInput(session, "annotations", clear = TRUE)
        })

        # Keep the per-alteration colour picker rows in sync with the alteration
        # types present in the currently selected column. New types get a
        # default colour; user-chosen colours for existing types are preserved
        # by updateMultiColorPicker (it only re-keys the group rows).
        observeEvent(list(data_reactive(), input$alteration), {
            df <- data_reactive()
            req(df, input$alteration)
            req(input$alteration %in% names(df))
            types <- .onco_types_from_df(df, input$alteration)
            req(length(types) > 0)

            current <- isolate(input$alteration.colors)
            new.colors <- .onco_default_colors(types)
            # Preserve any colours the user already set for still-present types.
            if (!is.null(current)) {
                keep <- intersect(names(current), types)
                new.colors[keep] <- current[keep]
            }
            updateMultiColorPicker(session, "alteration.colors", colors = new.colors)
        }, ignoreInit = TRUE)

        # Build the oncoprint matrix from the selected columns. Kept separate
        # from the drawn heatmap so it can be offered as downloadable source.
        onco_matrix <- reactive({
            df <- data_reactive()
            req(df)

            sample.col <- input$sample
            gene.col <- input$gene
            alt.col <- input$alteration
            req(sample.col, gene.col, alt.col)
            req(sample.col %in% names(df), gene.col %in% names(df), alt.col %in% names(df))

            mat <- .onco_to_matrix(df, sample.col, gene.col, alt.col)

            top.n <- input$top.n
            if (!is.null(top.n) && !is.na(top.n) && is.finite(top.n) &&
                top.n >= 1 && top.n < nrow(mat)) {
                n.alt <- rowSums(.onco_nzchar_matrix(mat))
                keep <- order(n.alt, decreasing = TRUE)[seq_len(top.n)]
                mat <- mat[sort(keep), , drop = FALSE]
            }
            mat
        })

        generate_oncoPlot <- reactive({
            mat <- onco_matrix()
            req(mat)

            col.title <- input$column.title
            if (is.null(col.title) || !nzchar(col.title)) col.title <- NULL

            # User-chosen alteration colours (named vector), if any. oncoPlot()
            # fills in any missing types automatically.
            user.col <- input$alteration.colors
            if (is.null(user.col) || !length(user.col)) user.col <- NULL

            background <- input$background.color
            if (is.null(background) || !nzchar(background)) background <- "#CCCCCC"

            row.fs <- input$row.font.size
            if (is.null(row.fs) || is.na(row.fs)) row.fs <- 12
            col.fs <- input$column.font.size
            if (is.null(col.fs) || is.na(col.fs)) col.fs <- 10

            # Build side annotations from the dynamic annotation adder rows.
            # Failures in any single track are swallowed (that track is skipped)
            # so a malformed row never blocks the whole plot.
            anns <- tryCatch(
                .onco_collect_annotations(
                    input$annotations, data_reactive(), mat,
                    input$sample, input$gene, input$alteration
                ),
                error = function(e) list(top = NULL, bottom = NULL, left = NULL, right = NULL)
            )

            oncoPlot(
                mat,
                col = user.col,
                remove.empty.columns = isTRUE(input$remove.empty.columns),
                remove.empty.rows = isTRUE(input$remove.empty.rows),
                show.column.names = isTRUE(input$show.column.names),
                show.pct = isTRUE(input$show.pct),
                column.title = col.title,
                background = background,
                border = isTRUE(input$border),
                row.font.size = row.fs,
                column.font.size = col.fs,
                top.annotation = anns$top,
                bottom.annotation = anns$bottom,
                left.annotation = anns$left,
                right.annotation = anns$right
            )
        })

        # InteractiveComplexHeatmap is not module-aware: it assigns directly to
        # `output[["<heatmap_id>_heatmap"]]` and talks to the client via custom
        # messages keyed on the raw heatmap_id, applying no namespacing itself.
        # The UI (originalHeatmapOutput/subHeatmapOutput) sanitizes its id by
        # turning "-" into "_", so ns("ht") -> "<ns>_ht". To make the server
        # write to those exact output slots we must (a) use that same sanitized
        # id and (b) hand it the *root* session's input/output/session so no
        # extra module prefix is added.
        heatmap_id <- gsub("-", "_", session$ns("ht"), fixed = TRUE)
        root <- session$rootScope()
        observe({
            ht <- tryCatch(generate_oncoPlot(), error = function(e) NULL)
            req(ht)
            makeInteractiveComplexHeatmap(
                root$input, root$output, root, ht, heatmap_id
            )
        })

        plot_source_reactive <- reactive({
            mat <- tryCatch(onco_matrix(), error = function(e) NULL)
            req(mat)
            df <- as.data.frame(mat, stringsAsFactors = FALSE)
            df <- cbind(gene = rownames(mat), df)
            rownames(df) <- NULL
            list(oncoPlot_matrix = df)
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "oncoPlot_source"
        )

        return(plot_source_reactive)
    })
}
