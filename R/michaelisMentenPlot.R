#' Plot a Michaelis-Menten kinetics fit
#'
#' Draws the observed reaction velocities against substrate concentration and
#' overlays the fitted Michaelis-Menten curve from a [drc::drm()] model. The
#' fitted line (`mml`) is generated internally by predicting the model over a
#' fine grid of substrate concentrations.
#'
#' @param data A data frame of observations with a substrate-concentration
#'   column `S` and a velocity column `v`.
#' @param model A fitted model object (e.g. from [drc::drm()]) whose
#'   `predict()` method returns velocities for new `S` values.
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
#' @param line_color Fitted-curve colour, supplied as a hex string from the
#'   VizModules [colourpicker::colourInput()] workflow. When `NULL`, `"red"` is
#'   used.
#'
#' @return A [ggplot2::ggplot()] object.
#'
#' @import ggplot2
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(drc)
#' mm_model <- drm(v ~ S, data = mm, fct = MM.2())
#' michaelisMentenPlot(mm, mm_model)
michaelisMentenPlot <- function(data, model, theme = theme_bw(), jitter = TRUE,
                                jitter_width = NULL, jitter_color = NULL,
                                line_color = NULL) {
    stopifnot(is.data.frame(data), all(c("S", "v") %in% names(data)))

    # Build the fitted line (mml) by predicting the model over a fine grid.
    mml <- data.frame(S = seq(min(data$S), max(data$S), length.out = 100))
    mml$v <- stats::predict(model, newdata = mml)

    if (is.null(line_color)) line_color <- "red"

    # Plot jittered points when enabled; omit points entirely when disabled.
    point_layer <- if (!isTRUE(jitter)) {
        NULL
    } else {
        pos <- position_jitter(width = jitter_width, height = 0)
        if (is.null(jitter_color)) {
            geom_point(alpha = 0.5, position = pos)
        } else {
            geom_point(alpha = 0.5, colour = jitter_color, position = pos)
        }
    }

    ggplot(data, aes(x = S, y = v)) +
        theme +
        point_layer +
        geom_line(data = mml, aes(x = S, y = v), colour = line_color)
}
