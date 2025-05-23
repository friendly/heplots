% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bartlettTests.R
\name{bartlettTests}
\alias{bartlettTests}
\alias{bartlettTests.default}
\alias{bartlettTests.formula}
\alias{bartlettTests.lm}
\title{Bartlett Tests of Homogeneity of Variances}
\usage{
bartlettTests(y, ...)

\method{bartlettTests}{default}(y, group, ...)

\method{bartlettTests}{formula}(y, data, ...)

\method{bartlettTests}{lm}(y, ...)
}
\arguments{
\item{y}{A data frame or matrix of numeric response variables for the default method,
or a model formula for a multivariate linear model, or the multivariate linear model itself.
In the case of a formula or model, the  variables on the right-hand-side of the model must all 
be factors and must be completely crossed.}

\item{\dots}{other arguments, passed to \code{\link[stats]{bartlett.test}}}

\item{group}{a vector or factor object giving the group for the
corresponding elements of the rows of \code{y} for the default method}

\item{data}{the data set, for the \code{formula} method}
}
\value{
An object of classes "anova" and "data.frame", with one observation
for each response variable in \code{y}.
}
\description{
This function extends \code{\link[stats]{bartlett.test}} to a multivariate
response setting.  It performs the Bartlett test of homogeneity of variances
for each of a set of response variables, and prints a compact summary.

Bartlett's test is the univariate version of Box's M test for equality of
covariance matrices.  This function provides a univariate follow-up test to
Box's M test to give one simple assessment of which response variables
contribute to significant differences in variances among groups.
}
\examples{

bartlettTests(iris[,1:4], iris$Species)

data(Skulls, package="heplots")
bartlettTests(Skulls[,-1], Skulls$epoch)

# formula method
bartlettTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)

}
\references{
Bartlett, M. S. (1937). Properties of sufficiency and
statistical tests.  \emph{Proceedings of the Royal Society of London Series
A}, \bold{160}, 268-282.
}
\seealso{
\code{\link{boxM}} for Box's M test for all responses together.
}
\author{
Michael Friendly
}
\keyword{htest}
