[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/heplots)](http://cran.r-project.org/package=heplots)
[![](http://cranlogs.r-pkg.org/badges/grand-total/heplots)](https://cran.r-project.org/package=heplots)
[![Rdoc](http://www.rdocumentation.org/badges/version/heplots)](http://www.rdocumentation.org/packages/heplots)

# heplots
Visualizing Hypothesis Tests in Multivariate Linear Models

Version 1.3-4

The `heplots` package provides functions for visualizing hypothesis tests in
multivariate linear models (MANOVA, multivariate multiple regression, MANCOVA,
and repeated measures designs).

HE plots represent sums-of-squares-and-products matrices for linear hypotheses and for 
error using ellipses (in two dimensions), ellipsoids (in three dimensions),
or by line segments in one dimension.
See Fox, Friendly and Monette (2009) for a brief introduction
and Friendly, Monette and Fox (2013) for a general discussion of the role of
elliptical geometry in statistical understanding.

Other topics now addressed here include:

* robust MLMs, 
* tests for equality of covariance matrices in MLMs (Box's M test), 
* chi sqare Q-Q plots for MLMs.

The package also provides a collection of  data sets illustrating
a variety of multivariate linear models of the types listed above,
together with graphical displays.

Several tutorial vignettes are also included.  See `vignette(package="heplots")`.


## Installation

Get the released version from CRAN:

     install.packages("heplots")

The development version can be installed to your R library directly from this repo via:

     if (!require(devtools)) install.packages("devtools")
     library(devtools)
     install_github("friendly/heplots", build_vignettes = TRUE)

This installs the package from the source and creates the package vignettes, 
so you will need to have R Tools installed on your system.  [R Tools for Windows](https://cran.r-project.org/bin/windows/Rtools/)
takes you to the download page for Windows.  [R Tools for Mac OS X](https://cran.r-project.org/bin/macosx/tools/)
has the required programs for Mac OS X.

## HE plot functions

The graphical functions contained here all display multivariate model
effects in variable (data) space, for one or more response variables
(or contrasts among response variables in repeated measures designs).
The related `candisc` package plots these in canonical discriminant space.

* `heplot` constructs two-dimensional HE plots for model terms and 
linear hypotheses for pairs of response variables in multivariate linear models.

* `heplot3d` constructs analogous 3D plots for triples of response
variables.
 
* `pairs.mlm` constructs a scatterplot matrix of pairwise HE plots.

* `heplot1d` constructs 1-dimensional analogs of HE plots for model terms and 
linear hypotheses for single response variables.

For repeated measure designs, between-subject effects and within-subject
effects must be plotted separately, because the error terms (E matrices)
differ.  For terms involving within-subject effects,
these functions carry out a linear
transformation of the matrix $Y$ of responses to a matrix $Y M$, where
$M$ is the model matrix for a term in
the intra-subject design and produce plots of
the H and E matrices in this transformed space. The vignette `"repeated"` describes
these graphical methods for repeated measures designs.

## References

Fox, J.; Friendly, M. & Monette, G. (2009).
Visualizing hypothesis tests in multivariate linear models: The heplots package for R 
*Computational Statistics*,  **24**, 233-246. [paper PDF](http://datavis.ca/palers/FoxFriendlyMonette-2009.pdf)

Friendly, M.; Monette, G. & Fox, J. (2013).
Elliptical Insights: Understanding Statistical Methods Through Elliptical Geometry 
*Statistical Science*,  **28**, 1-39. [paper](http://datavis.ca/palers/ellipses-STS402.pdf)

