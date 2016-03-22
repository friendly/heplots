#' Calculate confidence interval for log determinant of covariance matrices

#' @param cov a covariance matrix or a list of covariance matrices
#' @param n   sample size, or vector of sample sizes
#' @param conf  confidence level
#' @param method 
#' @param bias.adj logical, to include bias correction term

#' @reference Cai, T. T., Liang, T. & Zhou, H. H. (2016). Law of log determinant of sample
#'         covariance matrix and optimal estimation of differential enteropy
#'         for high-dimensional Gaussian distributions.   JMA, to appear.
#'         www.stat.yale.edu/~hz68/Covariance-Determinant.pdf

logdetCI <- function(cov, n, conf=0.95, method=2, bias.adj=TRUE) {
	p <- if (is.list(cov)) sapply(cov, nrow)
	     else nrow(cov)
	if (length(p) > 1)
		if (!all(p == p[1])) stop("all covariance matrices must be the same size")
		else p <- p[1]

	bias <- 0
	if (method==2) {  # corollary 2
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
	
####################  Testing #########################

TESTME <- FALSE

if (TESTME) {
# need latest R-Forge versions
if(!require(heplots))  install.packages("heplots", repos="http://R-Forge.R-project.org")
if(!require(candisc))  install.packages("candisc", repos="http://R-Forge.R-project.org")
library(heplots)
library(candisc)


### iris data

data(iris)
iris.mod <- lm(as.matrix(iris[,1:4]) ~ iris$Species)
iris.boxm <- boxM(iris.mod)
cov <- c(iris.boxm$cov, list(pooled=iris.boxm$pooled))
n <- c(rep(50, 3), 150)

CI <- logdetCI( cov, n=n, conf=.95, method=1, bias.adj=FALSE)
CI
plot(iris.boxm, xlim=c(-14, -8), main="Iris data, Box's M test", gplabel="Species")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)

### Skulls data

data(Skulls, package="heplots")
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
skulls.boxm <- boxM(skulls.mod)

plot(skulls.boxm, gplabel="Epoch")
cov <- c(skulls.boxm$cov, list(pooled=skulls.boxm$pooled))
n <- c(rep(29, 5), 145)
CI <- logdetCI( cov, n=n, conf=.95 )
CI
plot(skulls.boxm, xlim=c(9, 14), main="Skulls data, Box's M test", gplabel="Epoch")
arrows(CI$lower, 1:6, CI$upper, 1:6, lwd=3, angle=90, len=.1, code=3)


### Wine data

data(Wine, package="candisc")
Wine.mod <- lm(as.matrix(Wine[, -1]) ~ Cultivar, data=Wine)
wine.boxm <- boxM(Wine.mod)


cov <- c(wine.boxm$cov, list(pooled=wine.boxm$pooled))
n <- wine.boxm$df + c(1,1,1,3)

## Method of Corollary 2
CI <- logdetCI( cov, n=n, conf=.95 )
CI
plot(wine.boxm, xlim=c(-12, 0), main="Wine data, Box's M test", gplabel="Cultivar")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)

CI <- logdetCI( cov, n=n, conf=.95, bias.adj=FALSE)
CI
plot(wine.boxm, xlim=c(-12, 0), main="Wine data, Box's M test", gplabel="Cultivar")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)

## Method of Corollary 1

CI <- logdetCI( cov, n=n, conf=.95, method=1)
CI
plot(wine.boxm, xlim=c(-12, 0), main="Wine data, Box's M test", gplabel="Cultivar")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3)

CI <- logdetCI( cov, n=n, conf=.95, method=1, bias.adj=FALSE)
CI
plot(wine.boxm, xlim=c(-12, 0), main="Wine data, Box's M test")
arrows(CI$lower, 1:4, CI$upper, 1:4, lwd=3, angle=90, len=.1, code=3, gplabel="Cultivar")

}
