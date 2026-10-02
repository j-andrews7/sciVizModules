#' Read a MAGeCK gene summary
#'
#' Reads the gene-level output of MAGeCK, the standard tool for pooled CRISPR
#' screens, into a tidy data frame. Both summaries are recognised:
#' \itemize{
#'   \item `mageck test` (robust rank aggregation) `<prefix>.gene_summary.txt`,
#'     with `id`, `num` and, for each of negative (depletion) and positive
#'     (enrichment) selection, `score`, `p-value`, `fdr`, `rank`, `goodsgrna`
#'     and `lfc`.
#'   \item `mageck mle` `<prefix>.gene_summary.txt`, with `Gene`, `sgRNA` and,
#'     for each condition, `beta`, `z`, `p-value`, `fdr`, `wald-p-value` and
#'     `wald-fdr`.
#' }
#' The file may be gzip-compressed.
#'
#' @param file Path to a MAGeCK `gene_summary.txt`.
#' @return A data frame. For RRA: `gene`, `n.sgrna`, then `neg.score`,
#'   `neg.p`, `neg.fdr`, `neg.rank`, `neg.goodsgrna`, `neg.lfc` and the
#'   matching `pos.*` columns. For MLE: `gene`, `n.sgrna`, then
#'   `<condition>.beta`, `.z`, `.p`, `.fdr`, `.wald.p`, `.wald.fdr` per
#'   condition. The attribute `"mageck_type"` is `"rra"` or `"mle"`.
#'
#' @importFrom utils read.delim
#' @seealso [crisprScreenRankServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' screen <- read_mageck(system.file("extdata", "example_mageck.gene_summary.txt.gz",
#'     package = "sciVizModules"))
#' head(screen)
read_mageck <- function(file) {
    if (!file.exists(file)) stop("File not found: ", file, call. = FALSE)
    con <- gzfile(file, "rt")
    on.exit(close(con))
    raw <- utils::read.delim(con, check.names = FALSE, stringsAsFactors = FALSE)
    .mageck_tidy(raw)
}


#' Tidy a MAGeCK gene summary table
#'
#' Renames the `selection|statistic` columns of a MAGeCK gene summary (as read
#' with `read.delim(check.names = FALSE)`) to `selection.statistic`. A table
#' already tidied by [read_mageck()] is returned unchanged.
#'
#' @param df The table.
#' @return The tidy table, with attribute `"mageck_type"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_mageck_tidy
#' @keywords internal
.mageck_tidy <- function(df) {
    df <- as.data.frame(df, stringsAsFactors = FALSE)
    nm <- names(df)
    if (all(c("gene", "neg.rank", "pos.rank") %in% nm)) {
        attr(df, "mageck_type") <- "rra"
        return(df)
    }
    if ("gene" %in% nm && any(grepl("\\.beta$", nm))) {
        attr(df, "mageck_type") <- "mle"
        return(df)
    }

    rename <- function(x) {
        x <- sub("wald-p-value$", "wald.p", x)
        x <- sub("wald-fdr$", "wald.fdr", x)
        x <- sub("p-value$", "p", x)
        gsub("|", ".", x, fixed = TRUE)
    }

    if (all(c("id", "num", "neg|score", "pos|score") %in% nm)) {
        names(df) <- rename(nm)
        names(df)[names(df) == "id"] <- "gene"
        names(df)[names(df) == "num"] <- "n.sgrna"
        attr(df, "mageck_type") <- "rra"
        return(df)
    }
    if (all(c("Gene", "sgRNA") %in% nm) && any(grepl("|beta", nm, fixed = TRUE))) {
        names(df) <- rename(nm)
        names(df)[names(df) == "Gene"] <- "gene"
        names(df)[names(df) == "sgRNA"] <- "n.sgrna"
        attr(df, "mageck_type") <- "mle"
        return(df)
    }
    stop("Not a MAGeCK gene summary: expected the `mageck test` columns (id, num, neg|score, ...) ",
        "or the `mageck mle` columns (Gene, sgRNA, <condition>|beta, ...).", call. = FALSE)
}


#' Prepare a MAGeCK RRA summary for the rank plot
#'
#' @param df A MAGeCK RRA gene summary, raw or tidied.
#' @param direction `"neg"` (depletion) or `"pos"` (enrichment).
#' @param metric `"lfc"`, `"score"` (-log10 RRA score) or `"fdr"` (-log10 FDR).
#' @param fdr.threshold FDR below which a gene is a hit.
#' @return The tidy table with `screen.rank`, `screen.metric`, `screen.lfc`,
#'   `screen.fdr` and `screen.group` ("Depleted" / "Enriched" / "n.s.") added,
#'   sorted by rank.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_prepare
#' @keywords internal
.crispr_prepare <- function(df, direction = "neg", metric = "lfc", fdr.threshold = 0.05) {
    df <- .mageck_tidy(df)
    if (!identical(attr(df, "mageck_type"), "rra")) {
        stop("The rank plot takes a `mageck test` (RRA) gene summary; this is `mageck mle` output.", call. = FALSE)
    }
    direction <- match.arg(direction, c("neg", "pos"))
    col <- function(stat) df[[paste0(direction, ".", stat)]]
    neglog <- function(v) {
        floor <- min(v[v > 0], na.rm = TRUE)
        -log10(pmax(v, floor))
    }
    df$screen.rank <- col("rank")
    df$screen.lfc <- col("lfc")
    df$screen.fdr <- col("fdr")
    df$screen.metric <- switch(match.arg(metric, c("lfc", "score", "fdr")),
        lfc = col("lfc"),
        score = neglog(col("score")),
        fdr = neglog(col("fdr"))
    )
    hit <- !is.na(df$screen.fdr) & df$screen.fdr < fdr.threshold
    df$screen.group <- factor(
        ifelse(hit, if (direction == "neg") "Depleted" else "Enriched", "n.s."),
        levels = c("Depleted", "Enriched", "n.s.")
    )
    df <- df[order(df$screen.rank), , drop = FALSE]
    rownames(df) <- NULL
    attr(df, "mageck_type") <- "rra"
    df
}


#' Default inputs for the CRISPR screen rank module
#'
#' @param data The gene summary (raw or tidy), or `NULL`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_defaults
#' @keywords internal
.crispr_defaults <- function(data, defaults = NULL) {
    base <- list(
        direction = "neg",
        metric = "lfc",
        fdr.threshold = 0.05,
        n.labels = 10,
        label.size = 11,
        x.by = "screen.rank",
        y.by = "screen.metric",
        color.by = "screen.group",
        color.panel = c(Depleted = "#2166AC", Enriched = "#B2182B", n.s. = "#BFBFBF"),
        hover.data = c("gene", "n.sgrna", "screen.lfc", "screen.fdr"),
        annotate.by = "gene"
    )
    utils::modifyList(base, defaults %||% list())
}

# Inputs the CRISPR module adds to the wrapped scatter module.
.crispr_keys <- c("direction", "metric", "fdr.threshold", "n.labels", "label.size")


#' Add the CRISPR rank plot's layers to the wrapped scatter figure
#'
#' The `fig.fn` hook [crisprScreenRankServer()] hands to the scatter module:
#' axis titles for the chosen direction and metric, labels on the top-ranked
#' genes, and the FDR cut-off when the metric is the FDR. Only applied while the
#' axes are the rank and the metric with no adjustment or split.
#'
#' @param fig The scatter figure.
#' @param prepared The prepared table from [.crispr_prepare()].
#' @param input The module's input.
#' @param isolate_fn The module's isolation helper.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_layers
#' @keywords internal
.crispr_layers <- function(fig, prepared, input, isolate_fn) {
    adjusted <- any(vapply(
        list(isolate_fn(input$x.adjustment), isolate_fn(input$x.adj.fxn),
            isolate_fn(input$y.adjustment), isolate_fn(input$y.adj.fxn)),
        nz_value, logical(1)
    ))
    on_axes <- identical(isolate_fn(input$x.by), "screen.rank") && identical(isolate_fn(input$y.by), "screen.metric")
    if (!on_axes || adjusted || nz_value(isolate_fn(input$split.by))) {
        return(fig)
    }

    direction <- isolate_fn(input$direction) %||% "neg"
    metric <- isolate_fn(input$metric) %||% "lfc"
    fig$x$layout$xaxis$title$text <- if (identical(direction, "pos")) "Gene rank (enrichment)" else "Gene rank (depletion)"
    fig$x$layout$yaxis$title$text <- switch(metric,
        lfc = "Log2 fold change", score = "-log10(RRA score)", fdr = "-log10(FDR)"
    )

    thr <- isolate_fn(input$fdr.threshold)
    if (identical(metric, "fdr") && is.numeric(thr) && length(thr) == 1 && !is.na(thr) && thr > 0 && thr < 1) {
        fig$x$layout$shapes <- c(fig$x$layout$shapes, list(list(
            type = "line", xref = "paper", x0 = 0, x1 = 1, yref = "y", y0 = -log10(thr), y1 = -log10(thr),
            line = list(color = "#7F7F7F", dash = "dash", width = 1)
        )))
    }

    n <- isolate_fn(input$n.labels) %||% 0
    if (is.numeric(n) && !is.na(n) && n > 0) {
        top <- utils::head(prepared, n)
        size <- isolate_fn(input$label.size) %||% 11
        fig$x$layout$annotations <- c(fig$x$layout$annotations, lapply(seq_len(nrow(top)), function(i) {
            list(
                x = top$screen.rank[i], y = top$screen.metric[i], xref = "x", yref = "y",
                text = top$gene[i], showarrow = TRUE, arrowhead = 0, arrowwidth = 0.8, arrowcolor = "#7F7F7F",
                ax = 30, ay = if (top$screen.metric[i] < 0) 12 else -12, font = list(size = size)
            )
        }))
    }
    fig
}


#' The bundled MAGeCK example
#'
#' @return The simulated RRA gene summary in `inst/extdata`, read with [read_mageck()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_example
#' @keywords internal
.crispr_example <- function() {
    read_mageck(system.file("extdata", "example_mageck.gene_summary.txt.gz", package = "sciVizModules"))
}
