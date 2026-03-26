## Test environments
* local Windows 10 install, 4.5.1 (2025-06-13 ucrt)
* win-builder R Under development (unstable) (2025-12-05 r89107 ucrt)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> revdep()
[1] "candisc"      "effects"      "Guerry"       "HistData"     "ICSClust"     "latentnet"   
[7] "MorphoTools2" "mvinfluence"  "volker" 

### revdepcheck results

We checked 9 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

## Comments

This is a large cumulative release of several versions since the last CRAN release.

### Version 1.8.1

* `label.ellipse()` now returns invisibly the coordinates where the label was placed.
* `heplot()` adds a `label.cex` argument to control the size of labels on H/E ellipses. The `label.pos` argument is vectorized, so that the changes to `label.ellipse()` now apply.
* `boxM()` & `plot.boxM()` now correctly handle the situation where one or more groups have singular covariance matrices because !n>p
* Fixed bug in `covEllipses.boxM()` method. `boxM()` now returns `ngroups` and `means` among it's components.
* add `@family` tags to improve cross-referencing in documentation


### Version 1.8.0

* describe more fully constructing the datasets table using concept tags
* added `text_usr()` to add text in normalized device coordinates
* begin to convert documentation to use markdown via {roxygen2md}
* `label.ellipse()` re-written to allow a fully general way to specify label positions [Thx: Claude]

### Version 1.7.9

* plot.robmlm() gains a `groups` arg to vary point color and `pch`
* plot.robmlm() gains a `group.axis` arg to draw an axis identifying the groups at the top of the plot.

