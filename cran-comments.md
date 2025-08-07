## Test environments
* local Windows 10 install, 4.5.1 (2025-06-13 ucrt)
* win-builder R Under development (unstable) (2025-08-05 r88509 ucrt)
* devtools::check_mac_release() using R version 4.5.1 Patched (2025-07-10 r88405)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> revdep()
[1] "candisc"      "effects"      "Guerry"       "HistData"     "ICSClust"     "latentnet"   
[7] "MorphoTools2" "mvinfluence"  "volker" 

## revdepcheck results

We checked 9 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Version 1.7.8

Several small maintenance fixes, plus a new diagnostic plot and a new vignette

o Added `distancePlot()` for plots of Mahalanobis distances of X vs Y
o Added a vignette on robust MLMs using `robmlm()` and diagnostic plots

## Version 1.7.6 

* fixing data, group names in boxM to avoid necessity for `gplabel` in plots.
* added reference for CI in `plot.boxm()`

