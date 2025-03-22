# Find noteworthy points in a 2D scatterplot

#' Find noteworthy points in a 2D scatterplot
#' 
#' This function, loosely modeled on what is done in `car::showLabels` is designed as a helper function
#' for selectively labeling unusual ("noteworthy") points in a scatterplot.
#' 
#' @details
#' The `method` argument allows different ways to select the points
#' 
#' \itemize{
#'  \item{\code{method = "x"} select points according to their value of \code{abs(x - mean(x))}}
#'  \item{\code{method = "y"} select points according to their value of \code{abs(y - mean(y))}}
#'  \item{\code{method = "r"} select points according to their value of \code{abs(y}, as may be appropriate in residual plots, or others with a meaningful origin at 0}
#'  \item{\code{method = "dsq"} and \code{method = "mahal"} Treat (x, y) as if it were a bivariate sample, and select cases according to their Mahalanobis distance from \code{(mean(x), mean(y))}
#' }
#' 
#'
#' @param x X value
#' @param y Y value
#' @param n Maximum number of points to identify
#' @param method One of \code{c("dsq", "mahal", "x", "y", "r", "qx", "qy")} 
#' @param level If not \code{NULL} (the default), for the \code{"dsq", "mahal"} and \code{"qx", "qy"} methods, this specifies the cumulative probability value
#'        used to limit the number of points selected
#'
#' @return A vector of case id numbers for the selected points
#' @export
#'
#' @examples
#' set.seed(47)
#' x <- c(runif(100), 1.5, 1.6)
#' y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6 )
#' plot(x, y)
#' abline(lm(y ~ x))
#' noteworthy(x, y, n=5, method = "mahal")
#' noteworthy(x, y, n=5, method = "x")


noteworthy <- function(x, y, 
                       n,
                       method = "mahal",
                       level = NULL){

#  method <- match.arg(method)
  method <- pmatch(method, c("dsq", "mahal", "x", "y", "r", "qx", "qy"))
  
  id.criterion <- switch(method,
    'mahal' = rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
    'x' = abs(x - mean(x)),
    'y' = abs(y - mean(y)),
    'r' = abs(y),
    'qx' = quantile(x),
    'qy' = quantile(y)
  )
  if(method %in% c("qx", "qy"))
    if(!isNULL(level)) id.criterion <- id.criterion[id.criterion > level]
  if(method %in% c("dsq", "mahal"))
    if(!isNULL(level)) id.criterion <- id.criterion[id.criterion > qchisq(2, level)]
  if(length(id.criterion) == 0) return(NULL)
  index <-  order(id.criterion, decreasing=TRUE)[1L:min(length(id.criterion), n)]
  index
}
              
if(FALSE) {
  set.seed(47)
  x <- c(runif(100), 1.5, 1.6)
  y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6 )
  plot(x, y)
  abline(lm(y ~ x))
  
  demo <- function(x, y, n=5, method, level=NULL) {
    plot(x, y, main = paste0("method ='", method, "', level =", level))
    abline(lm(y ~ x))
    ids <- noteworthy(x, y, n=n, method = method, level = level)
    if(length(ids)>0) {
      points(x[ids], y[ids], pch = 16, cex = 1.5, col = "red")
      text(x[ids], y[ids], ids, pos=4, xpd=TRUE)
    }
    ids
  }
  
#  ids <- noteworthy(x, y, n=5, method = "mahal")
  demo(x, y, n=5, method = "mahal")
  demo(x, y, n=20, method = "mahal", level = 0.95)
  demo(x, y, n=5, method = "x")
  demo(x, y, n=5, method = "y")
  demo(x, y, n=5, method = "r")
  demo(x, y, n=5, method = "qx")
  demo(x, y, n=5, method = "qy")
  
}