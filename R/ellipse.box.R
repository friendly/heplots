#' Draw Conjugate Axes and Parallelogram Surrounding a Covariance Ellipse
#' 
#' @param x A square positive definite matrix at least 2x2 in size.  It will be
#'          treated as the correlation or covariance of a multivariate normal
#'          distribution.
#' @param center The center of the ellipse
#' @param which An integer vector to select which variables from the object \code{x} will be
#'          plotted.  The default is the first 2.
#' @param level The coverage level of a simultaneous region of the ellipse.  The
#'          default is 0.95, for a 95\% region.  This is used to control the size of the
#'          ellipse.
#' @param radius The size of the ellipsoid may also be controlled by specifying the
#'          value of a t-statistic on its boundary. This defaults to the square root of a chi-square statistic
#'          for a given \code{level} on 2 degrees of freedom, however in a small sample of \code{n} observations,
#'          a more accurate value is \code{sqrt(2 * qf(level, 2, n - 1 ))}. 
#' @param factor A function defining the conjugate axes used to transform the unit
#'          circle into an ellipse.  \code{\link{chol}}, uses the right Cholesky
#' factor of \code{x}. 
#' @param draw What to draw? \code{"box"}, \code{"diameters"} or \code{"both"}
#' @param \dots Other arguments passed to \code{\link[graphics]{lines}}.
#'
#' @return Invisibly returns a 2 column matrix containing the end points of lines.
#' @export ellipse.box
#'
#' @examples
#' data(iris)
#' cov <- cov(iris[,3:4])
#' mu <- colMeans(iris[,3:4])
#' 
#' radius <- sqrt(qchisq(0.68, 2))
#' plot(iris[,3:4], asp=1)
#' car::ellipse(mu, cov, radius = radius)
#' ellipse.axes(cov, center=mu, level = 0.68,
#'             labels = TRUE)
#' ellipse.box(cov, center=mu, level = 0.68, 
#'             factor = "pca", 
#'             col = "red", lwd = 2 )
#' 
#' res <- ellipse.box(cov, center=mu, level = 0.68, factor = "chol", col = "green", lwd = 2 )
#' res


ellipse.box <- function(
    x, 
    center = c(0, 0), 
    which = 1:2,
    level = 0.95,
    radius = sqrt(qchisq(level, 2)), 
    factor = c("cholesky", "pca"),
    draw = c("box", "diameters", "both"),
    ...)
{
  # local functions
  
  # rbind a list of arguments, separated by NA, for use with lines()
  rbindna <- function(x, ...) {
    if ( nargs() == 0) return(NULL)
    if ( nargs() == 1) return(x)
    rbind( x, NA, rbindna(...))
  }

  # parameterized circle as x,y points
  circle <- function(angle) cbind(cos(angle), sin(angle))
  
  pca.fac <- function( x )  {
    # fac(M) is a 'right factor' of a positive semidefinite M
    # i.e. M = t( fac(M) ) %*% fac(M)
    # similar to chol(M) but does not require M to be PD.
    xx <- svd(x,nu=0)
    t(xx$v) * sqrt(pmax( xx$d,0))
  }
  
  
  
  stopifnot(is.matrix(x)) 
  stopifnot(dim(x)[1] ==  dim(x)[2])  # square matrix?
  
  if(length(which) != 2)  stop("`which` must be a vector of length 2, not", which)

  cov <- x[which, which]

  # get the factor to use
  factor <- match.arg(factor)
  fac <- if(factor == "cholesky") chol else pca.fac
  Tr <- fac(cov)
  
  diameters <- rbind (
    t( c(center) + t( radius * circle(c(0, pi)) %*% Tr)),
    NA,
    t( c(center) + t( radius * circle(c(pi/2, 3*pi/2)) %*% Tr) )
  )

  # corners of a bounding box, including the first point at the end to make a path
  corners <- rbind( c(1,1), c(-1,1), c(-1,-1), c(1,-1), c(1,1) )
  box <-  t( c(center) + t( radius * corners %*% Tr) )

  draw <- match.arg(draw)
  result <- switch(draw,
                   box = box,
                   diameters = diameters,
                   both = rbindna(box, diameters))
#  result <- box
  colnames(result) <- colnames(cov)
  lines(result, ...)
  
  invisible(result)
  
}
    