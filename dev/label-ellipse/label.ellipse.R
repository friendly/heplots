# Dev version of label.ellipse
# 
# TODO: Generalize the `label.pos` argument to accept, in addition to values `0:4` and corresponding compass directions, N, S, E, W values:
#   * `NE`, `SE`, `SW`, `NW` to mean at circular angles 45, 135, 225, 315


#'  Label an ellipse
#'
#' @description 
#'  \code{label.ellipse} is used to a draw text label on an ellipse at its center or
#'  somewhere around the periphery in a very flexible way. It is used in \code{link{heplot}}, \code{link{covEllipses}}, and
#'  \code{link{coefplot.mlm}}, but is also useful as a utility when plotting ellipses in base R graphics.
#'  }
#'
#' @details 
#' If \code{label.pos=NULL}, the function uses the sign of the correlation \eqn{r}
#' represented by the ellipse to determine a position
#' at the "top" (\eqn{r>=0}) or "bottom" (\eqn{r<0}) of the ellipse.

#' Integer values of 0, 1, 2, 3 and 4, respectively indicate positions 
#' at the center, below, to the left of, above 
#' and to the right of the max/min coordinates of the `ellipse`.
#' Label positions can also be specified as the corresponding character strings
#' \code{c("center", "bottom", "left", "top", "right")}, or compass directions, 
#' \code{c("C", "S", "W", "N", "E")}. Additionally, diagonal compass directions
#' \code{c("NE", "SE", "SW", "NW")} can be used, corresponding to angles 45, 135, 225, 
#' and 315 degrees, respectively.
#'
#' # TODO: DELETE THIS -- too hard to use in terms of figuring out the indices of the rows of the ellipse
#' Other integer \code{label.pos} values, \code{5:nrow(ellipse)} are taken as indices of the row coordinates
#' to be used for the ellipse label. 
#' 
#' Equivalently, \code{label.pos} can also be a \emph{fraction} in (0,1), interpreted
#' as the fraction of the way around the unit circle, counterclockwise from the point (1,0).
#'
#' @param ellipse A two-column matrix of coordinates for the ellipse boundary
#' @param label   Character string to be used as the ellipse label 
#' @param col     Label color
#' @param label.pos  Label position relative to the ellipse.  See details 
#' @param xpd     Should the label be allowed to extend beyond the plot limits?
#' @param tweak   A vector of two lengths used to tweak label positions. The defaults are 0.5 times the height and width of the character \code{"M"} added
#'                or subtracted to the calculated (x, y) values.
#' @param ...     Other parameters passed to \code{text}, e.g., \code{cex}, \dots
#' 
#' @author Michael Friendly
#' @export
#' @seealso \code{\link{heplot}}
#' @examples 
#' circle <- function(center=c(0,0), radius=1, segments=60) {
#'    angles <- (0:segments)*2*pi/segments
#'    circle <- radius * cbind( cos(angles), sin(angles))
#'    t( c(center) + t( circle ))
#' }
#' 
#' label_demo <- function(ell, show = c("pos", "compass")) {
#'   plot(-2:2, -2:2, type="n", asp=1, main="label.pos values and points (0:60)")
#'   lines(ell, col="gray")
#'   points(0, 0, pch="+", cex=2)
#'   
#'   if ("pos" %in% show) {
#'     labs <- c("center", "bot", "left", "top", "right")
#'     for (i in 0:4) {
#'     label.ellipse(ell, label=paste(i, ":", labs[i+1]), label.pos = i)
#'     }
#'   }
#'   if ("compass" %in% show) {
#'     labs <- c("S", "W", "N", "E")
#'     for (i in 1:4) {
#'       label.ellipse(ell, label=labs[i], 
#'                     label.pos = c(1, 4, 2, 1)[i],
#'                     color = "red")
#'     }
#'   }
#'   
#'   # for( i in 6*c(1,2, 4,5, 7,8, 10,11)) {
#'   #  points(ell[i,1], ell[i,2], pch=16)
#'   #  label.ellipse(ell, label=i, label.pos=i)
#'   #}
#' }
#' 
#' circ <- circle(radius=1.8)
#' label_demo(circ)
#' 
#' # also show:
#' labs <- c("NE", "NW", "SW", "SE")
#'   for (i in 1:4) {
#'      label.ellipse(ell, label=labs[i], label.pos = labs[i], col = "blue")
#'       }
#'
#' 
#' ell <-circ %*% chol(matrix( c(1, .5, .5, 1), 2, 2)) 
#' label_demo(ell)

#' @export label.ellipse
label.ellipse <- function(
    ellipse, 
    label, 
    col="black", 
		label.pos=NULL, 
		xpd=TRUE, 
		tweak=0.5*c(strwidth("M"), strheight("M")), ...){
		
	ellipse <- as.matrix(ellipse)
	if (ncol(ellipse) < 2) stop("ellipse must be a 2-column matrix")

	if (is.null(label.pos)) {
	  r = cor(ellipse, use="complete.obs")[1,2]
	  label.pos <- if (r>0) 3 else 1
	}
	else if(length(label.pos) > 1) {
	  warning("label.pos = ", paste(label.pos, collapse=", "), " has length ", length(label.pos), " only 1st used." )
	  label.pos <- label.pos[1]    # only use 1st if > 1
	}
	

  # Define diagonal compass positions and their corresponding angular fractions
	post <- c("NE", "SE", "SW", "NW")
	numt <- c(45, 135, 225, 315) / 360  # Convert degrees to fraction of circle
	
  # translate nmemonics to standard numerical text positions 1:4,
	posn <- c("center", "bottom", "left", "top", "right")
	poss <- c("C",      "S",      "W",    "N",   "E")
	
	# Handle character input
	if (is.character(label.pos)) {
	  if (label.pos %in% posn) label.pos <- pmatch(label.pos, posn, nomatch=3) - 1
	  else if (label.pos %in% poss) label.pos <- pmatch(label.pos, poss, nomatch=3) - 1
	  else if (label.pos %in% post) {
	    # Convert diagonal compass to fractional position
	    idx <- pmatch(label.pos, post, nomatch=1)
	    label.pos <- numt[idx]
	  }
	}
	
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
	else  {  # use as fraction of circle or index into ellipse coords
	  if (0 < label.pos & label.pos < 1) {
	    # label.pos is a fraction of the way around the circle
	    # Find the ellipse center
	    center_x <- mean(ellipse[, 1])
	    center_y <- mean(ellipse[, 2])
	    
	    # Calculate target angle (in radians, counterclockwise from (1,0))
	    # Convert to range [-pi, pi] to match atan2 output
	    target_angle <- 2 * pi * label.pos
	    if (target_angle > pi) target_angle <- target_angle - 2*pi
	    
	    # Calculate angles for all points on the ellipse relative to center
	    angles <- atan2(ellipse[, 2] - center_y, ellipse[, 1] - center_x)
	    
	    # Find the point with angle closest to target angle
	    # Need to handle angle wrapping (angles are in [-pi, pi])
	    angle_diff <- abs(angles - target_angle)
	    angle_diff <- pmin(angle_diff, 2*pi - angle_diff)  # Handle wrapping
	    index <- which.min(angle_diff)
	    
	    # Get coordinates at this index
	    x <- ellipse[index, 1]
	    y <- ellipse[index, 2]
	    
	    # Determine text position based on angle
	    # pos=1 (below), 2 (left), 3 (above), 4 (right)
	    pos <- if (angles[index] >= -pi/4 & angles[index] < pi/4) 4       # right
	           else if (angles[index] >= pi/4 & angles[index] < 3*pi/4) 3  # above
	           else if (angles[index] >= 3*pi/4 | angles[index] < -3*pi/4) 2  # left
	           else 1  # below
	  }
	  else {
	    # Use as index into ellipse coords (legacy behavior)
	    index <- max(1, min(label.pos, nrow(ellipse)))
	    x <- ellipse[index, 1]
	    y <- ellipse[index, 2]
	    pos <- 4 - floor(4*(index-1)/nrow(ellipse))
	  }
	}
	
	text(x, y, label, pos=pos, xpd=xpd, col=col, ...)
}
