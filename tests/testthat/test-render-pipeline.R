# The modules that build their own figure draw it in a cached step
# (VizModules::cached_structure()) and style it in a second one, so these tests
# hold each of them to that contract:
#   * a styling change restyles the figure without redrawing the plot;
#   * a structural change redraws it once, and going back is served from the cache;
#   * every reactive the draw step reads besides `input` redraws it when it changes,
#     since one the cache cannot see leaves a stale plot;
#   * with Auto Update off, nothing redraws until Update is pressed.

.ditto_case <- function(fn, inputs, structural, reactive_change = NULL) {
    data("example_sce", package = "sciVizModules", envir = environment())
    list(
        server = get(paste0(fn, "Server"), envir = asNamespace("sciVizModules")),
        data = example_sce, builder = fn, package = "dittoSeq",
        base = paste0("base_", fn), generate = paste0("generate_", fn),
        inputs = c(list(auto.update = TRUE, download.format = "png"), inputs, test_axes_inputs(), test_legend_inputs()),
        structural = structural, reactive_change = reactive_change
    )
}

.pipeline_cases <- function() {
    cases <- .all_pipeline_cases()
    # dittoSeq draws its hexes with hexbin, a Suggests.
    if (!requireNamespace("hexbin", quietly = TRUE)) cases$hex <- NULL
    cases
}

.all_pipeline_cases <- function() {
    data("example_cn_segment", package = "sciVizModules", envir = environment())
    data("example_methylation", package = "sciVizModules", envir = environment())
    data("mm_kinetics", package = "sciVizModules", envir = environment())
    data("mm_kinetics_line", package = "sciVizModules", envir = environment())
    data("survival_lung", package = "sciVizModules", envir = environment())
    groups <- function(...) list(palette.colours = stats::setNames(rep("#FF0000", length(c(...))), c(...)))
    celltypes <- groups("B cell", "Myeloid", "NK cell", "T cell")
    point_inputs <- list(
        size = 1, opacity = 1, order = "unordered", do.ellipse = FALSE, do.contour = FALSE,
        min.color = "#F0E442", max.color = "#0072B2", split.by = "", shape.by = ""
    )
    list(
        bar = .ditto_case("dittoBarPlot", list(
            var = "celltype", group.by = "condition", scale = "percent", split.by = "", split.nrow = NA,
            split.ncol = NA, x.labels.rotate = TRUE, retain.factor.levels = FALSE
        ), list(scale = "count"), celltypes),
        hex = .ditto_case("dittoDimHex", list(
            reduction.use = "UMAP", color.var = "", color.method = "", bins = 30, dim.1 = 1, dim.2 = 2, split.by = "",
            min.color = "#F0E442", max.color = "#0072B2", min.opacity = 0.2, max.opacity = 1, do.contour = FALSE,
            do.ellipse = FALSE
        ), list(bins = 20)),
        dim = .ditto_case("dittoDimPlot", c(
            list(var = "celltype", reduction.use = "UMAP", dim.1 = 1, dim.2 = 2), point_inputs
        ), list(size = 2), celltypes),
        freq = .ditto_case("dittoFreqPlot", list(
            var = "celltype", group.by = "condition", sample.by = "sample", color.by = "",
            plots = c("boxplot", "jitter"), scale = "percent", max.normalize = FALSE, jitter.size = 1,
            jitter.width = 0.2, jitter.color = "black", boxplot.width = 0.4, vlnplot.width = 1
        ), list(jitter.size = 2), groups("Control", "Treated")),
        ditto = .ditto_case("dittoPlot", list(
            var = "nCount", group.by = "celltype", color.by = "", split.by = "", plots = c("jitter", "vlnplot"),
            boxplot.lineweight = 1, boxplot.width = 0.4, jitter.color = "black", jitter.size = 1, jitter.width = 0.2,
            ridgeplot.lineweight = 1, ridgeplot.scale = 1.25, vlnplot.lineweight = 1, vlnplot.scaling = "area",
            vlnplot.width = 1
        ), list(jitter.size = 2), celltypes),
        ridge = .ditto_case("dittoRidgeJitter", list(
            var = "nCount", group.by = "celltype", color.by = "", split.by = "", jitter.color = "black",
            jitter.size = 1, jitter.width = 0.2, ridgeplot.bins = 30, ridgeplot.lineweight = 1,
            ridgeplot.scale = 1.25, ridgeplot.shape = "smooth"
        ), list(jitter.size = 2), celltypes),
        scatter = .ditto_case("dittoScatterPlot", c(
            list(x.var = "nCount", y.var = "percent.mito", color.var = "celltype"), point_inputs
        ), list(size = 2), celltypes),
        dot = .ditto_case("dittoDotPlot", list(
            vars = c("Gene32", "Gene20", "Gene1"), group.by = "celltype", split.by = "", scale = TRUE,
            vars.dir = "x", assay = "logcounts", summary.fxn.color = "nonzero.mean", min.color = "grey90",
            max.color = "#C51B7D", mid.color = "", size = 6, min.percent = 0.01, max.percent = NA,
            size.legend.x = 1.04, size.legend.y = 0.35
        ), list(size = 8)),
        forest = list(
            server = forestPlotServer, data = survival_lung, builder = "forestPlot", package = "sciVizModules",
            base = "base_forestPlot", generate = "generate_forestPlot",
            inputs = c(list(
                auto.update = TRUE, model = "cox", time = "time", status = "status", outcome = "status",
                covariates = c("age", "sex"), multivariable = TRUE, conf.level = 0.95, show.reference = TRUE,
                show.table = TRUE, sort.by = "input", digits = 2, point.color = "#000000", point.size = 10,
                ci.color = "#000000", ci.width = 2, download.format = "png"
            ), test_axes_inputs()),
            structural = list(digits = 3)
        ),
        mm = list(
            server = michaelisMentenServer, data = list(data = mm_kinetics, model = mm_kinetics_line),
            builder = "michaelisMentenPlot", package = "sciVizModules",
            base = "base_michaelisMentenPlot", generate = "generate_michaelisMentenPlot",
            inputs = c(list(
                auto.update = TRUE, x = "S", y = "v", jitter = TRUE, jitter_alpha = 1, jitter_color = "#000000",
                jitter_size = 1.5, line_color = "#FF0000", linetype = "solid", show_stats = FALSE,
                download.format = "png"
            ), test_axes_inputs()),
            structural = list(jitter_size = 3)
        ),
        cnseg = list(
            server = cnSegmentPlotServer, data = example_cn_segment, builder = "cnSegmentPlot",
            package = "sciVizModules", base = "base_cnSegmentPlot", generate = "generate_cnSegmentPlot",
            inputs = c(list(
                auto.update = TRUE, samples = character(0), to.plot = "", hover.text.cols = "signal",
                id.col = "", label.genes = "", main = "", point.size = 1, point.alpha = 0.5, color.low = "#0000FF",
                color.zero = "#FFFFFF", color.high = "#FF0000", color.limit.low = NA, color.limit.high = NA,
                color.seg = "#0000FF", seg.line.width = 1, centromere.color = "#B3B3B3", centromere.width = 0.3,
                centromere.linetype = "dashed", border.color = "#000000", border.width = 0.3,
                border.linetype = "solid", gene.line.color = "#666666", gene.line.width = 0.3,
                gene.line.linetype = "dotted", label.size = 10, free.y = FALSE, y.min = NA, y.max = NA,
                download.format = "png"
            ), test_axes_inputs()),
            structural = list(point.size = 2), debounced = list(main = "A title")
        ),
        methylation = list(
            server = methylationTrackServer, data = example_methylation, builder = ".meth_figure",
            package = "sciVizModules", base = "base_plot", generate = "generate_plot",
            inputs = c(list(
                auto.update = TRUE, locate.by = "gene", gene = "DNMT1", region = "", probes = "", upstream = 2000,
                downstream = 2000, cpg.scope = "all", max.cpgs = 1000, filter.col = "", sample.filter = "",
                group.by = "platform", group.gap = 1, cluster.samples = FALSE, dist.method = "euclidean",
                hclust.method = "ward.D2", show.dendrogram = TRUE, anno.left = "category",
                anno.low = "#DEEBF7", anno.high = "#08306B", show.sample.names = TRUE, sample.font.size = 10,
                txn.view = "full", txn.types = "protein_coding", txn.labels = TRUE, txn.font.size = 8,
                show.cytoband = TRUE, show.map.lines = TRUE, show.coverage = TRUE, cpg.labels = "none",
                colorscale.min = 0, colorscale.max = 1, colorbar.title = "Beta value", download.format = "png"
            ), test_axes_inputs(), test_legend_inputs()),
            structural = list(group.gap = 2),
            reactive_change = list(gene = "MLH1"),
            debounced = list(sample.filter = "platform == 'EPIC'")
        ),
        gofan = list(
            server = goFanPlotServer, data = data.frame(id = c("GO:1", "GO:2"), p = c(0.1, 0.2)),
            builder = "goFanPlot", package = "sciVizModules",
            # GOfan and an OrgDb are not what this tests, so the plot is a stand-in.
            fake = function(...) {
                list(...) # reads the inputs, as the real function does
                plotly::plot_ly(labels = c("a", "b"), parents = c("", "a"), type = "sunburst")
            },
            base = "base_goFanPlot", generate = "generate_goFanPlot",
            inputs = list(
                auto.update = TRUE, term.id = "id", fill = "p", org = "org.Hs.eg.db", palette = "Viridis",
                sub_rect = "", onto = "BP", go.annotation.level.cutoff = 4, filter.nodes.by.edge.number = 2,
                fill.na.by.0 = TRUE, download.format = "png", title.font.size = 20
            ),
            structural = list(onto = "CC"), no_axes = TRUE
        )
    )
}

# Run `code` in a testServer session for `case`, counting calls to its plot
# function. `code` sees `draws()`, `styled()`, `set()` and `session`.
.with_pipeline <- function(case, code) {
    draws <- 0
    real <- case$fake %||% get(case$builder, envir = asNamespace(case$package))
    mock <- list(function(...) {
        draws <<- draws + 1
        real(...)
    })
    names(mock) <- case$builder
    do.call(testthat::local_mocked_bindings, c(mock, list(.package = case$package, .env = environment())))

    code <- substitute(code)
    caller <- parent.frame()
    shiny::testServer(case$server, args = list(id = "m", data = shiny::reactive(case$data)), {
        env <- environment()
        styled <- function() suppressWarnings(get(case$generate, envir = env)())
        draws_so_far <- function() draws
        set <- function(...) {
            suppressWarnings(do.call(session$setInputs, c(...)))
            session$elapse(800) # lets a debounced text input through
        }
        set(case$inputs)
        eval(code, list(styled = styled, draws = draws_so_far, set = set, session = session), caller)
    })
}

test_that("a styling change restyles the figure without redrawing the plot", {
    cases <- .pipeline_cases()
    for (nm in names(cases)) {
        case <- cases[[nm]]
        .with_pipeline(case, {
            first <- plotly::plotly_build(styled())
            n <- draws()
            expect_gt(n, 0)
            set(list(title.font.size = 31, download.format = "svg", margin.t = 90))
            second <- plotly::plotly_build(styled())
            expect_equal(draws(), n, info = nm)
            expect_identical(second$x$data, first$x$data, info = nm)
            expect_false(identical(second$x$layout, first$x$layout), info = nm)

            if (!isTRUE(case$no_axes)) {
                set(list(
                    hline.intercepts = "1", axis.tickfont.size = 7, grid.color = "#ABCDEF", legend.text.size = 19,
                    legend.title.size = 21, legend.font.family = "Courier New", legend.font.color = "#FF0000"
                ))
                styled()
                expect_equal(draws(), n, info = nm)
            }
        })
    }
})

test_that("a structural change redraws the plot once, and going back is cached", {
    cases <- .pipeline_cases()
    for (nm in names(cases)) {
        case <- cases[[nm]]
        .with_pipeline(case, {
            styled()
            n <- draws()
            original <- case$inputs[names(case$structural)]
            set(case$structural)
            styled()
            expect_equal(draws(), n + 1, info = nm)

            set(original)
            styled()
            expect_equal(draws(), n + 1, info = nm)
        })
    }
})

test_that("every reactive a draw step reads redraws it", {
    cases <- .pipeline_cases()
    for (nm in names(cases)) {
        case <- cases[[nm]]
        change <- case$reactive_change %||% case$debounced
        # Colouring hexes by a column takes ggplot.multistats, a Suggests.
        if (nm == "hex" && requireNamespace("ggplot.multistats", quietly = TRUE)) {
            change <- list(color.method = "max", color.var = "nCount")
        }
        if (is.null(change)) next
        .with_pipeline(case, {
            styled()
            n <- draws()
            set(change)
            styled()
            expect_gt(draws(), n, label = nm)
        })
    }
})

test_that("methylationTrack redraws for each kind of typed input and for strip colours", {
    case <- .pipeline_cases()$methylation
    .with_pipeline(case, {
        styled()
        n <- draws()

        set(case$debounced)
        expect_identical(attr(styled(), "table")$samples$cell.type[1], factor("PrEC", levels(
            attr(styled(), "table")$samples$cell.type
        )))
        expect_gt(draws(), n)
        n <- draws()

        set(list(sample.filter = "", locate.by = "region", region = "chr3:36990000-37010000"))
        styled()
        expect_gt(draws(), n)
        n <- draws()

        set(list(locate.by = "probes", probes = names(case$data$arrays$EPIC$loci)[1]))
        styled()
        expect_gt(draws(), n)
        n <- draws()

        # The discrete strips are heatmaps of their own, so their colours are drawn.
        set(list(locate.by = "gene", anno.colors = c("category: Cell line" = "#123456")))
        styled()
        expect_gt(draws(), n)
    })
})

test_that("methylationTrack's colour scale and frame change without a redraw", {
    case <- .pipeline_cases()$methylation
    .with_pipeline(case, {
        first <- plotly::plotly_build(styled())
        n <- draws()

        set(list(
            colorscale.colors = c(Lowest = "#000000", Highest = "#FFFFFF"), colorscale.reverse = TRUE,
            colorscale.min = 0.2, colorbar.title = "New", absent.color = "#123456", na.color = "#654321",
            sample.font.size = 6, axis.linewidth = 3
        ))
        second <- plotly::plotly_build(styled())

        expect_equal(draws(), n)
        expect_identical(second$x$data, first$x$data)
        expect_identical(second$x$layout$coloraxis$cmin, 0.2)
        expect_identical(second$x$layout$coloraxis$colorscale[[1]][[2]], "#FFFFFF")
        expect_identical(second$x$layout$coloraxis$colorbar$title$text, "New")
        expect_identical(second$x$layout$coloraxis2$colorscale[[1]][[2]], "#123456")
        expect_identical(second$x$layout$yaxis$tickfont$size, 6)
    })
})

test_that("with Auto Update off, nothing redraws until Update is pressed", {
    cases <- .pipeline_cases()
    case <- cases$dim
    .with_pipeline(case, {
        styled()
        set(list(auto.update = FALSE, update = 0))
        styled()
        n <- draws()
        set(list(size = 3))
        styled()
        expect_equal(draws(), n)
        set(list(update = 1))
        styled()
        expect_equal(draws(), n + 1)
    })
})

# A minimal module on the shared server, counting its draws.
.shared_server <- function(id, data, counter) {
    .sci_plot_server(
        id, data, NULL, NULL, NULL,
        name = "shared", validate = .sci_require_df,
        setup = function(input, output, session, object, params) {
            list(marks = reactive(input$marks), label = "not a reactive")
        },
        build = function(df, input, isolate_fn, state) {
            counter$draws <- counter$draws + 1
            fig <- plotly::plot_ly(
                df, x = ~wt, y = ~mpg, type = "scatter", mode = "markers",
                marker = list(size = isolate_fn(input$point.size)), name = state$marks() %||% "none"
            )
            attr(fig, "table") <- df[1:2, 1:2]
            fig
        },
        reset = function(session, df, defaults, state) NULL
    )
}

test_that("the shared server draws once and names its state to the cache", {
    counter <- new.env()
    counter$draws <- 0
    shiny::testServer(.shared_server, args = list(id = "m", data = reactive(mtcars), counter = counter), {
        suppressWarnings(do.call(session$setInputs, c(
            list(auto.update = TRUE, point.size = 5, marks = "a", download.format = "png", title.font.size = 20),
            test_axes_inputs(), test_legend_inputs()
        )))
        first <- generate_plot()
        expect_equal(counter$draws, 1)
        expect_identical(attr(first, "table"), mtcars[1:2, 1:2])

        session$setInputs(title.font.size = 31)
        expect_identical(attr(generate_plot(), "table"), mtcars[1:2, 1:2])
        expect_equal(counter$draws, 1)

        session$setInputs(point.size = 7)
        generate_plot()
        expect_equal(counter$draws, 2)

        # A reactive in `state`, which is not an input of the draw step.
        session$setInputs(marks = "b")
        expect_identical(plotly::plotly_build(generate_plot())$x$data[[1]]$name, "b")
        expect_equal(counter$draws, 3)
    })
})

test_that("mutationLollipop redraws for a change to its reactive domains", {
    laml <- laml_df()
    domains <- shiny::reactiveVal(data.frame(Hugo_Symbol = "NPM1", Start = 1, End = 50, Label = "A"))
    draws <- 0
    real <- mutationLollipop
    local_mocked_bindings(mutationLollipop = function(...) {
        draws <<- draws + 1
        real(...)
    })
    shiny::testServer(mutationLollipopServer, args = list(
        id = "m", data = shiny::reactive(laml), domains = domains
    ), {
        suppressWarnings(do.call(session$setInputs, c(
            list(auto.update = TRUE, gene = "NPM1", label.top = 3, point.size = 10, show.domains = TRUE,
                download.format = "png"),
            test_axes_inputs(), test_legend_inputs()
        )))
        suppressWarnings(generate_plot())
        n <- draws
        domains(data.frame(Hugo_Symbol = "NPM1", Start = 1, End = 80, Label = "B"))
        session$flushReact()
        suppressWarnings(generate_plot())
        expect_equal(draws, n + 1)
    })
})

# ---- The render ---------------------------------------------------------------

# A stand-in for a module session, inside the render of output `mod-plot`,
# recording the custom messages sent.
.render_session <- function() {
    env <- new.env()
    env$messages <- list()
    env$getCurrentOutputInfo <- function() list(name = "mod-plot")
    env$sendCustomMessage <- function(type, message) {
        env$messages[[length(env$messages) + 1]] <- list(type = type, message = message)
    }
    env$ns <- function(id) paste0("mod-", id)
    env
}

.render_store <- function() {
    list(
        edits = shiny::reactiveValues(legend = NULL, annotations = list(), colorbar = NULL),
        rendered_fig = shiny::reactiveVal(NULL),
        sent = new.env(parent = emptyenv()),
        refresh = shiny::reactiveVal(0)
    )
}

.render_fig <- function(title = "A") {
    plotly::plot_ly(x = mtcars$wt, y = mtcars$mpg, type = "scatter", mode = "markers") |>
        plotly::layout(title = list(text = title))
}

.renderer <- function(session, store) {
    titles <- new.env(parent = emptyenv())
    function(generate, guard = NULL) {
        shiny::isolate(.sci_rendered_figure(generate, list(), "mod-src", store, session, guard, titles))
    }
}

test_that("a restyle goes out as a layout-only update", {
    session <- .render_session()
    render <- .renderer(session, .render_store())

    expect_s3_class(render(function() .render_fig("A")), "plotly")
    expect_length(session$messages, 0)

    expect_error(render(function() .render_fig("B")), class = "shiny.output.cancel")
    expect_length(session$messages, 1)
    expect_identical(session$messages[[1]]$type, "vizmodules-plotly-layout")
})

test_that("an error shows as a message plot, and the next figure goes out whole", {
    session <- .render_session()
    render <- .renderer(session, .render_store())
    render(function() .render_fig("A"))

    broken <- render(function() stop("no metadata"))
    expect_s3_class(broken, "plotly")
    expect_true(any(grepl("no metadata", unlist(plotly::plotly_build(broken)$x$data), fixed = TRUE)))

    expect_s3_class(render(function() .render_fig("A")), "plotly")
    expect_length(session$messages, 0)

    # A guard's error is shown the same way: a malformed `data`, say.
    expect_s3_class(render(function() .render_fig("A"), guard = function() stop("bad data")), "plotly")
})

test_that("a req() pause stays a pause rather than a blank plot", {
    render <- .renderer(.render_session(), .render_store())
    expect_error(render(function() shiny::req(FALSE)), class = "shiny.silent.error")
    expect_error(render(function() .render_fig(), guard = function() shiny::req(FALSE)), class = "shiny.silent.error")
})

test_that("a typed axis title lasts until its axis changes, and its position stays", {
    fig <- function(x, y = "Y") {
        out <- plotly::plot_ly()
        out$x$layout$annotations <- list(
            list(annotationType = "axis", text = x),
            list(annotationType = "axis", textangle = -90, text = y)
        )
        out
    }
    store <- .render_store()
    seen <- new.env(parent = emptyenv())
    shiny::isolate(store$edits$annotations <- list(
        "axis:x#1" = list(text = "Typed x", x = 0.4),
        "axis:y#1" = list(text = "Typed y", y = 0.4)
    ))
    edits <- function() shiny::isolate(store$edits$annotations)

    .sci_clear_stale_titles(fig("X"), store, seen)
    .sci_clear_stale_titles(fig("X"), store, seen)
    expect_identical(edits()[["axis:x#1"]]$text, "Typed x")

    # The error plot has no titles, so it says nothing about them.
    .sci_clear_stale_titles(plotly::plot_ly(), store, seen)
    expect_identical(edits()[["axis:x#1"]]$text, "Typed x")

    .sci_clear_stale_titles(fig("Another column"), store, seen)
    expect_null(edits()[["axis:x#1"]]$text)
    expect_identical(edits()[["axis:x#1"]]$x, 0.4)
    expect_identical(edits()[["axis:y#1"]]$text, "Typed y")
})

# ---- WebGL and legend sections ------------------------------------------------

.ditto_figure <- function(case, ...) {
    fig <- NULL
    .with_pipeline(case, {
        set(list(...))
        fig <<- plotly::plotly_build(styled())
    })
    fig
}

.types <- function(fig) vapply(fig$x$data, function(tr) tr$type %||% "scatter", character(1))
.modes <- function(fig) vapply(fig$x$data, function(tr) tr$mode %||% "", character(1))

test_that("dittoDimPlot keeps its overlays on top of WebGL points", {
    old <- options(VizModules.webgl.threshold = 10)
    on.exit(options(old))
    case <- .pipeline_cases()$dim

    fig <- .ditto_figure(case, do.ellipse = TRUE)
    expect_true(all(.types(fig)[.modes(fig) %in% c("markers", "lines")] == "scattergl"))
    expect_true("lines" %in% .modes(fig))

    expect_false("scattergl" %in% .types(.ditto_figure(case, do.ellipse = TRUE, webgl = FALSE)))
})

test_that("dittoPlot's points go to WebGL while its violins stay SVG", {
    old <- options(VizModules.webgl.threshold = 10)
    on.exit(options(old))
    fig <- .ditto_figure(.pipeline_cases()$ditto)
    expect_true(all(.types(fig)[.modes(fig) == "markers"] == "scattergl"))
    filled <- vapply(fig$x$data, function(tr) identical(tr$fill, "toself"), logical(1))
    expect_true(any(filled))
    expect_true(all(.types(fig)[filled] == "scatter"))
})

test_that("the example data stays SVG below the threshold", {
    expect_false("scattergl" %in% .types(.ditto_figure(.pipeline_cases()$dim)))
})

test_that("colour and shape get their own legend sections", {
    cases <- .pipeline_cases()
    for (nm in c("dim", "scatter")) {
        fig <- .ditto_figure(cases[[nm]], shape.by = "condition")
        entries <- Filter(function(tr) !isFALSE(tr$showlegend) && !is.null(tr$meta$vizmodules_legend), fig$x$data)
        names <- vapply(entries, function(tr) tr$name, character(1))
        expect_setequal(names, c("B cell", "Myeloid", "NK cell", "T cell", "Control", "Treated"))
        expect_false(any(grepl("^\\(", names)))
    }
})

test_that("a continuous colour with a shape keeps plotly's legend", {
    fig <- .ditto_figure(.pipeline_cases()$dim, var = "nCount", shape.by = "condition")
    expect_null(fig$x$data[[1]]$meta$vizmodules_legend)
})

# ---- dittoDimPlot's annotations -----------------------------------------------

.point_labels <- function(fig) Filter(function(a) !identical(a$annotationType, "axis"), fig$x$layout$annotations)
.annotated <- function(nm) {
    case <- .pipeline_cases()[[nm]]
    case$inputs <- c(case$inputs, test_annotation_inputs())
    case
}
.annotated_dim <- function() .annotated("dim")

test_that("a named cell is labelled where it is drawn, and restyled", {
    data("example_sce", package = "sciVizModules", envir = environment())
    fig <- .ditto_figure(.annotated_dim(), annotate.by = "cell.id", highlight.points = "Cell12, Cell97")

    labels <- .point_labels(fig)
    expect_setequal(vapply(labels, `[[`, "", "text"), c("Cell12", "Cell97"))
    umap <- SingleCellExperiment::reducedDim(example_sce, "UMAP")
    for (label in labels) {
        expect_equal(c(label$x, label$y), unname(umap[label$text, 1:2]), tolerance = 1e-6)
    }

    sizes <- unlist(lapply(fig$x$data, function(tr) if (identical(tr$mode, "markers")) tr$marker$size))
    expect_equal(sum(sizes == 7), 2)
})

test_that("a metadata value labels every cell holding it, and a value may hold a space", {
    data("example_sce", package = "sciVizModules", envir = environment())
    fig <- .ditto_figure(.annotated_dim(), annotate.by = "celltype", highlight.points = "T cell")
    expect_length(.point_labels(fig), sum(example_sce$celltype == "T cell"))
    expect_identical(unique(vapply(.point_labels(fig), `[[`, "", "text")), "T cell")
})

test_that("Auto-annotate off highlights without labelling, and unset leaves the plot alone", {
    case <- .annotated_dim()
    quiet <- .ditto_figure(case, annotate.by = "cell.id", highlight.points = "Cell12", highlight.auto.annotate = FALSE)
    expect_length(.point_labels(quiet), 0)
    expect_true(any(unlist(lapply(quiet$x$data, function(tr) tr$marker$size)) == 7))

    # No Annotate By: the highlight text means nothing, and no hover text is drawn for it.
    plain <- .ditto_figure(case, highlight.points = "Cell12")
    expect_length(.point_labels(plain), 0)
    expect_false(any(grepl("Cell12", unlist(lapply(plain$x$data, function(tr) tr$text)), fixed = TRUE)))
})

test_that("the highlight text and the annotation style redraw the plot", {
    for (nm in c("dim", "scatter", "ditto")) {
        .with_pipeline(.annotated(nm), {
            set(list(annotate.by = "cell.id"))
            styled()
            n <- draws()
            set(list(highlight.points = "Cell12"))
            styled()
            expect_equal(draws(), n + 1, info = nm)
            set(list(annotation.size = 14))
            styled()
            expect_equal(draws(), n + 2, info = nm)
        })
    }
})

test_that("dittoScatterPlot labels a named cell where it is drawn", {
    data("example_sce", package = "sciVizModules", envir = environment())
    fig <- .ditto_figure(.annotated("scatter"), annotate.by = "cell.id", highlight.points = "Cell203")
    labels <- .point_labels(fig)
    expect_length(labels, 1)
    expect_identical(labels[[1]]$text, "Cell203")
    expect_equal(
        c(labels[[1]]$x, labels[[1]]$y), c(example_sce$nCount[203], example_sce$percent.mito[203]),
        tolerance = 1e-6
    )
})

test_that("dittoPlot labels its jitter points, and has nothing to label without them", {
    data("example_sce", package = "sciVizModules", envir = environment())
    case <- .annotated("ditto")
    fig <- .ditto_figure(case, annotate.by = "cell.id", highlight.points = "Cell203")
    labels <- .point_labels(fig)
    expect_length(labels, 1)
    expect_identical(labels[[1]]$text, "Cell203")
    expect_equal(labels[[1]]$y, example_sce$nCount[203], tolerance = 1e-6)
    # On a point the module drew, whichever way it was jittered.
    points <- Filter(function(tr) identical(tr$mode, "markers"), fig$x$data)
    expect_true(any(vapply(points, function(tr) labels[[1]]$x %in% tr$x, logical(1))))

    for (plots in list(c("vlnplot", "boxplot"), c("ridgeplot", "jitter"))) {
        none <- .ditto_figure(case, plots = plots, annotate.by = "cell.id", highlight.points = "Cell203")
        expect_length(.point_labels(none), 0)
    }
})

test_that("cells picked on the plot are labelled until cleared or redrawn differently", {
    data("example_sce", package = "sciVizModules", envir = environment())
    shiny::testServer(dittoDimPlotServer, args = list(data = shiny::reactive(example_sce)), {
        selected_cells <- annotations$selected
        case <- .annotated_dim()
        suppressWarnings(do.call(session$setInputs, utils::modifyList(case$inputs, list(annotate.by = "celltype"))))
        pick <- data.frame(curveNumber = 0, pointNumber = 2, x = 0, y = 0)
        labels <- function() .point_labels(plotly::plotly_build(suppressWarnings(generate_dittoDimPlot())))

        selected_cells(pick)
        session$flushReact()
        expect_length(labels(), 1)

        session$setInputs(annotation.clear = 1)
        expect_length(labels(), 0)

        # plotly reports a pick by its place in its trace, which a new grouping moves.
        selected_cells(pick)
        session$flushReact()
        expect_length(labels(), 1)
        suppressWarnings(session$setInputs(var = "clustering"))
        expect_null(selected_cells())
        expect_length(labels(), 0)
    })
})

test_that("a selection goes when dittoScatterPlot or dittoPlot regroup their points", {
    data("example_sce", package = "sciVizModules", envir = environment())
    regroup <- list(scatter = list(color.var = "clustering"), ditto = list(group.by = "clustering"))
    for (nm in names(regroup)) {
        case <- .annotated(nm)
        shiny::testServer(case$server, args = list(data = shiny::reactive(example_sce)), {
            inputs <- utils::modifyList(case$inputs, list(annotate.by = "cell.id"))
            suppressWarnings(do.call(session$setInputs, inputs))
            annotations$selected(data.frame(curveNumber = 0, pointNumber = 2, x = 0, y = 0))
            session$flushReact()
            figure <- get(case$generate)
            expect_length(.point_labels(plotly::plotly_build(suppressWarnings(figure()))), 1)
            suppressWarnings(do.call(session$setInputs, regroup[[nm]]))
            expect_null(annotations$selected())
        })
    }
})

test_that("the cell names are offered, and an object's own cell.id column is kept", {
    data("example_sce", package = "sciVizModules", envir = environment())
    expect_true(all(c("", "cell.id", "celltype") %in% .ditto_annotation_choices(example_sce)))
    expect_identical(.ditto_with_cell_ids(example_sce)$cell.id, colnames(example_sce))

    own <- example_sce
    own$cell.id <- rev(colnames(own))
    expect_identical(.ditto_with_cell_ids(own)$cell.id, own$cell.id)
    expect_equal(sum(.ditto_annotation_choices(own) == "cell.id"), 1)
})

test_that("the dead group-label inputs are gone, and the point plots have an Annotations tab", {
    data("example_sce", package = "sciVizModules", envir = environment())
    html <- function(fn) as.character(fn("m", example_sce))
    for (fn in list(dittoDimPlotInputsUI, dittoScatterPlotInputsUI, dittoDimHexInputsUI)) {
        expect_no_match(html(fn), "do.label|labels.size")
    }
    for (fn in list(dittoDimPlotInputsUI, dittoScatterPlotInputsUI, dittoPlotInputsUI)) {
        expect_match(html(fn), 'id="m-annotate.by"', fixed = TRUE)
    }
})
