#' Check that an object is a PCAtools `pca` object
#'
#' The PCAtools modules read the object's fields directly (it is a plain list),
#' so this only checks the fields they use are present.
#'
#' @param x The object to check.
#' @param arg Argument name for the error message.
#' @return `x`, invisibly.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_assert_pca
#' @keywords internal
.assert_pca <- function(x, arg = "data") {
    ok <- is.list(x) && all(c("rotated", "loadings", "variance") %in% names(x))
    if (!ok) {
        stop("'", arg, "' must be a PCAtools `pca` object, as returned by PCAtools::pca().", call. = FALSE)
    }
    invisible(x)
}


#' Component names of a PCAtools `pca` object
#'
#' @param p A `pca` object.
#' @return A character vector, e.g. `c("PC1", "PC2", ...)`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_components
#' @keywords internal
.pca_components <- function(p) {
    p$components %||% colnames(p$rotated)
}


#' Sample scores joined to the sample metadata
#'
#' One row per sample: a `sample` column (the row names of `rotated`), every
#' component score, then every metadata column whose name does not clash.
#'
#' @param p A `pca` object.
#' @return A data frame.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_scores_df
#' @keywords internal
.pca_scores_df <- function(p) {
    scores <- as.data.frame(p$rotated)
    sample <- rownames(scores) %||% as.character(seq_len(nrow(scores)))
    df <- data.frame(sample = sample, scores, check.names = FALSE, stringsAsFactors = FALSE)
    meta <- p$metadata
    if (!is.null(meta) && nrow(as.data.frame(meta)) == nrow(scores)) {
        meta <- as.data.frame(meta)
        df <- cbind(df, meta[, setdiff(names(meta), names(df)), drop = FALSE])
    }
    rownames(df) <- NULL
    df
}


#' Axis title for a component, with its explained variance
#'
#' @param p A `pca` object.
#' @param pc A component name.
#' @return E.g. `"PC1 (40.8% variance)"`, or `pc` unchanged when it is not a
#'   component.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_axis_title
#' @keywords internal
.pca_axis_title <- function(p, pc) {
    v <- p$variance
    if (is.null(names(v))) names(v) <- .pca_components(p)
    if (!pc %in% names(v)) {
        return(pc)
    }
    sprintf("%s (%.1f%% variance)", pc, v[[pc]])
}


#' Metadata columns of a `pca` object, by type
#'
#' @param p A `pca` object.
#' @param type `"discrete"` (logical, or factor and character with fewer than
#'   50 levels; see [.sci_discrete_cols()]) or `"numeric"`.
#' @return A character vector of column names, possibly empty.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_metadata_cols
#' @keywords internal
.pca_metadata_cols <- function(p, type = c("discrete", "numeric")) {
    type <- match.arg(type)
    meta <- p$metadata
    if (is.null(meta) || ncol(as.data.frame(meta)) == 0) {
        return(character(0))
    }
    meta <- as.data.frame(meta)
    if (identical(type, "discrete")) {
        # Sample IDs and other columns with too many levels to colour or shape by are left out.
        return(.sci_discrete_cols(meta))
    }
    names(meta)[vapply(meta, is.numeric, logical(1))]
}


#' The elbow of a scree curve
#'
#' Uses [PCAtools::findElbowPoint()] when PCAtools is installed.
#'
#' @param p A `pca` object.
#' @return The 1-based index of the elbow component, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_elbow
#' @keywords internal
.pca_elbow <- function(p) {
    if (!requireNamespace("PCAtools", quietly = TRUE)) {
        return(NULL)
    }
    elbow <- tryCatch(PCAtools::findElbowPoint(unname(p$variance)), error = function(e) NULL)
    if (length(elbow) != 1 || is.na(elbow)) NULL else as.integer(elbow)
}


#' Parse a typed list of components
#'
#' Accepts numbers or component names separated by commas or spaces, e.g.
#' `"3, 5"` or `"PC3 PC5"`.
#'
#' @param x A character string, or `NULL`.
#' @param n The number of components available.
#' @return A sorted integer vector of valid component indices, possibly empty.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_parse_components
#' @keywords internal
.pca_parse_components <- function(x, n) {
    if (!nz_value(x)) {
        return(integer(0))
    }
    parts <- strsplit(trimws(x), "[,[:space:]]+")[[1]]
    idx <- suppressWarnings(as.integer(sub("^PC", "", parts, ignore.case = TRUE)))
    sort(unique(idx[!is.na(idx) & idx >= 1 & idx <= n]))
}


#' Loading arrows for a biplot
#'
#' Picks the `n` variables with the largest absolute loading on each of the two
#' components (as [PCAtools::biplot()] does with `ntopLoadings`) and scales their
#' loadings into score space. The scale is the smaller of the two axes' ratio of
#' score range to loading range, times `length.factor`, so the longest arrows span
#' a comparable distance to the samples. (PCAtools computes
#' `max(scores) - min(scores) / range(loadings)` there, an operator-precedence
#' slip; this uses the ratio of ranges it intends.)
#'
#' @param p A `pca` object.
#' @param x,y Component names on the two axes.
#' @param n Number of top variables per component.
#' @param length.factor Arrow length multiplier.
#' @return A data frame with `variable`, `xend`, `yend`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_loading_arrows
#' @keywords internal
.pca_loading_arrows <- function(p, x, y, n = 5, length.factor = 1.5) {
    ld <- as.data.frame(p$loadings)
    sc <- as.data.frame(p$rotated)
    n <- max(1L, min(as.integer(n), nrow(ld)))
    vars <- unique(c(
        rownames(ld)[order(abs(ld[[x]]), decreasing = TRUE)][seq_len(n)],
        rownames(ld)[order(abs(ld[[y]]), decreasing = TRUE)][seq_len(n)]
    ))
    span <- function(v) diff(range(v, na.rm = TRUE))
    r <- min(span(sc[[x]]) / span(ld[[x]]), span(sc[[y]]) / span(ld[[y]]))
    data.frame(
        variable = vars,
        xend = ld[vars, x] * r * length.factor,
        yend = ld[vars, y] * r * length.factor,
        stringsAsFactors = FALSE
    )
}


#' Draw loading arrows onto a biplot figure
#'
#' Each arrow is an annotation from the origin to the scaled loading (tail and
#' head both in data coordinates), with the variable name as a separate label at
#' the head so it sits beyond the arrow rather than at the origin.
#'
#' @param fig A `plotly` figure.
#' @param arrows A data frame from [.pca_loading_arrows()].
#' @param color Arrow and label colour.
#' @param label.size Label font size.
#' @return The figure with the arrows added.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_add_loading_arrows
#' @keywords internal
.pca_add_loading_arrows <- function(fig, arrows, color = "#000000", label.size = 12) {
    new <- list()
    for (i in seq_len(nrow(arrows))) {
        new[[length(new) + 1]] <- list(
            x = arrows$xend[i], y = arrows$yend[i], xref = "x", yref = "y",
            ax = 0, ay = 0, axref = "x", ayref = "y",
            text = "", showarrow = TRUE, arrowhead = 2, arrowsize = 1, arrowwidth = 1.5,
            arrowcolor = color
        )
        new[[length(new) + 1]] <- list(
            x = arrows$xend[i], y = arrows$yend[i], xref = "x", yref = "y",
            text = arrows$variable[i], showarrow = FALSE,
            xanchor = if (arrows$xend[i] >= 0) "left" else "right",
            yanchor = if (arrows$yend[i] >= 0) "bottom" else "top",
            font = list(color = color, size = label.size)
        )
    }
    fig$x$layout$annotations <- c(fig$x$layout$annotations, new)
    fig
}


#' Default inputs for the PCA biplot module
#'
#' Shared by [pcaBiplotInputsUI()] and [pcaBiplotServer()]: the first two
#' components on the axes, colour by the first discrete metadata column, and the
#' loading-arrow settings. User values win.
#'
#' @param p A `pca` object, or `NULL` when no data is available yet.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_biplot_defaults
#' @keywords internal
.pca_biplot_defaults <- function(p, defaults = NULL) {
    base <- list(
        show.loadings = FALSE,
        n.top.loadings = 5,
        loadings.length.factor = 1.5,
        loadings.color = "#000000",
        loadings.label.size = 12
    )
    if (!is.null(p)) {
        comps <- .pca_components(p)
        disc <- .pca_metadata_cols(p, "discrete")
        base$x.by <- comps[1]
        base$y.by <- if (length(comps) > 1) comps[2] else comps[1]
        base$color.by <- if (length(disc)) disc[1] else ""
        base$hover.data <- "sample"
    }
    utils::modifyList(base, defaults %||% list())
}

# Inputs the biplot adds to the wrapped scatter module.
.pca_biplot_keys <- c(
    "show.loadings", "n.top.loadings", "loadings.length.factor", "loadings.color", "loadings.label.size"
)


#' Add the biplot's layers to the wrapped scatter figure
#'
#' The `fig.fn` hook [pcaBiplotServer()] hands to
#' [VizModules::dittoViz_scatterPlotServer()]. Titles each component axis with
#' its explained variance and, when requested, draws the loading arrows. Both
#' are skipped when an axis adjustment or a split is active, since those change
#' the coordinate space the scores and loadings were computed in.
#'
#' @param fig The scatter figure.
#' @param p The `pca` object.
#' @param input The module's input.
#' @param isolate_fn The module's isolation helper.
#' @return The figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_biplot_layers
#' @keywords internal
.pca_biplot_layers <- function(fig, p, input, isolate_fn) {
    comps <- .pca_components(p)
    x <- isolate_fn(input$x.by)
    y <- isolate_fn(input$y.by)

    adjusted <- any(vapply(
        list(isolate_fn(input$x.adjustment), isolate_fn(input$x.adj.fxn),
            isolate_fn(input$y.adjustment), isolate_fn(input$y.adj.fxn)),
        nz_value, logical(1)
    ))
    if (!nz_value(x) || !nz_value(y) || adjusted || nz_value(isolate_fn(input$split.by))) {
        return(fig)
    }

    if (x %in% comps) fig$x$layout$xaxis$title$text <- .pca_axis_title(p, x)
    if (y %in% comps) fig$x$layout$yaxis$title$text <- .pca_axis_title(p, y)

    if (isTRUE(isolate_fn(input$show.loadings)) && x %in% comps && y %in% comps) {
        arrows <- .pca_loading_arrows(
            p, x, y,
            n = isolate_fn(input$n.top.loadings) %||% 5,
            length.factor = isolate_fn(input$loadings.length.factor) %||% 1.5
        )
        fig <- .pca_add_loading_arrows(
            fig, arrows,
            color = isolate_fn(input$loadings.color) %||% "#000000",
            label.size = isolate_fn(input$loadings.label.size) %||% 12
        )
    }
    fig
}


#' Build a standalone Shiny app for a PCAtools module
#'
#' [.sci_object_app()] over a named list of `pca` objects, previewing each
#' object's sample metadata.
#'
#' @param inputs_ui_fn,output_ui_fn,server_fn The module's functions.
#' @param pca_list A named list of PCAtools `pca` objects.
#' @param title Page title.
#' @return A [shiny::shinyApp()] object.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_module_app
#' @keywords internal
.pca_module_app <- function(inputs_ui_fn, output_ui_fn, server_fn, pca_list, title) {
    .sci_object_app(
        inputs_ui_fn, output_ui_fn, server_fn, pca_list, title,
        validate = function(p) .assert_pca(p, "pca_list element"),
        preview = function(p) {
            md <- p$metadata
            if (is.null(md)) data.frame(message = "This PCA object has no sample metadata.") else as.data.frame(md)
        },
        select_label = "Select PCA:",
        preview_title = "Sample Metadata",
        preview_note = "Read-only preview of the PCA object's sample metadata."
    )
}
