# Find noteworthy points in a 2D scatterplot
# TODO: How to allow for method = a vector of the same length as x, e.g, method = cooks.distance(m)

#' Find noteworthy (unusual) points in a 2D plot
#' 
#' This function extends the logic used by \code{\link[car]{showLabels}} to provide a more general
#' collection of methods to identify unusual or "noteworthy" points in a two-dimensional display.
#' 
#' 
#' @details
#' 
#' You can supply as \code{id.fun} the name of any function that takes \code{(x, y)} as its first two 
#' arguments and calculates a criterion such that the \emph{largest} \code{n} values are considered noteworthy.
#' Otherwise, the \code{method} argument determines how noteworthy points are identified.
#' 
#' \describe{
#'  \item{\code{"x"}}{select points according to their value of \code{abs(x - mean(x))}
#'  \item{\code{"y"}}{select points according to their value of \code{abs(y - mean(r))}
#'  \item{\code{"r"}}{select points according to their value of abs(y), as may be appropriate 
#'       in residual plots, or others with a meaningful origin at 0, such as a chi-square QQ plot}
#'  \item{\code{"dsq", "mahal"}}{Treat (x, y) as if it were a bivariate sample, 
#'       and select cases according to their Mahalanobis distance from \code{(mean(x), mean(y))}
#'  \item{code{"px"}}{select points according to their value of \code{ppoints(x)}}
#'  \item{code{"py"}}{select points according to their value of \code{ppoints(y)}}
#' }
#' 
#' If a value for \code{level} is supplied, this is used as a filter to select cases whose criterion value
#' exceeds \code{level}. In this case, the number of points identified will be less than or equal to \code{n}.
#' 
#' @param x, y       Plotting coordinates 
#' @param n          Maximum number of points to identify
#' @param method     Method of point identification. See Details.
#' @param id.fun     Name of a function of \code{(x, y)}. If supplied, this overrides the \code{method} argument
#' @param level      If supplied, the identified points are filtered so that only those for which the 
#'                   criterion is \code{< level}
#' @param ...        Other arguments passed to \code{id.fun()}
#'
#' @return   An integer vector of the indices of the (x,y) pairs found to be noteworthy or \code{NULL} if no
#'           points are identified as noteworthy.
#' @export
#'
#' @examples
noteworthy <- function(x, y, 
                       n,
                       method = "mahal",
                       id.fun = NULL,
                       level = NULL,
                       ...){
  
  
  
  # remove missings
  ismissing <- is.na(x) | is.na(y) 
  if( any(ismissing) ) {
    x <- x[!ismissing]
    y <- y[!ismissing]
  }
  
  k <- length(x)
  methods <- c("dsq", "mahal", "x", "y", "r", "px", "py")
  methid <- pmatch(method, methods)
  method <- methods[methid]
  
  if (!is.null(id.fun)) 
    crit = id.fun(x, y, ...)
  else {
    crit <- switch(method,
                   'mahal' = (k-1) * rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
                   'dsq' = (k-1) * rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
                   'x' = abs(x - mean(x)),
                   'y' = abs(y - mean(y)),
                   'r' = abs(y),
                   'px' = ppoints(x),
                   'py' = ppoints(y)
    )
  }
  
  if(!is.null(level)) {
    if(method %in% c("px", "py")) {
      crit[crit < level] <- 0
      n <- sum(crit != 0)
    }
    if(method %in% c("dsq", "mahal")) {
      crit[crit < qchisq(level, df=2)] <- 0
      n <- sum(crit != 0)
    }
  }
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
  
  testnote <- function(x, y, n, method, ...)  {
    plot(x, y)
    abline(lm(y ~ x))
    if (method %in% c("mahal", "x", "y", "r"))
      showLabels(x, y, n=n, method = method) |> print()
    noteworthy(x, y, n=n, method = method, ...)
    
  }
  
  testnote(x, y, n=5, method = "mahal")
  testnote(x, y, n=5, method = "mahal", level = .99)
  
  testnote(x, y, n=5, method = "px")
  testnote(x, y, n=5, method = "px", level = .99)
  
  testnote(x, y, n=5, id.fun = Mahalanobis(data.frame(x,y)))
  
  noteworthy(x, y, n=5, method = "y")
  noteworthy(x, y, n=5, method = "r")
  
  
}