\name{heplots-package}
\alias{heplots-package}
\alias{heplots}
\docType{package}

\title{
Visualizing Tests in Multivariate Linear Models
}

\description{
Represents sums-of-squares-and-products matrices for linear hypotheses and for 
error using ellipses (in two dimensions) and ellipsoids (in three dimensions).
}

\details{
\tabular{ll}{
Package: \tab heplots\cr
Type: \tab Package\cr
Version: \tab 0.8-3\cr
Date: \tab 2008-11-6\cr
License: \tab GPL version 2 or newer\cr
}

\code{\link{heplot}} constructs two-dimensional plots for model terms and 
linear hypotheses for 
pairs of response variables in multivariate linear models. 
\code{\link{heplot3d}} constructs analogous 3D plots for triples of response
variables. \code{\link{pairs.mlm}} constructs a ``matrix'' of
pairwise HE plots.
}

\author{
John Fox, Michael Friendly, and Georges Monette

Maintainer: John Fox <jfox@mcmaster.ca>
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
}

\keyword{package}
\keyword{hplot}
\keyword{aplot}
\keyword{multivariate}

\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linear.hypothesis}}
}


