# heplots — development tasks

Broken out from the cross-package working list in `C:\Users\friendly\Dropbox\R\TASKS.md`
(2026-07-28). Update here as items are finished; sync back to the main list only if it's
useful to see heplots status at a glance across packages.

## TODOs

- [ ] `extract_eq.mlm()` for `equatiomatic` — S3 method to make `equatiomatic::extract_eq()` work on
  `mlm` objects (currently produces garbled LaTeX). Filed as an issue upstream:
  https://github.com/datalorax/equatiomatic/issues/243 (no response yet).
  Files: `dev/equatiomatic-notes.md`, `dev/equatiomatic.R`, `dev/equatiomatic-test.R`,
  `dev/equatiomatic-notes.html`
  
- [ ] `pred.mlm()` — extend `predict.lm`-style CIs/PIs to multivariate (`mlm`) models; draft only
  (`pred.mlm0`), not yet roxygenized or added to `R/`.
  File: `dev/pred.mlm.R`
  
- [ ] Decide finish-or-drop on two small utility drafts: `standardize.R` (standardized regression
  coefficients, adapted from `QuantPsyc::lm.beta`) and `se_variance.R` (SE of variance).
  Files: `dev/standardize.R`, `dev/se_variance.R`
  
- [ ] `Robust-flowchart.Rmd` — draft flowchart for robust MLM workflow; check whether it made it into
  the robust-MLM vignette already, otherwise finish or drop.
  File: `dev/Robust-flowchart.Rmd`

- [ ] `pvPlot()` -- general partial variable plots akin to `car::avPlot()`. Copied here from the
  Vis-MLM-book project: `dev/pvPlot.R`, `dev/pvPlot-test.R`, `dev/Ellipse.R` (2026-08-10).
  NOT blocked on upstream car after all: `pvPlot.R` now calls `car::dataEllipse()` directly
  (verified 2026-08-10 -- the `label.ellipse()` `cex` bug, filed at
  https://github.com/bprice2652/car_repo/issues/1 and still unresolved, only triggers via
  dataEllipse's `ellipse.label` arg, which pvPlot() never passes; full cex-varying test suite
  passes against plain installed car 3.1.5). `dev/Ellipse.R` kept around for if/when a future
  feature (e.g. group ellipse labeling) needs it. Not yet roxygenized into `R/` or added to
  `NAMESPACE`. Background/design notes (examples, TODOs like a `pvPlots()` all-pairs wrapper
  and a formula interface, factor-support caveats) remain in
  C:\R\Projects\friendly.github.io\blog\drafts\Ideas-Notes\partial-var-plots.md

- [ ] Rebuild the pkgdown site — versions are out of sync. Site title says "heplots 1.8.2", but
  the home page content says "Version 1.8.0; documentation built for pkgdown 2025-12-05" (noted
  2026-08-10), CRAN is at 1.8.1, and local `DESCRIPTION` is already at 1.8.3. `.build-steps.R`
  has the build sequence (`devtools::build_readme()` then `pkgdown::build_site(lazy = TRUE)`,
  among other release-prep steps) — run it and push the rebuilt `docs/`.

## Clean-up candidates

Scratch/debug work for features already shipped — see `NEWS.md` v1.8.1–1.8.2.

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
