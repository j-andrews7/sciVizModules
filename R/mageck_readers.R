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
#' The file may be gzip-compressed. A table read with `read.delim()`'s default
#' `check.names = TRUE` (`neg.p.value` rather than `neg|p-value`), as a Shiny
#' file upload reads it, is recognised too.
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
#'
#' mle <- read_mageck(system.file("extdata", "example_mageck_mle.gene_summary.txt.gz",
#'     package = "sciVizModules"))
#' head(mle)
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
#' with `read.delim(check.names = FALSE)`) to `selection.statistic`. The
#' `check.names = TRUE` spelling (`neg.p.value`, `drug.wald.p.value`) is renamed
#' the same way. A table already tidied by [read_mageck()] is returned unchanged.
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
        x <- gsub("|", ".", x, fixed = TRUE)
        # read.delim(check.names = TRUE) spells `neg|p-value` as `neg.p.value`.
        sub("\\.p\\.value$", ".p", x)
    }
    tidy <- rename(nm)

    if (all(c("id", "num", "neg.score", "pos.score") %in% tidy)) {
        names(df) <- tidy
        names(df)[names(df) == "id"] <- "gene"
        names(df)[names(df) == "num"] <- "n.sgrna"
        attr(df, "mageck_type") <- "rra"
        return(df)
    }
    if (all(c("Gene", "sgRNA") %in% tidy) && any(grepl("\\.beta$", tidy))) {
        names(df) <- tidy
        names(df)[names(df) == "Gene"] <- "gene"
        names(df)[names(df) == "sgRNA"] <- "n.sgrna"
        attr(df, "mageck_type") <- "mle"
        return(df)
    }
    stop("Not a MAGeCK gene summary: expected the `mageck test` columns (id, num, neg|score, ...) ",
        "or the `mageck mle` columns (Gene, sgRNA, <condition>|beta, ...).", call. = FALSE)
}


#' The conditions of a MAGeCK MLE gene summary
#'
#' @param df A MAGeCK gene summary, raw or tidied.
#' @return The conditions (the `<condition>` of each `<condition>.beta`
#'   column), or `character(0)` for an RRA summary.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_prepare
#' @keywords internal
.mageck_conditions <- function(df) {
    df <- .mageck_tidy(df)
    if (!identical(attr(df, "mageck_type"), "mle")) {
        return(character(0))
    }
    sub("\\.beta$", "", grep("\\.beta$", names(df), value = TRUE))
}


#' The y-axis choices of the CRISPR rank plot
#'
#' The keys are shared by both summaries, so `defaults` and Reset do not depend
#' on which one is loaded; only what they plot differs.
#'
#' @param type `"rra"` or `"mle"`.
#' @return A named character vector, labels as names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_prepare
#' @keywords internal
.crispr_metric_labels <- function(type = "rra") {
    if (identical(type, "mle")) {
        c("Beta" = "lfc", "z-score" = "score", "-log10(FDR)" = "fdr")
    } else {
        c("Log2 fold change" = "lfc", "-log10(RRA score)" = "score", "-log10(FDR)" = "fdr")
    }
}


#' Prepare a MAGeCK gene summary for the rank plot
#'
#' Genes are ranked by the statistic on the y-axis, so the plotted values fall
#' (or rise) steadily along the rank, with MAGeCK's own rank breaking ties.
#' For an RRA summary, `"score"` keeps MAGeCK's rank for the selection.
#' For an MLE summary, the statistics are those of one condition. `"lfc"` is
#' its beta and `"score"` its z-score, both signed so that the strongest effect
#' in the chosen direction ranks first. The MLE FDR is two-sided, so for
#' `"fdr"` the genes whose beta points the chosen way rank first, by FDR, and a
#' hit must point that way too.
#'
#' @param df A MAGeCK RRA or MLE gene summary, raw or tidied.
#' @param direction `"neg"` (depletion) or `"pos"` (enrichment).
#' @param metric `"lfc"` (log2 fold change, or beta for MLE), `"score"`
#'   (-log10 RRA score, or the z-score for MLE) or `"fdr"` (-log10 FDR).
#' @param fdr.threshold FDR below which a gene is a hit.
#' @param condition For an MLE summary, the condition to plot. Defaults to the
#'   first; ignored for RRA.
#' @return The tidy table with `screen.rank`, `screen.metric`, `screen.lfc`
#'   (beta for MLE), `screen.fdr` and `screen.group` ("Depleted" / "Enriched" /
#'   "n.s.") added, sorted by rank. The `"mageck_type"` attribute is kept, and an
#'   MLE table records the plotted condition in `"mageck_condition"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_prepare
#' @keywords internal
.crispr_prepare <- function(df, direction = "neg", metric = "lfc", fdr.threshold = 0.05, condition = NULL) {
    df <- .mageck_tidy(df)
    type <- attr(df, "mageck_type")
    direction <- match.arg(direction, c("neg", "pos"))
    metric <- match.arg(metric, c("lfc", "score", "fdr"))
    # The data filter hands character columns over as factors; labels need the text.
    df$gene <- as.character(df$gene)
    neglog <- function(v) {
        floor <- min(v[v > 0], na.rm = TRUE)
        -log10(pmax(v, floor))
    }
    # Signed so that the strongest effect in the chosen direction sorts first.
    sign <- if (direction == "neg") 1 else -1

    if (identical(type, "rra")) {
        col <- function(stat) df[[paste0(direction, ".", stat)]]
        lfc <- col("lfc")
        fdr <- col("fdr")
        mageck_rank <- col("rank")
        hit <- !is.na(fdr) & fdr < fdr.threshold
        value <- switch(metric, lfc = lfc, score = neglog(col("score")), fdr = neglog(fdr))
        key <- switch(metric,
            lfc = list(sign * lfc, mageck_rank),
            score = list(mageck_rank),
            fdr = list(fdr, mageck_rank)
        )
    } else {
        conds <- .mageck_conditions(df)
        condition <- if (nz_value(condition) && condition %in% conds) condition else conds[1]
        col <- function(stat) df[[paste0(condition, ".", stat)]]
        lfc <- col("beta")
        fdr <- col("fdr")
        z <- col("z")
        in_direction <- !is.na(lfc) & sign * lfc < 0
        hit <- in_direction & !is.na(fdr) & fdr < fdr.threshold
        value <- switch(metric, lfc = lfc, score = z, fdr = neglog(fdr))
        key <- switch(metric,
            lfc = list(sign * lfc),
            score = list(sign * z, sign * lfc),
            fdr = list(!in_direction, fdr, sign * lfc)
        )
    }

    rank <- integer(nrow(df))
    rank[do.call(order, key)] <- seq_len(nrow(df))
    df$screen.rank <- rank
    df$screen.lfc <- lfc
    df$screen.fdr <- fdr
    df$screen.metric <- value
    df$screen.group <- factor(
        ifelse(hit, if (direction == "neg") "Depleted" else "Enriched", "n.s."),
        levels = c("Depleted", "Enriched", "n.s.")
    )
    df <- df[order(df$screen.rank), , drop = FALSE]
    rownames(df) <- NULL
    attr(df, "mageck_type") <- type
    if (identical(type, "mle")) attr(df, "mageck_condition") <- condition
    df
}


#' Default inputs for the CRISPR screen rank module
#'
#' @param data The gene summary (raw or tidy), or `NULL`. For an MLE summary
#'   the default `condition` is its first.
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
    conds <- if (is.null(data)) character(0) else .mageck_conditions(data)
    if (length(conds)) base$condition <- conds[1]
    utils::modifyList(base, defaults %||% list())
}

# Inputs the CRISPR module adds to the wrapped scatter module.
.crispr_keys <- c("direction", "metric", "fdr.threshold", "n.labels", "label.size", "condition")


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
    labels <- .crispr_metric_labels(attr(prepared, "mageck_type") %||% "rra")
    fig$x$layout$yaxis$title$text <- names(labels)[labels == metric]

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
                text = as.character(top$gene[i]), showarrow = TRUE, arrowhead = 0, arrowwidth = 0.8,
                arrowcolor = "#7F7F7F",
                ax = 30, ay = if (top$screen.metric[i] < 0) 12 else -12, font = list(size = size)
            )
        }))
    }
    fig
}


#' The bundled MAGeCK examples
#'
#' @param type `"rra"` for the simulated `mageck test` gene summary, `"mle"`
#'   for the simulated `mageck mle` one.
#' @return The gene summary in `inst/extdata`, read with [read_mageck()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_example
#' @keywords internal
.crispr_example <- function(type = c("rra", "mle")) {
    file <- switch(match.arg(type),
        rra = "example_mageck.gene_summary.txt.gz",
        mle = "example_mageck_mle.gene_summary.txt.gz"
    )
    read_mageck(system.file("extdata", file, package = "sciVizModules"))
}
