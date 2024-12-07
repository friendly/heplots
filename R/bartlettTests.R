
#' @name bartlettTests
#' @aliases bartlettTests.default bartlettTests.formula bartlettTests.mlm
#' @title Bartlett Tests of Homogeneity of Variances
#' 
#' @description
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
#' @param y A data frame or matrix of numeric response variables for the default method,
#'        or a model formula for a multivariate linear model, or the multivariate linear model itself.
#'        In the case of a formula or model, the  variables on the right-hand-side of the model must all 
#'        be factors and must be completely crossed.
#' @param group a vector or factor object giving the group for the
#'        corresponding elements of the rows of \code{y} for the default method
#' @param \dots other arguments, passed to \code{\link[stats]{bartlett.test}}
#' @return An object of classes "anova" and "data.frame", with one observation
#' for each response variable in \code{y}. 
#' @author Michael Friendly
#' @seealso \code{\link{boxM}} for Box's M test for all responses together.
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
#' # formula method
#' bartlettTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' 
#' @export
#' 

bartlettTests <- function (y, ...) {
  UseMethod("bartlettTests") 
}

#' @rdname bartlettTests
#' @exportS3Method 

bartlettTests.default <-
	function (y, group, ...) 
{
  if (! inherits(y, c("data.frame", "matrix")) )
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

#' @param data  the data set, for the \code{formula} method
#' @rdname bartlettTests
#' @exportS3Method 
bartlettTests.formula <- function(y, data, ...) {
  form <- y
  mf <- if (missing(data)) model.frame(form) else model.frame(form, data)
  if (any(sapply(2:dim(mf)[2], function(j) is.numeric(mf[[j]])))) 
    stop("Bartlett's test is not appropriate with quantitative explanatory variables.")
  y <- mf[,1]
  
  if(dim(mf)[2]==2) group <- mf[,2]
  else {
    if (length(grep("\\+ | \\| | \\^ | \\:",form))>0) stop("Model must be completely crossed formula only.")
    group <- interaction(mf[,2:dim(mf)[2]])
  }
  bartlettTests.default(y=y, group=group, ...)
}


#' @rdname bartlettTests
#' @exportS3Method 
bartlettTests.mlm <- function(y, ...) {
  m <- model.frame(y)
  m$..y <- model.response(m)
  f <- formula(y)
  f[2] <- expression(..y)
  bartlettTests.formula(f, data=m, ...)
}
