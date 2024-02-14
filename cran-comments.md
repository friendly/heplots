## Test environments
* local Windows 10 install, R 4.3.1 (2023-06-16 ucrt)
* win-builder R Under development (unstable) (2024-02-13 r85898 ucrt)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> devtools::revdep()
[1] "candisc"      "effects"      "Guerry"       "HistData"     "latentnet"    "MapeBay"      "MorphoTools2"
[8] "mvinfluence"  "ordr"   

## revdepcheck results

We checked 9 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Comments

This is a minor release, adding some new functionality, fixing a few bugs and adding a new dataset.

## Version 1.6.2 (2024-02-14)

* Add `peng` dataset, a version of `palmerpenguins::penguins`
* Correct documentation problems from Roxygen 7.3.1 (@docType)

## Version 1.6.1 (2023-12-05)

* add warning to label.ellipse() if length(label.pos) > 1
* fixed label.pos in `coefplot.mlm()`
* add `ellipse.axes()` to draw axes of a covariance ellipse
* add `ellipse.box()` to draw conjugate axes of a covariance ellipse








