#' Calculate column deviations from central values
#' 
#' \code{colDevs} calculates the column deviations of data values from a
#' central value (mean, median, etc.), possibly stratified by a grouping
#' variable.
#' 
#' Conceptually, the function is similar to a column-wise
#' \code{\link[base]{sweep}}, by group, allowing an arbitrary \code{center}
#' function.
#' 
#' Non-numeric columns of \code{x} are removed, with a warning.
#' 
#' @param x A numeric data frame or matrix.
#' @param group A factor (or variable that can be coerced to a factor)
#'         indicating the membership of each observation in \code{x} in one or more
#'         groups. If missing, all the data is treated as a single group.
#' @param center A function used to center the values (for each group if
#'         \code{group} is specified. The function must take a vector argument and
#'         return a scalar result.
#' @param \dots Arguments passed down
#' @return A numeric matrix containing the deviations from the centering
#' function. 
#' @author Michael Friendly
#' @seealso \code{\link[base]{colMeans}} for column means,
#' 
#' \code{\link[base]{sweep}}
#' @keywords manip
#' @examples
#' 
#' data(iris)
#' 
#' Species <- iris$Species
#' irisdev <- colDevs(iris[,1:4], Species, mean)
#' irisdev <- colDevs(iris[,1:4], Species, median)
#' # trimmed mean, using an anonymous function
#' irisdev <- colDevs(iris[,1:4], Species, function(x) mean(x, trim=0.25))
#' 
#' # no grouping variable: deviations from column grand means
#' # include all variables (but suppress warning for this doc)
#' irisdev <- suppressWarnings( colDevs(iris) )
#' 
#' @export colDevs
colDevs <- function(x, group, center=mean,  ...) {

	if (!inherits(x, c("data.frame", "matrix")))
		stop("Argument 'x' must be a data.frame or matrix")

	if (missing(group)) {
		group <- factor(rep(1, nrow(x)))
	}
	
	if (!is.factor(group)) {
	warning(deparse(substitute(group)), " coerced to factor.")
	group <- as.factor(group)
	}
	
	nlev <- nlevels(group)
	lev <- levels(group)

	nums <- sapply(x, is.numeric)
	if (!all(nums)) {
		warning("Ignoring ", sum(!nums), " non-numeric column(s)")
		x <- x[, nums, drop=FALSE]
	}
	
	mat <- matrix(0, nrow(x), ncol(x), dimnames=dimnames(x))
	x <- as.matrix(x)
	for (i in 1:nlev) {
		rows <- which(group==lev[i])
		ctr <- apply( x[rows,], 2, center)
		mat[rows, ] <- sweep( x[rows, ], 2, ctr)
	}
	mat
}


