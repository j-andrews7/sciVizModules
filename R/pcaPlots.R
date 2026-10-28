#' Scree plot of a PCAtools `pca` object
#'
#' The interactive counterpart of [PCAtools::screeplot()]: the percentage of
#' variance each component explains, with the cumulative percentage as a line.
#' The elbow of the curve ([PCAtools::findElbowPoint()], when PCAtools is
#' installed) and any other components you choose (e.g. the number retained by
#' [PCAtools::parallelPCA()], which needs the original data matrix) can be
#' marked with vertical lines.
#'
#' @param pcaobj A PCAtools `pca` object.
#' @param components Components to show, by name. Default: the first 20.
#' @param show.cumulative Logical; draw the cumulative percentage line.
#' @param show.elbow Logical; mark the elbow component.
#' @param mark.components Integer indices of further components to mark.
#' @param bar.color,line.color Colours of the bars and the cumulative line.
#' @param main Optional plot title.
#'
#' @return A `plotly` object. The table it draws is attached as attribute `"table"`.
#'
#' @import plotly
#' @seealso [pcaScreePlotServer()], [PCAtools::screeplot()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_pca)
#' pcaScreePlot(example_pca)
pcaScreePlot <- function(pcaobj, components = NULL, show.cumulative = TRUE, show.elbow = TRUE,
                         mark.components = NULL, bar.color = "#1E90FF", line.color = "#CD2626",
                         main = NULL) {
    .assert_pca(pcaobj, "pcaobj")
    comps <- .pca_components(pcaobj)
    components <- if (length(components)) intersect(components, comps) else utils::head(comps, 20)
    if (length(components) == 0) stop("None of the requested components are in the PCA.", call. = FALSE)
    v <- unname(pcaobj$variance)
    idx <- match(components, comps)
    tab <- data.frame(
        component = components, variance = v[idx], cumulative = cumsum(v)[idx],
        stringsAsFactors = FALSE
    )
    tab$component <- factor(tab$component, levels = components)
    hover <- sprintf("%s<br>Explained: %.2f%%<br>Cumulative: %.2f%%", tab$component, tab$variance, tab$cumulative)

    fig <- plot_ly(tab) |>
        add_bars(x = ~component, y = ~variance, name = "Explained", text = hover, hoverinfo = "text",
            textposition = "none", marker = list(color = bar.color))
    if (isTRUE(show.cumulative)) {
        fig <- add_trace(fig, x = ~component, y = ~cumulative, type = "scatter", mode = "lines+markers",
            name = "Cumulative", text = hover, hoverinfo = "text",
            line = list(color = line.color, width = 2), marker = list(color = line.color, size = 7))
    }

    marks <- list()
    elbow <- if (isTRUE(show.elbow)) .pca_elbow(pcaobj) else NULL
    if (length(elbow)) marks[["Elbow"]] <- elbow
    for (m in mark.components) marks[[paste0("PC", m)]] <- m
    shapes <- list()
    annos <- list()
    for (lab in names(marks)) {
        pos <- match(comps[marks[[lab]]], components)
        if (is.na(pos)) next
        shapes[[length(shapes) + 1]] <- list(
            type = "line", x0 = pos - 1, x1 = pos - 1, xref = "x", y0 = 0, y1 = 1, yref = "paper",
            line = list(color = "#000000", dash = "dash", width = 1)
        )
        annos[[length(annos) + 1]] <- list(
            x = pos - 1, xref = "x", y = 1, yref = "paper", yanchor = "bottom",
            text = if (identical(lab, "Elbow")) paste0("Elbow (", comps[marks[[lab]]], ")") else lab,
            showarrow = FALSE
        )
    }

    fig <- layout(fig,
        title = list(text = main %||% ""),
        xaxis = list(title = list(text = "Principal component"), type = "category"),
        yaxis = list(title = list(text = "Explained variance (%)"), range = c(0, 105)),
        shapes = shapes, annotations = annos
    )
    attr(fig, "table") <- tab
    fig
}


#' Loadings plot of a PCAtools `pca` object
#'
#' The interactive counterpart of [PCAtools::plotloadings()]. For each chosen
#' component, the variables whose loading lies within `range.retain` of either
#' end of that component's loading range are retained (PCAtools' `rangeRetain`
#' rule), and every retained variable's loading is drawn on every chosen
#' component, coloured by its value.
#'
#' @param pcaobj A PCAtools `pca` object.
#' @param components Components to show, by name. Default: the first 5.
#' @param range.retain Fraction of each component's loading range, at either end,
#'   within which variables are retained.
#' @param absolute Logical; plot absolute loadings.
#' @param low.color,mid.color,high.color Colour scale for negative, zero and
#'   positive loadings.
#' @param point.size Marker size.
#' @param show.labels Logical; label each point with its variable name.
#' @param label.size Label font size.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the long table it draws as attribute `"table"`.
#'
#' @import plotly
#' @seealso [pcaLoadingsPlotServer()], [PCAtools::plotloadings()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_pca)
#' pcaLoadingsPlot(example_pca, components = c("PC1", "PC2"))
pcaLoadingsPlot <- function(pcaobj, components = NULL, range.retain = 0.05, absolute = FALSE,
                            low.color = "#FFD700", mid.color = "#FFFFFF", high.color = "#4169E1",
                            point.size = 12, show.labels = TRUE, label.size = 10, main = NULL) {
    .assert_pca(pcaobj, "pcaobj")
    comps <- .pca_components(pcaobj)
    components <- if (length(components)) intersect(components, comps) else utils::head(comps, 5)
    if (length(components) == 0) stop("None of the requested components are in the PCA.", call. = FALSE)

    ld <- as.data.frame(pcaobj$loadings)[, components, drop = FALSE]
    retain <- .pca_retained_loadings(ld, range.retain)
    ld <- ld[retain, , drop = FALSE]

    tab <- data.frame(
        variable = rep(rownames(ld), times = length(components)),
        component = factor(rep(components, each = nrow(ld)), levels = components),
        loading = unlist(ld, use.names = FALSE),
        stringsAsFactors = FALSE
    )
    tab$value <- if (isTRUE(absolute)) abs(tab$loading) else tab$loading
    lim <- max(abs(tab$value), na.rm = TRUE)

    fig <- plot_ly(tab,
        x = ~component, y = ~value, type = "scatter",
        mode = if (isTRUE(show.labels)) "markers+text" else "markers",
        text = ~variable, textposition = "middle right", textfont = list(size = label.size),
        hovertext = sprintf("%s<br>%s loading: %.4f", tab$variable, tab$component, tab$loading),
        hoverinfo = "text", showlegend = FALSE,
        marker = list(
            color = tab$value, size = point.size,
            colorscale = list(c(0, low.color), c(0.5, mid.color), c(1, high.color)),
            cmin = if (isTRUE(absolute)) 0 else -lim, cmax = lim,
            line = list(color = "#000000", width = 1),
            showscale = TRUE, colorbar = list(title = list(text = if (isTRUE(absolute)) "|Loading|" else "Loading"))
        )
    )
    fig <- layout(fig,
        title = list(text = main %||% ""),
        xaxis = list(title = list(text = "Principal component"), type = "category"),
        yaxis = list(title = list(text = if (isTRUE(absolute)) "Absolute loading" else "Component loading")),
        shapes = if (isTRUE(absolute)) list() else list(list(
            type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0, y1 = 0, yref = "y",
            line = list(color = "#000000", dash = "dash", width = 1)
        ))
    )
    attr(fig, "table") <- tab
    fig
}


#' Variables retained by PCAtools' `rangeRetain` rule
#'
#' @param ld A data frame of loadings (variables x components).
#' @param range.retain Fraction of each component's loading range.
#' @return Integer row indices of the retained variables, in first-retained order.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pca_retained_loadings
#' @keywords internal
.pca_retained_loadings <- function(ld, range.retain) {
    retain <- integer(0)
    for (i in seq_along(ld)) {
        x <- ld[[i]]
        offset <- (max(x) - min(x)) * range.retain
        retain <- unique(c(retain, which(x >= max(x) - offset), which(x <= min(x) + offset)))
    }
    retain
}


#' Pairs plot of a PCAtools `pca` object
#'
#' The interactive counterpart of [PCAtools::pairsplot()]: a lower-triangle grid
#' of sample-score scatters for every pair of the chosen components, sharing one
#' x-axis per column and one y-axis per row, coloured and shaped by sample
#' metadata.
#'
#' @param pcaobj A PCAtools `pca` object.
#' @param components Components to pair, by name. Default: the first 4.
#' @param color.by,shape.by Metadata columns to colour and shape the points by, or `NULL`.
#' @param colors Named vector of colours for the `color.by` levels. Unnamed
#'   levels fall back to the default palette.
#' @param point.size Marker size.
#' @param opacity Marker opacity.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the scores table as attribute `"table"`.
#'
#' @import plotly
#' @seealso [pcaPairsPlotServer()], [PCAtools::pairsplot()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_pca)
#' pcaPairsPlot(example_pca, color.by = "dex", shape.by = "cell")
pcaPairsPlot <- function(pcaobj, components = NULL, color.by = NULL, shape.by = NULL, colors = NULL,
                         point.size = 8, opacity = 1, main = NULL) {
    .assert_pca(pcaobj, "pcaobj")
    comps <- .pca_components(pcaobj)
    components <- if (length(components)) intersect(components, comps) else utils::head(comps, 4)
    k <- length(components)
    if (k < 2) stop("Choose at least two components to pair.", call. = FALSE)

    df <- .pca_scores_df(pcaobj)
    color.by <- if (nz_value(color.by) && color.by %in% names(df)) color.by else NULL
    shape.by <- if (nz_value(shape.by) && shape.by %in% names(df)) shape.by else NULL

    groups <- if (is.null(color.by)) "All" else unique(as.character(df[[color.by]]))
    group_of <- if (is.null(color.by)) rep("All", nrow(df)) else as.character(df[[color.by]])
    palette <- resolve_palette(groups, NULL, default_palettes()[["choices"]][["Defaults"]][["dittoColors"]], colors)
    symbols <- c("circle", "square", "diamond", "triangle-up", "cross", "x", "triangle-down", "star")
    shape_levels <- if (is.null(shape.by)) NULL else unique(as.character(df[[shape.by]]))
    symbol_of <- if (is.null(shape.by)) {
        rep("circle", nrow(df))
    } else {
        symbols[(match(as.character(df[[shape.by]]), shape_levels) - 1) %% length(symbols) + 1]
    }
    hover <- paste0(
        "<b>", df$sample, "</b>",
        if (!is.null(color.by)) paste0("<br>", color.by, ": ", group_of) else "",
        if (!is.null(shape.by)) paste0("<br>", shape.by, ": ", df[[shape.by]]) else ""
    )

    panels <- list()
    first <- TRUE
    for (r in seq_len(k - 1)) {
        for (cc in seq_len(k - 1)) {
            if (cc > r) {
                panels[[length(panels) + 1]] <- plotly_empty(type = "scatter", mode = "markers")
                next
            }
            xc <- components[cc]
            yc <- components[r + 1]
            p <- plot_ly()
            for (g in groups) {
                sel <- group_of == g
                p <- add_trace(p,
                    x = df[[xc]][sel], y = df[[yc]][sel], type = "scatter", mode = "markers",
                    name = g, legendgroup = g, showlegend = first && !is.null(color.by),
                    text = paste0(hover[sel], "<br>", xc, ": ", signif(df[[xc]][sel], 4), "<br>", yc, ": ",
                        signif(df[[yc]][sel], 4)),
                    hoverinfo = "text",
                    marker = list(color = palette[[g]], symbol = symbol_of[sel], size = point.size,
                        opacity = opacity, line = list(color = "#000000", width = 0.5))
                )
            }
            first <- FALSE
            panels[[length(panels) + 1]] <- p
        }
    }

    fig <- subplot(panels, nrows = k - 1, shareX = TRUE, shareY = TRUE, margin = 0.02)
    # The upper triangle's placeholders only hold its cells in the grid; left in,
    # they make each cell a panel that draws the shared axes' gridlines.
    fig$x$data <- Filter(function(tr) any(!is.na(unlist(tr[["x"]]))), fig$x$data)
    for (cc in seq_len(k - 1)) {
        key <- if (cc == 1) "xaxis" else paste0("xaxis", cc)
        fig$x$layout[[key]]$title <- list(text = .pca_axis_title(pcaobj, components[cc]))
    }
    for (r in seq_len(k - 1)) {
        key <- if (r == 1) "yaxis" else paste0("yaxis", r)
        fig$x$layout[[key]]$title <- list(text = .pca_axis_title(pcaobj, components[r + 1]))
    }
    fig <- layout(fig, title = list(text = main %||% ""))
    attr(fig, "table") <- df
    fig
}


#' PC-metadata correlation plot of a PCAtools `pca` object
#'
#' The interactive counterpart of [PCAtools::eigencorplot()]: the correlation of
#' each component's sample scores with each metadata variable, as a heatmap with
#' the coefficient and its significance in every cell. Non-numeric metadata are
#' converted to integer codes (factor level order), as PCAtools requires numeric
#' variables; their labels say so.
#'
#' @param pcaobj A PCAtools `pca` object.
#' @param components Components to correlate, by name. Default: the first 10.
#' @param metavars Metadata columns to correlate. Default: all of them.
#' @param cor.method `"pearson"`, `"spearman"` or `"kendall"`.
#' @param p.adjust.method A [stats::p.adjust()] method, applied across every cell.
#' @param plot.rsquared Logical; show R-squared instead of the signed coefficient.
#' @param low.color,mid.color,high.color Colour scale. For R-squared, the scale
#'   runs from `mid.color` to `high.color`.
#' @param show.values Logical; print the value and significance stars in each cell.
#' @param digits Decimal places of the printed values.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the long correlation table (coefficient,
#'   p-value, adjusted p-value) as attribute `"table"`.
#'
#' @import plotly
#' @importFrom stats cor.test p.adjust
#' @seealso [pcaEigencorPlotServer()], [PCAtools::eigencorplot()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_pca)
#' pcaEigencorPlot(example_pca, components = paste0("PC", 1:5))
pcaEigencorPlot <- function(pcaobj, components = NULL, metavars = NULL, cor.method = "pearson",
                            p.adjust.method = "none", plot.rsquared = FALSE,
                            low.color = "#00008B", mid.color = "#FFFFFF", high.color = "#8B0000",
                            show.values = TRUE, digits = 2, main = NULL) {
    .assert_pca(pcaobj, "pcaobj")
    meta <- as.data.frame(pcaobj$metadata %||% data.frame())
    if (ncol(meta) == 0) stop("This PCA object has no sample metadata to correlate.", call. = FALSE)
    comps <- .pca_components(pcaobj)
    components <- if (length(components)) intersect(components, comps) else utils::head(comps, 10)
    metavars <- if (length(metavars)) intersect(metavars, names(meta)) else names(meta)
    if (length(components) == 0 || length(metavars) == 0) {
        stop("Choose at least one component and one metadata variable.", call. = FALSE)
    }

    scores <- as.data.frame(pcaobj$rotated)
    labels <- vapply(metavars, function(m) {
        if (is.numeric(meta[[m]])) m else paste0(m, " (coded)")
    }, character(1))

    tab <- expand.grid(metavar = metavars, component = components, stringsAsFactors = FALSE)
    tab$label <- labels[tab$metavar]
    res <- t(mapply(function(m, cc) {
        x <- meta[[m]]
        if (!is.numeric(x)) x <- as.numeric(factor(x))
        ct <- tryCatch(
            suppressWarnings(stats::cor.test(x, scores[[cc]], method = cor.method)),
            error = function(e) NULL
        )
        if (is.null(ct)) c(NA_real_, NA_real_) else c(unname(ct$estimate), ct$p.value)
    }, tab$metavar, tab$component))
    tab$r <- res[, 1]
    tab$r2 <- tab$r^2
    tab$p.value <- res[, 2]
    tab$p.adj <- stats::p.adjust(tab$p.value, method = p.adjust.method)
    tab$stars <- as.character(cut(tab$p.adj, c(-Inf, 0.001, 0.01, 0.05, Inf), c("***", "**", "*", "")))
    tab$stars[is.na(tab$stars)] <- ""

    value <- if (isTRUE(plot.rsquared)) tab$r2 else tab$r
    z <- matrix(value, nrow = length(metavars), dimnames = list(labels, components))
    cell <- matrix(
        ifelse(is.na(value), "", paste0(formatC(value, digits = digits, format = "f"), tab$stars)),
        nrow = length(metavars)
    )
    hover <- matrix(sprintf(
        "%s vs %s<br>r = %.3f<br>p = %s<br>adj. p = %s",
        tab$label, tab$component, tab$r, format.pval(tab$p.value, digits = 2),
        format.pval(tab$p.adj, digits = 2)
    ), nrow = length(metavars))

    scale <- if (isTRUE(plot.rsquared)) {
        list(c(0, mid.color), c(1, high.color))
    } else {
        list(c(0, low.color), c(0.5, mid.color), c(1, high.color))
    }
    fig <- plot_ly(
        x = components, y = unname(labels), z = z, type = "heatmap",
        colorscale = scale, zmin = if (isTRUE(plot.rsquared)) 0 else -1, zmax = 1,
        text = cell, texttemplate = if (isTRUE(show.values)) "%{text}" else "",
        customdata = hover, hovertemplate = "%{customdata}<extra></extra>",
        colorbar = list(title = list(text = if (isTRUE(plot.rsquared)) "R\u00b2" else "r"))
    )
    fig <- layout(fig,
        title = list(text = main %||% ""),
        xaxis = list(title = list(text = "Principal component"), type = "category"),
        yaxis = list(title = list(text = ""), type = "category", autorange = "reversed")
    )
    attr(fig, "table") <- tab
    fig
}
