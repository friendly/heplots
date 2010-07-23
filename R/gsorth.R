# Gram-Schmidt for a data frame or matrix
# Return a matrix/data frame with uncorrelated columns
#   recenter=TRUE -> result has same means as original, else means = 0 for cols 2:p
#   rescale=TRUE -> result has same sd as original, else, sd = residual sd
#   adjnames=TRUE -> colnames are adjusted to Y1, Y2.1, Y3.12, ...

gsorth <- function(y, order=1:p, recenter=TRUE, rescale=TRUE, adjnames=TRUE) {
#	num <- sapply(y, is.numeric)
	p <- ncol(y)
	z <- y <- y[,order]
	for (j in 2:p) {
		z[,j] <- resid( lm( z[,j] ~ as.matrix(z[,1:(j-1)]), data=z) )
		if (rescale) z[,j] <- z[,j] * sd(y[,j]) / sd(z[,j])
		if (recenter) z[,j] <- z[,j] + mean(y[,j])
		if (adjnames) colnames(z)[j] <- paste(colnames(z)[j], '.', sep="",
		                                      paste( 1:(j-1), collapse=""))
		}
	z
}
