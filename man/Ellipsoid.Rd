\name{Ellipsoid}
\alias{Ellipsoid}
\alias{Ellipsoid.default}
\alias{Ellipsoid.data.frame}
%\alias{Ellipsoid.matrix}
%- Also NEED an '\alias' for EACH other topic documented here.

\title{Draw an Ellipsoid in an rgl Scene}
\description{Draws an ellipsoid in an \code{rgl} scene}

\usage{
Ellipsoid(x, ...)

\method{Ellipsoid}{data.frame}(
  x,
  which = 1:3,
  method = c("classical", "mve", "mcd"),
    ...)
  
\method{Ellipsoid}{default}(
  x,
  center = c(0,0,0), 
  which = 1:3,
  radius = 1, 
  df = Inf, 
  label = "", 
  cex.label = 1.5, 
  col = "pink", 
  lwd = 1, 
  segments = 40, 
  shade = TRUE, 
  alpha = 0.1, 
  wire = TRUE, 
  verbose = FALSE, 
  warn.rank = FALSE,
  ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{An object. In the default method the parameter x should be a square positive definite matrix at               least 3x3 in size. It will be treated as the correlation or covariance of a multivariate normal
           distribution. For the \code{data.frame} method, it should be a numeric data frame with at
           least 3 columns.
  }
  \item{center}{center of the ellipsoid, a vector of length 3, typically the mean vector of data}
  \item{which}{This parameter selects which variables from the object will be plotted. The default is the first 3.}
  \item{method}{For the \code{data.frame} method, a character string to specify the covariance method to 
           be used: \emph{classical} product-moment (\code{"classical"}),  or \emph{minimum volume ellipsoid} 
           (\code{"mve"}), or \emph{minimum covariance determinant} (\code{"mcd"}).}

  \item{radius}{size of the ellipsoid}
  \item{df}{degrees of freedom associated with the covariance matrix, used to calculate the appropriate F statistic}
  \item{label}{label for the ellipsoid}
  \item{cex.label}{text size of the label}
  \item{col}{color of the ellipsoid}
  \item{lwd}{line with for the wire-frame version}
  \item{segments}{number of segments composing each ellipsoid; defaults to \code{40}.}
  \item{shade}{logical; should the ellipsoid be smoothly shaded?}
  \item{alpha}{transparency of the shaded ellipsoid}
  \item{wire}{logical; should the ellipsoid be drawn as a wire frame?}
  \item{verbose}{logical; for debugging}
  \item{warn.rank}{logical; warn if the ellipsoid is less than rank 3?}
  \item{...}{Additional parameters}
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
returns the bounding box of the ellipsoid invisibly; otherwise used for it's side effect of
        drawing the ellipsoid
}

%\references{
%
%}

\author{Michael Friendly}
%\note{}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[rgl]{ellipse3d}}
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{ hplot }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
