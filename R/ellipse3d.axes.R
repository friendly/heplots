# draw axes in the data ellipse computed by ellipse3d


#' Draw axes of a 3D ellipsoid
#' 
#' A function to draw the major axes of a 3D ellipsoid from a correlation,
#' covariance or sums of squares and cross products matrix.
#' 
#' 
#' @param x A square positive definite matrix at least 3x3 in size.  It will be
#'          treated as the correlation or covariance of a multivariate normal
#'          distribution.
#' @param centre,center The center of the ellipse
#' @param scale If x is a correlation matrix, then the standard deviations of
#'          each parameter can be given in the scale parameter.  This defaults to
#'          `c(1, 1, 1)`, so no rescaling will be done.
#' @param level The coverage level of a simultaneous region.  The
#'          default is 0.95, for a 95\% region.  This is used to control the size of the
#'          ellipsoid.
#' @param t The size of the ellipsoid may also be controlled by specifying the
#'          value of a t-statistic on its boundary, which defaults to the square root of a chi-square statistic
#'          for a given `level` on 3 degrees of freedom.
#' @param which An integer vector to select which variables from the object will be
#'          plotted.  The default is the first 3.
#' @param labels Either a logical value, a character string, or a character
#'          vector of length 3.  If `TRUE`, the default, the axes are labeled PC1,
#'          PC2, PC3.  If a single character string, the digits 1, 2, 3 are pasted on
#'          the end.
#' @param label.ends A vector of length 3 indicating which ends of the axes
#'          should be labeled, corresponding to a selection of rows of the 6 x 3 matrix
#'          of axes end points.  Default: `c(2,4,6)`.
#' @param \dots Other arguments passed to `segments3d` and `text3d`.
#' @return Returns a 6 x 3 matrix containing the end points of the three axis
#'         lines in pairs by rows.
#' @author Michael Friendly
#' 
#' @seealso \code{\link[rgl:points3d]{segments3d}},
#' \code{\link[rgl:texts]{text3d}}, \code{\link[rgl]{ellipse3d}}
#' @family covariance ellipses
#' @family 3D plotting
#' @keywords aplot dynamic
#' @examples
#' 
#' data(iris)
#' iris3 <- iris[,1:3]
#' cov <- cov(iris3)
#' mu <- colMeans(iris3)
#' col <-c("blue", "green", "red")[iris$Species]
#' 
#' library(rgl)
#' plot3d(iris3, type="s", size=0.4, col=col, cex=2, box=FALSE, aspect="iso")
#' plot3d( ellipse3d(cov, centre=mu, level=0.68), col="gray", alpha=0.2,  add = TRUE)
#' 
#' axes <- ellipse3d.axes(cov, centre=mu, level=0.68, color="gray", lwd=2)
#' 
#' @export ellipse3d.axes
ellipse3d.axes <- function (
    x, 
    centre = c(0, 0, 0),
    center = centre,
    scale = c(1, 1, 1), 
    level = 0.95,
    t = sqrt(qchisq(level, 3)), 
    which = 1:3, 
    labels=TRUE, 
    label.ends=c(2,4,6), ...) 
{
    stopifnot(is.matrix(x)) 
    stopifnot(dim(x)[1] ==  dim(x)[2])  # square matrix?
    
    cov <- x[which, which]
    eig <- eigen(cov)
    # coordinate axes, (-1, 1), in pairs, for X, Y, Z
    axes <- matrix(
      c(-1, 0, 0,   1, 0, 0,
        0, -1, 0,   0, 1, 0,
        0, 0, -1,   0, 0, 1),  6, 3, byrow=TRUE)
	rownames(axes)<- apply(expand.grid(c("min","max"),c("X","Y","Z"))[,2:1],1,paste,collapse="")

	# transform to PC axes
    axes <- axes %*% sqrt(diag(eig$values)) %*% t(eig$vectors)
    result <- rgl::scale3d(axes, t, t, t)
    if (!missing(scale)) {
        if (length(scale) != 3) scale <- rep(scale, length.out=3) 
        result <- rgl::scale3d(result, scale[1], scale[2], scale[3])
        }
    if (!missing(centre)) {
        if (length(centre) != 3) centre <- rep(centre, length.out=3) 
        result <- rgl::translate3d(result, centre[1], centre[2], centre[3])
        }
    rgl::segments3d(result, ...)
    if (!missing(labels)) {
    	if (is.logical(labels) & labels) labels <- paste("PC", 1:3, sep="")
    	if (length(labels)==1) labels <- paste(labels, 1:3, sep="")
    	rgl::texts3d(result[label.ends,], texts=labels, ...)
    }
    invisible(result)
}
