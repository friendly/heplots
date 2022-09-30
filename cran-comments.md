## Test environments
* local Windows 7 install, R version 4.2.1 (2022-06-23 ucrt)
* local Windows 10 install, R 4.0.2
* win-builder R Under development (unstable) (2022-09-25 r82916 ucrt)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> devtools::revdep()
[1] "candisc"      "effects"      "Guerry"       "HistData"     "latentnet"    "MapeBay"      "MorphoTools2"
[8] "mvinfluence"  "ordr"   

> revdep_check(num_workers = 4)
*Wow, no problems at all. :)*

## Comments
`heplots` v.1.4-0 was submitted to CRAN via `devtools::release()` on Sept. 27?, but I have had no replies, so
perhaps this did not take.  I am resubmitting a new source package, with some documentation additions/changes.

This is a major release, adding Rmd vignettes that caused problems in their Sweave Rnw versions. No longer have to go through `qpdf` to compress. The new vignettes are more detailed, with more description and plots.

## Version 1.4-0 (2022-09-26)

* Added Iwasaki_Big_Five data [Thx: James Grice]
* Added `cex.label` arg to `heplot3d()`
* Convert old Rnw vignettes to Rmd
* Fix documentation infelicities
* Added TIPI data
* Added `glance.mlm()` as an extension of `broom::glance.lm()`





