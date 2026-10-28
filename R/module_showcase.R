# The example datasets and the "showcase" settings each module opens on.
#
# One registry feeds the module gallery (sciModuleGalleryApp()), the Figure
# Builder (sci_figure_builder_registry()) and every module's *App(), so a module
# opens on the same figure wherever it is demonstrated. The defaults go beyond
# picking columns: they switch on the features a module is worth reaching for
# (highlighted genes and variants, risk tables, trajectories, terminal fits,
# annotation tracks, splits). tests/testthat/test-showcase.R checks that every
# module has an entry and that every default is one its controls accept.
#
# Adding a module to the package means adding its entry here; the gallery, the
# Figure Builder and the module's *App() then all pick it up.


#' The example-data catalogue
#'
#' Each entry loads one example dataset on demand, so an `*App()` reads only
#' the data it opens on. `needs` names the Suggests packages a dataset is read
#' from, and `label` is the name an `*App()`'s dataset selector shows.
#'
#' @return A named list of `list(load =, needs =, label =)` entries.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_example_catalogue
#' @keywords internal
.sci_example_catalogue <- function() {
    bundled <- function(name) list(load = function() .sci_example_data(name), needs = character(0), label = name)
    entry <- function(load, needs = character(0), label) list(load = load, needs = needs, label = label)

    list(
        airway_deseq2 = bundled("airway_deseq2"),
        airway_edger = bundled("airway_edger"),
        airway_voom = bundled("airway_voom"),
        example_enrichment = bundled("example_enrichment"),
        survival_lung = bundled("survival_lung"),
        dose_response = bundled("dose_response"),
        example_gwas = bundled("example_gwas"),
        example_biomarkers = bundled("example_biomarkers"),
        example_plate = bundled("example_plate"),
        example_sbs96 = bundled("example_sbs96"),
        example_sce = bundled("example_sce"),
        example_cn_segment = bundled("example_cn_segment"),
        example_pca = bundled("example_pca"),
        example_gsea = bundled("example_gsea"),
        example_mageck = entry(function() .crispr_example("rra"), label = "example_mageck"),
        example_mageck_mle = entry(function() .crispr_example("mle"), label = "example_mageck_mle"),
        theoph = entry(.pk_example, label = "Theoph"),
        md_trajectory = entry(function() .md_example()$trajectory, label = "RMSD and Rg (simulated)"),
        md_rmsf = entry(function() .md_example()$rmsf, label = "RMSF (simulated)"),
        tcga_laml = entry(.maf_example, needs = "maftools", label = "TCGA LAML (maftools)"),
        airway = entry(.se_example, needs = "airway", label = "airway"),
        airway_de = entry(function() {
            list(object = .se_example(), results = .sci_example_data("airway_deseq2"))
        }, needs = "airway", label = "airway (DESeq2)"),
        mm_kinetics = entry(function() {
            list(
                data = .sci_example_data("mm_kinetics"),
                model = .sci_example_data("mm_kinetics_line"),
                stats = .sci_example_data("mm_kinetics_fit")
            )
        }, label = "mm_kinetics"),
        example_alphafold = entry(.af_example, label = "TP53 (P04637)"),
        example_structure = entry(.structure_example, label = "TP53 (P04637, AlphaFold)")
    )
}


#' Load one example dataset from the catalogue
#'
#' @param name A key of [.sci_example_catalogue()].
#' @return The dataset: a data frame, or the object or bundle its module takes.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_example_dataset
#' @keywords internal
.sci_example_dataset <- function(name) {
    entry <- .sci_example_catalogue()[[name]]
    if (is.null(entry)) {
        stop("No example dataset named '", name, "'.", call. = FALSE)
    }
    missing <- .sci_missing_packages(entry$needs)
    if (length(missing)) {
        stop(
            "The example dataset '", name, "' is read from ", paste(missing, collapse = ", "),
            ": BiocManager::install(c(", paste0("'", missing, "'", collapse = ", "), ")).",
            call. = FALSE
        )
    }
    entry$load()
}


#' Packages among those given that are not installed
#'
#' @param pkgs Package names.
#' @return The ones [requireNamespace()] cannot load.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_missing_packages
#' @keywords internal
.sci_missing_packages <- function(pkgs) {
    pkgs <- unique(as.character(pkgs))
    pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
}


# The gallery's menus, in navbar order. Every showcase entry's `group` is one.
.sci_gallery_groups <- c(
    "Expression", "Enrichment", "Single-cell", "PCA", "Genomics",
    "Mutations", "Clinical", "Pharmacology", "Structure"
)


#' Build one showcase entry
#'
#' Looks the module's `*InputsUI()`, `*OutputUI()` and `*Server()` up by name,
#' so an entry cannot name one module and wire another.
#'
#' @param module The module's base name, e.g. `"volcanoPlot"`.
#' @param label The module's name in the Figure Builder's picker and on its
#'   gallery card.
#' @param tab_label The shorter name on its gallery tab.
#' @param group The gallery menu it sits under, one of `.sci_gallery_groups`.
#' @param description One line for its gallery card and tab.
#' @param dataset The [.sci_example_catalogue()] key its `defaults` are written for.
#' @param kind `"df"` for a data frame fed through a filterable data table, or
#'   `"object"` for an object shown in a read-only preview.
#' @param defaults The input defaults it opens on.
#' @param needs Suggests packages the module needs beyond its dataset's.
#' @param preview For `"object"` entries, a function returning the data frame
#'   the gallery previews.
#' @param ui_data Optional function returning what `*InputsUI()` is given from
#'   the dataset, when that differs from what the server takes.
#' @param app_datasets Further catalogue keys its `*App()` also offers.
#' @param figure_builder Whether it is offered by the Figure Builder.
#' @return A showcase entry.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_showcase_entry
#' @keywords internal
.sci_showcase_entry <- function(module, label, tab_label, group, description, dataset,
                                kind = c("df", "object"), defaults = list(), needs = character(0),
                                preview = NULL, ui_data = NULL, app_datasets = NULL,
                                figure_builder = FALSE) {
    kind <- match.arg(kind)
    fn <- function(suffix) get(paste0(module, suffix), mode = "function")
    list(
        module = module,
        label = label,
        tab_label = tab_label,
        group = group,
        description = description,
        dataset = dataset,
        kind = kind,
        inputs_ui = fn("InputsUI"),
        output_ui = fn("OutputUI"),
        server_fn = fn("Server"),
        defaults = defaults,
        needs = needs,
        preview = preview,
        ui_data = ui_data,
        app_datasets = app_datasets,
        figure_builder = figure_builder
    )
}


#' The showcase registry: each module, its example dataset, and its defaults
#'
#' @details
#' One entry per module in the package, whatever is installed; see
#' [.sci_showcase_entry()] for the fields. Entries whose packages are missing
#' ([.sci_showcase_missing()]) are left out of the gallery and the Figure
#' Builder when those are built, so the registry itself stays complete and
#' `tests/testthat/test-showcase.R` can check it against the package's modules.
#'
#' @return A named list of entries, keyed by module id.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_module_showcase
#' @keywords internal
.sci_module_showcase <- function() {
    heatmap <- .heatmap_pkgs
    entry <- .sci_showcase_entry
    # The four cell types' most specific genes in example_sce, two each, in
    # the order of its celltype levels (B cell, Myeloid, NK cell, T cell).
    markers <- c("Gene34", "Gene39", "Gene22", "Gene19", "Gene14", "Gene15", "Gene35", "Gene31")
    # Well-known dexamethasone-responsive genes, all among airway's strongest hits.
    dex_genes <- "SPARCL1, PER1, DUSP1, ZBTB16, FKBP5, KLF15"
    gwas_leads <- "rs102919, rs110059"

    list(
        # ---- Expression ----------------------------------------------------
        volcano = entry(
            "volcanoPlot", "Volcano Plot", "Volcano", "Expression",
            "Effect size against significance, with thresholds and dexamethasone-responsive genes labelled.",
            "airway_deseq2", "df",
            defaults = list(sig.thresh = 0.05, fc.thresh = 1, annotate.by = "symbol", highlight.points = dex_genes),
            figure_builder = TRUE
        ),
        ma = entry(
            "maPlot", "MA Plot", "MA", "Expression",
            "Fold change against mean expression, with dexamethasone-responsive genes labelled.",
            "airway_deseq2", "df",
            defaults = list(sig.thresh = 0.05, fc.thresh = 1, annotate.by = "symbol", highlight.points = dex_genes),
            figure_builder = TRUE
        ),
        samplepca = entry(
            "samplePCA", "Sample PCA", "Sample PCA", "Expression",
            "Principal components of an experiment's counts, with an arrow from untreated to treated samples.",
            "airway", "object",
            defaults = list(
                color.by = "dex",
                trajectory.group.by = "dex", add.trajectory.by.groups = list(c("untrt", "trt"))
            ),
            preview = .se_coldata
        ),
        sampledist = entry(
            "sampleDistanceHeatmap", "Sample Distance Heatmap", "Sample Distance", "Expression",
            "Correlations between samples, annotated by cell line and treatment and split by treatment.",
            "airway", "object",
            defaults = list(sd.method = "pearson", column_split_by = "Annotation", column_split_cols = "dex"),
            needs = heatmap, preview = .se_coldata
        ),
        deheatmap = entry(
            "deHeatmap", "DE Heatmap", "DE Heatmap", "Expression",
            "The top differentially expressed genes, scaled by row, split by direction and by treatment.",
            "airway_de", "object",
            defaults = list(de.top.n = 40, column_split_by = "Annotation", column_split_cols = "dex"),
            needs = heatmap, preview = .de_preview
        ),

        # ---- Enrichment ----------------------------------------------------
        enrichment = entry(
            "enrichmentDotPlot", "Enrichment Dot Plot", "Enrichment Dot", "Enrichment",
            "Enriched terms per cluster, sized by gene count and coloured by adjusted p-value.",
            "example_enrichment", "df",
            defaults = list(x.data = "Cluster", y.data = "Description", size.by = "Count", fill.by = "p.adjust"),
            figure_builder = TRUE
        ),
        gofan = entry(
            "goFanPlot", "GO Sunburst", "GO Sunburst", "Enrichment",
            "Enriched GO terms in their place in the GO hierarchy, coloured by adjusted p-value.",
            "example_enrichment", "df",
            defaults = list(fill = "p.adjust", sub_rect = "Count"),
            needs = c("GOfan", "org.Hs.eg.db"), figure_builder = TRUE
        ),
        gsea = entry(
            "gseaEnrichmentPlot", "GSEA Enrichment Plot", "GSEA", "Enrichment",
            "Running enrichment scores of the top gene sets along the ranked gene list.",
            "example_gsea", "object",
            preview = .gsea_preview
        ),

        # ---- Single-cell ---------------------------------------------------
        dimplot = entry(
            "dittoDimPlot", "Dimensionality Reduction Plot", "DimPlot", "Single-cell",
            "Cells on a UMAP embedding coloured and labelled by cell type, split by condition.",
            "example_sce", "object",
            defaults = list(reduction.use = "UMAP", var = "celltype", do.label = TRUE, split.by = "condition"),
            preview = .ditto_preview
        ),
        dimhex = entry(
            "dittoDimHex", "Hexbin Reduction Plot", "DimHex", "Single-cell",
            "Cell density on a UMAP embedding in hexagonal bins, with density contours, split by condition.",
            "example_sce", "object",
            defaults = list(reduction.use = "UMAP", do.contour = TRUE, split.by = "condition"),
            preview = .ditto_preview
        ),
        scatter = entry(
            "dittoScatterPlot", "Cell Scatter Plot", "Scatter", "Single-cell",
            "Per-cell QC metrics against each other, coloured by cell type with an ellipse around each.",
            "example_sce", "object",
            defaults = list(color.var = "celltype", do.ellipse = TRUE),
            preview = .ditto_preview
        ),
        dittoplot = entry(
            "dittoPlot", "Expression Distribution Plot", "dittoPlot", "Single-cell",
            "A B-cell marker's expression per cell type as violins, boxes and points.",
            "example_sce", "object",
            defaults = list(var = "Gene34", group.by = "celltype", plots = c("vlnplot", "boxplot", "jitter")),
            preview = .ditto_preview
        ),
        dotplot = entry(
            "dittoDotPlot", "Marker Dot Plot", "Dot Plot", "Single-cell",
            "Two marker genes per cell type, sized by detection rate and coloured by scaled expression.",
            "example_sce", "object",
            defaults = list(vars = markers, group.by = "celltype"),
            preview = .ditto_preview
        ),
        dittoheatmap = entry(
            "dittoHeatmap", "Expression Heatmap", "Heatmap", "Single-cell",
            "Marker gene expression per cell, scaled by gene, ordered by cell type, with cell type and condition.",
            "example_sce", "object",
            defaults = list(
                dh.genes = markers, dh.order.by = "celltype", annot.by = c("celltype", "condition"),
                scale = "Rows", cluster_columns = FALSE
            ),
            needs = heatmap, preview = .ditto_preview
        ),
        ridge = entry(
            "dittoRidgeJitter", "Ridge + Jitter Plot", "Ridge + Jitter", "Single-cell",
            "A myeloid marker's expression per cell type as ridges over the individual cells.",
            "example_sce", "object",
            defaults = list(var = "Gene22", group.by = "celltype"),
            preview = .ditto_preview
        ),
        barplot = entry(
            "dittoBarPlot", "Composition Bar Plot", "Composition Bar", "Single-cell",
            "The cell-type composition of each sample.",
            "example_sce", "object",
            defaults = list(var = "celltype", group.by = "sample"),
            preview = .ditto_preview
        ),
        freq = entry(
            "dittoFreqPlot", "Cell Frequency Plot", "Frequency", "Single-cell",
            "Each cell type's frequency per sample, compared between conditions.",
            "example_sce", "object",
            defaults = list(var = "celltype", sample.by = "sample", group.by = "condition", color.by = "condition"),
            preview = .ditto_preview
        ),

        # ---- PCA -----------------------------------------------------------
        pcabiplot = entry(
            "pcaBiplot", "PCA Biplot", "Biplot", "PCA",
            "Samples on two components coloured by treatment, with the top gene loadings drawn as arrows.",
            "example_pca", "object",
            defaults = list(color.by = "dex", show.loadings = TRUE, n.top.loadings = 3),
            preview = .pca_preview
        ),
        pcascree = entry(
            "pcaScreePlot", "PCA Scree Plot", "Scree", "PCA",
            "Variance explained by each component, with the cumulative curve and the elbow marked.",
            "example_pca", "object",
            defaults = list(components = paste0("PC", 1:8)),
            preview = .pca_preview
        ),
        pcaloadings = entry(
            "pcaLoadingsPlot", "PCA Loadings Plot", "Loadings", "PCA",
            "The genes loading most strongly on each of the first components.",
            "example_pca", "object",
            preview = .pca_preview
        ),
        pcapairs = entry(
            "pcaPairsPlot", "PCA Pairs Plot", "Pairs", "PCA",
            "Every pair of the first four components, samples coloured by treatment.",
            "example_pca", "object",
            preview = .pca_preview
        ),
        pcaeigencor = entry(
            "pcaEigencorPlot", "PC-Metadata Correlation Plot", "PC Correlation", "PCA",
            "Correlations between each component and the sample metadata.",
            "example_pca", "object",
            preview = .pca_preview
        ),

        # ---- Genomics ------------------------------------------------------
        manhattan = entry(
            "manhattanPlot", "Manhattan Plot", "Manhattan", "Genomics",
            "Association p-values along the genome, with significance lines and the lead variants labelled.",
            "example_gwas", "df",
            defaults = list(highlight.points = gwas_leads)
        ),
        gwasqq = entry(
            "gwasQQPlot", "GWAS QQ Plot", "GWAS QQ", "Genomics",
            "Observed against expected p-values, with the null band, inflation factor and lead variants labelled.",
            "example_gwas", "df",
            defaults = list(highlight.points = gwas_leads)
        ),
        crispr = entry(
            "crisprScreenRank", "CRISPR Screen Rank Plot", "CRISPR Screen", "Genomics",
            "Genes ranked by MAGeCK FDR, with FDR cut-offs and the strongest depleted and enriched genes labelled.",
            "example_mageck", "df",
            defaults = list(metric = "fdr", highlight.points = "PLK1, KEAP1"),
            app_datasets = "example_mageck_mle"
        ),
        cnseg = entry(
            "cnSegmentPlot", "Copy Number Segments", "Copy Number", "Genomics",
            "Array copy-number segments and bin signals along the genome, with cancer genes marked.",
            "example_cn_segment", "object",
            preview = .cn_preview
        ),

        # ---- Mutations -----------------------------------------------------
        oncoplot = entry(
            "oncoPlot", "Oncoplot", "Oncoplot", "Mutations",
            "The most frequently mutated genes across tumours, with mutation burden and the FAB subtype as a track.",
            "tcga_laml", "df",
            defaults = list(clinical.tracks = "FAB_classification")
        ),
        mafsummary = entry(
            "mafSummary", "MAF Summary", "MAF Summary", "Mutations",
            "Variant classes and types, the SNV spectrum, per-sample burden and the most mutated genes of a cohort.",
            "tcga_laml", "df"
        ),
        lollipop = entry(
            "mutationLollipop", "Mutation Lollipop", "Lollipop", "Mutations",
            "DNMT3A mutations along the protein and its domains, the R882 hotspot and other recurrent sites labelled.",
            "tcga_laml", "df",
            defaults = list(gene = "DNMT3A", label.top = 4)
        ),
        mutational = entry(
            "mutationalProfile", "Mutational Profile", "SBS96 Profile", "Mutations",
            "The 96-channel single-base substitution spectrum of each tumour.",
            "example_sbs96", "df",
            figure_builder = TRUE
        ),

        # ---- Clinical ------------------------------------------------------
        survival = entry(
            "survivalCurve", "Survival Curve", "Survival", "Clinical",
            "Kaplan-Meier curves by sex with confidence bands, the log-rank p-value, median survival and a risk table.",
            "survival_lung", "df",
            defaults = list(
                time = "time", status = "status", group.by = "sex",
                risk.table = TRUE, surv.median.line = "hv"
            ),
            figure_builder = TRUE
        ),
        forest = entry(
            "forestPlot", "Forest Plot", "Forest", "Clinical",
            "Hazard ratios from a multivariable Cox model, with a table of estimates and intervals.",
            "survival_lung", "df",
            defaults = list(model = "cox", time = "time", status = "status", covariates = c("age", "sex", "ph.ecog"))
        ),
        roc = entry(
            "rocCurve", "ROC Curve", "ROC", "Clinical",
            "ROC curves for three diagnostic markers, with AUC intervals and Youden-optimal cut-offs.",
            "example_biomarkers", "df",
            defaults = list(
                response = "disease", positive = "Disease",
                predictors = c("marker_strong", "marker_moderate", "marker_weak")
            )
        ),

        # ---- Pharmacology --------------------------------------------------
        dose = entry(
            "doseResponse", "Dose-Response", "Dose-Response", "Pharmacology",
            "Responses against log dose with a fitted four-parameter log-logistic curve.",
            "dose_response", "df",
            needs = "drc", figure_builder = TRUE
        ),
        mm = entry(
            "michaelisMenten", "Michaelis-Menten", "Michaelis-Menten", "Pharmacology",
            "Initial velocity against substrate concentration, with the fitted curve and its Km and Vmax.",
            "mm_kinetics", "object",
            preview = function(x) x$data, ui_data = function(x) x$data
        ),
        pk = entry(
            "pkConcentrationTime", "PK Concentration-Time", "PK Profiles", "Pharmacology",
            "Concentration-time profiles on a log scale, each subject's terminal elimination fit drawn.",
            "theoph", "df",
            defaults = list(show.lambda = TRUE)
        ),
        plate = entry(
            "plateHeatmap", "Plate Heatmap", "Plate", "Pharmacology",
            "Two 384-well plates as percent inhibition, controls outlined, with each plate's Z'-factor.",
            "example_plate", "df",
            defaults = list(normalise = "percent.inhibition")
        ),

        # ---- Structure -----------------------------------------------------
        alphafold = entry(
            "alphafoldConfidence", "AlphaFold Confidence", "AlphaFold", "Structure",
            "Per-residue pLDDT and the predicted aligned error of an AlphaFold model of p53.",
            "example_alphafold", "object",
            preview = function(x) x$plddt
        ),
        structure = entry(
            "structureViewer", "Structure Viewer", "Structure", "Structure",
            "A 3D model of p53 coloured by pLDDT, its most often mutated DNA-binding residues highlighted.",
            "example_structure", "object",
            defaults = list(highlight.residues = "175, 245, 248, 249, 273, 282"),
            preview = function(x) x$residues
        ),
        md = entry(
            "mdTrajectoryMetrics", "MD Trajectory Metrics", "MD Trajectory", "Structure",
            "Backbone RMSD of three replicas and the radius of gyration, smoothed over the faded raw traces.",
            "md_trajectory", "df",
            defaults = list(smooth.window = 25),
            app_datasets = "md_rmsf"
        )
    )
}


#' Packages a showcase entry needs that are not installed
#'
#' @param entry A [.sci_module_showcase()] entry.
#' @return The missing packages, the module's and its dataset's.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_showcase_missing
#' @keywords internal
.sci_showcase_missing <- function(entry) {
    .sci_missing_packages(c(entry$needs, .sci_example_catalogue()[[entry$dataset]]$needs))
}


#' A module's example datasets and showcase defaults, for its `*App()`
#'
#' @param id A module id in [.sci_module_showcase()].
#' @param defaults The caller's defaults, layered over the showcase ones with
#'   [.sci_merge_defaults()].
#' @return A list with `data_list` (the module's example dataset, then any
#'   further ones its app offers, named by their catalogue labels) and
#'   `defaults`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_module_example
#' @keywords internal
.sci_module_example <- function(id, defaults = NULL) {
    entry <- .sci_module_showcase()[[id]]
    if (is.null(entry)) {
        stop("No showcase entry for module '", id, "'.", call. = FALSE)
    }
    keys <- c(entry$dataset, entry$app_datasets)
    catalogue <- .sci_example_catalogue()
    labels <- vapply(keys, function(k) catalogue[[k]]$label, character(1))
    list(
        data_list = stats::setNames(lapply(keys, .sci_example_dataset), labels),
        defaults = .sci_merge_defaults(entry$defaults, defaults)
    )
}


#' Layer a caller's defaults over a module's showcase defaults
#'
#' A key the caller sets replaces the showcase value whole, rather than being
#' merged into it as [utils::modifyList()] would merge a nested list (an
#' annotation-track list, say).
#'
#' @param base The showcase defaults.
#' @param over The caller's defaults, or `NULL`.
#' @return The combined list, or `NULL` when both are empty.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_merge_defaults
#' @keywords internal
.sci_merge_defaults <- function(base, over) {
    out <- base %||% list()
    for (key in names(over)) out[key] <- list(over[[key]])
    if (length(out)) out else NULL
}


#' A module server's arguments, leaving out the ones not given
#'
#' Several servers hide tabs by default (`volcanoPlotServer()` hides
#' "Trajectory" and "Facet"), so a `hide.tabs = NULL` passed through would
#' show them; an argument that is `NULL` is left to the server's own default.
#'
#' @param id The module id.
#' @param data The data reactive.
#' @param defaults,hide.inputs,hide.tabs Passed on when not `NULL`.
#' @return A named list for [do.call()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_server_args
#' @keywords internal
.sci_server_args <- function(id, data, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    args <- list(id = id, data = data)
    args$defaults <- defaults
    args$hide.inputs <- hide.inputs
    args$hide.tabs <- hide.tabs
    args
}
