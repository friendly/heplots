# Find the bounding box of a mesh3d object
# -- taken from gellipsoid package

#' Find the bounding box of a `rgl::mesh3d` or `rgl::qmesh3d` object
#' 
#' Ellipsoids are created by \pkg{rgl} functions as meshes of points, segments, ... from coordinates
#' in various forms. This function calculates the bounding box, defined as the range of the
#' x, y, and z coordinates.
#' 
#' @param x    A mesh3d object
#' @param ...  ignored
#' 
#' @importFrom rgl asEuclidean
#' 
#' @return     A 2 x 3 matrix, giving the minimum and maximum values in the rows and x, y, z coordinates
#'             in the columns.
#'             
#' @family 3D plotting
#' @export
bbox3d <- function(x, ...) {
  if (!inherits(x, "mesh3d"))
    stop(paste("Object", deparse(substitute(x), "must be of class 'mesh3d', not", class(x))))
  
  xyz <- rgl::asEuclidean(t(x$vb))
  mn <- apply(xyz, 2, min)
  mx <- apply(xyz, 2, max)
  res <- rbind("min" = mn, "max" = mx)
  colnames(res) <- c("x", "y", "z")
  res
}
