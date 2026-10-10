# Summary panels mafSummary() can draw, in dashboard order.
.mafsum_panels <- c(
    "Variant classification" = "classification", "Variant type" = "type", "SNV class" = "snv",
    "Variants per sample" = "per.sample", "Classification per sample" = "box", "Top mutated genes" = "genes"
)


#' Interactive summary of a MAF
#'
#' The interactive counterpart of [maftools::plotmafSummary()]: up to six panels
#' summarising the non-synonymous variants of a cohort - counts per variant
#' classification, per variant type and per substitution class (silent
#' substitutions included, as maftools counts them), variants per sample stacked
#' by classification with the median marked, the per-sample spread of each
#' classification, and the most frequently mutated genes with the percentage of
#' samples each is mutated in.
#'
#' maftools draws its summary with base graphics, so this is built natively in
#' plotly from the same tables; maftools itself is not needed.
#'
#' @param maf A maftools `MAF` object or a data frame in MAF columns (see
#'   [oncoPlot()]). The substitution-class panel also needs `Reference_Allele`
#'   and `Tumor_Seq_Allele2`, and the variant-type panel `Variant_Type`.
#' @param panels The panels to draw, any of `"classification"`, `"type"`,
#'   `"snv"`, `"per.sample"`, `"box"` and `"genes"`, in that order.
#' @param top.n The number of genes in the `"genes"` panel.
#' @param colors A named vector of variant-class colours, overriding maftools'
#'   palette for the classes it names.
#' @param show.median Logical; mark the median variants per sample.
#' @param main Optional plot title.
#'
#' @return A `plotly` object. The per-sample variant counts by classification
#'   (maftools' `getSampleSummary()`) are attached as attribute `"table"`.
#'
#' @import plotly
#' @seealso [mafSummaryServer()], [maftools::plotmafSummary()], [oncoPlot()]
#' @export
#' @author Jared Andrews
#' @examples
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     # The TCGA LAML cohort maftools ships, with its clinical annotations.
#'     laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
#'         comment.char = "#")
#'     clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
#'     laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
#'     mafSummary(laml)
#' }
mafSummary <- function(maf, panels = c("classification", "type", "snv", "per.sample", "box", "genes"), top.n = 10,
                       colors = NULL, show.median = TRUE, main = NULL) {
    m <- .maf_table(maf)
    panels <- intersect(.mafsum_panels, panels)
    if (!"Variant_Type" %in% names(m$data)) panels <- setdiff(panels, "type")
    if (!all(c("Reference_Allele", "Tumor_Seq_Allele2") %in% names(m$data))) panels <- setdiff(panels, "snv")
    if (!length(panels)) stop("No summary panel can be drawn from this MAF.", call. = FALSE)

    d <- m$data[m$data$nonsyn, , drop = FALSE]
    ss <- .maf_sample_summary(m)
    vcs <- setdiff(names(ss), c("Tumor_Sample_Barcode", "total"))
    vcs <- c(intersect(names(.maf_vc_colors), vcs), setdiff(vcs, names(.maf_vc_colors)))
    pal <- .maf_class_colors(vcs, colors)
    label <- function(x) gsub("_", " ", x)
    # Each class gets one legend entry, from whichever panel draws it first.
    legend <- new.env(parent = emptyenv())
    legend$shown <- character(0)
    legend_once <- function(cl) {
        first <- !cl %in% legend$shown
        legend$shown <- union(legend$shown, cl)
        first
    }

    build <- list(
        classification = function() {
            n <- vapply(vcs, function(v) sum(ss[[v]]), numeric(1))
            o <- order(n)
            p <- plot_ly()
            for (i in o) {
                p <- add_bars(p, y = label(vcs[i]), x = n[i], orientation = "h", marker = list(color = pal[[i]]),
                    name = label(vcs[i]), legendgroup = vcs[i], showlegend = legend_once(vcs[i]),
                    hoverinfo = "text", textposition = "none", text = sprintf("%s: %d", label(vcs[i]), n[i]))
            }
            layout(p, yaxis = list(type = "category", categoryorder = "array", categoryarray = label(vcs[o])),
                xaxis = list(title = list(text = "Variants")))
        },
        type = function() {
            n <- table(d$Variant_Type)
            types <- names(n)
            cols <- .maf_type_colors[types]
            cols[is.na(cols)] <- "#D9D9D9"
            plot_ly(x = types, y = as.vector(n), type = "bar", marker = list(color = unname(cols)),
                showlegend = FALSE, hoverinfo = "text", textposition = "none",
                text = sprintf("%s: %d", types, as.vector(n))) |>
                layout(xaxis = list(type = "category"), yaxis = list(title = list(text = "Variants")))
        },
        snv = function() {
            tv <- .maf_titv(m, use.syn = TRUE)
            cls <- c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G")
            n <- vapply(cls, function(cl) sum(tv[[cl]]), numeric(1))
            plot_ly(y = cls, x = n, type = "bar", orientation = "h",
                marker = list(color = unname(.maf_titv_colors[cls])), showlegend = FALSE, hoverinfo = "text",
                textposition = "none", text = sprintf("%s: %d", cls, n)) |>
                layout(yaxis = list(type = "category", categoryorder = "array", categoryarray = rev(cls)),
                    xaxis = list(title = list(text = "Substitutions")))
        },
        per.sample = function() {
            p <- plot_ly()
            for (v in vcs) {
                p <- add_bars(p, x = ss$Tumor_Sample_Barcode, y = ss[[v]], marker = list(color = pal[[v]]),
                    name = label(v), legendgroup = v, showlegend = legend_once(v), hoverinfo = "text",
                    textposition = "none", text = sprintf("%s<br>%s: %d<br>Total: %d", ss$Tumor_Sample_Barcode,
                        label(v), ss[[v]], ss$total))
            }
            if (isTRUE(show.median)) {
                med <- stats::median(ss$total)
                p <- add_trace(p, type = "scatter", mode = "lines", x = ss$Tumor_Sample_Barcode[c(1, nrow(ss))],
                    y = c(med, med), line = list(color = "#7F7F7F", dash = "dash", width = 1.5), showlegend = FALSE,
                    hoverinfo = "text", text = sprintf("Median: %s", format(med)))
            }
            layout(p, xaxis = list(type = "category", categoryorder = "array", categoryarray = ss$Tumor_Sample_Barcode,
                showticklabels = FALSE), yaxis = list(title = list(text = "Variants")))
        },
        box = function() {
            p <- plot_ly()
            for (v in vcs) {
                p <- add_trace(p, type = "box", y = ss[[v]], name = label(v), marker = list(color = pal[[v]]),
                    line = list(color = pal[[v]]), fillcolor = pal[[v]], legendgroup = v,
                    showlegend = legend_once(v), boxpoints = FALSE)
            }
            layout(p, xaxis = list(showticklabels = FALSE), yaxis = list(title = list(text = "Variants per sample")))
        },
        genes = function() {
            gs <- utils::head(.maf_gene_summary(m), top.n)
            gs <- gs[rev(seq_len(nrow(gs))), , drop = FALSE]
            pct <- sprintf("%.1f%%", 100 * gs$MutatedSamples / length(m$samples))
            p <- plot_ly()
            for (v in intersect(vcs, names(gs))) {
                p <- add_bars(p, y = gs$Hugo_Symbol, x = gs[[v]], orientation = "h", marker = list(color = pal[[v]]),
                    name = label(v), legendgroup = v, showlegend = legend_once(v), hoverinfo = "text",
                    textposition = "none", text = sprintf("%s (%s of samples)<br>%s: %d", gs$Hugo_Symbol, pct,
                        label(v), gs[[v]]))
            }
            layout(p, yaxis = list(type = "category", categoryorder = "array", categoryarray = gs$Hugo_Symbol),
                xaxis = list(title = list(text = "Variants")))
        }
    )

    plots <- lapply(panels, function(p) build[[p]]())
    ncol <- min(3, length(plots))
    nrow <- ceiling(length(plots) / ncol)
    fig <- subplot(plots, nrows = nrow, titleX = TRUE, titleY = TRUE, margin = c(0.05, 0.05, 0.07, 0.07))
    fig <- layout(fig, barmode = "stack", title = list(text = main %||% ""),
        legend = list(traceorder = "normal"))

    # Panel titles above each panel's plotting area.
    titles <- names(.mafsum_panels)[match(panels, .mafsum_panels)]
    lay <- fig$x$layout
    anns <- lapply(seq_along(panels), function(i) {
        suffix <- if (i == 1) "" else i
        xd <- lay[[paste0("xaxis", suffix)]]$domain %||% c(0, 1)
        yd <- lay[[paste0("yaxis", suffix)]]$domain %||% c(0, 1)
        list(text = paste0("<b>", titles[i], "</b>"), x = mean(xd), y = yd[2], xref = "paper", yref = "paper",
            xanchor = "center", yanchor = "bottom", showarrow = FALSE, font = list(size = 13))
    })
    fig$x$layout$annotations <- c(fig$x$layout$annotations, anns)

    attr(fig, "table") <- ss
    fig
}
