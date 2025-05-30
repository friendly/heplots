# coefplot method for an mlm object
#  - similar to car::confidence.ellipse, but displays ellipses
#    for all parameters in an mlm, for a given pair of variables
# Michael Friendly, last mod: 1/13/2013 1:32PM
# -- now allow ellipses to be filled
# -- now pass label.pos to label.ellipse

# TODO: Allow passing cex.lab. Doesn't work, possibly b/c conflict with cex.label.
# Calls for a refactoring: cex.label -> label.cex. Note: there is already label.pos



#' Coefficient plots for Multivariate Linear Models
#' 
#' Displays confidence ellipses for all parameters in an multivariate linear
#' model, for a given pair of variables.  As such, it is a generalization of
#' \code{\link[car]{confidenceEllipse}}.
#' 
#' 
#' @aliases coefplot coefplot.mlm
#' @param object A multivariate linear model, such as fit by \code{lm(cbind(y1,
#'             y2, ...) ~ terms, ...)}
#' @param \dots Other parameters passed to \code{\link[graphics]{plot}}
#' @param variables Response variables to plot, given as their indices or names
#' @param parm Parameters to plot, given as their indices or names
#' @param df Degrees of freedom for hypothesis tests
#' @param level Confidence level for the confidence ellipses
#' @param intercept logical. Include the intercept?
#' @param Scheffe If \code{TRUE}, confidence intervals for all parameters have
#'        Scheffe coverage, otherwise, individual coverage.
#' @param bars Draw univariate confidence intervals for each of the variables?
#' @param fill a logical value or vector. \code{TRUE} means the confidence
#'        ellipses will be filled.
#' @param fill.alpha Opacity of the confidence ellipses
#' @param labels Labels for the confidence ellipses
#' @param label.pos Positions of the labels for each ellipse.  See
#'        \code{\link{label.ellipse}}
#' @param xlab,ylab x, y axis labels
#' @param xlim,ylim Axis limits
#' @param axes Draw axes?
#' @param main Plot title
#' @param add logical. Add to an existing plot?
#' @param lwd Line widths
#' @param lty Line types
#' @param pch Point symbols for the parameter estimates
#' @param col Colors for the confidence ellipses, points, lines
#' @param cex Character size for points showing parameter estimates
#' @param cex.label Character size for ellipse labels
#' @param cex.lab Character size for axis labels. Defaults to \code{par("cex.lab")}.
#' @param lty.zero,col.zero,pch.zero Line type, color and point symbol for
#'        horizontal and vertical lines at 0, 0. These default to \code{lty.zero = 3},
#'        \code{col.zero = 1} (black) and \code{pch.zero = '+'}.
#' @param verbose logical.  Print parameter estimates and variance-covariance
#'        for each parameter?
#' @return Returns invisibly a list of the coordinates of the ellipses drawn
#' @author Michael Friendly
#' @seealso \code{\link[car]{confidenceEllipse}},
#' @keywords hplot
#' @examples
#' 
#' rohwer.mlm <- lm(cbind(SAT,PPVT,Raven)~n+s+ns, data=Rohwer)
#' 
#' coefplot(rohwer.mlm, lwd=2, 
#'          main="Bivariate coefficient plot for SAT and PPVT", fill=TRUE)
#' coefplot(rohwer.mlm, add=TRUE, Scheffe=TRUE, fill=TRUE)
#' 
#' coefplot(rohwer.mlm, var=c(1,3))
#' 
#' mod1 <- lm(cbind(SAT,PPVT,Raven)~n+s+ns+na+ss, data=Rohwer)
#' coefplot(mod1, lwd=2, fill=TRUE, parm=(1:5),
#' 	main="Bivariate 68% coefficient plot for SAT and PPVT", level=0.68)
#' 
#' 
#' @export coefplot
coefplot <- function(object, ...) {
	UseMethod("coefplot")
}

#' @rdname coefplot
#' @exportS3Method coefplot mlm
#' 
coefplot.mlm <- function(object, 
                         variables=1:2, 
                         parm=NULL, 
                         df = NULL, 
                         level = 0.95, 
                         intercept=FALSE, 
                         Scheffe=FALSE, 
                         bars=TRUE, 
                         fill=FALSE, fill.alpha=0.2,   # requires  trans.colors
                         labels = !add, 
                         label.pos = NULL,             # requires new version of label.ellipse
                         xlab, ylab,
                         xlim = NULL, ylim = NULL, 
                         axes=TRUE, 
                         main="", 
                         add=FALSE,
                         lwd = 1, lty = 1, pch = 19, col=palette(),
                         cex=2, cex.label=1.5,
                         cex.lab = par("cex.lab"),
                         lty.zero = 3, col.zero = 1, pch.zero = '+',
                         verbose=FALSE,
                         ...)
{

  vcovParm <- function(vcov, var, parm) {
#		which <- as.vector(t(outer( var, parm, paste, sep=":")))
  	which <- paste(var, parm, sep=':')
  	vcov[which, which]
  }

  ell <- function(center = rep(0,2) , shape = diag(2) , radius = 1, n = 100,
          angles = (0:n)*2*pi/n) {
         circle <- radius * cbind( cos(angles), sin(angles))
         t( c(center) + t( circle %*% chol(shape)))
  }


	# determine parameters to plot; allow parameters to be passed by names or numbers
  cf <- coef(object)
  if(!intercept) cf <- cf[-1,]

  if(is.null(parm)) parm <- 1:nrow(cf)
  if(is.numeric(parm) | is.logical(parm)) parm <- rownames(cf)[parm]
  if(is.character(parm)) parm <- which(rownames(cf) %in% parm)
  cf <- cf[parm, ]

  var.names <- colnames(cf)
  parm.names <- rownames(cf)
  nv <- length(var.names)
  np <- length(parm.names)

	# determine variables to plot;  allow variables to be passed by name or numbers
	if (!is.numeric(variables)) {
		vars <- variables
		variables <- match(vars, var.names)
		check <- is.na(variables)
		if (any(check)) stop(paste(vars[check], collapse=", "), 
					" not among response variables.") 
	}
	else {
		if (any (variables > length(var.names))) stop("There are only ", 
					length(var.names), " response variables.")
		vars <- var.names[variables]
	}

# TODO: handle the case of #variables !=2 ??
#	if (length(variables) != 2) {
#		extra <- if (length(variables) == 1) 'coefplot()' else 
#				if (length(variables) == 3) 'coefplot3d()' else 'pairs()'
#		stop(paste("You may only plot 2 response variables. Use", extra))
#	}

  
  cov <- vcov(object)

	#subset for the variables to plot
	cf  <- cf[,variables]
	var.names  <- var.names[variables]
	if (missing(xlab)) xlab <- paste(var.names[1], "coefficient")
	if (missing(ylab)) ylab <- paste(var.names[2], "coefficient") 
	
	if (is.logical(labels)) {
		parm.labels <- if (labels) parm.names else rep("", length.out=np)
	}
	else parm.labels <- rep(labels, length.out=np)
	
	# determine "size" of intervals [perhaps need importFrom(car, car:::df.terms, ...) in NAMESPACE?]
	# avoid ::: by including df.terms here (utility-car.R)
	if(is.null(df)) {
  	df <- if (Scheffe) sum(df.terms(object)) else 2
  }
  dfe <- df.residual(object)
	radius <- sqrt(df * qf(level, df, dfe)) 

  # need to calculate all the ellipses first to get limits
	ellList <- vector("list", np) 
	for (i in 1:np) {
		coef <- cf[i,]
		shape <- vcovParm(cov, var.names, parm.names[i])
		if (verbose) {
  		cat(parm.names[i],":\n")
  		print(coef)
  		print(shape)
		}
		ellList[[i]] <- ell(coef, shape, radius)
	}
	names(ellList) <- parm.names

#browser()

# find xlim, ylim
	max <- apply(emax <- sapply(ellList, function(X) apply(na.omit(X), 2, max)), 1, max)
	min <- apply(emin <- sapply(ellList, function(X) apply(na.omit(X), 2, min)), 1, min)
	xlim <- if(missing(xlim)) c(min[1], max[1]) else xlim
	ylim <- if(missing(ylim)) c(min[2], max[2]) else ylim

  if (!add) {
  	plot(xlim, ylim,  type = "n", 
  	     xlab=xlab, ylab=ylab, 
  	     main=main, axes=axes,
  	     cex.lab = cex.lab, ...)
#  	abline(h=0, lty=3)
#  	abline(v=0, lty=3)
  	mark.H0(col=col.zero, lty=lty.zero, pch='+', cex=cex)
	}
		

	lty <- rep(lty, length.out=np)
	lwd <- rep(lwd, length.out=np)
	col <- rep(col, length.out=np)
	pch <- rep(pch, length.out=np)
	fill <- rep(fill, length.out=np)
	fill.col <- trans.colors(col, fill.alpha)
	fill.col <- ifelse(fill, fill.col, NA)

	if (!is.null(label.pos)) label.pos <- rep(label.pos, length.out=np)

	for (parm in 1:np){
#			lines(ellList[[parm]], col=col[parm], lty=lty[parm], lwd=lwd[parm])
			polygon(ellList[[parm]], col=fill.col[parm], border=col[parm], lty=lty[parm], lwd=lwd[parm])
			points(cf[parm,1], cf[parm,2], col=col[parm], pch=pch[parm], cex=cex)
			if(labels) label.ellipse(ellList[[parm]], parm.labels[parm], 
			                         col=col[parm], cex=cex.label, label.pos=label.pos[parm])
			if (bars) {
				hxy <- matrix( c(emin[1,parm], emax[1,parm], rep(cf[parm,2], 2)), 2,2)
				vxy <- matrix( c(rep(cf[parm,1], 2), emin[2,parm], emax[2,parm]), 2,2)
				# could vary lwd if the bar excludes 0
				lines(hxy, col=col[parm], lwd=lwd[parm])
				lines(vxy, col=col[parm], lwd=lwd[parm])
			} 
		}   

	invisible(ellList)
}


# taken from car::utility-functions.R; should be imported into heplots
# but not sure how to do this
# [perhaps need importFrom(car, car:::df.terms, car:::df.terms.default, car:::is.aliased) in NAMESPACE?]

#df.terms <- function(model, term, ...){
#	UseMethod("df.terms")
#}
#
#df.terms.default <- function(model, term, ...){
#	if (is.aliased(model)) stop("Model has aliased term(s); df ambiguous.")
#	if (!missing(term) && 1 == length(term)){
#		assign <- attr(model.matrix(model), "assign")
#		which.term <- which(term == labels(terms(model)))
#		if (0 == length(which.term)) stop(paste(term, "is not in the model."))
#		sum(assign == which.term)
#	}
#	else {
#		terms <- if (missing(term)) labels(terms(model)) else term
#		result <- numeric(0)
#		for (term in terms) result <- c(result, Recall(model, term))
#		names(result) <- terms
#		result
#	}
#}
#
#is.aliased <- function(model){
#	!is.null(alias(model)$Complete)
#}


 
