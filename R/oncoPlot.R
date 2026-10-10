#' Interactive oncoplot of somatic mutations
#'
#' The interactive counterpart of [maftools::oncoplot()]: a gene-by-sample grid
#' of non-synonymous mutations coloured by variant class (`Multi_Hit` where a
#' gene carries more than one), with each sample's mutation burden above, each
#' gene's mutation frequency to the right, and sample annotations as tracks
#' below. Genes run from most to least often mutated and samples are sorted into
#' the oncoplot "waterfall"; both orders follow maftools' `createOncoMatrix()`.
#' Hovering a tile gives the gene, sample, class and protein change.
#'
#' maftools draws its oncoplot with base graphics, so this is built natively in
#' plotly from the same tables; maftools itself is not needed.
#'
#' @param maf A maftools `MAF` object (from [maftools::read.maf()]) or a data
#'   frame in MAF columns: `Hugo_Symbol`, `Tumor_Sample_Barcode`,
#'   `Variant_Classification`, and optionally a protein-change column
#'   (`HGVSp_Short`, `Protein_Change` or `AAChange`). Silent variants are
#'   dropped as [maftools::read.maf()] drops them. Sample annotations are the
#'   MAF object's clinical data, or for a data frame the columns that are
#'   constant within each sample.
#' @param genes Genes to show, or `NULL` for the `top.n` most often mutated.
#' @param top.n The number of genes when `genes` is `NULL`.
#' @param colors A named vector of variant-class colours, overriding maftools'
#'   palette for the classes it names.
#' @param clinical.tracks Sample-annotation columns to draw as tracks.
#' @param sort.samples Logical; sort the samples into the waterfall. Otherwise
#'   they keep their order in the MAF.
#' @param include.unmutated Logical; keep samples with none of the genes mutated.
#' @param show.tmb Logical; draw the per-sample mutation count bar.
#' @param show.gene.bar Logical; draw the per-gene frequency bar.
#' @param show.sample.names Logical; label the samples.
#' @param background.color Colour of unmutated tiles.
#' @param main Optional plot title.
#'
#' @return A `plotly` object. The shown genes' summary (mutated samples, their
#'   percentage, and variants per class) is attached as attribute `"table"`.
#'
#' @import plotly
#' @seealso [oncoPlotServer()], [maftools::oncoplot()]
#' @export
#' @author Jared Andrews
#' @examples
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     # The TCGA LAML cohort maftools ships, with its clinical annotations.
#'     laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
#'         comment.char = "#")
#'     clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
#'     laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
#'     oncoPlot(laml, top.n = 15, clinical.tracks = "FAB_classification")
#' }
oncoPlot <- function(maf, genes = NULL, top.n = 20, colors = NULL, clinical.tracks = NULL, sort.samples = TRUE,
                     include.unmutated = TRUE, show.tmb = TRUE, show.gene.bar = TRUE, show.sample.names = FALSE,
                     background.color = "#ECF0F1", main = NULL) {
    m <- .maf_table(maf)
    om <- .maf_onco_matrix(m, genes, top.n, include.unmutated, sort.samples)
    cls <- om$classes
    genes <- rownames(cls)
    samples <- colnames(cls)
    n_all <- length(m$samples)

    present <- setdiff(unique(as.vector(cls)), "")
    lv <- c(intersect(names(.maf_vc_colors), present), setdiff(sort(present), names(.maf_vc_colors)))
    pal <- .maf_class_colors(lv, colors)

    # Tiles: class codes 0 (none) to K, on a stepped colour scale.
    k <- length(lv)
    z <- matrix(match(cls, lv), nrow(cls), dimnames = dimnames(cls))
    z[is.na(z)] <- 0
    steps <- c(background.color, unname(pal))
    colorscale <- do.call(rbind, lapply(seq_along(steps), function(i) {
        rbind(c((i - 1) / length(steps), steps[i]), c(i / length(steps), steps[i]))
    }))
    colorscale <- lapply(seq_len(nrow(colorscale)), function(i) list(as.numeric(colorscale[i, 1]), colorscale[i, 2]))
    hover <- matrix(sprintf("%s<br>%s<br>%s%s", rep(genes, ncol(cls)), rep(samples, each = nrow(cls)),
        ifelse(cls == "", "No mutation", gsub("_", " ", cls)),
        ifelse(nzchar(om$changes), paste0("<br>", om$changes), "")), nrow(cls))
    rev_g <- rev(genes)

    heat <- plot_ly(x = samples, y = rev_g, z = z[rev_g, , drop = FALSE], type = "heatmap",
        text = hover[match(rev_g, genes), , drop = FALSE], hoverinfo = "text", colorscale = colorscale,
        zmin = -0.5, zmax = k + 0.5, showscale = FALSE, xgap = 1, ygap = 1)
    # Legend entries: 1px markers (plotly leaves a trace without points out of
    # the legend), drawn there at a set size (`itemsizing` below).
    for (cl in lv) {
        heat <- add_trace(heat, type = "scatter", mode = "markers", x = samples[1], y = rev_g[1],
            marker = list(color = pal[[cl]], symbol = "square", size = 1), name = gsub("_", " ", cl),
            legendgroup = cl, showlegend = TRUE, hoverinfo = "skip", inherit = FALSE)
    }
    heat <- layout(heat,
        xaxis = list(type = "category", categoryorder = "array", categoryarray = samples, showgrid = FALSE,
            zeroline = FALSE, showticklabels = isTRUE(show.sample.names), tickangle = -90, title = list(text = "")),
        yaxis = list(type = "category", categoryorder = "array", categoryarray = rev_g, showgrid = FALSE,
            zeroline = FALSE, title = list(text = ""))
    )

    rows <- list()
    if (isTRUE(show.tmb)) {
        ss <- .maf_sample_summary(m)
        ss <- ss[match(samples, ss$Tumor_Sample_Barcode), , drop = FALSE]
        tmb_lv <- c(intersect(names(.maf_vc_colors), names(ss)), setdiff(setdiff(names(ss),
            c("Tumor_Sample_Barcode", "total")), names(.maf_vc_colors)))
        tmb_pal <- .maf_class_colors(tmb_lv, colors)
        top <- plot_ly()
        for (cl in tmb_lv) {
            top <- add_bars(top, x = samples, y = ss[[cl]], marker = list(color = tmb_pal[[cl]]),
                name = gsub("_", " ", cl), legendgroup = cl, showlegend = FALSE, hoverinfo = "text",
                textposition = "none",
                text = sprintf("%s<br>%s: %d<br>Total: %d", samples, gsub("_", " ", cl), ss[[cl]], ss$total))
        }
        top <- layout(top, barmode = "stack",
            xaxis = list(type = "category", categoryorder = "array", categoryarray = samples),
            yaxis = list(title = list(text = "Variants"), showgrid = FALSE, zeroline = FALSE))
        rows$top <- top
    }

    right <- NULL
    if (isTRUE(show.gene.bar)) {
        right <- plot_ly()
        for (cl in lv) {
            n <- rowSums(cls[rev_g, , drop = FALSE] == cl)
            right <- add_bars(right, y = rev_g, x = 100 * n / n_all, orientation = "h",
                marker = list(color = pal[[cl]]), name = gsub("_", " ", cl), legendgroup = cl, showlegend = FALSE,
                hoverinfo = "text", textposition = "none",
                text = sprintf("%s<br>%s: %d samples", rev_g, gsub("_", " ", cl), n))
        }
        right <- layout(right, barmode = "stack",
            yaxis = list(type = "category", categoryorder = "array", categoryarray = rev_g),
            xaxis = list(title = list(text = "% samples"), showgrid = FALSE, zeroline = FALSE))
    }

    tracks <- intersect(clinical.tracks, .maf_track_cols(m))
    if (length(tracks)) rows$tracks <- .onco_tracks(m, samples, tracks)

    # A filler for the corners. It shares its row's y-axis and its column's
    # x-axis, so it must not set either.
    empty <- function() plot_ly(type = "scatter", mode = "markers")
    plots <- list()
    heights <- numeric(0)
    if (!is.null(rows$top)) {
        plots <- c(plots, list(rows$top), if (!is.null(right)) list(empty()))
        heights <- c(heights, 0.18)
    }
    plots <- c(plots, list(heat), if (!is.null(right)) list(right))
    heights <- c(heights, 1)
    if (!is.null(rows$tracks)) {
        plots <- c(plots, list(rows$tracks), if (!is.null(right)) list(empty()))
        heights <- c(heights, 0.045 * length(tracks))
    }
    heights[heights == 1] <- 1 - sum(heights[heights != 1])

    fig <- subplot(plots, nrows = length(heights), heights = heights,
        widths = if (!is.null(right)) c(0.86, 0.14) else 1, shareX = TRUE, shareY = TRUE, titleX = TRUE,
        titleY = TRUE, margin = 0.004)
    fig <- layout(fig, barmode = "stack", title = list(text = main %||% ""), plot_bgcolor = "#FFFFFF",
        xaxis = list(showticklabels = isTRUE(show.sample.names), tickangle = -90),
        legend = list(itemsizing = "constant", traceorder = "grouped"))

    gs <- data.frame(gene = genes, mutated.samples = rowSums(cls != ""),
        percent = round(100 * rowSums(cls != "") / n_all, 1), stringsAsFactors = FALSE)
    for (cl in lv) gs[[cl]] <- rowSums(cls == cl)
    rownames(gs) <- NULL
    attr(fig, "table") <- gs
    fig
}


#' Sample annotation tracks for an oncoplot
#'
#' One heatmap row per track: discrete annotations on dittoSeq's palette (each
#' track offset so two never share colours), numeric ones on a viridis scale.
#'
#' @param m A result of [.maf_table()].
#' @param samples The samples, in plot order.
#' @param tracks The annotation columns.
#' @return A `plotly` object.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_onco_tracks
#' @keywords internal
.onco_tracks <- function(m, samples, tracks) {
    cl <- m$clinical[match(samples, m$clinical$Tumor_Sample_Barcode), , drop = FALSE]
    base <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
    offset <- 0
    # Tracks sit at numeric heights (first at the top) labelled by name: a
    # one-row heatmap on a category axis is drawn a row off. Legend entries sit
    # below the range, out of sight.
    pos <- stats::setNames(rev(seq_along(tracks)), tracks)
    fig <- plot_ly()
    for (tr in tracks) {
        v <- cl[[tr]]
        y <- pos[[tr]]
        if (is.numeric(v)) {
            # Clinical tables carry -Inf and the like for "not recorded".
            v[!is.finite(v)] <- NA
            fig <- add_trace(fig, type = "heatmap", x = samples, y = I(y), z = matrix(v, 1), colorscale = "Viridis",
                showscale = FALSE, xgap = 1, hoverinfo = "text", text = matrix(sprintf("%s<br>%s: %s", samples, tr,
                    ifelse(is.na(v), "NA", format(v, digits = 4))), 1))
            next
        }
        v <- as.character(v)
        lv <- sort(unique(v[!is.na(v)]))
        cols <- base[(offset + seq_along(lv) - 1) %% length(base) + 1]
        offset <- offset + length(lv)
        codes <- match(v, lv)
        steps <- c("#FFFFFF", cols)
        cs <- unlist(lapply(seq_along(steps), function(i) {
            list(list((i - 1) / length(steps), steps[i]), list(i / length(steps), steps[i]))
        }), recursive = FALSE)
        fig <- add_trace(fig, type = "heatmap", x = samples, y = I(y), z = matrix(ifelse(is.na(codes), 0, codes), 1),
            colorscale = cs, zmin = -0.5, zmax = length(lv) + 0.5, showscale = FALSE, xgap = 1, hoverinfo = "text",
            text = matrix(sprintf("%s<br>%s: %s", samples, tr, ifelse(is.na(v), "NA", v)), 1))
        for (i in seq_along(lv)) {
            fig <- add_trace(fig, type = "scatter", mode = "markers", x = samples[1], y = -1,
                marker = list(color = cols[i], symbol = "square", size = 1), name = lv[i], legendgroup = tr,
                legendgrouptitle = list(text = tr), showlegend = TRUE, hoverinfo = "skip")
        }
    }
    layout(fig,
        xaxis = list(type = "category", categoryorder = "array", categoryarray = samples, showgrid = FALSE),
        yaxis = list(tickvals = unname(pos), ticktext = names(pos), range = c(0.5, length(tracks) + 0.5),
            showgrid = FALSE, zeroline = FALSE, title = list(text = ""))
    )
}
