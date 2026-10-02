#' Molecular dynamics trajectory metrics plot
#'
#' Plots the standard summaries of a molecular dynamics simulation - RMSD or
#' radius of gyration over time, RMSF per residue, hydrogen-bond counts - as
#' one line per group (typically a replica or a series), optionally smoothed
#' with a running mean over the faded raw trace, and optionally faceted into
#' stacked panels (one per metric). It takes the long data frame
#' [read_xvg()] returns, or any table with an x, a value and a grouping column
#' (e.g. MDAnalysis or mdtraj output saved as CSV).
#'
#' @param df A data frame.
#' @param x,y Columns for the x-axis (time, frame or residue) and the value.
#' @param group Column whose levels get one line each, or `NULL`.
#' @param facet Column whose levels get one stacked panel each, or `NULL`.
#' @param smooth.window Width (in points) of the centred running mean; 0 or 1
#'   for none.
#' @param time.unit `"as is"`, `"ps to ns"` or `"ns to ps"`, applied to the x
#'   values when their label names that unit.
#' @param length.unit `"as is"`, `"nm to A"` or `"A to nm"`, applied to the
#'   values when their label names that unit.
#' @param show.raw Logical; draw the raw trace under the smoothed one.
#' @param raw.opacity Opacity of the raw trace when smoothing.
#' @param colors Named vector of colours for the groups.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with a summary table (per group and panel: points,
#'   mean, SD, and the mean over the second half, a rough equilibrated value)
#'   as attribute `"table"`.
#'
#' @import plotly
#' @importFrom stats sd
#' @seealso [read_xvg()], [mdTrajectoryMetricsServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' files <- system.file("extdata", sprintf("example_rmsd_rep%d.xvg.gz", 1:3),
#'     package = "sciVizModules")
#' rmsd <- do.call(rbind, Map(read_xvg, files, series = paste("replica", 1:3)))
#' mdTrajectoryMetrics(rmsd, smooth.window = 11, time.unit = "ps to ns")
mdTrajectoryMetrics <- function(df, x = "x", y = "value", group = "series", facet = NULL, smooth.window = 0,
                                time.unit = "as is", length.unit = "as is", show.raw = TRUE, raw.opacity = 0.3,
                                colors = NULL, main = NULL) {
    df <- as.data.frame(df)
    missing <- setdiff(c(x, y), names(df))
    if (length(missing)) stop("Column(s) not in the data: ", paste(missing, collapse = ", "), call. = FALSE)
    group <- if (nz_value(group) && group %in% names(df)) group else NULL
    facet <- if (nz_value(facet) && facet %in% names(df)) facet else NULL

    df$.x <- as.numeric(df[[x]])
    df$.y <- as.numeric(df[[y]])
    df$.group <- if (is.null(group)) "all" else as.character(df[[group]])
    df$.facet <- if (is.null(facet)) "all" else as.character(df[[facet]])
    df$.xlab <- if ("x.label" %in% names(df)) as.character(df$x.label) else x
    df$.ylab <- if ("y.label" %in% names(df)) as.character(df$y.label) else y
    df <- df[is.finite(df$.x) & is.finite(df$.y), , drop = FALSE]
    if (nrow(df) == 0) stop("No finite values to plot.", call. = FALSE)

    conv <- .md_convert(df$.x, df$.xlab, time.unit, "time")
    df$.x <- conv$values
    df$.xlab <- conv$labels
    conv <- .md_convert(df$.y, df$.ylab, length.unit, "length")
    df$.y <- conv$values
    df$.ylab <- conv$labels

    groups <- unique(df$.group)
    facets <- unique(df$.facet)
    palette <- resolve_palette(groups, NULL, default_palettes()[["choices"]][["Defaults"]][["dittoColors"]], colors)
    k <- suppressWarnings(as.integer(smooth.window))
    smoothing <- !is.na(k) && k > 1

    panels <- lapply(seq_along(facets), function(fi) {
        sub <- df[df$.facet == facets[fi], , drop = FALSE]
        p <- plot_ly()
        for (g in groups) {
            d <- sub[sub$.group == g, , drop = FALSE]
            if (nrow(d) == 0) next
            d <- d[order(d$.x), , drop = FALSE]
            show_legend <- fi == 1 && !is.null(group)
            if (!smoothing || isTRUE(show.raw)) {
                p <- add_trace(p, x = d$.x, y = d$.y, type = "scatter", mode = "lines", name = g, legendgroup = g,
                    showlegend = show_legend && !smoothing, opacity = if (smoothing) raw.opacity else 1,
                    line = list(color = palette[[g]], width = 1), hoverinfo = "x+y+name")
            }
            if (smoothing) {
                sm <- as.numeric(stats::filter(d$.y, rep(1 / k, k), sides = 2))
                p <- add_trace(p, x = d$.x, y = sm, type = "scatter", mode = "lines", name = g, legendgroup = g,
                    showlegend = show_legend, line = list(color = palette[[g]], width = 2),
                    hoverinfo = "x+y+name")
            }
        }
        layout(p,
            xaxis = list(title = list(text = sub$.xlab[1])),
            yaxis = list(title = list(text = if (is.null(facet)) sub$.ylab[1] else paste0(facets[fi], "<br>", sub$.ylab[1])))
        )
    })

    fig <- if (length(panels) == 1) {
        panels[[1]]
    } else {
        subplot(panels, nrows = length(panels), shareX = FALSE, titleX = TRUE, titleY = TRUE, margin = 0.06)
    }
    fig <- layout(fig, title = list(text = main %||% ""), showlegend = !is.null(group))

    table <- do.call(rbind, lapply(split(df, list(df$.facet, df$.group), drop = TRUE), function(d) {
        d <- d[order(d$.x), , drop = FALSE]
        half <- d$.y[d$.x >= stats::median(d$.x)]
        data.frame(panel = d$.facet[1], group = d$.group[1], points = nrow(d), mean = mean(d$.y),
            sd = if (nrow(d) > 1) stats::sd(d$.y) else NA_real_, mean.second.half = mean(half),
            stringsAsFactors = FALSE)
    }))
    rownames(table) <- NULL
    attr(fig, "table") <- table
    fig
}


#' Convert time or length units when the label names them
#'
#' @param values Numeric values.
#' @param labels Their axis labels, e.g. `"Time (ps)"` or `"RMSD (nm)"`.
#' @param unit The requested conversion.
#' @param kind `"time"` or `"length"`.
#' @return A list of converted `values` and relabelled `labels`. Values whose
#'   label does not name the source unit are left alone.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_md_convert
#' @keywords internal
.md_convert <- function(values, labels, unit, kind) {
    rules <- list(
        "ps to ns" = list(from = "ps", to = "ns", factor = 1e-3),
        "ns to ps" = list(from = "ns", to = "ps", factor = 1e3),
        "nm to A" = list(from = "nm", to = "A", factor = 10),
        "A to nm" = list(from = "A", to = "nm", factor = 0.1)
    )
    rule <- rules[[unit %||% "as is"]]
    if (is.null(rule)) {
        return(list(values = values, labels = labels))
    }
    pattern <- paste0("[(]", rule$from, "[)]")
    hit <- grepl(pattern, labels)
    values[hit] <- values[hit] * rule$factor
    labels[hit] <- sub(pattern, paste0("(", rule$to, ")"), labels[hit])
    list(values = values, labels = labels)
}


#' The bundled molecular dynamics example
#'
#' @return A list of two data frames read with [read_xvg()]: `trajectory` (the
#'   three RMSD replicas and the radius of gyration, with `metric` naming each)
#'   and `rmsf` (per-residue fluctuations).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_md_example
#' @keywords internal
.md_example <- function() {
    ext <- function(f) system.file("extdata", f, package = "sciVizModules")
    rmsd <- do.call(rbind, lapply(1:3, function(i) {
        read_xvg(ext(sprintf("example_rmsd_rep%d.xvg.gz", i)), series = paste("replica", i))
    }))
    rg <- read_xvg(ext("example_gyrate.xvg.gz"))
    rg <- rg[rg$series == "Rg", , drop = FALSE]
    rg$series <- "replica 1"
    rg$metric <- "Radius of gyration"
    list(trajectory = rbind(rmsd, rg), rmsf = read_xvg(ext("example_rmsf.xvg.gz"), series = "replica 1"))
}
