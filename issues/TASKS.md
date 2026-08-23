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
  https://github.com/datalorax/equatiomatic/issues/243 (no response yet). Design work has
  progressed substantially since the last update (`dev/equatiomatic-notes.md` now has a
  resolved implementation strategy — refit-prototype-lm-then-post-process — a concrete
  function signature, and resolved decisions on notation/generic names/coefficient
  precision); still not implemented in `R/`.
  Files: `dev/equatiomatic-notes.md`, `dev/equatiomatic.R`, `dev/equatiomatic-test.R`,
  `dev/equatiomatic-notes.html`

- [ ] `pred.mlm()` — extend `predict.lm`-style CIs/PIs to multivariate (`mlm`) models; draft only
  (`pred.mlm0`), not yet roxygenized or added to `R/`.
  File: `dev/pred.mlm.R`

- [ ] Roy-Bargmann stepdown analysis (`RoyBargmann()`) — candidate topic for Gavin's funding
  application, not yet started as package code. Notes/goals (general function to fit the
  sequential stepdown model set, plus a `heplot()`-based visualization story) in
  `dev/GK-Project.md`, which also lists `predict.mlm()` above, robust-MLM extensions,
  and effect-size/canonical-space tie-ins as related candidate topics.
  File: `dev/GK-Project.md`

- [ ] Decide finish-or-drop on two small utility drafts: `standardize.R` (standardized regression
  coefficients, adapted from `QuantPsyc::lm.beta`) and `se_variance.R` (SE of variance).
  Files: `dev/standardize.R`, `dev/se_variance.R`

- [ ] Drop the hard `Depends: broom` in favor of `Imports: generics` for `glance.mlm()` --
  register the S3 method against `generics::glance` (the lightweight package defining the
  generic, which `broom` itself depends on) instead of `broom::glance`. Checked 2026-08-23:
  master still has `Depends: broom` and nothing else in `R/` uses `broom::`, so this is still
  fully applicable, not superseded. Abandoned mid-flight in 2023 on the `rm-glance` branch
  (single commit `1f59fad`, kept as `origin/rm-glance`, not merged) -- would need
  `DESCRIPTION` (`Depends`/`Imports`), `NAMESPACE`, `R/glance.mlm.R`, and `R/zzz.R`'s
  `.onLoad()` registration all updated together. Deliberately not picked up during the
  v1.8.4 CRAN resubmission; candidate for a later release.
  Branch: `origin/rm-glance`

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

- [ ] `dev/test_eigstatCI.R`, `dev/test_traceCI.R`, `dev/test_fix.R`, `dev/test_labels.R`,
  `dev/test_pooled_alignment.R`, `dev/debug_ci_alignment.R`, `dev/verify_ci_alignment.R`,
  `dev/compare_trace_methods.R`, `dev/demo_traceCI.R` — scratch/debug scripts used to build
  `traceCI()`/`eigstatCI()`, now shipped as `R/traceCI.R`/`R/eigstatCI.R`.

- [ ] `dev/noteworthy0.R`, `dev/noteworthy0a.R` — earlier drafts superseded by `R/noteworthy.R`.

- [ ] `dev/README_traceCI.md`, `dev/README_eigstatCI.md`, `dev/eigstats-analytic.md`,
  `dev/integrate_traceCI_plan.md` — planning/dev notes for now-shipped features; worth a skim
  before deleting in case anything belongs in a vignette, otherwise discard.

## Not flagged (intentionally kept)

- `dev/pulpfiber.R` — referenced in `NEWS.md` 1.7.5 as a worked example, not meant to be merged
  into `R/`.

- `dev/GK-Project.md` — active planning notes for Gavin's funding application, not a package
  dev task itself; see the Roy-Bargmann TODO above for the one item it's spawned so far.
