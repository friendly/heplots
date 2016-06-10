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

