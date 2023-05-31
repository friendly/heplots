\name{bbox3d}
\alias{bbox3d}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Find the bounding box of a \code{rgl::mesh3d} or \code{rgl::qmesh3d} object}

\description{Ellipsoids are created by \pkg{rgl} functions as meshes of points, segments, ... from coordinates
in various forms. This function calculates the bounding box, defined as the range of the
x, y, and z coordinates.}

\usage{
bbox3d(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A mesh3d object}
  \item{\dots}{ignored}
}

%\details{}

\value{A 2 x 3 matrix, giving the minimum and maximum values in the rows and x, y, z coordinates
            in the columns.}

%\references{%% ~put references to the literature/web site here ~}

\author{Michael Friendly, Duncan Murdoch}

%\note{}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[rgl]{mesh3d}}, \code{\link[rgl]{qmesh3d}}
}

\examples{
### None yet
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{dplot}
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
