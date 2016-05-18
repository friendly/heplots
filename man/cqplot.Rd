\name{cqplot}
\alias{cqplot}
\alias{cqplot.default}
\alias{cqplot.mlm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Chi Square Quantile-Quantile plots
}
\description{
A chi square quantile-quantile plots show the relationship between data-based 
values which should be distributed as \eqn{\chi^2} and corresponding quantiles
from the \eqn{\chi^2} distribution.  In multivariate analyses, this is often
to assess multivariate normality and check for outliers, using the
Mahalanobis squared distances (\eqn{D^2}) of observations from the centroid.

\code{cqplot} is a more general version of similar functions 
in other packages that produce chi square QQ plots.
It allows for classical Mahalanobis squared distances
as well as robust estimates based on the MVE and MCD;
it provides an approximate confidence (concentration) envelope around the 
line of unit slope, a detrended version, where the reference line
is horizontal, the ability to identify or label unusual points,
and other graphical features.

The method for \code{"mlm"} objects applies this to the residuals from
the model.
}
\usage{

cqplot(x, ...)

\method{cqplot}{mlm}(x, ...)

\method{cqplot}{default}(x, method = c("classical", "mcd", "mve"), 
	detrend = FALSE, pch = 19, col = palette()[1], 
	ref.col = "red", ref.lwd = 2, 
	conf = 0.95, env.col = "gray", env.lwd = 2, env.lty = 1, 
	env.fill = TRUE, fill.alpha = 0.2, 
	fill.color = trans.colors(ref.col, fill.alpha), 
	labels = if (!is.null(rownames(x))) rownames(x) else 1:nrow(x), 
	id.n, id.method = "y", id.cex = 1, id.col = palette()[1], 
	xlab, ylab, main, what=deparse(substitute(x)), ylim, ...)

}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{x}{
  either a numeric data frame or matrix for the default method, or
  an object of class \code{"mlm"} representing a multivariate linear model.
  In the latter case, residuals from the model are plotted.
}
  \item{\dots}{
Other arguments passed to methods
}

  \item{method}{
estimation method used for center and covariance, one of:
\code{"classical"} (product-moment), 
\code{"mcd"} (minimum covariance determinant), or           
\code{"mve"} (minimum volume ellipsoid).

}
  \item{detrend}{
logical; if \code{FALSE}, the plot shows values of \eqn{D^2} vs. \eqn{\chi^2}.
if \code{TRUE}, the ordinate shows values of \eqn{D^2 - \chi^2}
}
  \item{pch}{
plot symbol for points
}
  \item{col}{
color for points; the default is the \emph{first} entry in the current color palette 
(see \code{\link[grDevices]{palette}} and \code{\link[graphics]{par}}.
}
  \item{ref.col}{
Color for the reference line
}
  \item{ref.lwd}{
Line width for the reference line
}
  \item{conf}{
confidence coverage for the approximate confidence envelope
}
  \item{env.col}{
line color for the boundary of the confidence envelope
}
  \item{env.lwd}{
line width for the confidence envelope
}
  \item{env.lty}{
line type for the confidence envelope
}
  \item{env.fill}{
logical; should the confidence envelope be filled?
}
  \item{fill.alpha}{
transparency value for \code{fill.color}
}
  \item{fill.color}{
color used to fill the confidence envelope
}
  \item{labels}{
vector of text strings to be used to identify points, 
defaults to \code{rownames(x)} or observation numbers if \code{rownames(x)} is \code{NULL}
}
  \item{id.n}{
number of points labeled. If \code{id.n=0}, the default, no point identification occurs.
}
  \item{id.method}{
 	point identification method. The default \code{id.method="y"} will identify the \code{id.n} points 
 	with the largest value of abs(y-mean(y)). See \code{\link[car]{showLabels}} for other options.
}
  \item{id.cex}{
size of text for point labels
}
  \item{id.col}{
color for point labels
}
  \item{xlab}{
label for horizontal (theoretical quantiles) axis
}
  \item{ylab}{
label for vertical (empirical quantiles) axis
}
  \item{main}{
plot title
}
  \item{what}{
the name of the object plotted; used in the construction of \code{main}
when that is not specified.
}
  \item{ylim}{
limits for vertical axis.  If not specified, the range of the 
confidence envelope is used.
}

}
\details{
The calculation of the confidence envelope follows that used
in the SAS program, \url{http://www.datavis.ca/sasmac/cqplot.html}
which comes from Chambers etal. (1983), Section 6.8.

The essential formula is
\deqn{
SE ( z_{(i)} ) = \frac{\hat{\delta}}{g ( q_i )) \times
              \sqrt{ frac{ p_i (1-p_i} }{n}}
}
where \eqn{z_{(i)}} is the i-th order value of \eqn{D^2},
\eqn{\hat{\delta}} is an estimate of the slope of the reference
line obtained from the corresponding quartiles
and \eqn{g(q_i)} is the density of the chi square distribution
at the quantile \eqn{q_i}.

Note that this confidence envelope applies only to the \eqn{D^2}
computed using the classical estimates of location and scatter.
}
\value{
Returns invisibly the
vector of squared Mahalanobis distances corresponding to the rows of \code{x}
or the residuals of the model.
}
\references{
 J. Chambers, W. S. Cleveland, B. Kleiner, P. A. Tukey (1983).
 \emph{Graphical methods for data analysis}, Wadsworth. 
}
\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{Mahalanobis}} for calculation of Mahalanobis squared distance

\code{\link[stats]{qqplot}}, 
\code{\link[car]{qqPlot}} can give a similar result for Mahalanobis squared distances
of data or residuals.
}
\examples{

cqplot(iris[, 1:4])

iris.mod <- lm(as.matrix(iris[,1:4]) ~ Species, data=iris)
cqplot(iris.mod, id.n=3)

# compare with car::qqPlot
car::qqPlot(Mahalanobis(iris[, 1:4]), dist="chisq", df=4, id.n=3)


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{hplot}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
