\name{arrow3d}
\Rdversion{1.1}
\alias{arrow3d}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Draw a 3D Arrow in an RGL Scene
}
\description{
Draws a 3D arrow in an rgl scene with barbs at the arrow head
}
\usage{
arrow3d(p0 = c(0, 0, 0), p1 = c(1, 1, 1), barblen, s = 0.05, theta = pi/6, n = 3, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{p0}{
Initial point (tail of arrow)
}
  \item{p1}{
Ending point (head of arrow)
}
  \item{barblen}{
Length of each barb, in data units
}
  \item{s}{
length of barb as fraction of line length (unless barblen is specified)
}
  \item{theta}{
opening angle of barbs
}
  \item{n}{
number of barbs
}
  \item{\dots}{
args passed to lines3d for line styling, e.g., \code{color}, \code{lwd}, etc.
See \code{\link[rgl]{material3d}}.
}
}
%\details{
%}
\value{
Returns (invisibly): integer ID of the line added to the scene
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Barry Rowlinson, posted to R-help, 1/10/2010
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[rgl]{lines3d}}, \code{\link[rgl]{segments3d}},
}
\examples{
arrow3d(c(0,0,0), c(2,2,2), barblen=.2, lwd=3, col="black")
arrow3d(c(0,0,0), c(-2,2,2), barblen=.2, lwd=3, col="red")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{aplot}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
