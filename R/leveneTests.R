# univariate Levene tests for a multivariate response


#' @name leveneTests
#' @aliases leveneTests.default leveneTests.formula leveneTests.lm
#' @title Levene Tests of Homogeneity of Variances
#' 
#' @description
#' 
#' This function extends \code{\link[car]{leveneTest}} to a multivariate
#' response setting.  It performs the Levene test of homogeneity of variances
#' for each of a set of response variables, and prints a compact summary.
#' 
#' 
#' @param y A data frame or matrix of numeric response variables for the default method,
#'        or a model formula for a multivariate linear model, or the multivariate linear model itself.
#'        In the case of a formula or model, the  variables on the right-hand-side of the model must all 
#'        be factors and must be completely crossed.
#' @param group a vector or factor object giving the group for the
#'        corresponding elements of the rows of \code{y} for the default method
#' @param center The name of a function to compute the center of each group;
#'        \code{mean} gives the original Levene's (1960) test; the default,
#'        \code{median}, provides a more robust test suggested by Brown and Forsythe (1974).
#' @param \dots arguments to be passed down to \code{\link[car]{leveneTest}}, e.g., \code{data} for the 
#'        \code{formula} and \code{lm} methods; can also 
#'        be used to pass arguments to the function given by center (e.g., center=mean and trim=0.1 specify 
#'        the 10\% trimmed mean) other arguments.
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
#' # formula method
#' leveneTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' 
#' # use 10% trimmed means
#' leveneTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls, trim = 0.1)
#' 
#' 
#' # mlm method
#' skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' leveneTests(skulls.mod)
#' 
#' @export
#' 

leveneTests <- function (y, ...) {
  UseMethod("leveneTests") 
}

#' @rdname leveneTests
#' @exportS3Method 
leveneTests.default <-
	function (y, group, center = median, ...) 
{
	if (! inherits(y, c("data.frame", "matrix")) )
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

#' @param data  the data set, for the \code{formula} method
#' @rdname leveneTests
#' @exportS3Method 
leveneTests.formula <- function(y, data, ...) {
  form <- y
  mf <- if (missing(data)) model.frame(form) else model.frame(form, data)
  if (any(sapply(2:dim(mf)[2], function(j) is.numeric(mf[[j]])))) 
    stop("Levene's test is not appropriate with quantitative explanatory variables.")
  y <- mf[,1]

  if(dim(mf)[2]==2) group <- mf[,2]
  else {
    if (length(grep("\\+ | \\| | \\^ | \\:",form))>0) stop("Model must be completely crossed formula only.")
    group <- interaction(mf[,2:dim(mf)[2]])
  }
  leveneTests.default(y=y, group=group, ...)
}


#' @rdname leveneTests
#' @exportS3Method 
leveneTests.lm <- function(y, ...) {
  m <- model.frame(y)
  m$..y <- model.response(m)
  f <- formula(y)
  f[2] <- expression(..y)
  leveneTests.formula(f, data=m, ...)
}
