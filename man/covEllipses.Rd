\name{covEllipses}
\alias{covEllipses}
\alias{covEllipses.boxM}
\alias{covEllipses.data.frame}
\alias{covEllipses.matrix}
\alias{covEllipses.default}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Draw covariance ellipses for two or more groups
}
\description{
The function draws covariance ellipses for two or more groups
and optionally for the pooled total sample.  It 
uses either the classical product-moment covariance estimate, or a
robust alternative, as provided by \code{\link[MASS]{cov.rob}}.
}
\usage{

covEllipses(x, ...)

\method{covEllipses}{boxM}(x, ...)

\method{covEllipses}{data.frame}(x, group, pooled = TRUE, method = c("classical", "mve", "mcd"), ...)

\method{covEllipses}{matrix}(x, group, pooled = TRUE, method = c("classical", "mve", "mcd"), ...)

\method{covEllipses}{default}(x, means, df, 
        labels = NULL, variables = 1:2, level = 0.68, 
        segments = 40, 
        center = FALSE, center.pch = "+", center.cex = 2, 
        col = getOption("heplot.colors", c("red", "blue", "black", "darkgreen", 
                        "darkcyan", "magenta", "brown", "darkgray")), 
        lty = 1, lwd = 2, 
        fill = FALSE, fill.alpha = 0.3, 
        label.pos = 0, 
        xlab, ylab, main = "", 
        xlim, ylim, axes = TRUE, 
        offset.axes, add = FALSE, warn.rank = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{x}{
The generic argument. For the default method, this is a list of covariance matrices.
}

  \item{group}{
a factor defining groups, or a vector of length n doing the same
}
  \item{pooled}{
Logical; if \code{TRUE}, the pooled covariance matrix is also computed and plotted
}
  \item{method}{
the covariance method to be used: classical product-moment (\code{"classical"}), 
or minimum volume ellipsoid (\code{"mve"}), or 
minimum covariance determinant (\code{"mcd"}).
}

%  \item{cov}{
%%%     ~~Describe \code{cov} here~~
%}
  \item{means}{
For the default method, a matrix of the means for all groups (followed by the grand means, if \code{pooled=TRUE}).
Rows are the groups, and columns are the variables.
}
  \item{df}{
For the default method, a vector of the degrees of freedom for the covariance matrices
}
  \item{labels}{
Either a character vector of labels for the groups, or \code{TRUE},
indicating that group labels are taken as the names of the covariance matrices.
Use \code{labels=""} to suppress group labels
}
  \item{variables}{indices or names of the two response variables to be plotted;
    defaults to \code{1:2}.}

  \item{level}{equivalent coverage of ellipse for normally-distributed
    errors, defaults to \code{0.68}.}

  \item{segments}{number of line segments composing each ellipse; defaults to
    \code{40}.}

  \item{center}{If \code{TRUE}, the covariance ellipses are centered at the centroid.}

  \item{center.pch}{character to use in plotting the centroid of the data;
    defaults to \code{"+"}.}

  \item{center.cex}{size of character to use in plotting the centroid of the data;
    defaults to \code{2}.}

  \item{col}{a color or vector of colors to use in plotting ellipses
   --- recycled as necessary 
    A single color can be given, in which case it is used for all ellipses.
    For convenience, the default colors for all plots produced in a given session can be changed
    by assigning a color vector via \code{options(heplot.colors =c(...)}.  Otherwise,
    the default colors are \code{c("red", "blue", "black", "darkgreen", "darkcyan", "magenta", "brown", "darkgray")}.
    }

  \item{lty}{vector of line types to use for plotting the ellipses; the first is
    used for the error ellipse, the rest --- possibly recycled --- for
    the hypothesis ellipses; a single line type can be given. Defaults to
    \code{2:1}.}

  \item{lwd}{vector of line widths to use for plotting the ellipses; the first is
    used for the error ellipse, the rest --- possibly recycled --- for
    the hypothesis ellipses; a single line width can be given. Defaults to
    \code{1:2}.}

  \item{fill}{A logical vector indicating whether each ellipse should be filled or not.
    The first value is used for the error ellipse, the rest --- possibly recycled --- for
    the hypothesis ellipses; a single fill value can be given.  
    Defaults to FALSE for backward compatibility. See Details below.}
  \item{fill.alpha}{Alpha transparency for filled ellipses, a numeric scalar or vector of values
  within \code{[0,1]}, where 0 means fully transparent and 1 means fully opaque. Defaults to 0.3.}

  \item{label.pos}{
	Label position, a vector of integers (in \code{0:4}) or character strings
	(in \code{c("center", "bottom", "left", "top", "right")}) use in labeling ellipses,
	recycled as necessary.
	Values of 1, 2, 3 and 4, respectively indicate positions below, to the left of, above 
	and to the right of the max/min coordinates of the ellipse; the value 0 specifies
	the centroid of the \code{ellipse} object.
	The default, \code{label.pos=NULL}
	uses the correlation of the \code{ellipse} to determine "top" (r>=0) or "bottom" (r<0).
}

  \item{xlab}{x-axis label; defaults to name of the x variable.}
  \item{ylab}{y-axis label; defaults to name of the y variable.}
  \item{main}{main plot label; defaults to \code{""}.}
  \item{xlim}{x-axis limits; if absent, will be computed from the data.}
  \item{ylim}{y-axis limits; if absent, will be computed from the data.}
  \item{axes}{Whether to draw the x, y axes; defaults to \code{TRUE}}
  \item{offset.axes}{proportion to extend the axes in each direction if computed 
    from the data; optional.}

  \item{add}{if \code{TRUE}, add to the current plot; the default is \code{FALSE}.
    }

  \item{warn.rank}{if \code{TRUE}, do not suppress warnings about the rank of the
    covariance matrices; the default is \code{FALSE}.}

  \item{\dots}{
Other arguments passed to the default method for \code{plot}, \code{text}, 
    and \code{points}
}

}
\details{
This plot method provides one way to visualize possible heterogeneity of
covariance matrices in a one-way MANOVA design.

}
\value{
Returns invisibly an object of class \code{"covEllipse"},
which is a list of the coordinates for the ellipses drawn.
}

%\references{
%% ~put references to the literature/web site here ~
%}

\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{heplot}},
\code{\link{boxM}},

\code{\link[MASS]{cov.rob}}


}
\examples{

data(iris)

covEllipses(iris[,1:4], iris$Species)
covEllipses(iris[,1:4], iris$Species, fill=TRUE, method="mve", add=TRUE, labels="")
	
x <- boxM(iris[, 1:4], iris[, "Species"])
x
covEllipses(x, fill=c(rep(FALSE,3), TRUE) )
covEllipses(x, fill=c(rep(FALSE,3), TRUE), center=TRUE, label.pos=1:4 )

cov <- c(x$cov, pooled=list(x$pooled))
df <- c(table(iris$Species)-1, nrow(iris)-3)
covEllipses(cov, x$means, df, label.pos=3, fill=c(rep(FALSE,3), TRUE))
 
covEllipses(cov, x$means, df, label.pos=3, fill=c(rep(FALSE,3), TRUE), center=TRUE)


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{hplot }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
