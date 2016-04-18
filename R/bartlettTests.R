# univariate Bartlett tests for a multivariate response

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

