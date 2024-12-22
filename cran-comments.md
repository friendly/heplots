## Test environments
* local Windows 10 install, 4.4.1 (2024-06-14 ucrt)
* win-builder R Under development (unstable) (2024-12-21 r87453 ucrt)

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


## Version 1.7.3 (2024-12-05)

This is a moderate update, adding new functionality

* `leveneTests()` gains formula and lm methods
* `bartlettTests()` gains formula and lm methods
* `colDevs()` gains a `group.var` argument; examples extended
* Added `uniStats()` for an anova version of `glance.mlm()`
* Corrected documentation of `covEllipses()` to more accurately describe recycling of arguments.
* `size="significance"` now allowed as a synonym for `size="evidence"` in heplot functions.

## Version 1.7.2 (2024-11-25)

* Fixed bug in `ellipse.axes()` re center/centre
* `ellipse.axes()` gains a `type` argument to draw lines or arrows
* `ellipse.axes()` gains a `extend` argument to extend/shrink the axes



