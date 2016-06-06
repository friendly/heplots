\name{plot.robmlm}
\alias{plot.robmlm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plot observation weights from a robust multivariate linear models
}
\description{
Creates an index plot of the observation weights assigned in the 
last iteration of \code{\link{robmlm}}.
}
\usage{
\method{plot}{robmlm}(x, labels, 
     id.weight = 0.7, id.pos = 4, 
     pch = 19, 
     col = palette()[1], cex = par("cex"), 
     segments = FALSE,
     xlab = "Case index", ylab = "Weight in robust MANOVA", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
A \code{"robmlm"} object
}
  \item{labels}{
Observation labels; if not specified,uses rownames from the original data
}
  \item{id.weight}{
Threshold for identifying obsrevations with small weights
}
  \item{id.pos}{
Position of observation label relative to the point
}
  \item{pch}{
Point symbol(s)
}
  \item{col}{
Point color(s)
}
  \item{cex}{
Point character size(s)
}
  \item{segments}{
logical; if \code{TRUE}, draw line segments from 1.o down to the point
}
  \item{xlab}{
x axis label
}
  \item{ylab}{
y axis label
}
  \item{\dots}{
other arguments passed to \code{\link[graphics]{plot}}
}
}
%\details{
%%%  ~~ If necessary, more details than the description above ~~
%}
\value{
Returns invisibly the weights for the observations labeled in the plot
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
%\references{
%%% ~put references to the literature/web site here ~
%}
\author{
Michael Friendly
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{robmlm}}
}
\examples{
data(Skulls)
sk.rmod <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
plot(sk.rmod, col=Skulls$epoch)
axis(side=3, at=15+seq(0,120,30), labels=levels(Skulls$epoch), cex.axis=1)

# Pottery data

pottery.rmod <- robmlm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
plot(pottery.rmod, col=Pottery$Site, segments=TRUE)


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ hplot }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
