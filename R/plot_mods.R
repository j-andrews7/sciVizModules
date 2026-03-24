# Shared plotly helper utilities for sciVizModules
#
# This file mirrors the role of plot_mods.R in VizModules.  It contains the
# lower-level helpers used by the survival curve (and future) modules:
#   - Null-coalescing operator
#   - Default colour palette constant
#   - Step-function data transformation for KM curves
#   - Reference-line helpers (h/v/ab lines on plotly figures)
#   - Axis-style list builder from uniform Shiny inputs
#   - Plot config builder
#   - Download handler factory


# ---- Null-coalescing operator ----------------------------------------------
# Used across server files; defined once here.
`%||%` <- function(x, y) {
    if (!is.null(x) && length(x) > 0 && !is.na(x[1]) &&
        nzchar(as.character(x[1]))) x else y
}


# ---- Colour-by column helpers ----------------------------------------------

#' Return categorical column choices for a colour-by selector
#'
#' @param df A data frame.
#' @return A character vector: `"None"` followed by the names of all
#'   non-numeric columns in `df`, or just `"None"` when there are none.
#' @noRd
.colour_by_choices <- function(df) {
    cat_cols <- names(df)[vapply(df, function(x) !is.numeric(x), logical(1))]
    if (length(cat_cols) > 0) c("None", cat_cols) else "None"
}

#' Guess the best default colour-by column
#'
#' Prefers columns whose names match common grouping terms
#' (`group`, `strata`, `arm`, `treatment`, `cohort`); falls back to the first
#' non-numeric column, or `"None"` when no categorical columns exist.
#'
#' @param df A data frame.
#' @return A single string: the column name to use as the default, or
#'   `"None"`.
#' @noRd
.default_colour_by <- function(df) {
    cat_cols <- names(df)[vapply(df, function(x) !is.numeric(x), logical(1))]
    found <- grep("^group$|^strata$|^arm$|^treatment$|^cohort$",
                  cat_cols, value = TRUE, ignore.case = TRUE)
    if (length(found) > 0) return(found[1])
    if (length(cat_cols) > 0) return(cat_cols[1])
    "None"
}


# ---- Default colour palette (colourblind-friendly) -------------------------
.default_sci_palette <- c(
    "#E69F00", "#56B4E9", "#009E73", "#F0E442",
    "#0072B2", "#D55E00", "#CC79A7", "#000000"
)


# ---- Step-function data transformation for survival curves -----------------

#' Convert survival data to a plotly step-function format
#'
#' Expands a KM summary data frame so that each row \eqn{(t_i, s_i)} becomes
#' two rows — a horizontal segment at the previous survival level followed by a
#' vertical drop to the current level — creating a staircase step shape when
#' plotted as a line.
#'
#' The function handles an optional grouping column so that multiple groups can
#' be processed together and the group label is preserved in the result.
#'
#' @param df Input data frame ordered (or sortable) by `time_col`.
#' @param time_col Name of the time column.
#' @param surv_col Name of the survival column (0–1 scale).  Values are
#'   **multiplied by 100** in the output to give a percentage y-axis.
#' @param group_col Optional name of a categorical grouping column.
#'
#' @return A data frame whose rows are the expanded step-function points.  Only
#'   the `time_col`, `surv_col`, and (when provided) `group_col` columns are
#'   retained.
#'
#' @author Jacob Martin, Jared Andrews
#' @noRd
.survival_to_step <- function(df, time_col, surv_col, group_col = NULL) {
    if (!is.null(group_col) && group_col %in% names(df)) {
        groups      <- unique(df[[group_col]])
        result_list <- lapply(groups, function(g) {
            grp_data <- df[df[[group_col]] == g, , drop = FALSE]
            grp_data <- grp_data[order(grp_data[[time_col]]), ]
            step     <- .make_survival_steps(grp_data, time_col, surv_col)
            step[[group_col]] <- g
            step
        })
        do.call(rbind, result_list)
    } else {
        df <- df[order(df[[time_col]]), ]
        .make_survival_steps(df, time_col, surv_col)
    }
}


#' Build step-function rows for a single group
#'
#' @param df       Data frame for one group, sorted by time.
#' @param time_col Name of the time column.
#' @param surv_col Name of the survival column.
#' @return A data frame with two-column step-function points (time × survival %).
#' @noRd
.make_survival_steps <- function(df, time_col, surv_col) {
    n <- nrow(df)
    if (n == 0) {
        result        <- df[0, c(time_col, surv_col), drop = FALSE]
        return(result)
    }

    times     <- df[[time_col]]
    survivals <- df[[surv_col]] * 100   # convert 0–1 → %

    new_times     <- times[1]
    new_survivals <- survivals[1]

    if (n > 1) {
        for (i in 2:n) {
            # Horizontal: stay at previous level until current time
            new_times     <- c(new_times,     times[i])
            new_survivals <- c(new_survivals, survivals[i - 1])
            # Vertical: drop to new survival at the same time
            new_times     <- c(new_times,     times[i])
            new_survivals <- c(new_survivals, survivals[i])
        }
    }

    result              <- data.frame(a = new_times, b = new_survivals,
                                      stringsAsFactors = FALSE)
    names(result)       <- c(time_col, surv_col)
    result
}


# ---- Axis-style helper -----------------------------------------------------

#' Build a plotly axis style list from uniform Shiny inputs
#'
#' Reads the axis-related inputs created by
#' `VizModules:::.uniform_axes_inputs_ui()` and assembles them into the named
#' list expected by `plotly::layout(xaxis = …)` or `plotly::layout(yaxis = …)`.
#'
#' @param input     Shiny input object.
#' @param axis_side `"x"` or `"y"`.
#' @param isolate_fn Wrapper function – either `identity` (auto-update) or
#'   `shiny::isolate` (manual update).
#' @param title     Optional title string for the axis.
#'
#' @return A named list suitable for `plotly::layout()`.
#' @noRd
.build_axis_style <- function(input, axis_side = c("x", "y"),
                               isolate_fn = identity,
                               title = NULL) {
    axis_side <- match.arg(axis_side)

    show_grid <- if (axis_side == "x") {
        isolate_fn(input$show.grid.x)
    } else {
        isolate_fn(input$show.grid.y)
    }

    tick_angle <- if (axis_side == "x") {
        isolate_fn(input$axis.tickangle.x)
    } else {
        isolate_fn(input$axis.tickangle.y)
    }

    style <- list(
        showline  = isolate_fn(input$axis.showline),
        mirror    = isolate_fn(input$axis.mirror),
        linecolor = isolate_fn(input$axis.linecolor),
        linewidth = isolate_fn(input$axis.linewidth),
        tickfont  = list(
            size   = isolate_fn(input$axis.tickfont.size),
            color  = isolate_fn(input$axis.tickfont.color),
            family = isolate_fn(input$axis.tickfont.family)
        ),
        tickangle = tick_angle,
        ticks     = isolate_fn(input$axis.ticks),
        tickcolor = isolate_fn(input$axis.tickcolor),
        ticklen   = isolate_fn(input$axis.ticklen),
        tickwidth = isolate_fn(input$axis.tickwidth),
        showgrid  = show_grid
    )

    if (!is.null(title)) {
        style$title <- list(
            text = title,
            font = list(
                size   = isolate_fn(input$axis.title.font.size),
                color  = isolate_fn(input$axis.title.font.color),
                family = isolate_fn(input$axis.title.font.family)
            )
        )
    }

    style
}


# ---- Reference-line helpers (ported from VizModules::plot_mods.R) ----------

#' Parse a comma-separated numeric string to a vector
#' @noRd
.sci_parse_numeric_list <- function(text) {
    if (is.null(text) || !nzchar(trimws(text))) return(NULL)
    vals <- suppressWarnings(as.numeric(trimws(unlist(strsplit(text, ",")))))
    vals <- vals[!is.na(vals)]
    if (length(vals) == 0) NULL else vals
}

#' Recycle a style vector to length n
#' @noRd
.sci_recycle_style <- function(values, n, default) {
    if (is.null(values) || length(values) == 0) return(rep(default, n))
    if (length(values) == n) return(values)
    rep(values[1], n)
}

#' Convert linetype name strings (comma-separated) to a character vector
#' @noRd
.sci_string_to_linetypes <- function(text) {
    if (is.null(text) || !nzchar(trimws(text))) return("solid")
    trimws(unlist(strsplit(text, ",")))
}

#' Map ggplot2/survival linetype names to plotly dash names
#' @noRd
.sci_linetype_to_dash <- function(linetype) {
    switch(tolower(trimws(linetype)),
        "solid"     = "solid",
        "dashed"    = "dash",
        "dotted"    = "dot",
        "dotdash"   = "dashdot",
        "longdash"  = "longdash",
        "twodash"   = "longdashdot",
        "dash"      = "dash",
        "dot"       = "dot",
        "dashdot"   = "dashdot",
        "longdashdot" = "longdashdot",
        "solid"
    )
}

#' Build horizontal line shapes for a plotly figure
#' @noRd
.sci_add_hlines <- function(fig, intercepts,
                             colors = "#000000", widths = 1,
                             linetypes = "solid", opacities = 1) {
    if (is.null(intercepts) || length(intercepts) == 0) return(list())
    n         <- length(intercepts)
    colors    <- .sci_recycle_style(colors,    n, "#000000")
    widths    <- .sci_recycle_style(widths,    n, 1)
    linetypes <- .sci_recycle_style(linetypes, n, "solid")
    opacities <- .sci_recycle_style(opacities, n, 1)

    axis_pairs <- unique(lapply(fig$x$data, function(tr) {
        list(x = if (is.null(tr$xaxis)) "x" else tr$xaxis,
             y = if (is.null(tr$yaxis)) "y" else tr$yaxis)
    }))
    if (length(axis_pairs) == 0) axis_pairs <- list(list(x = "x", y = "y"))

    all_shapes <- list()
    for (pair in axis_pairs) {
        for (i in seq_len(n)) {
            all_shapes <- c(all_shapes, list(list(
                type = "line",
                x0 = 0, x1 = 1, xref = paste0(pair$x, " domain"),
                y0 = intercepts[i], y1 = intercepts[i], yref = pair$y,
                line = list(color = colors[i], width = widths[i],
                            dash = .sci_linetype_to_dash(linetypes[i])),
                opacity = opacities[i]
            )))
        }
    }
    all_shapes
}

#' Build vertical line shapes for a plotly figure
#' @noRd
.sci_add_vlines <- function(fig, intercepts,
                             colors = "#000000", widths = 1,
                             linetypes = "solid", opacities = 1) {
    if (is.null(intercepts) || length(intercepts) == 0) return(list())
    n         <- length(intercepts)
    colors    <- .sci_recycle_style(colors,    n, "#000000")
    widths    <- .sci_recycle_style(widths,    n, 1)
    linetypes <- .sci_recycle_style(linetypes, n, "solid")
    opacities <- .sci_recycle_style(opacities, n, 1)

    axis_pairs <- unique(lapply(fig$x$data, function(tr) {
        list(x = if (is.null(tr$xaxis)) "x" else tr$xaxis,
             y = if (is.null(tr$yaxis)) "y" else tr$yaxis)
    }))
    if (length(axis_pairs) == 0) axis_pairs <- list(list(x = "x", y = "y"))

    all_shapes <- list()
    for (pair in axis_pairs) {
        for (i in seq_len(n)) {
            all_shapes <- c(all_shapes, list(list(
                type = "line",
                x0 = intercepts[i], x1 = intercepts[i], xref = pair$x,
                y0 = 0, y1 = 1, yref = paste0(pair$y, " domain"),
                line = list(color = colors[i], width = widths[i],
                            dash = .sci_linetype_to_dash(linetypes[i])),
                opacity = opacities[i]
            )))
        }
    }
    all_shapes
}

#' Build diagonal (abline) shapes for a plotly figure
#' @noRd
.sci_add_ablines <- function(fig, slopes, intercepts,
                              colors = "#000000", widths = 1,
                              linetypes = "solid", opacities = 1) {
    if (is.null(slopes) || length(slopes) == 0 ||
        is.null(intercepts) || length(intercepts) == 0) return(list())
    n         <- max(length(slopes), length(intercepts))
    if (length(slopes) < n)     slopes     <- rep(slopes[1], n)
    if (length(intercepts) < n) intercepts <- rep(intercepts[1], n)
    colors    <- .sci_recycle_style(colors,    n, "#000000")
    widths    <- .sci_recycle_style(widths,    n, 1)
    linetypes <- .sci_recycle_style(linetypes, n, "solid")
    opacities <- .sci_recycle_style(opacities, n, 1)

    axis_pairs <- unique(lapply(fig$x$data, function(tr) {
        list(x = if (is.null(tr$xaxis)) "x" else tr$xaxis,
             y = if (is.null(tr$yaxis)) "y" else tr$yaxis)
    }))
    if (length(axis_pairs) == 0) axis_pairs <- list(list(x = "x", y = "y"))

    all_shapes <- list()
    for (pair in axis_pairs) {
        xaxis_name <- paste0("xaxis", sub("^x", "", pair$x))
        xaxis      <- fig$x$layout[[xaxis_name]]
        x_range    <- if (!is.null(xaxis)) xaxis$range else NULL
        if (is.null(x_range)) {
            x_data  <- unlist(lapply(fig$x$data, function(tr) {
                if ((if (is.null(tr$xaxis)) "x" else tr$xaxis) == pair$x) tr$x
            }))
            x_range <- if (length(x_data) > 0) {
                r <- range(x_data, na.rm = TRUE)
                c(r[1] - diff(r) * 0.1, r[2] + diff(r) * 0.1)
            } else {
                c(0, 1)
            }
        }
        for (i in seq_len(n)) {
            x0 <- x_range[1]; x1 <- x_range[2]
            all_shapes <- c(all_shapes, list(list(
                type = "line",
                x0 = x0, x1 = x1, xref = pair$x,
                y0 = intercepts[i] + slopes[i] * x0,
                y1 = intercepts[i] + slopes[i] * x1, yref = pair$y,
                line = list(color = colors[i], width = widths[i],
                            dash = .sci_linetype_to_dash(linetypes[i])),
                opacity = opacities[i]
            )))
        }
    }
    all_shapes
}

#' Add reference lines (h/v/ab) to a plotly figure from Shiny inputs
#'
#' Parses the comma-separated text inputs created by
#' `VizModules:::.uniform_lines_inputs_ui()` and adds the corresponding
#' horizontal, vertical, and/or diagonal lines to the figure.
#'
#' @param fig Plotly figure.
#' @param hline.intercepts,hline.colors,hline.widths,hline.linetypes,hline.opacities
#'   Comma-separated strings for horizontal lines.
#' @param vline.intercepts,vline.colors,vline.widths,vline.linetypes,vline.opacities
#'   Comma-separated strings for vertical lines.
#' @param abline.slopes,abline.intercepts,abline.colors,abline.widths,abline.linetypes,abline.opacities
#'   Comma-separated strings for diagonal lines.
#' @return Modified plotly figure.
#' @noRd
.sci_add_reference_lines <- function(
        fig,
        hline.intercepts = NULL, hline.colors = NULL,
        hline.widths = NULL, hline.linetypes = NULL, hline.opacities = NULL,
        vline.intercepts = NULL, vline.colors = NULL,
        vline.widths = NULL, vline.linetypes = NULL, vline.opacities = NULL,
        abline.slopes = NULL, abline.intercepts = NULL, abline.colors = NULL,
        abline.widths = NULL, abline.linetypes = NULL, abline.opacities = NULL) {

    all_shapes <- fig$x$layout$shapes
    if (is.null(all_shapes)) all_shapes <- list()

    # Horizontal lines
    h_int <- .sci_parse_numeric_list(hline.intercepts)
    if (!is.null(h_int)) {
        h_col <- if (!is.null(hline.colors) && nzchar(hline.colors))
            trimws(unlist(strsplit(hline.colors, ","))) else "#000000"
        h_w   <- .sci_parse_numeric_list(hline.widths);   if (is.null(h_w)) h_w <- 1
        h_lt  <- .sci_string_to_linetypes(hline.linetypes)
        h_op  <- .sci_parse_numeric_list(hline.opacities); if (is.null(h_op)) h_op <- 1
        all_shapes <- c(all_shapes, .sci_add_hlines(fig, h_int, h_col, h_w, h_lt, h_op))
    }

    # Vertical lines
    v_int <- .sci_parse_numeric_list(vline.intercepts)
    if (!is.null(v_int)) {
        v_col <- if (!is.null(vline.colors) && nzchar(vline.colors))
            trimws(unlist(strsplit(vline.colors, ","))) else "#000000"
        v_w   <- .sci_parse_numeric_list(vline.widths);   if (is.null(v_w)) v_w <- 1
        v_lt  <- .sci_string_to_linetypes(vline.linetypes)
        v_op  <- .sci_parse_numeric_list(vline.opacities); if (is.null(v_op)) v_op <- 1
        all_shapes <- c(all_shapes, .sci_add_vlines(fig, v_int, v_col, v_w, v_lt, v_op))
    }

    # Diagonal lines
    ab_sl  <- .sci_parse_numeric_list(abline.slopes)
    ab_int <- .sci_parse_numeric_list(abline.intercepts)
    if (!is.null(ab_sl) && !is.null(ab_int)) {
        ab_col <- if (!is.null(abline.colors) && nzchar(abline.colors))
            trimws(unlist(strsplit(abline.colors, ","))) else "#000000"
        ab_w   <- .sci_parse_numeric_list(abline.widths);   if (is.null(ab_w)) ab_w <- 1
        ab_lt  <- .sci_string_to_linetypes(abline.linetypes)
        ab_op  <- .sci_parse_numeric_list(abline.opacities); if (is.null(ab_op)) ab_op <- 1
        all_shapes <- c(all_shapes, .sci_add_ablines(fig, ab_sl, ab_int, ab_col, ab_w, ab_lt, ab_op))
    }

    if (length(all_shapes) > 0) fig$x$layout$shapes <- all_shapes
    fig
}


# ---- Plot config helper ----------------------------------------------------

#' Create a standard plotly config list for sciVizModules plots
#'
#' @param download.format Character; image format ("png" or "svg").
#' @param filename Character; base filename for image export.
#' @return Named list for `plotly::config()`.
#' @noRd
.sci_plot_config <- function(download.format = "png",
                              filename = as.character(Sys.Date())) {
    list(
        edits = list(
            axisTitleText    = TRUE,
            titleText        = TRUE,
            annotationText   = TRUE,
            legendText       = TRUE,
            legendPosition   = TRUE,
            annotationTail   = TRUE,
            annotationPosition = TRUE
        ),
        toImageButtonOptions = list(
            format   = download.format,
            filename = filename
        ),
        modeBarButtonsToAdd = list(
            "drawline", "drawopenpath", "drawclosedpath",
            "drawcircle", "drawrect", "eraseshape"
        ),
        displaylogo = FALSE
    )
}


# ---- Download handler factory ----------------------------------------------

#' Create a Shiny download handler for interactive plotly plots
#'
#' @param plot_reactive A reactive expression returning a plotly object.
#' @param filename_base Base name for the HTML file (without extension).
#' @return A `downloadHandler`.
#' @importFrom htmlwidgets saveWidget
#' @importFrom shinyjqui jqui_resizable
#' @noRd
.sci_plot_download_handler <- function(plot_reactive,
                                        filename_base = "survival_curve") {
    downloadHandler(
        filename = function() paste0(filename_base, "_", Sys.Date(), ".html"),
        content  = function(file) {
            p <- plot_reactive()
            if (!inherits(p, "plotly")) stop("Plot must be a plotly object")
            htmlwidgets::saveWidget(
                widget = jqui_resizable(p),
                file   = file,
                selfcontained = TRUE
            )
        }
    )
}
