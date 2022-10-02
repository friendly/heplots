



#' Internal heplots functions
#' 
#' Internal functions for package heplots.
#' 
#' These functions are not intended to be called by the user.
#' 
#' @aliases lambda.crit HLT.crit Roy.crit he.rep termInfo last
#' @param alpha significance level for critical values of multivariate
#' statistics
#' @param p Number of variables
#' @param dfh degrees of freedom for hypothesis
#' @param dfe degrees of freedom for error
#' @param test.statistic Test statistic used for the multivariate test
#' @param x An argument to \code{\link{heplot}} or \code{\link{heplot3d}} that
#' is to be repeated for Error and all hypothesis terms
#' @param n Number of hypothesis terms
#' @author Michael Friendly \email{friendly@@yorku.ca}
#' @keywords internal
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
#' \code{which="logDet"}. %%% ~~ If necessary, more details than the
#' __description__ above ~~ %} %\source{ %%% ~~ reference to a publication or
#' URL from which the data were obtained ~~ %} %\references{ %%% ~~ possibly
#' secondary sources and usages ~~
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









