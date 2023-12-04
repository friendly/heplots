#' Draw Axes of a 2D Covariance Ellipse
#' 
#' A function to draw the major axes of a 2D ellipse from a correlation,
#' covariance or sums of squares and cross products matrix in an existing plot.
#' 
#' 
#'
#' @param x A square positive definite matrix at least 2x2 in size.  It will be
#'          treated as the correlation or covariance of a multivariate normal
#'          distribution.
#' @param centre,center The center of the ellipse
#' @param scale If x is a correlation matrix, then the standard deviations of
#'          each parameter can be given in the scale parameter.  This defaults to
#'          \code{c(1, 1)}, so no rescaling will be done.
#' @param level The coverage level of a simultaneous region.  The
#'          default is 0.95, for a 95\% region.  This is used to control the size of the
#'          ellipsoid.
#' @param t The size of the ellipsoid may also be controlled by specifying the
#'          value of a t-statistic on its boundary, which defaults to the square root of a chi-square statistic
#'          for a given \code{level} on 2 degrees of freedom.
#' @param which An integer vector to select which variables from the object \code{x} will be
#'          plotted.  The default is the first 2.
#' @param labels Either a logical value, a character string, or a character
#'          vector of length 2.  If \code{TRUE}, the default, the axes are labeled PC1,
#'          PC2.  If a single character string, the digits 1, and 2 are pasted on
#'          the end.
#' @param label.ends A vector of indices in the range \code{1:4} indicating which ends of the axes
#'          should be labeled, corresponding to a selection of rows of the 4 x 2 matrix
#'          of axes end points. Values \code{1:2} represent the minimum and maximum of the first dimension respectivly.
#'          Values \code{3:4} represent the minimum and maximum of the second dimension.
#'          Default: \code{c(2, 4)}.
#' @param label.pos Positions of text labels relative to the ends of the axes used in \code{\link[graphics]{text}} for
#'          the four possible \code{label.ends}. 1, 2, 3, 4 represent below, to the left, above and to the right.
#'          Default: \code{c(4, 2, 3, 1)}.
#' @param \dots Other arguments passed to \code{lines} and \code{text}.
#'
#' @return Invisibly returns a 4 x 2 matrix containing the end points of the axes in pairs (min, max) by rows.
#' @author Michael Friendly
#' @seealso \code{\link[graphics]{lines}}, \code{\link[graphics]{text}}
#' @export
#'
#' @examples
#' data(iris)
#' cov <- cov(iris[,1:2])
#' mu <- colMeans(iris[,1:2])
#' 
#' radius <- sqrt(qchisq(0.68, 2))
#' plot(iris[,1:2])
#' car::ellipse(mu, cov, radius = radius)
#' # there's a bug here: labels appear at min of PC1 & PC2
#' res <- ellipse.axes(cov, centre=mu, level = 0.68,
#'             labels = TRUE)
#' res


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
    label.pos = c(4, 2, 3, 1),
    ...) 
{
  stopifnot(is.matrix(x)) 
  stopifnot(dim(x)[1] ==  dim(x)[2])  # square matrix?

  if(length(which) != 2)  stop("`which` must be a vector of length 2, not", which)
  cov <- x[which, which]
  eig <- eigen(cov)

  # coordinate axes, (-1, 1), in pairs, for X, Y,
  axes <- matrix(
    c(-1, 0,
       1, 0,
       0, -1,
       0, 1), nrow = 4, ncol = 2, byrow = TRUE)
  rownames(axes)<- apply(expand.grid(c("X","Y"), c("min","max")),
                         1, paste, collapse="")

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
    labels <- rep(labels, each = 2)
    text(result[label.ends,], 
         labels=labels[label.ends], 
         pos=label.pos[label.ends], ...)
  }
  invisible(result)

}

if(FALSE){
# data(iris)
# cov <- cov(iris[,1:2])
# mu <- colMeans(iris[,1:2])
# 
radius <- sqrt(qchisq(0.68, 2))
plot(iris[,1:2])
car::ellipse(mu, cov, radius = radius)
res <- ellipse.axes(cov, centre=mu, level = 0.68,
                    labels = TRUE, 
                    lwd = 2, col = "red", cex = 1.2)

# try using arrows
arrows(mu[1], mu[2], x1 = res[,1], y1 = res[,2], angle = 15)

plot(iris[,1:2])
car::ellipse(mu, cov, radius = radius)
res <- ellipse.axes(cov, centre=mu, level = 0.68,
                    labels = TRUE, label.ends = 1:4)
}