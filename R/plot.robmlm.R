#' Plot observation weights from a robust multivariate linear models
#' 
#' Creates an index plot of the observation weights assigned in the last
#' iteration of \code{\link{robmlm}}.  Observations with low weights have large
#' residual squared distances and are potential multivariate outliers with
#' respect to the fitted model.
#' 
#' 
#' @param x A `"robmlm"` object
#' @param labels Observation labels for point identification. If not specified, uses `rownames` from the
#'        original data
#' @param groups Optional grouping variable, a factor with length equal to the number of observations, used to  identify groups in the plot.
#' @param group.axis Logical; whether to draw an axis at the top identifying the groups. Not drawn if `groups` is missing.
#' @param id.weight Threshold for identifying observations with small weights
#' @param id.pos Position of observation label relative to the point
#' @param pch Point symbol(s); can be a vector of length equal to the number of
#'        observations in the data frame.
#' @param col Point color(s).  Multiple colors can be specified so that each point can be given its own color. If there are fewer colors than points they are recycled in the standard fashion.
#' @param cex Point character size(s)
#' @param segments logical; if `TRUE`, draw line segments from 1.0 down to
#'        the point
#' @param xlab x axis label
#' @param ylab y axis label
#' @param \dots other arguments passed to \code{\link[graphics]{plot}}
#' @return Returns invisibly the weights for the observations labeled in the
#'        plot
#' @importFrom graphics axis
#' @author Michael Friendly
#' @seealso \code{\link{robmlm}}
#' @keywords hplot
#' @examples
#' 
#' data(Skulls)
#' sk.rmod <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' plot(sk.rmod, col=Skulls$epoch, segments=TRUE)
#' axis(side=3, at=15+seq(0,120,30), labels=levels(Skulls$epoch), cex.axis=1)
#' 
#' # Pottery data
#' 
#' data(Pottery, package = "carData")
#' pottery.rmod <- robmlm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
#' plot(pottery.rmod, col=Pottery$Site, segments=TRUE)
#' 
#' # SocialCog data
#' 
#' data(SocialCog)
#' SC.rmod <- robmlm(cbind( MgeEmotions, ToM, ExtBias, PersBias) ~ Dx,
#'                data=SocialCog)
#' plot(SC.rmod, 
#'      col=SocialCog$Dx, segments=TRUE)
#' # label the groups 
#' ctr <- split(seq(nrow(SocialCog)), SocialCog$Dx) |> lapply(mean)
#' axis(side = 3, at=ctr, labels = names(ctr), cex.axis=1.2)
#' 
#' # use the groups arg
#' colors = c("red", "darkgreen", "blue") 
#' ids <- plot(SC.rmod, 
#'      groups=SocialCog$Dx, 
#'      col = colors,
#'      pch = 15:17,
#'      segments=TRUE)
#' 
#' # the cases labeled and their weights
#' ids
#' 
#' 
#' @exportS3Method plot robmlm
plot.robmlm <- 
	function(x, 
	         labels,
	         groups,
	         group.axis = TRUE,
           id.weight = .7,
           id.pos = 4,
           pch=19, 
           col = palette()[1], 
           cex = par("cex"), 
           segments = FALSE,
           xlab="Case index",
           ylab="Weight in robust MLM",
           ...) {

	weights <- x$weights
	nobs <- length(weights)
	if (missing(labels)) labels <- rownames(residuals(x))
	
   n.groups <- if (!missing(groups)) {
    if (!is.factor(groups)) groups <- as.factor(groups)
    length(levels(groups))
    }
    else 1

	 # assign pch and col based on groups
	 if (n.groups > 1 & length(pch) == n.groups) pch = pch[groups]
	 if (n.groups > 1 & length(col) == n.groups) col = col[as.integer(groups)]

  # browser()
	
	plot(weights, pch=pch, col=col, cex=cex, 
		xlab = xlab, ylab = ylab,
		...)
	
	ind <- 1:nobs
	bad <- weights < id.weight
	if(sum(bad) > 0) text(ind[bad], weights[bad], labels[bad], pos = id.pos, xpd=TRUE)
	
	if(segments)
		segments(1:nobs, 1, 1:nobs, weights, col=col)
	
	if (group.axis & !missing(groups)) {
  	if(n.groups > 1 & !is.unsorted(groups)) {
  	  ctr <- split(seq(nobs), groups) |> lapply(mean)
      axis(side = 3, at=ctr, labels = names(ctr), cex.axis=1.2)
  	}
	}

	names(weights) <- labels
	invisible(weights[bad])
}

