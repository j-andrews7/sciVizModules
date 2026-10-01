#' GSEA enrichment plot
#'
#' The standard gene set enrichment analysis figure for one or more gene sets,
#' on a shared axis of the ranked gene list: the running enrichment score (top),
#' a tick for each gene of the set (middle), and the ranked statistic itself
#' (bottom). The running score is that of [fgsea::plotEnrichmentData()] and
#' clusterProfiler's `gseaplot2()`; the enrichment score is its largest
#' deviation from zero, marked with a dashed line.
#'
#' @param x An fgsea bundle - `list(stats = <named numeric>, pathways = <named
#'   list>, results = <fgsea table, optional>)` - or a clusterProfiler
#'   `gseaResult`.
#' @param pathways Gene sets to plot, by name. Default: the three most
#'   significant (or the first three when there are no results).
#' @param gsea.param Weight exponent of the running score (1 is standard GSEA).
#' @param colors Named vector of colours for the gene sets. Unnamed sets fall
#'   back to the default palette.
#' @param show.ticks,show.metric Logical; draw the hit ticks and the ranked
#'   statistic panels.
#' @param metric.color Colour of the ranked statistic.
#' @param main Optional plot title.
#'
#' @return A `plotly` object. The per-set summary (enrichment score, NES and
#'   adjusted p-value when results are given, set size, leading edge) is attached
#'   as attribute `"table"`.
#'
#' @import plotly
#' @seealso [gseaEnrichmentPlotServer()], [fgsea::plotEnrichment()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_gsea)
#' gseaEnrichmentPlot(example_gsea)
gseaEnrichmentPlot <- function(x, pathways = NULL, gsea.param = 1, colors = NULL, show.ticks = TRUE,
                               show.metric = TRUE, metric.color = "#7F7F7F", main = NULL) {
    x <- .gsea_input(x, "x")
    pathways <- if (length(pathways)) intersect(pathways, names(x$pathways)) else .gsea_default_pathways(x)
    if (length(pathways) == 0) stop("Choose at least one gene set.", call. = FALSE)
    gsea.param <- as.numeric(gsea.param %||% 1)

    runs <- lapply(stats::setNames(pathways, pathways), function(pw) .gsea_running(x$stats, x$pathways[[pw]], gsea.param))
    runs <- runs[!vapply(runs, is.null, logical(1))]
    if (length(runs) == 0) stop("None of the chosen gene sets has genes in the ranked list.", call. = FALSE)
    pathways <- names(runs)

    palette <- resolve_palette(pathways, NULL, default_palettes()[["choices"]][["Defaults"]][["dittoColors"]], colors)
    res <- x$results
    legend_label <- function(pw) {
        label <- x$labels[[pw]] %||% pw
        row <- if (is.null(res)) NULL else res[res$pathway == pw, , drop = FALSE]
        if (!is.null(row) && nrow(row) && all(c("NES", "padj") %in% names(row))) {
            sprintf("%s (NES %.2f, adj. p %s)", label, row$NES[1], format(signif(row$padj[1], 2)))
        } else {
            sprintf("%s (ES %.2f)", label, runs[[pw]]$es)
        }
    }

    top <- plot_ly()
    for (pw in pathways) {
        cv <- runs[[pw]]$curve
        top <- add_trace(top,
            x = cv$rank, y = cv$es, type = "scatter", mode = "lines", name = legend_label(pw),
            legendgroup = pw, line = list(color = palette[[pw]], width = 2),
            text = sprintf("%s<br>rank %d<br>running ES %.3f", x$labels[[pw]] %||% pw, cv$rank, cv$es),
            hoverinfo = "text"
        )
    }
    top <- layout(top, yaxis = list(title = list(text = "Enrichment score"), zeroline = TRUE))

    panels <- list(top)
    heights <- 0.55

    if (isTRUE(show.ticks)) {
        ticks <- plot_ly()
        for (i in seq_along(pathways)) {
            h <- runs[[pathways[i]]]$hits
            ticks <- add_trace(ticks,
                x = as.vector(rbind(h$rank, h$rank, NA)),
                y = rep(c(i - 0.9, i - 0.1, NA), times = nrow(h)),
                type = "scatter", mode = "lines", legendgroup = pathways[i], showlegend = FALSE,
                line = list(color = palette[[pathways[i]]], width = 1),
                text = rep(sprintf("%s<br>rank %d<br>stat %.3f", h$gene, h$rank, h$stat), each = 3),
                hoverinfo = "text"
            )
        }
        ticks <- layout(ticks, yaxis = list(title = list(text = ""), showticklabels = FALSE,
            range = c(0, length(pathways)), showgrid = FALSE, zeroline = FALSE))
        panels[[length(panels) + 1]] <- ticks
        heights <- c(heights, min(0.08 * length(pathways), 0.3))
    }

    if (isTRUE(show.metric)) {
        s <- sort(x$stats, decreasing = TRUE)
        metric <- plot_ly(
            x = seq_along(s), y = unname(s), type = "scatter", mode = "lines", fill = "tozeroy",
            showlegend = FALSE, line = list(color = metric.color, width = 0.5), fillcolor = metric.color,
            text = sprintf("%s<br>rank %d<br>stat %.3f", names(s), seq_along(s), s), hoverinfo = "text"
        )
        metric <- layout(metric, yaxis = list(title = list(text = "Ranked metric")))
        panels[[length(panels) + 1]] <- metric
        heights <- c(heights, 0.25)
    }

    fig <- if (length(panels) == 1) {
        panels[[1]]
    } else {
        subplot(panels, nrows = length(panels), shareX = TRUE, titleY = TRUE, heights = heights / sum(heights),
            margin = 0.02)
    }

    # Each set's enrichment score as a dashed line in its colour. Shapes are set
    # directly because layout(shapes =) is dropped on a subplot() figure.
    fig$x$layout$shapes <- c(fig$x$layout$shapes, lapply(pathways, function(pw) {
        list(type = "line", xref = "paper", x0 = 0, x1 = 1, yref = "y", y0 = runs[[pw]]$es, y1 = runs[[pw]]$es,
            line = list(color = palette[[pw]], dash = "dash", width = 1))
    }))
    fig$x$layout$xaxis$title <- list(text = "Rank in ordered gene list")
    fig <- layout(fig, title = list(text = main %||% ""))

    table <- do.call(rbind, lapply(pathways, function(pw) {
        row <- if (is.null(res)) NULL else res[res$pathway == pw, , drop = FALSE]
        data.frame(
            pathway = pw, label = x$labels[[pw]] %||% pw, ES = runs[[pw]]$es,
            NES = if (!is.null(row) && nrow(row) && "NES" %in% names(row)) row$NES[1] else NA_real_,
            padj = if (!is.null(row) && nrow(row) && "padj" %in% names(row)) row$padj[1] else NA_real_,
            size = nrow(runs[[pw]]$hits),
            leading.edge.size = length(runs[[pw]]$leading.edge),
            leading.edge = paste(runs[[pw]]$leading.edge, collapse = "/"),
            stringsAsFactors = FALSE
        )
    }))
    attr(fig, "table") <- table
    fig
}
