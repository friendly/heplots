# Univariate test statistics for a mlm

#' Univariate Test Statistics for a Multivariate Linear Model
#'
#' @param x  A `"mlm"` object fitted by \code{\link[stats]{lm}} with two or more response variables
#' @param ... Other arguments, ignored
#'
#' @return An object of class `c("anova", "data.frame")` containing, for each response variable
#'         the overall \eqn{R^2} for all terms in the model and the overall \eqn{F} statistic
#'         together with its degrees of freedom and p-value.
#' @seealso \code{\link{glance.mlm}}
#' @export
#'
#' @examples
#' iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
#' car::Anova(iris.mod)
#' uniStats(iris.mod)
#' 
#' data(Plastic, package = "heplots")
#' plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
#' # multivariate tests
#' car::Anova(plastic.mod)


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
  attr(result, "heading") <- paste("Univariate tests for responses in the multivariate linear model", xname, "\n")
#  print(result, eps.Pvalue=eps, ...)
  result
  
}

