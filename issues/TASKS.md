# heplots — development tasks

Broken out from the cross-package working list in `C:\Users\friendly\Dropbox\R\TASKS.md`
(2026-07-28). Update here as items are finished; sync back to the main list only if it's
useful to see heplots status at a glance across packages.

Updated 2026-08-22: v1.8.3 was submitted to CRAN 2026-08-19 and rejected over two `URL`
findings from win-builder's incoming-feasibility check (see "CRAN resubmission status"
below); package is now at v1.8.4, resubmission-ready with a clean local `R CMD check`
(0/0/0). `pvPlot()` and the pkgdown rebuild shipped since the 2026-08-10 update; new
`dev/GK-Project.md` planning doc added (Roy-Bargmann stepdown analysis, `predict.mlm()`,
for a Gavin funding-application topic list).

## CRAN resubmission status

- v1.8.3 (submitted 2026-08-19, commit `4ac13ce`) was rejected by CRAN over two `URL`
  findings: a PubMed URL in `man/NeuroCog.Rd` (fixed on master directly, commit `9cb0769`,
  replaced with the article's DOI), and non-canonical URLs embedded in the static
  `vignettes/repeated-JSS.pdf` reprint.

- Resolved the `repeated-JSS.pdf` issue by withdrawal rather than further explanation:
  moved `repeated-JSS.pdf`/`repeated-JSS.pdf.asis`/`repeated.bib` to `vignettes-old/`,
  dropped the now-unused `R.rsp` from `Suggests`/`VignetteBuilder` in `DESCRIPTION`, and
  updated `release_cran_comments()`'s `known_issues` default to `NULL` (was the
  repeated-JSS explanation text).

- `DESCRIPTION` bumped to v1.8.4 (Date: 2026-08-22); `NEWS.md` and `cran-comments.md`
  updated accordingly. Also merged in the `robust-vignette` branch: a second worked
  example (`robustbase::pulpfiber`) for `vignettes/Robust.Rmd`, plus `distancePlot()`
  doc/cross-reference improvements and a `verbose`-gating bugfix.

- Local `devtools::check()` (R 4.6.1, `--as-cran`) is clean: 0 errors, 0 warnings,
  0 notes, including a successful re-build of all vignette outputs. Reverse dependencies
  were not re-checked this cycle (only docs/vignettes and one non-behavioral bugfix
  changed since the 9-checked/0-new-problems result at v1.8.3) — win-builder and revdep
  re-checks were deliberately skipped for this narrow resubmission.

- Not yet done: actual upload to CRAN (`devtools::release()`/`devtools::submit_cran()`)
  — deliberately left as a manual, interactive step.

## TODOs

- [ ] `extract_eq.mlm()` for `equatiomatic` — S3 method to make `equatiomatic::extract_eq()` work on
  `mlm` objects (currently produces garbled LaTeX). Filed as an issue upstream:
  https://github.com/datalorax/equatiomatic/issues/243 (no response yet; code already takes
  the right approach regardless -- `@exportS3Method equatiomatic::extract_eq mlm`, not
  waiting on upstream, same pattern `nestedLogit` uses).
  Re-verified 2026-10-02 against the currently-installed `equatiomatic` 0.4.9 (the file's
  earlier `logit_notation`/`check_dots()` error was tied to an unreleased 0.4.6 dev branch
  and is moot now): symbolic form (default/`pmatrix`/`bmatrix`, generic names), `wrap = TRUE`
  (resolving the notes' "still to clarify" item), `dots_threshold` truncation, and underscore
  sanitization all work correctly. Found and fixed one real bug: `use_coefs = TRUE` produced
  doubled `$$` in the output, because `.build_coef_matrix_eq()` manually wrapped its result
  in `$$...$$` on top of what `equatiomatic`'s own `print.equation()`/`format.equation()` add
  at display time (confirmed by inspecting the raw string's literal `$$` count before/after).
  Fix: return the bare body, matching the symbolic path. Remaining known limitation (documented,
  not urgent): `use_generic_names = "predictors"` only substitutes simple continuous main
  effects, not factor/interaction terms.
  Still not implemented in `R/` -- next step is the move-to-R/ workflow (`git mv`, add
  `equatiomatic` to `Suggests:`, `devtools::document()`, `R CMD check`, `NEWS.md`,
  `_pkgdown.yml`, clean up `dev/` scratch).
  Files: `dev/equatiomatic-notes.md`, `dev/equatiomatic.R`, `dev/equatiomatic-test.R`,
  `dev/equatiomatic-notes.html`

- ✔️ **DONE** `traceCI()` — analytic (asymptotic, Bai & Silverstein 2004) CI for the trace
  (sum of eigenvalues) of a covariance matrix, complementing `logdetCI()` (determinant) and
  `eigstatCI()` (bootstrap CIs for product/sum/precision/max). Shipped as `R/traceCI.R`
  2026-09-10 (see `NEWS.md`); the `dev/boxM/traceCI.R` source draft has been deleted as a
  stale duplicate.

- ✔️ **DONE** (first version) Two-page cheatsheet, 2026-09-30. Built with Quarto + Typst:
  page 1 is "Fit & visualize", page 2 is "Check, refine & report". Published at
  https://friendly.github.io/heplots/heplots-cheatsheet.pdf and linked from the README
  (thumbnail) and the pkgdown navbar. Rebuild with `source("dev/cheatsheet/build.R")`,
  closing the PDF in any viewer first. The outline and decisions are in `dev/cheatsheet.md`.
  Reviewed by two separate agents afterward; findings and fix status tracked in
  `dev/review-team.md`. §1/§2 (package bugs, statistical-statement issues) fixed.
  §3 ("calls that don't run") is now **entirely fixed** -- see the two entries below
  for G3/G4, plus (2026-10-02) caption fixes for I1, F4 (bookkeeping only --
  already fixed earlier, just never marked), B1/B2/C1 (`variables = 2:3`), B5
  (`variables = 3`), B4 (now notes the thumbnail is `Plastic`, not iris), B6
  (`library(candisc)`), C1 (`hyp` placeholder shown as `<hyp>`, matching the
  template panel's own angle-bracket convention -- the full contrast list doesn't
  fit that column), C2 (reworded to "the five PA predictors"), and the
  Customizing bullet ("(first = E)"). Verified by rebuilding and inspecting both
  pages at full resolution -- nothing overflows, though C1 now wraps to 5 short
  lines (matches C2's pre-existing density in that narrow column, not a new
  problem).

  Also from §4 ("worth considering"): ✔️ **DONE** (2026-10-02) G2 switched from the
  degenerate one-way-MANOVA `distancePlot(peng.mod)` (X distances only took 3
  discrete values; the X cutoff fell off the plot) to `distancePlot(rohwer.mod)`
  -- reusing the MMRA model already defined for C2 -- giving a proper continuous
  spread of X distances and real labeled outliers. Panel subtitle stays "`peng`
  data" (still true for G1/G3/G4); G2's own caption now notes the `Rohwer`
  exception. Rest of §4 still open (see `dev/review-team.md`): iris-vs-`Plastic`
  for Basics, a few short caption notes, a couple of one-liners.
  Still open:
  - [ ] Offer it to rstudio/cheatsheets as a contributed cheatsheet once stable.
  - ✔️ `covEllipses()` failed on the documented `label.pos = NULL`: fixed 2026-10-03
    (`NEWS.md`, 1.8.6).
  - ✔️ `pvPlot()` failed on a tibble (e.g., `peng`): fixed 2026-10-03 (`NEWS.md`, 1.8.6).
  - The `label.ellipse()` "SE"/"NW" swap found along the way is fixed (`NEWS.md`,
    development version).
  Files: `dev/cheatsheet/`, `dev/cheatsheet-figs.R`, `dev/cheatsheet.md`, `dev/review-team.md`

- ✔️ **DONE** (2026-10-02) `robmlm.mlm()` — new method so `robmlm()` accepts an existing
  classical `mlm` fit directly (e.g., `robmlm(mod)`), prompted by `dev/review-team.md`'s
  G3 finding (the cheatsheet caption `plot(robmlm(mod))` previously errored, since
  `robmlm()` only had `.default(X, Y)` and `.formula` methods). Pulls `Y`/model matrix
  off the fitted object directly rather than refitting through `model.frame()`/the
  formula -- that more "standard" refit idiom fails specifically for `mlm`s, because
  `model.frame()` stores a `cbind(y1, y2, ...)` response as one matrix-valued column
  literally named `"cbind(y1, y2, ...)"`, so re-parsing the formula against that data
  tries to re-evaluate `cbind(y1, y2, ...)` and can't find `y1` etc. as standalone
  columns (see the comment above `robmlm.mlm()` in `R/robmlm.R`). Verified: coefficients
  and weights identical to the formula-direct fit; `print()`/`summary()`/`car::Anova()`/
  `plot.robmlm()`/`heplot()` all work on the result; checked against an interaction model
  with contrasts (`Plastic`) and a `subset=`-fit model. Also fixes G4 (the
  classical-vs-robust `heplot()` overlay in the cheatsheet's G4 thumbnail): the robust
  fit's `heplot()` call in `dev/cheatsheet-figs.R` was missing an explicit `lty = 1`, so
  it fell back to the default `lty = 2:1`, which (via `he.rep()`) assigns the dashed style
  to **E** -- same as the classical fit -- defeating the "robust solid vs. classical
  dashed" contrast the caption claims. Fixed by adding `lty = 1` to that call.
  Files: `R/robmlm.R`, `dev/cheatsheet-figs.R`, `dev/review-team.md`

- [ ] `pred.mlm()` — extend `predict.lm`-style CIs/PIs to multivariate (`mlm`) models; draft only
  (`pred.mlm0`), not yet roxygenized or added to `R/`.
  File: `dev/pred.mlm.R`

- [ ] Modernize roxygen link style package-wide — convert remaining `\code{\link{fun}}` /
  `\code{\link[pkg]{fun}}` references to markdown `[fun()]` / `[pkg::fun()]` syntax
  (`Roxygen: list(markdown = TRUE)` is already set). Done for `R/coefplot.mlm.R` (2026-09-11,
  while clarifying its docs vs `car::confidenceEllipse()`'s `mlm` method) and `R/heplot3d.R`
  (2026-09-12, while adding the `rgl::rglwidget()` fix below); the rest of `R/` still has the
  old-style macros. Confirmed convention (verified against a scratch test package,
  2026-09-12): function-call links (with `()`) use plain `[pkg::fun()]` — roxygen2
  auto-detects the parens and code-formats them regardless of backticks; a bare topic link with
  no `()` (e.g. a package-overview page like `rgl-package`) needs backtick-quoting,
  `` [`pkg::topic`] ``, to get code formatting — plain `[pkg::topic]` renders as a non-code
  link.

- [ ] Roy-Bargmann stepdown analysis (`RoyBargmann()`) — candidate topic for Gavin's funding
  application, not yet started as package code. `dev/GK-Project.md` records the original
  topic list (`predict.mlm()`, robust-MLM extensions, effect-size/canonical-space tie-ins as
  related candidates) plus two competing sketches of the stepdown procedure. Confirmed
  against Roy (1958) directly that the all-univariate sketch is correct; framework/background
  (procedure definition, relation to overall Wilks' Lambda, an open Bargmann-attribution
  question, and a rough shape for `RoyBargmann()`) now written up in `dev/Roy-Bargmann.md`.
  Next step: sketch the actual `RoyBargmann()` function — Gavin or Michael, TBD.
  Files: `dev/GK-Project.md`, `dev/Roy-Bargmann.md`

- ✔️ **DONE** (2026-09-10) `standardize.R` — standardized regression coefficients for `lm`/`mlm`,
  adapted from `QuantPsyc::lm.beta`. Shipped as `R/standardize.R`: `stdmodel()` (S3 generic,
  refits on z-scored response(s) + numeric predictors, factor predictors left raw -- verified
  numerically equivalent to the analytic diagonal-rescale of `coef()`/`vcov()`) and `stdcoef()`
  (coefficient summary built on `stdmodel()` for `mlm`; kept the pre-existing closed-form for
  plain `lm`). Wired into `coefplot.mlm(std = TRUE)` for standardized-coefficient confidence
  ellipses -- the motivating use case. See `NEWS.md` and `dev/standardize-mlm-test.R`
  (verification script; local `devtools::check(cran = TRUE)` clean, 0/0/0).
  `dev/se_variance.R` (SE of variance) -- MF: can be ignored, not pursued.

- ✔️ **DONE** (2026-09-10) Drop the hard `Depends: broom` in favor of `Imports: generics` for
  `glance.mlm()`. `broom` moved to `Suggests` (still needed for the `\link[broom]{glance.lm}`
  Rd cross-reference and a vignette prose mention; nothing in `R/` calls `broom::` code).
  Resolved differently than the abandoned `rm-glance` branch attempt (`origin/rm-glance`,
  commit `1f59fad`, 2023) -- that commit imported `generics::glance` but never declared
  `generics` anywhere in `DESCRIPTION` (would have failed `R CMD check`), and kept the
  broom-specific dynamic `.onLoad()`/`setHook()` S3-registration workaround in `R/zzz.R`
  pointed at `generics` instead, which was no longer needed once `generics` became a real
  `Imports` dependency. Actual fix: added a standard roxygen2 generic re-export
  (`R/reexports.R`: `#' @importFrom generics glance` / `#' @export` / `generics::glance`),
  which keeps bare `glance(x)` working with just `library(heplots)` (verified: works with
  neither `broom` nor `generics` attached to the search path) via static `NAMESPACE`
  `S3method`/`importFrom`/`export` entries instead of a runtime hook; deleted the now-fully-
  unused `R/zzz.R`. Local `devtools::check(cran = TRUE)` clean (0/0/0).
  `origin/rm-glance` can be deleted whenever convenient -- superseded, not merged.

- ✔️ **DONE** `pvPlot()` — general partial variable plots akin to `car::avPlot()`, shipped in
  v1.8.3 as `R/pvPlot.R` (see `NEWS.md`). Superseded dev drafts moved to "Clean-up candidates"
  below.

- ✔️ **DONE** Rebuild the pkgdown site — was stale (site title/home page/CRAN version
  mismatched); rebuilt via commits `9d65d13`/`2acdd84` and now reflects 1.8.3.

## Clean-up candidates

Scratch/debug work for features already shipped — see `NEWS.md` v1.8.1–1.8.3. None of these
have actually been deleted yet, so all stay unchecked until the cleanup itself happens.

- [ ] `dev/pvPlot.R`, `dev/pvPlot-test.R` — superseded; `pvPlot()` shipped in v1.8.3 as
  `R/pvPlot.R` (see `NEWS.md`). `dev/Ellipse.R` still kept per the earlier note below
  (may be needed for a future group-ellipse-labeling feature).

- [ ] `dev/Robust-flowchart.Rmd` — a `DiagrammeR`/mermaid IRLS-algorithm flowchart; content
  matches the static `man/figures/IRWLS-flowchart.jpg` now embedded in `vignettes/Robust.Rmd`
  step-for-step, so this looks like the source used to produce that image (not verified who
  rendered it or when) — likely safe to drop once confirmed, rather than a live TODO.

- [ ] `issues/boxM-fix/` — resolved (singular-covariance-matrix fix for `boxM()`); has
  `BOXM_FIX_SUMMARY.md` documenting the fix.

- [ ] `issues/label-ellipse/` — resolved (`label.ellipse()` rewrite); has `IMPLEMENTATION_SUMMARY.md`.

- [ ] `dev/boxM/` (2026-09-10: grouped here from loose files directly in `dev/`) —
  remaining scratch/debug/planning work around `boxM()`, `plot.boxM()`, and `eigstatCI()`:
  `boot_cov.R`, `test_eigstatCI.R`, `test_traceCI.R`, `test_fix.R`, `test_labels.R`,
  `test_pooled_alignment.R`, `debug_ci_alignment.R`, `verify_ci_alignment.R`,
  `compare_trace_methods.R`, `demo_traceCI.R`, `README_traceCI.md`, `README_eigstatCI.md`,
  `eigstats-analytic.md`, `integrate_traceCI_plan.md`, `boxm-CI-align-test.jpg` — worth a
  skim before deleting in case anything belongs in a vignette, otherwise discard. (2026-09-10:
  the five stale duplicates of shipped code that were also here -- `boxM.R`, `eigstatCI.R`,
  `plot.boxM_boot.R`, `plot.boxM_with_bootstrap.R`, `traceCI.R` -- have been deleted.)

- [ ] `dev/noteworthy0.R`, `dev/noteworthy0a.R` — earlier drafts superseded by `R/noteworthy.R`.

- `dev/noteworthy/` (2026-09-10, moved in from the `ggbiplot` package's own `dev/` — a
  ggplot2 `stat_noteworthy()`/`StatNoteworthy` extension built on the already-shipped
  `heplots::noteworthy()`): `stat_noteworthy.R`, `test-noteworthy.R`,
  `ggextenders-noteworthy.md`, `peng-out-test.R`. Its `stat_noteworthy.R` name collided with
  a pre-existing, separate `dev/stat_noteworthy.R` (heplots' own earlier, unfinished attempt
  at the same idea) -- resolved 2026-09-10 by renaming the older one to
  `stat_noteworthy0.R` (matching the `noteworthy0.R`/`noteworthy0a.R` "earlier draft"
  convention above) and moving it alongside its continuation, into
  `dev/noteworthy/stat_noteworthy0.R`; both files kept in full, nothing deleted,
  cross-references between them updated.

## Not flagged (intentionally kept)

- `dev/pulpfiber.R` — referenced in `NEWS.md` 1.7.5 as a worked example, not meant to be merged
  into `R/`.

- `dev/GK-Project.md` — active planning notes for Gavin's funding application, not a package
  dev task itself; see the Roy-Bargmann TODO above for the one item it's spawned so far.
