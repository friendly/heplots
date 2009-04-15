\name{heplot}
\alias{heplot}
\alias{heplot.mlm}

\title{Two-Dimensional HE Plots}

\description{
This function plots ellipses representing the hypothesis and error
sums-of-squares-and-products matrices for terms and linear hypotheses in a 
multivariate linear model.
}

\usage{
heplot(mod, ...)

\method{heplot}{mlm}(mod, terms, hypotheses, term.labels = TRUE,
    hyp.labels = TRUE, variables = 1:2, error.ellipse = !add, 
    factor.means = !add, grand.mean = !add, remove.intercept = TRUE,
    type = c("II", "III", "2", "3"), manova, size = c("evidence", "effect.size"),
    level = 0.68, alpha = 0.05, segments = 40, center.pch = "+", col = palette()[-1], 
    lty = 2:1, lwd = 1:2, xlab, ylab, main = "", xlim, ylim, axes=TRUE, offset.axes, 
    add = FALSE, verbose = FALSE, warn.rank = FALSE, ...)
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
  \item{ylab}{y-axis label; defaults to name of the y variable.}
  \item{main}{main plot label; defaults to \code{""}.}
  \item{xlim}{x-axis limits; if absent, will be computed from the data.}
  \item{ylim}{y-axis limits; if absent, will be computed from the data.}
  \item{axes}{Whether to draw the x, y axes; defaults to \code{TRUE}}
  \item{offset.axes}{proportion to extend the axes in each direction if computed 
    from the data; optional.}
  \item{add}{if \code{TRUE}, add to the current plot; the default is \code{FALSE}.
    If \code{TRUE}, the error ellipse is not plotted.}
  \item{verbose}{if \code{TRUE}, print the MANOVA table and details of hypothesis
    tests; the default is \code{FALSE}.}
  \item{warn.rank}{if \code{TRUE}, do not suppress warnings about the rank of the
    hypothesis matrix when the ellipse collapses to a line; the default is
    \code{FALSE}.}
  \item{\dots}{arguments to pass down to \code{plot}, \code{text}, 
    and \code{points}.}
}

\details{
   The \code{heplot} function plots a representation of the covariance ellipses
   for hypothesized model terms and linear hypotheses (H) and the corresponding
   error (E) matrices for two response variables in a multivariate linear model (mlm).
     
   The plot helps to visualize the nature and dimensionality
   response variation on the two variables jointly
   in relation to error variation that is summarized in the various multivariate
   test statistics (Wilks' Lambda, Pillai trace, Hotelling-Lawley trace, Roy maximum
   root). Roy's maximum root test has a particularly simple visual interpretation,
   exploited in the \code{size="evidence"} version of the plot. See the description of
   argument \code{alpha}.
   
   For a 1 df hypothesis term (a quantitative regressor, a single contrast or 
   parameter test), the H matrix has rank 1 (one non-zero latent root of
   \eqn{H E^{-1}}) and the H ellipse collapses to a line. 
   
   Typically, you fit a mlm with \code{mymlm <- lm(cbind(y1, y2, y3, ...) ~ modelterms)},
   and plot some or all of the \code{modelterms} with \code{heplot(mymlm, ...)}.
   Arbitrary linear hypotheses related to the terms in the model (e.g., contrasts of
   an effect) can be included in the plot using the \code{hypotheses} argument. 
   See \code{\link[car]{linear.hypothesis}} for details.
   
}

\value{
  The function invisibly returns an object of class \code{"heplot"}, with
  coordinates for the various hypothesis ellipses and the error ellipse, and
  the limits of the horizontal and vertical axes.
  (No methods for manipulating these objects are currently available.)
}

\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples 
  \emph{Journal of Statistical Software}, \bold{17}(6), 1--42.
  \url{http://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, \bold{16}(2) 421--444.
  \url{http://www.math.yorku.ca/SCS/Papers/jcgs-heplots.pdf} 
}

\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linear.hypothesis}},
    \code{\link{heplot3d}}, \code{\link{pairs.mlm}}.
}

\examples{
## iris data
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
Species, data=iris)

heplot(iris.mod)
hep <-heplot(iris.mod, variables=c(1,3))
str(hep)
pairs(iris.mod)

## Pottery data, from cars package
data(Pottery)
pottery.mod <- lm(cbind(Al, Fe, Mg, Ca, Na) ~ Site, data=Pottery)
heplot(pottery.mod)
heplot(pottery.mod, terms=FALSE, add=TRUE, col="blue", 
  hypotheses=list(c("SiteCaldicot = 0", "SiteIsleThorns=0")),
  hyp.labels="Sites Caldicot and Isle Thorns")

## Rohwer data, multivariate multiple regression/ANCOVA
#-- ANCOVA, assuming equal slopes
rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data=Rohwer)
Anova(rohwer.mod)
heplot(rohwer.mod)
# Add ellipse to test all 5 regressors
heplot(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
# View all pairs
pairs(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
# or 3D plot
 heplot3d(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
}

\keyword{hplot}
\keyword{aplot}
\keyword{multivariate}
