\name{pairs.mlm}
\alias{pairs.mlm}

\title{Pairwise HE Plots}
\description{
 The function (in the form of an \code{mlm} method for the generic 
 \code{\link[graphics]{pairs}} function) constructs a ``matrix'' of pairwise 
 HE plots (see \link{heplot}) for a multivariate linear model.
}

\usage{
\method{pairs}{mlm}(x, variables, var.labels, var.cex=2,
  type = c("II", "III", "2", "3"), 
	idata=NULL, idesign=NULL, icontrasts=NULL, imatrix=NULL, iterm=NULL, manova,
  offset.axes = 0.05, digits = getOption("digits") - 1, fill=FALSE, fill.alpha=0.3, ...)
}

\arguments{
  \item{x}{an object of class \code{mlm}.}
  \item{variables}{indices or names of the three of more response variables 
    to be plotted; defaults to all of the responses.}
  \item{var.labels}{labels for the variables plotted in the diagonal panels;
    defaults to names of the response variables.}
  \item{var.cex}{character expansion for the variable labels.}
  \item{type}{``type'' of sum-of-squares-and-products matrices to compute; one of
    \code{"II"}, \code{"III"}, \code{"2"}, or \code{"3"}, where \code{"II"} is
    the default (and \code{"2"} is a synonym).}
  \item{idata}{an optional data frame giving a factor or factors defining the 
    intra-subject model for multivariate repeated-measures data. 
    See Details of \code{\link[car]{Anova}} for an explanation of the intra-subject design and for further explanation 
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
  \item{manova}{optional \code{Anova.mlm} object for the model; if absent a
    MANOVA is computed. Specifying the argument can therefore save 
    computation in repeated calls.}
  \item{offset.axes}{proportion to extend the axes in each direction; defaults
    to 0.05.}
  \item{digits}{number of significant digits in axis end-labels; taken from
    the \code{"digits"} option.}
  \item{fill}{A logical vector indicating whether each ellipse should be filled or not.
    The first value is used for the error ellipse, the rest --- possibly recycled --- for
    the hypothesis ellipses; a single fill value can be given.  
    Defaults to FALSE for backward compatibility. See Details of \code{\link{heplot}}}
  \item{fill.alpha}{Alpha transparency for filled ellipses, a numeric scalar or vector of values
  within \code{[0,1]}, where 0 means fully transparent and 1 means fully opaque. Defaults to 0.3.}
  \item{\dots}{arguments to pass down to \code{heplot}, which is used to draw
    each panel of the display.}
}


\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples 
  \emph{Journal of Statistical Software}, 17(6), 1-42.
  \url{https://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
  \url{http://datavis.ca/papers/jcgs-heplots.pdf} 
}

\author{Michael Friendly}

\seealso{
\code{\link{heplot}}, \code{\link{heplot3d}}
}

\examples{
# ANCOVA, assuming equal slopes
rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data=Rohwer)

# View all pairs, with ellipse for all 5 regressors
pairs(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))

}

\keyword{hplot}
\keyword{multivariate}

