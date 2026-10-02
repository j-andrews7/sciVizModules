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
