# Tests for the five PCAtools modules. The plotted values are checked against
# PCAtools' own rules (and PCAtools itself, where it is installed) and against
# base R statistics; the figures and servers structurally.

pca_modules <- c("pcaBiplot", "pcaScreePlot", "pcaLoadingsPlot", "pcaPairsPlot", "pcaEigencorPlot")

test_that("every PCAtools module exports its InputsUI/OutputUI/Server/App and builds its UI", {
    data(example_pca, package = "sciVizModules")
    for (m in pca_modules) {
        for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
            expect_true(is.function(get0(paste0(m, suffix), envir = asNamespace("sciVizModules"))),
                info = paste0(m, suffix))
        }
        ui <- get(paste0(m, "InputsUI"))("test", example_pca)
        expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")), info = m)
        expect_error(get(paste0(m, "InputsUI"))("test", data.frame(a = 1)), "PCAtools", info = m)
    }
})

test_that("the scores table joins the scores to the metadata", {
    data(example_pca, package = "sciVizModules")
    df <- .pca_scores_df(example_pca)
    expect_identical(nrow(df), 8L)
    expect_identical(names(df)[1:3], c("sample", "PC1", "PC2"))
    expect_true(all(c("dex", "cell", "lib.size") %in% names(df)))
    expect_identical(.pca_axis_title(example_pca, "PC1"), sprintf("PC1 (%.1f%% variance)", example_pca$variance[[1]]))
    expect_identical(.pca_axis_title(example_pca, "dex"), "dex")
})

test_that("loading arrows take the top variables per axis, scaled into score space", {
    data(example_pca, package = "sciVizModules")
    ld <- example_pca$loadings
    a <- .pca_loading_arrows(example_pca, "PC1", "PC2", n = 3, length.factor = 1)
    top <- union(
        rownames(ld)[order(abs(ld$PC1), decreasing = TRUE)][1:3],
        rownames(ld)[order(abs(ld$PC2), decreasing = TRUE)][1:3]
    )
    expect_setequal(a$variable, top)

    sc <- example_pca$rotated
    r <- min(diff(range(sc$PC1)) / diff(range(ld$PC1)), diff(range(sc$PC2)) / diff(range(ld$PC2)))
    expect_equal(a$xend, ld[a$variable, "PC1"] * r)
    # Every arrow stays within the span of the scores.
    expect_true(all(abs(a$xend) <= max(abs(sc$PC1)) * 1.0001 | abs(a$yend) <= max(abs(sc$PC2)) * 1.0001))
})

test_that("the biplot layers title the axes with variance and draw arrows only on raw scores", {
    data(example_pca, package = "sciVizModules")
    # Built, as the scatter module's ggplotly() figure is, so the layout is populated.
    fig <- plotly::plotly_build(plotly::layout(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers"),
        xaxis = list(title = list(text = "PC1")), yaxis = list(title = list(text = "PC2"))))
    input <- list(x.by = "PC1", y.by = "PC2", show.loadings = TRUE, n.top.loadings = 2,
        loadings.length.factor = 1.5, loadings.color = "#FF0000", loadings.label.size = 10)

    out <- .pca_biplot_layers(fig, example_pca, input, identity)
    expect_match(out$x$layout$xaxis$title$text, "% variance")
    n_arrows <- nrow(.pca_loading_arrows(example_pca, "PC1", "PC2", n = 2))
    # One arrow and one label per variable.
    expect_length(out$x$layout$annotations, 2 * n_arrows)

    # An adjusted axis or a split leaves the figure alone.
    for (extra in list(list(x.adjustment = "z-score"), list(split.by = "cell"))) {
        same <- .pca_biplot_layers(fig, example_pca, utils::modifyList(input, extra), identity)
        expect_identical(same$x$layout$xaxis$title$text, "PC1")
        expect_length(same$x$layout$annotations, 0)
    }

    # Arrows off: titles only.
    off <- .pca_biplot_layers(fig, example_pca, utils::modifyList(input, list(show.loadings = FALSE)), identity)
    expect_length(off$x$layout$annotations, 0)
})

test_that("pcaBiplotServer hands the scatter module the scores and its fig.fn hook", {
    data(example_pca, package = "sciVizModules")
    captured <- NULL
    local_mocked_bindings(
        dittoViz_scatterPlotServer = function(id, data, hide.inputs, hide.tabs, defaults, fig.fn) {
            captured <<- list(data = shiny::isolate(data()), defaults = defaults, fig.fn = fig.fn,
                hide.tabs = hide.tabs)
        }
    )
    shiny::testServer(pcaBiplotServer, args = list(data = shiny::reactive(example_pca)), expr = {})
    expect_true(is.function(captured$fig.fn))
    expect_identical(captured$data$PC1, example_pca$rotated$PC1)
    expect_identical(captured$defaults$x.by, "PC1")
    expect_identical(captured$defaults$color.by, "dex")
    expect_false(any(.pca_biplot_keys %in% names(captured$defaults)))
    expect_identical(captured$hide.tabs, "Trajectory")
})

test_that("the scree plot shows variance and its cumulative sum, and marks the elbow", {
    data(example_pca, package = "sciVizModules")
    fig <- pcaScreePlot(example_pca, show.elbow = FALSE, mark.components = c(2, 4))
    tab <- attr(fig, "table")
    expect_equal(tab$cumulative, cumsum(unname(example_pca$variance)))
    expect_length(plotly::plotly_build(fig)$x$layout$shapes, 2)

    # Cumulative is over all components, not just the ones shown.
    sub <- attr(pcaScreePlot(example_pca, components = c("PC2", "PC3")), "table")
    expect_equal(sub$cumulative, cumsum(unname(example_pca$variance))[2:3])

    expect_identical(.pca_parse_components("PC2, 4 x 99", n = 8), c(2L, 4L))

    skip_if_not_installed("PCAtools")
    expect_identical(.pca_elbow(example_pca), as.integer(PCAtools::findElbowPoint(unname(example_pca$variance))))
    elbow <- plotly::plotly_build(pcaScreePlot(example_pca))
    expect_true(any(grepl("Elbow", vapply(elbow$x$layout$annotations, `[[`, "", "text"))))
})

test_that("the loadings plot keeps the variables PCAtools' rangeRetain rule keeps", {
    data(example_pca, package = "sciVizModules")
    comps <- c("PC1", "PC2", "PC3")
    tab <- attr(pcaLoadingsPlot(example_pca, components = comps, range.retain = 0.1), "table")

    ld <- example_pca$loadings[, comps]
    keep <- unique(unlist(lapply(ld, function(x) {
        off <- diff(range(x)) * 0.1
        c(which(x >= max(x) - off), which(x <= min(x) + off))
    })))
    expect_setequal(unique(tab$variable), rownames(ld)[keep])
    # Every retained variable is drawn on every component.
    expect_identical(nrow(tab), length(keep) * length(comps))

    abs_tab <- attr(pcaLoadingsPlot(example_pca, components = comps, absolute = TRUE), "table")
    expect_true(all(abs_tab$value >= 0))

    skip_if_not_installed("PCAtools")
    msgs <- character(0)
    withCallingHandlers(
        PCAtools::plotloadings(example_pca, components = comps, rangeRetain = 0.1),
        message = function(m) {
            msgs <<- c(msgs, conditionMessage(m))
            invokeRestart("muffleMessage")
        }
    )
    retained <- trimws(strsplit(msgs[grep("variables retained", msgs) + 1], ",")[[1]])
    expect_setequal(unique(tab$variable), retained)
})

test_that("the pairs plot draws one panel per component pair", {
    data(example_pca, package = "sciVizModules")
    fig <- plotly::plotly_build(pcaPairsPlot(example_pca, components = paste0("PC", 1:4), color.by = "dex"))
    # The group traces; the empty upper-triangle placeholders carry no legend group.
    scatter <- Filter(function(tr) !is.null(tr$legendgroup), fig$x$data)
    # 6 pairs x 2 treatment groups.
    expect_length(scatter, 12)
    # The placeholders are dropped, so the upper triangle draws no gridlines.
    expect_length(fig$x$data, 12)
    # One legend entry per group, not per panel.
    expect_identical(sum(vapply(scatter, function(tr) isTRUE(tr$showlegend), logical(1))), 2L)
    expect_match(fig$x$layout$xaxis$title$text, "^PC1 \\(")
    expect_error(pcaPairsPlot(example_pca, components = "PC1"), "at least two")
})

test_that("the correlation heatmap matches cor.test() and applies the p-value adjustment", {
    data(example_pca, package = "sciVizModules")
    tab <- attr(pcaEigencorPlot(example_pca, components = c("PC1", "PC2"), metavars = c("dex", "lib.size"),
        cor.method = "spearman", p.adjust.method = "BH"), "table")

    ct <- suppressWarnings(stats::cor.test(example_pca$metadata$lib.size, example_pca$rotated$PC2,
        method = "spearman"))
    row <- tab[tab$metavar == "lib.size" & tab$component == "PC2", ]
    expect_equal(row$r, unname(ct$estimate))
    expect_equal(row$p.value, ct$p.value)
    expect_equal(tab$p.adj, stats::p.adjust(tab$p.value, "BH"))
    # A factor is correlated through its integer codes, and labelled as such.
    expect_identical(tab$label[tab$metavar == "dex"][1], "dex (coded)")

    rsq <- plotly::plotly_build(pcaEigencorPlot(example_pca, plot.rsquared = TRUE))
    expect_identical(rsq$x$data[[1]]$zmin, 0)
})

test_that("a native module server builds, finishes and exports its plot", {
    data(example_pca, package = "sciVizModules")
    shiny::testServer(
        pcaScreePlotServer,
        args = list(data = shiny::reactive(example_pca)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, components = paste0("PC", 1:6), show.cumulative = TRUE,
                    show.elbow = FALSE, mark.components = "", bar.color = "#1E90FF",
                    line.color = "#CD2626", download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_false(built$x$layout$showlegend)
            expect_identical(nrow(plot_source_reactive()$stats), 6L)
        }
    )
    shiny::testServer(
        pcaEigencorPlotServer,
        args = list(data = shiny::reactive(example_pca)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, components = c("PC1", "PC2"), metavars = c("dex", "cell"),
                    cor.method = "pearson", p.adjust.method = "none", plot.rsquared = FALSE,
                    low.color = "#00008B", mid.color = "#FFFFFF", high.color = "#8B0000",
                    show.values = TRUE, digits = 2, download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            expect_identical(nrow(plot_source_reactive()$stats), 4L)
        }
    )
})

test_that("sample IDs and other wide metadata are not offered to colour or shape by", {
    p <- list(metadata = data.frame(
        sample = paste0("s", seq_len(60)),
        grp = rep(c("a", "b"), 30),
        flag = rep(c(TRUE, FALSE), 30),
        depth = seq_len(60),
        stringsAsFactors = FALSE
    ))
    expect_identical(.pca_metadata_cols(p, "discrete"), c("grp", "flag"))
    expect_identical(.pca_metadata_cols(p, "numeric"), "depth")
})
