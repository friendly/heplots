\name{label.ellipse}
\alias{label.ellipse}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Draw a Label on an Ellipse-like Object
}
\description{
Draws a label on an ellipse (or similar closed ploygon object) 
allowing a \code{label.pos} argument to specify the position of
the label as center, bottom, left, top, or right relative to the
object.
}
\usage{
label.ellipse(ellipse, label, col = "black", label.pos = NULL, 
      xpd = TRUE, tweak = 0.5 * c(strwidth("M"), strheight("M")), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ellipse}{
A two-column matrix, or an object that can be coerced to one.
}
  \item{label}{
Label text, a character string, or expression (or coercible to such a type).
}
  \item{col}{
Label color
}
  \item{label.pos}{
Label position, an integer (in \code{0:4}) or character string
(in \code{c("center", "bottom", "left", "top", "right")}).
Values of 1, 2, 3 and 4, respectively indicate positions below, to the left of, above 
and to the right of the max/min coordinates of the ellipse; the value 0 specifies
the centroid of the \code{ellipse} object.
The default, \code{label.pos=NULL}
uses the correlation of the \code{ellipse} to determine "top" (r>=0) or "bottom" (r<0).
}
  \item{xpd}{
logical.  Whether to allow the label to go beyond the plot area.
}
  \item{tweak}{
A two element vector specifying minor adjustments applied to the
x or y coordinate of the label, depending on \code{label.pos}.
The defaults are one-half the width and height of an uppercase "M"
on the current graphics device.

Alternatively, you can set \code{tweak=c(0,0)} and use
\code{offset} to achieve more general adjustments.
}
  \item{\dots}{
Other arguments passed to \code{\link[graphics]{text}},
such as \code{offset}, \code{srt}, \code{font}, \code{family}, etc.
}
}
\details{
Like \code{\link[graphics]{text}}, this function simply adds to an
existing base graphics plot.
}
\value{
None.
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
\code{\link[graphics]{text}}, \code{\link[graphics]{par}}
 for other graphics parameters
}
\examples{
op <- par(mfrow=c(1,2))
plot(c(-2,2), c(-3,3), type="n", xlab="x", ylab="y")
E <- ellipse(c(0,0), matrix(c(1,2,2,5), 2, 2), 1, add=TRUE)

label.ellipse(E, "default", col="red", cex=2)
label.ellipse(E, "center", label.pos=0)
label.ellipse(E, "bottom", label.pos=1)
label.ellipse(E, "top", label.pos=3)
label.ellipse(E, "left", label.pos=2)
label.ellipse(E, "right", label.pos=4)

plot(c(-2,2), c(-3,3), type="n", xlab="x", ylab="y")
E <- ellipse(c(0,0), matrix(c(1,-2,-2,5), 2, 2), 1, add=TRUE)

label.ellipse(E, "default", col="red", cex=2)
label.ellipse(E, "center", label.pos="center")
label.ellipse(E, "bottom", label.pos=1, cex=1.5)
label.ellipse(E, "top", label.pos=3, cex=1.5)
label.ellipse(E, "left", label.pos=2, cex=1.5)
label.ellipse(E, "right", label.pos=4, cex=1.5)
par(op)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
