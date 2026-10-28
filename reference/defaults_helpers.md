# Default UI value producers for sciVizModules plot modules

This file collects the internal helpers that compute the `defaults`
lists handed to the wrapped VizModules plot servers/UIs. Keeping them
together keeps the auto-detected initial state and the reset state in
one place per module.

## Details

All detection routes through
[`.detect_column()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_detect_column.md)
(see `enrichment_helpers.R`).
