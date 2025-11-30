## 1D representation of an HE plot
# Initial version 17-Apr-2009
# Fixed buglet with hyp.labels 8-Dec-2009
# last modified 1 Jan 2010 by M. Friendly -- added idate=, idesign=, icontrasts, iterm for repeated measures




#' One-Dimensional HE Plots
#' 
#' This function plots a 1-dimensional representation of the hypothesis (H) and
#' error (E) sums-of-squares-and-products matrices for terms and linear
#' hypotheses in a multivariate linear model.
#' 
#' In particular, for a given response, the 1-D representations of H and E
#' matrices correspond to line segments.  The E ``ellipse'' is shown as a
#' filled rectangle whose width equals the mean squared error for that
#' response.  The H ``ellipse'' for each model term is shown as a line segment
#' whose length represents either the size of the effect or the evidence for
#' that effect.
#' 
#' **This version is an initial sketch.  Details of the implementation are
#' subject to change.**
#' 
#' 
#' @aliases heplot1d heplot1d.mlm
#' @param mod a model object of class `"mlm"`.
#' @param terms a logical value or character vector of terms in the model for
#'           which to plot hypothesis matrices; if missing or `TRUE`, defaults to
#'           all terms; if `FALSE`, no terms are plotted.
#' @param hypotheses optional list of linear hypotheses for which to plot
#'           hypothesis matrices; hypotheses are specified as for the
#'           \code{\link[car]{linearHypothesis}} function in the `car` package; the
#'           list elements can be named, in which case the names are used.
#' @param term.labels logical value or character vector of names for the terms
#'           to be plotted. If `TRUE` (the default) the names of the terms are used;
#'           if `FALSE`, term labels are not plotted.
#' @param hyp.labels logical value or character vector of names for the
#'           hypotheses to be plotted. If `TRUE` (the default) the names of
#'           components of the list of hypotheses are used; if `FALSE`, hypothesis
#'           labels are not plotted.
#' @param variables indices or names of the two response variables to be
#'            plotted; defaults to `1:2`.
#' @param error.ellipse if `TRUE`, plot the error ellipse; defaults to
#'            `TRUE`, if the argument `add` is `FALSE` (see below).
#' @param factor.means logical value or character vector of names of factors
#'            for which the means are to be plotted, or `TRUE` or `FALSE`;
#'            defaults to `TRUE`, if the argument `add` is `FALSE` (see
#'            below).
#' @param grand.mean if `TRUE`, plot the centroid for all of the data;
#'            defaults to `TRUE`, if the argument `add` is `FALSE` (see
#'            below).
#' @param remove.intercept if `TRUE` (the default), do not plot the
#'            ellipse for the intercept even if it is in the MANOVA table.
#' @param type ``type'' of sum-of-squares-and-products matrices to compute; one
#'             of `"II"`, `"III"`, `"2"`, or `"3"`, where `"II"`
#'             is the default (and `"2"` is a synonym).
#' @param idata an optional data frame giving a factor or factors defining the
#'             intra-subject model for multivariate repeated-measures data.  See Details of
#'             \code{\link[car]{Anova}} for an explanation of the intra-subject design and
#'             for further explanation of the other arguments relating to intra-subject
#'             factors.
#' @param idesign a one-sided model formula using the ``data'' in idata and
#'             specifying the intra-subject design for repeated measure models.
#' @param icontrasts names of contrast-generating functions to be applied by
#'             default to factors and ordered factors, respectively, in the within-subject
#'            ``data''; the contrasts must produce an intra-subject model matrix in which
#'             different terms are orthogonal. The default is c("contr.sum", "contr.poly").
#' @param imatrix In lieu of `idata` and `idesign`, you can specify
#'             the intra-subject design matrix directly via `imatrix`, in the form of
#'             list of named elements.  Each element gives the columns of the
#'             within-subject model matrix for an intra-subject term to be tested, and must
#'             have as many rows as there are responses; the columns of the within-subject
#'             model matrix for *different* terms must be mutually orthogonal.
#' @param iterm For repeated measures designs, you must specify one
#'             intra-subject term (a character string) to select the SSPE (E) matrix used
#'             in the HE plot.  Hypothesis terms plotted include the `iterm` effect as
#'             well as all interactions of `iterm` with `terms`.
#' @param manova optional `Anova.mlm` object for the model; if absent a
#'             MANOVA is computed. Specifying the argument can therefore save computation
#'             in repeated calls.
#' @param size how to scale the hypothesis ellipse relative to the error
#'              ellipse; if `"evidence"`, the default, the scaling is done so that a
#'              ``significant'' hypothesis ellipse at level `alpha` extends outside of
#'              the error ellipse. `size = "significance"` is a synonym and does the same thing.
#'              If `"effect.size"`, the hypothesis ellipse is on the
#'              same scale as the error ellipse.
#' @param level equivalent coverage of ellipse  (assuming normally-distributed errors).
#'              This defaults to `0.68`, giving a standard 1 SD bivariate ellipse.
#' @param alpha significance level for Roy's greatest-root test statistic; if
#'              `size="evidence"` or `size="significance"`, then the hypothesis ellipse is scaled so that it
#'              just touches the error ellipse at the specified alpha level. A larger
#'              hypothesis ellipse *somewhere* in the space of the response variables
#'              therefore indicates statistical significance; defaults to `0.05`.
#' @param center.pch character to use in plotting the centroid of the data;
#'             defaults to `"|"`.
#' @param col a color or vector of colors to use in plotting ellipses; the
#'             first color is used for the error ellipse; the remaining colors --- recycled
#'             as necessary --- are used for the hypothesis ellipses.  A single color can
#'             be given, in which case it is used for all ellipses.  For convenience, the
#'             default colors for all heplots produced in a given session can be changed by
#'             assigning a color vector via `options(heplot.colors =c(...)`.
#'             Otherwise, the default colors are `c("red", "blue", "black",
#'             "darkgreen", "darkcyan", "magenta", "brown", "darkgray")`.
#' @param lty vector of line types to use for plotting the ellipses; the first
#'             is used for the error ellipse, the rest --- possibly recycled --- for the
#'             hypothesis ellipses; a single line type can be given. Defaults to `2:1`.
#' @param lwd vector of line widths to use for plotting the ellipses; the first
#'             is used for the error ellipse, the rest --- possibly recycled --- for the
#'             hypothesis ellipses; a single line width can be given. Defaults to `1:2`.
#' @param xlab x-axis label; defaults to name of the x variable.
#' @param main main plot label; defaults to `""`.
#' @param xlim x-axis limits; if absent, will be computed from the data.
#' @param axes Whether to draw the x, y axes; defaults to `TRUE`
#' @param offset.axes proportion to extend the axes in each direction if
#'             computed from the data; optional.
#' @param add if `TRUE`, add to the current plot; the default is
#'             `FALSE`.  If `TRUE`, the error ellipse is not plotted.
#' @param verbose if `TRUE`, print the MANOVA table and details of
#'             hypothesis tests; the default is `FALSE`.
#' @param \dots arguments to pass down to `plot`, `text`, and `points`.
#' 
#' @return The function invisibly returns an object of class `"heplot1d"`,
#' with coordinates for the various hypothesis ellipses and the error ellipse,
#' and the limits of the horizontal and vertical axes.  (No methods for
#' manipulating these objects are currently available.)
#' 
#' The components are: 
#' \item{H}{ranges for the hypothesis terms} 
#' \item{E}{range for E} 
#' \item{xlim}{x-axis limits}
#' 
#' @author Michael Friendly
#' @seealso 
#'    \code{\link[car]{Anova}}, \code{\link[car]{linearHypothesis}} for
#'       hypothesis tests in `mlm`s
#' 
#'    \code{\link{heplot}}, \code{\link{heplot3d}}, \code{\link{pairs.mlm}} for
#'       other HE plot methods
#' @keywords hplot aplot multivariate
#' @examples
#' 
#' ## Plastics data
#' plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
#' heplot1d(plastic.mod, col=c("pink","blue"))
#' heplot1d(plastic.mod, col=c("pink","blue"),variables=2)
#' heplot1d(plastic.mod, col=c("pink","blue"),variables=3)
#' 
#' ## Bees data
#' bees.mod <- lm(cbind(Iz,Iy) ~ caste*treat*time, data=Bees)
#' heplot1d(bees.mod)
#' heplot1d(bees.mod, variables=2)
#' 
#' 
#' @export heplot1d
heplot1d <-
function(mod, ...) UseMethod("heplot1d")


#' @rdname heplot1d
#' @exportS3Method heplot1d mlm
heplot1d.mlm <-
		function ( 
				mod,           # an mlm object
				terms,         # vector of terms to plot H ellipses
				hypotheses,    # list of linear hypotheses for which to plot H ellipses
				term.labels=TRUE,  # TRUE, FALSE or a vector of term labels of length(terms)
				hyp.labels=TRUE,   # as above for term.labels
				variables=1,       # x,y variables for the plot [variable names or numbers]
				error.ellipse=!add,
				factor.means=!add,
				grand.mean=!add,
				remove.intercept=TRUE,
				type=c("II", "III", "2", "3"),
				idata=NULL,
				idesign=NULL,
				icontrasts=c("contr.sum", "contr.poly"),
				imatrix=NULL,
				iterm=NULL,
				manova,        # an optional Anova.mlm object
				size=c("evidence", "effect.size", "significance"),
				level=0.68,
				alpha=0.05,
				center.pch="|",   # doesn't have to be an argument
				col=getOption("heplot.colors", c("red", "blue", "black", "darkgreen", "darkcyan",
				                                 "magenta", "brown","darkgray")),
				# colors for H matrices, E matrix
				lty=2:1,
				lwd=1:2,
				xlab,
				main="",
				xlim,           # min/max for X (override internal min/max calc) 
				axes=TRUE,      # whether to draw the axes
				offset.axes=0.1,    # proportion by which to expand the axes on each end (e.g., .05)
				add=FALSE,      # add to existing plot?
				verbose=FALSE,
				...) {

	ell1d <- function(center, shape, radius) {
		circle <- radius * c(-0.5, 0.5)
		center + sqrt(shape) * circle 
	}
	F.crit <- function(alpha, p, dfh, dfe) {
		(dfh/dfe) * qf(alpha, dfh, dfe, lower.tail=FALSE)
	}

	#if (!require(car)) stop("car package is required.")
	#if (car2 <- packageDescription("car")[["Version"]] >= 2) linear.hypothesis <- linearHypothesis
	type <- match.arg(type)
	size <- match.arg(size)
	data <- model.frame(mod)

#	if (missing(manova)) manova <- Anova(mod, type=type)    
	if (missing(manova)) {
		if (is.null(imatrix)) {
			manova <- car::Anova(mod, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts)
		}
		else {
			manova <- car::Anova(mod, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts, imatrix=imatrix)
		} 
	}   
	
#	if (verbose) print(manova)    

	if (is.null(idata) && is.null(imatrix)) {
		Y <- model.response(data) 
		SSPE <- manova$SSPE
	} 
	else {
		if (is.null(iterm)) stop("Must specify a within-S iterm for repeated measures designs" )
		### FIXME::car -- workaround for car::Anova.mlm bug: no names assigned to $P component
		if (is.null(names(manova$P))) names(manova$P) <- names(manova$SSPE)
		Y <- model.response(data) %*% manova$P[[iterm]]
		SSPE <- manova$SSPE[[iterm]]
	}   
	if (!is.null(rownames(SSPE))) {response.names <- rownames(SSPE)}
	else {response.names <- paste("V.", 1:nrow(SSPE), sep="")}
	p <- length(response.names)
	
	if (!is.numeric(variables)) {
		vars <- variables
		variables <- match(vars, response.names)
		check <- is.na(variables)
		if (any(check)) stop(paste(vars[check], collapse=", "), 
					" not among response variables.") 
	}
	else {
		if (any (variables > length(response.names))) stop("There are only ", 
					length(response.names), " response variables.")
		vars <- response.names[variables]
	}

### Allow for more than one variable?
	if (length(variables) != 1) {
#		stop(paste("You may only plot 1 response variable."))
		extra <- if (length(variables) == 2) 'heplot()' else 
			if (length(variables) == 3) 'heplot3d()' else 'pairs()'
		stop(paste("You may only plot 1 response variable. Try", extra))
	}

	if (missing(terms) || (is.logical(terms) && terms)) {
		terms <- manova$terms
# FIXME:  This does mot work if the between-S design includes only an intercept 
# FIXME: && terms="(Intercept)" is specified
		if (!is.null(iterm)) {
#			if (terms=="(Intercept)")  terms <- iterm else 
			terms <- terms[grep(iterm, terms)]   ## only include those involving iterm
		}
		if (remove.intercept) terms <- terms[terms != "(Intercept)"]
	}
	
	n.terms <- if (!is.logical(terms)) length(terms) else 0 
	# note: if logical here, necessarily FALSE
	n.hyp <- if (missing(hypotheses)) 0 else length(hypotheses)
	n.ell <- n.terms + n.hyp
	if (n.ell == 0) stop("Nothing to plot.")

	Y <- Y[,vars] 
	gmean <- if (missing(data))  0 else mean(Y)
#			else colMeans(Y)

	if (missing(xlab)) xlab <- vars[1]
	dfe <- manova$error.df
	scale <- 1/dfe
#	radius <- sqrt(2 * qf(level, 2, dfe))
	radius <- sqrt(    qf(level, 1, dfe))

	# assign colors and line styles
	col <- he.rep(col, n.ell); E.col<- col[length(col)]
	lty <- he.rep(lty, n.ell)
	lwd <- he.rep(lwd, n.ell)

	# plot the 1D representations of the terms on equally spaced lines
	yvals <- 1:n.ell

	H.ellipse <- as.list(rep(0, n.ell))
	if (n.terms > 0) for (term in 1:n.terms){
			term.name <- terms[term]
			H <- manova$SSP[[term.name]]
			H <- H[variables, variables]
			dfh <- manova$df[term.name]
			factor <- if (size == "evidence") F.crit(alpha, p, dfh, dfe) else 1
			H <- H * scale/factor
			if (verbose){
				cat(term.name, " H matrix (", dfh, " df):\n")
				print(H)
			}
			H.ellipse[[term]] <- ell1d(gmean, H, radius)
			if(verbose) {cat(term.name, "H range:\n"); print(H.ellipse[[term]])}
		}
	if (n.hyp > 0) for (hyp in 1:n.hyp){
#			lh <- linear.hypothesis(mod, hypotheses[[hyp]])
			lh <- car::linearHypothesis(mod, hypotheses[[hyp]])
			H <- lh$SSPH[variables, variables]
			dfh <- lh$df
			factor <- if (size == "evidence") F.crit(alpha, p, dfh, dfe) else 1
			H <- H * scale/factor
			if (verbose){
				cat("\n\n Linear hypothesis: ", names(hypotheses)[[hyp]], "\n") 
				print(lh)
			}
			H.ellipse[[n.terms + hyp]] <- ell1d(gmean, H, radius)
		}
	E <- SSPE
	E <- E[variables, variables]
	E <- E * scale[1]
	E.ellipse <- ell1d(gmean, E, radius)
	H.ellipse$E <- E.ellipse     

	if (!add){
#		max <- apply(sapply(H.ellipse, function(X) apply(X, 2, max)), 1, max)
#		min <- apply(sapply(H.ellipse, function(X) apply(X, 2, min)), 1, min)
		max <- max(sapply(H.ellipse, max))
		min <- min(sapply(H.ellipse, min))

		factors <- data[, sapply(data, is.factor), drop=FALSE]
		if (!is.logical(factor.means)){
			factor.names <- colnames(factors) 
			which <- match(factor.means, factor.names)
			check <- is.na(which)
			if (any(check)) stop(paste(factor.means[check], collapse=", "), 
						" not among factors.")
			factors <- factors[, which, drop=FALSE]
		}
		if (!is.logical(factor.means) || factor.means){   
			for (fac in factors){
				means <- aggregate(Y, list(fac), mean)
				min <- min(min, means[,2])
				max <- max(max, means[,2])
			}
		}
		if (!missing(offset.axes)){
			range <- max - min
			min <- min - offset.axes*range
			max <- max + offset.axes*range
		}
		xlim <- if(missing(xlim)) c(min[1], max[1]) else xlim
#		ylim <- if(missing(ylim)) c(min[2], max[2]) else ylim
		plot(xlim, range(yvals),  type = "n", xlab=xlab, 
				ylab=if (n.hyp>0) "Terms and Hypotheses" else "Terms", yaxt="n",
				main=main, axes=axes, ...)
	}

	H.ellipse$E <- NULL
	if (error.ellipse){
#		lines(E.ellipse, col=E.col, lty=lty[length(lty)], lwd=lwd[length(lwd)])
		rect(E.ellipse[1], 0.5, E.ellipse[2], n.ell+0.5, 
		col=E.col, lty=lty[length(lty)], lwd=lwd[length(lwd)], border=NA)
#		label.ellipse(E.ellipse, "Error", col=E.col)
	}
	if (grand.mean) 
		points(rep(gmean,n.ell), 1:n.ell, pch=center.pch, cex=2, col="black", xpd=TRUE)

	term.labels <- if (n.terms == 0) NULL
			else if (!is.logical(term.labels)) term.labels
			else if (term.labels) terms else rep("", n.terms)  
	if (n.terms > 0) for (term in 1:n.terms){
			lines(x=H.ellipse[[term]], y=rep(term,2), col=col[term], lty=lty[term], lwd=lwd[term])
#			label.ellipse(H.ellipse[[term]], term.labels[term], col=col[term]) 
			text(xlim[1],term, term.labels[term], col=col[term], adj=c(0,0))
			term.name <- terms[term]
			means <- termMeans(mod, term.name, label.factors=FALSE)
			points(means[,vars], rep(term,nrow(means)), pch=16, xpd=TRUE, ...)
			widths <- strwidth(rownames(means))
# TODO: determin pos based on whether there is overlap of labels
			pos <- rep(c(1,3),length=nrow(means))
			text(means[,vars], rep(term,nrow(means)), labels=rownames(means), 
					pos=pos, xpd=TRUE, ...)
			if (verbose){
				cat("\n",term.name, " means:\n")
				print(means[,vars,drop=FALSE])
			}
		}   
	hyp.labels <- if (n.hyp == 0) NULL
			else if (!is.logical(hyp.labels)) hyp.labels
			else if (hyp.labels) names(hypotheses) else rep("", n.hyp)  
	if (n.hyp > 0) for (hyp in 1:n.hyp){
			term <- n.terms + hyp
			lines(x=H.ellipse[[term]], y=rep(term,2), col=col[term], lty=lty[term], lwd=lwd[term])
#			label.ellipse(H.ellipse[[term]], hyp.labels[hyp], col=col[term])
			text(xlim[1],term, hyp.labels[term], col=col[term], adj=c(0,0))
		}

#	if (!add && (!is.logical(factor.means) || factor.means)){
#		line <- 0
#		for (fac in factors){
#			line <- line+1
#			means <- aggregate(Y, list(fac), mean)
#			if (verbose){
#				cat(colnames(factors)[fac], " means:\n")
#				print(means)
#			}
#			points(means[,2], rep(line,nrow(means)), pch=16, xpd=TRUE, ...)
#			text(means[,2], rep(line,nrow(means)), labels=as.character(means[,1]), 
#					pos=rep(c(1,3),length=nrow(means)), xpd=TRUE, ...)
#		}
#	}

	names(H.ellipse) <- c(if (n.terms > 0) term.labels, if (n.hyp > 0) hyp.labels)
	result <- if (!add) list(H=H.ellipse, E=E.ellipse, xlim=xlim)	else list(H=H.ellipse, E=E.ellipse)
	class(result) <- "heplot1d"
	invisible(result)

}

