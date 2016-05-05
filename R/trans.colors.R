# make transparent colors, suitable for filling areas
# alpha transparency: (0 means fully transparent and 1 means opaque).
# names: optional character vector of names for the colors



#' Make Colors Transparent
#' 
#' Takes a vector of colors (as color names or rgb hex values) and adds a
#' specified alpha transparency to each.
#' 
#' Colors (\code{col}) and \code{alpha} need not be of the same length. The
#' shorter one is replicated to make them of the same length.
#' 
#' @param col A character vector of colors, either as color names or rgb hex
#' values
#' @param alpha alpha transparency value(s) to apply to each color (0 means
#' fully transparent and 1 means opaque)
#' @param names optional character vector of names for the colors
#' @return A vector of color values of the form \code{"#rrggbbaa"}
#' @author Michael Friendly
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' \code{\link[grDevices]{col2rgb}}, \code{\link[grDevices]{rgb}},
#' \code{\link[grDevices]{adjustcolor}},
#' @keywords color
#' @examples
#' 
#' trans.colors(palette(), alpha=0.5)
#' 
#' # alpha can be vectorized
#' trans.colors(palette(), alpha=seq(0, 1, length=length(palette())))
#' 
#' # lengths need not match: shorter one is repeated as necessary
#' trans.colors(palette(), alpha=c(.1, .2))
#' 
#' trans.colors(colors()[1:20])
#' 
#' # single color, with various alphas
#' trans.colors("red", alpha=seq(0,1, length=5))
#' # assign names
#' trans.colors("red", alpha=seq(0,1, length=5), names=paste("red", 1:5, sep=""))
#' 
#' 
trans.colors <- function(col, alpha=0.5, names=NULL) {
  nc <- length(col)
  na <- length(alpha)
  # make lengths conform, filling out to the longest
  if (nc != na) {
  	col <- rep(col, length.out=max(nc,na))
  	alpha <- rep(alpha, length.out=max(nc,na))
  	}
  clr <-rbind(col2rgb(col)/255, alpha=alpha)
  col <- rgb(clr[1,], clr[2,], clr[3,], clr[4,], names=names)
  col
}
 
