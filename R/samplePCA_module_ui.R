#' Input UI components for the samplePCA module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `samplePCAServer()` and
#' `samplePCAOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module draws the sample PCA of a bulk expression experiment, the first
#' plot of most RNA-seq analyses: the counts of a `SummarizedExperiment` are
#' transformed, the most variable genes kept, and the samples projected onto
#' their principal components ([sample_pca()]). The scores are drawn by the
#' [pcaBiplotInputsUI()] module, so the component axes (titled with the variance
#' each explains), the loading arrows and every scatter control apply; those
#' inputs are documented there. Colour and shape choices come from `colData`.
#'
#' To see the scree, loadings, pairs or PC-metadata correlation views of the
#' same PCA, build it with [sample_pca()] and pass it to [pcaScreePlotServer()]
#' and friends.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `pca.assay` - Assay (UI: "Assay", default: `"counts"` when present)
#' - `pca.transform` - Transformation (UI: "Transformation", default: `"vst"`,
#'   DESeq2's variance-stabilising transformation, when DESeq2 is installed,
#'   otherwise `"log2cpm"`; also `"log2"` and `"none"`)
#' - `pca.ntop` - Most variable genes kept (UI: "Top Variable Genes", default: 500,
#'   as DESeq2's `plotPCA()`)
#' - `pca.center`, `pca.scale` - Centre and scale each gene before the PCA (UI:
#'   "Center Genes", "Scale Genes"; default: TRUE, FALSE)
#' - `pca.labels` - `rowData` column naming the genes in the loading arrows, or
#'   `""` for the row names (UI: "Gene Labels", default: `symbol` when present)
#' - `x.by`, `y.by`, `color.by` - Components on the axes and the colour column
#'   (default: `"PC1"`, `"PC2"`, the first `colData` column that groups samples, skipping sample IDs)
#' - All other [pcaBiplotInputsUI()] parameters
#'
#' @param id The ID for the Shiny module.
#' @param data A `SummarizedExperiment` of counts (a `DESeqDataSet` will do).
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jared Andrews
#' @seealso [sample_pca()], [sciVizModules::pcaBiplotInputsUI()], [sciVizModules::samplePCAOutputUI()],
#' [sciVizModules::samplePCAServer()], [sciVizModules::samplePCAApp()]
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("airway", quietly = TRUE)) {
#'     data("airway", package = "airway")
#'     samplePCAInputsUI("pca", airway, defaults = list(pca.transform = "log2cpm"))
#' }
samplePCAInputsUI <- function(id, data, defaults = NULL, title = "Sample PCA Settings", columns = 2) {
    ns <- NS(id)
    .assert_se(data)
    d <- .spca_defaults(data, defaults)
    p <- .spca_build(data, .se_transform(data, d$pca.assay, d$pca.transform), d)
    labels <- .se_label_cols(data)

    extras <- tagList(
        .sci_tip(viz_select_input(ns("pca.assay"), "Assay", choices = .se_assays(data), selected = d$pca.assay),
            "The assay the PCA is computed from."),
        .sci_tip(viz_select_input(ns("pca.transform"), "Transformation",
            choices = .se_transform_choices(), selected = d$pca.transform
        ), paste("How counts are transformed first. Variance stabilisation (DESeq2) or log2 CPM for raw counts;",
            "None for an assay that is already on a log scale.")),
        .sci_tip(numericInput(ns("pca.ntop"), "Top Variable Genes", value = d$pca.ntop, min = 2, step = 50),
            "The most variable genes the PCA uses (DESeq2's plotPCA() uses 500)."),
        .sci_tip(viz_select_input(ns("pca.labels"), "Gene Labels",
            choices = c("Row names" = "", stats::setNames(labels, labels)), selected = d$pca.labels
        ), "rowData column naming the genes in the loading arrows."),
        .sci_tip(materialSwitch(ns("pca.center"), "Center Genes", value = isTRUE(d$pca.center), status = "success"),
            "Centre each gene on its mean before the PCA."),
        .sci_tip(materialSwitch(ns("pca.scale"), "Scale Genes", value = isTRUE(d$pca.scale), status = "success"),
            "Scale each gene to unit variance, so every gene weighs the same.")
    )

    tagList(
        organize_inputs(extras, columns = columns),
        pcaBiplotInputsUI(id, p, defaults = .spca_biplot_defaults(data, defaults), title = title, columns = columns)
    )
}


#' Output UI components for the samplePCA module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical, whether to wrap the output in a resizable container.
#' @return A Shiny plotlyOutput for the PCA.
#'
#' @examples
#' samplePCAOutputUI("pca")
#' @export
#' @author Jared Andrews
samplePCAOutputUI <- function(id, resizable = TRUE) {
    pcaBiplotOutputUI(id, resizable = resizable)
}


#' Default inputs for the samplePCA module
#'
#' Shared by the UI, the server and the Reset handler. User values win.
#'
#' @param se A `SummarizedExperiment`, or `NULL`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return The wrapper's own defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_spca_defaults
#' @keywords internal
.spca_defaults <- function(se, defaults = NULL) {
    labels <- if (is.null(se)) character(0) else .se_label_cols(se)
    labels <- intersect(c("symbol", "SYMBOL", "gene_name", "gene_symbol"), labels)
    base <- list(
        pca.assay = if (is.null(se)) "" else .se_default_assay(se),
        pca.transform = .se_default_transform(),
        pca.ntop = 500,
        pca.center = TRUE,
        pca.scale = FALSE,
        pca.labels = if (length(labels)) labels[1] else ""
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}

.spca_keys <- c("pca.assay", "pca.transform", "pca.ntop", "pca.center", "pca.scale", "pca.labels")


#' Biplot defaults for the samplePCA module
#'
#' The first two components on the axes, coloured by the first discrete
#' `colData` column. Given explicitly, since the wrapped biplot cannot read the
#' PCA when it is constructed. User values win.
#'
#' @param se A `SummarizedExperiment`, or `NULL`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return Defaults for [pcaBiplotServer()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_spca_biplot_defaults
#' @keywords internal
.spca_biplot_defaults <- function(se, defaults = NULL) {
    disc <- if (is.null(se)) character(0) else .se_group_cols(.se_coldata(se))
    base <- list(x.by = "PC1", y.by = "PC2", color.by = if (length(disc)) disc[1] else "", hover.data = "sample")
    user <- defaults %||% list()
    user <- user[setdiff(names(user), .spca_keys)]
    base[names(user)] <- user
    base
}


#' Build the samplePCA module's PCA from a transformed assay
#'
#' @param se The `SummarizedExperiment`.
#' @param mat Its transformed assay.
#' @param d The wrapper's input values.
#' @return A PCAtools-shaped `pca` list.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_spca_build
#' @keywords internal
.spca_build <- function(se, mat, d) {
    labels <- stats::setNames(.se_feature_labels(se, rownames(mat), d$pca.labels), rownames(mat))
    .pca_from_matrix(mat, .se_coldata(se), d$pca.ntop, d$pca.center, d$pca.scale, labels)
}
