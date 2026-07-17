#' Create an interactive GO enrichment sunburst ("fan") plot
#'
#' Builds a Gene Ontology (GO) enrichment sunburst plot from an enrichment
#' results table and returns an interactive `plotly` figure. The plot is
#' produced with [GOfan::sunburstGO()], which converts the GO directed acyclic
#' graph (DAG) into a clean, circular (sunburst / fan) representation where each
#' ring corresponds to a hierarchy level and each segment represents a GO term.
#'
#' @details The input `data` must contain a column of GO identifiers (e.g.
#' `"GO:0006955"`) and at least one numeric column to map onto the segment fill
#' colour (for example a q-value or `-log10` p-value). [GOfan::sunburstGO()]
#' resolves the hierarchical relationships among the supplied GO terms using the
#' organism annotation database given in `org`, so the appropriate `OrgDb`
#' package (e.g. `org.Hs.eg.db` for human) must be installed.
#'
#' `GOfan::sunburstGO()` is rendered with `plotBy = "plotly"` so the returned
#' figure is genuinely interactive: hovering a segment reveals its label and
#' clicking a segment zooms into that GO term and its offspring.
#'
#' @param data A data frame of enriched GO terms. Must contain the `term.id`
#'   column of GO identifiers and the `fill` column.
#' @param org Either an `OrgDb` object or the name of an installed organism
#'   annotation package (e.g. `"org.Hs.eg.db"`, `"org.Mm.eg.db"`,
#'   `"org.Dr.eg.db"`). Defaults to `"org.Hs.eg.db"`.
#' @param term.id The name of the column in `data` holding the GO IDs
#'   (default `"ID"`).
#' @param fill The name of the numeric column in `data` used to set the segment
#'   fill colours (default `"qvalue"`).
#' @param sub_rect Optional name of a numeric column in `data` used to draw a
#'   proportional sub-rectangle inside each segment (a value in `[0, 1]`; count
#'   columns are converted to a proportion). `NULL` or `""` disables it.
#' @param onto The GO ontology category of the supplied IDs. One of `"BP"`
#'   (biological process), `"CC"` (cellular component), or `"MF"` (molecular
#'   function).
#' @param go.annotation.level.cutoff Numeric cutoff for the GO annotation levels
#'   passed to [GOfan::sunburstGO()] as `GO_annotation_level_cutoff`
#'   (default `4`).
#' @param filter.nodes.by.edge.number Filter the sub-graphs by their edge number
#'   (passed as `filterNodesByEdgeNumber`, default `2`).
#' @param fill.na.by.0 Logical; fill `NA` values in the colour column with `0`
#'   (passed as `fillNAby0`, default `TRUE`).
#' @param must.keep Optional character vector of GO terms that must be kept
#'   (passed as `mustkeep`).
#' @param only.keep Optional character vector of GO terms; only branches
#'   containing these terms are kept (passed as `onlyKeep`).
#' @param ... Further arguments passed to [GOfan::sunburstGO()].
#'
#' @return A [plotly::plot_ly()] object containing the interactive sunburst plot.
#'
#' @import plotly
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [GOfan::sunburstGO()], [sciVizModules::goFanPlotInputsUI()],
#' [sciVizModules::goFanPlotServer()], [sciVizModules::goFanPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_enrichment)
#' # Requires the 'GOfan' package and the relevant OrgDb (e.g. org.Hs.eg.db).
#' if (requireNamespace("GOfan", quietly = TRUE) &&
#'     requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
#'     fig <- goFanPlot(example_enrichment,
#'         org = "org.Hs.eg.db",
#'         term.id = "ID", fill = "qvalue", onto = "BP"
#'     )
#'     if (interactive()) fig
#' }
goFanPlot <- function(data,
                      org = "org.Hs.eg.db",
                      term.id = "ID",
                      fill = "qvalue",
                      sub_rect = NULL,
                      onto = c("BP", "CC", "MF"),
                      go.annotation.level.cutoff = 4,
                      filter.nodes.by.edge.number = 2,
                      fill.na.by.0 = TRUE,
                      must.keep = NULL,
                      only.keep = NULL,
                      ...) {
    if (!requireNamespace("GOfan", quietly = TRUE)) {
        stop(
            "The 'GOfan' package is required for goFanPlot(). ",
            "Install it with BiocManager::install('jianhong/GOfan')."
        )
    }

    stopifnot(is.data.frame(data))
    onto <- match.arg(onto)
    df <- as.data.frame(data)

    if (!term.id %in% names(df)) {
        stop("GO ID column '", term.id, "' not found in data.")
    }
    if (!fill %in% names(df)) {
        stop("Fill column '", fill, "' not found in data.")
    }

    # Extract the first GO:####### token from each cell so free-text
    # columns like "immune response (GO:0006955)" or "GO:0006955 / foo"
    # are handled gracefully. Also coerces factors and tibble subsets
    # to plain character, which GOfan's downstream validators require.
    df[[term.id]] <- .extract_go_id(df[[term.id]])
    keep <- !is.na(df[[term.id]])
    if (!any(keep)) {
        stop(
            "No valid GO IDs (format 'GO:0000000') found in column '",
            term.id, "'."
        )
    }
    if (any(!keep)) {
        warning(
            "Dropping ", sum(!keep), " row(s) from '", term.id,
            "' with no extractable GO ID."
        )
        df <- df[keep, , drop = FALSE]
    }

    orgdb <- .resolve_orgdb(org)

    args <- list(
        df = df,
        org = orgdb,
        termID = term.id,
        fill = fill,
        GO_annotation_level_cutoff = go.annotation.level.cutoff,
        filterNodesByEdgeNumber = filter.nodes.by.edge.number,
        fillNAby0 = isTRUE(fill.na.by.0),
        onto = onto,
        plotBy = "plotly"
    )

    if (!is.null(sub_rect) && length(sub_rect) == 1 && nzchar(sub_rect)) {
        if (!sub_rect %in% names(df)) {
            stop("Sub-rectangle column '", sub_rect, "' not found in data.")
        }
        args$sub_rect <- sub_rect
    }
    if (!is.null(must.keep) && length(must.keep) > 0) args$mustkeep <- must.keep
    if (!is.null(only.keep) && length(only.keep) > 0) args$onlyKeep <- only.keep

    do.call(GOfan::sunburstGO, c(args, list(...)))
}


#' Resolve an OrgDb argument to an OrgDb object
#'
#' Accepts either an `OrgDb` object (returned unchanged) or the name of an
#' installed organism annotation package (e.g. `"org.Hs.eg.db"`) and returns the
#' corresponding `OrgDb` object exported by that package.
#'
#' @param org An `OrgDb` object or a length-one character naming an OrgDb
#'   package.
#' @return An `OrgDb` object.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_resolve_orgdb
#' @keywords internal
.resolve_orgdb <- function(org) {
    if (is.character(org) && length(org) == 1) {
        pkg <- org
        if (!requireNamespace(pkg, quietly = TRUE)) {
            stop(
                "The organism annotation package '", pkg, "' is required but is ",
                "not installed. Install it with BiocManager::install('", pkg, "')."
            )
        }
        return(getExportedValue(pkg, pkg))
    }
    org
}
