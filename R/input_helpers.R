#' Debounced read of a free-text module input
#'
#' [shiny::textInput()] and [shiny::textAreaInput()] report to the server on
#' every keystroke, so a plot reading one directly is rebuilt once per
#' character -- and for a list of gene names or an expression, most of those
#' characters are a state the plot cannot use. [shiny::debounce()] collapses a
#' burst of typing into one rebuild once the user pauses. It emits its initial
#' value immediately, so startup is unaffected.
#'
#' Create the result **once**, in the module server body. Creating it inside
#' another reactive rebuilds the timer on every invalidation, which defeats it.
#' Select, numeric, checkbox and slider inputs report discrete choices and need
#' nothing.
#'
#' A key backed by the reactive-defaults store follows the store rather than the
#' client input, matching what [VizModules::setup_auto_update_logic()] does for
#' an ordinary `isolate_fn(input$key)` read.
#'
#' @param input The Shiny `input` object from inside `moduleServer()`.
#' @param key Character string -- the input's id, without namespacing.
#' @param params Optional reactive-defaults store from
#'   [VizModules::setup_reactive_defaults()], or `NULL`.
#' @param millis Debounce delay in milliseconds. 500-800 is a good range; the
#'   more expensive the plot, the longer the delay earns its keep.
#'
#' @return A [shiny::reactive()] yielding the input's debounced value.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_debounced_input
#' @keywords internal
.sci_debounced_input <- function(input, key, params = NULL, millis = 700) {
    debounce(
        reactive({
            if (!is.null(params) && params$has(key)) params$get(key) else input[[key]]
        }),
        millis
    )
}


#' Columns fit to colour, shape or group by
#'
#' The categorical columns [VizModules::facet_check()] accepts (character or
#' factor, with fewer than `max.levels` distinct values) plus the logical
#' columns, in data order. A column of IDs or gene names would otherwise ask
#' for one colour, shape or group per row, which can bring an app down.
#'
#' @param data A data frame (or anything [as.data.frame()] accepts).
#' @param numeric Whether to also keep numeric columns with fewer than
#'   `max.levels` distinct values, e.g. a dose.
#' @param max.levels Columns with this many or more distinct values are left
#'   out. Passed to [VizModules::facet_check()].
#' @return A character vector of column names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_discrete_cols
#' @keywords internal
.sci_discrete_cols <- function(data, numeric = FALSE, max.levels = 50) {
    if (is.null(data)) {
        return(character(0))
    }
    data <- as.data.frame(data)
    if (ncol(data) == 0) {
        return(character(0))
    }
    nm <- names(data)
    ok <- nm %in% facet_check(data, max.levels) | vapply(data, is.logical, logical(1))
    if (isTRUE(numeric)) {
        ok <- ok | vapply(data, function(x) is.numeric(x) && length(unique(x[!is.na(x)])) < max.levels, logical(1))
    }
    nm[ok]
}


#' Fill inputs that have not reported yet
#'
#' A wrapper reads its own inputs before its UI may exist (or an empty
#' `numericInput()` reports `NA`); each such value falls back to the module's
#' default.
#'
#' @param vals A named list of input values.
#' @param fallback A named list of defaults covering the same names.
#' @return `vals`, with `NULL` and `NA` numeric entries replaced from `fallback`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_fill_inputs
#' @keywords internal
.sci_fill_inputs <- function(vals, fallback) {
    for (k in names(vals)) {
        v <- vals[[k]]
        if (is.null(v) || (is.numeric(v) && length(v) == 1 && is.na(v))) vals[k] <- list(fallback[[k]])
    }
    vals
}
