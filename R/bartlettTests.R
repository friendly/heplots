
#' Bartlett Tests of Homogeneity of Variances
#' 
#' This function extends \code{\link[stats]{bartlett.test}} to a multivariate
#' response setting.  It performs the Bartlett test of homogeneity of variances
#' for each of a set of response variables, and prints a compact summary.
#' 
#' Bartlett's test is the univariate version of Box's M test for equality of
#' covariance matrices.  This function provides a univariate follow-up test to
#' Box's M test to give one simple assessment of which response variables
#' contribute to significant differences in variances among groups.
#' 
#' @param y A data frame or matrix of numeric response variables in a
#'          multivariate linear model.
#' @param group a vector or factor object giving the group for the
#'          corresponding elements of the rows of \code{y}
#' @param \dots other arguments, passed to \code{\link[stats]{bartlett.test}}
#' @return An object of classes "anova" and "data.frame", with one observation
#' for each response variable in \code{y}. 
#' @author Michael Friendly
#' @seealso \code{\link{boxM}} for Box's M test for all responses.
#' @references 
#' Bartlett, M. S. (1937). Properties of sufficiency and
#' statistical tests.  \emph{Proceedings of the Royal Society of London Series
#' A}, \bold{160}, 268-282.
#' @keywords htest
#' @examples
#' 
#' bartlettTests(iris[,1:4], iris$Species)
#' 
#' data(Skulls, package="heplots")
#' bartlettTests(Skulls[,-1], Skulls$epoch)
#' 
#' 
#' @export bartlettTests
bartlettTests <-
	function (y, group, ...) 
{
	if (! inherits(y, "data.frame") | inherits(y, "matrix") )
		stop(deparse(substitute(y)), " is not a data frame or matrix")
	if (! all( apply(y, 2, is.numeric) ))
		stop(deparse(substitute(y)), " has non-numeric columns")

	btest <- apply(y, 2, FUN=function(x) stats::bartlett.test(x, g=group, ...))
	BT <- as.data.frame(matrix(0, nrow=length(btest), 3))

	for (i in 1:nrow(BT)) {
		BT[i,1] <- btest[[i]]$statistic
		BT[i,2] <- btest[[i]]$parameter
		BT[i,3] <- btest[[i]]$p.value
	}
	rownames(BT) <- names(btest)
	colnames(BT) <- c("Chisq", "df", "Pr(>Chisq)")
	class(BT) <- c("anova", "data.frame")
  dots <- deparse(substitute(...))
	attr(BT, "heading") <- paste("Bartlett's Tests for Homogeneity of Variance",
	       if (!(dots == "NULL"))  paste(":", dots), "\n")
	BT
}

