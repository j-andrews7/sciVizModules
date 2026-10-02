#' Assay plate heatmap
#'
#' Draws each assay plate as a heatmap in its physical layout (row A at the
#' top), raw or normalised, with the control wells outlined, the Z'-factor of
#' each plate in its title, and optional row and column means in the margins
#' for spotting edge effects and gradients.
#'
#' @param data A data frame with one row per well.
#' @param well Column of well identifiers (`"A01"`, `"A1"`, `"AF48"`).
#' @param value Column of the numeric readout.
#' @param plate Column of plate identifiers, or `NULL` for a single plate.
#' @param control Column labelling the control wells, or `NULL`.
#' @param positive,negative The labels of the positive and negative control
#'   wells in `control`. Every other well is a sample.
#' @param normalise One of `"raw"`, `"percent.control"`, `"percent.inhibition"`,
#'   `"zscore"`, `"robust.z"` or `"bscore"`, applied per plate. The z-scores are
#'   against the sample wells; the B-score is the median-polish residual of the
#'   sample wells over their MAD, which removes row and column effects.
#' @param plate.format The plate size (`96`, `384`, `1536`, ...), or `"auto"`
#'   for the smallest standard plate that holds every well.
#' @param colors Low, mid and high colours of the colour scale.
#' @param midpoint Value at the mid colour, or `NULL` for 0 (z- and B-scores),
#'   50 (percentages) or the median (raw).
#' @param show.controls Logical; outline the control wells.
#' @param positive.color,negative.color Outline colours of the control wells.
#' @param marginals Logical; draw the sample wells' row and column means beside
#'   each plate.
#' @param ncols Number of plates per row, or `NULL` for up to two.
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the per-plate statistics (control means and
#'   SDs, signal-to-background, Z'-factor, and the edge-to-interior ratio of the
#'   sample wells) as attribute `"table"`.
#'
#' @references Zhang JH, Chung TD, Oldenburg KR (1999). A simple statistical
#'   parameter for use in evaluation and validation of high throughput
#'   screening assays. *J Biomol Screen* 4:67-73.
#'
#'   Brideau C, Gunter B, Pikounis B, Liaw A (2003). Improved statistical methods
#'   for hit selection in high-throughput screening. *J Biomol Screen* 8:634-647.
#'
#' @import plotly
#' @seealso [plateHeatmapServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' data(example_plate)
#' plateHeatmap(example_plate, well = "well", value = "signal", plate = "plate",
#'     control = "type", positive = "positive", negative = "negative", normalise = "bscore")
plateHeatmap <- function(data, well, value, plate = NULL, control = NULL, positive = NULL, negative = NULL,
                         normalise = "raw", plate.format = "auto", colors = c("#2166AC", "#F7F7F7", "#B2182B"),
                         midpoint = NULL, show.controls = TRUE, positive.color = "#E7298A",
                         negative.color = "#000000", marginals = FALSE, ncols = NULL, main = NULL) {
    data <- as.data.frame(data)
    missing <- setdiff(c(well, value), names(data))
    if (length(missing)) stop("Column(s) not in the data: ", paste(missing, collapse = ", "), call. = FALSE)
    plate <- if (nz_value(plate) && plate %in% names(data)) plate else NULL
    control <- if (nz_value(control) && control %in% names(data)) control else NULL

    wells <- .plate_parse_wells(data[[well]])
    df <- data.frame(
        plate = if (is.null(plate)) "Plate 1" else as.character(data[[plate]]),
        well = toupper(as.character(data[[well]])),
        row = wells$row, col = wells$col,
        raw = as.numeric(data[[value]]),
        stringsAsFactors = FALSE
    )
    labels <- if (is.null(control)) rep(NA_character_, nrow(df)) else as.character(data[[control]])
    df$role <- ifelse(!is.na(labels) & nz_value(positive) & labels == (positive %||% ""), "positive",
        ifelse(!is.na(labels) & nz_value(negative) & labels == (negative %||% ""), "negative", "sample"))
    dup <- duplicated(df[, c("plate", "row", "col")])
    if (any(dup)) {
        stop("Duplicate wells (e.g. ", df$well[dup][1], " on ", df$plate[dup][1],
            "); choose a plate column that separates them.", call. = FALSE)
    }
    fmt <- .plate_format(df$row, df$col, plate.format)

    plates <- unique(df$plate)
    df$value <- NA_real_
    for (p in plates) {
        i <- df$plate == p
        df$value[i] <- .plate_normalise(df$raw[i], df$row[i], df$col[i], df$role[i], normalise)
    }
    stats <- do.call(rbind, lapply(plates, function(p) .plate_stats(df[df$plate == p, , drop = FALSE], fmt, p)))

    finite <- df$value[is.finite(df$value)]
    if (!length(finite)) stop("No finite values to plot.", call. = FALSE)
    zmin <- min(finite)
    zmax <- max(finite)
    if (zmax == zmin) zmax <- zmin + 1
    midpoint <- midpoint %||% switch(normalise, raw = stats::median(finite),
        percent.control = 100, percent.inhibition = 50, 0)
    frac <- min(max((midpoint - zmin) / (zmax - zmin), 0.001), 0.999)
    colorscale <- list(list(0, colors[1]), list(frac, colors[2]), list(1, colors[3]))
    scale_title <- switch(normalise, raw = value, percent.control = "% of control",
        percent.inhibition = "% inhibition", zscore = "z-score", robust.z = "robust z", bscore = "B-score")

    panels <- lapply(seq_along(plates), function(k) {
        .plate_panel(df[df$plate == plates[k], , drop = FALSE], fmt, colorscale, zmin, zmax, scale_title,
            showscale = k == 1, marginals = marginals)
    })
    ncols <- ncols %||% min(length(plates), 2)
    nrows <- ceiling(length(plates) / ncols)
    fig <- if (length(panels) == 1) {
        panels[[1]]
    } else {
        subplot(panels, nrows = nrows, shareX = FALSE, shareY = FALSE, titleX = TRUE, titleY = TRUE,
            margin = c(0.04, 0.04, 0.07, 0.07))
    }
    fig <- plotly_build(fig)
    fig <- layout(fig, title = list(text = main %||% ""), showlegend = FALSE)

    # Panel titles and control outlines go on each heatmap's own axes.
    heat_axes <- lapply(Filter(function(tr) identical(tr$type, "heatmap"), fig$x$data),
        function(tr) c(x = tr$xaxis %||% "x", y = tr$yaxis %||% "y"))
    axis_layout <- function(ref) fig$x$layout[[sub("^([xy])", "\\1axis", ref)]]
    annotations <- list()
    shapes <- list()
    for (k in seq_along(plates)) {
        ax <- heat_axes[[k]]
        x_dom <- axis_layout(ax[["x"]])$domain %||% c(0, 1)
        y_dom <- axis_layout(ax[["y"]])$domain %||% c(0, 1)
        if (isTRUE(marginals)) {
            # The title sits over the column-means bar, which shares the heatmap's x axis.
            top <- Filter(function(tr) identical(tr$type, "bar") && identical(tr$xaxis %||% "x", ax[["x"]]),
                fig$x$data)
            if (length(top)) y_dom <- axis_layout(top[[1]]$yaxis %||% "y")$domain %||% y_dom
        }
        z <- stats$z.prime[k]
        annotations[[k]] <- list(
            text = if (is.na(z)) plates[k] else sprintf("%s (Z' = %.2f)", plates[k], z),
            x = mean(x_dom), y = y_dom[2],
            xref = "paper", yref = "paper", xanchor = "center", yanchor = "bottom", showarrow = FALSE,
            font = list(size = 13)
        )
        if (isTRUE(show.controls)) {
            d <- df[df$plate == plates[k] & df$role != "sample", , drop = FALSE]
            y <- fmt$nrow - d$row + 1
            shapes <- c(shapes, lapply(seq_len(nrow(d)), function(i) {
                list(type = "rect", xref = ax[["x"]], yref = ax[["y"]],
                    x0 = d$col[i] - 0.45, x1 = d$col[i] + 0.45, y0 = y[i] - 0.45, y1 = y[i] + 0.45,
                    line = list(color = if (d$role[i] == "positive") positive.color else negative.color, width = 1.5),
                    fillcolor = "rgba(0,0,0,0)")
            }))
        }
    }
    fig$x$layout$annotations <- c(fig$x$layout$annotations, annotations)
    fig$x$layout$shapes <- c(fig$x$layout$shapes, shapes)
    attr(fig, "table") <- stats
    fig
}


#' One plate's heatmap (and margins)
#'
#' @param d The plate's wells, with `row`, `col`, `raw`, `value`, `role`, `well`.
#' @param fmt The plate format from `.plate_format()`.
#' @param colorscale,zmin,zmax,scale_title Shared colour scale.
#' @param showscale Logical; draw the colour bar.
#' @param marginals Logical; add the row and column means.
#' @return A `plotly` object.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_panel
#' @keywords internal
.plate_panel <- function(d, fmt, colorscale, zmin, zmax, scale_title, showscale, marginals) {
    nr <- fmt$nrow
    nc <- fmt$ncol
    y <- nr - d$row + 1
    z <- matrix(NA_real_, nr, nc)
    z[cbind(y, d$col)] <- d$value
    num <- function(v) formatC(v, digits = 4, format = "g")
    text <- matrix("", nr, nc)
    text[cbind(y, d$col)] <- sprintf("%s %s<br>raw %s<br>%s %s%s", d$plate, d$well, num(d$raw), scale_title,
        num(d$value), ifelse(d$role == "sample", "", paste0("<br>", d$role, " control")))
    step <- if (nc > 24) 4 else 1
    row_labels <- .plate_row_label(seq_len(nr))
    row_step <- if (nr > 16) 2 else 1

    heat <- plot_ly(x = seq_len(nc), y = seq_len(nr), z = z, type = "heatmap", text = text, hoverinfo = "text",
        colorscale = colorscale, zmin = zmin, zmax = zmax, showscale = showscale, xgap = 1, ygap = 1,
        colorbar = list(title = list(text = scale_title))) %>%
        layout(
            xaxis = list(title = list(text = ""), tickvals = seq(1, nc, by = step), showgrid = FALSE,
                zeroline = FALSE, side = "bottom", range = c(0.5, nc + 0.5)),
            yaxis = list(title = list(text = ""), tickvals = seq(nr, 1, by = -row_step),
                ticktext = row_labels[seq(1, nr, by = row_step)], showgrid = FALSE, zeroline = FALSE,
                range = c(0.5, nr + 0.5))
        )
    if (!isTRUE(marginals)) return(heat)

    s <- d[d$role == "sample" & is.finite(d$value), , drop = FALSE]
    if (!nrow(s)) s <- d[is.finite(d$value), , drop = FALSE]
    col_means <- tapply(s$value, factor(s$col, levels = seq_len(nc)), mean)
    row_means <- tapply(s$value, factor(nr - s$row + 1, levels = seq_len(nr)), mean)
    bar <- "#7F7F7F"
    # Columns or rows holding only controls have no sample mean.
    cm <- is.finite(col_means)
    rm <- is.finite(row_means)
    top <- plot_ly(x = seq_len(nc)[cm], y = as.vector(col_means)[cm], type = "bar", marker = list(color = bar),
        text = sprintf("Column %d mean %s", seq_len(nc)[cm], num(as.vector(col_means)[cm])), hoverinfo = "text") %>%
        layout(yaxis = list(title = list(text = ""), showgrid = FALSE))
    right <- plot_ly(y = seq_len(nr)[rm], x = as.vector(row_means)[rm], type = "bar", orientation = "h",
        marker = list(color = bar), text = sprintf("Row %s mean %s", rev(row_labels)[rm], num(as.vector(row_means)[rm])),
        hoverinfo = "text") %>%
        layout(xaxis = list(title = list(text = ""), showgrid = FALSE))
    corner <- plot_ly(type = "scatter", mode = "markers") %>%
        layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE))
    subplot(top, corner, heat, right, nrows = 2,
        widths = c(0.85, 0.15), heights = c(0.2, 0.8), shareX = TRUE, shareY = TRUE, margin = 0.005)
}


#' Per-plate quality statistics
#'
#' @param d One plate's wells.
#' @param fmt The plate format.
#' @param plate The plate name.
#' @return A one-row data frame.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_panel
#' @keywords internal
.plate_stats <- function(d, fmt, plate) {
    pos <- d$raw[d$role == "positive" & is.finite(d$raw)]
    neg <- d$raw[d$role == "negative" & is.finite(d$raw)]
    s <- d[d$role == "sample" & is.finite(d$raw), , drop = FALSE]
    edge <- s$row %in% c(1, fmt$nrow) | s$col %in% c(1, fmt$ncol)
    msd <- function(v, f) if (length(v) >= (if (identical(f, stats::sd)) 2 else 1)) f(v) else NA_real_
    data.frame(
        plate = plate,
        format = fmt$wells,
        wells = nrow(d),
        samples = nrow(s),
        positive.n = length(pos),
        positive.mean = msd(pos, mean),
        positive.sd = msd(pos, stats::sd),
        negative.n = length(neg),
        negative.mean = msd(neg, mean),
        negative.sd = msd(neg, stats::sd),
        signal.to.background = if (length(pos) && length(neg)) mean(neg) / mean(pos) else NA_real_,
        z.prime = .plate_zprime(pos, neg),
        edge.ratio = if (any(edge) && any(!edge)) mean(s$raw[edge]) / mean(s$raw[!edge]) else NA_real_,
        stringsAsFactors = FALSE
    )
}
