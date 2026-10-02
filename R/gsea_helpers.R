#' Normalise a GSEA input to the bundle the GSEA module plots
#'
#' Accepts either an fgsea bundle - a list with `stats` (a named numeric vector
#' of gene-level statistics), `pathways` (a named list of gene sets) and
#' optionally `results` (the [fgsea::fgsea()] table) - or a clusterProfiler
#' `gseaResult`, whose `geneList`, `geneSets` and `result` slots hold the same
#' three things. The clusterProfiler object is read through its slots, so
#' neither clusterProfiler nor DOSE is needed.
#'
#' @param x The input.
#' @param arg Argument name for error messages.
#' @return A list with `stats`, `pathways`, `results` (a data frame with
#'   `pathway`, `ES`, `NES`, `pval`, `padj`, `size`, or `NULL`) and `labels`
#'   (display names for the pathways).
#'
#' @importFrom methods is slot
#' @author Jared Andrews
#' @rdname INTERNAL_gsea_input
#' @keywords internal
.gsea_input <- function(x, arg = "data") {
    if (methods::is(x, "gseaResult")) {
        res <- as.data.frame(methods::slot(x, "result"))
        x <- list(
            stats = methods::slot(x, "geneList"),
            pathways = methods::slot(x, "geneSets"),
            results = data.frame(
                pathway = res$ID, ES = res$enrichmentScore, NES = res$NES, pval = res$pvalue,
                padj = res$p.adjust, size = res$setSize, stringsAsFactors = FALSE
            ),
            labels = stats::setNames(as.character(res$Description %||% res$ID), res$ID)
        )
    }
    if (inherits(x, "gsea_bundle")) {
        return(x)
    }

    ok <- is.list(x) && is.numeric(x$stats) && !is.null(names(x$stats)) && is.list(x$pathways) &&
        length(x$pathways) > 0 && !is.null(names(x$pathways))
    if (!ok) {
        stop("'", arg, "' must be a clusterProfiler gseaResult or a list with a named numeric `stats` ",
            "vector and a named list of `pathways` (plus optional fgsea `results`).", call. = FALSE)
    }

    results <- x$results
    if (!is.null(results)) {
        results <- as.data.frame(results)
        keep <- intersect(c("pathway", "ES", "NES", "pval", "padj", "size"), names(results))
        results <- results[, keep, drop = FALSE]
        if (!"pathway" %in% names(results)) results <- NULL
    }
    labels <- x$labels %||% stats::setNames(names(x$pathways), names(x$pathways))

    structure(
        list(stats = x$stats[is.finite(x$stats)], pathways = x$pathways, results = results, labels = labels),
        class = c("gsea_bundle", "list")
    )
}


#' Validate a GSEA input for the module
#'
#' @param x The input.
#' @param arg Argument name for error messages.
#' @return The normalised bundle from [.gsea_input()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_assert_gsea
#' @keywords internal
.assert_gsea <- function(x, arg = "data") {
    .gsea_input(x, arg)
}


#' Running enrichment score of one gene set
#'
#' Ranks the genes by decreasing statistic and walks down the list, stepping up
#' at each gene in the set by its weight (`|stat|^gsea.param`, normalised over
#' the set) and down at every other gene by `1 / (N - k)`. The top and bottom of
#' each step are those of [fgsea::calcGseaStat()], and the curve those of
#' [fgsea::plotEnrichmentData()], so the enrichment score matches fgsea's.
#'
#' @param stats Named numeric gene-level statistics.
#' @param genes The gene set.
#' @param gsea.param Weight exponent (1 is the standard weighted statistic).
#' @return A list with `curve` (rank, running ES), `hits` (rank, gene, stat),
#'   `es`, and `leading.edge` (the genes up to the peak), or `NULL` when no gene
#'   of the set is ranked.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gsea_running
#' @keywords internal
.gsea_running <- function(stats, genes, gsea.param = 1) {
    stats <- stats[is.finite(stats)]
    s <- stats[order(-stats)]
    n <- length(s)
    adj <- abs(s)^gsea.param
    hits <- sort(unique(stats::na.omit(match(genes, names(s)))))
    k <- length(hits)
    if (k == 0 || k == n) {
        return(NULL)
    }

    nr <- sum(adj[hits])
    step <- if (nr == 0) rep(1 / k, k) else adj[hits] / nr
    tops <- cumsum(step) - (hits - seq_len(k)) / (n - k)
    bottoms <- tops - step
    max_p <- max(tops)
    min_p <- min(bottoms)
    es <- if (max_p == -min_p) 0 else if (max_p > -min_p) max_p else min_p

    leading <- if (es >= 0) seq_len(which.max(tops)) else seq(which.min(bottoms), k)

    list(
        curve = data.frame(rank = c(0, as.vector(rbind(hits - 1, hits)), n + 1),
            es = c(0, as.vector(rbind(bottoms, tops)), 0)),
        hits = data.frame(rank = hits, gene = names(s)[hits], stat = unname(s[hits]), stringsAsFactors = FALSE),
        es = es,
        leading.edge = names(s)[hits[leading]]
    )
}


#' Pathways to show by default
#'
#' @param x A bundle from [.gsea_input()].
#' @param n How many.
#' @return The `n` most significant pathways when results are available,
#'   otherwise the first `n`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gsea_default_pathways
#' @keywords internal
.gsea_default_pathways <- function(x, n = 3) {
    res <- x$results
    if (!is.null(res) && "padj" %in% names(res)) {
        ranked <- res$pathway[order(res$padj)]
        ranked <- ranked[ranked %in% names(x$pathways)]
        if (length(ranked)) return(utils::head(ranked, n))
    }
    utils::head(names(x$pathways), n)
}
