

#' Calculate confidence interval for log determinant of covariance matrices
#' 
#' This function uses asymptotic results described by Cai et. al (2016),
#' Theorem 1, to calculate approximate, normal theory confidence intervals
#' (CIs) for the log determinant of one or more sample covariance matrices.
#' 
#' Their results are translated into a CI via the approximation 
#' \deqn{ \log det( \widehat{\Sigma} ) - bias \pm z_{1 - \alpha/2} \times SE } 
#' where \eqn{\widehat{\Sigma}} 
#' is the sample estimate of a population covariance matrix,
#' \eqn{bias} is a bias correction constant and \eqn{SE} is a width factor for
#' the confidence interval.  Both \eqn{bias} and \eqn{SE} are functions of the
#' sample size, \eqn{n} and number of variables, \eqn{p}.
#' 
#' This function is included here only to provide an approximation to
#' *graphical accuracy* for use with Box's M test for equality of
#' covariance matrices, \code{\link{boxM}} and its associated
#' \code{\link{plot.boxM}} method.
#' 
#' 
#' Cai et. al (2015) claim that their Theorem 1 holds with either \eqn{p} fixed
#' or \eqn{p(n)} growing with \eqn{n}, as long as \eqn{p(n) \le n}. Their
#' Corollary 1 (`method=2`) is the special case when \eqn{p} is fixed.
#' Their Corollary 2 (`method=3`) is the special case when \eqn{0 \le p/n
#' < 1} is fixed.
#' 
#' The properties of this CI estimator are unknown in small to moderate sample
#' sizes, but it seems to be the only one available.  It is therefore
#' experimental in this version of the package and is subject to change in the
#' future.
#' 
#' The \eqn{bias} term offsets the confidence interval from the sample estimate
#' of \eqn{ \log det( \widehat{\Sigma} ) }. When \eqn{p} is large relative to
#' \eqn{n}, the confidence interval may not overlap the sample estimate.
#' 
#' Strictly speaking, this estimator applies to the MLE of the covariance
#' matrix \eqn{ \widehat{\Sigma}}, i.e., using \eqn{n} rather than \eqn{n-1} in
#' as the divisor.  The factor \eqn{(n-1 / n)} has not yet been taken into
#' account here.
#' 
#' @param cov a covariance matrix or a (named) list of covariance matrices, all the same size
#' @param n sample size, or vector of sample sizes, one for each covariance matrix
#' @param conf confidence level
#' @param method Three methods are provided, based on Cai et. al Theorem 1
#'        (`method=1`), Corollary 1 (`method=2`) and Corollary 2
#'        (`method=3`), each with different bias and SE values.
#' @param bias.adj logical; set `FALSE` to exclude the bias correction term.
#' @return A data frame with one row for each covariance matrix. `lower`
#'        and `upper` are the boundaries of the confidence intervals. Other
#'        columns are `logdet, bias, se`. 
#'        
#' @author Michael Friendly
#' @seealso \code{\link{boxM}}, \code{\link{plot.boxM}}
#' @references
#' 
#' Cai, T. T.; Liang, T. & Zhou, H. H. (2015) Law of log determinant of sample
#' covariance matrix and optimal estimation of differential entropy for
#' high-dimensional Gaussian distributions. *Journal of Multivariate
#' Analysis*, 137, 161-172.
#' \doi{10.1016/j.jmva.2015.02.003}
#' @keywords manip
#' @examples
#' 
#' data(iris)
#' iris.mod <- lm(as.matrix(iris[,1:4]) ~ iris$Species)
#' iris.boxm <- boxM(iris.mod)
#' cov <- c(iris.boxm$cov, list(pooled=iris.boxm$pooled))
#' n <- c(rep(50, 3), 150)
#' 
#' CI <- logdetCI( cov, n=n, conf=.95, method=1)
#' CI
#' plot(iris.boxm, xlim=c(-14, -8), main="Iris data, Box's M test", gplabel="Species")
#' arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)
#' 
#' CI <- logdetCI( cov, n=n, conf=.95, method=1, bias.adj=FALSE)
#' CI
#' plot(iris.boxm, xlim=c(-14, -8), main="Iris data, Box's M test", gplabel="Species")
#' arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)
#' 
#' 
#' @export logdetCI
logdetCI <- function(cov, n, conf=0.95, method=1, bias.adj=TRUE) {
	p <- if (is.list(cov)) sapply(cov, nrow)
	     else nrow(cov)
	if (length(p) > 1)
		if (!all(p == p[1])) stop("all covariance matrices must be the same size")
		else p <- p[1]

	bias <- 0

	if (method==1) {  # Theorem 1
	  if (bias.adj) bias <- tau(n, p)
    se <- sigma(n, p)
  	}
	else if (method==2) {  # corollary 2
		if (bias.adj) {
			for (k in 1:p) bias <- bias + log( 1 - k/n)
		}
		se <- sqrt( -2 * log( 1 - p/n) )
	}
	else { # corollary 1
		if (bias.adj) bias <- p * (p+1) / (2*n)
		se <- sqrt(2 * p / n)
	}
	
	logdet <- if (is.list(cov)) sapply(cov, function(x) log( det(x) ))
	     else log( det(cov) )
	z <- qnorm((1-conf)/2, lower.tail=FALSE)
	lower <- (logdet - bias) - z * se
	upper <- (logdet - bias) + z * se
	
	result <- data.frame(logdet=logdet, bias=bias, se=se, lower=lower, upper=upper)
	result
}

# tau function, Eq(5), used as bias correction
tau <- function (n, p) {
	res <- 0
	for (k in 1:p) res <- res + (digamma( (n - k + 1) / 2) - log(n/2))
	return(res)
}	

# tau function, Eq(6), used as SE
sigma <- function (n, p) {
  res <- 0
  for (k in 1:p) res <- res + 2 / (n-k+1)
  return(sqrt(res))
}
	
