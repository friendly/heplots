\name{heplots-internal}
\alias{lambda.crit}
\alias{he.rep}

\title{Internal heplots functions}

\description{
Internal functions for package heplots.
}

\usage{
lambda.crit(alpha, p, dfh, dfe, test.statistic=c("Roy", "HLT", "Hotelling-Lawley"))
Roy.crit(alpha, p, dfh, dfe)
HLT.crit(alpha, p, dfh, dfe)
he.rep(x, n)
termInfo(x)
}

\arguments{
  \item{alpha}{}
  \item{p}{Number of variables}
  \item{dfh}{degrees of freedom for hypothesis}
  \item{dfe}{degrees of freedom for error}
  \item{test.statistic}{Test statistic used for the multivariate test}
  \item{x}{An argument to \code{\link{heplot}} or  \code{\link{heplot3d}}
  that is to be repeated for Error and all hypothesis terms}
  \item{n}{Number of hypothesis terms}
}

\details{
These functions are not intended to be called by the user.
}

\author{Michael Friendly \email{friendly@yorku.ca}}

\keyword{internal}
