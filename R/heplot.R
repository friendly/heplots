# Change log
# last modified 23 January 2007 by J. Fox
# last modified 14 May 2007 by M. Friendly -- return xlim, ylim
# last modified 18 May 2007 by M. Friendly -- fix xlim, ylim return when !add
# last modified 20 May 2007 by M. Friendly -- pass ... to text
# last modified 23 May 2007 by J. Fox -- add ... to call to points()
# last modified 22 Oct 2007 by M. Friendly
# -- moved lambda.crit to heplots-internal.R
# -- added he.rep to handle common task of repeating HE argument values
#  13 Apr 2009 by M. Friendly -- fix label.ellipse
#  15 Apr 2009 by M. Friendly -- added axes= to fix warnings from pairs.mlm
#  24 Dec 2009 by M. Friendly -- added idate=, idesign=, icontrasts, iterm for repeated measures
#  26 Dec 2009 by M. Friendly -- workaround for car::Anova buglet
#  27 Dec 2009 by M. Friendly -- made it work for designs with no between effects
#  28 Dec 2009 by M. Friendly -- made it work with car 2.0 for doubly multivariate
#  10 Jan 2010 by M. Friendly -- merged with heplot.mlm.R
#  23 Jul 2010 by M. Friendly -- return radius
#  05 Nov 2010 by M. Friendly 
# -- added fill= and fill.alpha for filled ellipses
# -- replaced lines() with polygon() for H and E ellipses
# -- calculate H.rank to distinguish degenerate ellipses
# -- added last() to utility.R
# -- added err.label to allow changing label for Error ellipse
# -- changed default colors from palette()[-1] to a better collection, also allowing options("heplot.colors")
#  15 Jan 2013 by M. Friendly
# -- replaced internal label.ellipse with separate function; added label.pos= argument
#  22 Feb 2013
# -- added ... to label.ellipse to be able to pass cex=
#  02 Dec 2025
# -- `heplot()`: added `label.cex` arg to allow control of H/E label sizes (not vectorized)
# -- no longer pass ... to label.ellipse()
# 



#' Two-Dimensional HE Plots
#' 
#' This function plots ellipses representing the hypothesis and error
#' sums-of-squares-and-products matrices for terms and linear hypotheses in a
#' multivariate linear model.  These include MANOVA models (all explanatory
#' variables are factors), multivariate regression (all quantitative
#' predictors), MANCOVA models, homogeneity of regression, as well as repeated
#' measures designs treated from a multivariate perspective.
#' 
#' The `heplot` function plots a representation of the covariance ellipses
#' for hypothesized model terms and linear hypotheses (H) and the corresponding
#' error (E) matrices for two response variables in a multivariate linear model
#' (mlm).
#' 
#' The plot helps to visualize the nature and dimensionality response variation
#' on the two variables jointly in relation to error variation that is
#' summarized in the various multivariate test statistics (Wilks' Lambda,
#' Pillai trace, Hotelling-Lawley trace, Roy maximum root). Roy's maximum root
#' test has a particularly simple visual interpretation, exploited in the
#' `size="evidence"` version of the plot. See the description of argument
#' `alpha`.
#' 
#' For a 1 df hypothesis term (a quantitative regressor, a single contrast or
#' parameter test), the H matrix has rank 1 (one non-zero latent root of \eqn{H
#' E^{-1}}) and the H "ellipse" collapses to a degenerate line.
#' 
#' Typically, you fit a mlm with `mymlm <- lm(cbind(y1, y2, y3, ...) ~
#' modelterms)`, and plot some or all of the `modelterms` with
#' `heplot(mymlm, ...)`.  Arbitrary linear hypotheses related to the terms
#' in the model (e.g., contrasts of an effect) can be included in the plot
#' using the `hypotheses` argument.  See
#' \code{\link[car]{linearHypothesis}} for details.
#' 
#' For repeated measure designs, where the response variables correspond to one
#' or more variates observed under a within-subject design, between-subject
#' effects and within-subject effects must be plotted separately, because the
#' error terms (E matrices) differ.  When you specify an intra-subject term
#' (`iterm`), the analysis and HE plots amount to analysis of the matrix
#' **Y** of responses post-multiplied by a matrix **M** determined by the
#' intra-subject design for that term.  See Friendly (2010) or the
#' `vignette("repeated")` in this package for an extended discussion and
#' examples.
#' 
#' The related \code{\link[candisc]{candisc}} package provides functions for
#' visualizing a multivariate linear model in a low-dimensional view via a
#' generalized canonical discriminant analyses.
#' \code{\link[candisc]{heplot.candisc}} and
#' \code{\link[candisc]{heplot3d.candisc}} provide a low-rank 2D (or 3D) view
#' of the effects for a given term in the space of maximum discrimination.
#' 
#' When an element of `fill` is `TRUE`, the ellipse outline is drawn
#' using the corresponding color in `col`, and the interior is filled with
#' a transparent version of this color specified in `fill.alpha`.  To
#' produce filled (non-degenerate) ellipses without the bounding outline, use a
#' value of `lty=0` in the corresponding position.
#' 
#' @aliases heplot heplot.mlm
#' @param mod a model object of class `"mlm"`.
#' @param terms a logical value or character vector of terms in the model for
#'              which to plot hypothesis matrices; if missing or `TRUE`, defaults to
#'              all terms; if `FALSE`, no terms are plotted.
#' @param hypotheses optional list of linear hypotheses for which to plot
#'              hypothesis matrices; hypotheses are specified as for the
#'              \code{\link[car]{linearHypothesis}} function in the `car` package; the
#'              list elements can be named, in which case the names are used.
#' @param term.labels logical value or character vector of names for the terms
#'              to be plotted. If `TRUE` (the default) the names of the terms are used;
#'              if `FALSE`, term labels are not plotted.
#' @param hyp.labels logical value or character vector of names for the
#'              hypotheses to be plotted. If `TRUE` (the default) the names of
#'              components of the list of hypotheses are used; if `FALSE`, hypothesis
#'              labels are not plotted.
#' @param err.label Label for the error ellipse
#' @param label.pos Label position, a vector of integers (in `0:4`) or
#'              character strings (in `c("center", "bottom", "left", "top", "right")`,
#'              or in `c("C", "S", "W", "N", "E")` use in labeling ellipses, recycled
#'              as necessary.  Values of 1, 2, 3 and 4, respectively indicate positions
#'              below, to the left of, above and to the right of the max/min coordinates of
#'              the ellipse; the value 0 specifies the centroid of the `ellipse`
#'              object.  The default, `label.pos=NULL` uses the correlation of the
#' `ellipse` to determine "top" (r>=0) or "bottom" (r<0).  Even more
#'              flexible options are described in \code{\link{label.ellipse}}
#' @param label.cex Character size used for labels for the hypothesis, error ellipses.
#' @param variables indices or names of the two response variables to be
#'              plotted; defaults to `1:2`.
#' @param error.ellipse if `TRUE`, plot the error ellipse; defaults to
#'              `TRUE`, if the argument `add` is `FALSE` (see below).
#' @param factor.means logical value or character vector of names of factors
#'              for which the means are to be plotted, or `TRUE` or `FALSE`;
#'              defaults to `TRUE`, if the argument `add` is `FALSE` (see
#'              below).
#' @param grand.mean if `TRUE`, plot the centroid for all of the data;
#'              defaults to `TRUE`, if the argument `add` is `FALSE` (see
#'              below).
#' @param remove.intercept if `TRUE` (the default), do not plot the
#'              ellipse for the intercept even if it is in the MANOVA table.
#' @param type ``type'' of sum-of-squares-and-products matrices to compute; one
#'              of `"II"`, `"III"`, `"2"`, or `"3"`, where `"II"`
#'              is the default (and `"2"` is a synonym).
#' @param idata an optional data frame giving a factor or factors defining the
#'              intra-subject model for multivariate repeated-measures data.  See Friendly
#'              (2010) and Details of \code{\link[car]{Anova}} for an explanation of the
#'              intra-subject design and for further explanation of the other arguments
#'              relating to intra-subject factors.
#' @param idesign a one-sided model formula using the ``data'' in idata and
#'              specifying the intra-subject design for repeated measure models.
#' @param icontrasts names of contrast-generating functions to be applied by
#'              default to factors and ordered factors, respectively, in the within-subject
#'              ``data''; the contrasts must produce an intra-subject model matrix in which
#'              different terms are orthogonal. The default is c("contr.sum", "contr.poly").
#' @param imatrix In lieu of `idata` and `idesign`, you can specify
#'              the intra-subject design matrix directly via `imatrix`, in the form of
#'              list of named elements.  Each element gives the columns of the
#'              within-subject model matrix for an intra-subject term to be tested, and must
#'              have as many rows as there are responses; the columns of the within-subject
#'              model matrix for *different* terms must be mutually orthogonal.
#' @param iterm For repeated measures designs, you must specify one
#'              intra-subject term (a character string) to select the SSPE (E) matrix used
#'              in the HE plot.  Hypothesis terms plotted include the `iterm` effect as
#'              well as all interactions of `iterm` with `terms`.
#' @param markH0 A logical value (or else a list of arguments to
#'              \code{\link{mark.H0}}) used to draw cross-hairs and a point indicating the
#'              value of a point null hypothesis.  The default is TRUE if `iterm` is
#'              non-NULL.
#' @param manova optional `Anova.mlm` object for the model; if absent a
#'              MANOVA is computed. Specifying the argument can therefore save computation
#'              in repeated calls.
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
#' @param segments number of line segments composing each ellipse; defaults to `60`.
#' @param center.pch character to use in plotting the centroid of the data;
#'              defaults to `"+"`.
#' @param center.cex size of character to use in plotting the centroid of the data; defaults to `2`.
#' @param col a color or vector of colors to use in plotting ellipses; the
#'              first color is used for the error ellipse; the remaining colors --- recycled
#'              as necessary --- are used for the hypothesis ellipses.  A single color can
#'              be given, in which case it is used for all ellipses.  For convenience, the
#'              default colors for all heplots produced in a given session can be changed by
#'              assigning a color vector via `options(heplot.colors =c(...)`.
#'              Otherwise, the default colors are `c("red", "blue", "black",
#'              "darkgreen", "darkcyan", "magenta", "brown", "darkgray")`.
#' @param lty vector of line types to use for plotting the ellipses; the first
#'              is used for the error ellipse, the rest --- possibly recycled --- for the
#'              hypothesis ellipses; a single line type can be given. Defaults to `2:1`.
#' @param lwd vector of line widths to use for plotting the ellipses; the first
#'              is used for the error ellipse, the rest --- possibly recycled --- for the
#'              hypothesis ellipses; a single line width can be given. Defaults to
#'              `1:2`.
#' @param fill A logical vector indicating whether each ellipse should be
#'              filled or not.  The first value is used for the error ellipse, the rest ---
#'              possibly recycled --- for the hypothesis ellipses; a single fill value can
#'              be given.  Defaults to FALSE for backward compatibility. See Details below.
#' @param fill.alpha Alpha transparency for filled ellipses, a numeric scalar
#'              or vector of values within `[0,1]`, where 0 means fully transparent and 1 means fully opaque.
#' @param xlab x-axis label; defaults to name of the x variable.
#' @param ylab y-axis label; defaults to name of the y variable.
#' @param main main plot label; defaults to `""`.
#' @param xlim x-axis limits; if absent, will be computed from the data.
#' @param ylim y-axis limits; if absent, will be computed from the data.
#' @param axes Whether to draw the x, y axes; defaults to `TRUE`
#' @param offset.axes proportion to extend the axes in each direction if
#'              computed from the data; optional.
#' @param add if `TRUE`, add to the current plot; the default is
#'              `FALSE`.  If `TRUE`, the error ellipse is not plotted.
#' @param verbose if `TRUE`, print the MANOVA table and details of
#'              hypothesis tests; the default is `FALSE`.
#' @param warn.rank if `TRUE`, do not suppress warnings about the rank of
#'              the hypothesis matrix when the ellipse collapses to a line; the default is `FALSE`.
#' @param \dots arguments to pass down to `plot`, `text`, and `points`.
#' @return The function invisibly returns an object of class `"heplot"`,
#' with coordinates for the various hypothesis ellipses and the error ellipse,
#' and the limits of the horizontal and vertical axes.  These may be useful for
#' adding additional annotations to the plot, using standard plotting
#' functions.  (No methods for manipulating these objects are currently
#' available.)
#' 
#' The components are:
#' \describe{
#' \item{H}{a list containing the coordinates of each ellipse for the hypothesis terms} 
#' \item{E}{a matrix containing the coordinates for the error ellipse} 
#' \item{center}{x,y coordinates of the centroid} 
#' \item{xlim}{x-axis limits} 
#' \item{ylim}{y-axis limits}
#' \item{radius}{the radius for the unit circles used to generate the ellipses}
#' }
#' 
#' @family HE plot functions
#' @seealso \code{\link[car]{Anova}}, \code{\link[car]{linearHypothesis}} for
#' details on testing MLMs.
#' 
#' \code{\link{heplot1d}}, \code{\link{heplot3d}}, \code{\link{pairs.mlm}},
#' \code{\link{mark.H0}} for other HE plot functions.
#' \code{\link{coefplot.mlm}} for plotting confidence ellipses for parameters
#' in MLMs.
#' 
#' \code{\link{trans.colors}} for calculation of transparent colors.
#' \code{\link{label.ellipse}} for labeling positions in plotting H and E
#' ellipses.
#' 
#' \code{\link[candisc]{candisc}}, \code{\link[candisc]{heplot.candisc}} for
#' reduced-rank views of `mlm`s in canonical space.
#' 
#' @references 
#' Friendly, M. (2006).  Data Ellipses, HE Plots and Reduced-Rank
#' Displays for Multivariate Linear Models: SAS Software and Examples
#' *Journal of Statistical Software*, **17**(6), 1--42. %
#' <https://www.jstatsoft.org/v17/i06/>,
#' DOI: 10.18637/jss.v017.i06
#' 
#' Friendly, M. (2007).  HE plots for Multivariate General Linear Models.
#' *Journal of Computational and Graphical Statistics*, **16**(2)
#' 421--444.  <http://datavis.ca/papers/jcgs-heplots.pdf>
#' 
#' Friendly, Michael (2010). HE Plots for Repeated Measures Designs.
#' *Journal of Statistical Software*, 37(4), 1-40.  
#' DOI: 10.18637/jss.v037.i04.
#' 
#' Fox, J., Friendly, M. & Weisberg, S. (2013). Hypothesis Tests for
#' Multivariate Linear Models Using the car Package. *The R Journal*,
#' **5**(1),
#' <https://journal.r-project.org/articles/RJ-2013-004/RJ-2013-004.pdf>.
#' 
#' Friendly, M. & Sigal, M. (2014) Recent Advances in Visualizing Multivariate
#' Linear Models. *Revista Colombiana de Estadistica*, **37**, 261-283.
#' DOI: 10.15446/rce.v37n2spe.47934.
#' @keywords hplot aplot multivariate
#' @examples
#' 
#' ## iris data
#' contrasts(iris$Species) <- matrix(c(0,-1,1, 2, -1, -1), 3,2)
#' contrasts(iris$Species)
#' 
#' iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
#' Species, data=iris)
#' 
#' hyp <- list("V:V"="Species1","S:VV"="Species2")
#' heplot(iris.mod, hypotheses=hyp)
#' # compare with effect-size scaling
#' heplot(iris.mod, hypotheses=hyp, size="effect", add=TRUE)
#' 
#' # try filled ellipses; include contrasts
#' heplot(iris.mod, hypotheses=hyp, fill=TRUE, 
#'        fill.alpha=0.2, col=c("red", "blue"))
#' heplot(iris.mod, hypotheses=hyp, fill=TRUE, 
#'        col=c("red", "blue"), lty=c(0,0,1,1))
#'
#' # vary label position and fill.alpha
#' heplot(iris.mod, hypotheses=hyp, fill=TRUE, fill.alpha=c(0.3,0.1), col=c("red", "blue"), 
#'        lty=c(0,0,1,1), label.pos=0:3)
#' 
#' # what is returned?
#' hep <-heplot(iris.mod, variables=c(1,3),  hypotheses=hyp)
#' str(hep)
#' 
#' # all pairs
#' pairs(iris.mod, hypotheses=hyp, hyp.labels=FALSE)
#' 
#' 
#' ## Pottery data, from car package
#' data(Pottery, package = "carData")
#' pottery.mod <- lm(cbind(Al, Fe, Mg, Ca, Na) ~ Site, data=Pottery)
#' heplot(pottery.mod)
#' heplot(pottery.mod, terms=FALSE, add=TRUE, col="blue", 
#'   hypotheses=list(c("SiteCaldicot = 0", "SiteIsleThorns=0")),
#'   hyp.labels="Sites Caldicot and Isle Thorns")
#' 
#' ## Rohwer data, multivariate multiple regression/ANCOVA
#' #-- ANCOVA, assuming equal slopes
#' rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data=Rohwer)
#' car::Anova(rohwer.mod)
#' col <- c("red", "black", "blue", "cyan", "magenta", "brown", "gray")
#' heplot(rohwer.mod, col=col)
#' 
#' # Add ellipse to test all 5 regressors
#' heplot(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")), 
#'        col=col, fill=TRUE)
#' # View all pairs
#' pairs(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
#' # or 3D plot
#' 
#' if(requireNamespace("rgl")){
#' col <- c("pink", "black", "blue", "cyan", "magenta", "brown", "gray")
#' heplot3d(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")), col=col)
#' }
#' 
#' @export heplot
heplot <-
		function(mod, ...) UseMethod("heplot")

#' @rdname heplot
#' @exportS3Method  heplot mlm
#' @importFrom car linearHypothesis Anova
heplot.mlm <-
		function ( 
				mod,           # an mlm object
				terms,         # vector of terms to plot H ellipses
				hypotheses,    # list of linear hypotheses for which to plot H ellipses
				term.labels = TRUE,  # TRUE, FALSE or a vector of term labels of length(terms)
				hyp.labels = TRUE,   # as above for term.labels
				err.label = "Error",
				label.pos = NULL,    # label positions: NULL or 0:4
				label.cex = par("cex"),
				variables = 1:2,     # x,y variables for the plot [variable names or numbers]
				error.ellipse = !add,
				factor.means = !add,
				grand.mean = !add,
				remove.intercept = TRUE,
				type = c("II", "III", "2", "3"),
				idata = NULL,
				idesign = NULL,
				icontrasts = c("contr.sum", "contr.poly"),
				imatrix = NULL,
				iterm = NULL,
				markH0 = !is.null(iterm),
				manova,        # an optional Anova.mlm object
				size = c("evidence", "effect.size", "significance"),
				level = 0.68,
				alpha = 0.05,
				segments = 60,   # line segments in each ellipse
				center.pch = "+",   # doesn't have to be an argument
				center.cex = 2,
				col=getOption("heplot.colors", c("red", "blue", "black", "darkgreen", "darkcyan","magenta", 
				                                 "brown","darkgray")),
				# colors for H matrices, E matrix
				lty = 2:1,
				lwd = 1:2,
				fill = FALSE,         ## whether to draw filled ellipses (vectorized)
				fill.alpha = 0.3,     ## alpha transparency for filled ellipses
				xlab,
				ylab,
				main = "",
				xlim,           # min/max for X (override internal min/max calc) 
				ylim,
				axes = TRUE,      # whether to draw the axes
				offset.axes,    # if specified, the proportion by which to expand the axes on each end (e.g., .05)
				add = FALSE,      # add to existing plot?
				verbose = FALSE,
				warn.rank = FALSE,  
				...) {
	ell <- function(center, shape, radius) {
		angles <- (0:segments)*2*pi/segments
		circle <- radius * cbind( cos(angles), sin(angles))
		if (!warn.rank){
			warn <- options(warn=-1)
			on.exit(options(warn))
		}
		Q <- chol(shape, pivot=TRUE)
		order <- order(attr(Q, "pivot"))
		t( c(center) + t( circle %*% Q[,order]))
	}

#	last <- function(x) {x[length(x)]}
	
	type <- match.arg(type)
	size <- match.arg(size)
	data <- model.frame(mod)
	
	if (missing(manova)) {
		if (is.null(imatrix)) {
			manova <- car::Anova(mod, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts)
		}
		else {
				manova <- car::Anova(mod, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts, imatrix=imatrix)
		} 
	}   
	if (verbose) print(manova)
	
	if (is.null(idata) && is.null(imatrix)) {
		Y <- model.response(data) 
		SSPE <- manova$SSPE
	} 
	else {
		if (is.null(iterm)) stop("Must specify a within-S iterm for repeated measures designs" )
		### DONE::car -- workaround for car::Anova.mlm bug: no names assigned to $P component
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
	if (length(variables) != 2) {
		extra <- if (length(variables) == 1) 'heplot1d()' else 
				if (length(variables) == 3) 'heplot3d()' else 'pairs()'
		stop(paste("You may only plot 2 response variables. Use", extra))
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
	gmean <- if (missing(data))  c(0,0) 
			else colMeans(Y)
	if (missing(xlab)) xlab <- vars[1]
	if (missing(ylab)) ylab <- vars[2] 
	dfe <- manova$error.df
	scale <- 1/dfe
	radius <- sqrt(2 * qf(level, 2, dfe))
	
	# assign colors and line styles
	if (!inherits(col, "character")) stop(paste("`col` must be a character vector, not class", class(col)))
	col <- he.rep(col, n.ell) 
	lty <- he.rep(lty, n.ell)
	lwd <- he.rep(lwd, n.ell)
	
	# handle filled ellipses
	fill <- he.rep(fill, n.ell)
	fill.alpha <- he.rep(fill.alpha, n.ell)
	fill.col <- trans.colors(col, fill.alpha)
	label.pos <- he.rep(label.pos, n.ell)
	
	# TODO:  take account of rank=1?
	fill.col <- ifelse(fill, fill.col, NA)
	E.col<- last(col)
	
	H.ellipse <- as.list(rep(0, n.ell))
	# keep track of ranks to distinguish degenerate ellipses
	H.rank <- rep(0, n.ell)
	
	if (n.terms > 0) for (term in 1:n.terms){
			term.name <- terms[term]
			H <- manova$SSP[[term.name]]
			if (!(all(variables %in% 1:nrow(H)))) {
				warning(paste("Skipping H term ", term.name, "(size: ", nrow(H), ")", sep=""))
				next
			}
			H <- H[variables, variables]
			dfh <- manova$df[term.name]
			factor <- if (size %in% c("evidence", "significance")) lambda.crit(alpha, p, dfh, dfe) else 1
			H <- H * scale/factor
			if (verbose){
				cat(term.name, " H matrix (", dfh, " df):\n")
				print(H)
			}
			H.ellipse[[term]] <- ell(gmean, H, radius)
			H.rank[term] <- qr(H)$rank
	}
	
	if (n.hyp > 0) for (hyp in 1:n.hyp){
			lh <- car::linearHypothesis(mod, hypotheses[[hyp]])
			H <- lh$SSPH[variables, variables]
			dfh <- lh$df
			factor <- if (size %in% c("evidence", "significance")) lambda.crit(alpha, p, dfh, dfe) else 1
			H <- H * scale/factor
			if (verbose){
				cat("\n\n Linear hypothesis: ", names(hypotheses)[[hyp]], "\n") 
				print(lh)
			}
			H.ellipse[[n.terms + hyp]] <- ell(gmean, H, radius)
	}
	
	E <- SSPE
	E <- E[variables, variables]
	E <- E * scale[1]
	E.ellipse <- ell(gmean, E, radius)
	H.ellipse$E <- E.ellipse    
	
	if (!add){
		max <- apply(sapply(H.ellipse, function(X) apply(X, 2, max)), 1, max)
		min <- apply(sapply(H.ellipse, function(X) apply(X, 2, min)), 1, min)
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
				min[1] <- min(min[1], means[,2])
				max[1] <- max(max[1], means[,2])
				min[2] <- min(min[2], means[,3])
				max[2] <- max(max[2], means[,3])
			}
		}
		if (!missing(offset.axes)){
			range <- max - min
			min <- min - offset.axes*range
			max <- max + offset.axes*range
		}
		xlim <- if(missing(xlim)) c(min[1], max[1]) else xlim
		ylim <- if(missing(ylim)) c(min[2], max[2]) else ylim
		plot(xlim, ylim,  type = "n", xlab=xlab, ylab=ylab, main=main, axes=axes, ...)
	}
	# no longer need H.ellipse$E, since we return it separately
	H.ellipse$E <- NULL
	
	if (grand.mean) 
		points(gmean[1], gmean[2], pch=center.pch, cex=center.cex, col="black", xpd=TRUE)

	if (error.ellipse){
		polygon(E.ellipse, col=last(fill.col), border=last(col), lty=last(lty), lwd=last(lwd))
		label.ellipse(E.ellipse, err.label, col=last(col), label.pos=last(label.pos), cex=label.cex)
	}
	term.labels <- if (n.terms == 0) NULL
			else if (!is.logical(term.labels)) term.labels
			else if (term.labels) terms else rep("", n.terms)  
	if (n.terms > 0) for (term in 1:n.terms){
			# TODO: avoid polygon if rank=1 ???
			polygon(H.ellipse[[term]], col=fill.col[term], border=col[term],  lty=lty[term], lwd=lwd[term])
			label.ellipse(H.ellipse[[term]], term.labels[term], col=col[term], label.pos=label.pos[term], cex=label.cex) 
		}   

	# draw and label the H ellipses for all terms
	hyp.labels <- if (n.hyp == 0) NULL
			else if (!is.logical(hyp.labels)) hyp.labels
			else if (hyp.labels) names(hypotheses) else rep("", n.hyp)  
	if (n.hyp > 0) for (hyp in 1:n.hyp){
			ell <- n.terms + hyp
			polygon(H.ellipse[[ell]], col=fill.col[ell], border=col[ell],  lty=lty[ell], lwd=lwd[ell])
			label.ellipse(H.ellipse[[ell]], hyp.labels[hyp], col=col[ell], label.pos=label.pos[hyp], cex=label.cex)
		}

	if (!add && (!is.logical(factor.means) || factor.means)){
		for (fac in factors){
			means <- aggregate(Y, list(fac), mean)
			points(means[,2], means[,3], pch=16, xpd=TRUE, ...)
			text(means[,2], means[,3], labels=as.character(means[,1]), pos=3, xpd=TRUE, ...)
		}
	}
	
	# mark the null hypothesis, where relevant
	if(is.logical(markH0) && markH0) mark.H0()
	else if (is.list(markH0)) do.call(mark.H0, markH0)
	
	# prepare returned `"heplot"` result
	names(H.ellipse) <- c(if (n.terms > 0) term.labels, if (n.hyp > 0) hyp.labels)
	result <- if (!add) list(H=H.ellipse, 
	                         E=E.ellipse, 
	                         center=gmean, 
	                         xlim=xlim, 
	                         ylim=ylim, 
	                         radius=radius)
			else list(H=H.ellipse, 
			          E=E.ellipse, 
			          center=gmean, 
			          radius=radius)
	class(result) <- "heplot"
	invisible(result)
}
