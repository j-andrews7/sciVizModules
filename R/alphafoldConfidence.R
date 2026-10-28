#' AlphaFold confidence plot: pLDDT track and predicted aligned error
#'
#' Draws the two confidence measures of an AlphaFold prediction on a shared
#' residue axis: the per-residue pLDDT as a track on top, over the AlphaFold DB
#' confidence bands, and the predicted aligned error (PAE) as a heatmap below.
#' Low-PAE blocks along the diagonal are confidently placed domains; low PAE
#' between two blocks means their relative position is confident too. For a
#' multimer, chain boundaries are drawn across both panels.
#'
#' @param x An object from [read_alphafold()].
#' @param residue.start,residue.end Range of positions (along the prediction,
#'   counting across chains) to show. Default: all.
#' @param max.pae Upper end of the PAE colour scale, in Angstroms. Default: the
#'   maximum the file reports, or the largest value.
#' @param show.bands Logical; shade the pLDDT confidence bands.
#' @param show.chains Logical; mark chain boundaries.
#' @param band.colors Colours of the "Very high", "Confident", "Low" and
#'   "Very low" bands, in that order (AlphaFold DB's by default).
#' @param line.color Colour of the pLDDT line.
#' @param pae.low.color,pae.high.color Colours for zero and `max.pae` PAE.
#' @param track.height Fraction of the plot height given to the pLDDT track.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the pLDDT table shown as attribute `"table"`.
#'
#' @import plotly
#' @seealso [read_alphafold()], [alphafoldConfidenceServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' af <- read_alphafold(
#'     pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz",
#'         package = "sciVizModules"),
#'     confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz",
#'         package = "sciVizModules")
#' )
#' alphafoldConfidence(af)
alphafoldConfidence <- function(x, residue.start = NULL, residue.end = NULL, max.pae = NULL,
                                show.bands = TRUE, show.chains = TRUE,
                                band.colors = c("#0053D6", "#65CBF3", "#FFDB13", "#FF7D45"),
                                line.color = "#333333",
                                pae.low.color = "#0B4D1F", pae.high.color = "#FFFFFF",
                                track.height = 0.25, main = NULL) {
    .assert_alphafold(x, "x")
    pl <- x$plddt
    n <- nrow(pl)
    start <- max(1L, as.integer(residue.start %||% 1L))
    end <- min(n, as.integer(residue.end %||% n))
    if (is.na(start) || is.na(end) || start > end) {
        stop("The residue range is empty.", call. = FALSE)
    }
    keep <- start:end
    pl <- pl[keep, , drop = FALSE]
    pl$label <- paste0(pl$chain, ":", pl$residue)

    has_plddt <- any(!is.na(pl$plddt))
    has_pae <- !is.null(x$pae)
    track.height <- min(max(as.numeric(track.height %||% 0.25), 0.1), 0.6)

    track <- NULL
    if (has_plddt) {
        track <- plot_ly(pl,
            x = ~index, y = ~plddt, type = "scatter", mode = "lines+markers",
            line = list(color = line.color, width = 1),
            marker = list(color = band.colors[as.integer(pl$category)], size = 4),
            text = sprintf("%s<br>pLDDT %.1f (%s)", pl$label, pl$plddt, pl$category),
            hoverinfo = "text", showlegend = FALSE
        )
        track <- layout(track, yaxis = list(title = list(text = "pLDDT"), range = c(0, 100)))
    }

    heat <- NULL
    if (has_pae) {
        m <- x$pae[keep, keep, drop = FALSE]
        cap <- as.numeric(max.pae %||% x$max_pae %||% max(m, na.rm = TRUE))
        hover <- outer(pl$label, pl$label, function(a, s) paste0("Aligned ", a, "<br>Scored ", s))
        heat <- plot_ly(
            x = pl$index, y = pl$index, z = m, type = "heatmap",
            colorscale = list(c(0, pae.low.color), c(1, pae.high.color)), zmin = 0, zmax = cap,
            customdata = hover,
            hovertemplate = "%{customdata}<br>PAE %{z:.1f} \u00c5<extra></extra>",
            colorbar = list(title = list(text = "PAE (\u00c5)"), len = 1 - track.height, y = 0, yanchor = "bottom")
        )
        heat <- layout(heat, yaxis = list(title = list(text = "Aligned residue"), autorange = "reversed"))
    }

    if (is.null(track) && is.null(heat)) stop("Nothing to plot: no pLDDT or PAE.", call. = FALSE)
    fig <- if (!is.null(track) && !is.null(heat)) {
        subplot(track, heat, nrows = 2, shareX = TRUE, titleY = TRUE,
            heights = c(track.height, 1 - track.height), margin = 0.02)
    } else {
        track %||% heat
    }

    shapes <- list()
    if (isTRUE(show.bands) && has_plddt) {
        bands <- list(c(90, 100), c(70, 90), c(50, 70), c(0, 50))
        for (i in seq_along(bands)) {
            shapes[[length(shapes) + 1]] <- list(
                type = "rect", xref = "x", yref = "y", layer = "below",
                x0 = start - 0.5, x1 = end + 0.5, y0 = bands[[i]][1], y1 = bands[[i]][2],
                fillcolor = band.colors[i], opacity = 0.15, line = list(width = 0)
            )
        }
    }
    if (isTRUE(show.chains)) {
        bounds <- pl$index[c(FALSE, pl$chain[-1] != pl$chain[-nrow(pl)])] - 0.5
        heat_y <- if (!is.null(track) && !is.null(heat)) "y2" else "y"
        for (b in bounds) {
            shapes[[length(shapes) + 1]] <- list(
                type = "line", xref = "x", yref = "paper", x0 = b, x1 = b, y0 = 0, y1 = 1,
                line = list(color = "#000000", width = 1, dash = "dot")
            )
            if (has_pae) {
                shapes[[length(shapes) + 1]] <- list(
                    type = "line", xref = "x", yref = heat_y, x0 = start - 0.5, x1 = end + 0.5, y0 = b, y1 = b,
                    line = list(color = "#000000", width = 1, dash = "dot")
                )
            }
        }
    }

    fig <- layout(fig, title = list(text = main %||% ""))
    # Set directly: shapes passed through layout() on a subplot() figure are
    # dropped when it is built (add_reference_lines() writes them the same way).
    fig$x$layout$shapes <- c(fig$x$layout$shapes, shapes)
    fig$x$layout$xaxis$title <- list(text = if (has_pae) "Scored residue" else "Residue")
    fig$x$layout$xaxis$range <- c(start - 0.5, end + 0.5)
    attr(fig, "table") <- pl[, c("index", "chain", "residue", "plddt", "category")]
    fig
}
