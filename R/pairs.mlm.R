# last modified 21 December 2006 by J. Fox
# last modified 15 April 2009 by M. Friendly 
#  -- Fixed numerous warnings resulting from axes=FALSE
#  -- prepare to generalize diagonal panel
# last modified 2 Feb 2010 by M. Friendly
#  -- added code for repeated measures designs
# last modified 13 Oct 2011 by M. Friendly
#  -- added var.labels 




#' Pairwise HE Plots
#' 
#' The function (in the form of an \code{mlm} method for the generic
#' \code{\link[graphics]{pairs}} function) constructs a ``matrix'' of pairwise
#' HE plots (see \link{heplot}) for a multivariate linear model.
#' 
#' 
#' @param x an object of class \code{mlm}.
#' @param variables indices or names of the three of more response variables to
#'        be plotted; defaults to all of the responses.
#' @param var.labels labels for the variables plotted in the diagonal panels;
#'        defaults to names of the response variables.
#' @param var.cex character expansion for the variable labels.
#' @param type type of sum-of-squares-and-products matrices to compute; one
#'        of \code{"II"}, \code{"III"}, \code{"2"}, or \code{"3"}, where \code{"II"}
#'        is the default (and \code{"2"} is a synonym).
#' @param idata an optional data frame giving a factor or factors defining the
#'        intra-subject model for multivariate repeated-measures data.  See Details of
#' \code{\link[car]{Anova}} for an explanation of the intra-subject design and
#'        for further explanation of the other arguments relating to intra-subject factors.
#' @param idesign a one-sided model formula using the ``data'' in idata and
#'        specifying the intra-subject design for repeated measure models.
#' @param icontrasts names of contrast-generating functions to be applied by
#'        default to factors and ordered factors, respectively, in the within-subject
#'        ``data''; the contrasts must produce an intra-subject model matrix in which
#'        different terms are orthogonal. The default is c("contr.sum", "contr.poly").
#' @param imatrix In lieu of \code{idata} and \code{idesign}, you can specify
#'         the intra-subject design matrix directly via \code{imatrix}, in the form of
#'         list of named elements.  Each element gives the columns of the
#'         within-subject model matrix for an intra-subject term to be tested, and must
#'         have as many rows as there are responses; the columns of the within-subject
#'         model matrix for \emph{different} terms must be mutually orthogonal.
#' @param iterm For repeated measures designs, you must specify one
#'        intra-subject term (a character string) to select the SSPE (E) matrix used
#'        in the HE plot.  Hypothesis terms plotted include the \code{iterm} effect as
#'        well as all interactions of \code{iterm} with \code{terms}.
#' @param manova optional \code{Anova.mlm} object for the model; if absent a
#'        MANOVA is computed. Specifying the argument can therefore save computation
#'        in repeated calls.
#' @param offset.axes proportion to extend the axes in each direction; defaults to 0.05.
#' @param digits number of significant digits in axis end-labels; taken from
#'        the \code{"digits"} option.
#' @param fill A logical vector indicating whether each ellipse should be
#'        filled or not.  The first value is used for the error ellipse, the rest ---
#'        possibly recycled --- for the hypothesis ellipses; a single fill value can
#'        be given.  Defaults to FALSE for backward compatibility. See Details of
#' \code{\link{heplot}}
#' @param fill.alpha Alpha transparency for filled ellipses, a numeric scalar
#'        or vector of values within \code{[0,1]}, where 0 means fully transparent and
#'        1 means fully opaque. Defaults to 0.3.
#' @param \dots arguments to pass down to \code{heplot}, which is used to draw
#'        each panel of the display.
#' @author Michael Friendly
#' @seealso \code{\link{heplot}}, \code{\link{heplot3d}}
#' @references 
#' Friendly, M. (2006).  Data Ellipses, HE Plots and Reduced-Rank
#' Displays for Multivariate Linear Models: SAS Software and Examples
#' \emph{Journal of Statistical Software}, 17(6), 1-42.
#' \url{https://www.jstatsoft.org/v17/i06/}
#' 
#' Friendly, M. (2007).  HE plots for Multivariate General Linear Models.
#' \emph{Journal of Computational and Graphical Statistics}, 16(2) 421-444.
#' \url{http://datavis.ca/papers/jcgs-heplots.pdf}
#' @keywords hplot multivariate
#' @examples
#' 
#' # ANCOVA, assuming equal slopes
#' rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data=Rohwer)
#' 
#' # View all pairs, with ellipse for all 5 regressors
#' pairs(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
#' 
#' 
#' @exportS3Method pairs mlm
pairs.mlm <-
function(x, variables, var.labels, var.cex = 2,
    type=c("II", "III", "2", "3"),
	idata=NULL,
	idesign=NULL,
	icontrasts=NULL,
	imatrix=NULL,
	iterm=NULL,
	manova,        # an optional Anova.mlm object
	offset.axes=0.05, 
	digits=getOption("digits") - 1,
	fill=FALSE,         ## whether to draw filled ellipses (vectorized)
	fill.alpha=0.3,     ## alpha transparency for filled ellipses
	...){

#	manova <- Anova(x, type)
	if (missing(manova)) {
		type <- match.arg(type)
		if (is.null(imatrix)) {
			manova <- Anova(x, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts)
		}
		else {
			if (packageDescription("car")[["Version"]] >= 2)
				manova <- Anova(x, type=type, idata=idata, idesign=idesign, icontrasts=icontrasts, imatrix=imatrix)
			else stop("imatrix argument requires car 2.0-0 or later")
		} 
	}   
	
	data <- model.frame(x)
#	Y <- model.response(model.frame(x))
	if (is.null(idata) && is.null(imatrix)) {
		Y <- model.response(data) 
#		SSPE <- manova$SSPE
	} 
	else {
		if (is.null(iterm)) stop("Must specify a within-S iterm for repeated measures designs" )
		### FIXME::car -- workaround for car::Anova.mlm bug: no names assigned to $P component
		if (is.null(names(manova$P))) names(manova$P) <- names(manova$SSPE)
		Y <- model.response(data) %*% manova$P[[iterm]]
#		SSPE <- manova$SSPE[[iterm]]
	}   
	
	vars <- colnames(Y)
  if (!missing(variables)){
      if (is.numeric(variables)) {
          vars <- vars[variables]
          if (any(is.na(vars))) stop("Bad response variable selection.")
          }
      else {
          check <- !(variables %in% vars)
          if (any(check)) stop(paste("The following", 
              if (sum(check) > 1) "variables are" else "variable is",
              "not in the model:", paste(variables[check], collapse=", ")))
          vars <- variables
          }
      }

	if(missing(var.labels)) var.labels <- vars
	else {
		if (length(var.labels) < length(vars)) stop("Too few var.labels supplied")
	}
	
    n.resp <- length(vars)
    if (n.resp < 3) stop("Fewer than 3 response variables.")
    range <- apply(Y, 2, range)
    min <- - offset.axes
    max <- 1 + offset.axes
    old.par <- par(mfrow=c(n.resp, n.resp), mar=rep(0,4))
    on.exit(par(old.par))

	panel.label <- function(x, ...) {
		plot(c(min, max),c(min, max), type="n", axes=FALSE)
		text(0.5, 0.5, var.labels[i], cex=var.cex)
		text(1, 0, signif(range[1, i], digits=digits), adj=c(1, 0))
		text(0, 1, signif(range[2, i], digits=digits), adj=c(0, 1)) 
		box()
	}	
	for (i in 1:n.resp){
	  for (j in 1:n.resp){
	    if (i == j){
	      panel.label()
	    }
	    else {
	      heplot(x, variables=c(vars[j], vars[i]), manova=manova, axes=FALSE,
	             idata=idata, idesign=idesign, imatrix=imatrix, iterm=iterm,
	             offset.axes=offset.axes, fill=fill, fill.alpha=fill.alpha, ...)
	      box()
	    }
	  }
	}
}

