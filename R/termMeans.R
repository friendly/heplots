#' Calculate Means for a Term in a Multivariate Linear Model
#' 
#' `termMeans` is a utility function designed to calculate means for the
#' levels of factor(s) for any term in a multivariate linear model.
#' 
#' 
#' @param mod An mlm model object
#' @param term A character string indicating a given term in the model. All
#'            factors in the term must be included in the model, even if they are in the
#'            model data frame.
#' @param label.factors If true, the rownames for each row in the result
#'            include the name(s) of the factor(s) involved, followed by the 
#'            level values. Otherwise, the rownames include only the levels of 
#'            the factor(s), with multiple factors separated by ':'
#' @param abbrev.levels Either a logical or an integer, specifying whether the
#'            levels values of the factors in the `term` are to be abbreviated in
#'            constructing the rownames.  An integer specifies the minimum length of the
#'            abbreviation for each factor in the term.
#' @return Returns a matrix whose columns correspond to the response variables
#'         in the model and whose rows correspond to the levels of the factor(s) in the
#'         `term`.
#' @author Michael Friendly
#' @seealso \code{\link[stats]{aggregate}}, \code{\link[base]{colMeans}}
#' 
#' \code{\link{statList}}, \code{\link{colMeansList}}
#' @keywords manip models
#' @examples
#' 
#' factors <- expand.grid(A=factor(1:3),B=factor(1:2),C=factor(1:2))
#' n <- nrow(factors)
#' responses <-data.frame(Y1=10+round(10*rnorm(n)),Y2=10+round(10*rnorm(n)))
#' test <- data.frame(factors, responses)
#' mod <- lm(cbind(Y1,Y2) ~ A*B, data=test)
#' 
#' termMeans(mod, "A")
#' termMeans(mod, "A:B")
#' termMeans(mod, "A:B", label.factors=TRUE)
#' \dontrun{
#' termMeans(mod, "A:B:C")    # generates an error
#' }
#' 
#' plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
#' colors = c("red", "darkblue", "darkgreen", "brown")
#' heplot(plastic.mod, col=colors, cex=1.25)
#' # add means for interaction term
#' intMeans <- termMeans(plastic.mod, 'rate:additive', abbrev=2)
#' points(intMeans[,1], intMeans[,2], pch=18, cex=1.2, col="brown")
#' text(intMeans[,1], intMeans[,2], rownames(intMeans), adj=c(0.5,1), col="brown")
#' 
#' 
#' 
#' @export termMeans
termMeans <- function(mod, term, label.factors=FALSE, abbrev.levels=FALSE){
	data <- model.frame(mod)
	Y <- model.response(data)
	factors <- data[, sapply(data, is.factor), drop=FALSE]
	if (missing(term)) stop("a term must be supplied")
	term.factors <- unlist(strsplit(term, ":"))
	if (any(which <- !term.factors %in% colnames(factors))) 
		stop(paste(term.factors[which], collapse=", "), " not in the model")
	n.factors <- length(term.factors)
	factor.values <- factors[,term.factors, drop=FALSE]
	rows <- nrow(levs <- unique(factor.values))
	means <-matrix(0, nrow=rows, ncol=ncol(Y))
	for (j in 1:ncol(Y)) {
		mn <- tapply(Y[,j], factor.values, mean)
		means[,j] <- as.vector(mn)
	}
	colnames(means) <- colnames(Y)
	nms <- colnames(levs)
	if (label.factors)
		for (j in 1:ncol(levs)) levs[,j] <- paste(nms[j], levs[,j], sep="")
	if (abbrev.levels) {
		if(is.logical(abbrev.levels)) levs <- apply(levs, 2, abbreviate)
		else levs <- apply(levs, 2, abbreviate, minlength=abbrev.levels)
	}
	levs <- apply(levs, 1, paste, collapse=":")
	rownames(means) <- levs
	means
}

