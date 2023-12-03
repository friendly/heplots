#' Draw axes of a 3D ellipsoid
#' 
#' A function to draw the major axes of a 2D ellipse from a correlation,
#' covariance or sums of squares and cross products matrix.
#' 
#' 
#'
#' @param x A square positive definite matrix at least 3x3 in size.  It will be
#'          treated as the correlation or covariance of a multivariate normal
#'          distribution.
#' @param centre,center The center of the ellipse
#' @param scale If x is a correlation matrix, then the standard deviations of
#'          each parameter can be given in the scale parameter.  This defaults to
#'          \code{c(1, 1, 1)}, so no rescaling will be done.
#' @param level The coverage level of a simultaneous region.  The
#'          default is 0.95, for a 95\% region.  This is used to control the size of the
#'          ellipsoid.
#' @param t The size of the ellipsoid may also be controlled by specifying the
#'          value of a t-statistic on its boundary, which defaults to the square root of a chi-square statistic
#'          for a given \code{level} on 3 degrees of freedom.
#' @param which An integer vector to select which variables from the object will be
#'          plotted.  The default is the first 2.
#' @param labels Either a logical value, a character string, or a character
#'          vector of length 2.  If \code{TRUE}, the default, the axes are labeled PC1,
#'          PC2.  If a single character string, the digits 1, and 2 are pasted on
#'          the end.
#' @param label.ends 
#' @param label.pos 
#' @param ... 
#'
#' @return Invisibly returns the end points of the axes
#' @export
#'
#' @examples
#' # None yet
ellipse.axes <- function(
    x, 
    centre = c(0, 0), 
    center = center,
    scale = c(1, 1), 
    level = 0.95,
    t = sqrt(qchisq(level, 2)), 
    which = 1:2, 
    labels = TRUE, 
    label.ends = c(2, 4),
    label.pos = c(4, 2, 3, 1),...) 
{
  stopifnot(is.matrix(x)) 
  stopifnot(dim(x)[1] ==  dim(x)[2])  # square matrix?
  
  cov <- x[which, which]
  eig <- eigen(cov)

  # coordinate axes, (-1, 1), in pairs, for X, Y,
  axes <- matrix(
    c(-1, 0,
       1, 0,
       0, -1,
       0, 1), nrow = 4, ncol = 2, byrow = TRUE)
  rownames(axes)<- apply(expand.grid(c("min","max"),c("X","Y"))[,2:1],
                         1, paste, collapse="")
#  colnames(axes) <- colnames(cov)

  # transform to PC axes
  result <- axes %*% sqrt(diag(eig$values)) %*% t(eig$vectors)
  # scale
  result <- result %*% diag(rep(t, 2))
  # center at values of centre
  result <- sweep(result, 2L, centre, FUN="+")
  colnames(result) <- colnames(cov)

  # convert to something that can be used by lines()
  #result <- rbind(result[1:2,], NA, result[3:4,])

  # draw the lines, inserting NA between each pair
  lines(rbind(result[1:2,], NA, result[3:4,]), ...)

  if (!missing(labels)) {
    if (is.logical(labels) & labels) labels <- paste("PC", 1:2, sep="")
    if (length(labels)==1) labels <- paste(labels, 1:2, sep="")
    text(result[label.ends,], labels=labels, pos=label.pos[label.ends], ...)
  }
  invisible(result)

}

data(iris)
cov <- cov(iris[,1:2])
mu <- colMeans(iris[,1:2])

radius <- sqrt(qchisq(0.68, 2))
plot(iris[,1:2])
car::ellipse(mu, cov, radius = radius)
# res <- ellipse.axes(cov, centre=mu, level = 0.68)
# lines(res, lwd = 2)

res <- ellipse.axes(cov, centre=mu, level = 0.68,
                    labels = TRUE)

plot(iris[,1:2])
car::ellipse(mu, cov, radius = radius)
res <- ellipse.axes(cov, centre=mu, level = 0.68,
                    labels = TRUE, label.ends = 1:4)
