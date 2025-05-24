## Test environments
* local Windows 10 install, 4.4.3 (2025-02-28 ucrt)
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


## Version 1.7.5 

Fix bugs and add some args for better control

* Edit description of NLSY data and extend the examples to show `coefplot()`, `cqplot()`
* Revise documentation for `robmlm()`
* Add dev/pulpfiber.R for a classic robust MLM example
* fix default Y axis label in `plot.robmlm()`
* fixed bug in `coefplot.mlm()` in selecting terms with `parm`.
* `coefplot.mlm()` gains a `cex.lab` argument
* Fleshed out details of Rohwer dataset PA measures
* Fixed nits from R CMD check



