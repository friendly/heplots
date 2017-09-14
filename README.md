[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/heplots)](http://cran.r-project.org/package=heplots)
[![](http://cranlogs.r-pkg.org/badges/grand-total/heplots)](https://cran.r-project.org/package=heplots)
[![Rdoc](http://www.rdocumentation.org/badges/version/heplots)](http://www.rdocumentation.org/packages/heplots)

# heplots
**Visualizing Hypothesis Tests in Multivariate Linear Models**

Version 1.3-4

The `heplots` package provides functions for visualizing hypothesis tests in
multivariate linear models (MANOVA, multivariate multiple regression, MANCOVA,
and repeated measures designs).

HE plots represent sums-of-squares-and-products matrices for linear hypotheses and for 
error using ellipses (in two dimensions), ellipsoids (in three dimensions),
or by line segments in one dimension.
See Fox, Friendly and Monette (2007) for a brief introduction
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

