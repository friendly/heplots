\name{Mahalanobis}
\alias{Mahalanobis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Classical and Robust Mahalanobis Distances
}
\description{
This function is a convenience wrapper to \code{\link[stats]{mahalanobis}} offering
also the possibility to calculate robust Mahalanobis squared distances using
MCD and MVE estimators of center and covariance (from \code{\link[MASS]{cov.rob}})
}
\usage{
Mahalanobis(x, center, cov, method = c("classical", "mcd", "mve"), nsamp = "best", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
a numeric matrix or data frame with, say, \eqn{p} columns
}
  \item{center}{
mean vector of the data; if this and \code{cov} are \emph{both} supplied,
the function simply calls \code{\link[stats]{mahalanobis}} to 
calculate the result, ignoring the \code{method} argument.
}
  \item{cov}{
covariance matrix (\eqn{p x p}) of the data
}
  \item{method}{
estimation method used for center and covariance, one of:
\code{"classical"} (product-moment), 
\code{"mcd"} (minimum covariance determinant), or           
\code{"mve"} (minimum volume ellipsoid).
}
  \item{nsamp}{
passed to \code{\link[MASS]{cov.rob}, just to make this argument explicit}
}
  \item{\dots}{
other arguments passed to \code{\link[MASS]{cov.rob}}
}
}

\details{
Any missing data in a row of \code{x} causes \code{NA} to be returned for that row. 
}

\value{
A numeric vector of squared Mahalanobis distances corresponding to the rows of \code{x}.
}

%\references{
%%% ~put references to the literature/web site here ~
%}

\author{
Michael Friendly
}

%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[stats]{mahalanobis}}, \code{\link[MASS]{cov.rob}}
}
\examples{
summary(Mahalanobis(iris[, 1:4]))
summary(Mahalanobis(iris[, 1:4], method="mve"))
summary(Mahalanobis(iris[, 1:4], method="mcd"))

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{multivariate}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
