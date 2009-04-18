\name{heplot1d}
\alias{heplot1d}
\alias{heplot1d.mlm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{One-Dimensional HE Plots}

\description{
This function plots a 1-dimensional representation of the hypothesis and error
sums-of-squares-and-products matrices for terms and linear hypotheses in a 
multivariate linear model.
}

\usage{
heplot1d(mod, ...)

\method{heplot1d}{mlm}(mod, terms, hypotheses, term.labels = TRUE, hyp.labels = TRUE, 
	variables = 1, error.ellipse = !add, factor.means = !add, grand.mean = !add, 
	remove.intercept = TRUE, 
	type = c("II", "III", "2", "3"), manova, size = c("evidence", "effect.size"), 
level = 0.68, alpha = 0.05, segments = 40, center.pch = "|", col = palette()[-1], 
lty = 2:1, lwd = 1:2, xlab, main = "", xlim, axes = TRUE, offset.axes, add = FALSE, 
verbose = FALSE, ...)
}

\arguments{
  \item{mod}{a model object of class \code{"mlm"}.}
  \item{terms}{a logical value or character vector of terms in the model 
    for which to plot
    hypothesis matrices; if missing or \code{TRUE}, defaults to all terms; 
    if \code{FALSE}, no terms are plotted.}
  \item{hypotheses}{optional list of linear hypotheses for which to plot hypothesis
    matrices; hypotheses are specified as for the
    \code{\link[car]{linear.hypothesis}} function in the \code{car} package;
    the list elements can be named, in which case the names are used.}
  \item{term.labels}{logical value or character vector of names for the terms to be
    plotted. If \code{TRUE} (the default) the names of the terms are used;
    if \code{FALSE}, term labels are not plotted.}
  \item{hyp.labels}{logical value or character vector of names for the hypotheses to
    be plotted. If \code{TRUE} (the default) the names of components of the list of
    hypotheses are used; if \code{FALSE}, hypothesis labels are not plotted.}
  \item{variables}{indices or names of the two response variables to be plotted;
    defaults to \code{1:2}.}
  \item{error.ellipse}{if \code{TRUE}, plot the error ellipse; defaults to \code{TRUE},
    if the argument \code{add} is \code{FALSE} (see below).}
  \item{factor.means}{logical value or character vector of names of 
    factors for which the means
    are to be plotted, or \code{TRUE} or \code{FALSE}; defaults to \code{TRUE},
    if the argument \code{add} is \code{FALSE} (see below).}
  \item{grand.mean}{if \code{TRUE}, plot the centroid for all of the data; 
    defaults to \code{TRUE},
    if the argument \code{add} is \code{FALSE} (see below).}
  \item{remove.intercept}{if \code{TRUE} (the default), do not plot the 
    ellipse for the intercept even if it is in the MANOVA table.}
  \item{type}{``type'' of sum-of-squares-and-products matrices to compute; one of
    \code{"II"}, \code{"III"}, \code{"2"}, or \code{"3"}, where \code{"II"} is
    the default (and \code{"2"} is a synomym).}
  \item{manova}{optional \code{Anova.mlm} object for the model; if absent a
    MANOVA is computed. Specifying the argument can therefore save 
    computation in repeated calls.}
  \item{size}{how to scale the hypothesis ellipse relative to the error
    ellipse; if \code{"evidence"}, the default, the scaling is done so that
    a ``significant'' hypothesis ellipse extends outside of the error
    ellipse; if \code{"effect.size"}, the hypothesis ellipse is on the same
    scale as the error ellipse.}  
  \item{level}{equivalent coverage of ellipse for normally-distributed
    errors, defaults to \code{0.68}.}
  \item{alpha}{signficance level for Roy's greatest-root test statistic; if
    \code{size="evidence"}, then the
    hypothesis ellipse is scaled so that it just touches the error ellipse at the
    specified alpha level; a larger hypothesis elllipse therefore indicates
    statistical significance; defaults to \code{0.05}.}
  \item{segments}{number of line segments composing each ellipse; defaults to
    \code{40}.}
  \item{center.pch}{character to use in plotting the centroid of the data;
    defaults to \code{"+"}.}
  \item{col}{a colour or vector of colours to use in plotting ellipses; the first
    colour is used for the error ellipse; the remaining colours --- recycled
    as necessary --- are used for the hypothesis ellipses; 
    a single colour can be given, in which case it is used for all ellipses. 
    Defaults to the current colour palette, less its first element.}
  \item{lty}{vector of line types to use for plotting the ellipses; the first is
    used for the error ellipse, the rest --- possibly recycled --- for
    the hypothesis ellipses; a single line type can be given. Defaults to
    \code{2:1}.}
  \item{lwd}{vector of line widths to use for plotting the ellipses; the first is
    used for the error ellipse, the rest --- possibly recycled --- for
    the hypothesis ellipses; a single line width can be given. Defaults to
    \code{1:2}.}
  \item{xlab}{x-axis label; defaults to name of the x variable.}
  \item{main}{main plot label; defaults to \code{""}.}
  \item{xlim}{x-axis limits; if absent, will be computed from the data.}
  \item{axes}{Whether to draw the x, y axes; defaults to \code{TRUE}}
  \item{offset.axes}{proportion to extend the axes in each direction if computed 
    from the data; optional.}
  \item{add}{if \code{TRUE}, add to the current plot; the default is \code{FALSE}.
    If \code{TRUE}, the error ellipse is not plotted.}
  \item{verbose}{if \code{TRUE}, print the MANOVA table and details of hypothesis
    tests; the default is \code{FALSE}.}
  \item{\dots}{arguments to pass down to \code{plot}, \code{text}, 
    and \code{points}.}
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{Michael Friendly}
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linear.hypothesis}},
    \code{\link{heplot}}, \code{\link{heplot3d}}, \code{\link{pairs.mlm}}.
}
 \examples{
plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
heplot1d(plastic.mod, col=c(rgb(1,0,0,0.2),"blue"))

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{hplot}
\keyword{aplot}
\keyword{multivariate}
