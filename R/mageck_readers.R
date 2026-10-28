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
        c("Beta" = "lfc", "z-score" = "score", "Signed -log10(FDR)" = "fdr")
    } else {
        c("Log2 fold change" = "lfc", "Signed -log10(RRA score)" = "score", "Signed -log10(FDR)" = "fdr")
    }
}


#' Prepare a MAGeCK gene summary for the rank plot
#'
#' Every statistic is signed by the direction of its effect, negative for
#' depletion and positive for enrichment, so depleted and enriched genes share
#' one plot: the most depleted gene ranks first and the most enriched last.
#' Genes are ranked by the statistic on the y-axis, so the curve rises steadily.
#'
#' An RRA summary tests each gene for depletion and for enrichment. Each gene
#' takes the side with the smaller RRA score, and its score and FDR are that
#' side's, negated for depletion. A hit is a gene whose FDR on that side is
#' below `fdr.threshold`. The log2 fold change needs no sign.
#'
#' An MLE summary is plotted for one condition. Its beta and z-score are signed
#' already. Its FDR is two-sided, so it takes the sign of the beta, and a hit is
#' "Depleted" or "Enriched" by that sign.
#'
#' @param df A MAGeCK RRA or MLE gene summary, raw or tidied.
#' @param metric `"lfc"` (log2 fold change, or beta for MLE), `"score"`
#'   (signed -log10 RRA score, or the z-score for MLE) or `"fdr"` (signed
#'   -log10 FDR).
#' @param fdr.threshold FDR below which a gene is a hit.
#' @param condition For an MLE summary, the condition to plot. Defaults to the
#'   first; ignored for RRA.
#' @return The tidy table with `screen.rank`, `screen.metric`, `screen.lfc`
#'   (beta for MLE), `screen.fdr` (the FDR behind the gene's call) and
#'   `screen.group` ("Depleted" / "Enriched" / "n.s.") added, sorted by rank.
#'   The `"mageck_type"` attribute is kept, and an MLE table records the
#'   plotted condition in `"mageck_condition"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_crispr_prepare
#' @keywords internal
.crispr_prepare <- function(df, metric = "lfc", fdr.threshold = 0.05, condition = NULL) {
    df <- .mageck_tidy(df)
    type <- attr(df, "mageck_type")
    metric <- match.arg(metric, c("lfc", "score", "fdr"))
    # The data filter hands character columns over as factors; labels need the text.
    df$gene <- as.character(df$gene)
    neglog <- function(v) {
        floor <- min(v[v > 0], na.rm = TRUE)
        -log10(pmax(v, floor))
    }

    if (identical(type, "rra")) {
        lfc <- df$neg.lfc
        # Each gene takes the side it scores better on. NA scores lose.
        depleted <- !is.na(df$neg.score) & (is.na(df$pos.score) | df$neg.score <= df$pos.score)
        sign <- ifelse(depleted, -1, 1)
        score <- ifelse(depleted, df$neg.score, df$pos.score)
        fdr <- ifelse(depleted, df$neg.fdr, df$pos.fdr)
        signed_score <- sign * neglog(score)
        value <- switch(metric, lfc = lfc, score = signed_score, fdr = sign * neglog(fdr))
        tiebreak <- if (identical(metric, "score")) lfc else signed_score
    } else {
        conds <- .mageck_conditions(df)
        condition <- if (nz_value(condition) && condition %in% conds) condition else conds[1]
        col <- function(stat) df[[paste0(condition, ".", stat)]]
        lfc <- col("beta")
        fdr <- col("fdr")
        depleted <- !is.na(lfc) & lfc < 0
        sign <- ifelse(depleted, -1, 1)
        value <- switch(metric, lfc = lfc, score = col("z"), fdr = sign * neglog(fdr))
        tiebreak <- lfc
    }
    hit <- !is.na(fdr) & fdr < fdr.threshold

    rank <- integer(nrow(df))
    rank[order(value, tiebreak)] <- seq_len(nrow(df))
    df$screen.rank <- rank
    df$screen.lfc <- lfc
    df$screen.fdr <- fdr
    df$screen.metric <- value
    df$screen.group <- factor(
        ifelse(hit, ifelse(depleted, "Depleted", "Enriched"), "n.s."),
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
        metric = "lfc",
        fdr.threshold = 0.05,
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
.crispr_keys <- c("metric", "fdr.threshold", "condition")


#' Add the CRISPR rank plot's layers to the wrapped scatter figure
#'
#' The `fig.fn` hook [crisprScreenRankServer()] hands to the scatter module:
#' axis titles for the metric, and the FDR cut-offs (one per direction) when
#' the metric is the FDR. Only applied while the axes are the rank and the
#' metric with no adjustment or split. Gene labels come from the scatter
#' module's own Annotations controls.
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

    metric <- isolate_fn(input$metric) %||% "lfc"
    fig$x$layout$xaxis$title$text <- "Gene rank"
    labels <- .crispr_metric_labels(attr(prepared, "mageck_type") %||% "rra")
    fig$x$layout$yaxis$title$text <- names(labels)[labels == metric]

    thr <- isolate_fn(input$fdr.threshold)
    if (identical(metric, "fdr") && is.numeric(thr) && length(thr) == 1 && !is.na(thr) && thr > 0 && thr < 1) {
        fig$x$layout$shapes <- c(fig$x$layout$shapes, lapply(c(-1, 1) * -log10(thr), function(y) list(
            type = "line", xref = "paper", x0 = 0, x1 = 1, yref = "y", y0 = y, y1 = y,
            line = list(color = "#7F7F7F", dash = "dash", width = 1)
        )))
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
