# plot.mlm:  diagnostic plots for a MLM
# 1: cqplot:  chisq QQ plot
# 2: mvinfluence plot?
# see: http://svitsrv25.epfl.ch/R-doc/library/snpMatrix/html/qq.chisq.html
#
# DONE: ✔️ `dist = "beta"`: exact scaled Beta(p/2, (n-p-1)/2) reference for classical D^2
#       (Gnanadesikan & Kettenring 1972), with an order-statistic envelope. Default stays
#       "chisq". Notes: dev/outliers-Rencher.md 11/27/2026
# DONE: ✔️ The "points with missing values" warning never fired (`nrow - length(OK)` is
#       always 0); `ylim` was NA when there were missing values 11/27/2026
# DONE: ✔️ Returned `p` is now the upper-tail p-value of the observed DSQ, not of its
#       theoretical quantile (which was just 1 - ppoints(n)) 11/27/2026
# TODO: 🚩 cqplot.mlm(): leverage-adjusted residual distances, (n-r) q_ii / (1 - h_ii), against
#       (n-r) * Beta(p/2, (n-r-p)/2) quantiles. Simulation agrees, but FIND A REFERENCE first
#       (start with Barrett & Ling 1992). See dev/outliers-Rencher.md
# TODO: 🚩 Maybe: Yang-Lee max-F p-value for the most extreme point; mention Mardia's test



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
#' For a data frame of numeric variables or a matrix supplied as the argument `x`,
#' it uses the Mahalanobis squared distances (\eqn{D^2}) of
#' observations \eqn{\mathbf{x}} from the centroid \eqn{\bar{\mathbf{x}}}
#' taking the sample covariance matrix \eqn{\mathbf{S}} into account,
#' \deqn{
#' D^2 = (\mathbf{x} - \bar{\mathbf{x}})^\prime \; \mathbf{S}^{-1} \; (\mathbf{x} - \bar{\mathbf{x}}) \; .
#' }
#' 
#' The method for `"mlm"` objects fit using [stats::lm()] for a multivariate response
#' applies this to the residuals from the model.
#'
#' The \eqn{\chi^2_p} reference distribution is an approximation. With `dist = "beta"`,
#' the exact (scaled) beta distribution of \eqn{D^2} for a multivariate normal sample
#' is used instead, which matters when \eqn{n} is small relative to \eqn{p}.
#' 
#' @details
#' 
#' `cqplot` is a more general version of similar functions in other
#' packages that produce chi square QQ plots. It allows for classical
#' Mahalanobis squared distances as well as robust estimates based on the MVE
#' and MCD; it provides an approximate confidence (concentration) envelope
#' around the line of unit slope, a detrended version, where the reference line
#' is horizontal, the ability to identify or label unusual points, and other
#' graphical features.
#' 
#' Cases with any missing values are excluded from the calculation and graph with a warning.
#'
#' \subsection{Reference distribution}{
#' The \eqn{\chi^2_p} distribution of \eqn{D^2} is only an approximation, which holds
#' as \eqn{n \rightarrow \infty}. It is poor when \eqn{n} is small relative to
#' \eqn{p}, and its long upper tail makes the largest distances, exactly where outliers
#' are judged, look less extreme than they are.
#'
#' For a sample of \eqn{n} observations from a multivariate normal distribution, with
#' the classical estimates \eqn{\bar{\mathbf{x}}} and \eqn{\mathbf{S}} (divisor
#' \eqn{n-1}), the *exact* distribution of \eqn{D^2} is a scaled beta
#' (Gnanadesikan & Kettenring, 1972):
#' \deqn{
#' \frac{n \, D^2}{(n-1)^2} \sim \text{Beta} \left( \frac{p}{2}, \frac{n-p-1}{2} \right) \; .
#' }
#' So \eqn{D^2} is bounded above by \eqn{(n-1)^2 / n}, unlike \eqn{\chi^2_p}.
#' With `dist = "beta"`, the sorted \eqn{D^2} values are plotted against
#' \eqn{(n-1)^2 / n} times the quantiles of this beta distribution at `ppoints(n)`,
#' which keeps the plot on the scale of \eqn{D^2}, with the same reference line
#' of unit slope. As \eqn{n} grows, the two references agree. See Rencher &
#' Christensen (2012), Sections 4.4.2 and 4.6.2, and Small (1978).
#'
#' The beta result applies only to classical estimates of location and scatter, so
#' `dist = "beta"` with `method = "mcd"` or `"mve"` gives a warning and uses
#' \eqn{\chi^2_p}. For `"mlm"` objects, it is applied to the residuals as if they
#' were a sample; this ignores their unequal variances (leverage) and the degrees of
#' freedom used by the model, so it is approximate.
#' }
#'
#' \subsection{Confidence envelope}{
#' In the typical use of QQ plots, it essential to have something in the nature of a confidence band
#' around the points to be able to appreciate whether, and to what degree the observed data points
#' differ from the reference distribution. For `cqplot`, this helps to assess whether the
#' data are reasonably distributed as multivariate normal and also to flag potential outliers.
#' 
#' The calculation of the confidence envelope here follows that used in the SAS
#' program, <https://github.com/friendly/SAS-macros/blob/master/cqplot.sas> which comes from
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
#' The pointwise confidence envelope of coverage `conf` = \eqn{1-\alpha} is then calculated as
#' \eqn{D^2_{(i)} \pm z_{1-\alpha/2} \text{se} ( D^2_{(i)} )}
#' 
#' For `dist = "beta"`, the envelope uses the fact that the \eqn{i}-th order statistic
#' of \eqn{n} uniform values has a Beta\eqn{(i, n-i+1)} distribution. Transforming its
#' \eqn{\alpha/2} and \eqn{1-\alpha/2} quantiles by the quantile function of the scaled
#' beta distribution of \eqn{D^2} gives a pointwise interval for \eqn{D^2_{(i)}}. This is
#' approximate, because the \eqn{D^2} values are not independent: they sum to exactly
#' \eqn{(n-1)p}.
#'
#' Note that these confidence envelopes apply only to the \eqn{D^2} computed
#' using the classical estimates of location (\eqn{\bar{\mathbf{x}}}) and scatter (\eqn{\mathbf{S}}). The
#' [car::qqPlot()]
#' function provides for simulated envelopes, but only for
#' a univariate measure. Oldford (2016) provides a general theory and methods
#' for QQ plots.
#' }
#' 
#' @aliases cqplot cqplot.default cqplot.mlm
#' @param x either a numeric data frame or matrix for the default method, or an
#'          object of class `"mlm"` representing a multivariate linear model.  In
#'          the latter case, residuals from the model are plotted.
#' @param \dots Other arguments passed to methods
#' @param method estimation method used for center and covariance, one of:
#'               `"classical"` (product-moment), `"mcd"` (minimum covariance
#'               determinant), or `"mve"` (minimum volume ellipsoid).
#' @param dist reference distribution for the theoretical quantiles: `"chisq"`
#'        (the default), the \eqn{\chi^2_p} approximation, or `"beta"`, the exact
#'        scaled beta distribution of classical \eqn{D^2} for a multivariate normal
#'        sample. See the section **Reference distribution** in Details.
#' @param detrend logical; if `FALSE`, the plot shows values of \eqn{D^2}
#'                vs. the theoretical quantiles. if `TRUE`, the ordinate shows
#'                values of \eqn{D^2} minus the theoretical quantiles
#' @param pch plot symbol for points. Can be a vector of length equal to the
#'            number of rows in `x`.
#' @param col color for points. Can be a vector of length equal to the
#'            number of rows in `x`.
#'            The default is the *first* entry in the
#'            current color palette (see [grDevices::palette()] and
#'            [graphics::par()]).
#' @param cex character symbol size for points.  Can be a vector of length
#'            equal to the number of rows in `x`.
#' @param ref.col Color for the reference line
#' @param ref.lwd Line width for the reference line
#' @param conf confidence coverage for the approximate confidence envelope
#' @param env.col line color for the boundary of the confidence envelope
#' @param env.lwd line width for the confidence envelope
#' @param env.lty line type for the confidence envelope
#' @param env.fill logical; should the confidence envelope be filled?
#' @param fill.alpha transparency value for `fill.color`
#' @param fill.color color used to fill the confidence envelope
#' @param labels vector of text strings to be used to identify points, defaults
#'            to `rownames(x)` or observation numbers if `rownames(x)` is
#'            `NULL`
#' @param id.n number of points labeled. If `id.n=0`, the default, no
#'             point identification occurs.
#' @param id.method point identification method. The default
#'             `id.method="r"` will identify the `id.n` points with the largest
#'             value of abs(y), i.e., the largest Mahalanobis DSQ. See [car::showLabels()] for other
#'             options.
#' @param id.cex size of text for point labels
#' @param id.col color for point labels
#' @param xlab label for horizontal (theoretical quantiles) axis
#' @param ylab label for vertical (empirical quantiles) axis
#' @param main plot title
#' @param what the name of the object plotted; used in the construction of
#'             `main` when that is not specified.
#' @param ylim limits for vertical axis.  If not specified, the range of the
#'             confidence envelope is used.
#' @return Returns invisibly a data.frame containing squared Mahalanobis distances (`DSQ`),
#'         their theoretical `quantile`s and `p`-values, for the identified
#'         points among the rows of `x` or the residuals of the model, else `NULL`
#'         if no points are identified. `p` is the upper-tail probability of `DSQ`
#'         under the reference distribution, `dist`. It is not adjusted for
#'         multiplicity.
#' @author Michael Friendly
#' @seealso [Mahalanobis()] for calculation of Mahalanobis squared distance;
#' 
#' [stats::qqplot()]; [car::qqPlot()] can give a similar
#'          result for Mahalanobis squared distances of data or residuals;
#'          [qqtest::qqtest()] has many features for all types of QQ plots.
#' @references 
#' J. Chambers, W. S. Cleveland, B. Kleiner, P. A. Tukey (1983).
#' *Graphical methods for data analysis*, Wadsworth.
#' 
#' R. Gnanadesikan, J. R. Kettenring (1972). Robust estimates, residuals, and outlier
#' detection with multiresponse data. *Biometrics*, 28, 81-124.
#'
#' R. W. Oldford (2016), "Self calibrating quantile-quantile plots",
#' *The American Statistician*, 70, 74-90.
#'
#' A. C. Rencher, W. F. Christensen (2012). *Methods of Multivariate Analysis*,
#' 3rd ed. Wiley.
#'
#' N. J. H. Small (1978). Plotting squared radii. *Biometrika*, 65, 657-658.
#' 
#' @family diagnostic plots
#' @keywords hplot
#' @keywords multivariate
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
#' # small n: compare the chi-square and exact beta references.
#' # With beta, boys 8, 12 and 20 fall outside the envelope
#' data(Ramus)
#' op <- par(mfrow = c(1, 2))
#' cqplot(Ramus, id.n = 4, main = "chi-square")
#' cqplot(Ramus, id.n = 4, dist = "beta", main = "beta")
#' par(op)
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
			dist = c("chisq", "beta"),
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

  method <- match.arg(method)
  dist <- match.arg(dist)
  if (dist == "beta" && method != "classical") {
    warning(glue::glue("dist = \"beta\" applies only to method = \"classical\"; ",
                       "using dist = \"chisq\" for method = \"{method}\""))
    dist <- "chisq"
  }

	df <- ncol(x)
	data <- as.matrix(x)
	OK <- complete.cases(x)
	miss <- sum(!OK)
	if (miss > 0) warning(glue::glue("{miss} points with missing values have been excluded"))

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

  if (dist == "chisq") {
    quant <- qchisq(p, df)
    # approximate confidence envelope, Chambers et al. (1983)
    g <- (quant ^(-1+df/2)) / (exp(quant/2) * gamma(df/2) * (sqrt(2)^df))
    scale <- IQR(dsq, na.rm=TRUE) / diff(qchisq(c(.25, .75), df))
    se <- (scale/g) * sqrt( p * (1-p) /n)
    semult <- qnorm(1 - (1 - conf)/2)
    lower <- quant - semult * se
    upper <- quant + semult * se
    pfun <- function(d) pchisq(d, df, lower.tail = FALSE)
  }
  else {
    # exact: n D^2 / (n-1)^2 ~ Beta(p/2, (n-p-1)/2), Gnanadesikan & Kettenring (1972)
    if (n <= df + 1)
      stop(glue::glue("dist = \"beta\" needs n > p + 1, but n = {n} complete cases ",
                      "and p = {df} variables"))
    a <- df / 2
    b <- (n - df - 1) / 2
    k <- (n - 1)^2 / n
    quant <- k * qbeta(p, a, b)
    # pointwise envelope: the i-th uniform order statistic is Beta(i, n - i + 1)
    i <- seq_len(n)
    alpha <- 1 - conf
    lower <- k * qbeta(qbeta(alpha/2, i, n - i + 1), a, b)
    upper <- k * qbeta(qbeta(1 - alpha/2, i, n - i + 1), a, b)
    pfun <- function(d) pbeta(d / k, a, b, lower.tail = FALSE)
  }
  if (detrend) {
    lower <- lower - quant
    upper <- upper - quant
  }

  if (missing(xlab))
      xlab <- if (dist == "chisq") bquote(~ chi[.(df)]^2 ~ " Quantile" )
              else glue::glue("Scaled Beta({a}, {b}) Quantile")

  if (missing(ylab))
      ylab <- paste( if (detrend) "Centered" else "",
                    "Squared Mahalanobis Distance" )
	if (missing(main))
			main <- paste( if (detrend) "Detrended" else "",
			 if (dist == "chisq") "Chi-Square" else "Beta",
			 "Q-Q Plot of", what)

	if (missing(ylim))
			ylim <- if(detrend) range(lower, upper, dsq.y - quant)
							else c(0, max(dsq.y, upper))

	y <- if (detrend) dsq.y - quant else dsq.y
  plot(quant, y, type="n",
		main = main, 
    ylab = ylab, 
    xlab = xlab,
    ylim = ylim,  ...)
  if (env.fill) shade(quant, upper, quant, lower, col=fill.color )
  lines(quant, lower, col=env.col, lwd=env.lwd, lty=env.lty)
  lines(quant, upper, col=env.col, lwd=env.lwd, lty=env.lty)
  points(quant, y, pch = pch, col=col, cex=cex)

  abline(0, if (detrend) 0 else 1, lwd = ref.lwd, col = ref.col)
  if (!missing(id.n)) {
  	noteworthy <- car::showLabels(quant, y, labels=labs, id.method=id.method,
  		id.n=id.n,  id.cex = id.cex, id.col = id.col)

  	res <- data.frame(DSQ = dsq.y[noteworthy],
  	                  quantile = quant[noteworthy],
  	                  p = pfun(dsq.y[noteworthy]))
  	rownames(res) <- labs[noteworthy]
  	return(invisible(res))
  }
  else return(invisible(NULL))

}

