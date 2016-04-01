colDevs <- function(x, group, center=mean,  ...) {

	if (!inherits(x, c("data.frame", "matrix")))
		stop("Argument 'x' must be a data.frame or matrix")

	if (missing(group)) {
		group <- factor(rep(1, nrow(x)))
	}
	
	if (!is.factor(group)) {
	warning(deparse(substitute(group)), " coerced to factor.")
	group <- as.factor(group)
	}
	
	nlev <- nlevels(group)
	lev <- levels(group)

	nums <- sapply(x, is.numeric)
	if (!all(nums)) {
		warning("Ignoring ", sum(!nums), " non-numeric column(s)")
		x <- x[, nums, drop=FALSE]
	}
	
	mat <- matrix(0, nrow(x), ncol(x), dimnames=dimnames(x))
	x <- as.matrix(x)
	for (i in 1:nlev) {
		rows <- which(group==lev[i])
		ctr <- apply( x[rows,], 2, center)
		mat[rows, ] <- sweep( x[rows, ], 2, ctr)
	}
	mat
}


