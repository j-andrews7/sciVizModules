# Domain fill colours (a pastel palette, cycled by domain name).
.lollipop_domain_colors <- c(
    "#F3A683", "#F7D794", "#778BEB", "#E77F67", "#CF6A87", "#786FA6", "#F8A5C2", "#63CDDA", "#EA8685",
    "#596275", "#574B90", "#F78FB3", "#3DC1D3", "#E15F41", "#C44569"
)


#' Interactive lollipop plot of the mutations in a protein
#'
#' The interactive counterpart of [maftools::lollipopPlot()]: the non-synonymous
#' mutations of one gene along its protein, one stem per amino-acid position,
#' with a point per distinct protein change at the height of its count, coloured
#' by variant class, over the protein's domains. The most frequent positions are
#' labelled. Hovering gives the change, its class and count, or the domain.
#'
#' Positions are read from the protein-change column as maftools reads them
#' (`"p.R882H"` is position 882). Domains and the protein length come from
#' maftools' bundled Pfam/SMART table when maftools is installed (the longest
#' isoform, as `lollipopPlot()` chooses), or from `domains` and
#' `protein.length`; without either the protein runs to the last mutated
#' position and no domains are drawn.
#'
#' @param maf A maftools `MAF` object or a data frame in MAF columns (see
#'   [oncoPlot()]), with a protein-change column (`HGVSp_Short`,
#'   `Protein_Change` or `AAChange`).
#' @param gene The gene (HGNC symbol) to draw. Default: the most often mutated.
#' @param domains Optional data frame of domains, with columns `start`, `end`
#'   and `label` (any case); overrides maftools' table.
#' @param protein.length Optional protein length in amino acids.
#' @param colors A named vector of variant-class colours, overriding maftools'
#'   palette for the classes it names.
#' @param label.top The number of most mutated positions to label.
#' @param point.size Marker size.
#' @param show.domains Logical; draw the domains.
#' @param main Optional plot title. Default: the gene, with the isoform and
#'   length when known.
#'
#' @return A `plotly` object. The plotted counts (one row per position, change
#'   and class) are attached as attribute `"table"`.
#'
#' @import plotly
#' @seealso [mutationLollipopServer()], [maftools::lollipopPlot()]
#' @export
#' @author Jared Andrews
#' @examples
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     # The TCGA LAML cohort maftools ships, with its clinical annotations.
#'     laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
#'         comment.char = "#")
#'     clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
#'     laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
#'     mutationLollipop(laml, gene = "DNMT3A")
#' }
mutationLollipop <- function(maf, gene = NULL, domains = NULL, protein.length = NULL, colors = NULL,
                             label.top = 3, point.size = 10, show.domains = TRUE, main = NULL) {
    m <- .maf_table(maf)
    gene <- gene %||% .maf_gene_summary(m)$Hugo_Symbol[1]
    d <- m$data[m$data$nonsyn & m$data$Hugo_Symbol %in% gene, , drop = FALSE]
    prot <- .maf_protein_col(d)
    if (is.null(prot)) stop("The MAF has no protein-change column (HGVSp_Short, Protein_Change or AAChange).",
        call. = FALSE)
    if (!nrow(d)) stop(gene, " carries no non-synonymous variant.", call. = FALSE)
    d$pos <- .maf_protein_position(d[[prot]])
    d$change <- sub("^p\\.", "", as.character(d[[prot]]))
    dropped <- sum(is.na(d$pos))
    d <- d[!is.na(d$pos), , drop = FALSE]
    if (!nrow(d)) stop("No protein position could be read for ", gene, ".", call. = FALSE)

    tab <- stats::aggregate(list(count = rep(1L, nrow(d))),
        by = list(pos = d$pos, change = d$change, class = d$Variant_Classification), FUN = sum)
    tab <- tab[order(tab$pos, -tab$count), , drop = FALSE]
    rownames(tab) <- NULL

    info <- if (!is.null(domains)) list(domains = .lollipop_domains(domains)) else .maf_domains(gene)
    len <- protein.length %||% info$length %||% max(tab$pos)
    top <- max(tab$count)
    bh <- max(0.3, top * 0.08)

    classes <- unique(tab$class)
    classes <- c(intersect(names(.maf_vc_colors), classes), setdiff(classes, names(.maf_vc_colors)))
    pal <- .maf_class_colors(classes, colors)

    fig <- plot_ly()
    # The protein backbone.
    fig <- add_trace(fig, type = "scatter", mode = "lines", x = c(0, len, len, 0, 0), y = c(-bh, -bh, 0, 0, -bh),
        fill = "toself", fillcolor = "#D9D9D9", line = list(color = "#BDBDBD", width = 1), hoverinfo = "text",
        text = sprintf("%s: %d aa", gene, as.integer(len)), hoveron = "fills", showlegend = FALSE)

    dom <- info$domains
    if (isTRUE(show.domains) && !is.null(dom) && nrow(dom)) {
        labels <- unique(dom$label)
        dcol <- stats::setNames(.lollipop_domain_colors[(seq_along(labels) - 1) %% length(.lollipop_domain_colors) + 1],
            labels)
        for (i in seq_len(nrow(dom))) {
            s <- dom$start[i]
            e <- dom$end[i]
            fig <- add_trace(fig, type = "scatter", mode = "lines", x = c(s, e, e, s, s),
                y = c(-bh * 1.5, -bh * 1.5, bh * 0.5, bh * 0.5, -bh * 1.5), fill = "toself",
                fillcolor = dcol[[dom$label[i]]], line = list(color = dcol[[dom$label[i]]], width = 1),
                name = dom$label[i], legendgroup = paste0("domain:", dom$label[i]),
                showlegend = !dom$label[i] %in% dom$label[seq_len(i - 1)], hoveron = "fills", hoverinfo = "text",
                text = sprintf("%s (%d-%d)", dom$label[i], as.integer(s), as.integer(e)))
        }
    }

    # Stems, from the backbone to the highest point at each position.
    stem <- stats::aggregate(list(count = tab$count), by = list(pos = tab$pos), FUN = max)
    fig <- add_trace(fig, type = "scatter", mode = "lines", x = as.vector(rbind(stem$pos, stem$pos, NA)),
        y = as.vector(rbind(0, stem$count, NA)), line = list(color = "#7F7F7F", width = 1), hoverinfo = "skip",
        showlegend = FALSE)

    for (cl in classes) {
        t <- tab[tab$class == cl, , drop = FALSE]
        fig <- add_trace(fig, type = "scatter", mode = "markers", x = t$pos, y = t$count, name = gsub("_", " ", cl),
            marker = list(color = pal[[cl]], size = point.size, line = list(color = "#FFFFFF", width = 1)),
            hoverinfo = "text", text = sprintf("p.%s<br>%s<br>%d sample%s", t$change, gsub("_", " ", cl), t$count,
                ifelse(t$count == 1, "", "s")))
    }

    anns <- list()
    if (label.top > 0) {
        by_pos <- stats::aggregate(list(count = tab$count), by = list(pos = tab$pos), FUN = sum)
        hot <- utils::head(by_pos[order(-by_pos$count, by_pos$pos), , drop = FALSE], label.top)
        for (p in hot$pos) {
            at <- tab[tab$pos == p, , drop = FALSE]
            anns[[length(anns) + 1]] <- list(x = p, y = max(at$count), text = at$change[which.max(at$count)],
                showarrow = FALSE, yanchor = "bottom", yshift = point.size / 2 + 2, xref = "x", yref = "y",
                font = list(size = 11))
        }
    }

    title <- main %||% paste0(gene, if (!is.null(info$refseq)) sprintf(" (%s, %d aa)", info$refseq, as.integer(len)))
    ticks <- pretty(c(0, top))
    fig <- layout(fig,
        title = list(text = title),
        xaxis = list(title = list(text = "Amino acid position"), range = c(-len * 0.01, len * 1.01),
            showgrid = FALSE, zeroline = FALSE),
        yaxis = list(title = list(text = "Mutations"), range = c(-bh * 2, top * 1.25 + 0.5),
            tickvals = ticks[ticks >= 0], showgrid = FALSE, zeroline = FALSE),
        annotations = anns
    )
    if (dropped > 0) {
        fig$x$layout$annotations <- c(fig$x$layout$annotations, list(list(
            x = 1, y = 1, xref = "paper", yref = "paper", xanchor = "right", yanchor = "top", showarrow = FALSE,
            text = sprintf("%d variant%s without a protein position not shown", dropped, if (dropped == 1) "" else "s"),
            font = list(size = 10, color = "#7F7F7F")
        )))
    }
    attr(fig, "table") <- tab
    fig
}


#' Normalise a user-supplied domain table
#'
#' @param domains A data frame with start, end and label columns (any case;
#'   `Start`/`End`/`Label` as in maftools' table).
#' @return A data frame with `start`, `end` and `label`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_lollipop_domains
#' @keywords internal
.lollipop_domains <- function(domains) {
    domains <- as.data.frame(domains)
    names(domains) <- tolower(names(domains))
    if (!all(c("start", "end") %in% names(domains))) {
        stop("'domains' needs start and end columns.", call. = FALSE)
    }
    data.frame(
        start = as.numeric(domains$start), end = as.numeric(domains$end),
        label = as.character(domains$label %||% domains$name %||% "domain"), stringsAsFactors = FALSE
    )
}
