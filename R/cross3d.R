
#' Draw a 3D cross in an rgl scene
#' 
#' Draws a 3D cross or axis vectors in an rgl scene.
#' 
#' 
#' @param centre A scalar or vector of length 3, giving the centre of the 3D
#' cross
#' @param scale A scalar or vector of length 3, giving the lengths of the arms
#' of the 3D cross
#' @param \dots Other arguments, passed on to \code{\link[rgl]{segments3d}}
#' @return Used for its side-effect, but returns (invisibly) a 6 by 3 matrix
#' containing the end-points of three axes, in pairs.
#' @author Michael Friendly
#' @seealso \code{\link[rgl:points3d]{segments3d}}
#' @keywords aplot dynamic

cross3d <- 
function(centre=rep(0,3), scale=rep(1,3), ...) {
    axes <- matrix(
      c(-1, 0, 0,   1, 0, 0,
        0, -1, 0,   0, 1, 0,
        0, 0, -1,   0, 0, 1),  6, 3, byrow=TRUE)
    if (!missing(scale)) {
        if (length(scale) != 3) scale <- rep(scale, length.out=3) 
        axes <- rgl::scale3d(axes, scale[1], scale[2], scale[3])
        }
    if (!missing(centre)) { 
        if (length(centre) != 3) scale <- rep(centre, length.out=3) 
        axes <- rgl::translate3d(axes, centre[1], centre[2], centre[3])
        }
    rgl::segments3d(axes, ...)
    invisible(axes)

}
