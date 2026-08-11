## Test environments
* local Windows 10 x64 install, R Under development (unstable) (2026-08-10 r90389 ucrt)
* win-builder (R-devel)

## R CMD check results
0 error(s) | 0 warning(s) | 0 note(s)



## Reverse dependencies checks


We checked 9 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 0 packages


## Comments

## Version 1.8.3

This is a modest cumulative release of several versions since the last CRAN release (v 1.8.1)

* Added a link to the NLSY97 Cohort Index in `NLSY`'s documentation.
* Added `pvPlot()` for partial variable plots: visualizes the partial correlation between two
variables after controlling for all others, as a scatterplot of the residuals from regressing
each on the rest, enhanced with a data ellipse, regression line, and point labels for unusual
cases. Similar in spirit to `car::avPlots()`, but works directly on a data frame rather than a
fitted model.
* Added cute 404 page for `pkgdown`
* Added a general `.release_checks.R` script in the repo (but `.Rbuildignore`d)

## Version 1.8.2

* add `eigstatsCI()` to calculate bootstrapped confidence intervals for eigenvalue statistics, as used in `plot.boxM()`
* added `plot_boxM_boot()` to plot these with bootstrapped CIs
* added `traceCI()` for use in `plot.boxM()`

