\name{coefplot}
\alias{coefplot}
\alias{coefplot.mlm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Coefficient plots for Multivariate Linear Models
}
\description{
Displays confidence ellipses
for all parameters in an multivariate linear model, 
for a given pair of variables.  As such, it is a generalization
of \code{\link[car]{confidenceEllipse}}.
}
\usage{

coefplot(object, ...)

\method{coefplot}{mlm}(object, variables = 1:2, parm = NULL, 
	df = NULL, level = 0.95, intercept = FALSE, 
	Scheffe = FALSE, bars = TRUE, 
	fill = FALSE, fill.alpha = 0.2, 
	labels = !add, label.pos = NULL, 
	xlab, ylab, 
	xlim = NULL, ylim = NULL, 
	axes = TRUE, main = "", add = FALSE, 
	lwd = 1, lty = 1, pch = 19, col = palette(), 
	cex = 2, cex.label = 1.5, 
	lty.zero = 3, col.zero = 1, pch.zero = '+',
	verbose = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{object}{
A multivariate linear model, such as fit by \code{lm()}
}
  \item{\dots}{
Other parameters passed to methods
}

  \item{variables}{
Response variables to plot, given as their indices or names
}
  \item{parm}{
Parameters to plot
}
  \item{df}{
Degrees of freedom for hypothesis tests
}
  \item{level}{
Confidence level
}
  \item{intercept}{
logical. Include the intercept?
}
  \item{Scheffe}{
If \code{TRUE}, confidence intervals for all parameters
have Scheffe coverage, otherwise, individual coverage.
}
  \item{bars}{
Draw univariate confidence intervals for each of the variables?
}
  \item{fill}{
a logical value or vector. \code{TRUE} means the confidence ellipses
will be filled.
}
  \item{fill.alpha}{
%%     ~~Describe \code{fill.alpha} here~~
}
  \item{labels}{
Labels for the confidence ellipses
}
  \item{label.pos}{
Positions of the labels for each ellipse.  See \code{\link{label.ellipse}}
}
  \item{xlab, ylab}{
x, y axis labels
}
  \item{xlim, ylim}{
Axis limits
}
  \item{axes}{
Draw axes?
}
  \item{main}{
Plot title
}
  \item{add}{
logical. Add to an existing plot?
}
  \item{lwd}{
Line widths
}
  \item{lty}{
Line types
}
  \item{pch}{
Point symbols for the parameter estimates
}
  \item{col}{
Colors for the confidence ellipses, points, lines
}
  \item{cex}{
Character size for points showing parameter estimates
}
  \item{cex.label}{
Character size for ellipse labels
}
  \item{lty.zero, col.zero, pch.zero}{
Line type, color and point symbol for horizontal and vertical lines at 0, 0.
}
  \item{verbose}{
logical.  Print parameter estimates and variance-covariance
for each parameter?
}
}
%\details{
%%%  ~~ If necessary, more details than the description above ~~
%}
\value{
	Returns invisibly a list of the coordinates of the ellipses drawn
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
\code{\link[car]{confidenceEllipse}}, ~~~
}
\examples{
mod <- lm(cbind(SAT,PPVT,Raven)~n+s+ns, data=Rohwer)

coefplot(mod, lwd=2, main="Bivariate coefficient plot for SAT and PPVT", fill=TRUE)
coefplot(mod, add=TRUE, Scheffe=TRUE, fill=TRUE)

coefplot(mod, var=c(1,3))

mod1 <- lm(cbind(SAT,PPVT,Raven)~n+s+ns+na+ss, data=Rohwer)
coefplot(mod1, lwd=2, fill=2 !=(1:5),
	main="Bivariate 68\% coefficient plot for SAT and PPVT", level=0.68)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{hplot}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
