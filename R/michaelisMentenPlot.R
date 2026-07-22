#' Plot a Michaelis-Menten kinetics fit
#'
#' Draws the observed reaction velocities against substrate concentration and
#' overlays a pre-computed fitted Michaelis-Menten curve (`mml`).
#'
#' @param data A data frame of observations containing the `x` and `y` columns.
#' @param model A data frame of fitted-line coordinates (e.g. `mml`) containing
#'   the same `x` and `y` columns as `data`. Drawn as the fitted curve.
#' @param x Name of the column in `data` to plot on the x-axis (substrate
#'   concentration). Defaults to `"S"`.
#' @param y Name of the column in `data` to plot on the y-axis (velocity).
#'   Defaults to `"v"`.
#' @param theme A ggplot2 theme to apply. Defaults to [ggplot2::theme_bw()].
#' @param jitter Logical; when `TRUE` (the default) the observed points are
#'   plotted (jittered horizontally by `jitter_width`). When `FALSE`, the
#'   points are omitted and only the fitted line is drawn.
#' @param jitter_width Horizontal jitter width for the observed points. Only
#'   used when `jitter = TRUE`. When `NULL`, ggplot2's default jitter width is
#'   used.
#' @param jitter_color Point colour, supplied as a hex string from the
#'   VizModules [colourpicker::colourInput()] workflow. When `NULL`, ggplot2's
#'   default point colour is used.
#' @param jitter_alpha Opacity of the observed points, in `[0, 1]`. Defaults to
#'   `0.5`.
#' @param jitter_size Size of the observed points, passed to
#'   [ggplot2::geom_point()]. Defaults to `1.5`.
#' @param line_color Fitted-curve colour, supplied as a hex string from the
#'   VizModules [colourpicker::colourInput()] workflow. When `NULL`, `"red"` is
#'   used.
#' @param linetype Line type for the fitted curve, passed to
#'   [ggplot2::geom_line()] (e.g. `"solid"`, `"dashed"`, `"dotted"`,
#'   `"dotdash"`, `"longdash"`, `"twodash"`). Defaults to `"solid"`.
#' @return A [ggplot2::ggplot()] object.
#'
#' @rawNamespace import(ggplot2, except = last_plot)
#'
#' @export
#' @author Jacob Martin
#' @examples
#' if (requireNamespace("drc", quietly = TRUE)) {
#'     library(drc)
#'     mm_model <- drm(v ~ S, data = mm_kinetics, fct = MM.2())
#'     mml <- data.frame(S = seq(min(mm_kinetics$S), max(mm_kinetics$S), length.out = 100))
#'     mml$v <- predict(mm_model, newdata = mml)
#'     michaelisMentenPlot(mm_kinetics, mml, x = "S", y = "v")
#' }
michaelisMentenPlot <- function(data, model, x = "S", y = "v", theme = theme_bw(),
                                jitter = TRUE, jitter_width = NULL,
                                jitter_color = NULL, jitter_alpha = 0.5,
                                jitter_size = 1.5, line_color = NULL,
                                linetype = "solid") {
    stopifnot(is.data.frame(data), all(c(x, y) %in% names(data)))
    stopifnot(is.data.frame(model), all(c(x, y) %in% names(model)))

    mml <- model

    if (is.null(line_color)) line_color <- "red"

    #If jitter is FALSE
    point_layer <- if (!isTRUE(jitter)) {
        NULL
    } else {
        pos <- position_jitter(width = jitter_width, height = 0)
        if (is.null(jitter_color)) {
            geom_point(alpha = jitter_alpha, size = jitter_size, position = pos)
        } else {
            geom_point(alpha = jitter_alpha, size = jitter_size, colour = jitter_color, position = pos)
        }
    }

    ggplot(data, aes(x = .data[[x]], y = .data[[y]])) +
        theme +
        point_layer +
        geom_line(
            data = mml, aes(x = .data[[x]], y = .data[[y]]),
            colour = line_color, linetype = linetype
        )
}

