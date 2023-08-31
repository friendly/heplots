
#' Visualizing Hypothesis Tests in Multivariate Linear Models
#' 
#' The \code{heplots} package provides functions for visualizing hypothesis
#' tests in multivariate linear models (MANOVA, multivariate multiple
#' regression, MANCOVA, and repeated measures designs).  HE plots represent
#' sums-of-squares-and-products matrices for linear hypotheses and for error
#' using ellipses (in two dimensions), ellipsoids (in three dimensions), or by
#' line segments in one dimension. See Fox, Friendly and Monette (2007) for a
#' brief introduction and Friendly, Monette and Fox (2013) for a general
#' discussion of the role of elliptical geometry in statistical understanding.
#' 
#' Other topics now addressed here include robust MLMs, tests for equality of
#' covariance matrices in MLMs, and chi square Q-Q plots for MLMs.
#' 
#' The package also provides a collection of data sets illustrating a variety
#' of multivariate linear models of the types listed above, together with
#' graphical displays.
#' 
#' Several tutorial vignettes are also included.  See
#' \code{vignette(package="heplots")}.
#' 
#' The graphical functions contained here all display multivariate model
#' effects in variable (data) space, for one or more response variables (or
#' contrasts among response variables in repeated measures designs).
#' 
#' \describe{ 
#' \item{list(list("heplot"))}{constructs two-dimensional HE plots
#' for model terms and linear hypotheses for pairs of response variables in
#' multivariate linear models.}
#' 
#' \item{list(list("heplot3d"))}{constructs analogous 3D plots for triples of
#' response variables.}
#' 
#' \item{list(list("pairs.mlm"))}{constructs a ``matrix'' of pairwise HE
#' plots.}
#' 
#' \item{list(list("heplot1d"))}{constructs 1-dimensional analogs of HE plots
#' for model terms and linear hypotheses for single response variables.} 
#' }
#' 
#' For repeated measure designs, between-subject effects and within-subject
#' effects must be plotted separately, because the error terms (E matrices)
#' differ.  For terms involving within-subject effects, these functions carry
#' out a linear transformation of the matrix \bold{Y} of responses to a matrix
#' \bold{Y M}, where \bold{M} is the model matrix for a term in the
#' intra-subject design and produce plots of the H and E matrices in this
#' transformed space. The vignette \code{repeated} describes these graphical
#' methods for repeated measures designs.
#' 
#' The related \pkg{car} package calculates Type II and Type III tests of
#' multivariate linear hypotheses using the \code{\link[car]{Anova}} and
#' \code{\link[car]{linearHypothesis}} functions.
#' 
#' The \code{\link[candisc]{candisc-package}} package provides functions for
#' visualizing effects for MLM model terms in a low-dimensional canonical space
#' that shows the largest hypothesis relative to error variation. The
#' \pkg{candisc} package now also includes related methods for canonical
#' correlation analysis.
#' 
#' The \code{heplots} package also contains a large number of multivariate data
#' sets with examples of analyses and graphic displays.  Use
#' \code{data(package="heplots")} to see the current list.
#' 
#' @name heplots-package
#' @aliases heplots-package heplots
#' @docType package
#' @author 
#'    Michael Friendly, John Fox, and Georges Monette
#' 
#'    Maintainer: Michael Friendly, \email{friendly@yorku.ca}, \url{http://datavis.ca}
#' @seealso 
#'     \code{\link[car]{Anova}}, \code{\link[car]{linearHypothesis}} for Anova.mlm computations and tests
#' 
#'     \code{\link[candisc]{candisc-package}} for reduced-rank views in canonical space
#' 
#'     \code{\link[stats]{manova}} for a different approach to testing effects in MANOVA designs
#'     
#' @references 
#' Friendly, M. (2006).  Data Ellipses, HE Plots and Reduced-Rank
#' Displays for Multivariate Linear Models: SAS Software and Examples.
#' \emph{Journal of Statistical Software}, 17(6), 1-42. %
#' \url{https://www.jstatsoft.org/v17/i06/}
#' c("\\Sexpr[results=rd,stage=build]{tools:::Rd_expr_doi(\"#1\")}",
#' "10.18637/jss.v017.i06")\Sexpr{tools:::Rd_expr_doi("10.18637/jss.v017.i06")}
#' 
#' Friendly, M. (2007).  HE plots for Multivariate General Linear Models.
#' \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
#' \url{http://datavis.ca/papers/jcgs-heplots.pdf}
#' 
#' Fox, J., Friendly, M. & Monette, G. (2007).  Visual hypothesis tests in
#' multivariate linear models: The heplots package for R.  \emph{DSC 2007:
#' Directions in Statistical Computing}.
#' \url{https://socialsciences.mcmaster.ca/jfox/heplots-dsc-paper.pdf}
#' 
#' Friendly, M. (2010). HE Plots for Repeated Measures Designs. \emph{Journal
#' of Statistical Software}, 37(4), 1-40. 
#' \doi{10.18637/jss.v037.i04}.
#' 
#' Fox, J., Friendly, M. & Weisberg, S. (2013).  Hypothesis Tests for
#' Multivariate Linear Models Using the car Package.  \emph{The R Journal},
#' \bold{5}(1),
#' \url{https://journal.r-project.org/archive/2013-1/fox-friendly-weisberg.pdf}.
#' 
#' Friendly, M., Monette, G. & Fox, J. (2013).  Elliptical Insights:
#' Understanding Statistical Methods Through Elliptical Geometry.
#' \emph{Statistical Science}, 2013, \bold{28} (1), 1-39,
#' \url{http://datavis.ca/papers/ellipses.pdf}.
#' 
#' Friendly, M. & Sigal, M. (2014). Recent Advances in Visualizing Multivariate
#' Linear Models. \emph{Revista Colombiana de Estadistica}, \bold{37}, 261-283
#' % \url{http://ref.scielo.org/6gq33g}.
#' 
#' Friendly, M. & Sigal, M. (2016). Graphical Methods for Multivariate Linear
#' Models in Psychological Research: An R Tutorial. Submitted for publication.
#' @keywords package hplot aplot multivariate
#' 
#' @importFrom grDevices col2rgb gray palette rgb
#' @importFrom graphics abline arrows box dotchart lines par points polygon rect strheight strwidth text
#' @importFrom stats .getXlevels IQR SSD aggregate alias coefficients complete.cases cor cov df.residual 
#'        estVar formula getCall lm.wfit lsfit mahalanobis median model.frame model.matrix model.response model.weights 
#'        na.omit offset pchisq pf pnorm ppoints qchisq qf qnorm residuals runif update var vcov
NULL








#' Plot for Box's M test and generalizations
#' 
#' This function creates a simple dot chart showing the contributions (log
#' determinants) of the various groups to Box's M test for equality of
#' covariance matrices.
#' 
#' Because Box's M test is based on a specific function (log determinant) of
#' the covariance matrices in the groups compared to the pooled covariance
#' matrix, this function also also allow plots of other measures based on the
#' eigenvalues of these covariance matrices.
#' 
#' Confidence intervals are only available for the default Box M test, using
#' \code{which="logDet"}. 
#' 
#' @name plot.boxM
#' @docType data
#' @param x A \code{"boxM"} object resulting from \code{\link{boxM}}
#' @param gplabel character string used to label the group factor.
#' @param which Measure to be plotted. The default, \code{"logDet"}, is the
#' standard plot.  Other values are: \code{"product"}, \code{"sum"},
#' \code{"precision"} and \code{"max"}
#' @param log logical; if \code{TRUE}, the log of the measure is plotted. The
#' default, \code{which=="product"}, produces a plot equivalent to the plot of
#' \code{"logDet"}.
#' @param pch a vector of two point symbols to use for the individual groups
#' and the pooled data, respectively
#' @param cex character size of point symbols, a vector of length two for
#' groups and pooled data, respectively
#' @param col colors for point symbols, a vector of length two for the groups
#' and the pooled data
#' @param rev logical; if \code{TRUE}, the order of the groups is reversed on
#' the vertical axis.
#' @param xlim x limits for the plot
#' @param conf coverage for approximate confidence intervals, \code{0 <= conf <
#' 1} ; use \code{conf=0} to suppress these
#' @param method confidence interval method; see \code{\link{logdetCI}}
#' @param bias.adj confidence interval bias adjustment; see
#' \code{\link{logdetCI}}
#' @param lwd line width for confidence interval
#' @param ... Arguments passed down to \code{\link[graphics]{dotchart}}.
#' @author Michael Friendly
#' @seealso \code{\link{boxM}}, \code{\link{logdetCI}}
#' 
#' \code{\link[graphics]{dotchart}}
#' @keywords hgraph
#' @examples
#' 
#' # Iris data
#' res <- boxM(iris[, 1:4], iris[, "Species"])
#' plot(res, gplabel="Species")
#' 
#' # Skulls data
#' skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' skulls.boxm <- boxM(skulls.mod)
#' plot(skulls.boxm, gplabel="Epoch")
#' plot(skulls.boxm, gplabel="Epoch", bias.adj=FALSE)
#' 
#' # other measures
#'  plot(skulls.boxm, which="product", gplabel="Epoch", xlim=c(10,14))
#'  plot(skulls.boxm, which="sum", gplabel="Epoch")
#'  plot(skulls.boxm, which="precision", gplabel="Epoch")
#'  plot(skulls.boxm, which="max", gplabel="Epoch")
#' 
#' 
#' 
NULL









