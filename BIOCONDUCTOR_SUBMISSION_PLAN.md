# Bioconductor Submission Plan — sciVizModules

Audited against the Bioconductor Contributions guide (general, DESCRIPTION,
R code, Shiny apps chapters). Items are ordered by severity: **blockers** will
stop acceptance outright; **required** items will be flagged as ERROR/WARNING by
`R CMD check` / `BiocCheck`; **recommended** items are NOTES or reviewer
expectations.

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

### 0.2 `biocViews` field is missing — REQUIRED, blocks build
`biocViews` is mandatory and must list **at least two** leaf terms from the same
trunk (Software). Suggested terms for this package:

```
biocViews: Software, Visualization, ShinyApps, GeneExpression,
    DifferentialExpression, SingleCell, GO, Survival
```

Verify each term exists in the current devel biocViews tree before committing.

### 0.3 `Description` field is malformed — REQUIRED
Words are run together across line breaks ("modulestailored", "foundationsof",
"inscientific", "packagewhile", "layersrelevant", "publication-ready,interactive",
"dataand"). Rewrite as clean, ≥3-sentence prose with proper spacing and
continuation-line indentation.

---

## 1. DESCRIPTION file — required cleanups

- **Remove `LazyData: true`.** Bioconductor recommends against it (slows loading);
  the guide asks for justification if kept. With ~2.7 MB of `.rda` data, drop it.
- **Trailing comma in `Imports:`** — `dittoSeq,` ends the block with a dangling
  comma. Remove it.
- **Trim `Depends:`.** Seven packages are in `Depends:` (`shiny`, `plotthis`,
  `dittoViz`, `plotly`, `shinyBS`, `VizModules`, plus `R`). The guide says it is
  unusual to have more than ~3. Move everything that is only used inside your
  namespace to `Imports:`; keep `Depends:` minimal (likely just `R (>= 4.x)` and
  possibly `shiny`).
- **Add `BugReports:`** — `https://github.com/j-andrews7/sciVizModules/issues`.
- **Bump R version.** `R (>= 3.5)` is very old; current Bioc devel expects a
  recent R (4.5/4.6). Set to match the devel Bioconductor you build against.
- **Version** — the submitted version must be exactly `0.99.0` (currently
  `0.99.0.9000`; drop the `.9000` dev suffix for submission).
- **Confirm every `Imports:` package is actually used**, and every package used
  is declared (see `drc` above). `BiocCheck` flags both directions.
- **License** — `MIT + file LICENSE` is acceptable. Ensure the `LICENSE` file
  contains the standard MIT text with year + copyright holder (no restrictive
  clauses).

---

## 2. Required package infrastructure (currently missing)

- **NEWS file** — add a top-level `NEWS.md` (or `inst/NEWS.Rd`). Even a single
  `# sciVizModules 0.99.0` section with "Initial Bioconductor submission" is
  expected.
- **CITATION file** — add `inst/CITATION`. Recommended for all packages.
- **INSTALL file** — only if you keep any `SystemRequirements` (e.g. if `drc`
  or GOfan pull in external system libs). Document Linux/Windows/Mac install.
- **Confirm `R CMD check` passes with the current vignette.** You just added
  `vignettes/quick-start.Rmd`; make sure it builds. Note it currently sets
  `eval = FALSE` for all chunks — acceptable for a Shiny package, but the
  reviewer will look for at least a screenshot or a runnable non-Shiny example.

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
- **shinytest2** is already in `Suggests:` — add at least one `shinytest2` test
  per module family; reviewers explicitly look for this.

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
  users to `install_github`, which won't apply post-acceptance).
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

1. **Resolve dependencies** (§0.1) — decide the fate of VizModules, GOfan, drc.
   Nothing else matters until this path is clear.
2. Fix `DESCRIPTION`: `biocViews`, `Description`, remove `Remotes`/`LazyData`,
   trailing comma, `Depends`→`Imports`, `BugReports`, version → `0.99.0` (§0.2–1).
3. Delete junk files, compress screenshots (§3).
4. Add `NEWS.md` and `inst/CITATION` (§2).
5. Audit exports vs internals and `@return` sections (§4, §6).
6. Add `shinytest2` tests (§4).
7. Style/lint pass (§5).
8. Run the full build/check/BiocCheck loop (§7) until clean.
