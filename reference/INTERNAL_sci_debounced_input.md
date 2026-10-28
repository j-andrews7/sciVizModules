# Debounced read of a free-text module input

[`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html) and
[`shiny::textAreaInput()`](https://rdrr.io/pkg/shiny/man/textAreaInput.html)
report to the server on every keystroke, so a plot reading one directly
is rebuilt once per character – and for a list of gene names or an
expression, most of those characters are a state the plot cannot use.
[`shiny::debounce()`](https://rdrr.io/pkg/shiny/man/debounce.html)
collapses a burst of typing into one rebuild once the user pauses. It
emits its initial value immediately, so startup is unaffected.

## Usage

``` r
.sci_debounced_input(input, key, params = NULL, millis = 700)
```

## Arguments

- input:

  The Shiny `input` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- key:

  Character string – the input's id, without namespacing.

- params:

  Optional reactive-defaults store from
  [`VizModules::setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.html),
  or `NULL`.

- millis:

  Debounce delay in milliseconds. 500-800 is a good range; the more
  expensive the plot, the longer the delay earns its keep.

## Value

A [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)
yielding the input's debounced value.

## Details

Create the result **once**, in the module server body. Creating it
inside another reactive rebuilds the timer on every invalidation, which
defeats it. Select, numeric, checkbox and slider inputs report discrete
choices and need nothing.

A key backed by the reactive-defaults store follows the store rather
than the client input, matching what
[`VizModules::setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.html)
does for an ordinary `isolate_fn(input$key)` read.

## Author

Jared Andrews
