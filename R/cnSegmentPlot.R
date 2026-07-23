#' Plot DNA methylation array-based copy number segmentation
#'
#' Draws a genome-wide copy number scatter/segment plot from the output of
#' [sesame::cnSegmentation()]: bin-level log2 signal ratios are plotted across
#' the genome and colored by signal, with the called segment means overlaid as
#' horizontal line segments. Optionally, genes overlapping the called segments
#' can be labeled with draggable Plotly annotations.
#'
#' @details `seg` must be a `CNSegment` object as returned by
#' [sesame::cnSegmentation()], a list with (at least) `bin.coords` (a
#' `GRanges` of genomic bins with associated `seqinfo`), `bin.signals` (a named
#' numeric vector of per-bin log2 signal ratios), and `seg.signals` (a
#' `data.frame` of called segments with `chrom`, `loc.start`, `loc.end`, and
#' `seg.mean` columns).
#'
#' Both the color scale and the y-axis support explicit limits
#' (`color.limits` and `y.min`/`y.max`, respectively). In both cases,
#' out-of-bound values are squished to the nearest limit (via
#' [scales::squish()]) rather than dropped, so points beyond the requested
#' limits remain visible (clamped to the edge of the plot/color scale) instead
#' of disappearing. The signal colorbar is shown, and `color.mid` is always
#' mapped to signal 0, including when `color.limits` are asymmetric.
#'
#' @param seg A `CNSegment` object, as returned by [sesame::cnSegmentation()].
#' @param genes An optional `GRanges` of gene coordinates. Genes overlapping a
#'   called segment are labeled on the plot at the segment they overlap the
#'   most (by overlap width).
#' @param id.col Name of the metadata column in `genes` holding the label to
#'   display (e.g. a gene symbol column). If `NULL`, `names(genes)` is used.
#' @param centromere An optional `GRanges` of per-chromosome centromere
#'   coordinates. When supplied, chromosome axis tick labels are placed at the
#'   centromere position rather than the chromosome midpoint.
#' @param to.plot An optional character vector of chromosome names (as found in
#'   `seqinfo(seg$bin.coords)`) to restrict the plot to. If `NULL` (the
#'   default), chromosomes representing at least 1% of the total genome length
#'   are shown (small scaffolds/contigs are dropped automatically).
#' @param hover.text.cols Character vector of `bin.coords` metadata column
#'   names to include in the point hover text (used when the returned plot is
#'   converted to `plotly`). Defaults to `"signal"`.
#' @param point.size Size of the bin-level points. Defaults to `1.5`.
#' @param point.alpha Opacity of the bin-level points, in `[0, 1]`. Defaults to
#'   `0.8`.
#' @param color.low Color for the low end of the signal color scale. Defaults
#'   to `"red"`.
#' @param color.mid Color for the midpoint (0) of the signal color scale.
#'   Defaults to `"grey"`.
#' @param color.high Color for the high end of the signal color scale.
#'   Defaults to `"green"`.
#' @param color.limits Length-2 numeric vector giving the `c(low, high)` limits
#'   of the signal color scale, or `NULL` to scale to the data range.
#'   The limits must include 0. Out-of-bound values are squished to the nearest
#'   limit. Defaults to `c(-0.4, 0.4)`.
#' @param color.seg Color of the segment mean line overlay. Defaults to
#'   `"blue"`.
#' @param seg.line.width Line width of the segment mean line overlay. Defaults
#'   to `1`.
#' @param label.size Text size of gene labels (only used when `genes` is
#'   supplied). Defaults to `3`.
#' @param y.min Optional lower limit for the y-axis (log2 signal ratio).
#'   Values below this limit are squished to the limit rather than dropped.
#'   `NULL` (the default) leaves the lower bound automatic.
#' @param y.max Optional upper limit for the y-axis. Values above this limit
#'   are squished to the limit rather than dropped. `NULL` (the default) leaves
#'   the upper bound automatic.
#'
#' @return A [plotly::plotly()] object. Gene labels are Plotly annotations and
#'   can be repositioned interactively.
#'
#' @importFrom methods is
#' @importFrom GenomicRanges seqinfo seqnames start end mcols
#' @import ggplot2
#' @importFrom plotly ggplotly add_annotations config
#' @importFrom scales squish
#' @importFrom stats setNames
#'
#' @export
#' @author Jared Andrews
#' @seealso [sesame::cnSegmentation()], [sciVizModules::cnSegmentPlotInputsUI()],
#' [sciVizModules::cnSegmentPlotServer()], [sciVizModules::cnSegmentPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_cn_segment)
#' data(example_cn_genes)
#' cnSegmentPlot(example_cn_segment, genes = example_cn_genes, id.col = "gene_name")
cnSegmentPlot <- function(seg,
                          genes = NULL,
                          id.col = NULL,
                          centromere = NULL,
                          to.plot = NULL,
                          hover.text.cols = "signal",
                          point.size = 1.5,
                          point.alpha = 0.8,
                          color.low = "red",
                          color.mid = "grey",
                          color.high = "green",
                          color.limits = c(-0.4, 0.4),
                          color.seg = "blue",
                          seg.line.width = 1,
                          label.size = 3,
                          y.min = NULL,
                          y.max = NULL) {
    stopifnot(is(seg, "CNSegment"))
    if (!is.null(color.limits)) {
        if (length(color.limits) != 2 || anyNA(color.limits) ||
            any(!is.finite(color.limits)) || color.limits[1] >= color.limits[2]) {
            stop("`color.limits` must be a finite, increasing numeric vector of length 2.")
        }
        if (color.limits[1] > 0 || color.limits[2] < 0) {
            stop("`color.limits` must include the fixed midpoint, 0.")
        }
    }

    bin.coords <- seg$bin.coords
    bin.signals <- seg$bin.signals
    sigs <- seg$seg.signals
    sigs$chrom <- as.character(sigs$chrom)

    bin.seqinfo <- seqinfo(bin.coords)
    total.length <- sum(as.numeric(bin.seqinfo@seqlengths), na.rm = TRUE)

    if (is.null(to.plot) || length(to.plot) == 0 || (length(to.plot) == 1 && !nzchar(to.plot))) {
        keep <- bin.seqinfo@seqlengths > total.length * 0.01
    } else {
        keep <- bin.seqinfo@seqnames %in% to.plot
    }
    if (!any(keep)) {
        stop("No chromosomes selected for plotting; check `to.plot`.")
    }

    seqlen <- as.numeric(bin.seqinfo@seqlengths[keep])
    seq.names <- bin.seqinfo@seqnames[keep]
    totlen <- sum(seqlen, na.rm = TRUE)
    seqcumlen <- cumsum(seqlen)
    seqstart <- setNames(c(0, seqcumlen[-length(seqcumlen)]), seq.names)

    bin.coords <- bin.coords[as.vector(seqnames(bin.coords)) %in% seq.names]
    bin.signals <- bin.signals[names(bin.coords)]

    # Genome-wide bin x-position and signal value. Matched by name (rather
    # than assigning into a logical-index subset) so every bin gets the
    # correct value even when only some bins have a signal.
    bin.coords$bin.mids <- (start(bin.coords) + end(bin.coords)) / 2
    bin.coords$bin.x <- seqstart[as.character(seqnames(bin.coords))] + bin.coords$bin.mids
    bin.coords$signal <- bin.signals[match(names(bin.coords), names(bin.signals))]

    # Chromosome tick label positions default to the chromosome midpoint, or
    # the centromere position (per chromosome) when supplied.
    seqmids <- seqstart + seqlen / 2
    if (!is.null(centromere) && length(centromere) > 0) {
        centromere <- centromere[as.vector(seqnames(centromere)) %in% seq.names]
        if (length(centromere) > 0) {
            cent.mid <- (start(centromere) + end(centromere)) / 2
            cent.chr <- as.character(seqnames(centromere))
            seqmids[cent.chr] <- seqstart[cent.chr] + cent.mid
        }
    }

    # Hover text (used when the plot is later converted to plotly).
    hover.text.cols <- intersect(hover.text.cols, names(mcols(bin.coords)))
    bin.coords$text <- if (length(hover.text.cols) > 0) {
        do.call(paste, c(
            lapply(hover.text.cols, function(n) {
                values <- mcols(bin.coords)[[n]]
                if (is.numeric(values)) values <- round(values, 4)
                paste0(n, ": ", values)
            }),
            list(sep = "\n")
        ))
    } else {
        NA_character_
    }

    df <- as.data.frame(bin.coords)

    p <- ggplot(df, aes(x = .data$bin.x / totlen, y = .data$signal, color = .data$signal, text = .data$text)) +
        geom_point(size = point.size, alpha = point.alpha)

    seg.beg <- (seqstart[sigs$chrom] + sigs$loc.start) / totlen
    seg.end <- (seqstart[sigs$chrom] + sigs$loc.end) / totlen
    keep.seg <- !is.na(seg.beg) & !is.na(seg.end)
    if (any(keep.seg)) {
        seg.df <- data.frame(
            x = seg.beg[keep.seg], xend = seg.end[keep.seg],
            y = sigs$seg.mean[keep.seg], yend = sigs$seg.mean[keep.seg]
        )
        p <- p + geom_segment(
            data = seg.df, aes(x = .data$x, xend = .data$xend, y = .data$y, yend = .data$yend),
            inherit.aes = FALSE, linewidth = seg.line.width, color = color.seg
        )
    }

    # Faint chromosome boundary reference lines.
    if (length(seqstart) > 1) {
        p <- p + geom_vline(xintercept = seqstart[-1] / totlen, color = "grey80", linewidth = 0.3)
    }

    p <- p +
        scale_x_continuous(labels = names(seqmids), breaks = as.numeric(seqmids) / totlen) +
        scale_colour_gradient2(
            name = "Log2 Signal Ratio",
            low = color.low, mid = color.mid, high = color.high,
            midpoint = 0, limits = color.limits, oob = squish
        ) +
        xlab("") +
        ylab("Log2 Signal Ratio") +
        theme_minimal() +
        theme(
            axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank()
        )

    if (!is.null(y.min) || !is.null(y.max)) {
        p <- p + scale_y_continuous(
            limits = c(
                if (is.null(y.min)) NA else y.min,
                if (is.null(y.max)) NA else y.max
            ),
            oob = squish
        )
    }

    label.df <- NULL
    if (!is.null(genes) && length(genes) > 0) {
        label.df <- .cn_seg_gene_label_data(
            genes = genes, id.col = id.col, sigs = sigs,
            seqstart = seqstart, totlen = totlen, seq.names = seq.names
        )
    }

    fig <- ggplotly(p, tooltip = "text")

    plotly.color.limits <- color.limits
    if (is.null(plotly.color.limits)) {
        plotly.color.limits <- range(df$signal, na.rm = TRUE)
        if (any(!is.finite(plotly.color.limits))) {
            plotly.color.limits <- c(-1, 1)
        } else {
            plotly.color.limits <- c(min(plotly.color.limits[1], 0), max(plotly.color.limits[2], 0))
        }
    }
    if (plotly.color.limits[1] == plotly.color.limits[2]) {
        plotly.color.limits <- c(-1, 1)
    }
    zero.position <- (0 - plotly.color.limits[1]) / diff(plotly.color.limits)
    plotly.colorscale <- matrix(c(
        0, color.low,
        zero.position, color.mid,
        1, color.high
    ), ncol = 2, byrow = TRUE)

    # ggplotly normalizes continuous colors to [0, 1]. Restore the raw signal
    # values so Plotly's colorbar and fixed zero midpoint remain meaningful.
    for (trace.idx in seq_along(fig$x$data)) {
        if (!is.null(fig$x$data[[trace.idx]]$marker$colorscale)) {
            fig$x$data[[trace.idx]]$marker$color <- fig$x$data[[trace.idx]]$y
            fig$x$data[[trace.idx]]$marker$cmin <- plotly.color.limits[1]
            fig$x$data[[trace.idx]]$marker$cmax <- plotly.color.limits[2]
            fig$x$data[[trace.idx]]$marker$cmid <- 0
            fig$x$data[[trace.idx]]$marker$colorscale <- plotly.colorscale
            fig$x$data[[trace.idx]]$marker$showscale <- TRUE
        }
    }

    if (!is.null(label.df) && nrow(label.df) > 0) {
        for (label.idx in seq_len(nrow(label.df))) {
            fig <- add_annotations(
                fig,
                x = label.df$x[label.idx], y = label.df$y[label.idx],
                text = label.df$label[label.idx],
                xref = "x", yref = "y", showarrow = FALSE,
                xanchor = "center", yanchor = "bottom",
                font = list(size = label.size * 3.78)
            )
        }
    }

    config(fig, edits = list(annotationPosition = TRUE, annotationText = TRUE))
}

.cn_seg_select_genes <- function(genes, id.col, label.genes) {
    if (is.null(genes) || length(genes) == 0 || is.null(label.genes) ||
        length(label.genes) == 0 || !nzchar(trimws(label.genes))) {
        return(NULL)
    }

    requested.genes <- unique(strsplit(trimws(label.genes), "[,[:space:]]+", perl = TRUE)[[1]])
    if (is.null(id.col)) {
        gene.labels <- names(genes)
    } else if (id.col %in% names(mcols(genes))) {
        gene.labels <- mcols(genes)[[id.col]]
    } else {
        stop("`id.col` '", id.col, "' not found in `genes` metadata columns.")
    }

    if (is.null(gene.labels)) {
        return(NULL)
    }
    genes[!is.na(gene.labels) & as.character(gene.labels) %in% requested.genes]
}

#' Compute gene-label positions for a copy number segment plot
#'
#' Internal helper for [cnSegmentPlot()]. Genes overlapping multiple segments
#' are assigned to the segment with the largest overlap.
#'
#' @param genes A `GRanges` of gene coordinates.
#' @param id.col Name of the metadata column in `genes` holding the label. If
#'   `NULL`, `names(genes)` is used.
#' @param sigs The `seg.signals` data.frame (`chrom`, `loc.start`, `loc.end`,
#'   `seg.mean` columns).
#' @param seqstart Named numeric vector of per-chromosome genome-wide offsets.
#' @param totlen Total genome length (sum of plotted chromosome lengths).
#' @param seq.names Character vector of chromosome names being plotted.
#'
#' @return A data frame containing annotation positions and labels, or `NULL`
#'   when no genes overlap the plotted segments.
#'
#' @importFrom GenomicRanges GRanges seqnames start end mcols width findOverlaps
#' @importFrom IRanges IRanges pintersect
#' @importFrom S4Vectors queryHits subjectHits
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_gene_label_data
#' @keywords internal
.cn_seg_gene_label_data <- function(genes, id.col, sigs, seqstart, totlen, seq.names) {
    genes <- genes[as.vector(seqnames(genes)) %in% seq.names]
    if (length(genes) == 0) {
        return(NULL)
    }

    if (is.null(id.col)) {
        gene.labels <- names(genes)
        if (is.null(gene.labels)) gene.labels <- as.character(seq_along(genes))
    } else if (id.col %in% names(mcols(genes))) {
        gene.labels <- as.character(mcols(genes)[[id.col]])
    } else {
        stop("`id.col` '", id.col, "' not found in `genes` metadata columns.")
    }

    sigs <- sigs[sigs$chrom %in% seq.names, , drop = FALSE]
    if (nrow(sigs) == 0) {
        return(NULL)
    }

    seg.gr <- GRanges(
        seqnames = sigs$chrom,
        ranges = IRanges(start = sigs$loc.start, end = sigs$loc.end)
    )

    hits <- findOverlaps(genes, seg.gr)
    if (length(hits) == 0) {
        return(NULL)
    }

    overlap.width <- width(pintersect(genes[queryHits(hits)], seg.gr[subjectHits(hits)]))

    # For genes overlapping multiple segments, keep only the largest overlap.
    best <- vapply(split(seq_along(hits), queryHits(hits)), function(idx) {
        idx[which.max(overlap.width[idx])]
    }, integer(1))

    gene.idx <- queryHits(hits)[best]
    seg.idx <- subjectHits(hits)[best]

    gene.mid <- (start(genes)[gene.idx] + end(genes)[gene.idx]) / 2
    gene.chr <- as.character(seqnames(genes))[gene.idx]
    data.frame(
        x = (seqstart[gene.chr] + gene.mid) / totlen,
        y = sigs$seg.mean[seg.idx],
        label = gene.labels[gene.idx],
        stringsAsFactors = FALSE
    )
}
