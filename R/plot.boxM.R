#' Plot for Box's M test and generalizations
#' 
#' @description
#' 
#' This function creates a simple dot chart showing the contributions (log
#' determinants) of the various groups to Box's M test for equality of
#' covariance matrices. An important virtue of these plots is that they can show
#' \emph{how} the groups differ from each other, and from the pooled
#' covariance matrix using a scalar like \eqn{ln | S |}. In this way, they
#' can suggest more specific questions or hypotheses regarding the
#' equality of covariance matrices, analogous to the use of contrasts
#' and linear hypotheses for testing differences among group mean vectors.
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
#' @references 
#' Friendly, M., & Sigal, M. (2018). Visualizing Tests for Equality of Covariance Matrices. 
#' \emph{The American Statistician}, \bold{72}(4);
#' \doi{10.1080/00031305.2018.1497537}.
#' Online: \url{https://www.datavis.ca/papers/EqCov-TAS.pdf}.
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
#' @exportS3Method plot boxM
plot.boxM <- 
  function(x, gplabel = NULL,
           which = c("logDet", "product", "sum", "precision", "max"),
           log = which=="product",
           pch=c(16, 15), 
           cex=c(2, 2.5), 
           col=c("blue", "red"),
           rev = FALSE,
           xlim,
           conf=0.95, method=1, bias.adj=TRUE, lwd=2, ...) {
    
    which <- match.arg(which)
    if (which=="logDet") {
      measure <- x$logDet
      xlab <- "log determinant"
    }
    else {
      eigstats <- summary(x, quiet=TRUE)$eigstats
      measure <- eigstats[which,]
      if(log) measure <- log(measure)
      xlab <- paste(if(log) "log" else "", which, "of eigenvalues" )
      conf <- 0
    }
    
    
    ng <- length(measure)-1
    
    if (missing(xlim)) {
      xlim <- range(measure)
    }
    
    if (conf>0) {
      cov <- c(x$cov, list(pooled=x$pooled))
      n <- x$df + c(rep(1, ng), ng)
      CI <- logdetCI( cov, n=n, conf=conf, method=method, bias.adj=bias.adj )
      xlim[1] <- min(xlim[1], CI$lower)
      xlim[2] <- max(xlim[2], CI$upper)
    }
    
    yorder <- if (rev) c(ng:1, ng+1) else 1:(ng+1)
    dotchart(measure[yorder], xlab = xlab, xlim=xlim,  ...)
    if (conf>0) {
      arrows(CI$lower, yorder, CI$upper, yorder, lwd=lwd, angle=90, length=.075, code=3)
    }
    points(measure, yorder,  
           cex=c(rep(cex[1], ng), cex[2]), 
           pch=c(rep(pch[1], ng), pch[2]),
           col=c(rep(col[1], ng), col[2]))
    
    if(!is.null(gplabel))
      text(par("usr")[1], ng + .5, gplabel, pos=4, cex=1.25)
    
  }


# TESTME <- FALSE
# if(TESTME) {
# 
# data(Skulls, package="heplots")
# # make shorter labels for epochs
# Skulls$epoch <- ordered(Skulls$epoch, labels=sub("c","",levels(Skulls$epoch)))
# skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
# skulls.boxm <- boxM(skulls.mod)
# 
# plot(skulls.boxm, gplabel="Epoch")
# 
# op <- par(mfrow=c(2,2), mar=c(5,4,1,1))
# plot_eigstats(skulls.boxm, which="product", gplabel="Epoch", xlim=c(10,14))
# plot_eigstats(skulls.boxm, which="sum", gplabel="Epoch")
# plot_eigstats(skulls.boxm, which="precision", gplabel="Epoch")
# plot_eigstats(skulls.boxm, which="max", gplabel="Epoch")
# par(op)
# 
# }