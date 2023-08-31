# Revisions:
# -  Now allow to plot multiple variables in a scatterplot matrix format 3/30/2016 10:53:05 AM

# Draw covariance ellipses for one or more groups



#' Draw classical and robust covariance ellipses for one or more groups
#' 
#' The function draws covariance ellipses for one or more groups and optionally
#' for the pooled total sample.  It uses either the classical product-moment
#' covariance estimate, or a robust alternative, as provided by
#' \code{\link[MASS]{cov.rob}}. Provisions are provided to do this for more
#' than two variables, in a scatterplot matrix format.
#' 
#' These plot methods provide one way to visualize possible heterogeneity of
#' within-group covariance matrices in a one-way MANOVA design. When covariance
#' matrices are nearly equal, their covariance ellipses should all have the
#' same shape.  When centered at a common mean, they should also all overlap.
#' 
#' The can also be used to visualize the difference between classical and
#' robust covariance matrices.
#' 
#' @aliases covEllipses covEllipses.boxM covEllipses.data.frame
#'          covEllipses.matrix covEllipses.default
#' @param x The generic argument. For the default method, this is a list of
#' covariance matrices. For the \code{data.frame} and \code{matrix} methods,
#' this is a numeric matrix of two or more columns supplying the variables to
#' be analyzed.
#' @param group a factor defining groups, or a vector of length
#' \code{n=nrow(x)} doing the same. If missing, a single covariance ellipse is
#' drawn.
#' @param pooled Logical; if \code{TRUE}, the pooled covariance matrix for the
#' total sample is also computed and plotted
#' @param method the covariance method to be used: classical product-moment
#' (\code{"classical"}), or minimum volume ellipsoid (\code{"mve"}), or minimum
#' covariance determinant (\code{"mcd"}).
#' @param means For the default method, a matrix of the means for all groups
#' (followed by the grand means, if \code{pooled=TRUE}). Rows are the groups,
#' and columns are the variables. It is assumed that the means have column
#' names corresponding to the variables in the covariance matrices.
#' @param df For the default method, a vector of the degrees of freedom for the
#' covariance matrices
#' @param labels Either a character vector of labels for the groups, or
#' \code{TRUE}, indicating that group labels are taken as the names of the
#' covariance matrices. Use \code{labels=""} to suppress group labels, e.g.,
#' when \code{add=TRUE}
#' @param variables indices or names of the response variables to be plotted;
#' defaults to \code{1:2}.  If more than two variables are supplied, the
#' function plots all pairwise covariance ellipses in a scatterplot matrix
#' format.
#' @param level equivalent coverage of a data ellipse for normally-distributed
#' errors, defaults to \code{0.68}.
#' @param segments number of line segments composing each ellipse; defaults to
#' \code{40}.
#' @param center If \code{TRUE}, the covariance ellipses are centered at the
#' centroid.
#' @param center.pch character to use in plotting the centroid of the data;
#' defaults to \code{"+"}.
#' @param center.cex size of character to use in plotting the centroid of the
#' data; defaults to \code{2}.
#' @param col a color or vector of colors to use in plotting ellipses ---
#' recycled as necessary A single color can be given, in which case it is used
#' for all ellipses.  For convenience, the default colors for all plots
#' produced in a given session can be changed by assigning a color vector via
#' \code{options(heplot.colors =c(...)}.  Otherwise, the default colors are
#' \code{c("red", "blue", "black", "darkgreen", "darkcyan", "magenta", "brown",
#' "darkgray")}.
#' @param lty vector of line types to use for plotting the ellipses; the first
#' is used for the error ellipse, the rest --- possibly recycled --- for the
#' hypothesis ellipses; a single line type can be given. Defaults to
#' \code{2:1}.
#' @param lwd vector of line widths to use for plotting the ellipses; the first
#' is used for the error ellipse, the rest --- possibly recycled --- for the
#' hypothesis ellipses; a single line width can be given. Defaults to
#' \code{1:2}.
#' @param fill A logical vector indicating whether each ellipse should be
#' filled or not.  The first value is used for the error ellipse, the rest ---
#' possibly recycled --- for the hypothesis ellipses; a single fill value can
#' be given.  Defaults to FALSE for backward compatibility. See Details below.
#' @param fill.alpha Alpha transparency for filled ellipses, a numeric scalar
#' or vector of values within \code{[0,1]}, where 0 means fully transparent and
#' 1 means fully opaque. Defaults to 0.3.
#' @param label.pos Label position, a vector of integers (in \code{0:4}) or
#' character strings (in \code{c("center", "bottom", "left", "top", "right")})
#' use in labeling ellipses, recycled as necessary.  Values of 1, 2, 3 and 4,
#' respectively indicate positions below, to the left of, above and to the
#' right of the max/min coordinates of the ellipse; the value 0 specifies the
#' centroid of the \code{ellipse} object.  The default, \code{label.pos=NULL}
#' uses the correlation of the \code{ellipse} to determine "top" (r>=0) or
#' "bottom" (r<0).
#' @param xlab x-axis label; defaults to name of the x variable.
#' @param ylab y-axis label; defaults to name of the y variable.
#' @param vlabels Labels for the variables can also be supplied through this
#' argument, which is more convenient when \code{length(variables) > 2}.
#' @param var.cex character size for variable labels in the pairs plot
#' @param main main plot label; defaults to \code{""}, and presently has no
#' effect.
#' @param xlim x-axis limits; if absent, will be computed from the data.
#' @param ylim y-axis limits; if absent, will be computed from the data.
#' @param axes Whether to draw the x, y axes; defaults to \code{TRUE}
#' @param offset.axes proportion to extend the axes in each direction if
#' computed from the data; optional.
#' @param add if \code{TRUE}, add to the current plot; the default is
#' \code{FALSE}. This argument is has no effect when more than two variables
#' are plotted.
#' @param \dots Other arguments passed to the default method for \code{plot},
#' \code{text}, and \code{points}
#' @return Nothing is returned.  The function is used for its side-effect of
#' producing a plot. %Returns invisibly an object of class \code{"covEllipse"},
#' %which is a list of the coordinates for the ellipses drawn.
#' @author Michael Friendly
#' @seealso \code{\link{heplot}}, \code{\link{boxM}},
#' 
#' \code{\link[MASS]{cov.rob}}
#' @keywords hplot
#' @examples
#' 
#' 
#' data(iris)
#' 
#' # compare classical and robust covariance estimates
#' covEllipses(iris[,1:4], iris$Species)
#' covEllipses(iris[,1:4], iris$Species, fill=TRUE, method="mve", add=TRUE, labels="")
#' 
#' # method for a boxM object	
#' x <- boxM(iris[, 1:4], iris[, "Species"])
#' x
#' covEllipses(x, fill=c(rep(FALSE,3), TRUE) )
#' covEllipses(x, fill=c(rep(FALSE,3), TRUE), center=TRUE, label.pos=1:4 )
#' 
#' # method for a list of covariance matrices
#' cov <- c(x$cov, pooled=list(x$pooled))
#' df <- c(table(iris$Species)-1, nrow(iris)-3)
#' covEllipses(cov, x$means, df, label.pos=3, fill=c(rep(FALSE,3), TRUE))
#'  
#' covEllipses(cov, x$means, df, label.pos=3, fill=c(rep(FALSE,3), TRUE), center=TRUE)
#' 
#' # scatterplot matrix version
#' covEllipses(iris[,1:4], iris$Species, 
#' 	fill=c(rep(FALSE,3), TRUE), variables=1:4, 
#' 	fill.alpha=.1)
#' 
#' 
#' @export covEllipses
covEllipses <-function(x, ...) {
	UseMethod("covEllipses")
}

covEllipses.data.frame <-
		function(x, group,
		         pooled=TRUE, 
		         method = c("classical", "mve", "mcd"), ...) {

 method <- match.arg(method)
 
 if (missing(group)) {
   group <- factor(rep(1, nrow(x)))
   pooled <- FALSE
 }

 if (!is.factor(group)) {
   warning(deparse(substitute(group)), " coerced to factor.")
   group <- as.factor(group)
 }
 
 p <- ncol(x)
 nlev <- nlevels(group)
 lev <- levels(group)
 dfs <- tapply(group, group, length) - 1
 mats <- list()
 means <- matrix(0, nrow=nlev, ncol=p) 
 for(i in 1:nlev) {
 		rcov <- MASS::cov.rob(x[group == lev[i], ], method=method)
    mats[[i]] <- rcov$cov
    means[i,] <- rcov$center
 }

 names(mats) <- lev
 rownames(means) <- lev
 colnames(means) <- colnames(x)

 if(pooled) {
   mns <- colMeans(x)
   x <- colDevs(x, group)
	 rcov <- MASS::cov.rob(x, method=method)
	 pooled <- rcov$cov
	 mats <- c(mats, pooled=list(pooled))
	 means <- rbind(means, pooled=mns)
	 dfs <- c(dfs, sum(dfs))
 }

   covEllipses.default(mats, means, dfs, ...)

}

covEllipses.matrix <- covEllipses.data.frame

covEllipses.formula <- function(x, data, ...)
{
  form <- x
  mf <- model.frame(form, data)
  if (any(sapply(2:dim(mf)[2], function(j) is.numeric(mf[[j]])))) 
    stop("covEllipses is not appropriate with quantitative explanatory variables.")
  
  x <- mf[,1]
  if (dim(x)[2] < 2) stop("There must be two or more response variables.")
  
  if(dim(mf)[2]==2) group <- mf[,2]
  else {
    if (length(grep("\\+ | \\| | \\^ | \\:",form))>0) stop("Model must be completely crossed formula only.")
    group <- interaction(mf[,2:dim(mf)[2]])
  }
  covEllipses.data.frame(x=x, group=group, ...)
}

# boxM method
covEllipses.boxM <-
  function(x, ...) {
    
    cov <- c(x$cov, pooled=list(x$pooled))
    mns <- x$means
    df <- x$df
    covEllipses.default(cov, mns, df, ...)
  }


covEllipses.default <-
		function ( 
		    x,                 # a list of covariance matrices
		    means,             # a matrix of means
		    df,                # vector of degrees of freedom
		    labels=NULL,
				variables=1:2,     # x,y variables for the plot [variable names or numbers]
				level=0.68,
				segments=60,       # line segments in each ellipse
				center = FALSE,    # center the ellipses at c(0,0)?
				center.pch="+",  
				center.cex=2,
				col=getOption("heplot.colors", c("red", "blue", "black", "darkgreen", "darkcyan", "brown", 
				                                 "magenta", "darkgray")),
				# colors for ellipses
				lty=1,
				lwd=2,
				fill=FALSE,         ## whether to draw filled ellipses (vectorized)
				fill.alpha=0.3,     ## alpha transparency for filled ellipses
				label.pos=0,    # label positions: NULL or 0:4
				xlab,
				ylab,
				vlabels,
				var.cex=2,
				main="",
				xlim,           # min/max for X (override internal min/max calc) 
				ylim,
				axes=TRUE,      # whether to draw the axes
				offset.axes,    # if specified, the proportion by which to expand the axes on each end (e.g., .05)
				add=FALSE,      # add to existing plot?
				...) 
{

	ell <- function(center, shape, radius) {
		angles <- (0:segments)*2*pi/segments
		circle <- radius * cbind( cos(angles), sin(angles))
		warn <- options(warn=-1)
		on.exit(options(warn))
		Q <- chol(shape, pivot=TRUE)
		order <- order(attr(Q, "pivot"))
		t( c(center) + t( circle %*% Q[,order]))
	}

	if (!is.list(x)) stop("Argument 'x' must be a list of covariance matrices")
	cov <- x
	response.names <- colnames(cov[[1]])
	p <- ncol(cov[[1]])

	if (!is.numeric(variables)) {
		vars <- variables
		variables <- match(vars, response.names)
		check <- is.na(variables)
		if (any(check)) stop(paste(vars[check], collapse=", "), 
					" not among response variables.") 
	}
	else {
		if (any (variables > p)) stop("There are only ", 	p, " response variables among", variables)
		vars <- response.names[variables]
	}
	n.ell <- length(cov)
	if (n.ell == 0) stop("Nothing to plot.")
	if (n.ell != nrow(means)) 
	    stop( paste0("number of covariance matrices (", n.ell, ") does not conform to rows of means (", nrow(means), ")") )
	if (n.ell != length(df)) 
	  stop( paste0("number of covariance matrices (", n.ell, ") does not conform to df (", length(df), ")") )
	
	# assign colors and line styles
	rep_fun <- rep_len
	col <- rep_fun(col, n.ell) 
	lty <- rep_fun(lty, n.ell)
	lwd <- rep_fun(lwd, n.ell)
	# handle filled ellipses
	fill <- rep_fun(fill, n.ell)
	fill.alpha <- rep_fun(fill.alpha, n.ell)
	fill.col <- trans.colors(col, fill.alpha)
	label.pos <- rep_fun(label.pos, n.ell)
	fill.col <- ifelse(fill, fill.col, NA)
	
	panel_covEllipses <- function(vars, xlab, ylab, xlim, ylim, offset.axes) {
		if (missing(xlab)) xlab <- vars[1]
		if (missing(ylab)) ylab <- vars[2] 
	
		radius <- c(sqrt(2 * qf(level, 2, df)))
		ellipses <- as.list(rep(0, n.ell))
		for(i in 1:n.ell) {
			S <- as.matrix(cov[[i]])
			S <- S[vars, vars]
			ctr <- if (center)  c(0,0)
			       else as.numeric(means[i, vars])
			ellipses[[i]] <- ell(ctr, S, radius[i])
		}
		
		if (!add){
			max <- apply(sapply(ellipses, function(X) apply(X, 2, max)), 1, max)
			min <- apply(sapply(ellipses, function(X) apply(X, 2, min)), 1, min)
	
			if (!missing(offset.axes)){
				range <- max - min
				min <- min - offset.axes*range
				max <- max + offset.axes*range
			}
			xlim <- if(missing(xlim)) c(min[1], max[1]) else xlim
			ylim <- if(missing(ylim)) c(min[2], max[2]) else ylim
			plot(xlim, ylim,  type = "n", xlab=xlab, ylab=ylab, main=main, axes=axes, ...)
		}
	
		labels <- if (!is.null(labels)) labels
				else names(cov)
		names(ellipses) <- labels
	
		for (i in 1:n.ell){
				polygon(ellipses[[i]], col=fill.col[i], border=col[i],  lty=lty[i], lwd=lwd[i])
				label.ellipse(ellipses[[i]], labels[i], col=col[i], label.pos=label.pos[i], ...) 
				if (!center) 
					points(means[i,vars[1]], means[i,vars[2]], pch=center.pch, cex=center.cex, col=col[i], xpd=TRUE)
			}
		if (center) points( 0, 0, pch=center.pch, cex=center.cex, col=gray(.25))
	}
	
	vlabels <- if (!missing(vlabels)) vlabels else vars
	if (length(vars)==2) {
		panel_covEllipses(vars, xlab=xlab, ylab=ylab, xlim=xlim, ylim=ylim, offset.axes=offset.axes)
	}
	else {
		nv <- length(vars)
		op <- par(mfcol=c(nv, nv), mar=c(1,1,0,0)+.1, xaxt='n', yaxt='n', ann=FALSE, oma=rep(0,4))
		on.exit( par(op) )
		for (i in 1:nv) {
			for (j in 1:nv) {
				if (i==j) {
					plot(c(0,1), c(0,1), type="n", axes=FALSE)
					text(0.5, 0.5, vlabels[i], cex=var.cex)
					box()
				}
				else {
					panel_covEllipses( vars[c(i,j)], xlab=xlab, ylab=ylab, xlim=xlim, ylim=ylim, offset.axes=offset.axes )
				}
			}
		}		
	}
	
#	result <- if (!add) list(ellipses, center=means, xlim=xlim, ylim=ylim, radius=radius)
#			else list(H=ellipses,  center=gmean, radius=radius)
#	result <- ellipses
#	class(result) <- "covEllipses"
#	invisible(result)
	
}

#if (FALSE) {
#op <- par(mfrow=c(4,4), mar=c(1,2,0,0)+.1, xaxt='n', yaxt='n', ann=FALSE)
#for (i in 1:4) {
#	for (j in 1:4) {
#		if (i==j) {
#			plot(c(0,1), c(0,1), type="n", axes=FALSE)
#			text(0.5, 0.5, vlab[i], cex=2.2)
#			box()
#		}
#		else {
#			covEllipses(Skulls[,-1], Skulls$epoch, variables=c(i,j),
#			            fill=c(rep(FALSE, 5), TRUE), label.pos=1:4,
#			            xlab=vlab[1], ylab=vlab[2], center=TRUE)
#			points(0, 0, pch='+', cex=2, col=gray(.25))
#		}
#	}
#}
#par(op)
#}
