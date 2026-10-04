## Test environments
* local Windows 11 x64 install, R version 4.6.1 (2026-06-24 ucrt)
* win-builder R Under development (unstable)

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

## Version 1.8.5

A feature release adding two datasets, a new confidence-interval function, and
standardized-coefficient support, plus documentation/rendering maintenance:

* Added the `LearnDis` and `ReadingDisability` datasets, for worked
  MANOVA/MANCOVA and Roy-Bargmann stepdown examples.
* Added `traceCI()`, analytic confidence intervals for the trace of one or
  more covariance matrices, complementing `logdetCI()` and `eigstatCI()`.
* Added `stdmodel()` and `stdcoef()` for standardized ("beta") coefficients on
  `lm`/`mlm` objects; `coefplot.mlm()` gains a `std = TRUE` argument using
  this.
* Added a live, rotatable/zoomable `heplot3d()` example to the `HE_manova`
  vignette.
