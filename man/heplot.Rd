\name{heplot}
\alias{heplot}
\alias{heplot.mlm}

\title{Two-Dimensional HE Plots}

\description{
This function plots ellipses representing the hypothesis and error
sums-of-squares-and-products matrices for terms and linear hypotheses in a 
multivariate linear model.  These include MANOVA models (all explanatory
variables are factors), multivariate regression (all quantitative predictors),
MANCOVA models, homogeneity of regression, as well as repeated measures
designs treated from a multivariate perspective.
}

\usage{
heplot(mod, ...)

\method{heplot}{mlm}(mod, terms, hypotheses, term.labels = TRUE,
    hyp.labels = TRUE, err.label="Error", label.pos=NULL,
    variables = 1:2, error.ellipse = !add, 
    factor.means = !add, grand.mean = !add, remove.intercept = TRUE,
    type = c("II", "III", "2", "3"), idata=NULL, idesign=NULL,
	icontrasts=c("contr.sum", "contr.poly"),
	imatrix=NULL, iterm=NULL, markH0=!is.null(iterm),
    manova, size = c("evidence", "effect.size"),
    level = 0.68, alpha = 0.05, segments = 60, 
    center.pch = "+", center.cex=2,
    col = getOption("heplot.colors", 
               c("red", "blue", "black", "darkgreen", 
                 "darkcyan","magenta", "brown","darkgray")),
    lty = 2:1, lwd = 1:2, 
    fill=FALSE, fill.alpha=0.3,   
    xlab, ylab, main = "", xlim, ylim, axes=TRUE, offset.axes, 
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
    \code{\link[car]{linearHypothesis}} function in the \code{car} package;
    the list elements can be named, in which case the names are used.}
  \item{term.labels}{logical value or character vector of names for the terms to be
    plotted. If \code{TRUE} (the default) the names of the terms are used;
    if \code{FALSE}, term labels are not plotted.}
  \item{hyp.labels}{logical value or character vector of names for the hypotheses to
    be plotted. If \code{TRUE} (the default) the names of components of the list of
    hypotheses are used; if \code{FALSE}, hypothesis labels are not plotted.}
  \item{err.label}{Label for the error ellipse}

  \item{label.pos}{
	Label position, a vector of integers (in \code{0:4}) or character strings
	(in \code{c("center", "bottom", "left", "top", "right")}, or in
	\code{c("C", "S", "W", "N", "E")} use in labeling ellipses,
	recycled as necessary.
	Values of 1, 2, 3 and 4, respectively indicate positions below, to the left of, above 
	and to the right of the max/min coordinates of the ellipse; the value 0 specifies
	the centroid of the \code{ellipse} object.
	The default, \code{label.pos=NULL}
	uses the correlation of the \code{ellipse} to determine "top" (r>=0) or "bottom" (r<0).
	Even more flexible options are described in \code{\link{label.ellipse}}
}

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
    the default (and \code{"2"} is a synonym).}
  \item{idata}{an optional data frame giving a factor or factors defining the 
    intra-subject model for multivariate repeated-measures data. 
    See Friendly (2010) and Details of \code{\link[car]{Anova}} for an explanation of the intra-subject design
    and for further explanation 
    of the other arguments relating to intra-subject factors.} 
  \item{idesign}{a one-sided model formula using the ``data'' in idata and specifying 
    the intra-subject design for repeated measure models.} 
  \item{icontrasts}{names of contrast-generating functions to be applied by default 
    to factors and ordered factors, respectively, in the within-subject ``data''; 
    the contrasts must produce an intra-subject model matrix in which different 
    terms are orthogonal. The default is c("contr.sum", "contr.poly").}
  \item{imatrix}{In lieu of \code{idata} and \code{idesign}, you can specify the
    intra-subject design matrix directly via \code{imatrix}, in the form of list of named elements.
    Each element gives
  	the columns of the within-subject model matrix for an intra-subject term to be tested, and must
  	have as many rows as there are responses; the columns of the within-subject model
  	matrix for \emph{different} terms must be mutually orthogonal. 
    \emph{This functionality
    requires \code{car} version 2.0 or later.}}
  \item{iterm}{For repeated measures designs, you must specify one intra-subject term
  	(a character string) to select the SSPE (E) matrix used in the HE plot. 
  	Hypothesis terms plotted include the \code{iterm} effect as well as all interactions
  	of \code{iterm} with \code{terms}.}
  \item{markH0}{A logical value (or else a list of arguments to \code{\link{mark.H0}}) used to
    draw cross-hairs and a point indicating the value of a point null hypothesis.
    The default is TRUE if \code{iterm} is non-NULL.}
  \item{manova}{optional \code{Anova.mlm} object for the model; if absent a
    MANOVA is computed. Specifying the argument can therefore save 
    computation in repeated calls.}
  \item{size}{how to scale the hypothesis ellipse relative to the error
    ellipse; if \code{"evidence"}, the default, the scaling is done so that
    a ``significant'' hypothesis ellipse at level \code{alpha} extends outside of the error
    ellipse; if \code{"effect.size"}, the hypothesis ellipse is on the same
    scale as the error ellipse.}  
  \item{level}{equivalent coverage of ellipse for normally-distributed
    errors, defaults to \code{0.68}, giving a standard 1 SD bivariate ellipse.}
  \item{alpha}{significance level for Roy's greatest-root test statistic; if
    \code{size="evidence"}, then the
    hypothesis ellipse is scaled so that it just touches the error ellipse at the
    specified alpha level; a larger hypothesis ellipse \emph{somewhere} in the space of
    the response variables therefore indicates
    statistical significance; defaults to \code{0.05}.}
  \item{segments}{number of line segments composing each ellipse; defaults to
    \code{60}.}
  \item{center.pch}{character to use in plotting the centroid of the data;
    defaults to \code{"+"}.}
  \item{center.cex}{size of character to use in plotting the centroid of the data;
    defaults to \code{2}.}
  \item{col}{a color or vector of colors to use in plotting ellipses; the first
    color is used for the error ellipse; the remaining colors --- recycled
    as necessary --- are used for the hypothesis ellipses. 
    A single color can be given, in which case it is used for all ellipses.
    For convenience, the default colors for all heplots produced in a given session can be changed
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
  within \code{[0,1]}, where 0 means fully transparent and 1 means fully opaque.}
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
   \eqn{H E^{-1}}) and the H "ellipse" collapses to a degenerate line. 
   
   Typically, you fit a mlm with \code{mymlm <- lm(cbind(y1, y2, y3, ...) ~ modelterms)},
   and plot some or all of the \code{modelterms} with \code{heplot(mymlm, ...)}.
   Arbitrary linear hypotheses related to the terms in the model (e.g., contrasts of
   an effect) can be included in the plot using the \code{hypotheses} argument. 
   See \code{\link[car]{linearHypothesis}} for details.
   
   For repeated measure designs, where the response variables correspond to one or
   more variates observed under a within-subject design, between-subject effects 
   and within-subject effects must be plotted separately, because the error terms 
   (E matrices) differ.  When you specify an intra-subject term (\code{iterm}),
   the analysis and HE plots
   amount to analysis of the matrix \bold{Y} of responses post-multiplied by a matrix 
   \bold{M} determined by the intra-subject design for that term.  See Friendly (2010)
   or the \code{vignette("repeated")} in this package for an extended discussion and
   examples.
   
    The related \code{\link[candisc]{candisc}} package provides functions for 
    visualizing a multivariate linear model in a low-dimensional view via a
    generalized canonical discriminant analyses.  \code{\link[candisc]{heplot.candisc}}
    and \code{\link[candisc]{heplot3d.candisc}} provide a low-rank 2D (or 3D) view of the effects for  
    a given term in the space of maximum discrimination.
    
    When an element of \code{fill} is \code{TRUE}, the ellipse outline is drawn using the corresponding
    color in \code{col}, and the interior is filled with a transparent version of this color specified
    in \code{fill.alpha}.  To produce filled (non-degenerate) ellipses without the bounding outline, use
    a value of \code{lty=0} in the corresponding position.
}

\value{
  The function invisibly returns an object of class \code{"heplot"}, with
  coordinates for the various hypothesis ellipses and the error ellipse, and
  the limits of the horizontal and vertical axes.  These may be useful for
  adding additional annotations to the plot, using standard plotting functions.
  (No methods for manipulating these objects are currently available.)

  The components are:
  \item{H}{a list containing the coordinates of each ellipse for the hypothesis terms}
  \item{E}{a matrix containing the coordinates for the error ellipse}
  \item{center}{x,y coordinates of the centroid}
  \item{xlim}{x-axis limits}
  \item{ylim}{y-axis limits}
  \item{radius}{the radius for the unit circles used to generate the ellipses}

}

\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples 
  \emph{Journal of Statistical Software}, \bold{17}(6), 1--42.
  \url{https://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, \bold{16}(2) 421--444.
  \url{http://datavis.ca/papers/jcgs-heplots.pdf} 

Friendly, Michael (2010). HE Plots for Repeated Measures Designs. \emph{Journal of Statistical Software},
  37(4), 1-40. URL \url{https://www.jstatsoft.org/v37/i04/}.

Fox, J., Friendly, M. & Weisberg, S. (2013).
Hypothesis Tests for Multivariate Linear Models Using the car Package.
\emph{The R Journal}, \bold{5}(1), 
\url{https://journal.r-project.org/archive/2013-1/fox-friendly-weisberg.pdf}.

Friendly, M. & Sigal, M. (2014)
Recent Advances in Visualizing Multivariate Linear Models.
\emph{Revista Colombiana de Estadistica}, \bold{37}, 261-283. 
%\url{http://ref.scielo.org/6gq33g}.

}

\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linearHypothesis}} for details on 
    testing MLMs.
    
    \code{\link{heplot1d}}, \code{\link{heplot3d}}, \code{\link{pairs.mlm}}, \code{\link{mark.H0}} for other
    HE plot functions. \code{\link{coefplot.mlm}} for plotting confidence ellipses for parameters
    in MLMs.
    
    \code{\link{trans.colors}} for calculation of transparent colors.
    \code{\link{label.ellipse}} for labeling positions in plotting H and E ellipses.
        
  	\code{\link[candisc]{candisc}},   \code{\link[candisc]{heplot.candisc}} for reduced-rank views of \code{mlm}s
  	in canonical space.
}

\examples{
## iris data
contrasts(iris$Species)<-matrix(c(0,-1,1, 2, -1, -1), 3,2)
contrasts(iris$Species)

iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
Species, data=iris)

hyp <- list("V:V"="Species1","S:VV"="Species2")
heplot(iris.mod, hypotheses=hyp)
# compare with effect-size scaling
heplot(iris.mod, hypotheses=hyp, size="effect", add=TRUE)

# try filled ellipses
heplot(iris.mod, hypotheses=hyp, fill=TRUE, fill.alpha=0.2, col=c("red", "blue"))
heplot(iris.mod, hypotheses=hyp, fill=TRUE, col=c("red", "blue"), lty=c(0,0,1,1))
# vary label position and fill.alpha
heplot(iris.mod, hypotheses=hyp, fill=TRUE, fill.alpha=c(0.3,0.1), col=c("red", "blue"), 
       lty=c(0,0,1,1), label.pos=0:3)


hep <-heplot(iris.mod, variables=c(1,3),  hypotheses=hyp)
str(hep)

# all pairs
pairs(iris.mod, hypotheses=hyp, hyp.labels=FALSE)


## Pottery data, from car package
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
col <- c("red", "black", "blue", "cyan", "magenta", "brown", "gray")
heplot(rohwer.mod, col=col)
# Add ellipse to test all 5 regressors
heplot(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")), col=col, fill=TRUE)
# View all pairs
pairs(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
# or 3D plot
if(requireNamespace("rgl")){
col <- c("pink", "black", "blue", "cyan", "magenta", "brown", "gray")
heplot3d(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")), col=col)
}
}

\keyword{hplot}
\keyword{aplot}
\keyword{multivariate}
