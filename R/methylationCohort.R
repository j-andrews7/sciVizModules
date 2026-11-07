# Rows that do not measure a CpG: SNP, control and nucleotide variant probes.
.meth_drop_pattern <- "^(rs[0-9]|ctl_|nv-)"

# The arrays tried for a matrix that does not say which it holds, newest first so
# a CpG measured on several takes its most recent coordinates.
.meth_platforms <- c("EPICv2", "EPIC", "HM450")


#' Assemble a DNA methylation cohort from one or more arrays
#'
#' Gathers beta values from any mix of Infinium arrays (HM450, EPIC, EPICv2, ...)
#' with their sample information and genomic positions, for [methylationTrack()]
#' and its module. Arrays are joined on genomic position rather than on probe ID:
#' the same cg ID can sit at different positions on different arrays, and different
#' IDs can measure the same CpG, so a join on IDs would merge what should not be
#' merged and split what should. Nothing is joined up front. A region is pulled
#' from each array when it is asked for, so an HDF5-backed
#' [SummarizedExperiment::SummarizedExperiment()] stays out of memory, and a
#' cohort's full union of CpGs, over a million rows, is never built.
#'
#' @details
#' **Input forms.** `betas` is one of:
#'
#' - A named list with one matrix or `SummarizedExperiment` per array, named by
#'   platform (`list(HM450 = m1, EPIC = m2, EPICv2 = m3)`). A CpG is on an array
#'   when that array has a row for it.
#' - One matrix or `SummarizedExperiment` already merged across arrays, with `NA`
#'   where a sample's array lacks a probe. Sample information can name each sample's
#'   array in a `platform` column; a CpG is then on an array when any of that array's
#'   samples has a value there. Without one, the cohort cannot tell a probe the array
#'   lacks from one that failed, and both are drawn in the NA colour.
#'
#' Matrices have probe IDs as row names and samples as columns.
#'
#' **Positions.** Each array's positions come from the first of these it has:
#'
#' 1. `probes`, a `GRanges` named by probe ID, or a list of them named by platform.
#' 2. The `rowRanges()` of a `SummarizedExperiment`. These must be on `genome`.
#' 3. `rowData()` columns: `CpG_chrm` and `CpG_beg`, as in the Infinium annotation
#'    manifests, whose BED-style starts are shifted to one-based; or `chr` and `pos`,
#'    as in minfi's annotation packages, taken as they are. Check that they are on
#'    `genome`: minfi's HM450 and EPIC annotations are often hg19.
#' 4. The sesameData manifest of the array, found from its platform name (`HM450`
#'    or `450K`, `EPIC`, `EPICv2`, `MSA` or `HM27`). These hold hg38 only, so another
#'    genome needs one of the above.
#'
#' Probe IDs match exactly, then on the ID's prefix, so `cg00000029_TC21` finds
#' `cg00000029` and the reverse. In a merged matrix, an ID is looked up on each array
#' in turn, newest first.
#'
#' Rows that cannot be placed, and SNP (`rs`), control (`ctl`) and nucleotide variant
#' (`nv`) probes, are left out, and counted when the cohort is printed. So is the
#' number of CpGs each pair of arrays shares: a pair sharing few suggests its positions
#' disagree, such as one on another genome build.
#'
#' **Samples.** Sample information comes from each `SummarizedExperiment`'s
#' `colData()` and from `samples`, whose row names or one of whose columns must hold
#' the column names of `betas`. Both are kept, `samples` taking precedence. The table
#' gains `sample` and, for a list of arrays, `platform` columns. A sample run on two
#' arrays stays as two samples, with the platform added to each name.
#'
#' **Annotation.** With `txns` and `cytobands` left as `NULL`, the transcripts and
#' cytobands of `genome` are read from sesameData when they are first needed, and held
#' for the session. Where neither is available those tracks are not drawn and genes
#' cannot be looked up.
#'
#' Beta values are not adjusted between arrays. Differences between platforms remain,
#' so check for them by grouping samples on `platform`.
#'
#' @param betas The beta values, in one of the forms described in Details.
#' @param samples Optional data frame of sample information.
#' @param probes Optional probe positions: a `GRanges` named by probe ID, or a list of
#'   them named as `betas` is.
#' @param genome The genome build, such as `"hg38"`.
#' @param assay For a `SummarizedExperiment`, the assay holding beta values. By default
#'   one named `betas`, `beta` or `Beta`, else the first.
#' @param txns Optional transcripts as a `GRangesList` of exons, one element per
#'   transcript named by transcript ID, with `gene_name` in its `mcols()`. Its
#'   `transcript_type`, `cdsStart` and `cdsEnd` are used where present. The shape of
#'   `genomeInfo$txns` from `sesameData::sesameData_getGenomeInfo()`.
#' @param cytobands Optional data frame of cytobands, with `chrom`, `chromStart`,
#'   `chromEnd` and `gieStain` columns.
#' @return A `methylationCohort` object: a list holding `arrays` (each with its
#'   `betas`, `loci` and `rowdata`), `samples`, `genome`, `txns`, `cytobands` and
#'   `dropped` (the rows left out).
#'
#' @importFrom methods is
#' @seealso [methylationTrack()], [methylationTrackApp()]
#' @export
#' @author Jared Andrews
#' @examples
#' betas <- matrix(
#'     c(0.1, 0.9, 0.5, 0.2, 0.8, 0.4),
#'     nrow = 3, dimnames = list(c("cg1", "cg2", "cg3"), c("a", "b"))
#' )
#' probes <- GenomicRanges::GRanges("chr1", IRanges::IRanges(c(100, 200, 300), width = 2))
#' names(probes) <- rownames(betas)
#' cohort <- methylationCohort(
#'     list(HM450 = betas), probes = probes,
#'     samples = data.frame(tissue = c("Blood", "Liver"), row.names = c("a", "b"))
#' )
#' cohort
methylationCohort <- function(betas, samples = NULL, probes = NULL, genome = "hg38", assay = NULL,
                              txns = NULL, cytobands = NULL) {
    merged <- !is.list(betas) || is.data.frame(betas)
    inputs <- if (merged) list(merged = betas) else betas
    if (!length(inputs)) {
        stop("'betas' holds no arrays.", call. = FALSE)
    }
    if (!merged && (is.null(names(inputs)) || any(!nzchar(names(inputs))) || anyDuplicated(names(inputs)))) {
        stop("A list of arrays must be named by platform, each name once.", call. = FALSE)
    }
    if (!is.null(txns) && !(is(txns, "GRangesList") && "gene_name" %in% names(S4Vectors::mcols(txns)))) {
        stop("'txns' must be a GRangesList with 'gene_name' in its mcols().", call. = FALSE)
    }
    if (!is.null(cytobands) && !all(c("chrom", "chromStart", "chromEnd", "gieStain") %in% names(cytobands))) {
        stop("'cytobands' needs chrom, chromStart, chromEnd and gieStain columns.", call. = FALSE)
    }

    parts <- lapply(inputs, .meth_parts, assay = assay, genome = genome)
    tables <- lapply(names(parts), function(nm) {
        .meth_sample_table(parts[[nm]], if (merged) NULL else nm, samples)
    })
    table <- .meth_bind_samples(tables, if (merged) NULL else names(parts))

    # The names the sample table settled on, handed back to each array's columns.
    ends <- cumsum(vapply(tables, nrow, integer(1)))
    ids <- split(table$sample, rep(seq_along(tables), diff(c(0L, ends))))

    arrays <- lapply(seq_along(parts), function(i) {
        part <- parts[[i]]
        colnames(part$betas) <- ids[[i]]
        name <- names(parts)[i]
        platforms <- if (merged) .meth_sample_platforms(table) else name
        .meth_build_array(part, name, merged, platforms, .meth_array_probes(probes, name), genome)
    })
    names(arrays) <- names(parts)

    structure(
        list(
            arrays = arrays,
            samples = table,
            genome = genome,
            txns = txns,
            cytobands = cytobands,
            dropped = Reduce(`+`, lapply(arrays, `[[`, "dropped"))
        ),
        class = "methylationCohort"
    )
}


#' @param x A `methylationCohort`.
#' @param ... Ignored.
#' @return `x`, invisibly.
#' @rdname methylationCohort
#' @importFrom IRanges overlapsAny
#' @export
print.methylationCohort <- function(x, ...) {
    n <- nrow(x$samples)
    cat("methylationCohort:", n, if (n == 1) "sample" else "samples", "on", x$genome, "\n")

    for (nm in names(x$arrays)) {
        a <- x$arrays[[nm]]
        cat(sprintf("  %-10s %5d samples  %9d probes\n", nm, ncol(a$betas), length(a$loci)))
    }
    pairs <- if (length(x$arrays) > 1) utils::combn(names(x$arrays), 2, simplify = FALSE)
    for (p in pairs) {
        shared <- sum(suppressWarnings(overlapsAny(
            .meth_points(x$arrays[[p[1]]]$loci), .meth_points(x$arrays[[p[2]]]$loci)
        )))
        cat(sprintf("  %d CpGs shared by %s and %s\n", shared, p[1], p[2]))
    }
    if (x$dropped[["control"]] > 0) {
        cat(sprintf("  %d SNP, control or variant probes left out\n", x$dropped[["control"]]))
    }
    if (x$dropped[["unplaced"]] > 0) {
        cat(sprintf("  %d probes left out with no known position\n", x$dropped[["unplaced"]]))
    }
    invisible(x)
}


#' Coerce a module's data to a methylationCohort
#'
#' @param x A `methylationCohort`, or anything [methylationCohort()] takes.
#' @return A `methylationCohort`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_as_cohort <- function(x) {
    if (inherits(x, "methylationCohort")) x else methylationCohort(x)
}


#' Pull apart one array's beta values and annotation
#'
#' @param x A matrix or `SummarizedExperiment`.
#' @param assay The assay to use, or `NULL`.
#' @param genome The cohort's genome build.
#' @return A list of `betas`, `coldata`, `rowdata` and `ranges`.
#'
#' @importFrom methods is
#' @importFrom SummarizedExperiment rowData
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_parts <- function(x, assay = NULL, genome = "hg38") {
    if (is(x, "SummarizedExperiment")) {
        rd <- rowData(x)
        keep <- vapply(seq_len(ncol(rd)), function(i) is.atomic(rd[[i]]) || is.factor(rd[[i]]), logical(1))
        part <- list(
            betas = SummarizedExperiment::assay(x, .meth_assay(x, assay)),
            coldata = .se_coldata(x),
            rowdata = if (any(keep)) as.data.frame(rd[, keep, drop = FALSE], optional = TRUE),
            ranges = .meth_row_ranges(x, genome)
        )
        dimnames(part$betas) <- dimnames(x)
    } else if (length(dim(x)) == 2L) {
        part <- list(betas = if (is.data.frame(x)) as.matrix(x) else x, coldata = NULL, rowdata = NULL, ranges = NULL)
    } else {
        stop("Beta values must be a matrix or a SummarizedExperiment.", call. = FALSE)
    }

    if (is.null(rownames(part$betas))) {
        stop("Beta values need probe IDs as row names.", call. = FALSE)
    }
    if (is.null(colnames(part$betas))) {
        colnames(part$betas) <- paste0("sample", seq_len(ncol(part$betas)))
    }
    part
}


#' The assay holding beta values
#'
#' @param se A `SummarizedExperiment`.
#' @param assay The assay asked for, or `NULL`.
#' @return An assay name.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_assay <- function(se, assay = NULL) {
    available <- .se_assays(se)
    if (!is.null(assay)) {
        if (!assay %in% available) {
            stop("No assay named '", assay, "'; there are: ", paste(available, collapse = ", "), ".", call. = FALSE)
        }
        return(assay)
    }
    c(intersect(c("betas", "beta", "Beta"), available), available)[1]
}


#' The rowRanges of a SummarizedExperiment, where it has usable ones
#'
#' @param se A `SummarizedExperiment`.
#' @param genome The cohort's genome build.
#' @return A `GRanges` parallel to the rows, or `NULL`.
#'
#' @importFrom methods is
#' @importFrom SummarizedExperiment rowRanges
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_row_ranges <- function(se, genome = "hg38") {
    if (!is(se, "RangedSummarizedExperiment")) {
        return(NULL)
    }
    ranges <- rowRanges(se)
    if (!is(ranges, "GRanges") || !length(ranges)) {
        return(NULL)
    }
    # Seqinfo::genome() here, whatever this function's argument is called.
    builds <- unique(Seqinfo::genome(ranges))
    builds <- builds[!is.na(builds)]
    aliases <- c(GRCh38 = "hg38", GRCh37 = "hg19", GRCm38 = "mm10", GRCm39 = "mm39")
    named <- ifelse(builds %in% names(aliases), aliases[builds], builds)
    if (length(named) && !all(named == genome)) {
        stop(
            "The rowRanges are on ", paste(builds, collapse = ", "), ", not ", genome,
            ". Set 'genome', or lift them over.",
            call. = FALSE
        )
    }
    ranges
}


#' Match probe IDs, exactly and then on their prefix
#'
#' EPICv2 and MSA suffix their IDs (`cg00000029_TC21`), and a table collapsed to
#' prefixes does not, so each side's prefix is tried for what is left unmatched.
#'
#' @param ids Probe IDs to find.
#' @param table Probe IDs to find them in.
#' @return Indices into `table`, `NA` where not found.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_match_ids <- function(ids, table) {
    hit <- match(ids, table)
    todo <- which(is.na(hit))
    if (length(todo)) {
        hit[todo] <- match(.meth_prefix(ids[todo]), .meth_prefix(table))
    }
    hit
}


#' The prefix of a probe ID
#'
#' @param ids Probe IDs.
#' @return The IDs without any suffix.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_prefix <- function(ids) {
    sub("_.*$", "", ids)
}


#' An empty table of positions, or one filled from ranges
#'
#' @param n The number of rows.
#' @return A data frame of `chr`, `start` and `end`, all `NA`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_no_places <- function(n) {
    data.frame(chr = rep(NA_character_, n), start = rep(NA_integer_, n), end = rep(NA_integer_, n))
}


#' Write the positions of some probes into a table of positions
#'
#' @param place A table from [.meth_no_places()].
#' @param rows The rows of `place` to fill.
#' @param ranges A `GRanges` parallel to `rows`, already subset to them.
#' @return `place`, with `chr` left `NA` for ranges on no chromosome.
#'
#' @importFrom GenomicRanges start end
#' @importFrom GenomicRanges seqnames
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_fill_places <- function(place, rows, ranges) {
    chr <- as.character(seqnames(ranges))
    chr[chr == "*"] <- NA
    place$chr[rows] <- chr
    place$start[rows] <- start(ranges)
    place$end[rows] <- end(ranges)
    place
}


#' Positions from a named GRanges
#'
#' @param ids Probe IDs.
#' @param ranges A `GRanges` named by probe ID.
#' @return A table of positions.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_from_ranges <- function(ids, ranges) {
    place <- .meth_no_places(length(ids))
    hit <- .meth_match_ids(ids, names(ranges))
    found <- which(!is.na(hit))
    if (length(found)) place <- .meth_fill_places(place, found, ranges[hit[found]])
    place
}


#' Positions from rowData columns
#'
#' @param rowdata The `rowData` of an array, as a data frame.
#' @return A table of positions, or `NULL` where it has no position columns.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_from_rowdata <- function(rowdata) {
    if (is.null(rowdata)) {
        return(NULL)
    }
    if (all(c("CpG_chrm", "CpG_beg") %in% names(rowdata))) {
        # The manifests are BED-style, so a start is one below the base it names.
        chr <- as.character(rowdata$CpG_chrm)
        start <- as.integer(rowdata$CpG_beg) + 1L
    } else if (all(c("chr", "pos") %in% names(rowdata))) {
        chr <- as.character(rowdata$chr)
        start <- as.integer(rowdata$pos)
    } else {
        return(NULL)
    }
    chr[!is.na(chr) & chr == "*"] <- NA
    data.frame(chr = chr, start = start, end = start + 1L)
}


#' Positions from the sesameData manifests
#'
#' Tries each array in turn, on exact IDs and then on prefixes, and stops once every
#' ID is placed, so a matrix from one array loads only that array's manifest.
#'
#' @param ids Probe IDs.
#' @param platforms Platform names, or `NULL` for each of `.meth_platforms`.
#' @param genome The genome build.
#' @return A table of positions.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_from_manifests <- function(ids, platforms, genome) {
    codes <- unique(.meth_platform_code(platforms))
    codes <- if (length(codes) && !anyNA(codes)) codes[order(match(codes, .meth_platforms))] else .meth_platforms
    place <- .meth_no_places(length(ids))

    for (match_on in c("id", "prefix")) {
        for (code in codes) {
            todo <- which(is.na(place$chr))
            if (!length(todo)) {
                return(place)
            }
            ranges <- .meth_manifest(code, genome)
            hit <- if (match_on == "id") {
                match(ids[todo], names(ranges))
            } else {
                .meth_match_ids(ids[todo], names(ranges))
            }
            found <- !is.na(hit)
            if (any(found)) place <- .meth_fill_places(place, todo[found], ranges[hit[found]])
        }
    }
    place
}


#' The sesameData code for a platform name
#'
#' @param x Platform names.
#' @return The sesameData codes, `NA` for names it does not know.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_platform_code <- function(x) {
    known <- c(
        HM450 = "HM450", `450K` = "HM450", HM450K = "HM450", EPIC = "EPIC", EPICV1 = "EPIC", `850K` = "EPIC",
        EPICV2 = "EPICv2", `935K` = "EPICv2", MSA = "MSA", HM27 = "HM27", `27K` = "HM27"
    )
    unname(known[toupper(gsub("[^[:alnum:]]", "", as.character(x)))])
}


#' An array's sesameData manifest
#'
#' Loaded once per session.
#'
#' @param platform A sesameData platform code.
#' @param genome The genome build.
#' @return A `GRanges` named by probe ID.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_manifest <- function(platform, genome) {
    key <- paste("manifest", platform, genome, sep = ".")
    if (!is.null(.sci_cache[[key]])) {
        return(.sci_cache[[key]])
    }
    if (!requireNamespace("sesameData", quietly = TRUE)) {
        stop(
            "Probe positions were not given, and reading them needs sesameData: ",
            "BiocManager::install('sesameData'), or pass them as 'probes'.",
            call. = FALSE
        )
    }
    ranges <- suppressMessages(sesameData::sesameData_getManifestGRanges(platform, genome = genome))
    if (is.null(ranges)) {
        stop("sesameData has no ", genome, " manifest for ", platform, ". Pass positions as 'probes'.", call. = FALSE)
    }
    assign(key, ranges, envir = .sci_cache)
    ranges
}


#' Ranges reduced to their first base
#'
#' @param loci A `GRanges`.
#' @return The ranges, one base wide.
#'
#' @importFrom IRanges resize
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_points <- function(loci) {
    resize(loci, 1, fix = "start", ignore.strand = TRUE)
}


#' Positions to use for one array, from `probes`
#'
#' @param probes The `probes` argument of [methylationCohort()].
#' @param name The array's name.
#' @return A `GRanges`, or `NULL`.
#'
#' @importFrom methods is
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_array_probes <- function(probes, name) {
    if (is.list(probes) || is(probes, "GRangesList")) probes[[name]] else probes
}


#' Place one array's probes and keep those that can be used
#'
#' @param part The array's parts, from [.meth_parts()].
#' @param name The array's name.
#' @param merged Logical; whether it is a matrix merged across arrays.
#' @param platforms The platforms it holds, for finding its manifests.
#' @param probes Positions given by the caller, or `NULL`.
#' @param genome The genome build.
#' @return A list of `betas`, `loci`, `rowdata`, `merged`, and `dropped` counts.
#'
#' @importFrom GenomicRanges GRanges
#' @importFrom IRanges IRanges
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_build_array <- function(part, name, merged, platforms, probes, genome) {
    ids <- rownames(part$betas)
    control <- grepl(.meth_drop_pattern, ids)

    place <- if (!is.null(probes)) {
        .meth_from_ranges(ids, probes)
    } else if (!is.null(part$ranges)) {
        .meth_fill_places(.meth_no_places(length(ids)), seq_along(ids), part$ranges)
    } else {
        from_rows <- .meth_from_rowdata(part$rowdata)
        if (is.null(from_rows)) {
            found <- .meth_no_places(length(ids))
            found[!control, ] <- .meth_from_manifests(ids[!control], platforms, genome)
            found
        } else {
            from_rows
        }
    }

    placed <- !is.na(place$chr) & !is.na(place$start)
    keep <- placed & !control
    if (!any(keep)) {
        stop("None of the probes of '", name, "' could be placed on ", genome, ".", call. = FALSE)
    }
    loci <- GRanges(place$chr[keep], IRanges(place$start[keep], pmax(place$start[keep], place$end[keep])))
    names(loci) <- ids[keep]

    list(
        betas = part$betas[keep, , drop = FALSE],
        loci = loci,
        rowdata = if (!is.null(part$rowdata)) part$rowdata[keep, , drop = FALSE],
        merged = merged,
        dropped = c(control = sum(control), unplaced = sum(!placed & !control))
    )
}


#' One array's rows of sample information
#'
#' @param part The array's parts, from [.meth_parts()].
#' @param platform The array's name, or `NULL` for a merged matrix.
#' @param samples The `samples` argument of [methylationCohort()].
#' @return A data frame with a `sample` column, one row per column of `betas`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_sample_table <- function(part, platform, samples) {
    ids <- colnames(part$betas)
    table <- data.frame(sample = ids, stringsAsFactors = FALSE)
    if (!is.null(part$coldata)) {
        extra <- part$coldata[setdiff(names(part$coldata), "sample")]
        table[names(extra)] <- extra
    }
    given <- .meth_match_samples(ids, samples)
    if (!is.null(given)) {
        table[names(given)] <- given
    }
    names(table)[tolower(names(table)) == "platform"] <- "platform"
    if (!is.null(platform)) {
        table$platform <- platform
    }
    table
}


#' Find each sample's row in a caller's sample table
#'
#' @param ids Sample names.
#' @param samples A data frame of sample information, or `NULL`.
#' @return The rows of `samples` for `ids`, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_match_samples <- function(ids, samples) {
    if (is.null(samples)) {
        return(NULL)
    }
    samples <- as.data.frame(samples)
    key <- rownames(samples)
    if (!all(ids %in% key)) {
        holds <- vapply(samples, function(col) all(ids %in% as.character(col)), logical(1))
        if (!any(holds)) {
            stop("'samples' must name every sample, by row name or in a column.", call. = FALSE)
        }
        key <- as.character(samples[[which(holds)[1]]])
    }
    out <- samples[match(ids, key), setdiff(names(samples), "sample"), drop = FALSE]
    rownames(out) <- NULL
    out
}


#' Join the arrays' sample tables
#'
#' @param tables One sample table per array.
#' @param order The array names, in the order to keep, or `NULL`.
#' @return One table, with unique `sample` names as its row names and `platform` as
#'   a factor in the arrays' order.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_bind_samples <- function(tables, order = NULL) {
    cols <- unique(unlist(lapply(tables, names)))
    filled <- lapply(tables, function(tab) {
        for (col in setdiff(cols, names(tab))) tab[[col]] <- NA
        tab[cols]
    })
    table <- do.call(rbind, filled)

    if ("platform" %in% names(table)) {
        table$platform <- factor(as.character(table$platform), levels = order %||% unique(table$platform))
        table <- table[c("sample", "platform", setdiff(names(table), c("sample", "platform")))]
    }
    repeated <- table$sample %in% table$sample[duplicated(table$sample)]
    if (any(repeated) && "platform" %in% names(table)) {
        table$sample[repeated] <- paste(table$sample[repeated], table$platform[repeated], sep = ".")
    }
    table$sample <- make.unique(table$sample)
    rownames(table) <- table$sample
    table
}


#' The platforms named by a sample table
#'
#' @param samples A cohort's sample table.
#' @return The platform names, or `NULL` where it has none.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_sample_platforms <- function(samples) {
    if ("platform" %in% names(samples)) levels(droplevels(samples$platform))
}


#' The transcripts and cytobands of a genome build
#'
#' Read from sesameData once per session. Anything that stops them being read (the
#' package missing, or no network for a first download) leaves them `NULL`, so the
#' module carries on without those tracks.
#'
#' @param genome The genome build.
#' @return The `genomeInfo` list, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_genome_info <- function(genome) {
    key <- paste0("genomeInfo.", genome)
    if (exists(key, envir = .sci_cache, inherits = FALSE)) {
        return(get(key, envir = .sci_cache, inherits = FALSE))
    }
    info <- if (requireNamespace("sesameData", quietly = TRUE)) {
        tryCatch(suppressMessages(sesameData::sesameData_getGenomeInfo(genome)), error = function(e) NULL)
    }
    assign(key, info, envir = .sci_cache)
    info
}


#' A cohort's transcripts
#'
#' @param cohort A `methylationCohort`.
#' @return A `GRangesList`, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_txns <- function(cohort) {
    cohort$txns %||% .meth_genome_info(cohort$genome)$txns
}


#' A cohort's cytobands
#'
#' @param cohort A `methylationCohort`.
#' @return A data frame, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_cohort
#' @keywords internal
.meth_cytobands <- function(cohort) {
    cohort$cytobands %||% .meth_genome_info(cohort$genome)$cytoBand
}
