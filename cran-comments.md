## Test environments
* local Windows 10 install, 4.4.1 (2024-06-14 ucrt)
* win-builder R Under development (unstable) (2025-04-13 r88141 ucrt)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> devtools::revdep()
> devtools::revdep()
 [1] "candisc"      "effects"      "Guerry"       "HistData"     "ICSClust"     "latentnet"    "MorphoTools2"
 [8] "mvinfluence"  "ordr"         "volker"
 
## revdepcheck results

We checked 10 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Version 1.7.4 (2025-04-015)

* added plotting all X vs all Y to Rohwer doc
* added `schoolsites` dataset
* `cqplot()` now prints a warning if there are missing cases and also returns the upper tail p-values corresponding to Mahalanobis $D^2$.
* Default `method.id` in `cqplot()` changed to "r", to identify points with the largest $D^2$.
* added `noteworthy()` as a utility to select "noteworthy" observations in a 2D plot.




