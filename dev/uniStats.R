# Univariate test statistics for a mlm

#' Univariate Test Statistics for a Multivariate Linear Model
#'
#' @param x  A \code{"mlm"} object fitted by \code{link[stats]{lm}} with two or more response variable3s
#' @param ... Other arguments, ignored
#'
#' @return
#' @export
#'
#' @examples
uniStats <- function(x, ...) {
  if (!inherits(x, "mlm")) stop("This function is only for 'mlm' objects")
  SS <- summary(x)
  nr <- length(SS)
  result <- as.data.frame(matrix(0, nrow=nr, 5))
  for (i in 1:nr) {
    result[i,1] <- SS[[i]]$r.squared
    f <- SS[[i]]$fstatistic
    result[i,2:4] <- f
    result[i,5] <- pf(f[1], f[2], f[3], lower.tail=FALSE)
  }
  
  colnames(result) <- c("R^2", "F", "df1", "df2", "Pr(>F)")
  resp <- sub("Response ", "", names(SS)) 
  rownames(result) <- resp

  class(result) <- c("anova", "data.frame")
  xname <- deparse(substitute(x))
  attr(result, "heading") <- paste("Univariate tests for responses in the 'mlm'", xname, "\n")
#  print(result, eps.Pvalue=eps, ...)
  result
  
}

if (FALSE) {
  
  data(Wine, package="candisc")
  Wine.mod <- lm(as.matrix(Wine[, -1]) ~ Cultivar, data=Wine)
  uniStats(Wine.mod)
  
  
ss <- summary(Wine.mod)
UniStats <- as.data.frame(matrix(0, nrow=length(ss), 5))
for (i in 1:length(ss)) {
  UniStats[i,1] <- ss[[i]]$r.squared
  f <- ss[[i]]$fstatistic
  UniStats[i,2:4] <- f
  UniStats[i,5] <- pf(f[1], f[2], f[3], lower.tail=FALSE)
}

rownames(UniStats) <- sub("Response ", "", names(ss))
UniStats$stars <- c(gtools:::stars.pval(UniStats[,5]))
UniStats[,5] <- format.pval(UniStats[,5], eps=0.001)
colnames(UniStats) <- c("R^2", "F", "df1", "df2", "Pr (>F)", "")
UniStats
}