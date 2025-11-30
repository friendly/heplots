# method can be any of the following:
#   * a vector of row numbers: all are chosen
#   * a vector of length(x) numbers: the largest n are chosen
#   * a text string:  'x', 'y', 'mahal', 'dsq', 'r', 'ry'
#
# For id.method = "identify", see: https://stackoverflow.com/questions/10526005/is-there-any-way-to-use-the-identify-command-with-ggplot-2

#' Find noteworthy (unusual) points in a 2D plot
#'
#' @description 
#' This function extends the logic used by \code{\link[car]{showLabels}} to provide a more general
#' collection of methods to identify unusual or "noteworthy" points in a two-dimensional display.
#' Standard methods include Mahalanobis  and Euclidean distance from the centroid, absolute value of distance from 
#' the mean of X or Y, absolute value of Y and absolute value of the residual in a model `Y ~ X`.
#' 
#' @details
#' 
#' The `method` argument determines how the points to be identified are selected:
#' \describe{
#'  \item{`"mahal"`}{Treat (x, y) as if it were a bivariate sample, 
#'       and select cases according to their Mahalanobis distance from `(mean(x), mean(y))`.}
#'  \item{`"dsq"`}{Similar to `"mahal"` but uses squared Euclidean distance.}  
#'  \item{`"x"`}{Select points according to their value of `abs(x - mean(x))`.}
#'  \item{`"y"`}{Select points according to their value of `abs(y - mean(y))`.}
#'  \item{`"r"`}{Select points according to their value of `abs(y)`, as may be appropriate 
#'       in residual plots, or others with a meaningful origin at 0, such as a chi-square QQ plot.}
#'  \item{`"ry"`}{Fit the linear model, `y ~ x` and select points according to their absolute residuals.}
#'  \item{case IDs}{`method` can be an integer vector of case numbers in \code{1:length{x}}, in which case those cases 
#'       will be labeled.}
#'  \item{numeric vector}{`method` can be a vector of the same length as x consisting of values to determine the points 
#'       to be labeled. For example, for a linear model `mod`, setting `method=cooks.distance(mod)` will label the 
#'       `n` points corresponding to the largest values of Cook's distance. Warning: If missing data are present, 
#'       points may be incorrectly selected.}
#' }
#' 
#' In the case of `method == "mahal"` a value for `level` can be supplied.
#' This is used as a filter to select cases whose criterion value
#' exceeds `level`. In this case, the number of points identified will be less than or equal to `n`.
#' 
#' 
#' @param x,y        The x and y coordinates of a set of points. Alternatively, a single argument `x` can be provided,
#'                   since \code{\link[grDevices]{xy.coords}(x, y)} is used for construction of the coordinates.
#' @param n          Maximum number of points to identify. If set to 0, no points are identified.
#' @param method     Method of point identification. See Details.
#' @param level      Where appropriate, if supplied, the identified points are filtered so that only those for which the 
#'                   criterion is `< level`
#' @param ...        Other arguments, silently ignored
#' @keywords utilities
#' @importFrom stats lm
#' @importFrom grDevices xy.coords
#' @export
#' @examples
#' # example code
#' set.seed(47)
#' x <- c(runif(100), 1.5, 1.6, 0)
#' y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6, 6 )
#' z <- y - x
#' mod <- lm(y ~ x)
#'
#' # testing function to compare noteworthy with car::showLabels() 
#' testnote <- function(x, y, n, method=NULL, ...)  {
#'   plot(x, y)
#'   abline(lm(y ~ x))
#'   if (!is.null(method))
#'     car::showLabels(x, y, n=n, method = method) |> print()
#'   ids <- noteworthy(x, y, n=n, method = method, ...)
#'   text(x[ids], y[ids], labels = ids, col = "red")
#'   ids
#'   }
#' 
#'   # Mahalanobis distance 
#' testnote(x, y, n = 5, method = "mahal")
#' testnote(x, y, n = 5, method = "mahal", level = .99)
#'   # Euclidean distance 
#' testnote(x, y, n = 5, method = "dsq")
#' 
#' testnote(x, y, n = 5, method = "y")
#' testnote(x, y, n = 5, method = "ry")
#' 
#'   # a vector of criterion values
#' testnote(x, y, n = 5, method = Mahalanobis(data.frame(x,y)))
#' testnote(x, y, n = 5, method = z)
#'   # vector of case IDs
#' testnote(x, y, n = 4, method = seq(10, 60, 10))
#' testnote(x, y, n = 4, method = which(cooks.distance(mod) > .25))
#' 
#'   # test use of xy.coords  
#' noteworthy(data.frame(x,y), n=4)
#' noteworthy(y ~ x, n=4)



noteworthy <- function(x, y = NULL, 
                       n = length(x),
                       method = "mahal",
                       level = NULL,
                       ...)
{

  special <- c("x", "y", "mahal", "dsq", "r", 'ry')
  idmeth <- pmatch(method[1], special)
  if(!is.na(idmeth)) 
    idmeth <- special[idmeth]

#browser()  
  if(is.na(idmeth)) {
  # if idmeth is still NA, then id.method must be <= n numbers or row ids
  # handle these separately before using idmeth
    # row ids?
    crit <- method
    # vector of row ids
    if(all(crit == floor(crit)) && all(crit %in% 1:length(x))) {
      n <- length(crit)
    # we're done
      return(crit)
    }
    # vector of numeric criteria, for selecting the largest `n`
    if (!is.null(level)) warning("`level` does not apply when `method` is a numeric vector.")
  }

  else {
    xy <- xy.coords(x, y)
    x <- xy$x
    y <- xy$y
    k <- length(x)
    # remove missings
    ismissing <- is.na(x) | is.na(y) 
    if( any(ismissing) ) {
      x <- x[!ismissing]
      y <- y[!ismissing]
      # should this issue a warning?
      warntext <- paste(sum(ismissing), "observations ignored due to missing `x` or `y`. Selected points may be incorrect.")
      message(warntext)
    }
    if(length(x) != length(y)) stop("`x` and `y` must be vectors of the same length.")

  # what about CookD / influence?  
    crit <- switch(idmeth,
                   'mahal' = (k-1) * rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
                   'dsq'   = (x - mean(x))^2 + (y - mean(y))^2,
                   'x'     = abs(x - mean(x)),
                   'y'     = abs(y - mean(y)),
                   'r'     = abs(y),
                   'ry'    = abs(residuals(stats::lm(y ~ x)))
    )
  
  # adjust for `level` here, for any methods for which a level value is appropriate, to select fewer than `n`.
    if(!is.null(level)) {
      if(idmeth == "mahal") {
        crit[crit < qchisq(level, df=2)] <- 0
        n <- sum(crit != 0)
      }
      # could do something similar for `ry`: select by qnorm(level, lower.tail = FALSE)
    }
  }
  
  # return result: row IDs of the largest n criterion values
  if(length(crit) == 0) return(NULL)
  #browser()  
  index <-  order(crit, decreasing=TRUE)[1L:min(length(crit), n)]
  index
  
}
  
