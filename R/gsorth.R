# Gram-Schmidt for a data frame or matrix
# Return a matrix/data frame with uncorrelated columns
#   recenter=TRUE -> result has same means as original, else means = 0 for cols 2:p
#   rescale=TRUE -> result has same sd as original, else, sd = residual sd
#   adjnames=TRUE -> colnames are adjusted to Y1, Y2.1, Y3.12, ...
#  12-5-2010:  Fixed buglet when matrix has no row/col names
#  10-14-2011: Made sd() a local function to avoid deprecated warnings



#' Orthogonalize successive columns of a data frame or matrix
#' 
#' \code{gsorth} uses sequential, orthogonal projections, as in the
#' Gram-Schmidt method, to transform a matrix or numeric columns of a data
#' frame into an uncorrelated set, possibly retaining the same column means and
#' standard deviations as the original.
#' 
#' In statistical applications, interpretation depends on the \code{order} of
#' the variables orthogonalized. In multivariate linear models, orthogonalizing
#' the response, Y variables provides the equivalent of step-down tests, where
#' Y1 is tested alone, and then Y2.1, Y3.12, etc. can be tested to determine
#' their additional contributions over the previous response variables.
#' 
#' Similarly, orthogonalizing the model X variables provides the equivalent of
#' Type I tests, such as provided by \code{\link[stats]{anova}}.
#' 
#' The method is equivalent to setting each of columns \code{2:p} to the
#' residuals from a linear regression of that column on all prior columns,
#' i.e.,
#' 
#' \code{z[,j] <- resid( lm( z[,j] ~ as.matrix(z[,1:(j-1)]), data=z) )}
#' 
#' However, for accuracy and speed the transformation is carried out using the
#' QR decomposition.
#' 
#' @param y A numeric data frame or matrix
#' @param order An integer vector specifying the order of and/or a subset of
#'        the columns of \code{y} to be orthogonalized. If missing, \code{order=1:p}
#'        where \code{p=ncol(y)}.
#' @param recenter If \code{TRUE}, the result has same column means as
#'        original; else means = 0 for cols \code{2:p}.
#' @param rescale If \code{TRUE}, the result has same column standard
#'        deviations as original; else sd = residual variance for cols \code{2:p}
#' @param adjnames If \code{TRUE}, the column names of the result are adjusted
#'        to the form Y1, Y2.1, Y3.12, by adding the suffixes '.1', '.12', etc. to the
#'        original column names.
#' @return Returns a matrix or data frame with uncorrelated columns.  Row and
#' column names are copied to the result. 
#' 
#' @author Michael Friendly
#' @seealso \code{\link[base]{qr}},
#' @keywords manip
#' @examples
#' 
#' GSiris <- gsorth(iris[,1:4])
#' GSiris <- gsorth(iris, order=1:4)   # same, using order
#' str(GSiris)
#' zapsmall(cor(GSiris))
#' colMeans(GSiris)
#' # sd(GSiris) -- sd(<matrix>) now deprecated
#' apply(GSiris, 2, sd)
#' 
#' # orthogonalize Y side
#' GSiris <- data.frame(gsorth(iris[,1:4]), Species=iris$Species)
#' iris.mod1 <- lm(as.matrix(GSiris[,1:4]) ~ Species, data=GSiris)
#' car::Anova(iris.mod1)
#' 
#' # orthogonalize X side
#' rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer)
#' car::Anova(rohwer.mod)
#' 
#' # type I tests for Rohwer data
#' Rohwer.orth <- cbind(Rohwer[,1:5], gsorth(Rohwer[, c("n", "s", "ns", "na", "ss")], adjnames=FALSE))
#' 
#' rohwer.mod1 <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer.orth)
#' car::Anova(rohwer.mod1)
#' # compare with anova()
#' anova(rohwer.mod1)
#' 
#' # compare heplots for original Xs and orthogonalized, Type I
#' heplot(rohwer.mod)
#' heplot(rohwer.mod1)
#' 
#' 
#' @export gsorth
gsorth <- function(y, order, recenter=TRUE, rescale=TRUE, adjnames=TRUE) {
	
	# local function sd(), since sd(<matrix>) and sd(<data.frame>) now deprecated
	sd <- function (x, na.rm = FALSE) 
	{
		if (is.matrix(x)) 
			apply(x, 2, sd, na.rm = na.rm)
		else if (is.vector(x)) 
			sqrt(var(x, na.rm = na.rm))
		else if (is.data.frame(x)) 
			sapply(x, sd, na.rm = na.rm)
		else sqrt(var(as.vector(x), na.rm = na.rm))
	}
	
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
	rownames(z) <- rownames(y, do.NULL=FALSE)
	colnames(z) <- colnames(y, do.NULL=FALSE)
	if (adjnames) {
		for (j in 2:p) {
			colnames(z)[j] <- paste(colnames(z)[j], '.', sep="",
					paste( 1:(j-1), collapse=""))
		}
	}
	z
}

