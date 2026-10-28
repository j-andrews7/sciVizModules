# Turn a preparation error into a validation message

An error raised while the wrapped heatmap builds would end the session,
since the base draws inside an observer; a
[`shiny::validate()`](https://rdrr.io/pkg/shiny/man/validate.html)
failure only stops that build. Pauses from
[`shiny::req()`](https://rdrr.io/pkg/shiny/man/req.html) pass through
untouched.

## Usage

``` r
.sci_soft_errors(expr)
```

## Arguments

- expr:

  The expression to evaluate.

## Value

The value of `expr`.

## Author

Jared Andrews
