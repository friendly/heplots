
#' Visualizing Hypothesis Tests in Multivariate Linear Models
#' 
#' The `heplots` package provides functions for visualizing hypothesis
#' tests in multivariate linear models (MANOVA, multivariate multiple
#' regression, MANCOVA, and repeated measures designs).  HE plots represent
#' sums-of-squares-and-products matrices for linear hypotheses and for error
#' using ellipses (in two dimensions), ellipsoids (in three dimensions), or by
#' line segments in one dimension. 
#' 
#' The basic theory behind HE plots is described by Friendly (2007).
#' See Fox, Friendly and Monette (2007) for a
#' brief introduction; Friendly & Sigal (2016) for a tutorial on these methods;
#' and Friendly, Monette and Fox (2013) for a general
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
#' `vignette(package="heplots")`.
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
#' out a linear transformation of the matrix **Y** of responses to a matrix
#' **Y M**, where **M** is the model matrix for a term in the
#' intra-subject design and produce plots of the H and E matrices in this
#' transformed space. The vignette `repeated` describes these graphical
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
#' The `heplots` package also contains a large number of multivariate data
#' sets with examples of analyses and graphic displays.  Use
#' `data(package="heplots")` to see the current list.
#' 
#' @name heplots-package
#' @aliases heplots-package heplots _PACKAGE
#' @author 
#'    Michael Friendly, John Fox, and Georges Monette
#' 
#'    Maintainer: Michael Friendly, \email{friendly@yorku.ca}, <http://datavis.ca>
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
#' *Journal of Statistical Software*, 17(6), 1-42. %
#' <https://www.jstatsoft.org/v17/i06/>,
#' \doi{10.18637/jss.v017.i06}
#' 
#' Friendly, M. (2007).  HE plots for Multivariate General Linear Models.
#' *Journal of Computational and Graphical Statistics*, 16(2) 421-444.
#' <http://datavis.ca/papers/jcgs-heplots.pdf>,
#' \doi{10.1198/106186007X208407}
#' 
#' Fox, J., Friendly, M. & Monette, G. (2007).  Visual hypothesis tests in
#' multivariate linear models: The heplots package for R.  *DSC 2007:
#' Directions in Statistical Computing*.
#' <https://socialsciences.mcmaster.ca/jfox/heplots-dsc-paper.pdf>
#' 
#' Friendly, M. (2010). HE Plots for Repeated Measures Designs. *Journal
#' of Statistical Software*, 37(4), 1-40. 
#' \doi{10.18637/jss.v037.i04}.
#' 
#' Fox, J., Friendly, M. & Weisberg, S. (2013).  Hypothesis Tests for
#' Multivariate Linear Models Using the car Package.  *The R Journal*,
#' **5**(1),
#' <https://journal.r-project.org/news/RJ-2013-1-fox-friendly-weisberg/RJ-2013-1-fox-friendly-weisberg.pdf>.
#' 
#' Friendly, M., Monette, G. & Fox, J. (2013).  Elliptical Insights:
#' Understanding Statistical Methods Through Elliptical Geometry.
#' *Statistical Science*, 2013, **28** (1), 1-39,
#' <http://datavis.ca/papers/ellipses.pdf>.
#' 
#' Friendly, M. & Sigal, M. (2014). Recent Advances in Visualizing Multivariate
#' Linear Models. *Revista Colombiana de Estadistica*, **37**, 261-283
#' \doi{10.15446/rce.v37n2spe.47934}.
#' 
#' Friendly, M. & Sigal, M. (2016). Graphical Methods for Multivariate Linear
#' Models in Psychological Research: An R Tutorial. Submitted for publication.
#' 
#' @keywords package hplot aplot multivariate
#' 
#' @importFrom grDevices col2rgb gray palette rgb
#' @importFrom graphics abline arrows box dotchart lines par points polygon rect strheight strwidth text
#' @importFrom stats .getXlevels IQR SSD aggregate alias coefficients complete.cases cor cov df.residual 
#'        estVar formula getCall lm.wfit lsfit mahalanobis median model.frame model.matrix model.response model.weights 
#'        na.omit offset pchisq pf pnorm ppoints qchisq qf qnorm residuals runif update var vcov
NULL

















