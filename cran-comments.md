## Test environments
* local Windows 11 x64 install, R version 4.6.1 (2026-06-24 ucrt)
* win-builder R Under development (unstable) (2026-09-30 r90605 ucrt)

## R CMD check results
0 error(s) | 0 warning(s) | 0 note(s)

## Version 1.8.6

A maintenance release with bug fixes, a new `robmlm()` method, documentation
clarifications, and a new cheatsheet (see NEWS.md for full details):

* Bug fixes: `termMeans()` attached row labels to the wrong means when the data
  were not sorted in factor-level order (also affecting `heplot1d()`);
  `eigstatCI()` computed its "pooled" statistic from the total rather than the
  pooled within-group covariance matrix (affecting `plot_boxM_boot()`); and
  fixes to `label.ellipse()`, `covEllipses()` and `pvPlot()`.
* Added a `robmlm.mlm()` method, so `robmlm()` can be applied directly to an
  existing `mlm` fit.
* Clarified in the documentation and vignettes how significance can be read
  from HE plots: **H** extending outside **E** in a 2D view implies
  significance, but not the converse.
* Added a two-page cheatsheet, linked from the README and the pkgdown site.


## Reverse dependencies checks

We checked 9 reverse dependencies, comparing R CMD check results across CRAN
(v1.8.5) and dev (v1.8.6) versions of this package.

* We saw 0 new problems
* We failed to check 0 packages

One reverse dependency, `Guerry` (which I also maintain), shows a vignette
ERROR with both the CRAN and dev versions of heplots: its vignette refers to an
image by a relative path into the package source. This is unrelated to heplots
and will be fixed in the next `Guerry` release.


## Comments

  *full* response space iff the term is significant by Roy's test, but in a 2D (or 3D) view
  the rule works one way only. **H** outside **E** means significant; **H** inside **E**
  does not mean "not significant". The `alpha` argument of `heplot1d()` is now correctly
  described as referring to the univariate F test for the response shown.

### Bug fixes

* Fixed `termMeans()`: when the data were not sorted in factor-level order, the row
  labels were attached to the wrong means (e.g., `peng` species, or the `Plastic`
  `rate:additive` cells in the `HE_manova` vignette). This also affected the mean labels
  in `heplot1d()`. Rows are now in **factor-level order** (first factor varying fastest), and
  empty cells are dropped instead of causing an error.

* Fixed `eigstatCI()`: the "pooled" statistic was computed from the total covariance
  matrix `cov(Y)`, ignoring groups, so it included the between-group variation. It now
  uses the pooled within-group covariance matrix, as in `boxM()$pooled`, and bootstraps it
  by resampling within groups. This changes the "pooled" point and CI in
  `plot_boxM_boot()`. This achieves a long-standing goal to make the plot methods related
  to `boxM()` more general, using bootstrap methods instead of asymptotic theory.

* Fixed `label.ellipse()`: the diagonal positions `label.pos = "SE"` and `"NW"` were
  swapped. The documentation for a fractional `label.pos` now says correctly that it is
  measured counterclockwise from East (0 = right, 0.25 = top).

* Fixed `covEllipses()`: `label.pos = NULL`, documented as giving automatic label
  positions, failed with "cannot replicate NULL". It now works. The documentation also
  wrongly said `NULL` was the default; the default is `0` (the ellipse center), and is
  unchanged.

* Fixed `pvPlot()` for tibbles (e.g., `peng`): it failed with "invalid type (list)",
  because selecting one column of a tibble does not give a vector. `X` is now converted
  with `as.data.frame()`.

