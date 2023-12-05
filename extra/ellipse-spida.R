#' Augmented ellipse
#'
#' Generates an ellipse augmented with conjugate axes and tangents
#'
#'
#' ellplus can produce, in addition to the points of an ellipse, the
#' conjugate axes corresponding to a chol or other decomposition
#' and the surrounding parallelogram.
#'
#' @param center (default: c(0,0))
#' @param shape (default: diag(2)) 'variance' corresponding to shape of ellipse
#'        if taken as a concentration ellipse for a bivariate normal
#' @param radius (default: 1)
#' @param n (default: 100) number of points generated
#' @param angles (default (0:n)*2*pi/n) at which points are generated. The angles
#'        refer to the generating circle that is then transformed linearly to
#'        form the ellipse
#' @param fac (default: chol) method use to factor 'shape'
#' @param ellipse (default: all) if TRUE generate ellipse
#' @param diameters (default: all) if TRUE generate diameters
#' @param box (default: all) if TRUE generate tangent box
#' @param all (default: FALSE)
#' @describeIn ell tangents and axes
#' @export
ellplus <- function ( center = rep(0,2), shape = diag(2), radius = 1, n = 100,
                      angles = (0:n)*2*pi/n,
                      fac = chol,
                      ellipse = all,
                      diameters = all,
                      box = all,
                      all = FALSE) {
  rbindna <- function(x,...) {
    if ( nargs() == 0) return(NULL)
    if ( nargs() == 1) return(x)
    rbind( x, NA, rbindna(...))
  }
  if( missing(ellipse) && missing(diameters) && missing(box)) all <- TRUE
  circle <- function( angle) cbind( cos(angle), sin(angle))
  Tr <- fac(shape)
  ret <- list (
    t( c(center) + t( radius * circle( angles) %*% Tr)),
    t( c(center) + t( radius * circle( c(0,pi)) %*% Tr)),
    t( c(center) + t( radius * circle( c(pi/2,3*pi/2)) %*% Tr)),
    t( c(center) + t( radius * rbind( c(1,1), c(-1,1),c(-1,-1), c(1,-1),c(1,1)) %*% Tr)))
  do.call( 'rbindna', ret[c(ellipse, diameters, diameters, box)])
}
#' @param x,y data values
#' @param \dots arguments passed to \code{ellplus}
#' @describeIn ell data ellipse with tangents and axes
#' @export
dellplus <- function( x, y,  ...) {
  if ( (is.matrix(x) && (ncol(x) > 1))|| is.data.frame(x)) mat <- as.matrix(x[,1:2])
  else if (is.list(x)) mat <- cbind(x$x, x$y)
  else mat <- cbind( x,y)
  ellplus( apply(mat,2,mean), var(mat), ...)
}
#' Calculate coordinates of an ellipse
#'
#' \code{ell} is a utility function used to calculate the (X, Y) coordinates of
#' a 2D ellipse for the purpose of drawing statistical diagrams and plots.
#'
#' \code{\link{ellplus}} can produce, in addition, the
#' conjugate axes corresponding to a \code{\link{chol}} or other decomposition and the
#' surrounding parallelogram defined by these axes.
#'
#' Add function that works with direction to compute slices and conjugate directions.
#'
#' @param center X,Y location of the center of the ellipse
#' @param shape A 2x2 matrix, typically a covariance matrix of data (for a data
#' ellipse), or a covariance matrix of estimated parameters in a model (for a
#' confidence ellipse).
#' @param radius Radius of the ellipse-generating unit circle.  The default,
#' \code{radius=1} corresponds to a "standard" ellipse.
#' @param n Number of points on the unit circle used to calculate the ellipse
#' @param angles Angles around the unit circle used to calculate the ellipse
#' @param fac A function defining the conjugate axes used to transform the unit
#' circle into an ellipse.  The default, \code{\link{chol}}, uses the right Cholesky
#' factor of \code{shape}.
#' @param ellipse Logical to indicate if the points on the ellipse should be
#' returned
#' @param diameters Logical to indicate if the points defining the ends of the
#' conjugate axes of the ellipse should be returned
#' @param box Logical to indicate if the points on the conjugate-axes bounding
#' box should be returned
#' @param all Logical to request all of \code{ellipse}, \code{diameters} and
#' \code{box}. If \code{FALSE}, only the components specified separately by
#' \code{ellipse}, \code{diameters} and \code{box} are returned.
#' @return Returns a 2-column matrix of (X,Y) coordinates suitable for drawing
#' with \code{lines()}.
#'
#' For \code{ellplus}, when more than one of the options \code{ellipse},
#' \code{diameters}, and \code{box} is \code{TRUE}, the different parts are
#' separated by a row of \code{NA}.
#' @author Georges Monette
#' @seealso \code{\link{cell}}, \code{\link{dell}}, \code{\link{dellplus}},
#' @keywords dplot aplot
#' @examples
#' plot( x=0,y=0, xlim = c(-3,3), ylim = c(-3,3),
#'       xlab = '', ylab = '', type = 'n', asp=1)
#' abline( v=0, col="gray")
#' abline( h=0, col="gray")
#' A <- cbind( c(1,2), c(1.5,1))
#' W <- A %*% t(A)
#'
#' lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)
#' lines( ellplus(center=c(0,0), shape = W, box=TRUE, diameters=TRUE ), col = 'red')
#'
#' # show conjugate axes for PCA factorization
#' pca.fac <- function(x) {
#'     xx <- svd(x)
#'     ret <- t(xx$v) * sqrt(pmax( xx$d,0))
#'     ret
#' }
#'
#' plot( x=0,y=0, xlim = c(-3,3), ylim = c(-3,3),
#'       xlab = '', ylab = '', type = 'n', asp=1)
#' abline( v=0, col="gray")
#' abline( h=0, col="gray")
#' lines( ell(center=c(0,0), shape = W ), col = 'blue', lwd=3)
#' lines( ellplus(center=c(0,0), shape = W, box=TRUE, diameters=TRUE, fac=pca.fac ), col = 'red')
#' @export
ell <- function( center = rep(0,2) , shape = diag(2), radius  = 1, n =100) {
  fac <- function( x )  {
    # fac(M) is a 'right factor' of a positive semidefinite M
    # i.e. M = t( fac(M) ) %*% fac(M)
    # similar to chol(M) but does not require M to be PD.
    xx <- svd(x,nu=0)
    t(xx$v) * sqrt(pmax( xx$d,0))
  }
  angles = (0:n) * 2 * pi/n
  if ( length(radius) > 1) {
    ret <- lapply( radius, function(r) rbind(r*cbind( cos(angles), sin(angles)),NA))
    circle <- do.call( rbind, ret)
  }
  else circle = radius * cbind( cos(angles), sin(angles))
  ret <- t( c(center) + t( circle %*% fac(shape)))
  attr(ret,"parms") <- list ( center = rbind( center), shape = shape, radius = radius)
  class(ret) <- "ell"
  ret
}

#' Confidence ellipse
#'
#' Confidence ellipse for two parameters of a fitted object
#'
#' @param x fitted object
#' @param \dots other arguments passed to method
#' @export
cell <- function(x, ... )  UseMethod("cell")
#' @param which.coef (default 1:2) which parameters to estimate
#' @param levels (default 0.95)
#' @param Sheffe logical (default FALSE)
#' @param dfn (default 2) degrees of freedom for Sheffe multiple test and confidence limits
#' @describeIn cell method for wald object
#' @export
cell.wald <-
  function (obj, which.coef = 1:2, levels = 0.95, Scheffe = FALSE, dfn = 2,
            center.pch = 19, center.cex = 1.5, segments = 51, xlab, ylab,
            las = par("las"), col = palette()[2], lwd = 2, lty = 1,
            add = FALSE, ...)
  {

    # BUGS: works only on first element of glh list
    # glh should be restructured to have two classes: waldList and wald

    obj <- obj[[1]]
    coef <- obj$coef[which.coef]
    xlab <- if (missing(xlab))
      paste(names(coef)[1], "coefficient")
    ylab <- if (missing(ylab))
      paste(names(coef)[2], "coefficient")

    dfd <- obj$anova$denDF
    shape <- obj$vcov[which.coef, which.coef]
    ret <- ell( coef, shape , sqrt( dfn * qf( levels, dfn, dfd)))
    colnames(ret) <- c(xlab, ylab)
    ret
  }
#' @describeIn cell default method
#' @export
cell.default <-
  function (model, which.coef, levels = 0.95, Scheffe = FALSE, dfn = 2,
            center.pch = 19, center.cex = 1.5, segments = 51, xlab, ylab,
            las = par("las"), col = palette()[2], lwd = 2, lty = 1,
            add = FALSE, ...)
  {

    #require(car)
    which.coef <- if (length(coefficients(model)) == 2)
      c(1, 2)
    else {
      if (missing(which.coef)) {
        if (any(names(coefficients(model)) == "(Intercept)"))
          c(2, 3)
        else c(1, 2)
      }
      else which.coef
    }
    coef <- coefficients(model)[which.coef]
    xlab <- if (missing(xlab))
      paste(names(coef)[1], "coefficient")
    ylab <- if (missing(ylab))
      paste(names(coef)[2], "coefficient")
    if(missing(dfn)) {
      dfn <- if (Scheffe) sum(df.terms(model)) else 2
    }
    dfd <- df.residual(model)
    shape <- vcov(model)[which.coef, which.coef]
    ret <- numeric(0)

    ret <- ell( coef, shape,sqrt(dfn * qf(levels, dfn, dfd)))
    colnames(ret) <- c(xlab, ylab)
    ret
  }
