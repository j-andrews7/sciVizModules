# Bioconductor Submission Plan — sciVizModules

Audited against the Bioconductor Contributions guide (general, DESCRIPTION,
R code, Shiny apps chapters). Items are ordered by severity: **blockers** will
stop acceptance outright; **required** items will be flagged as ERROR/WARNING by
`R CMD check` / `BiocCheck`; **recommended** items are NOTES or reviewer
expectations.

> **Status.** Most of §0-§2 is done; those items are marked RESOLVED below and
> kept for the record rather than deleted. What is genuinely still open:
>
> - `inst/CITATION` does not exist (§2).
> - `biocViews` omits the `Software` trunk term (§0.2).
> - The `@return` / `\value` audit across the `.Rd` files (§6).
> - Screenshot compression and the `data/` size question (§3).
> - `shinytest2` tests (§4) — note it is **not** in `Suggests:`, contrary to
>   what §4 claimed; adding it is part of that work.
> - Verifying the source tarball builds under 10 MB (§7).

---

## 0. Critical blockers (must fix before submission)

### 0.1 `Remotes:` field removed — RESOLVED
Bioconductor does **not** support the `Remotes:` field. All dependencies must be
on CRAN or Bioconductor. Verified availability:

- **VizModules** — on **CRAN**. Depend on it normally in `Imports:` (done).
- **GOfan** — on **Bioconductor** (release and devel). Keep it as a normal
  dependency; it powers `goFanPlot`. (Currently in `Suggests:` — fine, or move
  to `Imports:` if `goFanPlot` is core.)
- **drc** — on **CRAN**. Used by `doseResponse`; declared in `Suggests:` (done).

The `Remotes:` field has been removed from `DESCRIPTION`. No dependency blocker
remains.

### 0.2 `biocViews` field is missing — PARTLY RESOLVED
`biocViews` is mandatory and must list **at least two** leaf terms from the same
trunk (Software). Suggested terms for this package:

```
biocViews: Software, Visualization, ShinyApps, GeneExpression,
    DifferentialExpression, SingleCell, GO, Survival
```

Verify each term exists in the current devel biocViews tree before committing.

**Status:** `biocViews` is now present in `DESCRIPTION`, reading
`Visualization, ShinyApps, GUI, DifferentialExpression, GeneExpression,
SingleCell, GeneSetEnrichment, Pathways, GO, Survival`. **Still open:** the
`Software` trunk term is absent, and the guide requires trunk membership.

### 0.3 `Description` field is malformed — RESOLVED
Words were run together across line breaks ("modulestailored", "foundationsof",
"inscientific", "packagewhile", "layersrelevant", "publication-ready,interactive",
"dataand").

**Status:** rewritten as clean multi-sentence prose with proper spacing and
continuation-line indentation.

---

## 1. DESCRIPTION file — cleanups (RESOLVED)

- **Remove `LazyData: true`.** — DONE. Note the consequence: the datasets in
  `data/` are no longer promises in the namespace, so package code must reach
  them through `.sci_example_data()` and examples/tests must call `data()`
  first. A bare reference fails with "object not found".
- **Trailing comma in `Imports:`** — DONE.
- **Trim `Depends:`.** — DONE. `Depends:` is now `R (>= 4.6.0)`, `shiny`,
  `VizModules (>= 0.5.0)`.
- **Add `BugReports:`** — DONE.
- **Bump R version.** — DONE; `R (>= 4.6.0)`.
- **Version** — DONE; exactly `0.99.0`.
- **Confirm every `Imports:` package is actually used**, and every package used
  is declared. `BiocCheck` flags both directions. — DONE: `colourpicker`, `DT`,
  `ggplot2`, `grDevices`, `plotly`, `shinyBS`, `shinyjs`, `stats` and `survival`
  were imported in `NAMESPACE` but undeclared (they resolved only transitively
  through VizModules' own `Depends:`); `htmltools`, `htmlwidgets` and `jsonlite`
  were declared but unused. Both directions are now reconciled, and `survminer`
  has been added to `Suggests:`. **Keep checking this** — it drifts whenever a
  roxygen `@importFrom` is added.
- **License** — `MIT + file LICENSE` is acceptable. Ensure the `LICENSE` file
  contains the standard MIT text with year + copyright holder (no restrictive
  clauses).

---

## 2. Required package infrastructure (currently missing)

- **NEWS file** — DONE. `NEWS.md` carries the single `# sciVizModules 0.99.0`
  section. It stays that way until there is a released version to describe
  changes *from*.
- **CITATION file** — add `inst/CITATION`. Recommended for all packages.
- **INSTALL file** — only if you keep any `SystemRequirements` (e.g. if `drc`
  or GOfan pull in external system libs). Document Linux/Windows/Mac install.
- **Confirm `R CMD check` passes with the current vignette.** The vignette now
  sets `eval = FALSE` for all chunks — it previously did not, so
  `runApp(system.file(...))` and `shinyApp(ui, server)` executed at build time.
  `eval = FALSE` is acceptable for a Shiny package, but the reviewer will look
  for at least a screenshot or a runnable non-Shiny example.

---

## 3. Undesirable / junk files (REQUIRED — will be flagged)

- **Remove `.DS_Store` files** — present at repo root, in `data/`, and in
  `man/PlotScreenShots/`. Add `.DS_Store` to `.gitignore` and `git rm` them.
- **Remove `data/.Rapp.history`** — must not be committed.
- **`man/PlotScreenShots/` is ~1.3 MB of PNGs.** Individual files are under the
  5 MB cap, but the built source tarball must be < 10 MB total. Run the PNGs
  through `pngquant` (≈70% reduction) to be safe, and confirm they are actually
  referenced (screenshots usually belong in `vignettes/` or `man/figures/`,
  not a loose `man/` subfolder — reviewers may question this location).
- **`data/` is ~2.7 MB** (mostly the three airway `.rda` files at 1.4 MB /
  0.7 MB / 0.6 MB). Under limits, but consider whether the full 63k-row airway
  tables are needed or could be subset — smaller example data checks faster.

---

## 4. Shiny-app guidelines (Chapter 18) — mostly OK, verify

Good news: your `runApp()` calls are **all inside roxygen `@examples` guarded by
`if (interactive())`**, which is exactly what the guide requires. No `runApp()`
appears in executable package code. Remaining items:

- **UI/server live under `R/`** — satisfied (module files are in `R/`).
- **`*App()` functions return the app object rather than launching it** —
  confirm each `*App()` ends by *returning* `shinyApp(...)` and does not call
  `runApp()` internally. (Grep showed no non-example `runApp`, so this looks
  fine — just double-check.)
- **Internal (non-exported) helpers should be documented with
  `@keywords internal`**, not exposed on the user-facing index. You have many
  `*_helpers.R` files; make sure exported vs internal is deliberate. 112 `.Rd`
  files for ~14 modules suggests some internals may be exported unnecessarily.
- **Graceful error handling** — reviewers want errors/warnings surfaced to the
  user (e.g. `shinytoastr` / `showNotification`), not silent failures or
  crashes. Audit `stopifnot()`/`stop()` paths in the servers.
- **shinytest2** is **not** in `Suggests:` (this line was wrong). Add it, then
  add at least one `shinytest2` test per module family; reviewers explicitly
  look for this. The testthat suite currently covers helpers, UI construction
  and module wiring, but drives no browser.

---

## 5. R code style / BiocCheck NOTES (recommended)

Clean these before submission to minimize review friction:

- **Naming.** Bioc prefers `camelCase` for functions and `.` prefix for
  internal (non-exported) functions — **not** the S3-style `.` in names.
  Your module functions (`volcanoPlotServer`, etc.) are fine. Check helper
  files for dotted names.
- **`4-space indentation, no lines > 80 chars`** — run a linter
  (`BiocCheck` reports long lines and tab usage).
- **`vapply` over `sapply`, `seq_len`/`seq_along` over `1:n`, `is()` over
  `class() ==`, `TRUE/FALSE` over `T/F`.** (Grep found no `set.seed`, `browser`,
  or `<<-` in `R/` — good.)
- **Messaging** — use `message()`/`warning()`/`stop()` rather than `cat()`/
  `print()` for diagnostics.
- **Function length / cyclomatic complexity** — the module servers are large;
  `BiocCheck` may NOTE overly long functions. Factor shared logic into helpers.

---

## 6. Documentation & README (recommended)

- **README** already has content and an install section — update the install
  instructions once the `Remotes` situation is resolved (it currently tells
  users to `install_github`, which won't apply post-acceptance). It now also
  documents every exported module, the Figure Builder, and the agent skills.
- Ensure **every exported function has a `@return` (`\value`) section** —
  `BiocCheck` errors on missing value sections. With 112 Rd files this is worth
  an automated pass.
- Ensure **runnable examples** exist for exported non-Shiny functions
  (e.g. `michaelisMentenPlot()`, `goFanPlot()`).

---

## 7. Pre-submission checklist (run these, fix everything)

```r
# Build against Bioconductor devel with a recent R-devel
R CMD build sciVizModules          # source tarball must be < 10 MB
R CMD check --no-build-vignettes sciVizModules   # < 10 min, 0 error/warning
BiocCheck::BiocCheckGitClone()
BiocCheck::BiocCheck("new-package" = TRUE)        # 0 error/warning
```

Address every ERROR and WARNING; justify any remaining NOTE.

---

## Suggested order of work

Steps 1, 2 and the `NEWS.md` half of step 4 are done. What remains:

1. Add the `Software` biocViews trunk term (§0.2).
2. Delete any remaining junk files and compress the screenshots (§3).
3. Add `inst/CITATION` (§2).
4. Audit exports vs internals and `@return` sections (§4, §6).
5. Add `shinytest2` to `Suggests:` and write the browser tests (§4).
6. Style/lint pass (§5).
7. Run the full build/check/BiocCheck loop (§7) until clean.
