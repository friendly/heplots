\name{heplots-package}
\alias{heplots-package}
\alias{heplots}
\docType{package}

\title{
Visualizing Hypothesis Tests in Multivariate Linear Models
}

\description{
The \code{heplots} package provides functions for visualizing hypothesis tests
in multivariate linear models (MANOVA, multivariate multiple regression, MANCOVA,  and repeated measures designs). 
They represent sums-of-squares-and-products matrices for linear hypotheses and for 
error using ellipses (in two dimensions), ellipsoids (in three dimensions),
or by line segments in one dimension.
See Fox, Friendly and Monette (2007) for a brief introduction.

The package also provides a collection of  data sets illustrating
a variety of multivariate linear models of the types listed above,
together with graphical displays.

Several tutorial vignettes are also included.
}

\details{
\tabular{ll}{
Package: \tab heplots\cr
Type: \tab Package\cr
Version: \tab 0.9-12\cr
Date: \tab 2012-04-03\cr
License: \tab GPL (>= 2), GPL version 2 or newer\cr
}

The graphical functions contained here all display multivariate model
effects in variable (data) space, for one or more response variables
(or contrasts among response variables in repeated measures designs).

\describe{
\item{\code{\link{heplot}}}{constructs two-dimensional HE plots for model terms and 
linear hypotheses for pairs of response variables in multivariate linear models.}

\item{\code{\link{heplot3d}}}{constructs analogous 3D plots for triples of response
variables.}
 
\item{\code{\link{pairs.mlm}}}{constructs a ``matrix'' of pairwise HE plots.}

\item{\code{\link{heplot1d}}}{constructs 1-dimensional analogs of HE plots for model terms and 
linear hypotheses for single response variables.}
}

For repeated measure designs, between-subject effects and within-subject
effects must be plotted separately, because the error terms (E matrices)
differ.  For terms involving within-subject effects,
these functions carry out a linear
transformation of the matrix \bold{Y} of responses to a matrix \bold{Y M}, where
\bold{M} is the model matrix for a term in
the intra-subject design and produce plots of
the H and E matrices in this transformed space. The vignette \code{repeated} describes
these graphical methods for repeated measures designs.


The related \code{\link[car]{car-package}} package calculates Type II and Type III tests 
of multivariate
linear hypotheses using the  \code{\link[car]{Anova}} and \code{\link[car]{linearHypothesis}}
functions. 

The \code{\link[candisc]{candisc-package}} package provides functions for 
visualizing effects for model terms in a low-dimensional canonical space
that shows the largest hypothesis relative to error variation.

The package also contains a large number of multivariate data sets with examples
of analyses and graphic displays.  Use \code{data(package="heplots")} to see
the current list.
}

\author{
John Fox, Michael Friendly, and Georges Monette

Maintainer: Michael Friendly, <friendly@yorku.ca>, \url{http://datavis.ca}
}

\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples. 
  \emph{Journal of Statistical Software}, 17(6), 1-42.
  \url{http://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
  \url{http://datavis.ca/papers/jcgs-heplots.pdf} 

Fox, J., Friendly, M. & Monette, G. (2007).
  Visual hypothesis tests in multivariate linear models: The heplots package for R. 
  \emph{DSC 2007: Directions in Statistical Computing}.
  \url{http://socserv.socsci.mcmaster.ca/jfox/heplots-dsc-paper.pdf}

Friendly, Michael (2010). HE Plots for Repeated Measures Designs. \emph{Journal of Statistical Software},
  37(4), 1-40. URL \url{http://www.jstatsoft.org/v37/i04/}.

}

\keyword{package}
\keyword{hplot}
\keyword{aplot}
\keyword{multivariate}

\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linearHypothesis}} for Anova.mlm computations and tests
    
    \code{\link[candisc]{candisc-package}} for reduced-rank views in canonical space
    
    \code{\link[stats]{manova}} for a different approach to testing effects in MANOVA designs
    
}


