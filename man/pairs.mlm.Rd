\name{pairs.mlm}
\alias{pairs.mlm}

\title{Pairwise HE Plots}
\description{
 The function (in the form of an \code{mlm} method for the generic 
 \code{\link[graphics]{pairs}} function) constructs a ``matrix'' of pairwise 
 HE plots (see \link{heplot}) for a multivariate linear model.
}

\usage{
\method{pairs}{mlm}(x, variables, type = c("II", "III", "2", "3"), 
  offset.axes = 0.05, digits = getOption("digits") - 1, ...)
}

\arguments{
  \item{x}{an object of class \code{mlm}.}
  \item{variables}{indices or names of the three of more response variables 
    to be plotted; defaults to all of the responses.}
  \item{type}{``type'' of sum-of-squares-and-products matrices to compute; one of
    \code{"II"}, \code{"III"}, \code{"2"}, or \code{"3"}, where \code{"II"} is
    the default (and \code{"2"} is a synomym).}
  \item{offset.axes}{proportion to extend the axes in each direction; defaults
    to 0.05.}
  \item{digits}{number of significant digits in axis end-labels; taken from
    the \code{"digits"} option.}
  \item{\dots}{arguments to pass down to \code{heplot}, which is used to draw
    each panel of the display.}
}
}

\references{
Friendly, M. (2006).
  Data Ellipses, HE Plots and Reduced-Rank Displays for Multivariate Linear 
  Models: SAS Software and Examples 
  \emph{Journal of Statistical Software}, 17(6), 1-42.
  \url{http://www.jstatsoft.org/v17/i06/}

Friendly, M. (2007).
  HE plots for Multivariate General Linear Models.
  \emph{Journal of Computational and Graphical Statistics}, 16, in press.
  \url{http://www.math.yorku.ca/SCS/Papers/heplots.pdf} 
}

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

