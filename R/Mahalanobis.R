#' Classical and Robust Mahalanobis Distances
#' 
#' This function is a convenience wrapper to \code{\link[stats]{mahalanobis}}
#' offering also the possibility to calculate robust Mahalanobis squared
#' distances using MCD and MVE estimators of center and covariance (from
#' \code{\link[MASS]{cov.rob}})
#' 
#' Any missing data in a row of \code{x} causes \code{NA} to be returned for
#' that row.
#' 
#' @param x a numeric matrix or data frame with, say, \eqn{p} columns
#' @param center mean vector of the data; if this and \code{cov} are both supplied,
#'               the function simply calls \code{\link[stats]{mahalanobis}} to 
#'               calculate the result
#' @param cov    covariance matrix (p x p) of the data
#' @param method  estimation method used for center and covariance, one of:
#'               \code{"classical"} (product-moment), 
#'               \code{"mcd"} (minimum covariance determinant), or           
#'               \code{"mve"} (minimum volume ellipsoid).         
#' @param nsamp  passed to \code{\link[MASS]{cov.rob}}
#' @param ...    other arguments passed to \code{\link[MASS]{cov.rob}}
#' @return      a vector of length \code{nrow(x)} containing the squared distances.
#' @author Michael Friendly
#' @seealso \code{\link[stats]{mahalanobis}}, \code{\link[MASS]{cov.rob}}
#' @keywords multivariate
#' @examples
#' 
#' summary(Mahalanobis(iris[, 1:4]))
#' summary(Mahalanobis(iris[, 1:4], method="mve"))
#' summary(Mahalanobis(iris[, 1:4], method="mcd"))
#' 
#' 
#' @export 
Mahalanobis <- function(x, center, cov, 
	method=c("classical", "mcd", "mve"), nsamp="best", ...) {
	
  OK <- complete.cases(x)
  if (sum(OK) < nrow(x)) message(nrow(x) - sum(OK), "cases with missing data have been ignored.")
  res <- rep(NA, nrow(x))
	# if center and cov are supplied, use those
	if (! (missing(center) | missing(cov) )) {
	  res[OK] <- mahalanobis(x[OK,], center=center, cov=cov)
		return( res )
	}

	method = match.arg(method)
	stats <- MASS::cov.rob(x[OK,], method=method, nsamp=nsamp, ...)	
	res[OK] <- mahalanobis(x[OK,], stats$center, stats$cov)
	res
}
