#' Input UI components for the methylationTrack module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `methylationTrackServer()` and
#' `methylationTrackOutputUI()` functions.
#'
#' @details The module draws [methylationTrack()]: a heatmap of beta values, with samples
#' as rows and CpGs as columns, under the transcripts of a gene, region or set of probes.
#' Its data is a [methylationCohort()], or anything that takes, which can mix Infinium
#' arrays. Arrays are joined on genomic position, and a CpG not on a sample's array has a
#' colour of its own. The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' Choices in the Samples tab need no redraw to change the colours, and a change of
#' colour scale reaches the browser as a layout-only update.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' **Data**
#' - `locate.by` - Look up a `"gene"`, `"region"` or `"probes"` (default: `"gene"`)
#' - `gene` - The gene (default: none)
#' - `region` - The region, as `chr19:10260000-10380000` (default: none)
#' - `probes` - Probe IDs, separated by commas or spaces, from one chromosome (default: none)
#' - `upstream`, `downstream` - Bases added around a gene or probes (default: 2000)
#' - `cpg.scope` - `"all"` CpGs on any plotted array, or those `"shared"` by all of them
#'   (default: `"all"`)
#' - `max.cpgs` - The most CpGs to draw (default: 1000)
#'
#' **Samples**
#' - `filter.col`, `filter.levels` - Keep samples with these levels of a column (default: all)
#' - `sample.filter` - Keep samples meeting a condition, such as `age > 40` (default: all)
#' - `group.by` - Group samples on a column (default: `"platform"` for several arrays)
#' - `group.gap` - Blank rows between groups (default: 1)
#' - `cluster.samples` - Cluster samples, within any groups (default: FALSE)
#' - `dist.method` - Distance: `"euclidean"`, `"manhattan"`, `"pearson"` or `"spearman"`
#'   (default: `"euclidean"`)
#' - `hclust.method` - Linkage, as [stats::hclust()] (default: `"ward.D2"`)
#' - `show.dendrogram` - Draw the clustering (default: TRUE)
#' - `anno.left`, `anno.right` - Columns drawn as strips each side of the heatmap (default: none)
#' - `anno.colors` - Named colours of their levels, as `"column: level"` (multiColorPicker;
#'   default: a colour for each level in the cohort)
#' - `anno.low`, `anno.high` - Colours of a numeric strip (default: "#DEEBF7" and "#08306B")
#' - `show.sample.names` - Label the samples (default: TRUE)
#' - `sample.font.size` - Size of those labels (default: 10)
#'
#' **Tracks**
#' - `txn.view` - `"full"`, a row per transcript, or `"collapsed"`, a row per gene with
#'   its transcripts overlaid (default: `"full"`)
#' - `txn.types` - Transcript types to draw (default: `"protein_coding"`)
#' - `txn.labels` - Label the transcripts (default: TRUE)
#' - `txn.font.size` - Size of those labels (default: 8)
#' - `exon.color`, `cds.color`, `intron.color` - Transcript colours (default: "#1A1A1A",
#'   "#D7191C" and "#444444")
#' - `show.cytoband` - Draw the ideogram (default: TRUE)
#' - `show.map.lines` - Draw the lines from position to column (default: TRUE)
#' - `show.coverage` - Draw which array has which CpG (default: TRUE)
#' - `cpg.tracks` - `rowData()` columns drawn as strips under the heatmap (default: none)
#' - `cpg.labels` - Label columns with `"none"`, `"probe"` or `"locus"` (default: `"none"`)
#'
#' **Aesthetics**
#' - The colour scale inputs of [VizModules::uniform_colorscale_inputs_ui()], from 0 to 1
#'   and titled "Beta value" by default
#' - `absent.color` - Colour of a cell whose array lacks the CpG (default: "#BDBDBD")
#' - `na.color` - Colour of a cell with no value on an array that has the CpG (default: "#FFFFFF")
#'
#' The Legend, Axes and Plotly tabs carry the shared VizModules inputs. Only the sample
#' and column labels follow the Axes tab, with its axis lines boxing the heatmap, and
#' gridlines are not offered, as they would run across cells. There is no Lines tab.
#'
#' @param id The ID for the Shiny module.
#' @param data A [methylationCohort()], or anything it takes.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [methylationTrack()], [methylationCohort()], [sciVizModules::methylationTrackOutputUI()],
#' [sciVizModules::methylationTrackServer()], [sciVizModules::methylationTrackApp()]
#' @examples
#' library(sciVizModules)
#' data(example_methylation)
#' methylationTrackInputsUI("track", example_methylation)
methylationTrackInputsUI <- function(id, data, defaults = NULL, title = "Methylation Track Settings", columns = 2) {
    ns <- NS(id)
    cohort <- .meth_as_cohort(data)
    defaults <- .meth_axes_defaults(defaults)
    d <- .meth_defaults(cohort, defaults)
    samples <- cohort$samples
    none <- c("None" = "")
    group.cols <- .meth_group_cols(samples)
    strip.cols <- .meth_strip_cols(samples)
    switch_input <- function(key, label) {
        materialSwitch(ns(key), label, value = isTRUE(d[[key]]), status = "success")
    }

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("locate.by"), "Look Up", choices = .meth_lookups, selected = d$locate.by),
            "What to plot: a gene, a region, or the region around some probes."),
        .sci_tip(viz_select_input(ns("gene"), "Gene", choices = c(none, .meth_gene_names(cohort)), selected = d$gene),
            "All of the gene's transcripts are spanned, plus the bases set below."),
        .sci_tip(textInput(ns("region"), "Region", value = d$region, placeholder = "chr19:10260000-10380000"),
            "A chromosome, start and end."),
        .sci_tip(textAreaInput(ns("probes"), "Probes", value = d$probes, rows = 2,
            placeholder = "cg02382400, cg03738669"),
            "Probe IDs on one chromosome, on any of the arrays. The plot covers the region around them."),
        .sci_tip(numericInput(ns("upstream"), "Upstream (bp)", value = d$upstream, min = 0, step = 500),
            "Bases added before a gene, following its strand, or before the probes."),
        .sci_tip(numericInput(ns("downstream"), "Downstream (bp)", value = d$downstream, min = 0, step = 500),
            "Bases added after a gene, following its strand, or after the probes."),
        .sci_tip(viz_select_input(ns("cpg.scope"), "CpGs", choices = .meth_scopes, selected = d$cpg.scope),
            "Every CpG on any plotted array, or only those on all of them. Nothing is imputed."),
        .sci_tip(numericInput(ns("max.cpgs"), "Max CpGs", value = d$max.cpgs, min = 1, step = 100),
            "The most CpGs to draw. Larger regions ask to be shrunk.")
    )

    samples_tab <- tagList(
        .sci_tip(viz_select_input(ns("filter.col"), "Filter By", choices = c(none, group.cols),
            selected = d$filter.col), "A sample information column to choose samples on."),
        .sci_tip(viz_select_input(ns("filter.levels"), "Keep Levels",
            choices = .meth_filter_levels(samples, d$filter.col), selected = d$filter.levels, multiple = TRUE),
            "The levels of that column to keep. None selected keeps every sample."),
        .sci_tip(textInput(ns("sample.filter"), "Sample Filter", value = d$sample.filter, placeholder = "age > 40"),
            "A condition on the sample information columns, applied as well as Filter By."),
        textOutput(ns("sample.status")),
        .sci_tip(viz_select_input(ns("group.by"), "Group By", choices = c(none, group.cols), selected = d$group.by),
            "Gather samples into groups, set apart by a gap. Clustering then runs within each group."),
        .sci_tip(numericInput(ns("group.gap"), "Group Gap", value = d$group.gap, min = 0, step = 1),
            "Blank rows between groups."),
        .sci_tip(switch_input("cluster.samples", "Cluster Samples"),
            "Hierarchical clustering on the CpGs measured in all of the samples being clustered."),
        .sci_tip(viz_select_input(ns("dist.method"), "Distance", choices = .meth_distances, selected = d$dist.method),
            "How samples are compared."),
        .sci_tip(viz_select_input(ns("hclust.method"), "Linkage", choices = .meth_linkages, selected = d$hclust.method),
            "How clusters are joined."),
        .sci_tip(switch_input("show.dendrogram", "Dendrogram"), "Draw the clustering beside the heatmap."),
        .sci_tip(viz_select_input(ns("anno.left"), "Left Annotations", choices = strip.cols, selected = d$anno.left,
            multiple = TRUE), "Sample information to draw as strips left of the heatmap."),
        .sci_tip(viz_select_input(ns("anno.right"), "Right Annotations", choices = strip.cols, selected = d$anno.right,
            multiple = TRUE), "Sample information to draw as strips right of the heatmap."),
        uiOutput(ns("palette.selection")),
        .sci_tip(colourInput(ns("anno.low"), "Numeric Low", value = d$anno.low), "Lowest colour of a numeric strip."),
        .sci_tip(colourInput(ns("anno.high"), "Numeric High", value = d$anno.high),
            "Highest colour of a numeric strip."),
        .sci_tip(switch_input("show.sample.names", "Sample Names"), "Label the samples."),
        .sci_tip(numericInput(ns("sample.font.size"), "Sample Font Size", value = d$sample.font.size, min = 1,
            step = 1), "Size of the sample labels.")
    )

    tracks_tab <- tagList(
        .sci_tip(viz_select_input(ns("txn.view"), "Transcripts", choices = .meth_txn_views, selected = d$txn.view),
            "A row per transcript, or a row per gene with its transcripts overlaid, as in IGV."),
        .sci_tip(viz_select_input(ns("txn.types"), "Transcript Types", choices = .meth_txn_types(cohort),
            selected = d$txn.types, multiple = TRUE), "The transcript types to draw. None selected draws them all."),
        .sci_tip(switch_input("txn.labels", "Transcript Labels"), "Name each transcript or gene."),
        .sci_tip(numericInput(ns("txn.font.size"), "Label Font Size", value = d$txn.font.size, min = 1, step = 1),
            "Size of those names."),
        .sci_tip(colourInput(ns("exon.color"), "Exon Color", value = d$exon.color), "Colour of the exons."),
        .sci_tip(colourInput(ns("cds.color"), "CDS Color", value = d$cds.color), "Colour of the coding sequence."),
        .sci_tip(colourInput(ns("intron.color"), "Intron Color", value = d$intron.color),
            "Colour of the transcript lines, arrowheads and labels."),
        .sci_tip(switch_input("show.cytoband", "Ideogram"), "Show where the region sits on its chromosome."),
        .sci_tip(switch_input("show.map.lines", "Map Lines"), "Link each CpG's position to its heatmap column."),
        .sci_tip(switch_input("show.coverage", "Array Coverage"), "Mark which array has which CpG."),
        .sci_tip(viz_select_input(ns("cpg.tracks"), "CpG Annotations", choices = .meth_cpg_cols(cohort),
            selected = d$cpg.tracks, multiple = TRUE), "rowData columns to draw as strips under the heatmap."),
        .sci_tip(viz_select_input(ns("cpg.labels"), "CpG Labels", choices = .meth_cpg_label_choices,
            selected = d$cpg.labels), "Label the heatmap's columns.")
    )

    aes_tab <- tagList(
        uniform_colorscale_inputs_ui(ns, defaults),
        .sci_tip(colourInput(ns("absent.color"), "Not On Array", value = d$absent.color),
            "Colour of a cell whose array lacks the CpG."),
        .sci_tip(colourInput(ns("na.color"), "No Value", value = d$na.color),
            "Colour of a cell with no value on an array that has the CpG, such as a masked probe.")
    )

    .sci_plot_inputs_ui(ns, "methylationTrack", data_tab, aes_tab, defaults, title, columns,
        lines = FALSE, extra_tabs = list("Samples" = samples_tab, "Tracks" = tracks_tab))
}


#' Output UI components for the methylationTrack module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' methylationTrackOutputUI("track")
#' @export
#' @author Jared Andrews
methylationTrackOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "methylationTrack", resizable = resizable, height = "750px")
}


# The choices of the module's selects.
.meth_lookups <- c("Gene" = "gene", "Region" = "region", "Probes" = "probes")
.meth_scopes <- c("All, on any array" = "all", "Shared by all arrays" = "shared")
.meth_distances <- c(
    "Euclidean" = "euclidean", "Manhattan" = "manhattan", "1 - Pearson" = "pearson", "1 - Spearman" = "spearman"
)
.meth_linkages <- c(
    "Ward (ward.D2)" = "ward.D2", "Average" = "average", "Complete" = "complete", "Single" = "single",
    "McQuitty" = "mcquitty"
)
.meth_txn_views <- c("Full" = "full", "Collapsed" = "collapsed")
.meth_cpg_label_choices <- c("None" = "none", "Probe ID" = "probe", "Position" = "locus")

# The inputs each lookup uses.
.meth_lookup_inputs <- list(
    gene = c("gene", "upstream", "downstream"), region = "region", probes = c("probes", "upstream", "downstream")
)

# The Axes tab inputs methylationTrackServer() always hides: gridlines would run
# across the heatmap's cells.
.meth_grid_inputs <- c("show.grid.x", "show.grid.y", "grid.color")


#' The gene names of a cohort's transcripts
#'
#' @param cohort A `methylationCohort`.
#' @return Sorted gene names.
#'
#' @importFrom GenomicRanges mcols
#' @author Jared Andrews
#' @rdname INTERNAL_meth_defaults
#' @keywords internal
.meth_gene_names <- function(cohort) {
    txns <- .meth_txns(cohort)
    if (is.null(txns)) character(0) else sort(unique(as.character(mcols(txns)$gene_name)))
}


#' The transcript types of a cohort's transcripts
#'
#' @param cohort A `methylationCohort`.
#' @return Sorted transcript types.
#'
#' @importFrom GenomicRanges mcols
#' @author Jared Andrews
#' @rdname INTERNAL_meth_defaults
#' @keywords internal
.meth_txn_types <- function(cohort) {
    txns <- .meth_txns(cohort)
    if (is.null(txns)) character(0) else sort(unique(as.character(mcols(txns)$transcript_type)))
}


#' The levels offered for filtering on a column
#'
#' @param samples A cohort's sample table.
#' @param col A column, or `""`.
#' @return The column's levels.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_defaults
#' @keywords internal
.meth_filter_levels <- function(samples, col) {
    if (nz_value(col) && col %in% names(samples)) .meth_levels(samples[[col]]) else character(0)
}


#' The picker's groups for the strips on show
#'
#' @param cohort A `methylationCohort`.
#' @param columns The sample and CpG annotations drawn.
#' @return Strings of `"column: level"`, for the discrete ones.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_defaults
#' @keywords internal
.meth_anno_groups <- function(cohort, columns) {
    levels <- .meth_annotation_levels(cohort)
    columns <- intersect(unique(columns), names(levels))
    unlist(lapply(columns, function(col) paste0(col, ": ", levels[[col]])), use.names = FALSE)
}


#' Default inputs for the methylationTrack module
#'
#' Shared by the module's UI and its Reset, so the two cannot drift.
#'
#' @param cohort A `methylationCohort`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_defaults
#' @keywords internal
.meth_defaults <- function(cohort, defaults = NULL) {
    samples <- cohort$samples
    group.cols <- .meth_group_cols(samples)
    strip.cols <- .meth_strip_cols(samples)
    types <- .meth_txn_types(cohort)
    platforms <- .meth_sample_platforms(samples)
    one_of <- function(choices) function(x) length(x) == 1 && x %in% choices
    some_of <- function(choices) function(x) all(x %in% choices)

    base <- list(
        locate.by = "gene", gene = "", region = "", probes = "", upstream = 2000, downstream = 2000,
        cpg.scope = "all", max.cpgs = 1000,
        filter.col = "", filter.levels = character(0), sample.filter = "",
        group.by = if (length(platforms) > 1) "platform" else "", group.gap = 1, cluster.samples = FALSE,
        dist.method = "euclidean", hclust.method = "ward.D2", show.dendrogram = TRUE,
        anno.left = character(0), anno.right = character(0),
        anno.low = .meth_colors$anno.low, anno.high = .meth_colors$anno.high,
        show.sample.names = TRUE, sample.font.size = 10,
        txn.view = "full", txn.types = intersect("protein_coding", types), txn.labels = TRUE, txn.font.size = 8,
        exon.color = .meth_colors$exon, cds.color = .meth_colors$cds, intron.color = .meth_colors$intron,
        show.cytoband = TRUE, show.map.lines = TRUE, show.coverage = TRUE,
        cpg.tracks = character(0), cpg.labels = "none",
        absent.color = .meth_colors$absent, na.color = .meth_colors$na
    )
    checks <- list(
        locate.by = one_of(.meth_lookups), gene = one_of(c("", .meth_gene_names(cohort))),
        cpg.scope = one_of(.meth_scopes), filter.col = one_of(c("", group.cols)),
        group.by = one_of(c("", group.cols)), dist.method = one_of(.meth_distances),
        hclust.method = one_of(.meth_linkages), anno.left = some_of(strip.cols), anno.right = some_of(strip.cols),
        txn.view = one_of(.meth_txn_views), txn.types = some_of(types), cpg.tracks = some_of(.meth_cpg_cols(cohort)),
        cpg.labels = one_of(.meth_cpg_label_choices)
    )
    out <- lapply(stats::setNames(nm = names(base)), function(k) {
        get_default(defaults, k, base[[k]], checks[[k]])
    })
    out$filter.levels <- get_default(
        defaults, "filter.levels", character(0), some_of(.meth_filter_levels(samples, out$filter.col))
    )
    out
}


#' The methylationTrack defaults for the shared tabs
#'
#' Beta values run from 0 to 1, so the colour scale does too, and column labels stand
#' upright to fit their narrow columns.
#'
#' @param defaults A named list of user defaults, or `NULL`.
#' @return `defaults`, with those set where the caller did not set them.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_meth_defaults
#' @keywords internal
.meth_axes_defaults <- function(defaults) {
    utils::modifyList(
        list(
            show.grid.x = FALSE, show.grid.y = FALSE, axis.showline = FALSE, axis.tickangle.x = -90,
            colorscale.min = 0, colorscale.max = 1, colorbar.title = "Beta value"
        ),
        defaults %||% list()
    )
}
