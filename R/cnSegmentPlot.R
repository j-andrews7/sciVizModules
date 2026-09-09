#' Plot DNA methylation array-based copy number segmentation
#'
#' Draws a genome-wide copy number scatter/segment plot from the output of
#' [sesame::cnSegmentation()]: bin-level log2 signal ratios are plotted across
#' the genome and colored by signal, with the called segment means overlaid as
#' horizontal line segments. Genes overlapping each bin (`bin.coords$genes`) are
#' surfaced in the point hover text, and selected genes can additionally be
#' labeled with draggable Plotly annotations. Several samples can be compared at
#' once by passing a list of `CNSegment` objects, which are stacked vertically
#' over a single shared genomic x-axis.
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
#' @section Multiple samples: A `CNSegment` object holds a single sample. To
#' compare several, pass a (preferably named) list of them; each becomes one
#' panel, stacked vertically in the order supplied with the first sample on
#' top. Panel names are taken from `names(seg)`, falling back to the
#' `seg.signals$ID` column and then to `"Sample <i>"`.
#'
#' All panels share one genomic x-axis, built from the union of the samples'
#' `seqinfo`, so a locus lines up vertically across the whole stack: chromosome
#' tick labels are drawn once beneath the bottom panel, and the chromosome
#' boundary and centromere guide lines run through every panel. Samples must
#' agree on their chromosome lengths (i.e. share a genome build); an error is
#' raised otherwise.
#'
#' Gene labels are shared too. Rather than one arrowed annotation per panel,
#' each requested gene is labeled once above the top panel, with a vertical
#' guide line (see `gene.line.color` and friends) descending through the stack
#' at that gene's position. With a single sample the labels stay anchored to
#' their bin with an arrow, as before.
#'
#' By default every panel shares one y-axis so peak heights are directly
#' comparable; set `free.y = TRUE` to let each sample scale independently.
#'
#' @section Limits: Both the color scale and the y-axis support explicit limits
#' (`color.limits` and `y.min`/`y.max`, respectively). In both cases,
#' out-of-bound values are squished to the nearest limit (via
#' [scales::squish()]) rather than dropped, so points beyond the requested
#' limits remain visible (clamped to the edge of the plot/color scale) instead
#' of disappearing. The signal colorbar is shown once, and `color.zero` is
#' always mapped to signal 0, including when `color.limits` are asymmetric.
#'
#' @param seg A `CNSegment` object, as returned by [sesame::cnSegmentation()],
#'   or a named list of them to stack several samples vertically over a shared
#'   genomic x-axis. See the "Multiple samples" section.
#' @param genes An optional `GRanges` of gene coordinates. Each gene is matched
#'   to the plotted bin it overlaps most; its identifier is added to that bin's
#'   hover text and labeled on the plot -- with an arrow pointing at the bin for
#'   a single sample, or once above the stack for several (see the "Multiple
#'   samples" section).
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
#' @param gene.line.color Color of the vertical gene guide lines drawn through
#'   every panel when several samples are stacked. Defaults to `"grey40"`.
#'   Unused with a single sample, which anchors its labels with arrows instead.
#' @param gene.line.width Line width of the gene guide lines. Defaults to `0.3`;
#'   use `0` to suppress them.
#' @param gene.line.linetype Line type of the gene guide lines. Defaults to
#'   `"dotted"`.
#' @param panel.border.color Color of the border drawn around each panel when
#'   several samples are stacked. Defaults to `"black"`.
#' @param panel.border.width Width of the per-panel border. Defaults to `0.5`;
#'   use `0` to suppress it.
#' @param panel.border.mirror Logical; when `TRUE` (the default) each panel gets
#'   a complete rectangle. When `FALSE`, only its left and bottom edges are
#'   drawn.
#' @param label.size Plotly font size of gene labels (only used when `genes` is
#'   supplied). Defaults to `10`.
#' @param free.y Logical; when `TRUE`, each stacked sample gets its own
#'   automatically scaled y-axis instead of a single shared one, and `y.min` /
#'   `y.max` are ignored. Has no effect with a single sample. Defaults to
#'   `FALSE`.
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
#' @importFrom ggplot2 facet_grid vars
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
#'
#' # Several samples are stacked over a shared genomic x-axis:
#' noisy <- example_cn_segment
#' noisy$bin.signals <- noisy$bin.signals + 0.2
#' cnSegmentPlot(list(Tumor = example_cn_segment, Reference = noisy))
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
                          gene.line.color = "grey40",
                          gene.line.width = 0.3,
                          gene.line.linetype = "dotted",
                          panel.border.color = "black",
                          panel.border.width = 0.5,
                          panel.border.mirror = TRUE,
                          label.size = 10,
                          free.y = FALSE,
                          y.min = NULL,
                          y.max = NULL,
                          main = NULL) {
    seg.list <- .cn_seg_as_list(seg)
    sample.names <- names(seg.list)
    multi <- length(seg.list) > 1L
    if (!is.null(color.limits)) {
        if (length(color.limits) != 2 || anyNA(color.limits) ||
            any(!is.finite(color.limits)) || color.limits[1] >= color.limits[2]) {
            stop("`color.limits` must be a finite, increasing numeric vector of length 2.")
        }
        if (color.limits[1] > 0 || color.limits[2] < 0) {
            stop("`color.limits` must include the fixed midpoint, 0.")
        }
    }

    # One genomic coordinate system for every panel: chromosome offsets are
    # derived from the union of the samples' seqinfo (which must agree), so a
    # locus maps to the same x position in every panel of the stack.
    seqlen.all <- .cn_seg_shared_seqlengths(seg.list)
    total.length <- sum(as.numeric(seqlen.all), na.rm = TRUE)

    if (is.null(to.plot) || length(to.plot) == 0 || (length(to.plot) == 1 && !nzchar(to.plot))) {
        keep <- !is.na(seqlen.all) & seqlen.all > total.length * 0.01
    } else {
        keep <- names(seqlen.all) %in% to.plot
    }
    if (!any(keep)) {
        stop("No chromosomes selected for plotting; check `to.plot`.")
    }

    seqlen <- as.numeric(seqlen.all[keep])
    seq.names <- names(seqlen.all)[keep]
    totlen <- sum(seqlen, na.rm = TRUE)
    seqcumlen <- cumsum(seqlen)
    seqstart <- setNames(c(0, seqcumlen[-length(seqcumlen)]), seq.names)

    # Per-sample points, segment means, and gene/bin matches, all placed on the
    # shared coordinate system above.
    panels <- lapply(seg.list, .cn_seg_panel_data,
        seq.names = seq.names, seqstart = seqstart, totlen = totlen,
        hover.text.cols = hover.text.cols, genes = genes, id.col = id.col
    )

    add_sample <- function(d, i) {
        if (is.null(d) || nrow(d) == 0) {
            return(NULL)
        }
        if (multi) d$sample <- factor(sample.names[i], levels = sample.names)
        d
    }
    df <- do.call(rbind, lapply(seq_along(panels), function(i) add_sample(panels[[i]]$df, i)))
    seg.df <- do.call(rbind, lapply(seq_along(panels), function(i) add_sample(panels[[i]]$seg.df, i)))

    if (multi) {
        # Genes are labeled once for the whole stack, so collect the union of
        # the per-sample matches; a gene missing from one sample's usable bins
        # is still labeled from whichever sample did match it.
        label.df <- do.call(rbind, lapply(panels, `[[`, "label.df"))
        if (!is.null(label.df) && nrow(label.df) > 0) {
            label.df <- label.df[!duplicated(label.df$label), , drop = FALSE]
        }
    } else {
        label.df <- panels[[1]]$label.df
    }

    # Chromosome tick label positions default to the chromosome midpoint, or
    # the centromere position (per chromosome) when available. When not passed
    # explicitly, centromeres are read from the objects' cytoBand information,
    # using the first sample that carries usable bands.
    seqmids <- seqstart + seqlen / 2
    if (is.null(centromere)) {
        for (one.seg in seg.list) {
            centromere <- .cn_seg_centromeres(one.seg)
            if (!is.null(centromere) && length(centromere) > 0) break
        }
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

    p <- ggplot(df, aes(x = .data$bin.x / totlen, y = .data$signal, color = .data$signal, text = .data$text)) +
        geom_point(size = point.size, alpha = point.alpha)

    if (!is.null(seg.df) && nrow(seg.df) > 0) {
        p <- p + geom_segment(
            data = seg.df, aes(x = .data$x, xend = .data$xend, y = .data$y, yend = .data$yend),
            inherit.aes = FALSE, linewidth = seg.line.width, color = color.seg
        )
    }

    # Reference lines carry no `sample` column, so ggplot repeats them in every
    # panel of the stack -- which is exactly what keeps the chromosome and
    # centromere guides aligned across samples.
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

    # With several samples the gene labels sit above the stack rather than on a
    # single panel's points, so a guide line ties each label to its locus in
    # every sample.
    if (multi && !is.null(label.df) && nrow(label.df) > 0 && isTRUE(gene.line.width > 0)) {
        p <- p + geom_vline(
            xintercept = label.df$x,
            color = gene.line.color, linewidth = gene.line.width,
            linetype = gene.line.linetype
        )
    }

    if (multi) {
        p <- p + facet_grid(
            rows = vars(.data$sample),
            scales = if (isTRUE(free.y)) "free_y" else "fixed"
        )
    }

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

    if (!isTRUE(free.y) && (!is.null(y.min) || !is.null(y.max))) {
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

    # Faceting yields one point trace per panel; each needs the same colorscale,
    # but only the first carries the (single, shared) colorbar. The dummy trace
    # ggplotly adds to draw the guide is excluded here and dropped below.
    point.trace.idx <- which(vapply(fig$x$data, function(trace) {
        identical(trace$mode, "markers") && length(trace$y) > 1
    }, logical(1)))
    point.trace.idx <- setdiff(point.trace.idx, color.trace.idx)

    if (length(point.trace.idx) > 0) {
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

        for (trace.n in seq_along(point.trace.idx)) {
            idx <- point.trace.idx[trace.n]
            fig$x$data[[idx]]$marker$color <- fig$x$data[[idx]]$y
            fig$x$data[[idx]]$marker$cmin <- plotly.color.limits[1]
            fig$x$data[[idx]]$marker$cmax <- plotly.color.limits[2]
            fig$x$data[[idx]]$marker$cmid <- 0
            fig$x$data[[idx]]$marker$colorscale <- plotly.colorscale
            fig$x$data[[idx]]$marker$showscale <- trace.n == 1L
            if (trace.n == 1L) {
                fig$x$data[[idx]]$marker$colorbar <- colorbar
            }
        }

        if (length(color.trace.idx) > 0) {
            fig$x$data[color.trace.idx] <- NULL
        }
    }

    if (!is.null(label.df) && nrow(label.df) > 0) {
        for (label.idx in seq_len(nrow(label.df))) {
            fig <- if (multi) {
                # Shared across the stack: rotated above the top panel, anchored
                # to the (common) data x-axis but to the paper in y, with the
                # guide line drawn above tying it to every sample.
                add_annotations(
                    fig,
                    x = label.df$x[label.idx], y = 1,
                    text = label.df$label[label.idx],
                    xref = "x", yref = "paper", showarrow = FALSE,
                    xanchor = "center", yanchor = "bottom",
                    textangle = -90, yshift = 4,
                    font = list(size = label.size)
                )
            } else {
                add_annotations(
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
    }

    if (multi) {
        fig <- .cn_seg_tag_axis_title(fig, "Log2 Signal Ratio")

        # ggplotly anchors the single shared x-axis to the bottom panel, so axis
        # lines alone box only that panel and leave the ones above it open at the
        # top and bottom. Draw an explicit rectangle per panel instead, appending
        # to the shapes ggplotly already uses for the facet strip backgrounds.
        if (isTRUE(panel.border.width > 0)) {
            fig$x$layout$shapes <- c(
                fig$x$layout$shapes,
                build_facet_panel_borders(
                    fig,
                    n_facets = length(seg.list),
                    showline = TRUE, mirror = isTRUE(panel.border.mirror),
                    linecolor = panel.border.color, linewidth = panel.border.width,
                    ncol = 1, nrow = length(seg.list)
                )
            )
        }
    }

    fig <- config(fig, edits = list(
        annotationPosition = TRUE, annotationText = TRUE, annotationTail = TRUE
    )) |> toWebGL()

    fig
}

#' Normalize the `seg` argument to a named list of CNSegment objects
#'
#' Internal helper for [cnSegmentPlot()] and its module. A `CNSegment` holds a
#' single sample, so multi-sample plots are driven by a list of them. This
#' accepts either form and always returns a named list, so callers can treat
#' the single-sample case as a stack of one.
#'
#' Panel names come from `names(seg)` where supplied, falling back per element
#' to the `seg.signals$ID` column (which [sesame::cnSegmentation()] populates)
#' and then to a positional `"Sample <i>"`. Names are made unique.
#'
#' @param seg A `CNSegment` object or a list of them.
#'
#' @return A named list of `CNSegment` objects.
#'
#' @importFrom methods is
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_as_list
#' @keywords internal
.cn_seg_as_list <- function(seg) {
    if (is(seg, "CNSegment")) {
        seg.list <- list(seg)
    } else if (is.list(seg) && length(seg) > 0) {
        seg.list <- seg
    } else {
        stop("`seg` must be a `CNSegment` object or a non-empty list of `CNSegment` objects.")
    }

    is.cn <- vapply(seg.list, function(x) is(x, "CNSegment"), logical(1))
    if (!all(is.cn)) {
        stop(
            "`seg` must be a `CNSegment` object or a list of `CNSegment` objects; ",
            "element(s) ", paste(which(!is.cn), collapse = ", "), " are not."
        )
    }

    seg.names <- names(seg.list)
    if (is.null(seg.names)) {
        seg.names <- rep(NA_character_, length(seg.list))
    }
    seg.names[is.na(seg.names) | !nzchar(seg.names)] <- NA_character_

    unnamed <- which(is.na(seg.names))
    for (i in unnamed) {
        id <- unique(as.character(seg.list[[i]]$seg.signals$ID))
        id <- id[!is.na(id) & nzchar(id)]
        seg.names[i] <- if (length(id) == 1L) id else paste("Sample", i)
    }

    names(seg.list) <- make.unique(seg.names)
    seg.list
}


#' Built-in input defaults for the cnSegmentPlot module
#'
#' Internal helper shared by [cnSegmentPlotInputsUI()] and
#' [cnSegmentPlotServer()], which must fall back to the same values when
#' building and when resetting the controls. It lives here so the two stay in
#' step.
#'
#' @return A named list of default input values.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_base_defaults
#' @keywords internal
.cn_seg_base_defaults <- function() {
    list(
        label.genes = paste(
            "TP53, EGFR, MYC, TERT, PTCH1, MGMT, CCNE1, KRAS, CDK4, CDK6, CCND1, CCND2,",
            "FGFR1, PDGFRA, RB1, MYCN, MDM4, GLI2, MYB, CDKN2A, PTEN, MDM2, NF1, PPM1D,",
            "NF2, SMARCB1"
        ),
        label.size = 10,
        show.grid.x = FALSE,
        show.grid.y = FALSE,
        # The real input id is `margin.t`; the extra headroom over the uniform
        # default leaves room for the gene labels above a stacked plot.
        margin.t = 90,
        hline.intercepts = "0",
        hline.colors = "#adadad",
        hline.widths = "1",
        hline.linetypes = "solid",
        axis.tickangle.x = -45
    )
}


#' Shared input choices for the cnSegmentPlot module
#'
#' Internal helpers shared by [cnSegmentPlotInputsUI()] and
#' [cnSegmentPlotServer()], which must offer the same choices when building and
#' when resetting the controls.
#'
#' `.cn_seg_genes()` returns the gene annotation of the first sample that has
#' one -- gene labels are shared across the stack, so a single annotation drives
#' every panel. `.cn_seg_seq_choices()` returns the standard chromosomes found
#' across the samples, and `.cn_seg_hover_choices()` the union of their bin
#' metadata column names.
#'
#' @param seg.list A named list of `CNSegment` objects, from
#'   [.cn_seg_as_list()].
#'
#' @return A `GRanges` (or `NULL`) for `.cn_seg_genes()`, otherwise a character
#'   vector of input choices.
#'
#' @importFrom GenomicRanges mcols
#' @importFrom Seqinfo seqinfo seqlengths
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_choices
#' @keywords internal
.cn_seg_genes <- function(seg.list) {
    for (one.seg in seg.list) {
        genes <- one.seg$genomeInfo$genes
        if (!is.null(genes) && length(genes) > 0) {
            return(genes)
        }
    }
    NULL
}


#' @rdname INTERNAL_cn_seg_choices
.cn_seg_seq_choices <- function(seg.list) {
    standard <- c(paste0("chr", seq_len(22)), "chrX", "chrY")
    found <- unique(unlist(lapply(seg.list, function(one.seg) {
        names(seqlengths(seqinfo(one.seg$bin.coords)))
    }), use.names = FALSE))
    standard[standard %in% found]
}


#' @rdname INTERNAL_cn_seg_choices
.cn_seg_hover_choices <- function(seg.list) {
    cols <- unique(unlist(lapply(seg.list, function(one.seg) {
        names(mcols(one.seg$bin.coords))
    }), use.names = FALSE))
    union(cols, "signal")
}


#' Merge chromosome lengths across CNSegment samples
#'
#' Internal helper for [cnSegmentPlot()]. Stacked samples must share one set of
#' chromosome offsets for their x-axes to line up, so this merges the samples'
#' `seqlengths` into a single named vector: the first sample's `seqinfo` order,
#' with any chromosomes only later samples define appended.
#'
#' @param seg.list A named list of `CNSegment` objects, from
#'   [.cn_seg_as_list()].
#'
#' @return A named numeric vector of chromosome lengths.
#'
#' @importFrom Seqinfo seqinfo seqlengths
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_shared_seqlengths
#' @keywords internal
.cn_seg_shared_seqlengths <- function(seg.list) {
    lens <- seqlengths(seqinfo(seg.list[[1]]$bin.coords))
    if (length(seg.list) == 1L) {
        return(lens)
    }

    for (i in seq_along(seg.list)[-1]) {
        other <- seqlengths(seqinfo(seg.list[[i]]$bin.coords))
        shared <- intersect(names(lens), names(other))
        mismatched <- shared[
            !is.na(lens[shared]) & !is.na(other[shared]) & lens[shared] != other[shared]
        ]
        if (length(mismatched) > 0) {
            stop(
                "Samples must share a genome build to be plotted together: '",
                names(seg.list)[i], "' and '", names(seg.list)[1],
                "' disagree on the length of ",
                paste(mismatched[seq_len(min(3L, length(mismatched)))], collapse = ", "), "."
            )
        }
        novel <- setdiff(names(other), names(lens))
        if (length(novel) > 0) {
            lens <- c(lens, other[novel])
        }
    }

    lens
}


#' Build one sample's plotting data for a copy number segment plot
#'
#' Internal helper for [cnSegmentPlot()]. Places a single `CNSegment`'s bins and
#' called segments onto the shared genomic coordinate system (`seqstart` /
#' `totlen`) computed once across all samples, and builds the point hover text.
#'
#' @param seg A `CNSegment` object.
#' @param seq.names Character vector of chromosome names being plotted.
#' @param seqstart Named numeric vector of per-chromosome genomic offsets.
#' @param totlen Total length of the plotted chromosomes, used to scale x into
#'   a genome fraction.
#' @param hover.text.cols Character vector of `bin.coords` metadata column
#'   names to include in the hover text.
#' @param genes An optional `GRanges` of gene coordinates to label.
#' @param id.col Name of the metadata column in `genes` holding the label.
#'
#' @return A list with `df` (the per-bin plotting frame), `seg.df` (the segment
#'   mean overlay, or `NULL`), and `label.df` (gene/bin matches, or `NULL`).
#'
#' @importFrom GenomicRanges start end mcols seqnames
#' @importFrom methods is
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_panel_data
#' @keywords internal
.cn_seg_panel_data <- function(seg, seq.names, seqstart, totlen, hover.text.cols,
                               genes = NULL, id.col = NULL) {
    bin.coords <- seg$bin.coords
    bin.signals <- seg$bin.signals
    sigs <- seg$seg.signals
    sigs$chrom <- as.character(sigs$chrom)

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
        bin.x = as.numeric(bin.coords$bin.x),
        signal = as.numeric(bin.coords$signal),
        text = bin.coords$text,
        stringsAsFactors = FALSE,
        row.names = NULL
    )

    seg.beg <- (seqstart[sigs$chrom] + sigs$loc.start) / totlen
    seg.end <- (seqstart[sigs$chrom] + sigs$loc.end) / totlen
    keep.seg <- !is.na(seg.beg) & !is.na(seg.end)
    seg.df <- if (any(keep.seg)) {
        data.frame(
            x = as.numeric(seg.beg[keep.seg]), xend = as.numeric(seg.end[keep.seg]),
            y = sigs$seg.mean[keep.seg], yend = sigs$seg.mean[keep.seg],
            row.names = NULL
        )
    } else {
        NULL
    }

    list(df = df, seg.df = seg.df, label.df = label.df)
}


#' Tag a faceted figure's shared y-axis title as an axis annotation
#'
#' Internal helper for [cnSegmentPlot()]. `ggplotly()` renders a faceted plot's
#' shared axis titles as paper-anchored annotations that are otherwise
#' indistinguishable from facet strip labels, so
#' [VizModules::apply_axis_title_to_annotations()] would style the y-axis title
#' with the facet title font. Tagging it `annotationType = "axis"` routes it to
#' the axis title font instead, and keys its dragged position by axis side.
#'
#' @param fig A plotly figure produced from a faceted ggplot.
#' @param y.title The y-axis title text to look for.
#'
#' @return The figure, with the matching annotation tagged.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_seg_tag_axis_title
#' @keywords internal
.cn_seg_tag_axis_title <- function(fig, y.title) {
    annotations <- fig$x$layout$annotations
    if (!is.list(annotations) || length(annotations) == 0) {
        return(fig)
    }

    for (i in seq_along(annotations)) {
        ann <- annotations[[i]]
        if (is.null(ann) || !is.null(ann$annotationType)) next
        if (!identical(ann$xref, "paper") || !identical(ann$yref, "paper")) next
        if (!identical(as.character(ann$text), y.title)) next
        # Facet strips sit at the right edge; the shared y title at the left.
        if (!is.numeric(ann$x) || ann$x > 0.5) next
        fig$x$layout$annotations[[i]]$annotationType <- "axis"
    }

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
