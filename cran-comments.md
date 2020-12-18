## Test environments
* local Windows 7 install, R 3.6.3
* win-builder R Under development (unstable) (2020-12-09 r79601)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> revdep()
[1] "candisc"     "effects"     "HistData"    "latentnet"   "mvinfluence"

> revdep_check(num_workers = 4)
*Wow, no problems at all. :)*

## Comments
This is a minor release, fixing a CRAN nit re conditional Suggests:rgl in examples & vignettes



