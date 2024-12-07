## Test environments
* local Windows 10 install, 4.4.1 (2024-06-14 ucrt)
* win-builder R Under development (unstable) (2024-11-22 r87365 ucrt)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> devtools::revdep()
[1] "candisc"      "effects"      "Guerry"       "HistData"     "ICSClust"     "latentnet"    "MorphoTools2"
[8] "mvinfluence"  "ordr"

## revdepcheck results

We checked 9 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Version 1.7.1 (2024-11-14)

This is a modest update, adding two new datasets for simple examples and a PDF vignette

* Extended the "datasets" vignette with further description of how this was done.
* Added `dogfood` and `oral` datasets, both simple MANOVA examples.
* Added HE Plots for Repeated Measures Designs vignette
* Fixed nits from URLs vanished or moved



