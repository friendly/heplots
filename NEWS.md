## Version 1.7.5 

* Edit description of NLSY data

## Version 1.7.4 (2025-04-15)

This is largely a maintenance release, but adds a function to identify "noteworthy" points in 2D scatterplots.

* added plotting all X vs all Y to Rohwer examples
* added `schoolsites` dataset, providing additional variables related to the `schooldata` dataset.
* `cqplot()` now prints a warning if there are missing cases and also returns the upper tail p-values corresponding to Mahalanobis $D^2$.
* Default `method.id` in `cqplot()` changed to "r", to identify points with the largest $D^2$.
* added `noteworthy(x, y)` as a utility to select "noteworthy" observations in a 2D plot, extending the ideas in `car::showLabels()`
* corrected some minor documentation problems
* fixed some 301 "moved" URLs
* Now Depends: on R >= 4.1.0 because package uses native pipes |>
* Added Suggests: KernSmooth, aplpack, foreign, used in some demos

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

## Version 1.7.1 (2024-11-14)

This is a modest update, adding two new datasets for simple examples and a PDF vignette

* Extended the "datasets" vignette with further description of how this was done.
* Added `dogfood` and `oral` datasets, both simple MANOVA examples.
* Added HE Plots for Repeated Measures Designs vignette
* Fixed nits from URLs vanished or moved

## Version 1.7.0 (2024-05-01)

This is a semi-major release, primarily documenting all datasets in the package with `@concept` tags.
It also adds new datasets and fixes bugs and documentation errors since the last CRAN release (v 1.6.2)

* Added a new example (`AddHealth` data) to the `HE_manova` vignette
* Added `Overdose` data, a simple MMRA example.
* All datasets now classified by `@concept` tags in documentation, giving the primary methods ("MANOVA", "MMRA", "repeated", ...) that they illustrate. These supplement `@keyword` tags and appear in the index of the package documentation.
* A new vignette (`datasets`) lists the datasets in the package, classified by these `@concept` tags.

## Version 1.6.3 (2024-03-05)

* Correct documentation error in `cqplot()`
* `cqplot()` now returns DSQ values for identified points
* Fixed small buglet re: labeling of hypothesis ellipses in `heplot()`

## Version 1.6.2 (2024-02-14)

* Add `peng` dataset, a version of `palmerpenguins::penguins`
* Correct documentation problems from Roxygen 7.3.1 (@docType)

## Version 1.6.1 (2023-12-05)

* add warning to label.ellipse() if length(label.pos) > 1
* fixed label.pos in `coefplot.mlm()`
* add `ellipse.axes()` to draw axes of a covariance ellipse
* add `ellipse.box()` to draw conjugate axes of a covariance ellipse

## Version 1.6.0 (2023-08-30)

* converted pkg to roxygen documentation
* now Suggests: car rather than Depends:
* fix CITATION authors

## Version 1.5.0 (2023-05-30)

* `covEllipses()` gains a formula method
* Internal function `ellipsoid()` used in `heplot3d()` becomes an (experimental) exported function, `Ellipsoid()`

## Version 1.4-3 (2023-01-02)

* replace rgl.pop() with pop3D (PR #7); thx: D. Murdoch

## Version 1.4-2 (2022-10-09)

* Fix CITATION

## Version 1.4-1 (2022-10-01)

* (Ugh) broom becomes a Depend: so as not to override `broom::glance()`

## Version 1.4-0 (2022-09-26)

* Added Iwasaki_Big_Five data [Thx: James Grice]
* Added `cex.label` arg to `heplot3d()`
* Convert old Rnw vignettes to Rmd
* Fix documentation infelicities
* Added TIPI data
* Added `glance.mlm()` as an extension of `broom::glance.lm()`

## Version 1.3-9 (2021-10-06)

* Fix potential problem with URL links to JSS articles, now converted to DOIs

## Version 1.3-8

* fix CRAN nit re rgl in examples

## Version 1.3-7 

* Fix rendering of 3D heplots [Thx: Duncan Murdoch]
* Fix URLs

## Version 1.3-6 (2019-03-26)

* add mathscore data
* fix bug in `etasq.lm()` per #1 [thx: Phil Chalmers]
* bump pkg version
* remove Suggests: FRB

## Version 1.3-5 (2018-04-02)

* fix references to car datasets -> carData
* fix error resulting from car 3.0 changes
* bump pkg version

## Version 1.3-4 (2016-11-7)

* Added Diabetes data, a nice example of heterogeneity of covariances

## Version 1.3-3 (2016-10-21)

* Added Parenting data, a simple one-way MANOVA design (used in TQMP paper)
* Prepare for CRAN release

## Version 1.3-1 (2016-06-10)

* added `plot.robmlm()`, a plot method for "robmlm" objects.  Currently, it plots the weights given
  to observations in the last iteration as an index plot.
* Re-built vignettes

## Version 1.3-0 (2016-06-03)

* In cqplot, pch, col, and cex can now be vectors
* Bump version, prepare for release

## Version 1.2-1 (2016-05-19)

* in `coefplot.mlm()`, now pass `label.pos` to label.ellipse()
* added `Mahalanobis()` for classical and robust squared distances; handles 
  missing data gracefully and provides a confidence envelope
* added SocialCog data [Thx: Leah Hartman]
* added `cqplot()` of Mahalanobis distances as a plot method for an mlm and for 
  multivariate data

## Version 1.2-0 (2016-04-27)

* `covEllipses()` extended to more than two variables, giving a scatterplot matrix plot
* plot.boxM() now can plot other measures of the eigenvalues of the covariance matrices,
  useful for understanding the properties of the test.
* added `bartlettTests()` for a collection of univariate Bartlett tests 
* added `leveneTests()` for a collection of univariate Levene tests 
* added NeuroCog data, a simple one-way MANOVA [Thx: Leah Hartman]
* label.ellipse() now uses a much more flexible `label.pos` argument for positioning the
  text labels used in `heplot()` and friends.

## Version 1.1-0 (2016-03-03)

* Added boXM from biotools
* Fleshed out `boxM()` with formula, lm, plot and summary methods
* added plot.boxM() method
* Added `covEllipses()` methods for plotting (possibly robust) covariance ellipses
* Added colDevs() as a utility and for use in other multivariate tests.
* Added data(AddHealth), a simple example of a one-way MANOVA with nice views [thx: Russell Warne]
* summary.boxM() now returns the calculated statistics and can be used to construct other kinds of plots.
* plot.boxM() gets a gplabel argument to provide a label for the group factor
* pairs.mlm() gets a var.cex argument to control size of variable labels
* Added logdetCI() for confidence intervals on log determinants of covariance matrices (experimental)
* Now use logdetCI() in plot.boxM()


## Version 1.0-16 (2015-07-11)
* use importsFrom for base packages

## Version 1.0-15 (2015-04-15)
* Fix require -> requireNamespace

## Version 1.0-14 (2015-02-15)
* Updated broken urls in documentation
* Removed vcov.mlm from exports to conform to CRAN policies
* Now use rgl:: for rgl functions in *3d.R
* Removed robmlm.default, robmlm.formula from exports
* Imports: rgl


## Version 1.0-12 (2014-05-15)
* Removed Authors: to satisfy CRAN nits
* Fixed doc for Hernior.Rd
* Now importsFrom(MASS) rather than Depends:


## Version 1.0-11 (2013-08-20)
* Cosmetic changes to pass CRAN checks
* For R 3.1.0, revised vcov.mlm() to avoid calling summary.mlm() directly
* fixed long lines in .Rd files for R 3.0.1 checks
* removed require() calls for MASS & car (Depends:)
* removed ::: calls to car and stats

## Version 1.0-10 (2013-06-03)
* Added demo/HE-other.R, exploring other representations of HE plots

## Version 1.0-9 (2013-04-19)
* Added Pottery2 data, extending car::Pottery
* Fixed heplot3d to minimize striated rendering of ellipsoids, and also modified default
  colors and fill.alpha

## Version 1.0-8 (2013-02-22)
* In heplot.mlm(), added ... to label.ellipse to be able to pass cex=
* Added NLSY data with examples of testing linearHypotheses
* In heplot3d(), rgl.* functions replaced with *3d() equivalents
* Extended gsorth description and examples
 

## Version 1.0-7 (2013-02-07)
* Made some heplot3d() examples \dontrun{} to reduce example execution time to satisfy CRAN nits

## Version 1.0-6 (2013-01-14)
* Added label.ellipse() as a more general exported function.
* heplot() gets a label.pos= argument allowing more flexible labeling, with
  the label position to be specified (bottom, left, top, right or center)
* Added coefplot S3 generic and a coefplot.mlm method to plot ellipses for mlm coefficients.
  This generalizes car::confidenceEllipse to the mlm setting.

## Version 1.0-4 (2012-12-29)
* Added interpPlot for plotting interpolations between two data sets, with data ellipses, etc.
  Main use for this is in animated demos of multivariate statistical concepts.
* interpPlot gains add=, points= and col= arguments for greater control of graphical parameters.

## Version 1.0-2 (2012-12-05)
* Added Schooldata and further example of comparison of mlm with robmlm()

## Version 1.0-1 (2012-10-18)
* Added simple robmlm methods for robust MLMss with print and summary methods and a vcov.mlm method.
  This allows heplot() and related methods to show robust HE plots.

## Version 1.0-0 (2012-6-3)
* Added Olso data
* Corrected error in demo/OBK.R

## Version 0.9-13 (2012-5-18)
* Extended HE-examples vignette with example based on SocGrades data

## Version 0.9-12 (2012-04-03)
* Added Skulls data
* Extended HE-examples vignette with example based on Skulls data
* Changed the default colors for heplot() and heplot1d() to allow global setting
  of options("heplot.colors"); similarly, heplot3d() now allows a global option
  for colors, options("heplot3d.colors"), differing only in using pink for error
  ellipsoid.
* Extended Hernior.Rd examples to show 1D plots in canonical space; added a discussion of
  this example to HE-examples vignette.
* Extended SocGrades.Rd examples to show plots in canonical space.

## Version 0.9-11 (2012-01-12)
* Added Probe1, Probe2 data sets-- repeated measures design
* Added Sake data

## Version 0.9-10 (2011-09-12)
* Fixed Authors@R in DESCRIPTION for R 2.14.x
* Added var.labels argument to pairs.mlm
* gsorth.R: Made sd() a local function to avoid deprecated warnings

## Version 0.9-9 (2011-06-10)
* Added data(Hernior), another MMRA, cancorr example data set
* Added data(SocGrades), another MANOVA, MMRA, cancorr example data set
* Corrected buglet with fill.alpha in heplot

## Version 0.9-8 (2011-04-8)
* Added an MMRA example to HE-examples vignette
* Added err.label argument to heplot and heplot3d to allow changing the label for the error ellipsoid

## Version 0.9-7 (2010-11-4)
 o Added trans.colors() to make colors transparent
 o Modifications to heplot() for filled ellipses: added fill= and fill.alpha= arguments; replaced lines() 
   with polygon() for H and E ellipses; calculate H.rank to distinguish degenerate ellipses
 o added last() to utility.R 
 o Modified some examples to show fill=TRUE and use wire=FALSE in heplot3d()
 o Modified pairs.mlm() to pass fill= and fill.alpha= to heplot()
 o Updated reference URLs to point to datavis.ca
 o Fixed buglet in gsorth when matrix has no row/col names [Thx: mekki@mektek.ca]
 o Fixed buglet in etasq.lm with partial=FALSE [Thx: i.e.holliday@aston.ac.uk]
 
 Version 0.9-6 (2010-11-2)
 o added CITATION to JSS article and references to .Rd files
 o modified repeated vignette to [nojss]
 
 Version 0.9-5 (2010-10-01)
 o Added repeated vignette 

 Version 0.9-4 (2010-07-29)
 o Minor documentation changes
 o Added etasq.lm() method
 o Added data/MockJury - 1-way and 2-way MANOVA, step-down tests, ANCOVA
 o Generalized termMeans() and exported it
 o Added HE-examples vignette
 
 Version 0.9-3 (2010-07-27)
 o Added gsorth() for Gram-Schmidt orthogonalization of a matrix or data frame, preserving
    column means and standard deviations
 o Avoid Deprecated warnings (linear.hypothesis) with car2
 o Fixed documentation warnings with car2 (linear.hypothesis, data.ellipse) 
 
 Version 0.9-2 (2010-02-12)
 o Added demo/Big5.R - Analysis of scores on the 'Big 5' personality traits for three groups
 o fixed buglet with text3d causing rgl to crash (thx: Duncan Murdoch)
 o switched inst/CHANGES to NEWS
 o Added data/RatWeight and examples - repeated measures on Weight Gain in Rats
 o Added data/Headache and examples - repeated measures on treatment for headaches
 o Fixed buglets in heplot, heplot1d, heplot3d regarding number of variables
 o Added etasq.mlm methods for multivariate measures of association (\eta^2)
 o Return ellipse radius from heplot, heplot3d

## Version 0.9-1 (2010-01-1)
 o heplot.mlm, pairs.mlm, heplot3d.mlm now work for repeated measure designs
   with only covariates on the rhs.
 o Implemented heplot1d() for repeated measures designs (untested)
 o Revised documentation for repeated measures
 o Added center.cex to heplot.mlm()
 o Revised mark.H0() to handle 3D plots also
 o Added Adoption data -- MMreg with repeated measures
 o Added ReactTime data -- 2 within-S, no between-S factors
 o Fixed bug with icontrasts
 o Added markH0 argument to heplot
 o Added label argument to mark.H0()
 o Added arrow3d()
 o Fixed buglet in pairs.mlm (type)
 
## Version 0.9-0 (2009-12-25)
 o Implemented 2D HE plots in heplot.mlm for repeated measures designs by adding
   idata=, idesign=, icontrasts= arguments.  
 o imatrix= argument  for doubly-multivariate designs implemented, but depends on car 2.0+
 o Updated example(OBK) 
 o Updated example(WeightLoss)
 o Implemented 3D HE plots in heplot3d.mlm for repeated measures designs (OK)
 o Implemented pairs() for repeated measures designs (OK)

## Version 0.8-11 (2009-12-08)
 o Minor fixes to heplot1d
 o Added contrasts example to RootStock.Rd
 o Added WeightLoss data -- doubly multivariate
 o Added mark.H0

## Version 0.8-10 (2009-10-10)
 o Fixes to cross-references in .Rd files.

## Version 0.8-9 (2009-06-19)
 o Added data(RootStock)
 o heplot.mlm, heplot3d.mlm now include center in the returned object
 
## Version 0.8-8 (2009-06-04)
 o Added data(FootHead)
 o Extended example(FootHead)

 Version 0.8-7 (2009-04-17)
 o Initial version of heplot1d
 o Added data(Bees), demo(bees.contrasts)
 o Now suggest: effects package

## Version 0.8-6 (2009-04-11)
 o Added VocabGrowth data, with an example of heplot() for a repeated measures design
 o Fixed label.ellipse in heplot.mlm.R to center the label horizontally
 o Added demo(OBK)
 o Added axes= to heplot.mlm to fix warnings arising from axes=FALSE in pairs.mlm 
 
## Version 0.8-5 (2009-01-26)
 o Minor documentation changes for Rdoc 2
 o Michael Friendly as maintainer

## Version 0.8-4 (2008-11-17)
 o Documentation additions
 o added CITATION file

## Version 0.8-3 (2008-11-6)
 
* Changes to heplot3d.mlm:
 o  added xlim, ylim, zlim arguments

## Version 0.8-2 (2008-10-22)

* Package changes
 o  added suggests: candisc
 o  added utility.R, cross3d.R

* Changes to heplot.mlm:
 o  moved lambda.crit to utility.R
 o  added he.rep to handle common task of repeating HE argument values

* Changes to heplot3d.mlm:
 o  added shade=, shade.alpha=, wire= parameters
 o  fixed: grand.mean=FALSE not respected
 o  replaced sphere at grand.mean with cross3d()
 o  color means according to the color of the term
 o  return bounding boxes of the ellipsoids
 o  replaced rgl.texts with texts3d
 
* Changes to utility.R:
 o  Generalized lambda.crit to provide Roy.crit and HLT.crit; only Roy.crit is used
 
## Version 0.8-1 (2007-05-23)

 o  heplot now passes ... not only to plot() but to calls to text() and points().

## Version 0.8-0 (2007-01-31)

* Initial version released to CRAN.

