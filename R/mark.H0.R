# last modified 2 Jan 2010

# mark the location of a point corresponding to a null hypothesis



#' Mark a point null hypothesis in an HE plot
#' 
#' A utility function to draw and label a point in a 2D (or 3D) HE plot
#' corresponding to a point null hypothesis being tested. This is most useful
#' for repeated measure designs where null hypotheses for within-S effects
#' often correspond to (0,0).
#' 
#' 
#' @param x Horizontal coordinate for H0
#' @param y Vertical coordinate for H0
#' @param z z coordinate for H0.  If not NULL, the function assumes that a
#'        `heplot3d` plot has been drawn.
#' @param label Text used to label the point. Defaults to
#'        `expression(H[0])` in 2D plots.
#' @param cex Point and text size.  For 3D plots, the function uses
#'        `size=5*cex` in a call to \code{\link[rgl]{points3d}}.
#' @param pch Plot character.  Ignored for 3D plots.
#' @param col Color for text, character and lines
#' @param lty Line type for vertical and horizontal reference lines. Not drawn if `lty`=0.
#' @param pos Position of text.  Ignored for 3D plots
#' @return None. Used for side effect of drawing on the current plot. 
#' 
#' @author Michael Friendly
#' @seealso \code{\link{cross3d}}
#' @keywords aplot
#' @examples
#' 
#' Vocab.mod <- lm(cbind(grade8,grade9,grade10,grade11) ~ 1, data=VocabGrowth)
#' idata <-data.frame(grade=ordered(8:11))
#' 
#' heplot(Vocab.mod, type="III", idata=idata, idesign=~grade, iterm="grade",
#' 	main="HE plot for Grade effect")
#' mark.H0()
#' 
#' @export mark.H0
mark.H0 <- function(x=0, y=0, z=NULL, label, cex=2, pch=19, col="green3", lty=2, pos=2) {
	if (is.null(z)) {
		points(x,y, cex=cex, col=col, pch=pch)
		if (missing(label)) label<-expression(H[0])
		text(x,y, label, col=col, pos=pos)
		if (lty>0) abline(h=y, col=col, lty=lty)
		if (lty>0) abline(v=x, col=col, lty=lty)
	}
	else {
		bbox <- matrix(rgl::par3d("bbox"), nrow=2)
		ranges <- apply(bbox, 2, diff)
		rgl::points3d(x, y, z, size=5*cex, color=col)
		if(lty>0) cross3d(c(x,y,z), (ranges/2), col=col, lty=lty)
	}
}
