# last modified 23 January 2007 by J. Fox
# last modified 10/6/2008 8:32AM by M. Friendly
#    - added shade=, shade.alpha=, wire=
#    - fixed: grand.mean=FALSE not respected
#    - replaced sphere at grand.mean with cross3d
# last modified 10/7/2008 11:26AM by M. Friendly
#    - color means according to the color of the term
# last modified 10/15/2008 4:21PM by M. Friendly
#    - return bounding boxes of the ellipsoids
# last modified 10/28/2008 9:37AM by M. Friendly
#    - replaced rgl.texts with texts3d
#    - replaced ellipsoid() with spheres3d() for plotting means
# last modified 11/4/2008 12:50PM by M. Friendly
#    - reverted to ellipsoid() for plotting means
# last modified 11/6/2008 by M. Friendly
#    - added xlim, ylim, zlim arguments to allow expanding the plot bbox (for candisc)
# last modified 29 Dec 2009 by M. Friendly -- added idate=, idesign=, icontrasts, iterm for repeated measures
# last modified 30 Dec 2009 by M. Friendly -- debugged repeated measures
# last modified  1 Jan 2010 by M. Friendly -- debugged repeated measures again
# last modified  1 Jan 2010 by M. Friendly -- merged heplot3d.R and heplot.mlm.R
# last modified 12 Feb 2010 by M. Friendly -- fixed buglet with text3d causing rgl to crash (thx: Duncan Murdoch)
# last modified 23 Jul 2010 by M. Friendly -- return radius
# -- added err.label to allow changing label for Error ellipse
# last modified 26 Apr 2013 by M. Friendly 
# -- modified ellipsoid to reduce striation (Thx: Duncan Murdoch)
# -- changed default colors and default fill.alpha
# 10/20/2020 Fixed moire problem in heplot3d when dfh <3 (Thx: Duncan Murdoch)
# -- uses back="culled" & depth_mask=FALSE properties
# 9/22/2022  Add cex.label arg

# TODO what is this doing here?
savedvars <- new.env(parent=emptyenv())



#' Three-Dimensional HE Plots
#' 
#' This function plots ellipsoids in 3D representing the hypothesis and error
#' sums-of-squares-and-products matrices for terms and linear hypotheses in a
#' multivariate linear model.
#' 
#' When the H matrix for a term has rank < 3, the ellipsoid collapses to an
#' ellipse (rank(H)=2) or a line (rank(H)=1).
#' 
#' Rotating the plot can be particularly revealing, showing views in which H
#' variation is particularly large or small in relation to E variation.  See
#' \code{\link[rgl]{play3d}} and \code{\link[rgl]{movie3d}} for details on
#' creating animations.
#' 
#' The arguments \code{xlim}, \code{ylim}, and \code{zlim} can be used to
#' expand the bounding box of the axes, but cannot decrease it.
#' 
#' @aliases heplot3d heplot3d.mlm
#' @param mod a model object of class \code{"mlm"}.
#' @param terms a logical value or character vector of terms in the model for
#'        which to plot hypothesis matrices; if missing or \code{TRUE}, defaults to
#'        all terms; if \code{FALSE}, no terms are plotted.
#' @param hypotheses optional list of linear hypotheses for which to plot
#'        hypothesis matrices; hypotheses are specified as for the
#'        \code{\link[car]{linearHypothesis}} function in the \code{car} package; the
#'        list elements can be named, in which case the names are used.
#' @param term.labels logical value or character vector of names for the terms
#'        to be plotted. If \code{TRUE} (the default) the names of the terms are used;
#'        if \code{FALSE}, term labels are not plotted.
#' @param hyp.labels logical value or character vector of names for the
#'        hypotheses to be plotted. If \code{TRUE} (the default) the names of
#'        components of the list of hypotheses are used; if \code{FALSE}, hypothesis
#'        labels are not plotted.
#' @param err.label Label for the error ellipse
#' @param variables indices or names of the three response variables to be
#'        plotted; defaults to \code{1:3}.
#' @param error.ellipsoid if \code{TRUE}, plot the error ellipsoid; defaults to
#'        \code{TRUE}, if the argument \code{add} is \code{FALSE} (see below).
#' @param factor.means logical value or character vector of names of factors
#'        for which the means are to be plotted, or \code{TRUE} or \code{FALSE};
#'        defaults to \code{TRUE}, if the argument \code{add} is \code{FALSE} (see
#'        below).
#' @param grand.mean if \code{TRUE}, plot the centroid for all of the data;
#'        defaults to \code{TRUE}, if the argument \code{add} is \code{FALSE} (see
#'        below).
#' @param remove.intercept if \code{TRUE} (the default), do not plot the
#'        ellipsoid for the intercept even if it is in the MANOVA table.
#' @param type ``type'' of sum-of-squares-and-products matrices to compute; one
#'        of \code{"II"}, \code{"III"}, \code{"2"}, or \code{"3"}, where \code{"II"}
#'        is the default (and \code{"2"} is a synonym).
#' @param idata an optional data frame giving a factor or factors defining the
#'        intra-subject model for multivariate repeated-measures data.  See Details of
#'        \code{\link[car]{Anova}} for an explanation of the intra-subject design and
#'        for further explanation of the other arguments relating to intra-subject
#'        factors.
#' @param idesign a one-sided model formula using the ``data'' in idata and
#'        specifying the intra-subject design for repeated measure models.
#' @param icontrasts names of contrast-generating functions to be applied by
#'        default to factors and ordered factors, respectively, in the within-subject
#'        ``data''; the contrasts must produce an intra-subject model matrix in which
#'        different terms are orthogonal. The default is c("contr.sum", "contr.poly").
#' @param imatrix In lieu of \code{idata} and \code{idesign}, you can specify
#'        the intra-subject design matrix directly via \code{imatrix}, in the form of
#'        list of named elements.  Each element gives the columns of the
#'        within-subject model matrix for an intra-subject term to be tested, and must
#'        have as many rows as there are responses; the columns of the within-subject
#'        model matrix for \emph{different} terms must be mutually orthogonal.
#' @param iterm For repeated measures designs, you must specify one
#'        intra-subject term (a character string) to select the SSPE (E) matrix used
#'        in the HE plot.  Hypothesis terms plotted include the \code{iterm} effect as
#'        well as all interactions of \code{iterm} with \code{terms}.
#' @param manova optional \code{Anova.mlm} object for the model; if absent a
#'        MANOVA is computed. Specifying the argument can therefore save computation
#'        in repeated calls.
#' @param size how to scale the hypothesis ellipsoid relative to the error
#'        ellipsoid; if \code{"evidence"}, the default, the scaling is done so that a
#'        ``significant'' hypothesis ellipsoid extends outside of the error ellipsoid;
#'        if \code{"effect.size"}, the hypothesis ellipsoid is on the same scale as
#'        the error ellipsoid.
#' @param level equivalent coverage of ellipsoid for normally-distributed
#'        errors, defaults to \code{0.68}.
#' @param alpha significance level for Roy's greatest-root test statistic; if
#'        \code{size="evidence"}, then the hypothesis ellipsoid is scaled so that it
#'        just touches the error ellipsoid at the specified alpha level; a larger
#'        hypothesis ellipsoid therefore indicates statistical significance; defaults
#'        to \code{0.05}.
#' @param segments number of segments composing each ellipsoid; defaults to \code{40}.
#' @param col a color or vector of colors to use in plotting ellipsoids; the
#'        first color is used for the error ellipsoid; the remaining colors ---
#'        recycled as necessary --- are used for the hypothesis ellipsoid.  A single
#'        color can be given, in which case it is used for all ellipsoid.  For
#'        convenience, the default colors for all heplots produced in a given session
#'        can be changed by assigning a color vector via \code{options(heplot3d.colors=c(...)}.  
#'        Otherwise, the default colors are \code{c("pink", "blue",
#'        "black", "darkgreen", "darkcyan", "magenta", "brown", "darkgray")}.
#' @param lwd a two-element vector giving the line width for drawing ellipsoids
#'        (including those that degenerate to an ellipse) and for drawing ellipsoids
#'        that degenerate to a line segment. The default is \code{c(1, 4)}.
#' @param shade a logical scalar or vector, indicating whether the ellipsoids
#'        should be rendered with \code{\link[rgl]{shade3d}}. Works like \code{col},
#'        except that \code{FALSE} is used for any 1 df degenerate ellipsoid.
#' @param shade.alpha a numeric value in the range [0,1], or a vector of such
#'        values, giving the alpha transparency for ellipsoids rendered with
#'        \code{shade=TRUE}.
#' @param wire a logical scalar or vector, indicating whether the ellipsoids
#'        should be rendered with \code{\link[rgl]{wire3d}}. Works like \code{col},
#'        except that \code{TRUE} is used for any 1 df degenerate ellipsoid.
#' @param bg.col background colour, \code{"white"} or \code{"black"},
#'        defaulting to \code{"white"}.
#' @param fogtype type of ``fog'' to use for depth-cueing; the default is
#'        \code{"none"}. See \code{\link[rgl]{bg}}.
#' @param fov field of view angle; controls perspective.  See
#'        \code{\link[rgl]{viewpoint}}.
#' @param offset proportion of axes to off set labels; defaults to \code{0.01}.
#' @param xlab x-axis label; defaults to name of the x variable.
#' @param ylab y-axis label; defaults to name of the y variable.
#' @param zlab z-axis label; defaults to name of the z variable.
#' @param xlim x-axis limits; if absent, will be computed from the data.
#' @param ylim y-axis limits; if absent, will be computed from the data.
#' @param zlim z-axis limits; if absent, will be computed from the data.
#' @param cex.label text size for ellipse labels
#' @param add if \code{TRUE}, add to the current plot; the default is
#'        \code{FALSE}.  If \code{TRUE}, the error ellipsoid is neither plotted nor
#'        returned in the output object.
#' @param verbose if \code{TRUE}, print the MANOVA table and details of
#'        hypothesis tests; the default is \code{FALSE}.
#' @param warn.rank if \code{TRUE}, do not suppress warnings about the rank of
#'        the hypothesis matrix when the ellipsoid collapses to an ellipse or line;
#'        the default is \code{FALSE}.
#' @param \dots arguments passed from generic.
#' @return \code{heplot3d} invisibly returns a list containing the bounding
#' boxes of the error (E) ellipsoid and for each term or linear hypothesis
#' specified in the call.  Each of these is a 2 x 3 matrix with rownames "min"
#' and "max" and colnames corresponding to the variables plotted. An additional
#' component, \code{center}, contains the coordinates of the centroid in the
#' plot.
#' 
#' The function also leaves an object named \code{.frame} in the global
#' environment, containing the rgl object IDs for the axes, axis labels, and
#' bounding box; these are deleted and the axes, etc.  redrawn if the plot is
#' added to.
#' @seealso 
#'    \code{\link[car]{Anova}}, \code{\link[car]{linearHypothesis}}, for
#'    details on MANOVA tests and linear hypotheses
#' 
#'    \code{\link{heplot}}, \code{\link{pairs.mlm}}, for other plotting methods
#'    for \code{mlm} objects
#' 
#'    \code{\link[rgl]{rgl-package}}, for details about 3D plots with \code{rgl}
#' 
#'    \code{\link[candisc]{heplot3d.candisc}} for 3D HE plots in canonical space.
#' 
#' @references 
#' Friendly, M. (2006).  Data Ellipses, HE Plots and Reduced-Rank
#' Displays for Multivariate Linear Models: SAS Software and Examples
#' \emph{Journal of Statistical Software}, 17(6), 1-42.
#' \url{https://www.jstatsoft.org/v17/i06/}
#' 
#' Friendly, M. (2007).  HE plots for Multivariate General Linear Models.
#' \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
#' \url{http://datavis.ca/papers/jcgs-heplots.pdf}
#' @keywords hplot aplot dynamic multivariate
#' @examples
#' 
#' # Soils data, from car package
#' soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth, data=Soils)
#' Anova(soils.mod)
#' 
#' heplot(soils.mod, variables=c("Ca", "Mg"))
#' pairs(soils.mod, terms="Depth", variables=c("pH", "N", "P", "Ca", "Mg"))
#' 
#' heplot3d(soils.mod, variables=c("Mg", "Ca", "Na"), wire=FALSE)
#' 
#' # Plastic data
#' plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
#' \dontrun{
#' heplot3d(plastic.mod, col=c("red", "blue", "brown", "green3"), wire=FALSE)
#' }
#' 
#' @export heplot3d
heplot3d <-
function(mod, ...) UseMethod("heplot3d")

# TODO:
#  - add aspect argument (for candisc)

#' @rdname heplot3d
#' @exportS3Method heplot3d mlm
heplot3d.mlm <-
		function ( 
				mod,           # an mlm object
				terms,         # vector of terms to plot H ellipses
				hypotheses,    # list of linear hypotheses for which to plot H ellipses
				term.labels=TRUE,  # TRUE, FALSE or a list of term labels of length(terms)
				hyp.labels=TRUE,   # as above for term.labels
				err.label="Error",
				variables=1:3,     # x,y variables for the plot [variable names or numbers]
				error.ellipsoid=!add,
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
				size=c("evidence", "effect.size"),
				level=0.68,
				alpha=0.05,
				segments=40,          # line segments in each ellipse
#				col=palette()[-1],    # colors for E matrix, H matrices
				col=getOption("heplot3d.colors", c("red", "blue", "black", "darkgreen", "darkcyan",
				                                   "magenta", "brown","darkgray")),
				# colors for H matrices, E matrix
				lwd=c(1, 4),          # line width for drawing ellipsoids and 1d degenerate ellipsoids
				shade=TRUE,           # use shade3d to render ellipsoids?
				shade.alpha=0.2,      # alpha transparency for shaded3d
				wire=c(TRUE,FALSE),   # use wire3d to render ellipsoids?
				bg.col=c("white", "black"),  # background colour
				fogtype=c("none", "exp2", "linear", "exp"), # fog -- for depth cueing
				fov=30,   # field of view (for perspective)
				offset=0.01, # for ellipsoid labels
				xlab,
				ylab,
				zlab,
				xlim,
				ylim,
				zlim,
        cex.label = 1.5,       # text size for ellipse labels
				add=FALSE,             # add to existing plot?
				verbose=FALSE,
				warn.rank=FALSE,  
				...) {              
	
	ellipsoid <- function(center, 
	                      shape, 
	                      radius=1, 
	                      label="",
	                      cex.label,
	                      col, 
	                      df=Inf, 
	                      shade=TRUE, 
	                      alpha=0.1, 
	                      wire=TRUE){
		# adapted from the shapes3d demo in the rgl package and from the Rcmdr package
		# modified to return the bbox of the ellipsoid
		degvec <- seq(0, 2*pi, length=segments)
		ecoord2 <- function(p) c(cos(p[1])*sin(p[2]), sin(p[1])*sin(p[2]), cos(p[2]))
		# v <- t(apply(expand.grid(degvec,degvec), 1, ecoord2))  # modified to make smoother
		v <- t(apply(expand.grid(degvec,degvec/2), 1, ecoord2)) 
		if (!warn.rank){
			warn <- options(warn=-1)
			on.exit(options(warn))
		}
		Q <- chol(shape, pivot=TRUE)
		lwd <- if (df < 2) lwd[2] else lwd[1]
		order <- order(attr(Q, "pivot"))
		v <- center + radius * t(v %*% Q[, order])
		v <- rbind(v, rep(1,ncol(v))) 
		e <- expand.grid(1:(segments-1), 1:segments)
		i1 <- apply(e, 1, function(z) z[1] + segments*(z[2] - 1))
		i2 <- i1 + 1
		i3 <- (i1 + segments - 1) %% segments^2 + 1
		i4 <- (i2 + segments - 1) %% segments^2 + 1
		i <- rbind(i1, i2, i4, i3)
		x <- rgl::asEuclidean(t(v))
		ellips <- rgl::qmesh3d(v, i)
		# override settings for 1 df line
		if (df<2) {
			wire <- TRUE
			shade <- FALSE
		}
		back <- if (df < 3) "culled" else "filled"
		depth_mask <- if (alpha <.8) FALSE else TRUE
		if (verbose) cat(paste("df=", df, "col:", col, " shade:", shade, " alpha:", alpha, 
		                         " wire:", wire, "back:", back, "depth_mask:", depth_mask,
		                       sep=" "), "\n")
		if(shade) rgl::shade3d(ellips, 
		                       col=col, alpha=alpha, lit=TRUE, back=back, depth_mask=depth_mask)
		if(wire) rgl::wire3d(ellips, 
		                     col=col, size=lwd, lit=FALSE, back=back, depth_mask=depth_mask)
		bbox <- matrix(rgl::par3d("bbox"), nrow=2)
		ranges <- apply(bbox, 2, diff)
		if (!is.null(label) && label !="")
			rgl::texts3d(x[which.max(x[,2]),] + offset*ranges, adj=0, texts=label, color=col, lit=FALSE)
		rownames(bbox) <- c("min", "max")
		return(bbox)
	}
	
	
	if (!requireNamespace("rgl")) stop("rgl package is required.")    
	# avoid deprecated warnings from car
	#if (car2 <- packageDescription("car")[["Version"]] >= 2) linear.hypothesis <- linearHypothesis

	type <- match.arg(type)
	size <- match.arg(size)
	fogtype <- match.arg(fogtype)
	bg.col <- match.arg(bg.col)    
	data <- model.frame(mod)
	if (missing(manova)) {
		if (is.null(imatrix)) {
			manova <- Anova(mod, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts)
		}
		else {
				manova <- Anova(mod, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts, imatrix=imatrix)
		} 
	}   
#	if (verbose) print(manova)    
#	response.names <- rownames(manova$SSPE)
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
	if (length(variables) != 3) {
		extra <- if (length(variables) == 1) 'heplot1d()' else 
				if (length(variables) == 2) 'heplot()' else 'pairs()'
		stop(paste("You may only plot 3 response variables. Use", extra))
	}
	
	if (missing(terms) || (is.logical(terms) && terms)) {
		terms <- manova$terms
		if (!is.null(iterm)) {
			terms <- terms[grep(iterm, terms)]   ## only include those involving iterm
		}
		if (remove.intercept) terms <- terms[terms != "(Intercept)"]
	}
	n.terms <- if (!is.logical(terms)) length(terms) else 0 
	# note: if logical here, necessarily FALSE
	n.hyp <- if (missing(hypotheses)) 0 else length(hypotheses)
	n.ell <- n.terms + n.hyp
	if (n.ell == 0) stop("Nothing to plot.")
	
	E <- SSPE
	p <- nrow(E)
	E <- E[variables, variables]
	Y <- Y[,vars] 
	gmean <- if (missing(data))  c(0,0,0) 
			else colMeans(Y)
	if (missing(xlab)) xlab <- vars[1]
	if (missing(ylab)) ylab <- vars[2]
	if (missing(zlab)) zlab <- vars[3]
	dfe <- manova$error.df
	scale <- 1/dfe 
	E <- E * scale
	radius <- sqrt(3 * qf(level, 3, dfe))
	
	col   <- he.rep(col, n.ell); E.col<- col[length(col)]
	shade <- he.rep(shade, n.ell)
	shade.alpha <- he.rep(shade.alpha, n.ell)
	wire  <- he.rep(wire, n.ell)
	
if (!add){    
		rgl::open3d()
		rgl::view3d(fov=fov)
		rgl::bg3d(color=bg.col, fogtype=fogtype)    
	} 
	
	if (error.ellipsoid) {
		E.ellipsoid <- ellipsoid(gmean, E, radius, col=E.col, 
		                         label=err.label, cex.label = cex.label,
		                         df=dfe,
				                    shade=shade[[length(shade)]], 
				                    alpha=shade.alpha[[length(shade.alpha)]],
				                    wire=wire[[length(wire)]])
		colnames(E.ellipsoid) <- vars
	}       
	term.labels <- if (n.terms == 0) NULL
			else if (!is.logical(term.labels)) term.labels
			else if (term.labels) terms else rep("", n.terms)
	
	H.ellipsoid <- as.list(rep(0, n.ell))
	if (n.terms > 0) for (term in 1:n.terms){
			term.name <- terms[term] 
			H <- manova$SSP[[term.name]]
			H <- H[variables, variables]
			dfh <- manova$df[term.name]
			#          scale <- eval(parse(text=h.scale))
			factor <- if (size == "evidence") lambda.crit(alpha, p, dfh, dfe) else 1  
			H <- H * scale/factor
			if (verbose){
				cat(term.name, " H matrix (", dfh, " df):\n")
				print(H)
			}
			if((!shade[term]) & !wire[term]) 
				warning(paste("shate and wire are both FALSE for ", term), call.=FALSE)
			H.ellipsoid[[term]] <- ellipsoid(gmean, H, radius, col=col[term], 
			                                 label=term.labels[term], cex.label = cex.label,
					                      df=dfh, shade=shade[term], alpha=shade.alpha[term], 
					                      wire=wire[term])  
			colnames(H.ellipsoid[[term]]) <- vars
		}
	hyp.labels <- if (n.hyp == 0) NULL
			else if (!is.logical(hyp.labels)) hyp.labels
			else if (hyp.labels) names(hypotheses) else rep("", n.hyp)  
	if (n.hyp > 0) for (hyp in 1:n.hyp){
			lh <- car::linearHypothesis(mod, hypotheses[[hyp]])
			H <- lh$SSPH[variables, variables]
			dfh <- lh$df
			factor <- if (size == "evidence") lambda.crit(alpha, p, dfh, dfe) else 1  
			H <- H * scale/factor
			if (verbose){
				cat("\n\n Linear hypothesis: ", names(hypotheses)[[hyp]], "\n") 
				print(lh)
			}
			term <- n.terms + hyp
			H.ellipsoid[[term]] <- ellipsoid(gmean, H, radius, col=col[term], 
			                                 label=hyp.labels[hyp], cex.label = cex.label,
					                             df=dfh, shade=shade[term], alpha=shade.alpha[term], wire=wire[term])
		}         
	ranges <- apply(matrix(rgl::par3d("bbox"), nrow=2), 2, diff)

	#   if (grand.mean) ellipsoid(gmean, diag((ranges/40)^2), col="black", wire=FALSE, alpha=0.8) # centre dot    
	# better: use a centered 3D cross here
	if (grand.mean) cross3d(gmean, (ranges/25), col="black", lwd=2) # centre cross            
	
#browser()	
	## BUG fixed here:  should only label the means for factors included in terms
	if ((!is.logical(factor.means)) || factor.means){
		factors <- data[, sapply(data, is.factor), drop=FALSE]
		factor.names <- colnames(factors) 
		if (is.null(iterm)) factor.names <- factor.names[factor.names %in% terms]
		if (!is.logical(factor.means)){
			which <- match(factor.means, factor.names)
			check <- is.na(which)
			if (any(check)) stop(paste(factor.means[check], collapse=", "), 
						" not among factors.")
			factors <- factors[, which, drop=FALSE]
		}
		else factors <- factors[, factor.names, drop=FALSE]    
#        for (fac in factors){
#            means <- aggregate(Y, list(fac), mean)
		if (ncol(factors)) for (j in 1:ncol(factors)){
				means <- aggregate(Y, list(factors[,j]), mean)
				# color the points the same as the ellipse for the term
				loc <- match(factor.names[j], terms, nomatch=0)
				pcol <- if (loc>0) col[loc] else "black"
				for (m in 1:nrow(means)) {
					ellipsoid(unlist(means[m, 2:4]), diag((ranges/100))^2, col=pcol, 
					          wire=FALSE, alpha=0.8)
#            		points3d(unlist(means[m, 2:4]), size=3, color=pcol)
#					spheres3d(unlist(means[m, 2:4]), radius=diag((ranges/30))^2, color=pcol)
				}
				rgl::texts3d(means[,2:4] + matrix(offset*ranges, nrow(means), 3, byrow=TRUE), 
						texts=as.character(means[,1]), color=pcol, adj=0)
			}
	}
	
	# handle xlim, ylim, zlim
	## enforce that the specified limits are at least as large as the bbox
	if (!missing(xlim) | !missing(ylim) | !missing(zlim)) {
		bbox <- matrix(rgl::par3d("bbox"),3,2,byrow=TRUE)
		xlim <- if(missing(xlim)) bbox[1,] else c(min(xlim[1],bbox[1,1]), max(xlim[2],bbox[1,2]))
		ylim <- if(missing(ylim)) bbox[2,] else c(min(ylim[1],bbox[2,1]), max(ylim[2],bbox[2,2]))
		zlim <- if(missing(zlim)) bbox[3,] else c(min(zlim[1],bbox[3,1]), max(zlim[2],bbox[3,2]))
		rgl::decorate3d(xlim=xlim, ylim=ylim, zlim=zlim, 
		                box=FALSE, axes=FALSE, 
		                xlab=NULL, ylab=NULL, zlab=NULL, top=FALSE)
	}
	
  # TODO: allow cex for axis labels
	if (add) rgl::pop3d(id=savedvars$.frame)
	frame <- rgl::axis3d("x-", color="black")
	frame <- c(frame, rgl::mtext3d(xlab, "x-", color="black", line=1.5))
	frame <- c(frame, rgl::axis3d("y-", col="black"))
	frame <- c(frame, rgl::mtext3d(ylab, "y-", color="black", line=1.5))
	frame <- c(frame, rgl::axis3d("z-", col="black"))
	frame <- c(frame, rgl::mtext3d(zlab, "z-", color="black", line=1.5))
	frame <- c(frame, rgl::box3d(col="black"))
	assign(".frame", frame, envir=savedvars)
	#   savedvars$.frame <- frame

	rgl::aspect3d(x=1, y=1, z=1)
	
	names(H.ellipsoid) <- c(if (n.terms > 0) term.labels, if (n.hyp > 0) hyp.labels)
	result <- if(error.ellipsoid) list(H=H.ellipsoid, E=E.ellipsoid, center=gmean, radius=radius) 
			else list(H=H.ellipsoid, center=gmean, radius=radius)
	class(result) <- "heplot3d"
	invisible(result)
	
}

.frame <- NULL   # avoid warning

