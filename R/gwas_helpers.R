#' Detect the columns of GWAS summary statistics
#'
#' Recognises the usual names for the chromosome, position, p-value and variant
#' columns across qqman, PLINK, REGENIE and the GWAS Catalog harmonised format.
#'
#' @param data A data frame of summary statistics.
#' @return A list with `chr`, `bp`, `p` and `snp`, each a column name or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_columns
#' @keywords internal
.gwas_columns <- function(data) {
    pick <- function(candidates, numeric = FALSE) {
        hit <- .detect_column(data, candidates, numeric = numeric)
        if (is.null(hit)) {
            lower <- tolower(names(data))
            idx <- match(tolower(candidates), lower)
            idx <- idx[!is.na(idx)]
            if (length(idx)) hit <- names(data)[idx[1]]
        }
        hit
    }
    list(
        chr = pick(c("CHR", "chr", "chrom", "chromosome", "#CHROM", "CHROM", "Chromosome")),
        bp = pick(c("BP", "bp", "POS", "pos", "position", "base_pair_location", "GENPOS", "Position"),
            numeric = TRUE),
        p = pick(c("P", "p", "pval", "p_value", "P.value", "PVAL", "p.value", "Pvalue", "P_BOLT_LMM"),
            numeric = TRUE),
        snp = pick(c("SNP", "snp", "rsid", "variant_id", "ID", "MarkerName", "rs_id", "Variant"))
    )
}


#' Natural order of chromosome names
#'
#' Numbered chromosomes in numeric order, then X, Y and the mitochondrion, then
#' anything else alphabetically. A "chr" prefix is ignored.
#'
#' @param x Chromosome names or numbers.
#' @return The distinct names, ordered.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_chr_order
#' @keywords internal
.gwas_chr_order <- function(x) {
    lv <- unique(as.character(x[!is.na(x)]))
    bare <- sub("^chr", "", lv, ignore.case = TRUE)
    num <- suppressWarnings(as.numeric(bare))
    special <- match(toupper(bare), c("X", "Y", "XY", "M", "MT"))
    key <- ifelse(!is.na(num), num, ifelse(!is.na(special), 1000 + special, 2000))
    lv[order(key, bare)]
}


#' Prepare summary statistics for a Manhattan plot
#'
#' Drops variants with a missing or out-of-range p-value or position, orders the
#' chromosomes naturally, and lays them end to end: `manhattan.chr` is the
#' chromosome as an ordered factor (with any "chr" prefix removed) and
#' `manhattan.x` the position along the concatenated genome, with a gap between
#' chromosomes.
#'
#' @param data A data frame of summary statistics.
#' @param chr,bp,p Column names.
#' @param gap Gap between chromosomes, as a fraction of the genome length.
#' @return `data` with `manhattan.chr` and `manhattan.x` added, sorted by them.
#'   The chromosome centres along the axis are attached as attribute `"centres"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_prepare
#' @keywords internal
.gwas_prepare <- function(data, chr, bp, p, gap = 0.01) {
    data <- as.data.frame(data)
    missing <- setdiff(c(chr, bp, p), names(data))
    if (length(missing)) {
        stop("Column(s) not in the data: ", paste(missing, collapse = ", "), call. = FALSE)
    }
    pv <- suppressWarnings(as.numeric(data[[p]]))
    pos <- suppressWarnings(as.numeric(data[[bp]]))
    keep <- is.finite(pv) & pv > 0 & pv <= 1 & is.finite(pos) & !is.na(data[[chr]])
    data <- data[keep, , drop = FALSE]
    if (nrow(data) == 0) stop("No variants with a valid position and p-value.", call. = FALSE)

    order_lv <- .gwas_chr_order(data[[chr]])
    labels <- sub("^chr", "", order_lv, ignore.case = TRUE)
    data$manhattan.chr <- factor(sub("^chr", "", as.character(data[[chr]]), ignore.case = TRUE), levels = labels)

    pos <- as.numeric(data[[bp]])
    spans <- tapply(pos, data$manhattan.chr, max)
    spans[is.na(spans)] <- 0
    starts <- tapply(pos, data$manhattan.chr, min)
    starts[is.na(starts)] <- 0
    width <- spans - starts
    pad <- gap * sum(width)
    offset <- c(0, cumsum(width + pad))[seq_along(width)] - starts
    names(offset) <- names(width)

    data$manhattan.x <- pos + offset[as.character(data$manhattan.chr)]
    data <- data[order(data$manhattan.chr, data$manhattan.x), , drop = FALSE]
    rownames(data) <- NULL

    centres <- tapply(data$manhattan.x, data$manhattan.chr, function(v) mean(range(v)))
    attr(data, "centres") <- centres[!is.na(centres)]
    data
}


#' Thin the non-significant variants of large summary statistics
#'
#' Keeps every variant with p below `p.keep` and a reproducible random
#' `fraction` of the rest, so plots of millions of variants stay responsive
#' without losing any signal worth looking at.
#'
#' @param df A data frame.
#' @param p The p-value column.
#' @param p.keep Variants below this p-value are always kept.
#' @param fraction Fraction of the remaining variants to keep.
#' @return The thinned data frame, in the original order.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_thin
#' @keywords internal
.gwas_thin <- function(df, p, p.keep = 0.01, fraction = 0.1) {
    if (!is.numeric(fraction) || is.na(fraction) || fraction >= 1) {
        return(df)
    }
    sig <- df[[p]] < p.keep
    rest <- which(!sig)
    picked <- with_stable_seed(rest[stats::runif(length(rest)) < max(fraction, 0)])
    df[sort(c(which(sig), picked)), , drop = FALSE]
}


#' Genomic inflation factor
#'
#' The median of the 1-df chi-squared statistics the p-values correspond to,
#' divided by the median of that distribution (lambda GC).
#'
#' @param p Numeric p-values.
#' @return A single number.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_lambda
#' @keywords internal
.gwas_lambda <- function(p) {
    p <- p[is.finite(p) & p > 0 & p <= 1]
    stats::median(stats::qchisq(1 - p, df = 1)) / stats::qchisq(0.5, df = 1)
}


#' Observed against expected -log10(p) for a QQ plot
#'
#' @param data A data frame of summary statistics.
#' @param p The p-value column.
#' @param snp The variant column, or `NULL`.
#' @return A data frame sorted from the most significant variant: `qq.rank`,
#'   `qq.expected`, `qq.observed`, the p-value as `qq.p`, and the variant id as `variant` when given. The
#'   variant count and lambda GC are attached as attributes `"n"` and `"lambda"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_qq_frame
#' @keywords internal
.gwas_qq_frame <- function(data, p, snp = NULL) {
    data <- as.data.frame(data)
    if (!p %in% names(data)) stop("Column not in the data: ", p, call. = FALSE)
    pv <- suppressWarnings(as.numeric(data[[p]]))
    keep <- is.finite(pv) & pv > 0 & pv <= 1
    pv <- pv[keep]
    if (length(pv) == 0) stop("No valid p-values.", call. = FALSE)
    ord <- order(pv)
    n <- length(pv)
    out <- data.frame(
        qq.rank = seq_len(n),
        qq.expected = -log10(stats::ppoints(n)),
        qq.observed = -log10(pv[ord]),
        qq.p = pv[ord]
    )
    if (!is.null(snp) && snp %in% names(data)) {
        out$variant <- as.character(data[[snp]][keep][ord])
    }
    attr(out, "n") <- n
    attr(out, "lambda") <- .gwas_lambda(pv)
    out
}


#' Defaults shared by the GWAS module UIs and servers
#'
#' @param data The summary statistics.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_defaults
#' @keywords internal
.gwas_defaults <- function(data, defaults = NULL) {
    cols <- if (is.null(data)) list() else .gwas_columns(data)
    base <- list(
        chr.col = cols$chr %||% "",
        bp.col = cols$bp %||% "",
        p.col = cols$p %||% "",
        snp.col = cols$snp %||% "",
        thin = TRUE,
        thin.p = 0.01,
        thin.fraction = 0.25
    )
    utils::modifyList(base, defaults %||% list())
}

# Inputs the GWAS modules add to the wrapped scatter module.
.gwas_shared_keys <- c("chr.col", "bp.col", "p.col", "snp.col", "thin", "thin.p", "thin.fraction")


#' Default inputs for the Manhattan plot module
#'
#' The GWAS column defaults plus the wrapped scatter module's: the cumulative
#' position on x, the p-value column on y drawn as -log10, points coloured by
#' chromosome in two alternating colours, variant ids for hover and labels, and
#' no legend (one entry per chromosome says nothing the axis does not).
#'
#' @param data The summary statistics.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_manhattan_defaults
#' @keywords internal
.manhattan_defaults <- function(data, defaults = NULL) {
    d <- .gwas_defaults(data, defaults)
    base <- list(
        sig.threshold = 5e-8,
        suggestive.threshold = 1e-5,
        color.odd = "#1F4E79",
        color.even = "#7FA7D1",
        x.by = "manhattan.x",
        y.by = d$p.col,
        y.adj.fxn = "neg_log10",
        color.by = "manhattan.chr",
        hover.data = Filter(nzchar, c(d$snp.col, d$chr.col, d$bp.col, d$p.col)),
        annotate.by = d$snp.col,
        legend.show = FALSE
    )
    d <- utils::modifyList(base, d)
    if (!is.null(data) && nzchar(d$chr.col) && d$chr.col %in% names(data) && is.null(d$color.panel)) {
        chrs <- sub("^chr", "", .gwas_chr_order(data[[d$chr.col]]), ignore.case = TRUE)
        d$color.panel <- stats::setNames(rep(c(d$color.odd, d$color.even), length.out = length(chrs)), chrs)
    }
    d
}

# Inputs the Manhattan module adds on top of the shared GWAS ones.
.manhattan_keys <- c(.gwas_shared_keys, "sig.threshold", "suggestive.threshold", "color.odd", "color.even")


#' Add the Manhattan plot's layers to the wrapped scatter figure
#'
#' The `fig.fn` hook [manhattanPlotServer()] hands to the scatter module. While
#' the x-axis is the concatenated genome, it labels the axis with chromosome
#' names at their centres; while the y-axis is the p-value drawn as -log10, it
#' titles it and draws the genome-wide and suggestive significance lines.
#' Adjusted or split axes are left alone.
#'
#' @param fig The scatter figure.
#' @param centres Named chromosome centres along the x-axis.
#' @param input The module's input.
#' @param isolate_fn The module's isolation helper.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_manhattan_layers
#' @keywords internal
.manhattan_layers <- function(fig, centres, input, isolate_fn) {
    if (nz_value(isolate_fn(input$split.by))) {
        return(fig)
    }
    x_genome <- identical(isolate_fn(input$x.by), "manhattan.x") &&
        !nz_value(isolate_fn(input$x.adjustment)) && !nz_value(isolate_fn(input$x.adj.fxn))
    if (x_genome && length(centres)) {
        fig$x$layout$xaxis$tickmode <- "array"
        fig$x$layout$xaxis$tickvals <- unname(as.numeric(centres))
        fig$x$layout$xaxis$ticktext <- names(centres)
        fig$x$layout$xaxis$title$text <- "Chromosome"
    }

    y_logp <- identical(isolate_fn(input$y.by), isolate_fn(input$p.col)) &&
        identical(isolate_fn(input$y.adj.fxn), "neg_log10") && !nz_value(isolate_fn(input$y.adjustment))
    if (y_logp) {
        fig$x$layout$yaxis$title$text <- "-log10(p)"
        lines <- list(
            list(p = isolate_fn(input$sig.threshold), color = "#D62728", dash = "dash"),
            list(p = isolate_fn(input$suggestive.threshold), color = "#1F77B4", dash = "dot")
        )
        for (l in lines) {
            if (is.numeric(l$p) && length(l$p) == 1 && !is.na(l$p) && l$p > 0 && l$p < 1) {
                fig$x$layout$shapes <- c(fig$x$layout$shapes, list(list(
                    type = "line", xref = "paper", x0 = 0, x1 = 1, yref = "y",
                    y0 = -log10(l$p), y1 = -log10(l$p), line = list(color = l$color, dash = l$dash, width = 1)
                )))
            }
        }
    }
    fig
}


#' Stop when the GWAS columns could not be found
#'
#' @param d Resolved defaults with `chr.col`, `bp.col`, `p.col`.
#' @param need Which of them are required.
#' @return `NULL`, invisibly; errors otherwise.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_require_columns
#' @keywords internal
.gwas_require_columns <- function(d, need = c("chr.col", "bp.col", "p.col")) {
    missing <- need[!vapply(need, function(k) nz_value(d[[k]]), logical(1))]
    if (length(missing)) {
        stop("Could not detect the ", paste(sub("[.]col$", "", missing), collapse = ", "),
            " column(s); name them in `defaults` (", paste(missing, collapse = ", "), ").", call. = FALSE)
    }
    invisible(NULL)
}


#' Column selectors shared by the GWAS modules
#'
#' @param ns Namespace function.
#' @param data The summary statistics.
#' @param d Resolved defaults.
#' @param which Which selectors to include.
#' @return A `tagList`.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_column_inputs
#' @keywords internal
.gwas_column_inputs <- function(ns, data, d, which = c("chr.col", "bp.col", "p.col", "snp.col")) {
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    all <- names(data)
    inputs <- list(
        chr.col = .sci_tip(viz_select_input(ns("chr.col"), "Chromosome Column", choices = all, selected = d$chr.col),
            "Column holding the chromosome (e.g. 1-22, X; a 'chr' prefix is fine)."),
        bp.col = .sci_tip(viz_select_input(ns("bp.col"), "Position Column", choices = num, selected = d$bp.col),
            "Column holding the base-pair position."),
        p.col = .sci_tip(viz_select_input(ns("p.col"), "P-value Column", choices = num, selected = d$p.col),
            "Column holding the association p-value."),
        snp.col = .sci_tip(viz_select_input(ns("snp.col"), "Variant Column",
            choices = c("None" = "", stats::setNames(all, all)), selected = d$snp.col
        ), "Column holding variant ids, used for hover text and labels.")
    )
    do.call(tagList, unname(inputs[which]))
}


#' Thinning controls shared by the GWAS modules
#'
#' @param ns Namespace function.
#' @param d Resolved defaults.
#' @return A `tagList`.
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_thin_inputs
#' @keywords internal
.gwas_thin_inputs <- function(ns, d) {
    tagList(
        .sci_tip(materialSwitch(ns("thin"), "Thin Variants", value = isTRUE(d$thin), status = "success"),
            "Keep every variant below the p-value cut-off and only a fraction of the rest, to keep large plots fast."),
        .sci_tip(numericInput(ns("thin.p"), "Always Keep Below p", value = d$thin.p, min = 0, max = 1, step = 0.001),
            "Variants with a p-value below this are always plotted."),
        .sci_tip(numericInput(ns("thin.fraction"), "Fraction of Others Kept",
            value = d$thin.fraction, min = 0.01, max = 1, step = 0.05
        ), "Fraction of the remaining variants plotted, chosen reproducibly.")
    )
}


#' Restore the shared GWAS inputs on Reset
#'
#' @param session The module session.
#' @param d Resolved defaults.
#' @return `NULL`, invisibly.
#'
#' @importFrom shinyWidgets updateMaterialSwitch
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_reset_inputs
#' @keywords internal
.gwas_reset_inputs <- function(session, d) {
    for (k in c("chr.col", "bp.col", "p.col", "snp.col")) update_viz_select(session, k, selected = d[[k]])
    updateMaterialSwitch(session, "thin", value = isTRUE(d$thin))
    updateNumericInput(session, "thin.p", value = d$thin.p)
    updateNumericInput(session, "thin.fraction", value = d$thin.fraction)
    invisible(NULL)
}


#' Default inputs for the GWAS QQ plot module
#'
#' @param data The summary statistics.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_qq_defaults
#' @keywords internal
.gwas_qq_defaults <- function(data, defaults = NULL) {
    d <- .gwas_defaults(data, defaults)
    base <- list(
        show.band = TRUE,
        ci.level = 0.95,
        band.color = "#7F7F7F",
        band.opacity = 0.25,
        show.lambda = TRUE,
        x.by = "qq.expected",
        y.by = "qq.observed",
        color.by = "",
        abline.slopes = "1",
        abline.intercepts = "0",
        hover.data = c(if (nzchar(d$snp.col)) "variant", "qq.p"),
        annotate.by = if (nzchar(d$snp.col)) "variant" else ""
    )
    utils::modifyList(base, d)
}

# Inputs the QQ module adds on top of the shared GWAS ones.
.gwas_qq_keys <- c(.gwas_shared_keys, "show.band", "ci.level", "band.color", "band.opacity", "show.lambda")


#' Confidence band of a QQ plot as an SVG path
#'
#' The `ci.level` interval of the i-th smallest of `n` uniform p-values is given
#' by the Beta(i, n - i + 1) quantiles. It is evaluated at up to `points`
#' log-spaced ranks, which is plenty for a smooth outline and keeps the shape
#' small for millions of variants.
#'
#' @param n Number of variants.
#' @param ci.level Confidence level.
#' @param points Number of ranks to evaluate.
#' @return An SVG path string in data coordinates (expected, observed -log10 p).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_qq_band
#' @keywords internal
.gwas_qq_band <- function(n, ci.level = 0.95, points = 300) {
    i <- unique(round(exp(seq(0, log(n), length.out = min(points, n)))))
    expected <- -log10(stats::ppoints(n)[i])
    a <- (1 - ci.level) / 2
    upper <- -log10(stats::qbeta(a, i, n - i + 1))
    lower <- -log10(stats::qbeta(1 - a, i, n - i + 1))
    fmt <- function(x, y) paste0(signif(x, 6), ",", signif(y, 6))
    paste0(
        "M ", paste(fmt(expected, lower), collapse = " L "),
        " L ", paste(rev(fmt(expected, upper)), collapse = " L "), " Z"
    )
}


#' Add the QQ plot's layers to the wrapped scatter figure
#'
#' The `fig.fn` hook [gwasQQPlotServer()] hands to the scatter module: axis
#' titles, the confidence band under the null, and the genomic inflation factor.
#' Only applied while the axes are the expected and observed -log10(p) with no
#' adjustment or split.
#'
#' @param fig The scatter figure.
#' @param n Number of variants (before thinning).
#' @param lambda Lambda GC.
#' @param input The module's input.
#' @param isolate_fn The module's isolation helper.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_qq_layers
#' @keywords internal
.gwas_qq_layers <- function(fig, n, lambda, input, isolate_fn) {
    adjusted <- any(vapply(
        list(isolate_fn(input$x.adjustment), isolate_fn(input$x.adj.fxn),
            isolate_fn(input$y.adjustment), isolate_fn(input$y.adj.fxn)),
        nz_value, logical(1)
    ))
    on_axes <- identical(isolate_fn(input$x.by), "qq.expected") && identical(isolate_fn(input$y.by), "qq.observed")
    if (!on_axes || adjusted || nz_value(isolate_fn(input$split.by))) {
        return(fig)
    }
    fig$x$layout$xaxis$title$text <- "Expected -log10(p)"
    fig$x$layout$yaxis$title$text <- "Observed -log10(p)"

    level <- isolate_fn(input$ci.level)
    if (isTRUE(isolate_fn(input$show.band)) && is.numeric(level) && length(level) == 1 && !is.na(level) &&
        level > 0 && level < 1 && n > 1) {
        fig$x$layout$shapes <- c(fig$x$layout$shapes, list(list(
            type = "path", path = .gwas_qq_band(n, level), xref = "x", yref = "y", layer = "below",
            fillcolor = .gwas_band_fill(isolate_fn(input$band.color), isolate_fn(input$band.opacity)),
            line = list(width = 0)
        )))
    }
    if (isTRUE(isolate_fn(input$show.lambda)) && is.finite(lambda)) {
        fig$x$layout$annotations <- c(fig$x$layout$annotations, list(list(
            x = 0.02, y = 0.98, xref = "paper", yref = "paper", xanchor = "left", yanchor = "top",
            text = sprintf("\u03bb<sub>GC</sub> = %.3f", lambda), showarrow = FALSE
        )))
    }
    fig
}


#' Fill colour of the QQ plot's confidence band
#'
#' @param color The band colour; an unusable value falls back to grey.
#' @param opacity The fill opacity, clamped to 0-1; an unusable value falls back
#'   to 0.25.
#' @return An `rgba()` colour string.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gwas_band_fill
#' @keywords internal
.gwas_band_fill <- function(color = "#7F7F7F", opacity = 0.25) {
    if (!nz_value(color) || inherits(try(grDevices::col2rgb(color), silent = TRUE), "try-error")) {
        color <- "#7F7F7F"
    }
    if (!is.numeric(opacity) || length(opacity) != 1 || is.na(opacity)) {
        opacity <- 0.25
    }
    plotly::toRGB(color, min(max(opacity, 0), 1))
}
