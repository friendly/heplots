#' Calculate statistics for levels of factors
#' 
#' `statList` provides a general method for calculating univariate or
#' multivariate statistics for a matrix or data.frame stratified by one or more
#' factors.
#' 
#' `statList` is the general function. `X` is first `split` by
#' `factors`, and `FUN` is applied to the result.
#' 
#' `colMeansList` and `covList` are just calls to `statList`
#' with the appropriate `FUN`.
#' 
#' @aliases statList covList colMeansList
#' @param X A matrix or data frame containing the variables to be summarized
#' @param factors A vector, matrix or data frame containing the factors for
#'        which `X` is to be summarized.  If `factors` is not specified,  
#'        the result is calculated for all of the data in `X`.
#' @param FUN A function to be applied to the pieces of `X`, as split by `factors`.
#' @param drop Logical, indicating whether empty levels of `factors` are
#'        to be dropped from the result.
#' @param \dots Other arguments, passed to `FUN`.
#' @return Returns a list of items corresponding to the unique elements in
#'        `factors`, or the interaction of `factors`. Each item is the
#'        result of applying `FUN` to that collection of rows of `X`. The
#'        items are named according to the levels in `factors`.
#' @author Michael Friendly
#' @seealso \code{\link[base]{colMeans}}, \code{\link{termMeans}}
#' @keywords utilities multivariate
#' @examples
#' 
#' # grand means
#' statList(iris[,1:4], FUN=colMeans)
#' # species means
#' statList(iris[,1:4], iris$Species, FUN=colMeans)
#' # same
#' colMeansList(iris[,1:4], iris$Species)
#' 
#' # var-cov matrices, by species
#' covList(iris[,1:4], iris$Species)
#' 
#' # multiple factors
#' iris$Dummy <- sample(c("Hi","Lo"),150, replace=TRUE)
#' colMeansList(iris[,1:4], iris[,5:6])
#' 
#' 
#' 
#' @export statList
statList <- function(X, factors, FUN, drop=FALSE, ...) {
	if (!is.numeric(as.matrix(X))) stop("Argument X must be numeric")
	if (!missing(factors)) {
    glist <- split(X, factors, drop=drop)
    result <- lapply(glist, FUN, ...)
  	}
  else result <- list(FUN(X, ...))
  result
}

#' @export
colMeansList <- function(X, factors, drop=FALSE, ...) {
	statList(X, factors, FUN=colMeans, drop=drop, ...)
}

#' @export
covList <- function(X, factors, drop=FALSE, ...) {
	statList(X, factors, FUN=cov, drop=drop, ...)
}


