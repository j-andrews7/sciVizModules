# Finding a region, pulling it from a cohort's arrays, and ordering its samples.

# Beyond this many heatmap cells the hover text is left out: a string per cell
# outweighs the rest of the figure.
.meth_hover_limit <- 2e5


#' Describe a genomic region
#'
#' @param chr,start,end The region.
#' @param gene The gene it was found from, or `NULL`.
#' @return A list of `chr`, `start`, `end` and `label`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_target
#' @keywords internal
.meth_region <- function(chr, start, end, gene = NULL) {
    start <- max(1, start)
    position <- sprintf("%s:%s-%s", chr, .meth_comma(start), .meth_comma(end))
    list(chr = chr, start = start, end = end, label = paste(c(gene, position), collapse = "  "))
}


#' Format positions with thousands separators
#'
#' @param x Numbers.
#' @return Character strings.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_target
#' @keywords internal
.meth_comma <- function(x) {
    format(x, big.mark = ",", scientific = FALSE, trim = TRUE)
}


#' Parse a region typed as chr:start-end
#'
#' @param text The region, such as `"chr19:10,260,000-10,380,000"`. The `chr` prefix
#'   and commas are optional, and spaces may stand in for the separators.
#' @return A region, from [.meth_region()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_target
#' @keywords internal
.meth_parse_region <- function(text) {
    pattern <- "^[[:space:]]*([^:[:space:]]+)[:[:space:]]+([0-9,]+)[-[:space:]]+([0-9,]+)[[:space:]]*$"
    parts <- regmatches(text, regexec(pattern, text))[[1]]
    if (!length(parts)) {
        stop("Give a region as chr:start-end, such as chr19:10260000-10380000.", call. = FALSE)
    }
    chr <- if (startsWith(parts[2], "chr")) parts[2] else paste0("chr", parts[2])
    span <- as.numeric(gsub(",", "", parts[3:4], fixed = TRUE))
    if (span[1] >= span[2]) {
        stop("The start of a region must come before its end.", call. = FALSE)
    }
    .meth_region(chr, span[1], span[2])
}


#' Split a list of probe IDs typed by hand
#'
#' @param text IDs separated by commas, semicolons or white space.
#' @return The unique IDs.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_target
#' @keywords internal
.meth_parse_probes <- function(text) {
    ids <- unlist(strsplit(paste(text, collapse = " "), "[,;[:space:]]+"))
    unique(ids[nzchar(ids)])
}


#' The region spanning a gene's transcripts
#'
#' As `sesame::visualizeGene()`: `upstream` and `downstream` follow the strand of the
#' gene's first transcript. A gene on two chromosomes (a pseudoautosomal gene) takes
#' the first.
#'
#' @param cohort A `methylationCohort`.
#' @param gene A gene name.
#' @param upstream,downstream Bases to add either side of the gene.
#' @return A region, from [.meth_region()].
#'
#' @importFrom GenomicRanges end mcols seqnames start strand
#' @author Jared Andrews
#' @rdname INTERNAL_meth_target
#' @keywords internal
.meth_gene_region <- function(cohort, gene, upstream = 2000, downstream = 2000) {
    txns <- .meth_txns(cohort)
    if (is.null(txns)) {
        stop("No transcripts are available for ", cohort$genome, ", so give a region or probes.", call. = FALSE)
    }
    target <- txns[which(mcols(txns)$gene_name == gene)]
    if (!length(target)) {
        stop("Gene '", gene, "' is not among the transcripts of ", cohort$genome, ".", call. = FALSE)
    }
    exons <- unlist(target, use.names = FALSE)
    chr <- as.character(seqnames(exons))[1]
    forward <- as.character(strand(exons))[1] == "+"
    exons <- exons[as.character(seqnames(exons)) == chr]
    .meth_region(
        chr,
        min(start(exons)) - (if (forward) upstream else downstream),
        max(end(exons)) + (if (forward) downstream else upstream),
        gene
    )
}


#' The region spanning some probes
#'
#' @param cohort A `methylationCohort`.
#' @param ids Probe IDs, matched on any array, exactly or on their prefix.
#' @param upstream,downstream Bases to add before and after the probes.
#' @return A region, from [.meth_region()].
#'
#' @importFrom GenomicRanges seqnames start
#' @author Jared Andrews
#' @rdname INTERNAL_meth_target
#' @keywords internal
.meth_probe_region <- function(cohort, ids, upstream = 2000, downstream = 2000) {
    if (!length(ids)) {
        stop("Give at least one probe ID.", call. = FALSE)
    }
    found <- lapply(cohort$arrays, function(a) {
        hit <- .meth_match_ids(ids, names(a$loci))
        a$loci[hit[!is.na(hit)]]
    })
    chr <- unique(unlist(lapply(found, function(loci) as.character(seqnames(loci)))))
    pos <- unlist(lapply(found, start), use.names = FALSE)
    if (!length(pos)) {
        stop("None of those probes are in this cohort.", call. = FALSE)
    }
    if (length(chr) > 1) {
        stop("Those probes are on ", paste(chr, collapse = ", "), ". Give probes from one chromosome.", call. = FALSE)
    }
    .meth_region(chr, min(pos) - upstream, max(pos) + downstream)
}


#' Resolve what is being looked up to a region
#'
#' @param cohort A `methylationCohort`.
#' @param locate.by `"gene"`, `"region"` or `"probes"`.
#' @param gene,region,probes The lookup of that kind.
#' @param upstream,downstream Bases to add around a gene or probes.
#' @return A region, from [.meth_region()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_lookup
#' @keywords internal
.meth_target <- function(cohort, locate.by = "gene", gene = NULL, region = NULL, probes = NULL,
                         upstream = 2000, downstream = 2000) {
    up <- na_to_null(upstream) %||% 0
    down <- na_to_null(downstream) %||% 0
    prompt <- "Choose a gene, or give a region or probes, in the Data tab."
    switch(locate.by,
        gene = {
            if (!nz_value(gene)) stop(prompt, call. = FALSE)
            .meth_gene_region(cohort, gene, up, down)
        },
        region = {
            if (!nz_value(region)) stop(prompt, call. = FALSE)
            .meth_parse_region(region)
        },
        probes = {
            ids <- .meth_parse_probes(probes)
            if (!length(ids)) stop(prompt, call. = FALSE)
            .meth_probe_region(cohort, ids, up, down)
        },
        stop("Unknown lookup: ", locate.by, call. = FALSE)
    )
}


#' Choose samples from a column's levels and a filter expression
#'
#' Both apply when both are given. Levels no longer in the column are ignored: the
#' choices trail a change of column by a round trip to the browser.
#'
#' @param samples A cohort's sample table.
#' @param filter.col A column of `samples`, or `""`.
#' @param filter.levels The levels of it to keep; none keeps all.
#' @param expression A filter over the columns of `samples`, or `""`.
#' @return A logical vector over the rows of `samples`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_samples
#' @keywords internal
.meth_select_samples <- function(samples, filter.col = "", filter.levels = NULL, expression = "") {
    keep <- rep(TRUE, nrow(samples))
    if (nz_value(filter.col) && filter.col %in% names(samples)) {
        values <- as.character(samples[[filter.col]])
        chosen <- intersect(filter.levels, values)
        if (length(chosen)) keep <- values %in% chosen
    }
    if (nz_value(expression)) {
        problem <- NULL
        hit <- withCallingHandlers(
            safe_eval_filter(expression, samples),
            warning = function(w) {
                problem <<- conditionMessage(w)
                invokeRestart("muffleWarning")
            }
        )
        if (is.null(hit) || !is.logical(hit) || !length(hit) %in% c(1L, nrow(samples))) {
            stop(problem %||% "The sample filter must be a condition, such as age > 40.", call. = FALSE)
        }
        keep <- keep & hit & !is.na(hit)
    }
    keep
}


#' A status line for the chosen samples
#'
#' @param samples A cohort's sample table.
#' @param keep The logical vector from [.meth_select_samples()].
#' @return A string such as `"14 of 23 samples: HM450 6, EPIC 5, EPICv2 3"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_samples
#' @keywords internal
.meth_sample_status <- function(samples, keep) {
    line <- sprintf("%d of %d samples", sum(keep), length(keep))
    if (!"platform" %in% names(samples) || !any(keep)) {
        return(line)
    }
    counts <- table(droplevels(samples$platform[keep]))
    paste0(line, ": ", paste(names(counts), counts, collapse = ", "))
}


#' Average the probes that measure one CpG
#'
#' The mean of each CpG's values, skipping missing ones, as
#' `sesame::betasCollapseToPfx()` does for replicate probes. Here the replicates are
#' those at one position, so probes with different IDs are averaged too, and
#' replicates at different positions are not.
#'
#' @param betas A matrix with probes in rows.
#' @param pos Each row's position.
#' @return A matrix with one row per position, in position order.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_collapse <- function(betas, pos) {
    if (!anyDuplicated(pos)) {
        return(betas[order(pos), , drop = FALSE])
    }
    seen <- !is.na(betas)
    betas[!seen] <- 0
    out <- rowsum(betas, pos) / rowsum(seen * 1, pos)
    out[is.nan(out)] <- NA
    out
}


#' Pull a region from one array
#'
#' @param a An array of a `methylationCohort`.
#' @param reg The region as a `GRanges`.
#' @return A list of `pos`, `betas`, `probes` and `rowdata`, one row per position, or
#'   `NULL` where the array has nothing there.
#'
#' @importFrom GenomicRanges start
#' @importFrom IRanges overlapsAny
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_array_region <- function(a, reg) {
    hit <- which(suppressWarnings(overlapsAny(a$loci, reg, ignore.strand = TRUE)))
    if (!length(hit)) {
        return(NULL)
    }
    loci <- a$loci[hit]
    pos <- start(loci)
    first <- which(!duplicated(pos))
    first <- first[order(pos[first])]
    list(
        pos = pos[first],
        betas = .meth_collapse(as.matrix(a$betas[hit, , drop = FALSE]), pos),
        probes = unname(vapply(split(names(loci), pos), paste, character(1), collapse = ";")),
        rowdata = if (!is.null(a$rowdata)) a$rowdata[hit[first], , drop = FALSE]
    )
}


#' Whether each array covers each CpG of a region
#'
#' A row in an array's own matrix shows the array has the CpG. In a matrix merged across
#' arrays there are no such rows to go on, so any value from one of the array's samples
#' shows it.
#'
#' @param hits The regions from [.meth_array_region()].
#' @param pos The positions, in order.
#' @param betas The joined matrix, CpGs in rows, over all the cohort's samples.
#' @param table The cohort's sample table.
#' @param merged Logical; whether the cohort is one matrix merged across arrays.
#' @return A logical matrix with a column per platform, or `NULL` where the cohort
#'   names no platforms.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_coverage <- function(hits, pos, betas, table, merged = FALSE) {
    platforms <- .meth_sample_platforms(table)
    if (is.null(platforms)) {
        return(NULL)
    }
    columns <- lapply(platforms, function(p) {
        if (merged) {
            rowSums(!is.na(betas[, which(table$platform == p), drop = FALSE])) > 0
        } else {
            pos %in% hits[[p]]$pos
        }
    })
    matrix(unlist(columns), nrow = length(pos), dimnames = list(NULL, platforms))
}


#' Pull a region from a cohort and join its arrays on position
#'
#' Only here are the arrays joined, and only for the CpGs of this region.
#'
#' @param cohort A `methylationCohort`.
#' @param region A region, from [.meth_region()].
#' @param samples The names of the samples to keep, or `NULL` for all.
#' @param scope `"all"` for every CpG on any plotted array, `"shared"` for those on all
#'   of them.
#' @param max.cpgs The most CpGs to draw. A larger region is an error, as in
#'   `sesame::visualizeRegion()`.
#' @return A list of `region`, `betas` (CpGs in rows), `absent` (cells whose array lacks
#'   the CpG), `coverage`, `cpgs`, `rowdata`, `samples`, `txns` and `cytobands`.
#'
#' @importFrom GenomicRanges GRanges
#' @importFrom IRanges IRanges
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_query <- function(cohort, region, samples = NULL, scope = "all", max.cpgs = 1000) {
    table <- cohort$samples
    picked <- if (is.null(samples)) table$sample else intersect(table$sample, samples)
    if (!length(picked)) {
        stop("No samples are selected.", call. = FALSE)
    }

    reg <- GRanges(region$chr, IRanges(region$start, region$end))
    hits <- lapply(cohort$arrays, .meth_array_region, reg = reg)
    hits <- hits[!vapply(hits, is.null, logical(1))]
    pos <- sort(unique(unlist(lapply(hits, `[[`, "pos"), use.names = FALSE)))
    if (!length(pos)) {
        stop("No CpGs in ", region$label, ".", call. = FALSE)
    }

    betas <- matrix(NA_real_, length(pos), nrow(table), dimnames = list(NULL, table$sample))
    for (h in hits) betas[match(h$pos, pos), colnames(h$betas)] <- h$betas

    merged <- isTRUE(cohort$arrays[[1]]$merged)
    coverage <- .meth_coverage(hits, pos, betas, table, merged)
    absent <- matrix(FALSE, nrow(betas), ncol(betas), dimnames = dimnames(betas))
    for (p in colnames(coverage)) {
        absent[, which(table$platform == p)] <- !coverage[, p]
    }

    keep <- rep(TRUE, length(pos))
    if (!is.null(coverage)) {
        plotted <- intersect(colnames(coverage), as.character(table[picked, "platform"]))
        coverage <- coverage[, plotted, drop = FALSE]
        keep <- rowSums(coverage) > 0
        if (identical(scope, "shared")) {
            keep <- rowSums(coverage) == ncol(coverage)
        }
    }
    if (!any(keep)) {
        stop("No CpG in ", region$label, " is on all of the plotted arrays.", call. = FALSE)
    }
    if (sum(keep) > max.cpgs) {
        stop(
            sprintf("%d CpGs in this region, over the limit of %d. ", sum(keep), max.cpgs),
            "Shrink the region or raise Max CpGs.",
            call. = FALSE
        )
    }

    cpgs <- data.frame(locus = paste0(region$chr, ":", pos), chr = region$chr, pos = pos)
    for (nm in names(hits)) {
        cpgs[[if (merged) "probe" else paste0("probe.", nm)]] <- hits[[nm]]$probes[match(pos, hits[[nm]]$pos)]
    }

    list(
        region = region,
        betas = betas[keep, picked, drop = FALSE],
        absent = absent[keep, picked, drop = FALSE],
        coverage = if (!is.null(coverage)) coverage[keep, , drop = FALSE],
        cpgs = cpgs[keep, , drop = FALSE],
        rowdata = .meth_join_rowdata(hits, pos)[keep, , drop = FALSE],
        samples = table[picked, , drop = FALSE],
        txns = .meth_region_txns(cohort, reg, region),
        cytobands = .meth_region_bands(cohort, region$chr)
    )
}


#' Join the arrays' rowData on position
#'
#' Where arrays disagree over a CpG, the first array's value stands.
#'
#' @param hits The regions from [.meth_array_region()].
#' @param pos The positions, in order.
#' @return A data frame with one row per position.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_join_rowdata <- function(hits, pos) {
    out <- data.frame(row.names = seq_along(pos))
    for (h in hits) {
        for (col in names(h$rowdata)) {
            values <- as.character(h$rowdata[[col]])
            at <- match(h$pos, pos)
            if (is.null(out[[col]])) out[[col]] <- NA_character_
            todo <- is.na(out[[col]][at])
            out[[col]][at[todo]] <- values[todo]
        }
    }
    out
}


#' The transcripts crossing a region
#'
#' By the span of a transcript, so one with only an intron in the region is kept.
#'
#' @param cohort A `methylationCohort`.
#' @param reg The region as a `GRanges`.
#' @param region The region, from [.meth_region()].
#' @return A `GRangesList`, or `NULL`.
#'
#' @importFrom GenomicRanges mcols
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_region_txns <- function(cohort, reg, region) {
    txns <- .meth_txns(cohort)
    if (is.null(txns)) {
        return(NULL)
    }
    meta <- mcols(txns)
    if (all(c("chrm", "transcript_start", "transcript_end") %in% names(meta))) {
        return(txns[which(
            meta$chrm == region$chr & meta$transcript_start <= region$end & meta$transcript_end >= region$start
        )])
    }
    txns[suppressWarnings(overlapsAny(range(txns, ignore.strand = TRUE), reg, ignore.strand = TRUE))]
}


#' The cytobands of a chromosome
#'
#' @param cohort A `methylationCohort`.
#' @param chr A chromosome.
#' @return A data frame, or `NULL` where there are none.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_query
#' @keywords internal
.meth_region_bands <- function(cohort, chr) {
    bands <- .meth_cytobands(cohort)
    if (is.null(bands)) {
        return(NULL)
    }
    bands <- bands[as.character(bands$chrom) == chr, , drop = FALSE]
    if (nrow(bands)) bands
}


#' The levels of a sample or CpG annotation
#'
#' @param x A vector.
#' @return Factor levels in use, or the sorted values, as strings.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_samples
#' @keywords internal
.meth_levels <- function(x) {
    if (is.factor(x)) {
        return(levels(droplevels(x)))
    }
    sort(unique(as.character(x[!is.na(x)])))
}


#' Distances between the samples of a beta matrix
#'
#' Pairs with nothing to compare come back `NA`. Euclidean and Manhattan distances use
#' the CpGs each pair shares, scaled up for those left out, as [stats::dist()] does.
#'
#' @param betas A matrix with samples in columns.
#' @param method `"euclidean"`, `"manhattan"`, `"pearson"` or `"spearman"`, the last
#'   two as one minus the correlation.
#' @return A `dist` object.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_order
#' @keywords internal
.meth_dist <- function(betas, method = "euclidean") {
    if (method %in% c("pearson", "spearman")) {
        r <- suppressWarnings(stats::cor(betas, use = "pairwise.complete.obs", method = method))
        return(stats::as.dist(1 - r))
    }
    stats::dist(t(betas), method = method)
}


#' Cluster the samples of a beta matrix
#'
#' Samples on different arrays leave many cells empty, and most distance measures have
#' no answer for them. So samples are compared on the CpGs measured in all of them. With
#' fewer than two such CpGs, as can happen across arrays in a small region, each pair is
#' compared on the CpGs it shares instead, and a pair sharing none is placed apart from
#' everything, at 1.1 times the greatest distance.
#'
#' @param betas A matrix with samples in columns.
#' @param dist.method,hclust.method The distance, as for [.meth_dist()], and the linkage, passed to
#'   [stats::hclust()].
#' @return A list of `hc` and `fallback`, which is `TRUE` where pairwise distances were
#'   needed.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_order
#' @keywords internal
.meth_cluster <- function(betas, dist.method = "euclidean", hclust.method = "ward.D2") {
    complete <- rowSums(is.na(betas)) == 0
    fallback <- sum(complete) < 2
    d <- .meth_dist(if (fallback) betas else betas[complete, , drop = FALSE], dist.method)
    known <- d[!is.na(d)]
    if (length(known) < length(d)) {
        d[is.na(d)] <- if (length(known) && max(known) > 0) 1.1 * max(known) else 1
    }
    list(hc = stats::hclust(d, method = hclust.method), fallback = fallback)
}


#' Order a query's samples
#'
#' Groups and clustering are independent: samples stay in their given order, gather
#' into groups, are clustered, or are clustered within each group.
#'
#' @param betas A matrix with samples in columns.
#' @param samples The samples' table.
#' @param group.by A column of `samples` to group on, or `NULL`.
#' @param cluster Logical; cluster the samples, within any groups.
#' @param dist.method,hclust.method The distance, as for [.meth_dist()], and the linkage, passed to
#'   [stats::hclust()].
#' @return A list of `index` (columns of `betas`, in plotted order), `groups` (a factor
#'   over the plotted samples, or `NULL`), `trees` (each group's clustering and how many
#'   samples precede it) and `fallback`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_order
#' @keywords internal
.meth_order <- function(betas, samples, group.by = NULL, cluster = FALSE, dist.method = "euclidean",
                        hclust.method = "ward.D2") {
    n <- ncol(betas)
    groups <- NULL
    members <- list(seq_len(n))
    if (!is.null(group.by)) {
        values <- samples[[group.by]]
        labels <- .meth_levels(values)
        values <- as.character(values)
        if (anyNA(values)) {
            values[is.na(values)] <- "NA"
            labels <- union(labels, "NA")
        }
        groups <- factor(values, levels = labels)
        members <- unname(split(seq_len(n), groups, drop = TRUE))
    }

    index <- integer(0)
    trees <- list()
    fallback <- FALSE
    for (m in members) {
        if (isTRUE(cluster) && length(m) > 1) {
            tree <- .meth_cluster(betas[, m, drop = FALSE], dist.method, hclust.method)
            fallback <- fallback || tree$fallback
            trees[[length(trees) + 1]] <- list(hc = tree$hc, before = length(index))
            m <- m[tree$hc$order]
        }
        index <- c(index, m)
    }
    list(index = index, groups = if (!is.null(groups)) groups[index], trees = trees, fallback = fallback)
}


#' The heatmap row of each plotted sample
#'
#' Blank rows between groups draw the gaps.
#'
#' @param n The number of samples.
#' @param groups A factor over the plotted samples, or `NULL`.
#' @param gap Blank rows between groups.
#' @return A list of `y` (each sample's row) and `n` (the rows in all).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_order
#' @keywords internal
.meth_rows <- function(n, groups = NULL, gap = 1) {
    y <- seq_len(n)
    if (!is.null(groups) && n > 1) {
        changes <- groups[-1] != groups[-n]
        y <- y + cumsum(c(0, changes * max(0, round(gap))))
    }
    list(y = y, n = max(y))
}


#' Lay a region's transcripts out in rows
#'
#' Full gives each transcript a row of its own, as `sesame::visualizeRegion()` does.
#' Collapsed overlays a gene's transcripts on one row, as IGV's collapsed view does,
#' and genes that overlap take separate rows.
#'
#' @param txns A `GRangesList` of exons, or `NULL`.
#' @param region A region, from [.meth_region()].
#' @param view `"full"` or `"collapsed"`.
#' @param types Transcript types to keep; `NULL` or none keeps all.
#' @return A list of `n` (the rows), and `spans`, `exons` and `cds` data frames of `row`,
#'   `start` and `end`, clipped to the region. `spans` also holds `label`, `strand` and
#'   `hover`.
#'
#' @importFrom GenomicRanges end mcols start strand
#' @importFrom IRanges IRanges disjointBins reduce
#' @author Jared Andrews
#' @rdname INTERNAL_meth_transcripts
#' @keywords internal
.meth_txn_model <- function(txns, region, view = "full", types = NULL) {
    if (!is.null(txns) && length(types) && "transcript_type" %in% names(mcols(txns))) {
        txns <- txns[mcols(txns)$transcript_type %in% types]
    }
    if (is.null(txns) || !length(txns)) {
        none <- data.frame(row = integer(0), start = numeric(0), end = numeric(0))
        return(list(n = 0L, spans = cbind(none, label = character(0)), exons = none, cds = none))
    }

    meta <- mcols(txns)
    exons <- unlist(txns, use.names = FALSE)
    owner <- rep(seq_along(txns), lengths(txns))
    table <- data.frame(owner = owner, start = start(exons), end = end(exons), strand = as.character(strand(exons)))
    cds <- .meth_cds(table, meta)

    gene <- as.character(meta$gene_name)
    first <- table[!duplicated(table$owner), ]
    span <- data.frame(
        gene = gene,
        id = names(txns) %||% as.character(seq_along(txns)),
        start = as.numeric(tapply(table$start, table$owner, min)),
        end = as.numeric(tapply(table$end, table$owner, max)),
        strand = first$strand[match(seq_along(txns), first$owner)]
    )

    laid <- if (identical(view, "collapsed")) {
        .meth_collapsed_rows(span, table, cds, gene, region)
    } else {
        .meth_full_rows(span, table, cds)
    }
    list(
        n = max(laid$spans$row),
        spans = .meth_clip(laid$spans, region),
        exons = .meth_clip(laid$exons, region),
        cds = .meth_clip(laid$cds, region)
    )
}


#' The coding part of each exon
#'
#' As sesame's `exonToCDS()`, for every transcript at once.
#'
#' @param exons A data frame of `owner`, `start` and `end`.
#' @param meta The transcripts' `mcols()`.
#' @return The same columns, for the coding exons, clipped to the coding region.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cds
#' @keywords internal
.meth_cds <- function(exons, meta) {
    if (!all(c("cdsStart", "cdsEnd") %in% names(meta))) {
        return(exons[0, c("owner", "start", "end")])
    }
    from <- suppressWarnings(as.numeric(meta$cdsStart))[exons$owner]
    to <- suppressWarnings(as.numeric(meta$cdsEnd))[exons$owner]
    keep <- which(!is.na(from) & !is.na(to) & to > from & exons$start < to & exons$end > from)
    data.frame(
        owner = exons$owner[keep],
        start = pmax(exons$start[keep], from[keep]),
        end = pmin(exons$end[keep], to[keep])
    )
}


#' Give each transcript a row
#'
#' @param span A data frame of transcripts.
#' @param exons,cds Data frames of `owner`, `start` and `end`.
#' @return A list of `spans`, `exons` and `cds` with a `row` column.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_transcripts
#' @keywords internal
.meth_full_rows <- function(span, exons, cds) {
    row <- integer(nrow(span))
    row[order(span$gene, span$start, span$end)] <- seq_len(nrow(span))
    span$row <- row
    span$label <- sprintf("%s (%s)", span$gene, span$id)
    span$hover <- sprintf("%s<br>%s (%s)", span$gene, span$id, span$strand)
    list(
        spans = span,
        exons = data.frame(row = row[exons$owner], start = exons$start, end = exons$end),
        cds = data.frame(row = row[cds$owner], start = cds$start, end = cds$end)
    )
}


#' Give each gene a row, its transcripts overlaid
#'
#' @param span A data frame of transcripts.
#' @param exons,cds Data frames of `owner`, `start` and `end`.
#' @param gene Each transcript's gene.
#' @param region A region, from [.meth_region()].
#' @return A list of `spans`, `exons` and `cds` with a `row` column.
#'
#' @importFrom GenomicRanges end start
#' @importFrom IRanges IRanges disjointBins reduce
#' @author Jared Andrews
#' @rdname INTERNAL_meth_transcripts
#' @keywords internal
.meth_collapsed_rows <- function(span, exons, cds, gene, region) {
    genes <- unique(gene[order(span$start, span$end)])
    spans <- do.call(rbind, lapply(genes, function(g) {
        mine <- span[span$gene == g, ]
        data.frame(
            gene = g, start = min(mine$start), end = max(mine$end), strand = mine$strand[1],
            transcripts = nrow(mine)
        )
    }))
    # Two genes share a row when no part of them shows together in the region.
    shown <- IRanges(pmax(spans$start, region$start), pmin(spans$end, region$end))
    spans$row <- disjointBins(shown)
    spans$label <- spans$gene
    spans$hover <- sprintf("%s (%s)<br>%d transcripts", spans$gene, spans$strand, spans$transcripts)

    merged <- function(parts) {
        out <- lapply(seq_along(genes), function(i) {
            mine <- parts[parts$owner %in% which(gene == genes[i]), ]
            if (!nrow(mine)) {
                return(NULL)
            }
            ranges <- reduce(IRanges(mine$start, mine$end))
            data.frame(row = spans$row[i], start = start(ranges), end = end(ranges))
        })
        do.call(rbind, out) %||% data.frame(row = integer(0), start = numeric(0), end = numeric(0))
    }
    list(spans = spans, exons = merged(exons), cds = merged(cds))
}


#' Clip track features to a region
#'
#' @param features A data frame with `start` and `end`.
#' @param region A region, from [.meth_region()].
#' @return The features inside the region, cut at its edges.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_transcripts
#' @keywords internal
.meth_clip <- function(features, region) {
    features <- features[features$end >= region$start & features$start <= region$end, , drop = FALSE]
    features$start <- pmax(features$start, region$start)
    features$end <- pmin(features$end, region$end)
    features
}
