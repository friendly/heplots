# Gram-Schmidt for a data frame or matrix
# Return a matrix/data frame with uncorrelated columns
#   recenter=TRUE -> result has same means as original, else means = 0 for cols 2:p
#   rescale=TRUE -> result has same sd as original, else, sd = residual sd
#   adjnames=TRUE -> colnames are adjusted to Y1, Y2.1, Y3.12, ...

gsorth <- function(y, order, recenter=TRUE, rescale=TRUE, adjnames=TRUE) {
	n <- nrow(y)
	if (missing(order)) order <- 1:ncol(y)
	y <- y[,order]
	p <- ncol(y)
	
	if (is.data.frame(y)) {
		numeric <- unlist(lapply(y, is.numeric))
		if (!all(numeric)) stop("all columns of y must be numeric")
	}
	
	ybar <- colMeans(y)
	ysd <- sd(y)
	z <- scale(y, center=TRUE, scale=FALSE)
	z <- qr.Q(qr(z))
	zsd <- sd(z)
	if (rescale) z <- z %*% diag( ysd/zsd )
	if (recenter) z <- z + matrix(rep(ybar,times=n), ncol=p, byrow=TRUE)
	rownames(z) <- rownames(y)
	colnames(z) <- colnames(y)
	if (adjnames) {
		for (j in 2:p) {
			colnames(z)[j] <- paste(colnames(z)[j], '.', sep="",
					paste( 1:(j-1), collapse=""))
		}
	}
	z
}
