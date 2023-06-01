# was an internal function in heplot3d
# adapted from the shapes3d demo in the rgl package and from the Rcmdr package
# modified to return the bbox of the ellipsoid

# TODO:
# Handle greater, less than 3D
# Use label.ellipse?

#' Draw an Ellipsoid in an rgl Scene
#'
#' @param x      a 3 x 3 matrix, , typically the covariance matrix of data
#' @param center center of the ellipsoid, a vector of length 3, typically the mean vector of data
#' @param which  selects which variables from the object will be plotted. The default is the first 3.
#' @param radius size of the ellipsoid
#' @param df     degrees of freedom associated with the covariance matrix, used to calculate the appropriate F statistic
#' @param label  label for the ellipsoid
#' @param cex.label text size of label
#' @param col    color of the ellipsoid
#' @param lwd    line with for the wire-frame version
#' @param segments number of segments composing each ellipsoid; defaults to \code{40}.
#' @param shade  logical; should the ellipsoid be smoothly shaded?
#' @param alpha  transparency of the shaded ellipsoid
#' @param wire   logical; should the ellipsoid be drawn as a wire frame?
#' @param verbose logical; for debugging
#' @param warn.rank logical; warn if the ellipsoid is less than rank 3?
#' @param ...
#'
#' @return returns the bounding box of the ellipsoid invisibly; otherwise used for it's side effect of
#'         drawing the ellipsoid
#' @export
#'
#' @examples

Ellipsoid <-
  function(x, ...) UseMethod("Ellipsoid")

#' @param method  the covariance method to be used: classical product-moment (\code{"classical"}), 
#'        or minimum volume ellipsoid (\code{"mve"}), or 
#'        minimum covariance determinant (\code{"mcd"}
        
Ellipsoid.data.frame <- function(
    x,
    which = 1:3,
    method = c("classical", "mve", "mcd"),
    ...) {
  
  method <- match.arg(method)
  
  if (length(which) != 3L) stop("'which' must be a vector of length 3, not ", which)
  if (any(which) > ncol(x) |
      any(which) < 0)  stop("unavailable variables selected in ", which) 
  x <- x[, which]
  if (nrow(x) < 4) stop("at least 4 cases are needed")
  
  rcov <- MASS::cov.rob(x, method=method)
  cov  <- rcov$cov
  means<- rcov$center
  
  Ellipsoid.default(cov, center = means, ...)
  
}

# Ellipsoid.matrix <- Ellipsoid.data.frame


Ellipsoid.default <- function(
    x, 
    center = c(0,0,0), 
    which = 1:3,
    radius = 1, 
    df = Inf, 
    label = "",
    cex.label = 1.5,
    col = "pink", 
    lwd = 1,
    segments = 40,          # line segments in each ellipse
    shade = TRUE, 
    alpha = 0.1, 
    wire = TRUE,
    verbose = FALSE,
    warn.rank = FALSE,
    ...
){

  degvec <- seq(0, 2*pi, length=segments)
  ecoord2 <- function(p) c(cos(p[1])*sin(p[2]), sin(p[1])*sin(p[2]), cos(p[2]))

  # v <- t(apply(expand.grid(degvec,degvec), 1, ecoord2))  # modified to make smoother
  v <- t(apply(expand.grid(degvec,degvec/2), 1, ecoord2)) 
  if (!warn.rank){
    warn <- options(warn=-1)
    on.exit(options(warn))
  }

  dimx <- dim(x)
  if (!length(dimx) == 2 & dimx[1] == dimx[2]) stop("'x' must be a square matrix")
  if (length(which) != 3) stop("'which' must be a vector of length 3, not ", which)
  if (any(which) > dimx[1]) stop("unavailable variables selected in ", which) 
  x <- x[which, which]
  shape <- x
  # TODO: select which
  
  Q <- chol(shape, pivot=TRUE)
  lwd <- if (df < 2) lwd[2] else lwd[1]
  order <- order(attr(Q, "pivot"))

  v <- center + radius * t(v %*% Q[, order])
  v <- rbind(v, rep(1,ncol(v))) 
  e <- expand.grid(1:(segments-1), 1:segments)
  i1 <- apply(e, 1, function(z) z[1] + segments*(z[2] - 1))
  i2 <- i1 + 1
  i3 <- (i1 + segments - 1) %% segments^2 + 1
  i4 <- (i2 + segments - 1) %% segments^2 + 1
  i <- rbind(i1, i2, i4, i3)
  x <- rgl::asEuclidean(t(v))
  ellips <- rgl::qmesh3d(v, i)

  # override settings for 1 df line
  if (df<2) {
    wire <- TRUE
    shade <- FALSE
  }
  back <- if (df < 3) "culled" else "filled"
  depth_mask <- if (alpha <.8) FALSE else TRUE
  if (verbose) cat(paste("df=", df, "col:", col, " shade:", shade, " alpha:", alpha, 
                         " wire:", wire, "back:", back, "depth_mask:", depth_mask,
                         sep=" "), "\n")
  if(shade) rgl::shade3d(ellips, 
                         col=col, alpha=alpha, lit=TRUE, back=back, depth_mask=depth_mask)
  if(wire) rgl::wire3d(ellips, 
                       col=col, size=lwd, lit=FALSE, back=back, depth_mask=depth_mask)

  # get bounding box of object
  bbox <- matrix(rgl::par3d("bbox"), nrow=2)
  ranges <- apply(bbox, 2, diff)
  if (!is.null(label) && label !="")
    rgl::texts3d(x[which.max(x[,2]),] + offset*ranges, adj=0, texts=label, color=col, lit=FALSE)

  rownames(bbox) <- c("min", "max")
  colnames(bbox) <- names(center)
  invisible(bbox)
}

