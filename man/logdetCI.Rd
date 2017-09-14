\name{logdetCI}
\alias{logdetCI}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
 Calculate confidence interval for log determinant of covariance matrices
}
\description{
This function uses asymptotic results described by Cai et. al (2016),
Theorem 1,
to calculate approximate, normal theory confidence intervals (CIs) for
the log determinant of one or more sample covariance matrices.

Their results are translated into a CI via the approximation
\deqn{ \log det( \widehat{\Sigma} ) - bias \pm z_{1 - \alpha/2} \times SE }
where \eqn{ \widehat{\Sigma}} is the sample estimate of a population
covariance matrix, 
\eqn{bias} is a bias correction constant and \eqn{SE} is a width factor for
the confidence interval.  Both \eqn{bias} and \eqn{SE} are functions of 
the sample size, \eqn{n} and number of variables, \eqn{p}.  

This function is included here only to provide an approximation to
\emph{graphical accuracy} for use with Box's M test for equality of covariance
matrices, \code{\link{boxM}} and its associated \code{\link{plot.boxM}} method.
}
\usage{
logdetCI(cov, n, conf = 0.95, method = 1, bias.adj = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{cov}{a covariance matrix or a (named) list of covariance matrices, all the same size}
  \item{n}{sample size, or vector of sample sizes, one for each covariance matrix}
  \item{conf}{confidence level}

  \item{method}{
Three methods are provided, based on Cai et. al Theorem 1 (\code{method=1}), Colollary 1 (\code{method=2}) and 
Colollary 2 (\code{method=3}),
each with different bias and SE values.
}
  \item{bias.adj}{
logical; set \code{FALSE} to exclude the bias correction term.
}
}
\details{

Cai et. al (2015) claim that their Theorem 1 holds with either \eqn{p} fixed or \eqn{p(n)} growing with \eqn{n}, as long as
\eqn{p(n) \le n}. Their Corollary 1 (\code{method=2}) is the special case when \eqn{p} is fixed.
Their Corollary 2 (\code{method=3}) is the special case when \eqn{0 \le p/n < 1} is fixed.

The properties of this CI estimator are unknown in small to moderate
sample sizes, but it seems to be the only one available. 
It is therefore experimental in this version of the package
and is subject to change in the future. 

The \eqn{bias} term offsets the confidence interval from the sample
estimate of \eqn{ \log det( \widehat{\Sigma} ) }.
When \eqn{p} is large relative to \eqn{n}, the confidence interval may not
overlap the sample estimate.

Strictly speaking, this estimator applies to the MLE of the covariance matrix \eqn{ \widehat{\Sigma}}, i.e.,
using \eqn{n} rather than \eqn{n-1} in as the divisor.  The factor \eqn{(n-1 / n)}
has not yet been taken into account here.
}
\value{
A data frame with one row for each covariance matrix.
\code{lower} and \code{upper} are the boundaries of the confidence intervals.
Other columns are \code{logdet, bias, se}.
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}

\references{

Cai, T. T.; Liang, T. & Zhou, H. H. (2015) Law of log determinant of sample covariance matrix and optimal estimation of differential entropy for high-dimensional Gaussian distributions Journal of Multivariate Analysis, 137, 161-172.
\url{https://doi.org/10.1016/j.jmva.2015.02.003}
}
\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{boxM}},
\code{\link{plot.boxM}}
}
\examples{
data(iris)
iris.mod <- lm(as.matrix(iris[,1:4]) ~ iris$Species)
iris.boxm <- boxM(iris.mod)
cov <- c(iris.boxm$cov, list(pooled=iris.boxm$pooled))
n <- c(rep(50, 3), 150)

CI <- logdetCI( cov, n=n, conf=.95, method=1)
CI
plot(iris.boxm, xlim=c(-14, -8), main="Iris data, Box's M test", gplabel="Species")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)

CI <- logdetCI( cov, n=n, conf=.95, method=1, bias.adj=FALSE)
CI
plot(iris.boxm, xlim=c(-14, -8), main="Iris data, Box's M test", gplabel="Species")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
