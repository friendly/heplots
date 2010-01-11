\name{mark.H0}
\Rdversion{1.1}
\alias{mark.H0}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Mark a point null hypothesis in an HE plot
}
\description{
A utility function to draw and label a point in a 2D (or 3D) HE plot
corresponding to a point null hypothesis being tested.
This is most useful for repeated measure designs where null
hypotheses for within-S effects often correspond to (0,0).
}
\usage{
mark.H0(x = 0, y = 0, z=NULL, label, cex = 2, pch = 19, col = "green3", lty = 2, pos = 2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{Horizontal coordinate for H0}
  \item{y}{Vertical coordinate for H0}
  \item{z}{z coordinate for H0.  If not NULL, the function assumes that
  a \code{heplot3d} plot has been drawn.}
  \item{label}{Text used to label the point. Defaults to \code{expression(H[0])} in 2D plots.}
  \item{cex}{Point and text size.  For 3D plots, the function uses
  \code{size=5*cex} in a call to \code{\link[rgl]{points3d}}.}
  \item{pch}{Plot character.  Ignored for 3D plots.}
  \item{col}{Color for text, character and lines}
  \item{lty}{Line type for vertical and horizontal reference lines. Not
  	drawn if \code{lty}=0.}
  \item{pos}{Position of text.  Ignored for 3D plots}
}
%\details{
%%%  ~~ If necessary, more details than the description above ~~
%}
\value{
None. Used for side effect of drawing on the current plot.
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
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{cross3d}}, ~~~
}
\examples{
Vocab.mod <- lm(cbind(grade8,grade9,grade10,grade11) ~ 1, data=VocabGrowth)
idata <-data.frame(grade=ordered(8:11))

heplot(Vocab.mod, type="III", idata=idata, idesign=~grade, iterm="grade",
	main="HE plot for Grade effect")
mark.H0()
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ aplot }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
