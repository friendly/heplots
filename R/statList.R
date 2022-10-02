#' Calculate statistics for levels of factors
#' 
#' \code{statList} provides a general method for calculating univariate or
#' multivariate statistics for a matrix or data.frame stratified by one or more
#' factors.
#' 
#' \code{statList} is the general function. \code{X} is first \code{split} by
#' \code{factors}, and \code{FUN} is applied to the result.
#' 
#' \code{colMeansList} and \code{covList} are just calls to \code{statList}
#' with the appropriate \code{FUN}.
#' 
#' @aliases statList covList colMeansList
#' @param X A matrix or data frame containing the variables to be summarized
#' @param factors A vector, matrix or data frame containing the factors for
#' which \code{X} is to be summarized.  If \code{factors} is not specified, the
#' result is calculated for all of the data in \code{X}.
#' @param FUN A function to be applied to the pieces of \code{X}, as split by
#' \code{factors}.
#' @param drop Logical, indicating whether empty levels of \code{factors} are
#' to be dropped from the result.
#' @param \dots Other arguments, passed to \code{FUN}.
#' @return Returns a list of items corresponding to the unique elements in
#' \code{factors}, or the interaction of \code{factors}. Each item is the
#' result of applying \code{FUN} to that collection of rows of \code{X}. The
#' items are named according to the levels in \code{factors}.
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

colMeansList <- function(X, factors, drop=FALSE, ...) {
	statList(X, factors, FUN=colMeans, drop=drop, ...)
}

covList <- function(X, factors, drop=FALSE, ...) {
	statList(X, factors, FUN=cov, drop=drop, ...)
}


