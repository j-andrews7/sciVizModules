# Default colours, shared by the plot function and the module's controls.
.meth_colors <- list(
    exon = "#1A1A1A", cds = "#D7191C", intron = "#444444", absent = "#BDBDBD", na = "#FFFFFF",
    anno.low = "#DEEBF7", anno.high = "#08306B"
)

# Cytoband stains, from light to dark, with the centromere in red.
.meth_band_colors <- c(
    gneg = "#EEEEEE", stalk = "#DDDDDD", gpos25 = "#BBBBBB", gpos50 = "#888888", gpos75 = "#555555",
    gvar = "#555555", gpos100 = "#222222", acen = "#C00000"
)


#' Plot a genomic region of DNA methylation across arrays
#'
#' A track view of beta values over a gene, region or set of probes, after SeSAMe's
#' `visualizeGene()`, `visualizeRegion()` and `visualizeProbes()`, for cohorts that mix
#' Infinium arrays. Samples are rows and CpGs are columns of the heatmap, evenly spaced
#' and in genomic order. Above it, the transcripts are drawn to genomic scale, with
#' lines linking each CpG to its position and an ideogram marking the region.
#'
#' @details
#' **Mixed arrays.** Arrays are joined on genomic position (see [methylationCohort()]).
#' Every CpG on any plotted array is a column, so most columns of a cohort mixing HM450
#' with EPICv2 will be blank for its HM450 samples: only around a third of the CpGs on
#' these arrays are on all three. Those cells take `absent.color`, separately from
#' `na.color` for a probe the array has but which gave no value, such as one masked by
#' quality control. Nothing is imputed. `cpg.scope = "shared"` keeps only the CpGs on
#' every plotted array, and the coverage strip under the heatmap shows which array has
#' which CpG. Probes at one position, whether replicates or different IDs, are averaged.
#'
#' Beta values are not corrected for differences between arrays, which can be large, so
#' a cluster following `platform` may be technical rather than biological. Grouping on
#' `platform` keeps those comparisons within an array.
#'
#' **Clustering.** Samples are clustered on the CpGs measured in all of the samples being
#' clustered. Where fewer than two CpGs are, each pair is compared on those it shares, a
#' pair with none is placed at 1.1 times the greatest distance, and a note on the figure
#' says so. These orderings rest on the CpGs of this region alone.
#'
#' `attr(fig, "table")` holds two tables: `betas`, the values plotted with each CpG's
#' position and probes, and `samples`, the samples in plotted order.
#'
#' Unlike `visualizeRegion()`, the CpG island and Ensembl regulatory tracks are not
#' drawn; `rowData()` columns of the cohort can be drawn as strips with `cpg.tracks`.
#'
#' @param cohort A [methylationCohort()], or anything it takes.
#' @param gene,region,probes What to plot, one of: a gene name; a region as
#'   `"chr19:10260000-10380000"`; or probe IDs, which must lie on one chromosome.
#' @param upstream,downstream Bases to add around a gene, following its strand, or before
#'   and after a set of probes.
#' @param samples Names of the samples to plot, as in `cohort$samples$sample`. `NULL` for
#'   all.
#' @param cpg.scope `"all"` for every CpG on any plotted array, `"shared"` for those on
#'   all of them.
#' @param max.cpgs The most CpGs to draw. A region with more is an error.
#' @param colors Colours of the scale, lowest first. `NULL` for the default of
#'   [VizModules::resolve_colorscale()], which runs from blue to red.
#' @param scale.min,scale.mid,scale.max Values at the lowest, middle and highest colours.
#'   `NA` for the range of the data, or the centre of the limits.
#' @param reverse Logical; run the colours from high to low.
#' @param colorbar.title The title of the colorbar.
#' @param absent.color Colour of a cell whose array lacks the CpG.
#' @param na.color Colour of a cell with no value on an array that has the CpG.
#' @param ... Further options for the figure:
#'   - `group.by`: a column of the sample table. Its groups are drawn apart.
#'   - `group.gap`: blank rows between groups (default 1).
#'   - `cluster.samples`: logical; cluster samples, within any groups (default `FALSE`).
#'   - `dist.method`: `"euclidean"` (the default), `"manhattan"`, `"pearson"` or
#'     `"spearman"`.
#'   - `hclust.method`: the linkage, as [stats::hclust()] (default `"ward.D2"`).
#'   - `show.dendrogram`: logical; draw the clustering (default `TRUE`).
#'   - `anno.left`, `anno.right`: sample table columns to draw as strips beside the
#'     heatmap. Numeric columns run from `anno.low` to `anno.high`.
#'   - `anno.colors`: named colours for strip levels, as `"column: level"`.
#'   - `anno.low`, `anno.high`: colours of a numeric strip.
#'   - `show.sample.names`: logical (default `TRUE`).
#'   - `txn.view`: `"full"` for a row per transcript (the default), or `"collapsed"` to
#'     overlay each gene's transcripts on one row.
#'   - `txn.types`: transcript types to draw (default `"protein_coding"`). `NULL` for all.
#'   - `txn.labels`: logical; label transcripts (default `TRUE`).
#'   - `txn.font.size`: size of those labels (default 8).
#'   - `exon.color`, `cds.color`, `intron.color`: transcript colours.
#'   - `show.cytoband`, `show.map.lines`, `show.coverage`: logical; draw the ideogram,
#'     the lines from position to column, and the strip of array coverage (default `TRUE`).
#'   - `cpg.tracks`: `rowData()` columns to draw as strips under the heatmap.
#'   - `cpg.labels`: label columns with `"none"` (the default), `"probe"` or `"locus"`.
#' @return A `plotly` figure. See Details for the table it carries.
#'
#' @references
#' Zhou W, Triche TJ, Laird PW, Shen H (2018). SeSAMe: reducing artifactual detection
#' of DNA methylation by Infinium BeadChips in genomic deletions. *Nucleic Acids
#' Research*, 46(20), e123.
#'
#' @seealso [methylationCohort()], [sciVizModules::methylationTrackInputsUI()],
#'   [sciVizModules::methylationTrackOutputUI()], [sciVizModules::methylationTrackServer()],
#'   [sciVizModules::methylationTrackApp()]
#'
#' @import plotly
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_methylation)
#' example_methylation
#'
#' methylationTrack(
#'     example_methylation, gene = "DNMT1", group.by = "platform", cluster.samples = TRUE,
#'     anno.left = "cell.type", anno.right = "global.beta", txn.view = "collapsed"
#' )
methylationTrack <- function(cohort, gene = NULL, region = NULL, probes = NULL, upstream = 2000, downstream = 2000,
                             samples = NULL, cpg.scope = c("all", "shared"), max.cpgs = 1000, colors = NULL,
                             scale.min = 0, scale.mid = NA, scale.max = 1, reverse = FALSE,
                             colorbar.title = "Beta value", absent.color = .meth_colors$absent,
                             na.color = .meth_colors$na, ...) {
    cohort <- .meth_as_cohort(cohort)
    given <- c(gene = length(gene), region = length(region), probes = length(probes)) > 0
    if (sum(given) != 1) {
        stop("Give one of 'gene', 'region' or 'probes'.", call. = FALSE)
    }
    target <- .meth_target(
        cohort, names(given)[given], gene, region, paste(probes, collapse = " "), upstream, downstream
    )
    q <- .meth_query(cohort, target, samples, match.arg(cpg.scope), max.cpgs)
    options <- list(...)
    options$anno.colors <- c(options$anno.colors, .meth_level_colors(cohort))
    .meth_apply_scale(
        do.call(.meth_figure, c(list(q), options)),
        colors = colors, min = scale.min, mid = scale.mid, max = scale.max, reverse = reverse,
        title = colorbar.title, absent.color = absent.color, na.color = na.color
    )
}


#' Set a track figure's colour scales
#'
#' The colours live on `layout.coloraxis`, so changing them needs no redraw.
#'
#' @param fig A figure from [.meth_figure()].
#' @param colors,min,mid,max,reverse Passed to [VizModules::resolve_colorscale()].
#' @param title The colorbar's title.
#' @param absent.color,na.color Colours of the two kinds of empty cell.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_apply_scale <- function(fig, colors = NULL, min = NA, mid = NA, max = NA, reverse = FALSE, title = "Beta value",
                              absent.color = .meth_colors$absent, na.color = .meth_colors$na) {
    scale <- resolve_colorscale(colors, min, mid, max, reverse, data.range = attr(fig, "beta.range"))
    axis <- fig$x$layout$coloraxis
    axis$colorscale <- scale$colorscale
    axis$cmin <- scale$cmin
    axis$cmax <- scale$cmax
    axis$colorbar$title <- list(text = title %||% "")
    fig$x$layout$coloraxis <- axis

    # One half of the scale per kind of cell, each a flat colour.
    fig$x$layout$coloraxis2$colorscale <- list(
        list(0, absent.color), list(0.5, absent.color), list(0.5, na.color), list(1, na.color)
    )
    fig
}


#' Set the sample labels' size and the heatmap's border
#'
#' The Axes tab's lines would otherwise fall on the strips that carry the figure's main
#' axes, so they are moved onto the heatmap here. Passed through `fixed.axes`, which
#' [.sci_finalize_plotly()] applies after the shared styling.
#'
#' @param fig A figure from [.meth_figure()].
#' @param font.size The sample labels' size, or `NULL`.
#' @param showline,mirror,linecolor,linewidth The Axes tab's axis lines.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_apply_frame <- function(fig, font.size = NULL, showline = FALSE, mirror = FALSE, linecolor = NULL,
                              linewidth = NULL) {
    fixed <- attr(fig, "fixed.axes")
    if (!is.null(font.size)) {
        fixed$yaxis$tickfont$size <- font.size
    }
    border <- list(
        showline = isTRUE(showline), mirror = isTRUE(mirror), linecolor = linecolor %||% "#000000",
        linewidth = linewidth %||% 1
    )
    for (axis in attr(fig, "heat.axes")) {
        fixed[[axis]] <- utils::modifyList(fixed[[axis]] %||% list(), border)
    }
    attr(fig, "fixed.axes") <- fixed
    fig
}


#' The layer behind the heatmap: cells with no value, by why
#'
#' @param betas,absent Matrices with rows for samples, as plotted.
#' @return A matrix: 1 where the array lacks the CpG, 2 for a value that is missing,
#'   and `NA` over a value.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_empty_cells <- function(betas, absent) {
    out <- matrix(NA_real_, nrow(betas), ncol(betas))
    out[is.na(betas)] <- 2
    out[is.na(betas) & absent] <- 1
    out
}


#' Hover text for the heatmap's cells
#'
#' @param q A query, from [.meth_query()].
#' @param index The plotted order of the samples.
#' @param y Each plotted sample's heatmap row.
#' @param ny The heatmap rows.
#' @return A list of `values` and `empty`, character matrices over the heatmap's cells,
#'   or `NULL` for a heatmap too large to carry them (see `.meth_hover_limit`).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_hover <- function(q, index, y, ny) {
    n <- nrow(q$betas)
    if (n * ny > .meth_hover_limit) {
        return(NULL)
    }
    values <- matrix("", ny, n)
    empty <- matrix("", ny, n)
    for (k in seq_along(index)) {
        i <- index[k]
        name <- colnames(q$betas)[i]
        beta <- q$betas[, i]
        platform <- if ("platform" %in% names(q$samples)) as.character(q$samples$platform[i])
        probe <- q$cpgs[[paste0("probe.", platform)]] %||% q$cpgs[["probe"]] %||% rep("", n)
        base <- paste0(name, "<br>", q$cpgs$locus)
        seen <- !is.na(beta)
        values[y[k], seen] <- sprintf("%s<br>%s<br>Beta: %.3f", base[seen], probe[seen], beta[seen])
        empty[y[k], !seen] <- paste0(base[!seen], "<br>", ifelse(q$absent[!seen, i], "Not on this array", "No value"))
    }
    list(values = values, empty = empty)
}


#' Work out how to draw one annotation strip
#'
#' @param values The annotation's values.
#' @param column The annotation's name.
#' @param colors Named colours for levels, as `"column: level"`.
#' @param low,high Colours of a numeric annotation.
#' @return A list of `z`, `zmin`, `zmax`, `colorscale`, and `legend`, a data frame of the
#'   `name` and `color` of each legend entry.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_strip <- function(values, column, colors = NULL, low = .meth_colors$anno.low,
                        high = .meth_colors$anno.high) {
    if (is.numeric(values)) {
        finite <- values[is.finite(values)]
        span <- if (length(finite)) range(finite) else c(0, 1)
        if (span[1] == span[2]) span <- span + c(-0.5, 0.5)
        ramp <- scales::pal_seq_gradient(low, high)
        return(list(
            z = values, zmin = span[1], zmax = span[2],
            colorscale = list(list(0, low), list(1, high)),
            legend = data.frame(
                name = format(c(span[1], mean(span), span[2]), digits = 3, trim = TRUE),
                color = c(low, ramp(0.5), high)
            )
        ))
    }

    levels <- .meth_levels(values)
    keys <- paste0(column, ": ", levels)
    fill <- if (is.null(colors)) rep(NA_character_, length(keys)) else unname(colors[keys])
    fill[is.na(fill)] <- .meth_palette(sum(is.na(fill)))
    k <- max(1, length(levels))
    list(
        z = match(as.character(values), levels), zmin = 0.5, zmax = k + 0.5,
        colorscale = .meth_steps(if (length(fill)) fill else "#FFFFFF"),
        legend = data.frame(name = levels, color = fill)
    )
}


#' A stepped colourscale, one flat band per colour
#'
#' @param colors Colours, one per integer value.
#' @return A plotly colourscale.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_steps <- function(colors) {
    k <- length(colors)
    unlist(lapply(seq_len(k), function(i) {
        list(list((i - 1) / k, colors[i]), list(i / k, colors[i]))
    }), recursive = FALSE)
}


#' Colours from the package's default palette
#'
#' @param n How many, recycled past the end of the palette.
#' @return Hex colours.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_palette <- function(n) {
    rep_len(default_palettes()[["choices"]][["Defaults"]][["dittoColors"]], n)
}


#' The levels of every annotation that can be drawn as a strip
#'
#' @param cohort A `methylationCohort`.
#' @return A named list of levels, one element per discrete sample or CpG annotation.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_annotation_levels <- function(cohort) {
    samples <- cohort$samples
    out <- lapply(stats::setNames(nm = .meth_group_cols(samples)), function(col) .meth_levels(samples[[col]]))
    for (col in .meth_cpg_cols(cohort)) {
        lv <- unlist(lapply(cohort$arrays, function(a) {
            if (col %in% names(a$rowdata)) .meth_levels(a$rowdata[[col]])
        }), use.names = FALSE)
        out[[col]] <- union(out[[col]], sort(unique(lv)))
    }
    out
}


#' A colour for every annotation level in a cohort
#'
#' One map for the whole cohort, walking along the palette from one annotation to the
#' next, so two annotations drawn together never start from the same colour and a level
#' keeps its colour however the strips on show change.
#'
#' @param cohort A `methylationCohort`.
#' @return A named colour vector, keyed `"column: level"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_level_colors <- function(cohort) {
    levels <- .meth_annotation_levels(cohort)
    keys <- unlist(Map(function(col, lv) paste0(col, ": ", lv), names(levels), levels), use.names = FALSE)
    stats::setNames(.meth_palette(length(keys)), keys)
}


#' Columns to filter or group samples on
#'
#' @param samples A cohort's sample table.
#' @return Column names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_group_cols <- function(samples) {
    setdiff(.sci_discrete_cols(samples), "sample")
}


#' Columns to draw as sample strips
#'
#' @param samples A cohort's sample table.
#' @return Column names: the discrete ones, then the numeric.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_strip_cols <- function(samples) {
    numeric <- names(samples)[vapply(samples, is.numeric, logical(1))]
    c(.meth_group_cols(samples), setdiff(numeric, .meth_group_cols(samples)))
}


#' rowData columns to draw as CpG strips
#'
#' @param cohort A `methylationCohort`.
#' @return Column names, without those giving probe positions.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_strips
#' @keywords internal
.meth_cpg_cols <- function(cohort) {
    cols <- unlist(lapply(cohort$arrays, function(a) .sci_discrete_cols(a$rowdata)), use.names = FALSE)
    setdiff(unique(cols), c("CpG_chrm", "CpG_beg", "CpG_end", "chr", "pos", "strand"))
}


#' Where each panel of the figure goes
#'
#' @param n.left,n.right Annotation strips each side of the heatmap.
#' @param dendrogram Logical; whether a dendrogram is drawn.
#' @param label.width The share of the width kept for sample names.
#' @param txn.rows The transcript rows, or `NULL` for no transcript panel.
#' @param txn.labels Logical; whether transcripts are labelled.
#' @param map,ideogram Logical; whether those panels are drawn.
#' @param n.bottom Strips under the heatmap.
#' @param labelled Logical; whether columns are labelled.
#' @return A list of `x` and `y`, each a list of panel domains. A panel not drawn has
#'   none.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_domains
#' @keywords internal
.meth_domains <- function(n.left = 0, n.right = 0, dendrogram = FALSE, label.width = 0.15, txn.rows = NULL,
                          txn.labels = TRUE, map = TRUE, ideogram = TRUE, n.bottom = 0, labelled = FALSE) {
    strip <- 0.016
    gap <- 0.004

    # Across, from the left.
    x <- list()
    at <- 0
    if (isTRUE(dendrogram)) {
        x$dendrogram <- c(0, 0.08)
        at <- 0.08 + gap
    }
    if (n.left > 0) {
        x$left <- c(at, at + n.left * strip)
        at <- x$left[2] + gap
    }
    edge <- 1 - label.width
    if (n.right > 0) {
        x$right <- c(edge - n.right * strip, edge)
        edge <- x$right[1] - gap
    }
    x$heatmap <- c(at, edge)

    # Down from the top, then up from the bottom; the heatmap gets what is left.
    y <- list()
    top <- 0.965
    if (isTRUE(ideogram)) {
        y$ideogram <- c(top - 0.03, top)
        top <- y$ideogram[1] - if (is.null(txn.rows)) 0.01 else 0.035
    }
    if (!is.null(txn.rows)) {
        height <- min(0.3, max(0.05, txn.rows * (if (isTRUE(txn.labels)) 0.036 else 0.022)))
        y$transcripts <- c(top - height, top)
        top <- y$transcripts[1] - 0.005
    }
    if (isTRUE(map)) {
        y$map <- c(top - 0.07, top)
        top <- y$map[1] - 0.003
    }
    bottom <- if (isTRUE(labelled)) 0.12 else 0
    if (n.bottom > 0) {
        y$bottom <- c(bottom, bottom + n.bottom * 0.02)
        bottom <- y$bottom[2] + 0.006
    }
    y$heatmap <- c(bottom, top)
    list(x = x, y = y)
}


#' Number the figure's axes
#'
#' Each panel has axes of its own, linked to the others by `matches`, so a shared axis
#' never makes one panel of several. The first axis on each side goes to the outermost
#' panel, where its labels belong: the columns' under the bottom strips, the samples'
#' beside the right-hand strips. Those are the two axes the Axes tab styles.
#'
#' @param panels The panels drawn, from [.meth_domains()].
#' @return A named list of `x` and `y` axis numbers per panel.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_axis_numbers <- function(panels) {
    bottom <- !is.null(panels$y$bottom)
    right <- !is.null(panels$x$right)
    others <- c(
        intersect(c("left", "dendrogram"), names(panels$x)),
        intersect(c("map", "transcripts", "ideogram"), names(panels$y))
    )
    # Every axis but the first of each side, in turn.
    numbered <- c(
        if (bottom) c("x.heatmap", "y.bottom"),
        if (right) c("y.heatmap", "x.right"),
        as.vector(rbind(paste0("x.", others), paste0("y.", others)))
    )
    if (!length(others)) numbered <- setdiff(numbered, c("x.", "y."))

    panels.drawn <- c("heatmap", if (bottom) "bottom", if (right) "right", others)
    numbers <- function(side) {
        lapply(stats::setNames(nm = panels.drawn), function(panel) {
            at <- match(paste0(side, ".", panel), numbered)
            if (is.na(at)) 1L else at + 1L
        })
    }
    list(x = numbers("x"), y = numbers("y"))
}


#' A trace's reference to an axis, and the axis's name in the layout
#'
#' @param side `"x"` or `"y"`.
#' @param number The axis number.
#' @return A string such as `"x2"`, or `"xaxis2"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_axis_ref <- function(side, number) {
    if (number == 1L) side else paste0(side, number)
}

#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_axis_name <- function(side, number) {
    paste0(side, "axis", if (number != 1L) number)
}


#' Draw a region's transcripts
#'
#' @param fig The figure so far.
#' @param model The transcripts, from [.meth_txn_model()].
#' @param to_x A function from genomic position to the x axis.
#' @param xaxis,yaxis The panel's axis references.
#' @param labels Logical; label the transcripts.
#' @param font.size The labels' size.
#' @param exon.color,cds.color,intron.color Colours.
#' @return The figure.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_add_transcripts <- function(fig, model, to_x, xaxis, yaxis, labels = TRUE, font.size = 8,
                                  exon.color = .meth_colors$exon, cds.color = .meth_colors$cds,
                                  intron.color = .meth_colors$intron) {
    drop <- if (isTRUE(labels)) 0.14 else 0
    blocks <- function(parts, half) {
        y <- parts$row + drop
        list(
            x = as.vector(rbind(
                to_x(parts$start), to_x(parts$end), to_x(parts$end), to_x(parts$start), to_x(parts$start), NA
            )),
            y = as.vector(rbind(y - half, y - half, y + half, y + half, y - half, NA))
        )
    }
    filled <- function(fig, shape, color) {
        add_trace(fig,
            type = "scatter", mode = "lines", x = shape$x, y = shape$y, fill = "toself", fillcolor = color,
            line = list(width = 0), xaxis = xaxis, yaxis = yaxis, hoverinfo = "skip", showlegend = FALSE
        )
    }

    spans <- model$spans
    if (!nrow(spans)) {
        return(add_trace(fig,
            type = "scatter", mode = "text", x = to_x(0), y = 1, text = "No transcripts", xaxis = xaxis,
            yaxis = yaxis, hoverinfo = "skip", showlegend = FALSE
        ))
    }
    y <- spans$row + drop
    fig <- add_trace(fig,
        type = "scatter", mode = "lines",
        x = as.vector(rbind(to_x(spans$start), to_x(spans$end), NA)), y = as.vector(rbind(y, y, NA)),
        line = list(color = intron.color, width = 1), xaxis = xaxis, yaxis = yaxis, hoverinfo = "skip",
        showlegend = FALSE
    )
    if (nrow(model$exons)) fig <- filled(fig, blocks(model$exons, 0.26), exon.color)
    if (nrow(model$cds)) fig <- filled(fig, blocks(model$cds, 0.12), cds.color)

    # The direction of each, with its hover text, at the end it runs towards.
    forward <- spans$strand != "-"
    fig <- add_trace(fig,
        type = "scatter", mode = "markers",
        x = to_x(ifelse(forward, spans$end, spans$start)), y = y, text = spans$hover, hoverinfo = "text",
        marker = list(
            symbol = ifelse(forward, "triangle-right", "triangle-left"), size = 7, color = intron.color
        ),
        xaxis = xaxis, yaxis = yaxis, showlegend = FALSE
    )
    if (isTRUE(labels)) {
        fig <- add_trace(fig,
            type = "scatter", mode = "text", x = to_x((spans$start + spans$end) / 2), y = spans$row - 0.28,
            text = spans$label, textfont = list(size = font.size, color = intron.color), xaxis = xaxis,
            yaxis = yaxis, hoverinfo = "skip", showlegend = FALSE
        )
    }
    fig
}


#' Draw one strip's cells and legend entries
#'
#' @param fig The figure so far.
#' @param strip A strip, from [.meth_strip()], with `z` already shaped as a matrix.
#' @param x,y The strip's cell positions.
#' @param text Hover text.
#' @param title The legend group's title.
#' @param xaxis,yaxis The panel's axis references.
#' @param legend Logical; add the strip's legend entries.
#' @return The figure.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_meth_add_strip
#' @keywords internal
.meth_add_strip <- function(fig, strip, x, y, text, title, xaxis, yaxis, legend = TRUE) {
    fig <- add_trace(fig,
        type = "heatmap", x = x, y = y, z = strip$z, zmin = strip$zmin, zmax = strip$zmax,
        colorscale = strip$colorscale, showscale = FALSE, text = text, hoverinfo = "text", hoverongaps = FALSE,
        xaxis = xaxis, yaxis = yaxis
    )
    # Off the panel's range, so only the legend shows them.
    for (i in seq_len(if (isTRUE(legend)) nrow(strip$legend) else 0L)) {
        fig <- add_trace(fig,
            type = "scatter", mode = "markers", x = x[1], y = -5,
            marker = list(symbol = "square", size = 10, color = strip$legend$color[i]), name = strip$legend$name[i],
            legendgroup = title, legendgrouptitle = list(text = title), showlegend = TRUE, hoverinfo = "skip",
            xaxis = xaxis, yaxis = yaxis
        )
    }
    fig
}


#' Draw a set of sample strips beside the heatmap
#'
#' @param fig The figure so far.
#' @param columns Sample table columns.
#' @param plotted The plotted samples' rows of the table.
#' @param rows Each plotted sample's heatmap row.
#' @param ny The heatmap rows.
#' @param colors,low,high Passed to [.meth_strip()].
#' @param xaxis,yaxis The panel's axis references.
#' @param legended Columns already in the legend, from the other side.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_add_strip
#' @keywords internal
.meth_add_sample_strips <- function(fig, columns, plotted, rows, ny, colors, low, high, xaxis, yaxis,
                                    legended = NULL) {
    for (k in seq_along(columns)) {
        col <- columns[k]
        values <- plotted[[col]]
        strip <- .meth_strip(values, col, colors, low, high)
        z <- matrix(NA_real_, ny, 1)
        z[rows, 1] <- strip$z
        strip$z <- z
        text <- matrix("", ny, 1)
        shown <- if (is.numeric(values)) format(values, digits = 3, trim = TRUE) else as.character(values)
        text[rows, 1] <- sprintf("%s<br>%s: %s", plotted$sample, col, shown)
        fig <- .meth_add_strip(fig, strip, I(k), seq_len(ny), text, col, xaxis, yaxis, !col %in% legended)
    }
    fig
}


#' Draw a dendrogram for each clustered group
#'
#' @param fig The figure so far.
#' @param trees The trees from [.meth_order()].
#' @param rows Each plotted sample's heatmap row.
#' @param xaxis,yaxis The panel's axis references.
#' @return The figure.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_add_dendrogram <- function(fig, trees, rows, xaxis, yaxis) {
    shapes <- lapply(trees, function(tree) .meth_dendrogram(tree$hc, rows[tree$before + seq_along(tree$hc$order)]))
    add_trace(fig,
        type = "scatter", mode = "lines", x = unlist(lapply(shapes, `[[`, "x")), y = unlist(lapply(shapes, `[[`, "y")),
        line = list(color = "#333333", width = 1), xaxis = xaxis, yaxis = yaxis, hoverinfo = "skip", showlegend = FALSE
    )
}


#' The line segments of a dendrogram
#'
#' @param hc An `hclust` object.
#' @param y The rows of its leaves, in `hc$order`.
#' @return A list of `x` (heights) and `y`, with `NA` between merges.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_dendrogram
#' @keywords internal
.meth_dendrogram <- function(hc, y) {
    leaf.y <- y[match(seq_along(hc$order), hc$order)]
    node.y <- numeric(nrow(hc$merge))
    node.h <- numeric(nrow(hc$merge))
    out.x <- numeric(0)
    out.y <- numeric(0)
    for (i in seq_len(nrow(hc$merge))) {
        ends <- hc$merge[i, ]
        at <- ifelse(ends < 0, leaf.y[abs(ends)], node.y[pmax(ends, 1)])
        from <- ifelse(ends < 0, 0, node.h[pmax(ends, 1)])
        h <- hc$height[i]
        out.x <- c(out.x, from[1], h, h, from[2], NA)
        out.y <- c(out.y, at[1], at[1], at[2], at[2], NA)
        node.y[i] <- mean(at)
        node.h[i] <- h
    }
    list(x = out.x, y = out.y)
}


#' Draw the ideogram of a chromosome, marking a region
#'
#' @param fig The figure so far.
#' @param bands The chromosome's cytobands.
#' @param region A region, from [.meth_region()].
#' @param xaxis,yaxis The panel's axis references.
#' @return The figure.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_add_ideogram <- function(fig, bands, region, xaxis, yaxis) {
    stains <- as.character(bands$gieStain)
    for (stain in unique(stains)) {
        band <- bands[stains == stain, , drop = FALSE]
        color <- unname(.meth_band_colors[stain])
        fig <- add_trace(fig,
            type = "scatter", mode = "lines",
            x = as.vector(rbind(band$chromStart, band$chromEnd, band$chromEnd, band$chromStart, band$chromStart, NA)),
            y = rep(c(0, 0, 1, 1, 0, NA), nrow(band)), fill = "toself",
            fillcolor = if (is.na(color)) "#EEEEEE" else color, line = list(width = 0), xaxis = xaxis,
            yaxis = yaxis, hoverinfo = "skip", showlegend = FALSE
        )
    }
    add_trace(fig,
        type = "scatter", mode = "lines", x = c(region$start, region$start, NA, region$end, region$end),
        y = c(-0.2, 1.2, NA, -0.2, 1.2), line = list(color = "#FF0000", width = 2), xaxis = xaxis, yaxis = yaxis,
        hoverinfo = "skip", showlegend = FALSE
    )
}


#' The figure's axes
#'
#' @param panels The panel domains, from [.meth_domains()].
#' @param numbers The axis numbers, from [.meth_axis_numbers()].
#' @param n The heatmap's columns.
#' @param ny The heatmap's rows.
#' @param rows Each plotted sample's heatmap row.
#' @param sample.names Sample names, or `NULL` to leave them off.
#' @param left,right The strips' column names.
#' @param bottom The bottom strips' row names.
#' @param column.labels The heatmap's column labels, or `NULL`.
#' @param ticks Genomic position ticks, a list of `at` and `label`, or `NULL`.
#' @param txn.rows The transcript rows.
#' @param height The tallest dendrogram.
#' @param chrom.end The length of the chromosome.
#' @return A named list of axes for [plotly::layout()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_axes <- function(panels, numbers, n, ny, rows, sample.names, left, right, bottom, column.labels, ticks,
                       txn.rows, height, chrom.end) {
    plain <- list(
        showgrid = FALSE, zeroline = FALSE, showline = FALSE, showticklabels = FALSE, ticks = "",
        title = list(text = "")
    )
    # A panel beside the heatmap spans its height, and those above and below its width.
    # Along those, the first axis holds the range and the rest follow it.
    beside <- c("left", "right", "dendrogram")
    above <- c("bottom", "map", "transcripts")
    axis <- function(side, panel, settings = list()) {
        spanning <- if (side == "x") c(above, "ideogram") else beside
        linked <- c("heatmap", if (side == "x") above else beside)
        other <- if (side == "x") "y" else "x"
        number <- numbers[[side]][[panel]]
        fields <- list(
            domain = panels[[side]][[if (panel %in% spanning) "heatmap" else panel]],
            anchor = .meth_axis_ref(other, numbers[[other]][[panel]])
        )
        if (number != 1L && panel %in% linked) fields$matches <- side
        stats::setNames(list(utils::modifyList(plain, c(fields, settings))), .meth_axis_name(side, number))
    }

    columns <- list(range = c(0.5, n + 0.5))
    if (length(column.labels)) {
        columns <- c(columns, list(
            showticklabels = TRUE, tickmode = "array", tickvals = seq_len(n), ticktext = column.labels
        ))
    }
    sample_axis <- list(range = c(ny + 0.5, 0.5))
    if (length(sample.names)) {
        sample_axis <- c(sample_axis, list(
            showticklabels = TRUE, tickmode = "array", tickvals = rows, ticktext = sample.names, side = "right",
            automargin = TRUE
        ))
    }
    strip_labels <- function(k, labels) {
        list(
            range = c(0.5, k + 0.5), showticklabels = TRUE, tickmode = "array", tickvals = seq_len(k),
            ticktext = labels, tickangle = -90, side = "top", tickfont = list(size = 9)
        )
    }

    has.bottom <- !is.null(panels$y$bottom)
    has.right <- !is.null(panels$x$right)
    c(
        # The two main axes hold the columns' and the samples' ranges and labels.
        axis("x", if (has.bottom) "bottom" else "heatmap", columns),
        axis("y", if (has.right) "right" else "heatmap", sample_axis),
        if (has.bottom) {
            c(axis("x", "heatmap"), axis("y", "bottom", list(
                range = c(length(bottom) + 0.5, 0.5), showticklabels = TRUE, tickmode = "array",
                tickvals = seq_along(bottom), ticktext = bottom, tickfont = list(size = 9)
            )))
        },
        if (has.right) {
            c(axis("y", "heatmap"), axis("x", "right", strip_labels(length(right), right)))
        },
        if (!is.null(panels$x$left)) {
            c(axis("x", "left", strip_labels(length(left), left)), axis("y", "left"))
        },
        if (!is.null(panels$x$dendrogram)) {
            c(axis("x", "dendrogram", list(range = c(height * 1.02, 0))), axis("y", "dendrogram"))
        },
        if (!is.null(panels$y$map)) {
            c(axis("x", "map"), axis("y", "map", list(range = c(0, 1))))
        },
        if (!is.null(panels$y$transcripts)) {
            c(
                axis("x", "transcripts", list(
                    side = "top", showticklabels = TRUE, tickmode = "array", tickvals = ticks$at,
                    ticktext = ticks$label, ticks = "outside", ticklen = 3, tickfont = list(size = 9)
                )),
                axis("y", "transcripts", list(range = c(max(1, txn.rows) + 0.5, 0.5)))
            )
        },
        if (!is.null(panels$y$ideogram)) {
            c(axis("x", "ideogram", list(range = c(0, chrom.end))), axis("y", "ideogram", list(range = c(-0.3, 1.3))))
        }
    )
}


#' Draw a region's beta values and tracks
#'
#' The draw step of [methylationTrack()] and its module. Colours come afterwards, from
#' [.meth_apply_scale()].
#'
#' @param q A query, from [.meth_query()].
#' @param group.by,group.gap,cluster.samples,dist.method,hclust.method See
#'   [methylationTrack()].
#' @param show.dendrogram,anno.left,anno.right,anno.colors,anno.low,anno.high See
#'   [methylationTrack()].
#' @param show.sample.names,txn.view,txn.types,txn.labels,txn.font.size See
#'   [methylationTrack()].
#' @param exon.color,cds.color,intron.color See [methylationTrack()].
#' @param show.cytoband,show.map.lines,show.coverage,cpg.tracks,cpg.labels See
#'   [methylationTrack()].
#' @return A built `plotly` figure, with attributes `table`, `fixed.axes`, `heat.axes`
#'   and `beta.range`.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_meth_figure
#' @keywords internal
.meth_figure <- function(q, group.by = NULL, group.gap = 1, cluster.samples = FALSE, dist.method = "euclidean",
                         hclust.method = "ward.D2", show.dendrogram = TRUE, anno.left = NULL, anno.right = NULL,
                         anno.colors = NULL, anno.low = .meth_colors$anno.low, anno.high = .meth_colors$anno.high,
                         show.sample.names = TRUE, txn.view = "full", txn.types = "protein_coding",
                         txn.labels = TRUE, txn.font.size = 8, exon.color = .meth_colors$exon,
                         cds.color = .meth_colors$cds, intron.color = .meth_colors$intron, show.cytoband = TRUE,
                         show.map.lines = TRUE, show.coverage = TRUE, cpg.tracks = NULL, cpg.labels = "none") {
    unknown <- setdiff(c(group.by, anno.left, anno.right), names(q$samples))
    if (length(unknown)) {
        stop("Not columns of the sample table: ", paste(unknown, collapse = ", "), ".", call. = FALSE)
    }
    ord <- .meth_order(q$betas, q$samples, group.by, cluster.samples, dist.method, hclust.method)
    n <- nrow(q$betas)
    rows <- .meth_rows(length(ord$index), ord$groups, group.gap)
    ny <- rows$n
    plotted <- q$samples[ord$index, , drop = FALSE]
    names.shown <- if (isTRUE(show.sample.names)) plotted$sample

    region <- q$region
    to_x <- function(pos) (pos - region$start) / (region$end - region$start) * n + 0.5

    model <- .meth_txn_model(q$txns, region, txn.view, txn.types)
    has.txns <- !is.null(q$txns)
    bands <- if (isTRUE(show.cytoband)) q$cytobands
    dendrogram <- isTRUE(show.dendrogram) && length(ord$trees) > 0
    coverage <- if (isTRUE(show.coverage) && NCOL(q$coverage) > 1) q$coverage
    tracks <- intersect(cpg.tracks, names(q$rowdata))
    column.labels <- switch(cpg.labels %||% "none",
        probe = unname(apply(q$cpgs[grep("^probe", names(q$cpgs))], 1, function(ids) ids[!is.na(ids)][1])),
        locus = q$cpgs$locus
    )

    # Room for the names at the default font size, in the width of an app's plot.
    width <- if (length(names.shown)) min(0.3, max(nchar(names.shown)) * 0.0085 + 0.012) else 0.01
    panels <- .meth_domains(
        n.left = length(anno.left), n.right = length(anno.right), dendrogram = dendrogram, label.width = width,
        txn.rows = if (has.txns) max(1, model$n), txn.labels = txn.labels, map = isTRUE(show.map.lines),
        ideogram = !is.null(bands), n.bottom = (if (is.null(coverage)) 0 else ncol(coverage)) + length(tracks),
        labelled = length(column.labels) > 0
    )
    numbers <- .meth_axis_numbers(panels)
    ref <- function(name) {
        list(x = .meth_axis_ref("x", numbers$x[[name]]), y = .meth_axis_ref("y", numbers$y[[name]]))
    }

    # Samples in rows from here on, with blank rows for the gaps between groups.
    z <- matrix(NA_real_, ny, n)
    gone <- matrix(FALSE, ny, n)
    z[rows$y, ] <- t(q$betas[, ord$index, drop = FALSE])
    gone[rows$y, ] <- t(q$absent[, ord$index, drop = FALSE])
    empty <- .meth_empty_cells(z, gone)
    empty[-rows$y, ] <- NA

    hover <- .meth_hover(q, ord$index, rows$y, ny)
    heat <- ref("heatmap")
    fig <- plot_ly()
    fig <- add_trace(fig,
        type = "heatmap", x = seq_len(n), y = seq_len(ny), z = empty, coloraxis = "coloraxis2",
        text = hover$empty, hoverinfo = if (is.null(hover)) "skip" else "text", hoverongaps = FALSE, name = "No value",
        xaxis = heat$x, yaxis = heat$y
    )
    fig <- add_trace(fig,
        type = "heatmap", x = seq_len(n), y = seq_len(ny), z = round(z, 3), coloraxis = "coloraxis",
        text = hover$values, hoverinfo = if (is.null(hover)) "z" else "text", hoverongaps = FALSE, name = "Beta",
        xaxis = heat$x, yaxis = heat$y
    )

    if (!is.null(panels$y$map)) {
        panel <- ref("map")
        fig <- add_trace(fig,
            type = "scatter", mode = "lines", x = as.vector(rbind(to_x(q$cpgs$pos), to_x(q$cpgs$pos), seq_len(n), NA)),
            y = rep(c(1, 0.55, 0, NA), n), line = list(color = "#7F7F7F", width = 0.5), xaxis = panel$x,
            yaxis = panel$y, hoverinfo = "skip", showlegend = FALSE
        )
    }
    if (!is.null(panels$y$transcripts)) {
        panel <- ref("transcripts")
        fig <- .meth_add_transcripts(
            fig, model, to_x, panel$x, panel$y, txn.labels, txn.font.size, exon.color, cds.color, intron.color
        )
    }
    if (!is.null(panels$y$ideogram)) {
        panel <- ref("ideogram")
        fig <- .meth_add_ideogram(fig, bands, region, panel$x, panel$y)
    }

    colors <- anno.colors
    if (!is.null(panels$x$left)) {
        panel <- ref("left")
        fig <- .meth_add_sample_strips(
            fig, anno.left, plotted, rows$y, ny, colors, anno.low, anno.high, panel$x, panel$y
        )
    }
    if (!is.null(panels$x$right)) {
        panel <- ref("right")
        fig <- .meth_add_sample_strips(
            fig, anno.right, plotted, rows$y, ny, colors, anno.low, anno.high, panel$x, panel$y, anno.left
        )
    }
    if (dendrogram) {
        panel <- ref("dendrogram")
        fig <- .meth_add_dendrogram(fig, ord$trees, rows$y, panel$x, panel$y)
    }

    bottom <- character(0)
    if (!is.null(panels$y$bottom)) {
        panel <- ref("bottom")
        at <- 0L
        for (platform in colnames(coverage)) {
            at <- at + 1L
            bottom <- c(bottom, platform)
            cells <- ifelse(coverage[, platform], 1, NA)
            fig <- add_trace(fig,
                type = "heatmap", x = seq_len(n), y = I(at), z = matrix(cells, 1), zmin = 0, zmax = 1,
                showscale = FALSE, colorscale = list(list(0, "#444444"), list(1, "#444444")), hoverongaps = FALSE,
                text = matrix(paste0(platform, "<br>", q$cpgs$locus), 1), hoverinfo = "text", xaxis = panel$x,
                yaxis = panel$y
            )
        }
        for (col in tracks) {
            at <- at + 1L
            bottom <- c(bottom, col)
            values <- q$rowdata[[col]]
            strip <- .meth_strip(values, col, colors)
            strip$z <- matrix(strip$z, 1)
            text <- matrix(sprintf("%s<br>%s: %s", q$cpgs$locus, col, values), 1)
            fig <- .meth_add_strip(fig, strip, seq_len(n), I(at), text, col, panel$x, panel$y)
        }
    }

    ticks <- pretty(c(region$start, region$end), 5)
    ticks <- ticks[ticks >= region$start & ticks <= region$end]
    heights <- unlist(lapply(ord$trees, function(tree) tree$hc$height))
    axes <- .meth_axes(
        panels, numbers, n, ny, rows$y, names.shown, anno.left, anno.right, bottom, column.labels,
        list(at = to_x(ticks), label = .meth_comma(ticks)), max(1, model$n),
        if (length(heights)) max(heights, 1e-8) else 1, if (!is.null(bands)) max(bands$chromEnd) else 1
    )

    fig <- do.call(layout, c(list(fig), axes, list(
        title = list(text = region$label),
        plot_bgcolor = "#FFFFFF",
        coloraxis = list(colorbar = list(len = 0.32, y = 1, yanchor = "top", thickness = 12)),
        coloraxis2 = list(cmin = 1, cmax = 2, showscale = FALSE),
        legend = list(y = 0.64, yanchor = "top", tracegroupgap = 8),
        hovermode = "closest",
        margin = list(l = 40, r = 40, t = 40, b = 20)
    )))
    fig <- plotly_build(fig)
    primary <- c("xaxis", "yaxis")
    fig <- mark_overlay_axes(fig, setdiff(names(axes), primary))

    if (isTRUE(ord$fallback)) {
        fig$x$layout$annotations <- c(fig$x$layout$annotations, list(list(
            text = "Clustered on the CpGs each pair of samples shares", x = 0, y = 1, xref = "paper", yref = "paper",
            xanchor = "left", yanchor = "bottom", showarrow = FALSE, font = list(size = 10)
        )))
    }

    heat.axes <- c(.meth_axis_name("x", numbers$x$heatmap), .meth_axis_name("y", numbers$y$heatmap))
    fixed <- list(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showline = FALSE, mirror = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showline = FALSE, mirror = FALSE)
    )
    if (!length(column.labels)) fixed$xaxis$ticks <- ""
    if (!length(names.shown)) fixed$yaxis$ticks <- ""

    order.table <- plotted
    order.table$row <- rows$y
    if (!is.null(ord$groups)) {
        order.table$group <- as.character(ord$groups)
    }
    values <- as.data.frame(q$betas[, ord$index, drop = FALSE], optional = TRUE)
    attr(fig, "table") <- list(betas = cbind(q$cpgs, values), samples = order.table)
    attr(fig, "fixed.axes") <- fixed
    attr(fig, "heat.axes") <- heat.axes
    attr(fig, "beta.range") <- suppressWarnings(range(q$betas, finite = TRUE))
    fig
}
