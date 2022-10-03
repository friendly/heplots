# univariate Levene tests for a multivariate response


#' Levene Tests of Homogeneity of Variances
#' 
#' This function extends \code{\link[car]{leveneTest}} to a multivariate
#' response setting.  It performs the Levene test of homogeneity of variances
#' for each of a set of response variables, and prints a compact summary.
#' 
#' 
#' @param y A data frame or matrix of numeric response variables in a
#'        multivariate linear model.
#' @param group a vector or factor object giving the group for the
#'        corresponding elements of the rows of \code{y}
#' @param center The name of a function to compute the center of each group;
#'        \code{mean} gives the original Levene's (1960) test; the default,
#'        \code{median}, provides a more robust test suggested by Brown and Forsythe (1974).
#' @param \dots other arguments, passed to \code{\link[car]{leveneTest}}
#' 
#' @return An object of classes "anova" and "data.frame", with one observation
#'         for each response variable in \code{y}.
#' @author Michael Friendly
#' @seealso 
#'    \code{\link[car]{leveneTest}}, \code{\link{bartlettTests}}
#' @references 
#' Levene, H. (1960). Robust Tests for Equality of Variances. In
#' Olkin, I. \emph{et al.} (Eds.), \emph{Contributions to Probability and
#' Statistics: Essays in Honor of Harold Hotelling}, Stanford University Press,
#' 278-292.
#' 
#' Brown, M. B. & Forsythe, A. B. (1974). Robust Tests For Equality Of
#' Variances \emph{Journal of the American Statistical Association}, \bold{69},
#' 364-367.
#' @keywords htest
#' @examples
#' 
#' leveneTests(iris[,1:4], iris$Species)
#' 
#' # handle a 1-column response?
#' leveneTests(iris[,1, drop=FALSE], iris$Species)
#' 
#' data(Skulls, package="heplots")
#' leveneTests(Skulls[,-1], Skulls$epoch)
#' 
#' 
#' @export leveneTests
leveneTests <-
	function (y, group, center = median, ...) 
{
	if (! inherits(y, "data.frame") | inherits(y, "matrix") )
		stop(deparse(substitute(y)), " is not a data frame or matrix")
	if (! all( apply(y, 2, is.numeric) ))
		stop(deparse(substitute(y)), " has non-numeric columns")

	ltest <- apply(y, 2, FUN=function(x) car::leveneTest(x, group=group, center=center, ...))
	LT <- as.data.frame(matrix(0, nrow=length(ltest), 4))
	
	for (i in 1:nrow(LT)) {
		LT[i,1] <- ltest[[i]][1,1]
		LT[i,2] <- ltest[[i]][2,1]
		LT[i,3] <- ltest[[i]][1,2]
		LT[i,4] <- ltest[[i]][1,3]	
	}
	colnames(LT) <- c("df1", "df2", "F value", "Pr(>F)")
	rownames(LT) <- names(ltest)
	class(LT) <- c("anova", "data.frame")
  dots <- deparse(substitute(...))
  attr(LT, "heading") <- paste("Levene's Tests for Homogeneity of Variance (center = ", 
      deparse(substitute(center)), if (!(dots == "NULL")) 
          paste(":", dots), ")\n", sep = "")
	LT
}

