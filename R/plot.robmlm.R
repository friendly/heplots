#' Plot observation weights from a robust multivariate linear models
#' 
#' Creates an index plot of the observation weights assigned in the last
#' iteration of \code{\link{robmlm}}.  Observations with low weights have large
#' residual squared distances and are potential multivariate outliers with
#' respect to the fitted model.
#' 
#' 
#' @param x A \code{"robmlm"} object
#' @param labels Observation labels; if not specified, uses rownames from the
#'        original data
#' @param id.weight Threshold for identifying observations with small weights
#' @param id.pos Position of observation label relative to the point
#' @param pch Point symbol(s); can be a vector of length equal to the number of
#'        observations in the data frame
#' @param col Point color(s)
#' @param cex Point character size(s)
#' @param segments logical; if \code{TRUE}, draw line segments from 1.o down to
#'        the point
#' @param xlab x axis label
#' @param ylab y axis label
#' @param \dots other arguments passed to \code{\link[graphics]{plot}}
#' @return Returns invisibly the weights for the observations labeled in the
#'        plot
#' @author Michael Friendly
#' @seealso \code{\link{robmlm}}
#' @keywords hplot
#' @examples
#' 
#' data(Skulls)
#' sk.rmod <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' plot(sk.rmod, col=Skulls$epoch)
#' axis(side=3, at=15+seq(0,120,30), labels=levels(Skulls$epoch), cex.axis=1)
#' 
#' # Pottery data
#' 
#' pottery.rmod <- robmlm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
#' plot(pottery.rmod, col=Pottery$Site, segments=TRUE)
#' 
#' # SocialCog data
#' 
#' data(SocialCog)
#' SC.rmod <- robmlm(cbind( MgeEmotions, ToM, ExtBias, PersBias) ~ Dx,
#'                data=SocialCog)
#' plot(SC.rmod, col=SocialCog$Dx, segments=TRUE)
#' 
#' 
#' 
#' @exportS3Method plot robmlm
plot.robmlm <- 
	function(x, 
	         labels,
           id.weight = .7,
           id.pos = 4,
           pch=19, 
           col = palette()[1], 
           cex = par("cex"), 
           segments = FALSE,
           xlab="Case index",
           ylab="Weight in robust MANOVA",
           ...) {

	weights <- x$weights
	if (missing(labels)) labels <- rownames(residuals(x))
	
	plot(weights, pch=pch, col=col, cex=cex, 
		xlab = xlab, ylab = ylab,
		...)
	
	n <- length(weights)
	ind <- 1:n
	bad <- weights < id.weight
	text(ind[bad], weights[bad], labels[bad], pos = id.pos, xpd=TRUE)
	
	if(segments)
		segments(1:n, 1, 1:n, weights, col=col)

	names(weights) <- labels
	invisible(weights[bad])
}

