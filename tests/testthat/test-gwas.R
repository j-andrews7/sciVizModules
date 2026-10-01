# Tests for the GWAS modules (manhattanPlot, gwasQQPlot) and their helpers.

test_that("all GWAS functions are exported", {
    for (m in c("manhattanPlot", "gwasQQPlot")) {
        for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
            expect_true(is.function(get0(paste0(m, suffix), envir = asNamespace("sciVizModules"))),
                info = paste0(m, suffix))
        }
    }
})

test_that("columns are detected across the common naming styles", {
    qqman <- data.frame(SNP = "rs1", CHR = 1, BP = 10, P = 0.5)
    catalog <- data.frame(variant_id = "rs1", chromosome = 1, base_pair_location = 10, p_value = 0.5)
    plink <- data.frame(`#CHROM` = 1, POS = 10, ID = "rs1", P = 0.5, check.names = FALSE)
    expect_identical(unlist(.gwas_columns(qqman)), c(chr = "CHR", bp = "BP", p = "P", snp = "SNP"))
    expect_identical(unlist(.gwas_columns(catalog)),
        c(chr = "chromosome", bp = "base_pair_location", p = "p_value", snp = "variant_id"))
    expect_identical(unlist(.gwas_columns(plink)), c(chr = "#CHROM", bp = "POS", p = "P", snp = "ID"))
})

test_that("chromosomes are ordered naturally and laid end to end", {
    df <- data.frame(chr = c("chr2", "chrX", "chr10", "chr1", "chr1"), pos = c(5, 3, 1, 2, 8),
        p = c(0.1, 0.2, 0.3, 0.4, 2))
    out <- .gwas_prepare(df, "chr", "pos", "p", gap = 0)
    expect_identical(levels(out$manhattan.chr), c("1", "2", "10", "X"))
    # The p > 1 row is dropped, and positions increase along the genome.
    expect_identical(nrow(out), 4L)
    expect_false(is.unsorted(out$manhattan.x))
    expect_identical(names(attr(out, "centres")), c("1", "2", "10", "X"))
})

test_that("thinning keeps every significant variant and is reproducible", {
    data(example_gwas, package = "sciVizModules")
    thin1 <- .gwas_thin(example_gwas, "P", p.keep = 0.001, fraction = 0.1)
    thin2 <- .gwas_thin(example_gwas, "P", p.keep = 0.001, fraction = 0.1)
    expect_identical(thin1, thin2)
    expect_true(all(example_gwas$SNP[example_gwas$P < 0.001] %in% thin1$SNP))
    expect_lt(nrow(thin1), nrow(example_gwas) / 5)
    expect_identical(.gwas_thin(example_gwas, "P", 0.01, 1), example_gwas)
})

test_that("lambda GC and the QQ frame follow their definitions", {
    p <- stats::ppoints(1000)
    expect_equal(.gwas_lambda(p), 1, tolerance = 0.01)
    expect_equal(.gwas_lambda(p), stats::median(stats::qchisq(1 - p, 1)) / stats::qchisq(0.5, 1))

    data(example_gwas, package = "sciVizModules")
    qq <- .gwas_qq_frame(example_gwas, "P", "SNP")
    expect_equal(qq$qq.expected, -log10(stats::ppoints(nrow(example_gwas))))
    expect_equal(qq$qq.observed, -log10(sort(example_gwas$P)))
    expect_identical(qq$variant[1], example_gwas$SNP[which.min(example_gwas$P)])
    expect_match(.gwas_qq_band(1000), "^M .* Z$")
})

test_that("the Manhattan layers label chromosomes and draw both significance lines", {
    fig <- plotly::plotly_build(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers"))
    centres <- c(`1` = 100, `2` = 300)
    input <- list(x.by = "manhattan.x", y.by = "P", p.col = "P", y.adj.fxn = "neg_log10",
        sig.threshold = 5e-8, suggestive.threshold = 1e-5)
    out <- .manhattan_layers(fig, centres, input, identity)
    expect_identical(out$x$layout$xaxis$ticktext, c("1", "2"))
    expect_identical(out$x$layout$xaxis$title$text, "Chromosome")
    expect_equal(vapply(out$x$layout$shapes, `[[`, 0, "y0"), -log10(c(5e-8, 1e-5)))

    # A blank suggestive threshold draws only the genome-wide line; a split or
    # a different y column leaves the axes alone.
    one <- .manhattan_layers(fig, centres, utils::modifyList(input, list(suggestive.threshold = NA)), identity)
    expect_length(one$x$layout$shapes, 1)
    split <- .manhattan_layers(fig, centres, utils::modifyList(input, list(split.by = "CHR")), identity)
    expect_null(split$x$layout$xaxis$ticktext)
    other_y <- .manhattan_layers(fig, centres, utils::modifyList(input, list(y.by = "BP")), identity)
    expect_length(other_y$x$layout$shapes, 0)
})

test_that("the QQ layers add the band and lambda GC only on the QQ axes", {
    fig <- plotly::plotly_build(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers"))
    input <- list(x.by = "qq.expected", y.by = "qq.observed", show.band = TRUE, ci.level = 0.95, show.lambda = TRUE)
    out <- .gwas_qq_layers(fig, 1000, 1.05, input, identity)
    expect_identical(out$x$layout$shapes[[1]]$type, "path")
    expect_match(out$x$layout$annotations[[1]]$text, "1.050")
    expect_identical(out$x$layout$xaxis$title$text, "Expected -log10(p)")

    off <- .gwas_qq_layers(fig, 1000, 1.05, utils::modifyList(input, list(y.adj.fxn = "log10")), identity)
    expect_length(off$x$layout$shapes, 0)
})

test_that("the servers hand the scatter module prepared data and a fig.fn hook", {
    data(example_gwas, package = "sciVizModules")
    captured <- NULL
    local_mocked_bindings(
        dittoViz_scatterPlotServer = function(id, data, hide.inputs, hide.tabs, defaults, fig.fn) {
            captured <<- list(defaults = defaults, fig.fn = fig.fn, data = data)
        }
    )
    shiny::testServer(manhattanPlotServer, args = list(data = shiny::reactive(example_gwas)), expr = {
        session$setInputs(auto.update = TRUE, chr.col = "CHR", bp.col = "BP", p.col = "P", thin = TRUE, thin.p = 0.01,
            thin.fraction = 0.25)
        prepared <- captured$data()
        expect_true(all(c("manhattan.x", "manhattan.chr") %in% names(prepared)))
        expect_lt(nrow(prepared), nrow(example_gwas))
    })
    expect_true(is.function(captured$fig.fn))
    expect_identical(captured$defaults$x.by, "manhattan.x")
    expect_identical(captured$defaults$y.adj.fxn, "neg_log10")
    expect_false(captured$defaults$legend.show)
    # Two alternating colours, one per chromosome.
    expect_length(captured$defaults$color.panel, 22)
    expect_length(unique(captured$defaults$color.panel), 2)
    expect_false(any(.manhattan_keys %in% names(captured$defaults)))

    shiny::testServer(gwasQQPlotServer, args = list(data = shiny::reactive(example_gwas)), expr = {
        session$setInputs(auto.update = TRUE, p.col = "P", snp.col = "SNP", thin = FALSE)
        expect_identical(nrow(captured$data()), nrow(example_gwas))
    })
    expect_identical(captured$defaults$abline.slopes, "1")
})

test_that("a Manhattan plot builds end to end through the scatter module", {
    data(example_gwas, package = "sciVizModules")
    df <- .gwas_prepare(example_gwas, "CHR", "BP", "P")
    centres <- attr(df, "centres")
    built <- build_scatter_figure(df,
        fig.fn = function(fig, input, isolate_fn) .manhattan_layers(fig, centres, input, isolate_fn),
        inputs = test_scatter_inputs(x.by = "manhattan.x", y.by = "P", y.adj.fxn = "neg_log10",
            color.by = "manhattan.chr", p.col = "P", sig.threshold = 5e-8, suggestive.threshold = 1e-5,
            webgl = FALSE)
    )
    expect_identical(built$x$layout$xaxis$ticktext, names(centres))
    texts <- vapply(built$x$layout$annotations, function(a) as.character(a$text %||% ""), "")
    expect_true(all(c("Chromosome", "-log10(p)") %in% texts))
    expect_true(any(vapply(built$x$layout$shapes, function(s) isTRUE(all.equal(s$y0, -log10(5e-8))), logical(1))))
})

test_that("the UIs build from detected columns and explain missing ones", {
    data(example_gwas, package = "sciVizModules")
    expect_true(inherits(manhattanPlotInputsUI("m", example_gwas), c("shiny.tag", "shiny.tag.list")))
    expect_true(inherits(gwasQQPlotInputsUI("q", example_gwas), c("shiny.tag", "shiny.tag.list")))
    expect_error(manhattanPlotInputsUI("m", data.frame(a = 1, b = 2)), "Could not detect")
})
