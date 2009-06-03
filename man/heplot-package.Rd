\name{heplots-package}
\alias{heplots-package}
\alias{heplots}
\docType{package}

\title{
Visualizing Tests in Multivariate Linear Models
}

\description{
The \code{heplots} package provides functions for visualizing hypothesis tests
in multivariate linear models. They
represent sums-of-squares-and-products matrices for linear hypotheses and for 
error using ellipses (in two dimensions) and ellipsoids (in three dimensions).
See Fox, Friendly and Monette (2007) for a brief introduction.
}

\details{
\tabular{ll}{
Package: \tab heplots\cr
Type: \tab Package\cr
Version: \tab 0.8-8\cr
Date: \tab 2009-06-3\cr
License: \tab GPL version 2 or newer\cr
}

The graphical functions contained here all display multivariate model
effects in variable space:

%\describe(
\code{\link{heplot}} constructs two-dimensional HE plots for model terms and 
linear hypotheses for pairs of response variables in multivariate linear models.

\code{\link{heplot3d}} constructs analogous 3D plots for triples of response
variables.
 
\code{\link{pairs.mlm}} constructs a ``matrix'' of pairwise HE plots.
%}


The related \code{\link[car]{car-package}} package calculates tests of multivariate
linear hypotheses. 
The \code{\link[candisc]{candisc-package}} package provides functions for 
visualizing effects for model terms in a low-dimensional canonical space
that shows the largest hypothesis relative to error variation.
}

\author{
John Fox, Michael Friendly, and Georges Monette

Maintainer: Michael Friendly <friendly@yorku.ca>
}

\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples 
  \emph{Journal of Statistical Software}, 17(6), 1-42.
  \url{http://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
  \url{http://www.math.yorku.ca/SCS/Papers/jcgs-heplots.pdf} 

Fox, J., Friendly, M. & Monette, G. (2007).
  Visual hypothesis tests in multivariate linear models: The heplots package for R. 
  \emph{DSC 2007: Directions in Statistical Computing}.
  \url{http://socserv.socsci.mcmaster.ca/jfox/heplots-dsc-paper.pdf}

}

\keyword{package}
\keyword{hplot}
\keyword{aplot}
\keyword{multivariate}

\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linear.hypothesis}}
}


