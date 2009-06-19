\name{heplot3d}
\alias{heplot3d}
\alias{heplot3d.mlm}

\title{Three-Dimensional HE Plots}

\description{
This function plots ellipsoids in 3D representing the hypothesis and error
sums-of-squares-and-products matrices for terms and linear hypotheses in a 
multivariate linear model.
}

\usage{
heplot3d(mod, ...)

\method{heplot3d}{mlm}(mod, terms, hypotheses, term.labels = TRUE, 
    hyp.labels = TRUE, variables = 1:3, error.ellipsoid = !add,
    factor.means = !add, grand.mean = !add, remove.intercept = TRUE, 
    type = c("II", "III", "2", "3"), manova, size = c("evidence", "effect.size"),
    level = 0.68, alpha = 0.05,  segments = 40, col = palette()[-1], lwd=c(1, 4),
    shade=TRUE, shade.alpha=0.1, wire=c(TRUE,FALSE),
    bg.col = c("white", "black"), fogtype = c("none", "exp2", "linear", "exp"), 
    fov = 30, offset = 0.01, xlab, ylab, zlab, xlim, ylim, zlim, add = FALSE, verbose = FALSE, 
    warn.rank = FALSE, ...)
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
  \item{variables}{indices or names of the three response variables to be plotted;
    defaults to \code{1:3}.}
  \item{error.ellipsoid}{if \code{TRUE}, plot the error ellipsoid; defaults to \code{TRUE},
    if the argument \code{add} is \code{FALSE} (see below).}
  \item{factor.means}{logical value or character vector of names of 
    factors for which the means
    are to be plotted, or \code{TRUE} or \code{FALSE}; defaults to \code{TRUE},
    if the argument \code{add} is \code{FALSE} (see below).}
  \item{grand.mean}{if \code{TRUE}, plot the centroid for all of the data; 
    defaults to \code{TRUE},
    if the argument \code{add} is \code{FALSE} (see below).}
  \item{remove.intercept}{if \code{TRUE} (the default), do not plot the 
    ellipsoid for the intercept even if it is in the MANOVA table.}
  \item{type}{``type'' of sum-of-squares-and-products matrices to compute; one of
    \code{"II"}, \code{"III"}, \code{"2"}, or \code{"3"}, where \code{"II"} is
    the default (and \code{"2"} is a synomym).}
  \item{manova}{optional \code{Anova.mlm} object for the model; if absent a
    MANOVA is computed. Specifying the argument can therefore save 
    computation in repeated calls.}
  \item{size}{how to scale the hypothesis ellipsoid relative to the error
    ellipsoid; if \code{"evidence"}, the default, the scaling is done so that
    a ``significant'' hypothesis elliposid extends outside of the error
    ellipsoid; if \code{"effect.size"}, the hypothesis ellipsoid is on the same
    scale as the error ellipsoid.}  
  \item{level}{equivalent coverage of ellipsoid for normally-distributed
    errors, defaults to \code{0.68}.}
  \item{alpha}{signficance level for Roy's greatest-root test statistic; if
    \code{size="evidence"}, then the
    hypothesis ellipsoid is scaled so that it just touches the error ellipsoid at the
    specified alpha level; a larger hypothesis elllipsoid therefore indicates
    statistical significance; defaults to \code{0.05}.}
  \item{segments}{number of segments composing each elliposid; defaults to
    \code{40}.}
  \item{col}{a colour or vector of colours to use in plotting ellipsoids; the first
    colour is used for the error ellipsoid; the remaining colours --- recycled
    as necessary --- are used for the hypothesis ellipsoids; 
    a single colour can be given, in which case it is used for all ellipsoids. 
    Defaults to the current colour palette, less its first element.}
  \item{lwd}{a two-element vector giving the line width for drawing ellipsoids
    (including those that degenerate to an ellipse) and
    for drawing ellipsoids that degenerate to a line segment. The default
    is \code{c(1, 4)}.}
  \item{shade}{a logical scalar or vector, indicating whether the ellipsoids should be
    rendered with \code{\link[rgl]{shade3d}}. Works like \code{col},  except that \code{FALSE}
    is used for any 1 df degenerate ellipsoid.}
  \item{shade.alpha}{a numeric value in the range [0,1], or a vector of such values, giving
    the alpha transparency for ellipsoids rendered with \code{shade=TRUE}.}
  \item{wire}{a logical scalar or vector, indicating whether the ellipsoids should be
    rendered with \code{\link[rgl]{wire3d}}. Works like \code{col}, except that \code{TRUE}
    is used for any 1 df degenerate ellipsoid.}
  \item{bg.col}{background colour, \code{"white"} or \code{"black"}, defaulting
    to \code{"white"}.} 
  \item{fogtype}{type of ``fog'' to use for depth-cueing; the default is 
    \code{"none"}. See \code{\link[rgl]{bg}}.}
  \item{fov}{field of view angle; controls perspective. 
    See \code{\link[rgl]{viewpoint}}.}
  \item{offset}{proportion of axes to off set labels; defaults to
    \code{0.01}.}
  \item{xlab}{x-axis label; defaults to name of the x variable.}
  \item{ylab}{y-axis label; defaults to name of the y variable.}
  \item{zlab}{z-axis label; defaults to name of the z variable.}
  \item{xlim}{x-axis limits; if absent, will be computed from the data.}
  \item{ylim}{y-axis limits; if absent, will be computed from the data.}
  \item{zlim}{z-axis limits; if absent, will be computed from the data.}
  \item{add}{if \code{TRUE}, add to the current plot; the default is \code{FALSE}.
    If \code{TRUE}, the error ellipsoid is neither plotted nor returned in the output object.}
  \item{verbose}{if \code{TRUE}, print the MANOVA table and details of hypothesis
    tests; the default is \code{FALSE}.}
  \item{warn.rank}{if \code{TRUE}, do not suppress warnings about the rank of the
    hypothesis matrix when the ellipsoid collapses to an ellipse or line; 
    the default is \code{FALSE}.}
  \item{\dots}{arguments passed from generic.}
}
\details{
	When the H matrix for a term has rank < 3, the ellipsoid collapses to an 
	ellipse	(rank(H)=2) or a line (rank(H)=1). 

	Rotating the plot can be particularly revealing, showing views in which H variation
	is particularly large or small in relation to E variation.  See \code{\link[rgl]{play3d}}
	and \code{\link[rgl]{movie3d}} for details on creating animations.
	
	The arguments \code{xlim}, \code{ylim}, and \code{zlim} can be used to expand the bounding
	box of the axes, but cannot decrease it.
}

\value{
  \code{heplot3d} invisibly returns a list containing the bounding boxes of the error (E)
  ellipsoid and for each term or linear hypothesis specified in the call.
  Each of these is a 2 x 3 matrix with rownames "min" and "max" and colnames
  corresponding to the variables plotted. An additional component, \code{center},
  contains the coordinates of the centroid in the plot.

  The function also leaves an object named
  \code{.frame} in the global environment, containing the rgl object IDs for
  the axes, axis labels, and bounding box; these are deleted and the axes, etc.
  redrawn if the plot is added to.
}

\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples 
  \emph{Journal of Statistical Software}, 17(6), 1-42.
  \url{http://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
  \url{http://www.math.yorku.ca/SCS/Papers/jcgs-heplots.pdf} 
}

\seealso{
    \code{\link[car]{Anova}}, \code{\link[car]{linear.hypothesis}}, for details on MANOVA tests and
    linear hypotheses
    
    \code{\link{heplot}}, \code{\link{pairs.mlm}}, for other plotting methods for \code{mlm} objects
    
    \code{\link[rgl]{rgl-package}}, 
    
    \code{\link[candisc]{heplot3d.candisc}}.
}

\examples{
# Soils data, from car package
soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth, data=Soils)
Anova(soils.mod)

heplot(soils.mod, variables=c("Ca", "Mg"))
pairs(soils.mod, terms="Depth", variables=c("pH", "N", "P", "Ca", "Mg"))

heplot3d(soils.mod, variables=c("Mg", "Ca", "Na"))

# Plastic data
plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
heplot3d(plastic.mod)
} 

\keyword{hplot}
\keyword{aplot}
\keyword{dynamic}
\keyword{multivariate}
