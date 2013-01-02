# Plot an interpolation between two related data sets,
# typically transformations of each other.
# This function is designed to be used in animations.

# DONE: incorporate xlim, ylim from xy1, xy2
# TODO: incorporate the loop over alpha values?

interpPlot <- function(xy1, xy2, alpha,
		xlim, ylim, 
		ellipse = FALSE, ellipse.args = NULL, 
		abline=FALSE, col.lines = palette()[2], lwd=2,
		id.method = "mahal", labels=rownames(xy1), 
		id.n = 0, id.cex = 1, id.col = palette()[1],
		segments=FALSE, segment.col="darkgray",
		 ...){

	 xy1 <- as.matrix(xy1)
	 xy2 <- as.matrix(xy2)
	 # interpolate
	 xy <- xy1 + alpha * (xy2-xy1)
	 
	 # set default plot limits to incorporate xy1, xy2
	 lims <- apply(rbind(xy1, xy2), 2, range)
	 if (missing(xlim)) xlim=lims[,1]
	 if (missing(ylim)) ylim=lims[,2]
	 
	 plot(xy, xlim=xlim, ylim=ylim, ...)
	 if (ellipse) {
		 ellipse.args <- c(list(xy, add = TRUE, plot.points = FALSE), 
				 ellipse.args)
		 do.call(dataEllipse, ellipse.args)
	 }
	 if (abline) {
		 abline(lsfit(xy[, 1], xy[, 2]), col = col.lines, 
				 lwd = lwd)
	 }
	 showLabels(xy[, 1], xy[, 2], labels = labels, id.method = id.method, 
			 id.n = id.n, id.cex = id.cex, id.col = id.col)
	 
	 if(segments) {
		 segments(xy1[,1], xy1[,2], xy[,1], xy[,2], col=segment.col)
	 }
}

