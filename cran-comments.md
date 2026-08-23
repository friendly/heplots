## Test environments
* local Windows 11 x64 install, R version 4.6.1 (2026-06-24 ucrt)
* win-builder R Under development (unstable) (2026-08-22 r90443 ucrt)

## R CMD check results
0 error(s) | 0 warning(s) | 0 note(s)

## Resubmission of v1.8.3 -> v1.8.4

This resubmission addresses the two `URL` findings from CRAN's win-builder
incoming-feasibility check on the v1.8.3 submission:

* `man/NeuroCog.Rd` cited the Nuechterlein et al. (2008) reference by a PubMed URL
  (`https://pubmed.ncbi.nlm.nih.gov/18172019/`); replaced with the article's DOI, written
  with the `\doi{}` macro rather than `\url{}` (a win-builder dry run flagged the first
  attempt for using `\url{}` around a `doi.org` link). Found and fixed two more
  pre-existing bare `doi.org` references the same way, in `Iwasaki_Big_Five` and `TIPI`.
* `vignettes/repeated-JSS.pdf` (a static reprint of the published *Journal of Statistical
  Software* article, included via the `R.rsp::asis` engine) had several embedded
  non-canonical URLs that are part of the original, already-published document and not
  under our control. Rather than continue explaining this on every submission, we've
  withdrawn the vignette to `vignettes-old/` and dropped the now-unused `R.rsp` from
  `Suggests`/`VignetteBuilder`.

Reverse dependencies were not re-checked for this resubmission: the only other change is a
second worked example added to the `Robust.Rmd` vignette and a small `distancePlot()`
documentation/bugfix update (gating a `cat()` call behind its existing `verbose` argument,
which previously fired unconditionally). Nothing exported changed signature of any function. The prior
check of 9 reverse dependencies against v1.8.3, with 0 new problems, still applies.

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
