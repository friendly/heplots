## Test environments
* local Windows 7 install, R version 4.2.1 (2022-06-23 ucrt)
* local Windows 10 install, R 4.0.2
* win-builder R Under development (unstable) (2022-09-25 r82916 ucrt)
* win-builder R version 4.2.1 (2022-06-23 ucrt)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> devtools::revdep()
[1] "candisc"      "effects"      "Guerry"       "HistData"     "latentnet"    "MapeBay"      "MorphoTools2"
[8] "mvinfluence"  "ordr"   

## revdepcheck results

We checked 9 reverse dependencies (4 from CRAN + 5 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Comments

This is a major release, adding Rmd vignettes that caused problems in their Sweave Rnw versions. No longer have to go through `qpdf` to compress. The new vignettes are more detailed, with more description and plots.

## Version 1.4-1 (2022-10-01)

* (Ugh) broom becomes a Depend: so as not to override `broom::glance()` and to pass revdep checks from MapeBay

## Version 1.4-0 (2022-09-26)

* Added Iwasaki_Big_Five data [Thx: James Grice]
* Added `cex.label` arg to `heplot3d()`
* Convert old Rnw vignettes to Rmd
* Fix documentation infelicities
* Added TIPI data
* Added `glance.mlm()` as an extension of `broom::glance.lm()`





