# id.method can be any of the following:
#    --- a vector of row numbers: all are chosen
#    --- a vector of n numbers: the largest n are chosen
#    --- a text string:  'x', 'y', 'mahal', 'r', 'ry'
#
# For id.method = "identify", see: https://stackoverflow.com/questions/10526005/is-there-any-way-to-use-the-identify-command-with-ggplot-2

#' Find noteworthy (unusual) points in a 2D plot
#' 
#' This function extends the logic used by \code{\link[car]{showLabels}} to provide a more general
#' collection of methods to identify unusual or "noteworthy" points in a two-dimensional display.
#' Standard methods include ...
#' 
#' @details
#' 
#' You can supply as \code{id.fun} the name of any function that takes \code{(x, y)} as its first two 
#' arguments and calculates a criterion such that the \emph{largest} \code{n} values are considered noteworthy.
#' Otherwise, the \code{method} argument determines how noteworthy points are identified.
#' 
#' \describe{
#'  \item{\code{"dsq", "mahal"}}{Treat (x, y) as if it were a bivariate sample, 
#'       and select cases according to their Mahalanobis distance from \code{(mean(x), mean(y))}
#'  \item{\code{"x"}}{Select points according to their value of \code{abs(x - mean(x))}
#'  \item{\code{"y"}}{Select points according to their value of \code{abs(y - mean(r))}
#'  \item{\code{"r"}}{Select points according to their value of abs(y), as may be appropriate 
#'       in residual plots, or others with a meaningful origin at 0, such as a chi-square QQ plot}
#'  \item{code{"ry"}}{Fit the linear model, \code{y ~ x} andselect points according to their absolute residuals.}
#' }
#' 
#' If a value for \code{level} is supplied, this is used as a filter to select cases whose criterion value
#' exceeds \code{level}. In this case, the number of points identified will be less than or equal to \code{n}.
#' 
#' 
#' 
#' @param x, y       Plotting coordinates 
#' @param n          Maximum number of points to identify
#' @param method     Method of point identification. See Details.
#' @param level      Where appropriate, if supplied, the identified points are filtered so that only those for which the 
#'                   criterion is \code{< level}

noteworthy <- function(x, y, 
                       n = length(x),
                       method = "mahal",
                       level = NULL,
                       ...)
{

  special <- c("x", "y", "mahal", "r", 'ry')
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
    if (!is.null(level)) warning("`level` does not apply when `method` is a numeric vector")
  }

  else {
  # remove missings
  ismissing <- is.na(x) | is.na(y) 
  if( any(ismissing) ) {
    x <- x[!ismissing]
    y <- y[!ismissing]
    # should this issue a warning?
    warntext <- paste(sum(ismissing), "observations ignored due to missing 'x' or 'y'")
    message(warntext)
    }

  # what about CookD / influence?  
  crit <- switch(idmeth,
                 'mahal' = (k-1) * rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
                 'dsq'   = (k-1) * rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
                 'x'     = abs(x - mean(x)),
                 'y'     = abs(y - mean(y)),
                 'r'     = abs(y),
                 'ry'    = abs(residuals(lm(y ~ x)))
  )
  
  # adjust for `level` here, for any methods for which a level value is appropriate, to select fewer than `n`.
  if(!is.null(level)) {
    if(idmeth %in% c("dsq", "mahal")) {
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
  x <- c(runif(100), 1.5, 1.6)
  y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6 )
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
#    text(x, y, labels = ifelse(1:length(x) %in% ids, ids, ""), col = "red")
    text(x[ids], y[ids], labels = ids, col = "red")
    ids
  }
  
  testnote(x, y, n=5, method = "mahal")
  testnote(x, y, n=5, method = "mahal", level = .99)
  
  testnote(x, y, n=5, method = "y")
  testnote(x, y, n=5, method = "r")
  
  # a vector of criterion values
  testnote(x, y, n=5, method = Mahalanobis(data.frame(x,y)))
  # NB: level doesn't apply here
  testnote(x, y, n=5, method = Mahalanobis(data.frame(x,y)), level = 0.95)
  
  testnote(x, y, n=4, method = residuals(lm(y~x)))
  # vector of case IDs
  testnote(x, y, n = 4, method = seq(10, 60, 10))
  
}
  
  