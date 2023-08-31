\name{cross3d}
\alias{cross3d}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Draw a 3D cross in an rgl scene}
\description{
  Draws a 3D cross or axis vectors in an rgl scene.
}
\usage{
cross3d(centre = rep(0, 3), scale = rep(1, 3), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{centre}{A scalar or vector of length 3, giving the centre of the 3D cross}
  \item{scale}{ A scalar or vector of length 3, giving the lengths of the arms of the 3D cross}
  \item{\dots}{Other arguments, passed on to \code{\link[rgl]{segments3d}}}
}
%\details{
%  ~~ If necessary, more details than the description above ~~
%}
\value{
Used for its side-effect, but returns (invisibly) a 6 by 3 matrix
containing the end-points of three axes, in pairs.
}
%\references{ ~put references to the literature/web site here ~ }
\author{Michael Friendly}
%\note{ ~~further notes~~ 
%
% ~Make other sections like Warning with \section{Warning }{....} ~
%}
\seealso{ \code{\link[rgl:points3d]{segments3d}}}
%\examples{
%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{aplot}
\keyword{dynamic}% __ONLY ONE__ keyword per line
