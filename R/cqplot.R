# plot.mlm:  diagnostic plots for a MLM
# 1: cqplot:  chisq QQ plot
# 2: mvinfluence plot?
# see: http://svitsrv25.epfl.ch/R-doc/library/snpMatrix/html/qq.chisq.html



#' Chi Square Quantile-Quantile plots
#' 
#' @description
#' 
#' A chi square quantile-quantile plots show the relationship between
#' data-based values which should be distributed as \eqn{\chi^2} and
#' corresponding quantiles from the \eqn{\chi^2} distribution.  In multivariate
#' analyses, this is often used both to assess multivariate normality and check
#' for or identify outliers.  
#' 
#' For a data frame of numeric variables or a matrix supplied as the argument \code{x},
#' it uses the Mahalanobis squared distances (\eqn{D^2}) of
#' observations \eqn{\mathbf{x}} from the centroid \eqn{\bar{\mathbf{x}}}
#' taking the sample covariance matrix \eqn{\mathbf{S}} into account,
#' \deqn{
#' D^2 = (\mathbf{x} - \bar{\mathbf{x}})^\prime \; \mathbf{S}^{-1} \; (\mathbf{x} - \bar{\mathbf{x}}) \; .
#' }
#' 
#' The method for \code{"mlm"} objects fit using \code{\link[stats]{lm}} for a multivariate response
#' applies this to the residuals from the model.
#' 
#' @details
#' 
#' \code{cqplot} is a more general version of similar functions in other
#' packages that produce chi square QQ plots. It allows for classical
#' Mahalanobis squared distances as well as robust estimates based on the MVE
#' and MCD; it provides an approximate confidence (concentration) envelope
#' around the line of unit slope, a detrended version, where the reference line
#' is horizontal, the ability to identify or label unusual points, and other
#' graphical features.
#' 
#' Cases with any missing values are excluded from the calculation and graph with a warning.
#' 
#' \subsection{Confidence envelope}{
#' In the typical use of QQ plots, it essential to have something in the nature of a confidence band
#' around the points to be able to appreciate whether, and to what degree the observed data points
#' differ from the reference distribution. For \code{cqplot}, this helps to assess whether the
#' data are reasonably distributed as multivariate normal and also to flag potential outliers.
#' 
#' The calculation of the confidence envelope here follows that used in the SAS
#' program, \url{http://www.datavis.ca/sasmac/cqplot.html} which comes from
#' Chambers et al. (1983), Section 6.8.
#' 
#' The essential formula computes the standard errors as: 
#' \deqn{ \text{se} ( D^2_{(i)} ) = \frac{\hat{b}} {d ( q_i)} \times \sqrt{  p_i (1-p_i) / n } }
#' where \eqn{D^2_{(i)}} is the i-th
#' ordered value of \eqn{D^2}, \eqn{\hat{b}} is an estimate of the slope of
#' the reference line obtained from the ratio of the interquartile range of the
#' \eqn{D^2} values to that of the \eqn{\chi^2_p} distribution and
#' \eqn{d(q_i)} is the density of the chi square distribution at the quantile
#' \eqn{q_i}. 
#' 
#' The pointwise confidence envelope of coverage \code{conf} = \eqn{1-\alpha} is then calculated as
#' \eqn{D^2_{(i)} \pm z_{1-\alpha/2} \text{se} ( D^2_{(i)} )}
#' 
#' Note that this confidence envelope applies only to the \eqn{D^2} computed
#' using the classical estimates of location (\eqn{\bar{\mathbf{x}}}) and scatter (\eqn{\mathbf{S}}). The
#' \code{\link[car]{qqPlot}}
#' function provides for simulated envelopes, but only for
#' a univariate measure. Oldford (2016) provides a general theory and methods
#' for QQ plots.
#' }
#' 
#' @aliases cqplot cqplot.default cqplot.mlm
#' @param x either a numeric data frame or matrix for the default method, or an
#'          object of class \code{"mlm"} representing a multivariate linear model.  In
#'          the latter case, residuals from the model are plotted.
#' @param \dots Other arguments passed to methods
#' @param method estimation method used for center and covariance, one of:
#'               \code{"classical"} (product-moment), \code{"mcd"} (minimum covariance
#'               determinant), or \code{"mve"} (minimum volume ellipsoid).
#' @param detrend logical; if \code{FALSE}, the plot shows values of \eqn{D^2}
#'                vs. \eqn{\chi^2}. if \code{TRUE}, the ordinate shows values of \eqn{D^2 -
#' \chi^2}
#' @param pch plot symbol for points. Can be a vector of length equal to the
#'            number of rows in \code{x}.
#' @param col color for points. Can be a vector of length equal to the
#'            number of rows in \code{x}.
#'            The default is the \emph{first} entry in the
#'            current color palette (see \code{\link[grDevices]{palette}} and
#'            \code{\link[graphics]{par}}).
#' @param cex character symbol size for points.  Can be a vector of length
#'            equal to the number of rows in \code{x}.
#' @param ref.col Color for the reference line
#' @param ref.lwd Line width for the reference line
#' @param conf confidence coverage for the approximate confidence envelope
#' @param env.col line color for the boundary of the confidence envelope
#' @param env.lwd line width for the confidence envelope
#' @param env.lty line type for the confidence envelope
#' @param env.fill logical; should the confidence envelope be filled?
#' @param fill.alpha transparency value for \code{fill.color}
#' @param fill.color color used to fill the confidence envelope
#' @param labels vector of text strings to be used to identify points, defaults
#'            to \code{rownames(x)} or observation numbers if \code{rownames(x)} is
#'            \code{NULL}
#' @param id.n number of points labeled. If \code{id.n=0}, the default, no
#'             point identification occurs.
#' @param id.method point identification method. The default
#'             \code{id.method="r"} will identify the \code{id.n} points with the largest
#'             value of abs(y), i.e., the largest Mahalanobis DSQ. See \code{\link[car]{showLabels}} for other
#'             options.
#' @param id.cex size of text for point labels
#' @param id.col color for point labels
#' @param xlab label for horizontal (theoretical quantiles) axis
#' @param ylab label for vertical (empirical quantiles) axis
#' @param main plot title
#' @param what the name of the object plotted; used in the construction of
#'             \code{main} when that is not specified.
#' @param ylim limits for vertical axis.  If not specified, the range of the
#'             confidence envelope is used.
#' @return Returns invisibly a data.frame containing squared Mahalanobis distances (\code{DSQ}), 
#'         their \code{quantile}s and \code{p}-values
#'             corresponding to the rows of \code{x} or the residuals of the model for the identified points, 
#'             else \code{NULL} if no points are identified.
#' @author Michael Friendly
#' @seealso \code{\link{Mahalanobis}} for calculation of Mahalanobis squared distance;
#' 
#' \code{\link[stats]{qqplot}}; \code{\link[car]{qqPlot}} can give a similar
#'          result for Mahalanobis squared distances of data or residuals;
#'          \code{\link[qqtest]{qqtest}} has many features for all types of QQ plots.
#' @references 
#' J. Chambers, W. S. Cleveland, B. Kleiner, P. A. Tukey (1983).
#' \emph{Graphical methods for data analysis}, Wadsworth.
#' 
#' R. W. Oldford (2016), "Self calibrating quantile-quantile plots", 
#' \emph{The American Statistician}, 70, 74-90.
#' @keywords hplot
#' @examples
#' 
#' 
#' cqplot(iris[, 1:4])
#' 
#' iris.mod <- lm(as.matrix(iris[,1:4]) ~ Species, data=iris)
#' out <- cqplot(iris.mod, id.n=3)
#' # show return value
#' out
#' 
#' # compare with car::qqPlot
#' car::qqPlot(Mahalanobis(iris[, 1:4]), dist="chisq", df=4)
#' 
#' 
#' # Adopted data
#' Adopted.mod <- lm(cbind(Age2IQ, Age4IQ, Age8IQ, Age13IQ) ~ AMED + BMIQ, 
#'                   data=Adopted)
#' cqplot(Adopted.mod, id.n=3)
#' cqplot(Adopted.mod, id.n=3, method="mve")
#' 
#' 
#' # Sake data
#' Sake.mod <- lm(cbind(taste, smell) ~ ., data=Sake)
#' cqplot(Sake.mod)
#' cqplot(Sake.mod, method="mve", id.n=2)
#' 
#' # SocialCog data -- one extreme outlier
#' data(SocialCog)
#' SC.mlm <-  lm(cbind(MgeEmotions,ToM, ExtBias, PersBias) ~ Dx,
#'                data=SocialCog)
#' cqplot(SC.mlm, id.n=1)
#' 
#' # data frame example: stackloss data
#' data(stackloss)
#' cqplot(stackloss[, 1:3], id.n=4)                # very strange
#' cqplot(stackloss[, 1:3], id.n=4, detrend=TRUE)
#' cqplot(stackloss[, 1:3], id.n=4, method="mve")
#' cqplot(stackloss[, 1:3], id.n=4, method="mcd")
#' 
#' 
#' 
#' @export cqplot
`cqplot` <-
		function(x, ...) UseMethod("cqplot")

#' @rdname cqplot
#' @exportS3Method cqplot mlm
cqplot.mlm <-
		function(x, ...) {
		
		resids <- residuals(x)
		cqplot.default(resids, what=deparse(substitute(x)), ...)
}


#' @rdname cqplot
#' @exportS3Method cqplot default
cqplot.default <- 
		function(x,
			method = c("classical", "mcd", "mve"), 
			detrend = FALSE, 
			pch = 19, 
			col  =  palette()[1], 
			cex  =  par("cex"),
			ref.col = "red", 
			ref.lwd = 2,
			conf  =  0.95,
			env.col = "gray", 
			env.lwd = 2, 
			env.lty = 1, 
			env.fill = TRUE,  
			fill.alpha = 0.2,
			fill.color = trans.colors(ref.col, fill.alpha),
			labels  =  if (!is.null(rownames(x))) rownames(x) else 1:nrow(x),
			id.n, 
			id.method = "r", 
			id.cex = 1, 
			id.col  =  palette()[1],
			xlab, ylab, 
			main, 
			what = deparse(substitute(x)), 
			ylim, ...) {

  # Function to shade concentration band  
  shade <- function(x1, y1, x2, y2, col) {
    n <- length(x2)
    polygon(c(x1, x2[n:1]), c(y1, y2[n:1]), border=NA, col=col)
  }

	df <- ncol(x)
	data <- as.matrix(x)
	OK <- complete.cases(x)
	miss <- nrow(data) - length(OK)
	if (miss > 0) warning(paste(miss, "points with missing values have been excluded"))

  dsq <- Mahalanobis(data, method=method)
  ord <- order(dsq[OK])
	dsq.y <- dsq[OK][ord]
	labs <- labels[OK][ord]

  # allow col, pch, and cex to be vectors
	if (length(col) == nrow(x)) 
	  col <- col[OK][ord]
	if (length(pch) == nrow(x)) 
	  pch <- pch[OK][ord]
	if (length(cex) == nrow(x)) 
	  cex <- cex[OK][ord]
	
	n <- length(ord)
  p <- ppoints(n)
  chi2q <- qchisq(p, df)

  # approximate confidence envelope
  g <- (chi2q ^(-1+df/2)) / (exp(chi2q/2) * gamma(df/2) * (sqrt(2)^df))
  scale <- IQR(dsq, na.rm=TRUE) / diff(qchisq(c(.25, .75), df))
  se <- (scale/g) * sqrt( p * (1-p) /n)

	semult <- qnorm(1 - (1 - conf)/2)
  lower <- if (detrend) - semult * se else chi2q - semult * se
  upper <- if (detrend)   semult * se else chi2q + semult * se

  if (missing(xlab)) 
      xlab <- bquote(~ chi[.(df)]^2 ~ " Quantile" )

  if (missing(ylab)) 
      ylab <- paste( if (detrend) "Centered" else "",
                    "Squared Mahalanobis Distance" )
	if (missing(main))
			main <- paste( if (detrend) "Detrended" else "",
			 "Chi-Square Q-Q Plot of", what)
			
	if (missing(ylim))
			ylim <- if(detrend) c(min(lower), max(upper))
							else c(0, max(dsq, upper))

	y <- if (detrend) dsq.y - chi2q else dsq.y
  plot(chi2q, y, type="n",
		main = main, 
    ylab = ylab, 
    xlab = xlab,
    ylim = ylim,  ...)
  if (env.fill) shade(chi2q, upper, chi2q, lower, col=fill.color )
  lines(chi2q, lower, col=env.col, lwd=env.lwd, lty=env.lty)
  lines(chi2q, upper, col=env.col, lwd=env.lwd, lty=env.lty)
  points(chi2q, y, pch = pch, col=col, cex=cex)
  
  abline(0, if (detrend) 0 else 1, lwd = ref.lwd, col = ref.col)
  if (!missing(id.n)) {
  	noteworthy <- car::showLabels(chi2q, y, labels=labs, id.method=id.method, 
  		id.n=id.n,  id.cex = id.cex, id.col = id.col)
  	
  	res <- data.frame(DSQ = dsq.y[noteworthy], 
  	                  quantile = chi2q[noteworthy],
  	                  p = pchisq(chi2q[noteworthy], df, lower.tail = FALSE))
  	rownames(res) <- labs[noteworthy]
  	return(invisible(res))
  }
  else return(invisible(NULL))

}

