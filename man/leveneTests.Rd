\name{leveneTests}
\alias{leveneTests}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Levene Tests of Homogeneity of Variances
}
\description{
This function extends \code{\link[car]{leveneTest}} to a multivariate
response setting.  It performs the Levene test of homogeneity of
variances for each of a set of response variables, and prints a
compact summary.
}
\usage{
leveneTests(y, group, center = median, ...)
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
  \item{center}{
The name of a function to compute the center of each group; \code{mean} gives the original Levene's (1960) test; 
the default, \code{median}, provides a more robust test suggested by Brown and Forsythe (1974).
}
  \item{\dots}{
other arguments, passed to \code{\link[car]{leveneTest}}
}
}

%\details{
%%%  ~~ If necessary, more details than the description above ~~
%}
\value{
An object of classes "anova" and "data.frame", with one observation for each
response variable in \code{y}.  
}
\references{
Levene, H. (1960).
Robust Tests for Equality of Variances.
In Olkin, I. \emph{etal.} (Eds.), 
\emph{Contributions to Probability and Statistics: Essays in Honor of Harold Hotelling}, 
Stanford University Press, 278-292.

Brown, M. B. & Forsythe, A. B. (1974).
Robust Tests For Equality Of Variances 
\emph{Journal of the American Statistical Association}, \bold{69}, 364-367.

}
\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[car]{leveneTest}},
\code{\link{bartlettTests}}
}
\examples{
leveneTests(iris[,1:4], iris$Species)

# handle a 1-column response?
leveneTests(iris[,1, drop=FALSE], iris$Species)

data(Skulls, package="heplots")
leveneTests(Skulls[,-1], Skulls$epoch)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{htest}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
