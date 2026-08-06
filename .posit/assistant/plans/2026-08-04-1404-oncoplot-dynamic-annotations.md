# Oncoplot dynamic annotations (multiDynamicInput)

## Goal

Add a **dynamic annotation adder** to the oncoplot module's front tab using
`VizModules::multiDynamicInput`. Each row the user adds defines one
ComplexHeatmap annotation track (barplot, points, lines, boxplot, density, a
plain numeric/simple track, etc.). The user chooses which **side** of the
oncoprint the track attaches to (top / bottom / left / right) and, when the
track is a scaled numeric/simple track, picks a **colour**. Multiple rows =
multiple stacked tracks. This mirrors idioms like:

```r
HeatmapAnnotation(foo = anno_barplot(...))   # top/bottom
rowAnnotation(foo = anno_density(m))         # left/right
HeatmapAnnotation(foo = 1:10)                # simple numeric track
```

## Key constraint: annotation data must conform to the oncoprint

An oncoprint is a gene (row) x sample (column) matrix. Annotation length must
match the axis it sits on:

- **top / bottom** annotations need **one value per sample** (column).
- **left / right** annotations need **one value per gene** (row).

The module's input is a **tidy mutation table** (`sample`, `gene`,
`alteration`) plus possibly extra columns. There is no arbitrary numeric matrix
to annotate with, so the sensible, self-contained data sources are **derived
per-sample / per-gene summaries** plus **any extra column carried in the tidy
data** collapsed to one value per sample or per gene. Concretely, the "Data
source" choices offered per annotation row will be:

Per **sample** (top/bottom):
- `n_alterations` - total alterations in that sample (numeric)
- `n_genes_altered` - distinct genes altered in that sample (numeric)
- Any extra numeric column in the data, averaged per sample
- Any extra categorical column in the data, taken as the (first/majority) value per sample

Per **gene** (left/right):
- `n_altered` - number of samples altered for that gene (numeric)
- `pct_altered` - fraction of samples altered (numeric)
- Any extra numeric column, averaged per gene
- Any extra categorical column, majority value per gene

The available data-source choices depend on the side (sample-space vs
gene-space). To keep the UI simple and robust, the **side selector and data
source are both fields in each `multiDynamicInput` row**, and the server
validates/derives the correct vector for the chosen side. If a chosen source is
not conformable to the chosen side, that row is skipped with a warning surfaced
via the plot's empty-state message (never a hard crash).

## Annotation types offered

Mapped to `ComplexHeatmap::anno_*` builders. Numeric-vector tracks:

| UI label   | Builder            | Notes |
|------------|--------------------|-------|
| Bar        | `anno_barplot`     | colour picker used for bar fill |
| Points     | `anno_points`      | colour picker used for point colour |
| Lines      | `anno_lines`       | colour picker used for line colour |
| Boxplot    | `anno_boxplot`     | per-... only meaningful with a matrix; use simple fill colour |
| Simple     | simple numeric track (`anno_simple` via `col` ramp) | colour picker seeds a white->colour ramp |

Categorical track:

| Simple (categorical) | simple track with discrete colour map | auto palette; colour picker seeds base hue |

`anno_density` / `anno_joyplot` need a matrix per row/column and don't fit a
single summary vector cleanly, so they are **out of scope** for v1 (documented
as a limitation). We can revisit if you want matrix-valued sources later.

## Colour picker visibility

Per the request: "if something's scaled numeric have a colour picker added".
The `colour` field is present in every row's `row_spec` but is only
**meaningful** for numeric/simple tracks. Two options:

- (Recommended) Always render the colour field but document that it is ignored
  for categorical sources (categorical uses an auto palette). Simpler, no
  backend-field machinery.
- Use the `backend`-tagged field mechanism to show the colour field only for
  numeric types. More complex; `multiDynamicInput`'s backend tagging is
  designed around the model-line system.

Plan uses the always-visible colour field for v1.

## `row_spec` for the annotation adder

```r
multiDynamicInput(
  ns("annotations"),
  label = "Annotation",
  row_spec = list(
    side   = list(type = "select",
                  args = list(label = "Side",
                              choices = c("top", "bottom", "left", "right"))),
    source = list(type = "select",
                  args = list(label = "Data", choices = <all source keys>)),
    type   = list(type = "select",
                  args = list(label = "Type",
                              choices = c("Bar","Points","Lines","Boxplot","Simple"))),
    colour = list(type = "colour", args = list(label = "Colour", value = "#4C78A8"))
  ),
  max_per_row = 4
)
```

`input$annotations` returns a named list of rows, each a list with
`side`, `source`, `type`, `colour`.

Because the valid `source` choices differ by side (sample-space vs
gene-space), the `choices` list will include **all** sources with a naming
convention that encodes their space (e.g. `sample:n_alterations`,
`gene:pct_altered`, `sample:<colname>`, `gene:<colname>`). The server only
applies a row when the source's space matches the chosen side's space; otherwise
that row is skipped. This avoids needing per-row dynamic choice updates (which
`multiDynamicInput` does not do per-row).

## Implementation

### 1. New helper file additions (`R/oncoPlot_helpers.R`)

- `.onco_annotation_sources(data, sample.col, gene.col, alteration.col)`
  Returns a named list describing available sources, split by space:
  `list(sample = c(...keys...), gene = c(...keys...))`, where each key is a
  human label mapped to an internal id. Includes the derived summaries plus
  extra columns detected in `data`.
- `.onco_summarise_source(data, key, space, mat, sample.col, gene.col, alteration.col)`
  Given a source key and space, returns a named vector aligned to
  `colnames(mat)` (sample space) or `rownames(mat)` (gene space). Handles the
  derived summaries and extra-column aggregation (mean for numeric, majority
  for categorical). Returns `NULL` if not derivable.
- `.onco_build_annotation(vec, type, colour, which)`
  Builds a single-track `HeatmapAnnotation`/`rowAnnotation` object from a
  conformable vector, dispatching on `type` to the right `anno_*` builder and
  applying `colour`. `which = "column"` for top/bottom, `"row"` for left/right.
- `.onco_collect_annotations(rows, data, mat, sample.col, gene.col, alteration.col)`
  Iterates the `multiDynamicInput` rows, derives vectors, builds per-side
  annotation objects, and returns a list with elements `top`, `bottom`,
  `left`, `right` (each a combined `HeatmapAnnotation` or `NULL`). Multiple
  rows on the same side are combined into one annotation object with multiple
  tracks.

### 2. `oncoPlot()` (`R/oncoPlot.R`)

Add parameters `top.annotation`, `bottom.annotation`, `left.annotation`,
`right.annotation` (each a prebuilt annotation object or `NULL`). Pass them to
`oncoPrint()` as `top_annotation` / `bottom_annotation` / `left_annotation` /
`right_annotation`.

Important: `oncoPrint()` installs a **default `top_annotation`** (the per-sample
alteration barplot). If the user adds a top annotation we must not silently drop
that barplot. Approach: when a user top annotation is supplied, keep the default
oncoprint barplot by combining it, OR expose a `show.top.barplot` toggle. v1:
if the user supplies any `top.annotation`, we pass it through and also set the
oncoprint's own barplots via the existing `oncoPrint` defaults where possible;
if they conflict, the user annotation wins for `top`. Document this. (The
per-gene right barplot behaves similarly for `right`.)

### 3. UI (`R/oncoPlot_module_ui.R`)

- Add the `multiDynamicInput("annotations", ...)` to the **Data** tab (the
  "front tab") per the request, under the column selectors, wrapped in a
  `tipify` explaining conformance rules.
- Compute the `source` choices from the initial data via
  `.onco_annotation_sources()` so the dropdown is seeded sensibly.
- Add `@importFrom VizModules multiDynamicInput`.

### 4. Server (`R/oncoPlot_module_server.R`)

- In `generate_oncoPlot()`, read `input$annotations`, call
  `.onco_collect_annotations(...)` against the current `mat` and data, and pass
  the four side objects into `oncoPlot()`.
- Wrap annotation building in `tryCatch`; on failure, skip the offending track
  and continue (surface message via the existing `empty_plot`/error path in the
  interactive observer).
- On `input$reset`, call `updateMultiDynamicInput(session, "annotations",
  clear = TRUE)`.
- Keep the annotation `source` choices in sync when the data / column selection
  changes: because per-row choices can't be updated, we instead **rebuild the
  whole `multiDynamicInput`** is not supported either; v1 keeps the initial
  seeded choices and relies on the `space:key` naming + server-side validation.
  (Note this limitation in docs.)

### 5. DESCRIPTION / docs / tests

- No new package dependency (`multiDynamicInput` is already in VizModules, and
  ComplexHeatmap is already a Suggest).
- Update the `@section` docs in the UI/oncoPlot roxygen to describe annotations.
- Add a `tests/testthat/test-onco-annotations.R` covering:
  - `.onco_annotation_sources()` returns sample+gene keys for the example data.
  - `.onco_summarise_source()` returns vectors aligned to `colnames`/`rownames`
    of the matrix, with correct length.
  - `.onco_build_annotation()` returns a `HeatmapAnnotation` for each type.
  - `oncoPlot()` accepts a built annotation and still returns a `Heatmap`.

## Confirmed design decisions

1. **Placement**: the annotation adder goes on the **Data** tab (front tab),
   below the column selectors.
2. **Data sources**: derived per-sample / per-gene summaries plus extra columns
   from the tidy table aggregated to one value per sample/gene. No separate
   annotation-table upload in v1.
3. **Default barplots**: when a user adds a `top` or `right` annotation, keep
   oncoPrint's built-in per-sample / per-gene alteration barplots **alongside**
   the user's track (user tracks stack with, not replace, the defaults).
4. **Categorical colours**: categorical sources use an **auto palette**; the
   row's colour picker is ignored for them (only numeric/simple tracks use it).

## Out of scope for v1 (documented limitations)

- Matrix-valued annotations (`anno_density`, `anno_joyplot`,
  `cbind(runif, runif)` style) — need a matrix source, not a summary vector.
- Per-row dynamic `source` choice filtering by the chosen side (uses `space:`
  prefixed keys + server validation instead).
- Legends for continuous simple tracks are basic (single-hue ramp).
