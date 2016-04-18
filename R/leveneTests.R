# univariate Levene tests for a multivariate response

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

