## Test environments
* local Windows 11 x64 install, R version 4.6.2 (ucrt)
* win-builder R Under development (unstable) (2026-11-17 r90926 ucrt),
  Windows Server 2022 x64

## R CMD check results
0 error(s) | 0 warning(s) | 0 note(s), both locally and on win-builder (R-devel)

## Version 1.8.7

A release with bug fixes, new functions for multivariate Box-Cox transformations, and
three new datasets (see NEWS.md for full details):

* Bug fixes:
  - `heplot()`, `heplot1d()`, `heplot3d()`: in repeated-measures plots, ellipses for
    `hypotheses` were computed from the original responses but drawn in the within-S space,
    so they did not match the other ellipses. They are now tested in that space.
  - `heplot1d()` failed for any model with a covariate, or for repeated-measures plots.
  - `heplot()`: hypothesis labels used the label positions meant for the model terms.
* New functions `bcProfile()`, `bcRefit()` and `bcBoxM()` add profile-likelihood plots
  and a workflow around `car::powerTransform()` for multivariate Box-Cox transformations,
  including a criterion based on Box's M for homogeneity of covariance matrices.
* `heplot()` gains a `means.pos` argument for the positions of the factor-mean labels.
* New datasets `SnapBeans`, `Dystrophy` and `Phosphate`, from Rencher & Christensen (2012).


## Reverse dependencies checks

We checked 10 reverse dependencies, comparing R CMD check results across CRAN
(v1.8.6) and dev (v1.8.7) versions of this package.

* We saw 0 new problems
* We failed to check 0 packages

One reverse dependency, `Guerry` (which I also maintain), shows a vignette
ERROR with both the CRAN and dev versions of heplots: its vignette refers to an
image by a relative path into the package source. This is unrelated to heplots
and will be fixed in the next `Guerry` release.
