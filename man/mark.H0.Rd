\name{mark.H0}
\Rdversion{1.1}
\alias{mark.H0}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Mark a point null hypothesis in an HE plot
}
\description{
A utility function to draw and label a point in a 2D HE plot
corresponding to a point null hypothesis being tested.
}
\usage{
mark.H0(x = 0, y = 0, cex = 2, pch = 19, col = "green3", lty = 2, pos = 2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{Horizontal coordinate for H0}
  \item{y}{Vertical coordinate for H0}
  \item{cex}{Text size}
  \item{pch}{Plot character}
  \item{col}{Color for text, character and lines}
  \item{lty}{Line type for vertical and horizontal reference lines. Not
  	drawn if \code{lty}=0.}
  \item{pos}{Position of text}
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

%\seealso{
%%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
%\examples{
%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ aplot }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
