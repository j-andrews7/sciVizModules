#' Plot DNA methylation array-based copy number segmentation
#'
#' Draws a genome-wide copy number scatter/segment plot from the output of
#' [sesame::cnSegmentation()]: bin-level log2 signal ratios are plotted across
#' the genome and colored by signal, with the called segment means overlaid as
#' horizontal line segments. Genes overlapping each bin (`bin.coords$genes`) are
#' surfaced in the point hover text, and selected genes can additionally be
#' labeled with draggable Plotly annotations.
#'
#' @details `seg` must be a `CNSegment` object as returned by
#' [sesame::cnSegmentation()], a list with (at least) `bin.coords` (a
#' `GRanges` of genomic bins with associated `seqinfo`), `bin.signals` (a named
#' numeric vector of per-bin log2 signal ratios), and `seg.signals` (a
#' `data.frame` of called segments with `chrom`, `loc.start`, `loc.end`, and
#' `seg.mean` columns).
#'
#' Chromosome tick and dashed-guide positions are derived from
#' `seg$genomeInfo$cytoBand` (see `centromere`), and gene labels from
#' `seg$genomeInfo$genes` (see `genes`). Genes overlapping each plotted bin are
#' read from the `bin.coords$genes` metadata column when present.
#'
#' Both the color scale and the y-axis support explicit limits
#' (`color.limits` and `y.min`/`y.max`, respectively). In both cases,
#' out-of-bound values are squished to the nearest limit (via
#' [scales::squish()]) rather than dropped, so points beyond the requested
#' limits remain visible (clamped to the edge of the plot/color scale) instead
#' of disappearing. The signal colorbar is shown, and `color.zero` is always
#' mapped to signal 0, including when `color.limits` are asymmetric.
#'
#' @param seg A `CNSegment` object, as returned by [sesame::cnSegmentation()].
#' @param genes An optional `GRanges` of gene coordinates. Each gene is matched
#'   to the plotted bin it overlaps most; its identifier is added to that bin's
#'   hover text and shown in an arrowed annotation.
#' @param id.col Name of the metadata column in `genes` holding the label to
#'   display (e.g. a gene symbol column). If `NULL`, `names(genes)` is used.
#' @param centromere An optional `GRanges` of per-chromosome centromere
#'   coordinates used to place chromosome axis ticks and dashed guides. When
#'   `NULL` (the default), centromere positions are derived from
#'   `seg$genomeInfo$cytoBand` (the end of each chromosome's p-arm `"acen"`
#'   band, i.e. the p/q boundary); if that information is unavailable,
#'   chromosome midpoints are used.
#' @param to.plot An optional character vector of chromosome names (as found in
#'   `seqinfo(seg$bin.coords)`) to restrict the plot to. If `NULL` (the
#'   default), chromosomes representing at least 1% of the total genome length
#'   are shown (small scaffolds/contigs are dropped automatically).
#' @param hover.text.cols Character vector of `bin.coords` metadata column
#'   names to include in the point hover text (used when the returned plot is
#'   converted to `plotly`). Defaults to `c("signal", "genes")`; columns that
#'   are absent from `bin.coords` are ignored.
#' @param point.size Size of the bin-level points. Defaults to `1.5`.
#' @param point.alpha Opacity of the bin-level points, in `[0, 1]`. Defaults to
#'   `0.8`.
#' @param color.low Color for the low end of the signal color scale. Defaults
#'   to `"red"`.
#' @param color.zero Color for the 0 point of the signal color scale.
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
#' @param centromere.color Color of the centromere guide lines. Defaults to
#'   `"grey70"`.
#' @param centromere.width Line width of the centromere guide lines. Defaults
#'   to `0.3`.
#' @param centromere.linetype Line type of the centromere guide lines (e.g.
#'   `"dashed"`, `"solid"`, `"dotted"`). Defaults to `"dashed"`.
#' @param border.color Color of the chromosome boundary lines. Defaults to
#'   `"grey80"`.
#' @param border.width Line width of the chromosome boundary lines. Defaults to
#'   `0.3`.
#' @param border.linetype Line type of the chromosome boundary lines. Defaults
#'   to `"solid"`.
#' @param label.size Plotly font size of gene labels (only used when `genes` is
#'   supplied). Defaults to `10`.
#' @param y.min Optional lower limit for the y-axis (log2 signal ratio).
#'   Values below this limit are squished to the limit rather than dropped.
#'   `NULL` (the default) leaves the lower bound automatic.
#' @param y.max Optional upper limit for the y-axis. Values above this limit
#'   are squished to the limit rather than dropped. `NULL` (the default) leaves
#'   the upper bound automatic.
#' @param main Optional plot title. `NULL` (the default) or an empty string
#'   leaves the plot untitled.
#'
#' @return A [plotly::plotly()] object. Gene labels are Plotly annotations and
#'   can be repositioned interactively.
#'
#' @importFrom methods is
#' @importFrom GenomicRanges start end mcols
#' @importFrom Seqinfo seqinfo seqlengths seqnames
#' @importFrom ggplot2 .data ggplot aes geom_point geom_segment geom_vline
#' @importFrom ggplot2 scale_x_continuous scale_y_continuous scale_colour_gradient2
#' @importFrom ggplot2 theme_minimal theme element_text element_blank xlab ylab ggtitle
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
#' # Gene labels are drawn from the object's own gene annotation:
#' cnSegmentPlot(example_cn_segment,
#'     genes = example_cn_segment$genomeInfo$genes, id.col = "gene_name")
cnSegmentPlot <- function(seg,
                          genes = NULL,
                          id.col = NULL,
                          centromere = NULL,
                          to.plot = NULL,
                          hover.text.cols = c("signal", "genes"),
                          point.size = 1.5,
                          point.alpha = 0.8,
                          color.low = "red",
                          color.zero = "grey",
                          color.high = "green",
                          color.limits = c(-0.4, 0.4),
                          color.seg = "blue",
                          seg.line.width = 1,
                          centromere.color = "grey70",
                          centromere.width = 0.3,
                          centromere.linetype = "dashed",
                          border.color = "grey80",
                          border.width = 0.3,
                          border.linetype = "solid",
                          label.size = 10,
                          y.min = NULL,
                          y.max = NULL,
                          main = NULL) {
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
    total.length <- sum(as.numeric(seqlengths(bin.seqinfo)), na.rm = TRUE)

    if (is.null(to.plot) || length(to.plot) == 0 || (length(to.plot) == 1 && !nzchar(to.plot))) {
        keep <- seqlengths(bin.seqinfo) > total.length * 0.01
    } else {
        keep <- seqnames(bin.seqinfo) %in% to.plot
    }
    if (!any(keep)) {
        stop("No chromosomes selected for plotting; check `to.plot`.")
    }

    seqlen <- as.numeric(seqlengths(bin.seqinfo)[keep])
    seq.names <- seqnames(bin.seqinfo)[keep]
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

    label.df <- NULL
    bin.coords$gene_label <- NA_character_
    if (!is.null(genes) && length(genes) > 0) {
        label.df <- .cn_seg_gene_bin_data(
            genes = genes, id.col = id.col, bin.coords = bin.coords,
            totlen = totlen, seq.names = seq.names
        )
        if (!is.null(label.df) && nrow(label.df) > 0) {
            bin.coords$gene_label[label.df$bin.index] <- label.df$label
        }
    }

    # Chromosome tick label positions default to the chromosome midpoint, or
    # the centromere position (per chromosome) when available. When not passed
    # explicitly, centromeres are read from the object's cytoBand information.
    seqmids <- seqstart + seqlen / 2
    if (is.null(centromere)) {
        centromere <- .cn_seg_centromeres(seg)
    }
    if (!is.null(centromere) && length(centromere) > 0) {
        centromere <- centromere[as.vector(seqnames(centromere)) %in% seq.names]
        if (length(centromere) > 0) {
            cent.chr <- as.character(seqnames(centromere))
            cent.mid <- vapply(split(seq_along(centromere), cent.chr), function(idx) {
                (min(start(centromere)[idx]) + max(end(centromere)[idx])) / 2
            }, numeric(1))
            seqmids[names(cent.mid)] <- seqstart[names(cent.mid)] + cent.mid
        }
    }

    # Hover text, with selected genes added only to their matched bins. List
    # columns (e.g. the per-bin `genes` overlaps) render each entry on its own
    # line so long gene sets stay readable.
    hover.text.cols <- intersect(hover.text.cols, names(mcols(bin.coords)))
    bin.coords$text <- if (length(hover.text.cols) > 0) {
        do.call(paste, c(
            lapply(hover.text.cols, function(n) {
                values <- mcols(bin.coords)[[n]]
                if (is.list(values) || is(values, "List")) {
                    values <- vapply(as.list(values), function(v) {
                        v <- as.character(v)
                        v <- v[!is.na(v) & nzchar(v)]
                        if (length(v) == 0) "" else paste(v, collapse = "<br>")
                    }, character(1))
                } else if (is.numeric(values)) {
                    values <- round(values, 4)
                }
                paste0("<b>", n, ":</b> ", values)
            }),
            list(sep = "<br>")
        ))
    } else {
        rep("", length(bin.coords))
    }
    labeled.bins <- !is.na(bin.coords$gene_label)
    if (any(labeled.bins)) {
        gene.field <- if (is.null(id.col)) "gene" else id.col
        prefix <- ifelse(nzchar(bin.coords$text[labeled.bins]), "<br>", "")
        bin.coords$text[labeled.bins] <- paste0(
            bin.coords$text[labeled.bins], prefix,
            "<b>", gene.field, ":</b> ", bin.coords$gene_label[labeled.bins]
        )
    }

    # Build the plotting frame directly from the columns ggplot needs; this
    # keeps list-type metadata (e.g. the per-bin `genes` overlaps, already
    # encoded into `text`) out of the flat data frame.
    df <- data.frame(
        bin.x = bin.coords$bin.x,
        signal = bin.coords$signal,
        text = bin.coords$text,
        stringsAsFactors = FALSE
    )

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
        p <- p + geom_vline(
            xintercept = seqstart[-1] / totlen,
            color = border.color, linewidth = border.width, linetype = border.linetype
        )
    }
    p <- p + geom_vline(
        xintercept = as.numeric(seqmids) / totlen,
        linetype = centromere.linetype, color = centromere.color,
        alpha = 0.6, linewidth = centromere.width
    )

    p <- p +
        scale_x_continuous(
            labels = names(seqmids),
            breaks = as.numeric(seqmids) / totlen,
            expand = c(0,0)
        ) +
        scale_colour_gradient2(
            name = "Log2 Signal Ratio",
            low = color.low, mid = color.zero, high = color.high,
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
            oob = squish,
            expand = c(0,0)
        )
    }

    if (!is.null(main) && length(main) == 1 && !is.na(main) && nzchar(main)) {
        p <- p + ggtitle(main)
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
        zero.position, color.zero,
        1, color.high
    ), ncol = 2, byrow = TRUE)

    color.trace.idx <- which(vapply(fig$x$data, function(trace) {
        !is.null(trace$marker$colorscale)
    }, logical(1)))

    point.trace.idx <- which(vapply(fig$x$data, function(trace) {
        identical(trace$mode, "markers") && length(trace$y) > 1
    }, logical(1)))[1]

    if (length(point.trace.idx) == 1 && !is.na(point.trace.idx)) {
        colorbar <- if (length(color.trace.idx) > 0) {
            fig$x$data[[color.trace.idx[1]]]$marker$colorbar
        } else {
            list()
        }
        tickvals <- pretty(plotly.color.limits, n = 5)
        tickvals <- tickvals[tickvals >= plotly.color.limits[1] & tickvals <= plotly.color.limits[2]]
        colorbar$title <- "Log2 Signal Ratio"
        colorbar$tickmode <- "array"
        colorbar$tickvals <- tickvals
        colorbar$ticktext <- format(tickvals, trim = TRUE)

        fig$x$data[[point.trace.idx]]$marker$color <- fig$x$data[[point.trace.idx]]$y
        fig$x$data[[point.trace.idx]]$marker$cmin <- plotly.color.limits[1]
        fig$x$data[[point.trace.idx]]$marker$cmax <- plotly.color.limits[2]
        fig$x$data[[point.trace.idx]]$marker$cmid <- 0
        fig$x$data[[point.trace.idx]]$marker$colorscale <- plotly.colorscale
        fig$x$data[[point.trace.idx]]$marker$showscale <- TRUE
        fig$x$data[[point.trace.idx]]$marker$colorbar <- colorbar

        if (length(color.trace.idx) > 0) {
            fig$x$data[color.trace.idx] <- NULL
        }
    }

    if (!is.null(label.df) && nrow(label.df) > 0) {
        for (label.idx in seq_len(nrow(label.df))) {
            fig <- add_annotations(
                fig,
                x = label.df$x[label.idx], y = label.df$y[label.idx],
                text = label.df$label[label.idx],
                xref = "x", yref = "y", showarrow = TRUE,
                arrowhead = 4, arrowsize = 0.5,
                ax = 20, ay = if (label.df$y[label.idx] >= 0) -30 else 30,
                font = list(size = label.size)
            )
        }
    }

    fig <- config(fig, edits = list(
        annotationPosition = TRUE, annotationText = TRUE, annotationTail = TRUE
    )) |> toWebGL()

    fig
}

#' Derive centromere positions from a CNSegment's cytoBand
#'
#' Internal helper for [cnSegmentPlot()]. Extracts one centromere position per
#' chromosome from `seg$genomeInfo$cytoBand`, using the end of each
#' chromosome's p-arm `"acen"` band (the p/q boundary). The `"acen"` stain
#' marks the two centromere-flanking bands; the p-arm band's end is the
#' position drawn on the plot.
#'
#' @param seg A `CNSegment` object. `seg$genomeInfo$cytoBand` is expected to be
#'   a `data.frame` with `chrom`, `chromStart`, `chromEnd`, `name`, and
#'   `gieStain` columns (as bundled by sesameData).
#'
#' @return A `GRanges` of width-1 centromere positions (one per chromosome that
#'   has a p-arm `"acen"` band), or `NULL` when no usable `cytoBand` is present.
#'
#' @importFrom GenomicRanges GRanges
#' @importFrom IRanges IRanges
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_centromeres
#' @keywords internal
.cn_seg_centromeres <- function(seg) {
    cyto <- seg$genomeInfo$cytoBand
    required.cols <- c("chrom", "chromStart", "chromEnd", "name", "gieStain")
    if (is.null(cyto) || !is.data.frame(cyto) || nrow(cyto) == 0 ||
        !all(required.cols %in% names(cyto))) {
        return(NULL)
    }

    acen <- cyto[!is.na(cyto$gieStain) & cyto$gieStain == "acen", , drop = FALSE]
    # Keep only the p-arm band; its end marks the centromere (p/q boundary).
    p.arm <- acen[startsWith(as.character(acen$name), "p"), , drop = FALSE]
    if (nrow(p.arm) == 0) {
        return(NULL)
    }

    # One position per chromosome; if a chromosome has multiple p-arm acen
    # bands, use the largest end.
    p.end <- vapply(split(p.arm$chromEnd, as.character(p.arm$chrom)), max, numeric(1))
    GRanges(
        seqnames = names(p.end),
        ranges = IRanges(start = as.integer(p.end), width = 1)
    )
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

#' Match genes to plotted copy number bins
#'
#' Internal helper for [cnSegmentPlot()]. Each gene is assigned to its plotted
#' bin with the largest overlap so annotations point to observed bin signals.
#'
#' @param genes A `GRanges` of gene coordinates.
#' @param id.col Name of the metadata column in `genes` holding the label. If
#'   `NULL`, `names(genes)` is used.
#' @param bin.coords A `GRanges` of plotted bins with `bin.x` and `signal`
#'   metadata columns.
#' @param totlen Total genome length (sum of plotted chromosome lengths).
#' @param seq.names Character vector of chromosome names being plotted.
#'
#' @return A data frame containing bin indices, annotation positions, and
#'   labels, or `NULL` when no genes overlap plotted bins with signal values.
#'
#' @importFrom GenomicRanges GRanges seqnames start end mcols width findOverlaps
#' @importFrom IRanges IRanges pintersect
#' @importFrom S4Vectors queryHits subjectHits
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_gene_bin_data
#' @keywords internal
.cn_seg_gene_bin_data <- function(genes, id.col, bin.coords, totlen, seq.names) {
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

    hits <- findOverlaps(genes, bin.coords)
    hits <- hits[is.finite(bin.coords$signal[subjectHits(hits)])]
    if (length(hits) == 0) {
        return(NULL)
    }

    overlap.width <- width(pintersect(genes[queryHits(hits)], bin.coords[subjectHits(hits)]))

    # For genes overlapping multiple segments, keep only the largest overlap.
    best <- vapply(split(seq_along(hits), queryHits(hits)), function(idx) {
        idx[which.max(overlap.width[idx])]
    }, integer(1))

    gene.idx <- queryHits(hits)[best]
    bin.idx <- subjectHits(hits)[best]
    matched <- data.frame(
        bin.index = bin.idx,
        x = bin.coords$bin.x[bin.idx] / totlen,
        y = bin.coords$signal[bin.idx],
        label = gene.labels[gene.idx],
        stringsAsFactors = FALSE
    )

    grouped <- split(seq_len(nrow(matched)), matched$bin.index)
    do.call(rbind, lapply(grouped, function(idx) {
        data.frame(
            bin.index = matched$bin.index[idx[1]],
            x = matched$x[idx[1]],
            y = matched$y[idx[1]],
            label = paste(unique(matched$label[idx]), collapse = ", "),
            stringsAsFactors = FALSE
        )
    }))
}
