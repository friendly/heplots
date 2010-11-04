\name{trans.colors}
\alias{trans.colors}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Make Colors Transparent
}
\description{
Takes a vector of colors (as color names or rgb hex values) and adds a specified
alpha transparency to each.
}
\usage{
trans.colors(col, alpha = 0.5, names = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{col}{
A character vector of colors, either as color names or rgb hex values
}
  \item{alpha}{
alpha transparency value(s) to apply to each color (0 means fully transparent and 1 means opaque)
}
  \item{names}{
optional character vector of names for the colors
}
}
\details{
Colors (\code{col}) and \code{alpha} need not be of the same length.
The shorter one is replicated to make them of the same length.

}
\value{
A vector of color values of the form \code{"#rrggbbaa"}
}
%\references{
%%% ~put references to the literature/web site here ~
%}
\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
\code{\link[grDevices]{col2rgb}},
\code{\link[grDevices]{rgb}},
}
\examples{
trans.colors(palette(), alpha=0.5)

# alpha can be vectorized
trans.colors(palette(), alpha=seq(0, 1, length=length(palette())))

# lengths need not match: shorter one is repeated as necessary
trans.colors(palette(), alpha=c(.1, .2))

trans.colors(colors()[1:20])

# single color, with various alphas
trans.colors("red", alpha=seq(0,1, length=5))
# assign names
trans.colors("red", alpha=seq(0,1, length=5), names=paste("red", 1:5, sep=""))

}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{color}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
