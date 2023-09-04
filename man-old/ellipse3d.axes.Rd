\name{ellipse3d.axes}
\alias{ellipse3d.axes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Draw axes of a 3D ellipsoid}
\description{
A function to draw the major axes of a 3D ellipsoid from a correlation,
covariance or sums of squares and cross products matrix.
}
\usage{
ellipse3d.axes(x, centre = c(0, 0, 0), scale = c(1, 1, 1), 
    level = 0.95, t = sqrt(qchisq(level, 3)), which = 1:3, 
    labels = TRUE, label.ends=c(2,4,6), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A square positive definite matrix at least 3x3 in size. 
  	It will be treated as the correlation or covariance of a multivariate normal 
  	distribution. }
  \item{centre}{The center of the ellipse}
  \item{scale}{If x is a correlation matrix, then the standard deviations of each parameter can be given in the scale parameter. 
  	This defaults to \code{c(1, 1, 1)}, so no rescaling will be done. }
  \item{level}{The confidence level of a simultaneous confidence region. 
  	The default is 0.95, for a 95\% region. 
  	This is used to control the size of the ellipsoid.}
  \item{t}{The size of the ellipsoid may also be controlled by specifying the value of a 
  	t-statistic on its boundary.}
  \item{which}{This parameter selects which variables from the object will be plotted. 
  	The default is the first 3. }
  \item{labels}{Either a logical value, a character string, or a character vector of length 3.
  	If \code{TRUE}, the default, the axes are labeled PC1, PC2, PC3.
  	If a single character string, the digits 1, 2, 3 are pasted on the end.}
  \item{label.ends}{A vector of length 3 indicating which ends of the axes should
  	be labeled, corresponding to a selection of rows of the 6 x 3 matrix of axes
  	end points.  Default: \code{c(2,4,6)}.}
  \item{\dots}{Other arguments passed to \code{segments3d} and \code{text3d}.}
}
%\details{
%  ~~ If necessary, more details than the description above ~~
%}
\value{
Returns a 6 x 3 matrix containing the end points of the three axis lines in pairs
by rows.
}
%\references{ ~put references to the literature/web site here ~ }
\author{Michael Friendly}
%\note{ ~~further notes~~ 
%}
\seealso{\code{\link[rgl:points3d]{segments3d}}, \code{\link[rgl:texts]{text3d}}, \code{\link[rgl]{ellipse3d}}}

\examples{
data(iris)
iris3 <- iris[,1:3]
cov <- cov(iris3)
mu <- colMeans(iris3)
col <-c("blue", "green", "red")[iris$Species]

library(rgl)
plot3d(iris3, type="s", size=0.4, col=col, cex=2, box=FALSE, aspect="iso")
plot3d( ellipse3d(cov, centre=mu, level=0.68), col="gray", alpha=0.2,  add = TRUE)

axes <- ellipse3d.axes(cov, centre=mu, level=0.68, color="gray", lwd=2)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{aplot}
\keyword{dynamic}% __ONLY ONE__ keyword per line
