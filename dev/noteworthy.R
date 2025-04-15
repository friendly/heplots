# id.method can be any of the following:
#    --- a vector of row numbers: all are chosen
#    --- a vector of n numbers: the largest n are chosen
#    --- a text string:  'x', 'y', 'mahal', 'dsq', 'r', 'ry'
#
# For id.method = "identify", see: https://stackoverflow.com/questions/10526005/is-there-any-way-to-use-the-identify-command-with-ggplot-2

#' Find noteworthy (unusual) points in a 2D plot
#'
#' @description 
#' This function extends the logic used by \code{\link[car]{showLabels}} to provide a more general
#' collection of methods to identify unusual or "noteworthy" points in a two-dimensional display.
#' Standard methods include Mahalanobis  and Euclidean distance from the centroid, absolute value of distance from 
#' the mean of X or Y, absolute value of Y and absolute value of the residual in a model \code{Y ~ X}.
#' 
#' @details
#' 
#' The `method` argument determines how the points to be identified are selected:
#' \describe{
#'  \item{\code{"mahal"}}{Treat (x, y) as if it were a bivariate sample, 
#'       and select cases according to their Mahalanobis distance from \code{(mean(x), mean(y))}
#'  \item{\code{"dsq"}}{Similar to \code{"mahal"} but uses squared Euclidean distance}  
#'  \item{\code{"x"}}{Select points according to their value of \code{abs(x - mean(x))}
#'  \item{\code{"y"}}{Select points according to their value of \code{abs(y - mean(r))}
#'  \item{\code{"r"}}{Select points according to their value of abs(y), as may be appropriate 
#'       in residual plots, or others with a meaningful origin at 0, such as a chi-square QQ plot}
#'  \item{\code{"ry"}}{Fit the linear model, \code{y ~ x} and select points according to their absolute residuals.}
#'  \item{numeric vector}{\code{method} can be a vector of the same length as x consisting of values to determine the points 
#'       to be labeled. For example, for a linear model \code{mod}, setting \code{method=cooks.distance(mod)} will label the 
#'       \code{n} points corresponding to the largest values of Cook's distance. Warning: If missing data are present, 
#'       points may be incorrectly selected.}
#'  \item{case IDs}{\code{method} can be an integer vector of case numbers in \code{1:length{x}}, in which case those cases 
#'       will be labeled.}
#' }
#' 
#' In the case of \code{method == "mahal"} a value for \code{level} can be supplied and 
#' this can used as a filter to select cases whose criterion value
#' exceeds \code{level}. In this case, the number of points identified will be less than or equal to \code{n}.
#' 
#' 
#' 
#' @param x, y       Plotting coordinates 
#' @param n          Maximum number of points to identify
#' @param method     Method of point identification. See Details.
#' @param level      Where appropriate, if supplied, the identified points are filtered so that only those for which the 
#'                   criterion is \code{< level}
#' @export
#' @examples
#' # example code
#' set.seed(47)
#' x <- c(runif(100), 1.5, 1.6, 0)
#' y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6, 6 )
#' 
#' testnote(x, y, n=5, method = "mahal")
#' testnote(x, y, n=5, method = "mahal", level = .99)
#' 
#' testnote(x, y, n=5, method = "dsq")
#' 
#' testnote(x, y, n=5, method = "y")
#' testnote(x, y, n=5, method = "ry")
#'   # a vector of criterion values
#' testnote(x, y, n=5, method = Mahalanobis(data.frame(x,y)))

noteworthy <- function(x, y, 
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
                   'ry'    = abs(residuals(lm(y ~ x)))
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
  
if(FALSE) {
  set.seed(47)
  x <- c(runif(100), 1.5, 1.6, 0)
  y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6, 6 )
  XY <- data.frame(x, y)
  plot(x, y)
  abline(lm(y ~ x))
  dsq <- Mahalanobis(XY)
  out <- cqplot(XY, id.n = 4)
  out
  dsqr <- rowSums( qr.Q(qr(cbind(1, XY)))^2 )
  dmod <- lm(dsq ~ dsqr)
  coef(dmod)
  
  testnote <- function(x, y, n, method=NULL, ...)  {
    plot(x, y)
    abline(lm(y ~ x))
    if (!is.null(method))
      car::showLabels(x, y, n=n, method = method) |> print()
    ids <- noteworthy(x, y, n=n, method = method, ...)
    text(x[ids], y[ids], labels = ids, col = "red")
    ids
  }
  
  testnote(x, y, n=5, method = "mahal")
  testnote(x, y, n=5, method = "mahal", level = .99)

  testnote(x, y, n=5, method = "dsq")
  
  testnote(x, y, n=5, method = "y")
  testnote(x, y, n=5, method = "r")
  
  # a vector of criterion values
  testnote(x, y, n=5, method = Mahalanobis(data.frame(x,y)))
  # NB: level doesn't apply here (-> warning)
  testnote(x, y, n=5, method = Mahalanobis(data.frame(x,y)), level = 0.95)

  # largest (positive) residuals
  testnote(x, y, n=4, method = residuals(lm(y~x)))
  # vector of case IDs
  testnote(x, y, n = 4, method = seq(10, 60, 10))
  
}
  
  