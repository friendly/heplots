## Test environments
* local Windows 10 install, R 4.3.2 (2023-10-31 ucrt)
* win-builder R Under development (unstable) (2024-04-29 r86495 ucrt)

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

This is a semi-major release, primarily documenting all datasets in the package with `@concept` tags.
It also adds new datasets and fixes bugs and documentation errors since the last CRAN release (v 1.6.2)

## Version 1.7.0 (2024-05-01)

* Added a new example (`AddHealth` data) to the `HE_manova` vignette
* Added `Overdose` data, a simple MMRA example.
* All datasets now classified by `@concept` tags in documentation, giving the primary methods ("MANOVA", "MMRA", "repeated", ...) that they illustrate. These supplement `@keyword` tags and appear in the index of the package documentation.
* A new vignette (`datasets`) lists the datasets in the package, classified by these `@concept` tags.


## Version 1.6.3 (2024-03-05)

* Correct documentation error in `cqplot()`
* `cqplot()` now returns DSQ values for identified points
* Fixed small buglet re: labeling of hypothesis ellipses in `heplot()`


