# Shared helpers for the somatic-mutation modules (oncoPlot, mafSummary,
# mutationLollipop). They read a maftools `MAF` object or a data frame in
# Mutation Annotation Format columns into one standard table, and compute the
# summaries maftools computes, so the modules need maftools only for protein
# domains.

# The variant classes maftools::read.maf() keeps as non-synonymous by default
# (its `vc_nonSyn`); everything else goes to its silent table.
.maf_nonsyn <- c(
    "Frame_Shift_Del", "Frame_Shift_Ins", "Splice_Site", "Translation_Start_Site", "Nonsense_Mutation",
    "Nonstop_Mutation", "In_Frame_Del", "In_Frame_Ins", "Missense_Mutation"
)

# maftools' oncoplot colours (maftools:::get_vcColors()).
.maf_vc_colors <- c(
    Nonstop_Mutation = "#A6CEE3", Frame_Shift_Del = "#1F78B4", IGR = "#B2DF8A", Missense_Mutation = "#33A02C",
    Silent = "#FB9A99", Nonsense_Mutation = "#E31A1C", RNA = "#FDBF6F", Splice_Site = "#FF7F00",
    Intron = "#CAB2D6", Frame_Shift_Ins = "#6A3D9A", In_Frame_Del = "#FFFF99", ITD = "#9E0142",
    In_Frame_Ins = "#D53E4F", Translation_Start_Site = "#F46D43", Multi_Hit = "#000000", Amp = "#EE82EE",
    Del = "#4169E1", Complex_Event = "#7B7060"
)

# maftools' transition/transversion colours (maftools:::get_titvCol()).
.maf_titv_colors <- c(
    "C>T" = "#F44336", "C>G" = "#3F51B5", "C>A" = "#2196F3", "T>A" = "#4CAF50", "T>C" = "#FFC107",
    "T>G" = "#FF9800"
)

# Variant type colours (RColorBrewer Set3, as maftools' summary uses).
.maf_type_colors <- c(
    SNP = "#8DD3C7", INS = "#FFFFB3", DEL = "#BEBADA", DNP = "#FB8072", TNP = "#80B1D3", ONP = "#FDB462"
)

# Variant-level MAF columns, never treated as sample annotations.
.maf_variant_cols <- c(
    "Hugo_Symbol", "Entrez_Gene_Id", "Center", "NCBI_Build", "Chromosome", "Start_Position", "End_Position",
    "Strand", "Variant_Classification", "Variant_Type", "Reference_Allele", "Tumor_Seq_Allele1",
    "Tumor_Seq_Allele2", "Tumor_Sample_Barcode", "Matched_Norm_Sample_Barcode", "Protein_Change", "HGVSp_Short",
    "HGVSp", "HGVSc", "AAChange", "Transcript_ID", "i_transcript_name", "t_ref_count", "t_alt_count",
    "n_ref_count", "n_alt_count", "i_TumorVAF_WU", "tumor_f", "t_depth", "n_depth", "dbSNP_RS", "Exon_Number"
)


#' Bind data frames whose columns differ
#'
#' @param frames A list of data frames.
#' @return One data frame holding every column, missing ones filled with `NA`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_rbind_fill
#' @keywords internal
.rbind_fill <- function(frames) {
    frames <- Filter(function(f) !is.null(f) && nrow(f) > 0, frames)
    if (!length(frames)) {
        return(data.frame())
    }
    cols <- unique(unlist(lapply(frames, names)))
    do.call(rbind, lapply(frames, function(f) {
        for (cl in setdiff(cols, names(f))) f[[cl]] <- NA
        f[, cols, drop = FALSE]
    }))
}


#' Read somatic mutations into the modules' standard table
#'
#' @param x A maftools `MAF` object (from [maftools::read.maf()]), a data frame
#'   in MAF columns (`Hugo_Symbol`, `Tumor_Sample_Barcode`,
#'   `Variant_Classification`, and for some views `Variant_Type`,
#'   `Reference_Allele`, `Tumor_Seq_Allele2` and a protein-change column), or a
#'   result of this function.
#' @return A list of class `"sci_maf"`: `data` (every variant, character
#'   columns, with a logical `nonsyn` column flagging maftools' non-synonymous
#'   classes), `samples` (every sample, including those without non-synonymous
#'   variants) and `clinical` (one row per sample: `Tumor_Sample_Barcode` plus
#'   the sample annotations - the MAF object's clinical data, or for a data
#'   frame the columns that are constant within each sample).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_table
#' @keywords internal
.maf_table <- function(x) {
    if (inherits(x, "sci_maf")) {
        return(x)
    }
    clinical <- NULL
    if (methods::is(x, "MAF")) {
        d <- .rbind_fill(list(as.data.frame(methods::slot(x, "data")), as.data.frame(methods::slot(x, "maf.silent"))))
        clinical <- as.data.frame(methods::slot(x, "clinical.data"))
    } else if (is.data.frame(x)) {
        d <- as.data.frame(x)
    } else {
        stop("'data' must be a maftools MAF object or a data frame in MAF columns.", call. = FALSE)
    }

    # MAF column names are case-insensitive in practice (End_position, ...).
    canon <- c(.maf_variant_cols, "Tumor_Sample_Barcode")
    hit <- match(tolower(names(d)), tolower(canon))
    names(d)[!is.na(hit)] <- canon[hit[!is.na(hit)]]
    need <- c("Hugo_Symbol", "Tumor_Sample_Barcode", "Variant_Classification")
    miss <- setdiff(need, names(d))
    if (length(miss)) stop("The MAF is missing column(s): ", paste(miss, collapse = ", "), ".", call. = FALSE)

    for (cl in names(d)) if (is.factor(d[[cl]])) d[[cl]] <- as.character(d[[cl]])
    d <- d[!is.na(d$Tumor_Sample_Barcode) & nzchar(d$Tumor_Sample_Barcode), , drop = FALSE]
    d$nonsyn <- d$Variant_Classification %in% .maf_nonsyn
    rownames(d) <- NULL

    samples <- unique(d$Tumor_Sample_Barcode)
    if (is.null(clinical)) {
        clinical <- .maf_sample_columns(d)
    } else {
        for (cl in names(clinical)) if (is.factor(clinical[[cl]])) clinical[[cl]] <- as.character(clinical[[cl]])
        samples <- union(samples, as.character(clinical$Tumor_Sample_Barcode))
    }
    out <- list(data = d, samples = samples, clinical = clinical)
    class(out) <- "sci_maf"
    out
}


#' Validate the data of a mutation module
#'
#' The `validate` function the MAF modules pass to [.sci_plot_server()].
#'
#' @param x The module's data.
#' @return A result of [.maf_table()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_validate
#' @keywords internal
.maf_validate <- function(x) {
    m <- .maf_table(x)
    if (!any(m$data$nonsyn)) stop("The MAF holds no non-synonymous variants.", call. = FALSE)
    m
}


#' Sample-level columns of a MAF data frame
#'
#' @param d The standard MAF table.
#' @return A data frame with `Tumor_Sample_Barcode` and every non-variant column
#'   whose value is constant within each sample.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_sample_columns
#' @keywords internal
.maf_sample_columns <- function(d) {
    s <- d$Tumor_Sample_Barcode
    cand <- setdiff(names(d), c(.maf_variant_cols, "nonsyn"))
    keep <- vapply(cand, function(cl) {
        u <- unique(data.frame(s = s, v = d[[cl]], stringsAsFactors = FALSE))
        !anyDuplicated(u$s)
    }, logical(1))
    first <- !duplicated(s)
    out <- data.frame(Tumor_Sample_Barcode = s[first], stringsAsFactors = FALSE)
    for (cl in cand[keep]) out[[cl]] <- d[[cl]][first]
    out
}


#' Sample annotations usable as oncoplot tracks
#'
#' @param m A result of [.maf_table()].
#' @return The names of the clinical columns with fewer than 50 distinct values,
#'   or numeric ones.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_track_cols
#' @keywords internal
.maf_track_cols <- function(m) {
    cl <- m$clinical
    if (is.null(cl) || ncol(cl) < 2) {
        return(character(0))
    }
    cand <- setdiff(names(cl), "Tumor_Sample_Barcode")
    cand[vapply(cand, function(c) {
        v <- cl[[c]]
        is.numeric(v) || length(unique(v[!is.na(v)])) < 50
    }, logical(1))]
}


#' Non-synonymous variant counts per sample
#'
#' maftools' `getSampleSummary()`.
#'
#' @param m A result of [.maf_table()].
#' @return A data frame: `Tumor_Sample_Barcode`, one column per variant class
#'   present, and `total`, with every sample (zeros for those without variants),
#'   most mutated first.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_sample_summary
#' @keywords internal
.maf_sample_summary <- function(m) {
    d <- m$data[m$data$nonsyn, , drop = FALSE]
    vcs <- sort(unique(d$Variant_Classification))
    tab <- table(factor(d$Tumor_Sample_Barcode, levels = m$samples), factor(d$Variant_Classification, levels = vcs))
    out <- data.frame(Tumor_Sample_Barcode = m$samples, stringsAsFactors = FALSE)
    for (v in vcs) out[[v]] <- as.integer(tab[, v])
    out$total <- as.integer(rowSums(tab))
    out <- out[order(-out$total, out$Tumor_Sample_Barcode), , drop = FALSE]
    rownames(out) <- NULL
    out
}


#' Non-synonymous variant counts per gene
#'
#' maftools' `getGeneSummary()`.
#'
#' @param m A result of [.maf_table()].
#' @return A data frame: `Hugo_Symbol`, one column per variant class present,
#'   `total` (variants) and `MutatedSamples`, most frequently mutated first.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_gene_summary
#' @keywords internal
.maf_gene_summary <- function(m) {
    d <- m$data[m$data$nonsyn, , drop = FALSE]
    vcs <- sort(unique(d$Variant_Classification))
    genes <- unique(d$Hugo_Symbol)
    tab <- table(factor(d$Hugo_Symbol, levels = genes), factor(d$Variant_Classification, levels = vcs))
    out <- data.frame(Hugo_Symbol = genes, stringsAsFactors = FALSE)
    for (v in vcs) out[[v]] <- as.integer(tab[, v])
    out$total <- as.integer(rowSums(tab))
    mutated <- tapply(d$Tumor_Sample_Barcode, factor(d$Hugo_Symbol, levels = genes), function(s) length(unique(s)))
    out$MutatedSamples <- as.integer(mutated)
    out <- out[order(-out$MutatedSamples, -out$total, out$Hugo_Symbol), , drop = FALSE]
    rownames(out) <- NULL
    out
}


#' Single-nucleotide substitution classes
#'
#' The six pyrimidine-centred classes, collapsing each substitution with its
#' reverse complement (G>A is C>T, and so on).
#'
#' @param ref,alt Reference and alternate bases.
#' @return A character vector of classes, `NA` where the change is not a
#'   single-base substitution.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_snv_class
#' @keywords internal
.maf_snv_class <- function(ref, alt) {
    comp <- c(A = "T", C = "G", G = "C", T = "A")
    ref <- toupper(as.character(ref))
    alt <- toupper(as.character(alt))
    ok <- ref %in% names(comp) & alt %in% names(comp) & ref != alt
    flip <- ok & ref %in% c("A", "G")
    r <- ifelse(flip, comp[ref], ref)
    a <- ifelse(flip, comp[alt], alt)
    ifelse(ok, paste0(r, ">", a), NA_character_)
}


#' Transition and transversion counts per sample
#'
#' maftools' `titv()$raw.counts`.
#'
#' @param m A result of [.maf_table()].
#' @param use.syn Logical; count silent substitutions too (as maftools' summary
#'   plot does).
#' @return A data frame: `Tumor_Sample_Barcode` and one count column per class,
#'   for the samples with at least one substitution.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_titv
#' @keywords internal
.maf_titv <- function(m, use.syn = TRUE) {
    d <- m$data
    if (!isTRUE(use.syn)) d <- d[d$nonsyn, , drop = FALSE]
    if (!all(c("Reference_Allele", "Tumor_Seq_Allele2") %in% names(d))) {
        stop("Substitution classes need the Reference_Allele and Tumor_Seq_Allele2 columns.", call. = FALSE)
    }
    if ("Variant_Type" %in% names(d)) d <- d[d$Variant_Type %in% "SNP", , drop = FALSE]
    cls <- .maf_snv_class(d$Reference_Allele, d$Tumor_Seq_Allele2)
    keep <- !is.na(cls)
    classes <- c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G")
    tab <- table(factor(d$Tumor_Sample_Barcode[keep], levels = unique(d$Tumor_Sample_Barcode[keep])),
        factor(cls[keep], levels = classes))
    out <- data.frame(Tumor_Sample_Barcode = rownames(tab), stringsAsFactors = FALSE)
    for (cl in classes) out[[cl]] <- as.integer(tab[, cl])
    out
}


#' The gene-by-sample alteration matrix of an oncoplot
#'
#' Each cell holds the variant class of the gene in the sample, `"Multi_Hit"`
#' when it carries more than one variant (as maftools' `createOncoMatrix()`), or
#' `""`. Genes run from most to least often mutated; samples are sorted so that
#' those mutated in the first gene come first, then the second, and so on (the
#' oncoplot "waterfall").
#'
#' @param m A result of [.maf_table()].
#' @param genes The genes, or `NULL` for the `top.n` most mutated.
#' @param top.n The number of genes when `genes` is `NULL`.
#' @param include.unmutated Logical; keep samples with none of the genes
#'   mutated (at the right).
#' @param sort Logical; sort the samples. Otherwise they keep their order.
#' @return A list with `classes` (the character matrix), `changes` (a matrix of
#'   the protein changes, for hover text) and `counts` (the number of variants).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_onco_matrix
#' @keywords internal
.maf_onco_matrix <- function(m, genes = NULL, top.n = 20, include.unmutated = TRUE, sort = TRUE) {
    gs <- .maf_gene_summary(m)
    genes <- if (length(genes)) intersect(genes, gs$Hugo_Symbol) else utils::head(gs$Hugo_Symbol, top.n)
    if (!length(genes)) stop("None of the genes carry a non-synonymous variant.", call. = FALSE)
    d <- m$data[m$data$nonsyn & m$data$Hugo_Symbol %in% genes, , drop = FALSE]
    prot <- .maf_protein_col(d)
    samples <- m$samples

    key <- paste(d$Hugo_Symbol, d$Tumor_Sample_Barcode, sep = "\r")
    per_cell <- split(seq_len(nrow(d)), key)
    classes <- matrix("", length(genes), length(samples), dimnames = list(genes, samples))
    changes <- classes
    counts <- matrix(0L, length(genes), length(samples), dimnames = list(genes, samples))
    for (k in names(per_cell)) {
        idx <- per_cell[[k]]
        g <- d$Hugo_Symbol[idx[1]]
        s <- d$Tumor_Sample_Barcode[idx[1]]
        classes[g, s] <- if (length(idx) > 1) "Multi_Hit" else d$Variant_Classification[idx]
        counts[g, s] <- length(idx)
        if (!is.null(prot)) {
            pc <- d[[prot]][idx]
            changes[g, s] <- paste(unique(pc[!is.na(pc) & nzchar(pc)]), collapse = ", ")
        }
    }

    # Genes by mutated samples, then samples by their binary pattern over those
    # genes; ties fall alphabetically, as in maftools' createOncoMatrix().
    mutated <- classes != ""
    o <- order(-rowSums(mutated), genes)
    classes <- classes[o, , drop = FALSE]
    changes <- changes[o, , drop = FALSE]
    counts <- counts[o, , drop = FALSE]
    mutated <- mutated[o, , drop = FALSE]
    if (isTRUE(sort)) {
        so <- do.call(order, c(lapply(seq_len(nrow(mutated)), function(i) -mutated[i, ]), list(colnames(mutated))))
        classes <- classes[, so, drop = FALSE]
        changes <- changes[, so, drop = FALSE]
        counts <- counts[, so, drop = FALSE]
        mutated <- mutated[, so, drop = FALSE]
    }
    if (!isTRUE(include.unmutated)) {
        keep <- colSums(mutated) > 0
        classes <- classes[, keep, drop = FALSE]
        changes <- changes[, keep, drop = FALSE]
        counts <- counts[, keep, drop = FALSE]
    }
    list(classes = classes, changes = changes, counts = counts)
}


#' The protein-change column of a MAF
#'
#' Looked for in maftools' order: `HGVSp_Short`, `Protein_Change`, `AAChange`.
#'
#' @param d The standard MAF table.
#' @return A column name, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_protein_col
#' @keywords internal
.maf_protein_col <- function(d) {
    hit <- intersect(c("HGVSp_Short", "Protein_Change", "AAChange"), names(d))
    if (length(hit)) hit[1] else NULL
}


#' Amino-acid positions of protein changes
#'
#' Parsed as maftools' `lollipopPlot()` does: the part after the last `.`, with
#' a trailing `Ter...`, letters and `*` stripped, and the first number of a
#' range taken. `"p.R882H"` gives 882, `"p.KIM2014fs"` 2014, `"p.R7*"` 7.
#'
#' @param x A character vector of protein changes.
#' @return A numeric vector of positions, `NA` where none can be read.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_protein_position
#' @keywords internal
.maf_protein_position <- function(x) {
    x <- as.character(x)
    last <- vapply(strsplit(ifelse(is.na(x), "", x), ".", fixed = TRUE), function(p) {
        if (length(p)) p[length(p)] else ""
    }, character(1))
    pos <- gsub("Ter.*", "", last)
    pos <- gsub("[[:alpha:]]", "", pos)
    pos <- gsub("\\*$", "", pos)
    pos <- gsub("^\\*", "", pos)
    pos <- gsub("\\*.*", "", pos)
    pos <- vapply(strsplit(pos, "_", fixed = TRUE), function(p) if (length(p)) p[1] else "", character(1))
    abs(suppressWarnings(as.numeric(pos)))
}


#' Protein length and domains of a gene, from maftools
#'
#' Reads maftools' bundled Pfam/SMART domain table (`protein_domains.RDs`),
#' using the gene's longest isoform (the first RefSeq protein on a tie), as
#' maftools' `lollipopPlot()` does. The table is read once per session.
#'
#' @param gene An HGNC gene symbol.
#' @return A list with `length` (amino acids), `refseq` and `domains` (a data
#'   frame of `start`, `end` and `label`), or `NULL` when maftools is not
#'   installed or does not know the gene.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_domains
#' @keywords internal
.maf_domains <- function(gene) {
    tab <- .sci_cache$protein_domains
    if (is.null(tab)) {
        f <- if (requireNamespace("maftools", quietly = TRUE)) {
            system.file("extdata", "protein_domains.RDs", package = "maftools")
        } else {
            ""
        }
        if (!nzchar(f)) {
            return(NULL)
        }
        raw <- readRDS(f)
        # The file repeats a column name, so take its columns by position:
        # HGNC, refseq.ID, protein.ID, aa.length, Start, End, domain.source, Label.
        tab <- data.frame(
            gene = as.character(raw[[1]]), refseq = as.character(raw[[2]]), length = as.numeric(raw[[4]]),
            start = as.numeric(raw[[5]]), end = as.numeric(raw[[6]]), label = as.character(raw[[8]]),
            stringsAsFactors = FALSE
        )
        assign("protein_domains", tab, envir = .sci_cache)
    }
    g <- tab[tab$gene == gene, , drop = FALSE]
    if (!nrow(g)) {
        return(NULL)
    }
    g <- g[g$length == max(g$length, na.rm = TRUE), , drop = FALSE]
    ref <- g$refseq[1]
    len <- g$length[1]
    g <- g[g$refseq == ref & !is.na(g$start) & !is.na(g$end), , drop = FALSE]
    list(length = len, refseq = ref,
        domains = data.frame(start = g$start, end = g$end, label = g$label, stringsAsFactors = FALSE))
}

# Session-level cache (maftools' domain table).
.sci_cache <- new.env(parent = emptyenv())


#' Variant classes and their colours for a mutation module's picker
#'
#' @param m A result of [.maf_table()].
#' @param multi.hit Logical; include `"Multi_Hit"`.
#' @return The non-synonymous classes present, in maftools' colour order.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_vc_levels
#' @keywords internal
.maf_vc_levels <- function(m, multi.hit = FALSE) {
    present <- unique(m$data$Variant_Classification[m$data$nonsyn])
    lv <- c(intersect(names(.maf_vc_colors), present), setdiff(sort(present), names(.maf_vc_colors)))
    if (isTRUE(multi.hit)) lv <- c(lv, "Multi_Hit")
    lv
}


#' Colours for variant classes
#'
#' @param classes The classes.
#' @param colors A named colour vector from the module's picker, or `NULL`.
#' @return A named colour vector covering `classes`: the picker's colour, then
#'   maftools', then a grey.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_class_colors
#' @keywords internal
.maf_class_colors <- function(classes, colors = NULL) {
    out <- stats::setNames(rep("#7F7F7F", length(classes)), classes)
    known <- intersect(classes, names(.maf_vc_colors))
    out[known] <- .maf_vc_colors[known]
    if (length(colors)) {
        given <- intersect(classes, names(colors))
        out[given] <- colors[given]
    }
    out
}


#' Defaults with maftools' variant-class colours
#'
#' @param defaults A named list of user defaults, or `NULL`.
#' @return `defaults` with `palette.colours` seeded from maftools' palette
#'   where the user gave no colour.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_color_defaults
#' @keywords internal
.maf_color_defaults <- function(defaults) {
    defaults <- defaults %||% list()
    given <- defaults$palette.colours
    cols <- .maf_vc_colors
    if (length(given) && !is.null(names(given))) cols[names(given)] <- given
    defaults$palette.colours <- cols
    defaults
}


#' The example MAF: TCGA LAML, as maftools ships it
#'
#' The somatic mutations of 193 acute myeloid leukaemia tumours (The Cancer
#' Genome Atlas Research Network, NEJM 2013;368:2059-74) that maftools ships in
#' `inst/extdata`, read as a data frame (silent and non-silent variants alike)
#' with each sample's clinical annotations merged in. Read directly rather than
#' with [maftools::read.maf()], which needs R.utils for a gzipped file.
#'
#' @return A data frame in MAF columns.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_maf_example
#' @keywords internal
.maf_example <- function() {
    if (!requireNamespace("maftools", quietly = TRUE)) {
        stop("The example MAF ships with maftools: BiocManager::install('maftools').", call. = FALSE)
    }
    maf <- utils::read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
        comment.char = "#", stringsAsFactors = FALSE)
    clinical <- utils::read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"),
        stringsAsFactors = FALSE)
    out <- merge(maf, clinical, by = "Tumor_Sample_Barcode", all.x = TRUE, sort = FALSE)
    out[, c(names(maf), setdiff(names(clinical), "Tumor_Sample_Barcode"))]
}


#' Build a standalone Shiny app for a mutation module
#'
#' [VizModules::createModuleApp()] over the supplied MAFs (maftools `MAF`
#' objects become data frames first, since the app's table holds data frames).
#'
#' @param inputs_ui_fn,output_ui_fn,server_fn The module's functions.
#' @param data_list A named list of MAF data frames or maftools `MAF` objects,
#'   or `NULL` for maftools' TCGA LAML example (see [.maf_example()]).
#' @param title Page title.
#' @return A [shiny::shinyApp()] object.
#'
#' @importFrom VizModules createModuleApp
#' @author Jared Andrews
#' @rdname INTERNAL_maf_module_app
#' @keywords internal
.maf_module_app <- function(inputs_ui_fn, output_ui_fn, server_fn, data_list, title) {
    if (is.null(data_list)) {
        data_list <- list("TCGA LAML (maftools)" = .maf_example())
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    data_list <- lapply(data_list, function(x) {
        if (is.data.frame(x)) {
            return(x)
        }
        m <- .maf_table(x)
        d <- m$data[setdiff(names(m$data), "nonsyn")]
        if (!is.null(m$clinical) && ncol(m$clinical) > 1) {
            d <- merge(d, m$clinical, by = "Tumor_Sample_Barcode", all.x = TRUE, sort = FALSE)
        }
        d
    })
    createModuleApp(
        inputs_ui_fn = inputs_ui_fn,
        output_ui_fn = output_ui_fn,
        server_fn = server_fn,
        data_list = data_list,
        title = title
    )
}
