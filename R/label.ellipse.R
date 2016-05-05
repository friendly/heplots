#'  Label an ellipse
#'
#' @description 
#'  \code{label.ellipse} is used to a draw text label on an ellipse at its center or
#'  somewhere around the periphery in a very flexible way.
#'
#' @details 
#' If \code{label.pos=NULL}, the function uses the correlation of the ellipse to determine a position
#' at the top (\eqn{r>=0}) or bottom (\eqn{r<0}) of the ellipse.

#' Integer values of 0, 1, 2, 3 and 4, respectively indicate positions 
#' at the center, below, to the left of, above 
#' and to the right of the max/min coordinates of the ellipse.
#' Label positions can also be specified as the corresponding character strings
#' \code{c("center", "bottom", "left", "top", "right")}.  
#
#' Other integer \code{label.pos} values, \code{5:nrow(ellipse)} are taken as indices of the row coordinates
#' to be used for the ellipse label. 
#' Equivalently, \code{label.pos} can also be a fraction in (0,1), interpreted
#' as the fraction of the way around the unit circle, counterclockwise from the point (1,0)
#'
#' @param ellipse A two-column matrix of coordinates for the ellipse boundary
#' @param label   Character string to be used as the ellipse label 
#' @param col     Label color
#' @param label.pos  Label position relative to the ellipse.  See details 
#' @param xpd     Should the label be allowed to extend beyond the plot limits?
#' @param tweak   A vector of two lengths used to tweak label positions
#' @param ...     Other parameters passed to \code{text}
#' 
#' @author Michael Friendly
#' @examples 
#' circle <- function(center=c(0,0), radius=1, segments=60) {
#'    angles <- (0:segments)*2*pi/segments
#'    circle <- radius * cbind( cos(angles), sin(angles))
#'    t( c(center) + t( circle ))
#' }
#' 
#' plot(-2:2, -2:2, type="n", asp=1)
#' circ <- circle(radius=1.8)
#' lines(circ, col="gray")
#' points(0, 0, pch="+", cex=2)
#' labs <- c("C", "bot", "left", "top", "right")
#' for (i in 0:4) {
#'   label.ellipse(circ, label=paste(i, ":", labs[i+1]), label.pos = i)
#' }





label.ellipse <- function(ellipse, label, col="black", 
				label.pos=NULL, xpd=TRUE, 
				tweak=0.5*c(strwidth("M"), strheight("M")), ...){
		
	ellipse <- as.matrix(ellipse)
	if (ncol(ellipse)<2) stop("ellipse must be a 2-column matrix")

	if (is.null(label.pos)) {
		r = cor(ellipse, use="complete.obs")[1,2]
		label.pos <- if (r>0) 3 else 1
	}

	#		index <- if (1:4 %% 2) ... 

	posn <- c("center", "bottom", "left", "top", "right")
	if (is.character(label.pos)) label.pos <- pmatch(label.pos, posn, nomatch=3)-1
	pos <- label.pos

	if (label.pos==1) {   # bottom
			index <- which.min(ellipse[,2])
			x <- ellipse[index, 1]
			y <- ellipse[index, 2] + tweak[2]
			}
	else if (label.pos==2) {   # left
			index <- which.min(ellipse[,1])
			x <- ellipse[index, 1] + tweak[1]
			y <- ellipse[index, 2]
			}
	else if (label.pos==3) {   # top
			index <- which.max(ellipse[,2])
			x <- ellipse[index, 1] 
			y <- ellipse[index, 2] - tweak[2]
			}
	else if (label.pos==4) {   # right
			index <- which.max(ellipse[,1])
			x <- ellipse[index, 1] - tweak[1]
			y <- ellipse[index, 2]
			}
	else if (label.pos==0) {   # center
			x <- mean(ellipse[, 1])
			y <- mean(ellipse[, 2]) - tweak[2]
			pos <-3
    	}
	else  {  # use as index into ellipse coords
	  if (0 < label.pos & label.pos < 1) 
	    label.pos <- floor(label.pos * nrow(ellipse))
	  index <- max(1, min(label.pos, nrow(ellipse)))
	  x <- ellipse[index, 1]
	  y <- ellipse[index, 2]
	  pos <- 4 - floor(4*(index-1)/nrow(ellipse))
	}
	
	text(x, y, label, pos=pos, xpd=xpd, col=col, ...)
}

