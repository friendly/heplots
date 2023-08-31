\name{bartlettTests}
\alias{bartlettTests}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bartlett Tests of Homogeneity of Variances
}
\description{
This function extends \code{\link[stats]{bartlett.test}} to a multivariate
response setting.  It performs the Bartlett test of homogeneity of
variances for each of a set of response variables, and prints a
compact summary.
}
\usage{
bartlettTests(y, group, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{
A data frame or matrix of numeric response variables in a 
multivariate linear model.
}
  \item{group}{
a vector or factor object giving the group for the corresponding elements of the rows of \code{y}
}
  \item{\dots}{
other arguments, passed to \code{\link[stats]{bartlett.test}}
}
}
\details{
Bartlett's test is the univariate version of Box's M test for equality of
covariance matrices.  This function provides a univariate follow-up test
to Box's M test to give one simple assessment of which response variables
contribute to significant differences in variances among groups.
}
\value{
An object of classes "anova" and "data.frame", with one observation for each
response variable in \code{y}.  
}
\references{
Bartlett, M. S. (1937). Properties of sufficiency and statistical tests. 
\emph{Proceedings of the Royal Society of London Series A}, \bold{160}, 268-282. 
}
\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{boxM}} for Box's M test for all responses.
}
\examples{
bartlettTests(iris[,1:4], iris$Species)

data(Skulls, package="heplots")
bartlettTests(Skulls[,-1], Skulls$epoch)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{htest}
