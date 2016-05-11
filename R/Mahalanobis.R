#' Classical and Robust Mahalanobis Distances
#'
#' This function is a convenience wrapper to \code{\link[stats]{mahalanobis}} offering
#' also the possibility to calculate robust Mahalanobis squared distances using
#' MCD and MVE estimators of center and covariance.
#'
#' @param x      matrix of data with, say, p columns
#' @param center mean vector of the data; if this and \code{cov} are both supplied,
#'               the function simply calls \code{\link[stats]{mahalanobis}} to 
#'               calculate the result
#' @param cov    covariance matrix (p x p) of the data
#' @param method  estimation method used for center and covariance, one of:
#'               \code{"classical") (product-moment), 
#'               \code{"mcd") (minimum covariance determinant), or           
#'               \code{"mve") (minimum volume ellipsoid).         
#' @param nsamp  passed to \code{\link[MASS]{cov.rob}}
#' @param ...    other arguments passed to \code{\link[MASS]{cov.rob}}
#' @return 
#' @export
#' @examples

Mahalanobis <- function(x, center, cov, 
	method=c("classical", "mcd", "mve"), nsamp="best", ...) {
	
	# if center and cov are supplied, use those
	if (! (missing(center) | missing(cov) ))
		return( mahalanobis(x, center=center, cov=cov) )

	method = match.arg(method)
	stats <- MASS::cov.rob(x, method=method, nsamp=nsamp, ...)	
	mahalanobis(x, stats$center, stats$cov)	
}
