#' Caller-supplied group colors from a module's `defaults`
#'
#' Mirrors the validation VizModules applies to a group-color mapping given in
#' `defaults`, so a module can seed its [VizModules::multiColorPicker()] from
#' the same mapping that [VizModules::setup_group_colors()] holds in its store.
#' Only a named, non-empty character vector counts; anything else is treated as
#' "no mapping supplied" and the stock palette is used instead.
#'
#' Color names are converted to hex, because the picker's swatch is a native
#' `<input type="color">` and shows black for anything that is not.
#'
#' @param defaults A named list of default values, or `NULL`. The entry may be
#'   a [shiny::reactive()]; it is resolved with [shiny::isolate()].
#' @param key Character string naming the color entry, e.g. `"palette.colours"`.
#'
#' @return A named character vector of hex colors, or `NULL` when `defaults`
#'   supplies no usable mapping.
#'
#' @seealso [VizModules::resolve_palette()], [VizModules::setup_group_colors()]
#'
#' @importFrom grDevices col2rgb rgb
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_group_colors
#' @keywords internal
.sci_group_colors <- function(defaults, key = "palette.colours") {
    colors <- get_default(defaults, key, NULL, function(x) {
        is.character(x) && length(x) > 0 && !is.null(names(x)) && all(nzchar(names(x)))
    })

    if (is.null(colors)) {
        return(NULL)
    }

    colors <- vapply(colors, function(col) {
        if (is.na(col) || !nzchar(col)) {
            return("")
        }
        tryCatch(
            rgb(t(col2rgb(col)), maxColorValue = 255),
            error = function(e) ""
        )
    }, character(1))

    colors <- colors[nzchar(colors)]

    if (length(colors) == 0) NULL else colors
}
