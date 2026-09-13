## Test environments
* local Windows 11 x64 install, R version 4.6.1 (2026-06-24 ucrt)
* win-builder R Under development (unstable)

## R CMD check results
0 error(s) | 0 warning(s) | 0 note(s)

## Version 1.8.5

A feature release adding two datasets, a new confidence-interval function, and
standardized-coefficient support, plus documentation/rendering maintenance (see
NEWS.md for full details):

* Added the `LearnDis` and `ReadingDisability` datasets, for worked
  MANOVA/MANCOVA and Roy-Bargmann stepdown examples.
* Added `traceCI()`, analytic confidence intervals for the trace of one or
  more covariance matrices, complementing `logdetCI()` and `eigstatCI()`.
* Added `stdmodel()` and `stdcoef()` for standardized ("beta") coefficients on
  `lm`/`mlm` objects; `coefplot.mlm()` gains a `std = TRUE` argument using
  this.
* Added a live, rotatable/zoomable `heplot3d()` example to the `HE_manova`
  vignette.


## Reverse dependencies checks

We checked 9 reverse dependencies, comparing R CMD check results across CRAN
(v1.8.4) and dev (v1.8.5) versions of this package.

* We saw 0 new problems
* We failed to check 0 packages


## Comments

## Version 1.8.4

CRAN resubmission of v1.8.3, addressing two `URL` findings from the win-builder
CRAN-incoming-feasibility check.

* Fixed the `NeuroCog` documentation to cite the Nuechterlein et al. (2008) reference by
  DOI instead of a PubMed URL that CRAN flagged as needing an update. A win-builder dry
  run then flagged the replacement itself: CRAN wants bare `doi.org` links written with
  the `\doi{}` macro, not `\url{}`. Fixed that in `NeuroCog`, and found (and fixed the
  same way) two more pre-existing bare `doi.org` references in `Iwasaki_Big_Five` and
  `TIPI`'s documentation that hadn't yet been flagged.
* Withdrew `vignettes/repeated-JSS.pdf` (a static reprint of the published *Journal of
  Statistical Software* article, included via the `R.rsp::asis` engine) to `vignettes-old/`,
  rather than continue explaining its embedded non-canonical URLs to CRAN on every
  submission. Dropped the now-unused `R.rsp` from `Suggests`/`VignetteBuilder`.
* Added a second, shorter worked example to the `Robust.Rmd` vignette using the
  `robustbase::pulpfiber` data (Rousseeuw et al. 2004): a multivariate multiple regression
  contrasted with the earlier Pottery MANOVA example, using the weight plot and an
  MCD-based `distancePlot()` to distinguish vertical outliers, a bad leverage point, and
  two good leverage points.
* `distancePlot()` documentation now cross-links `robmlm()`, `car::influencePlot()`, and
  `mvinfluence`'s `influencePlot.mlm()` method; fixed `verbose` argument not actually
  gating the cutoff `cat()` line.
