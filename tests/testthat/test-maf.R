# Tests for the somatic-mutation modules (oncoPlot, mafSummary,
# mutationLollipop) and the MAF helpers they share. The summaries are computed
# in-package and tested equal to maftools' where it is installed.

laml_maf <- function() {
    # Read the gzipped MAF here: maftools' own reader needs R.utils for a .gz,
    # which is not declared here and so is masked under R CMD check.
    maf <- utils::read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
        comment.char = "#", stringsAsFactors = FALSE)
    suppressMessages(maftools::read.maf(maf,
        clinicalData = system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"),
        verbose = FALSE
    ))
}

test_that(".maf_table() reads a MAF data frame and keeps maftools' non-synonymous set", {
    laml <- laml_df()
    m <- .maf_table(laml)
    expect_s3_class(m, "sci_maf")
    expect_identical(sum(m$data$nonsyn), 1732L)
    expect_length(m$samples, 193)
    expect_identical(names(m$clinical), c("Tumor_Sample_Barcode", "FAB_classification", "days_to_last_followup",
        "Overall_Survival_Status"))
    expect_identical(.maf_track_cols(m), c("FAB_classification", "days_to_last_followup", "Overall_Survival_Status"))

    # Factor columns (as a data table returns them) and odd column case are fine.
    f <- laml
    f$Hugo_Symbol <- factor(f$Hugo_Symbol)
    names(f)[names(f) == "End_Position"] <- "End_position"
    expect_identical(.maf_table(f)$data$Hugo_Symbol, laml$Hugo_Symbol)
    expect_error(.maf_table(laml[, -1]), "Hugo_Symbol")
    expect_error(.maf_validate(laml[laml$Variant_Classification == "Silent", ]), "no non-synonymous")
})

test_that("the summaries equal maftools' on the LAML cohort", {
    skip_if_not_installed("maftools")
    laml <- laml_maf()
    m <- .maf_table(laml)
    expect_identical(sum(m$data$nonsyn), nrow(laml@data))
    expect_length(m$samples, 193)

    gs <- .maf_gene_summary(m)
    ref <- as.data.frame(maftools::getGeneSummary(laml))
    expect_identical(utils::head(gs$Hugo_Symbol, 20), utils::head(ref$Hugo_Symbol, 20))
    mg <- merge(gs, ref, by = "Hugo_Symbol")
    expect_identical(nrow(mg), nrow(ref))
    expect_true(all(mg$total.x == mg$total.y))
    expect_true(all(mg$MutatedSamples.x == mg$MutatedSamples.y))

    ss <- .maf_sample_summary(m)
    rs <- as.data.frame(maftools::getSampleSummary(laml))
    ms <- merge(ss, rs, by = "Tumor_Sample_Barcode")
    expect_identical(nrow(ms), 193L)
    expect_true(all(ms$total.x == ms$total.y))

    tt <- .maf_titv(m, use.syn = TRUE)
    rt <- as.data.frame(maftools::titv(laml, useSyn = TRUE, plot = FALSE)$raw.counts)
    mt <- merge(tt, rt, by = "Tumor_Sample_Barcode")
    expect_identical(nrow(mt), nrow(rt))
    for (cl in c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G")) {
        expect_true(all(mt[[paste0(cl, ".x")]] == mt[[paste0(cl, ".y")]]), info = cl)
    }
})

test_that("the oncoplot matrix matches maftools' createOncoMatrix()", {
    skip_if_not_installed("maftools")
    laml <- laml_maf()
    om <- .maf_onco_matrix(.maf_table(laml), top.n = 10, include.unmutated = FALSE)
    ref <- maftools:::createOncoMatrix(laml, g = rownames(om$classes))
    expect_identical(rownames(om$classes), rownames(ref$oncoMatrix))
    expect_identical(colnames(om$classes), colnames(ref$oncoMatrix))
    expect_identical(unname(om$classes), unname(ref$oncoMatrix))
})

test_that("the waterfall sort and Multi_Hit are computed without maftools", {
    d <- data.frame(
        Hugo_Symbol = c("A", "A", "A", "B", "B", "C"),
        Tumor_Sample_Barcode = c("s1", "s2", "s2", "s3", "s1", "s4"),
        Variant_Classification = c("Missense_Mutation", "Nonsense_Mutation", "Missense_Mutation",
            "Frame_Shift_Del", "Missense_Mutation", "Silent"),
        Protein_Change = c("p.R1H", "p.Q2*", "p.R5C", "p.K9fs", "p.G3V", "p.L1L"),
        stringsAsFactors = FALSE
    )
    om <- .maf_onco_matrix(.maf_table(d))
    expect_identical(rownames(om$classes), c("A", "B"))
    expect_identical(colnames(om$classes), c("s1", "s2", "s3", "s4"))
    expect_identical(om$classes["A", "s2"], "Multi_Hit")
    expect_identical(om$changes["A", "s2"], "p.Q2*, p.R5C")
    expect_identical(colnames(.maf_onco_matrix(.maf_table(d), include.unmutated = FALSE)$classes), c("s1", "s2", "s3"))
})

test_that("protein positions are read as maftools reads them", {
    expect_identical(
        .maf_protein_position(c("p.R882H", "p.KIM2014fs", "p.R7*", "p.-920fs", "", NA, "p.Arg882His", "p.X123_splice")),
        c(882, 2014, 7, 920, NA, NA, 882, 123)
    )
    expect_identical(.maf_snv_class(c("C", "G", "A", "T", "C", "AT"), c("T", "A", "G", "G", "C", "A")),
        c("C>T", "C>T", "T>C", "T>G", NA, NA))
})

test_that("maftools' domain table gives a protein's length and domains", {
    skip_if_not_installed("maftools")
    dm <- .maf_domains("DNMT3A")
    expect_identical(dm$refseq, "NM_022552")
    expect_identical(dm$length, 912)
    expect_true(nrow(dm$domains) >= 1)
    expect_null(.maf_domains("NOT_A_GENE"))
})

test_that("oncoPlot() draws the grid, the bars and the tracks", {
    laml <- laml_df()
    fig <- oncoPlot(laml, top.n = 8, clinical.tracks = c("FAB_classification", "days_to_last_followup"))
    b <- suppressWarnings(plotly::plotly_build(fig))
    types <- vapply(b$x$data, function(t) t$type %||% "", "")
    expect_identical(sum(types == "heatmap"), 3L)
    expect_true(sum(types == "bar") > 0)
    expect_identical(attr(fig, "table")$gene[1:2], c("FLT3", "DNMT3A"))
    expect_true(any(vapply(b$x$data, function(t) identical(t$name, "Multi Hit"), logical(1))))

    # Without the bars only the grid is left.
    bare <- suppressWarnings(plotly::plotly_build(oncoPlot(laml, genes = c("TP53", "NPM1"), show.tmb = FALSE,
        show.gene.bar = FALSE)))
    expect_identical(sum(vapply(bare$x$data, function(t) identical(t$type, "bar"), logical(1))), 0L)
    expect_identical(attr(oncoPlot(laml, genes = c("TP53", "NPM1")), "table")$gene, c("NPM1", "TP53"))
})

test_that("mafSummary() draws the chosen panels", {
    laml <- laml_df()
    fig <- mafSummary(laml)
    b <- suppressWarnings(plotly::plotly_build(fig))
    titles <- vapply(b$x$layout$annotations, function(a) a$text, "")
    expect_identical(titles, paste0("<b>", names(.mafsum_panels), "</b>"))
    expect_identical(nrow(attr(fig, "table")), 193L)

    two <- suppressWarnings(plotly::plotly_build(mafSummary(laml, panels = c("genes", "type"))))
    expect_length(two$x$layout$annotations, 2)
    noalleles <- laml[, setdiff(names(laml), "Reference_Allele")]
    expect_error(mafSummary(noalleles, panels = "snv"), "No summary panel")
})

test_that("mutationLollipop() places mutations along the protein", {
    laml <- laml_df()
    fig <- mutationLollipop(laml, gene = "DNMT3A", domains = data.frame(Start = 1, End = 100, Label = "D"),
        protein.length = 912)
    tab <- attr(fig, "table")
    expect_true(all(c("pos", "change", "class", "count") %in% names(tab)))
    expect_identical(tab$count[tab$pos == 882 & tab$change == "R882H"], 19L)
    b <- plotly::plotly_build(fig)
    expect_identical(b$x$layout$xaxis$range[2], 912 * 1.01)
    expect_error(mutationLollipop(laml, gene = "NOTAGENE"), "no non-synonymous")
    expect_error(mutationLollipop(laml[, setdiff(names(laml), "Protein_Change")]), "protein-change")
})

test_that("the mutation module servers build, finish and export their plots", {
    laml <- laml_df()
    own <- list(
        oncoPlot = list(genes = character(0), top.n = 10, clinical.tracks = "FAB_classification",
            sort.samples = TRUE, include.unmutated = TRUE, show.tmb = TRUE, show.gene.bar = TRUE,
            show.sample.names = FALSE, background.color = "#ECF0F1"),
        mafSummary = list(panels = c("classification", "genes"), top.n = 8, show.median = TRUE),
        mutationLollipop = list(gene = "NPM1", label.top = 2, show.domains = TRUE, point.size = 9)
    )
    for (mod in names(own)) {
        expect_true(inherits(get(paste0(mod, "InputsUI"))("x", laml), "shiny.tag.list"), info = mod)
        shiny::testServer(get(paste0(mod, "Server")), args = list(data = shiny::reactive(laml)), expr = {
            do.call(session$setInputs, c(list(auto.update = TRUE, download.format = "png"), own[[mod]],
                test_axes_inputs(), test_legend_inputs()))
            built <- suppressWarnings(plotly::plotly_build(generate_plot()))
            expect_false(built$x$layout$showlegend)
            expect_false(is.null(plot_source_reactive()$stats))
        })
    }
})

test_that("the oncoplot module starts without gridlines, and on maftools' colours", {
    d <- .onco_style_defaults(list(show.grid.y = TRUE))
    expect_false(d$show.grid.x)
    expect_true(d$show.grid.y)
    cols <- .maf_color_defaults(list(palette.colours = c(Missense_Mutation = "#123456")))$palette.colours
    expect_identical(cols[["Missense_Mutation"]], "#123456")
    expect_identical(cols[["Nonsense_Mutation"]], "#E31A1C")
})
