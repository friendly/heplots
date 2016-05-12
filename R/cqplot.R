# plot.mlm:  diagnostic plots for a MLM
# 1: cqplot:  chisq QQ plot
# 2: mvinfluence plot?
# see: http://svitsrv25.epfl.ch/R-doc/library/snpMatrix/html/qq.chisq.html

`cqplot` <-
		function(x, ...) UseMethod("cqplot")

cqplot.mlm <-
		function(x, ...) {
		
		resids <- residuals(x)
		cqplot.default(resids, what=deparse(substitute(x)), ...)
}


cqplot.default <- 
		function(x,
			method=c("classical", "mcd", "mve"), 
			detrend=FALSE, 
			pch=19, col = palette()[1],
			ref.col="red", ref.lwd=2,
			conf = 0.95,
			env.col="gray", env.lwd=2, env.lty=1, env.fill=TRUE,  fill.alpha=0.2,
			fill.color=trans.colors(ref.col, fill.alpha),
			labels = if (!is.null(rownames(x))) rownames(x) else 1:nrow(x),
			id.n, id.method="y", id.cex=1, id.col = palette()[1],
			xlab, ylab, main, what=deparse(substitute(x)), ylim, ...) {

  # Function to shade concentration band  
  shade <- function(x1, y1, x2, y2, col) {
    n <- length(x2)
    polygon(c(x1, x2[n:1]), c(y1, y2[n:1]), border=NA, col=col)
  }

	df <- ncol(x)
	data <- as.matrix(x)
	OK <- complete.cases(x)

  dsq <- Mahalanobis(data, method=method)
  ord <- order(dsq[OK])
	dsq.y <- dsq[OK][ord]
	labs <- labels[OK][ord]

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
  points(chi2q, y, pch = pch, col=col)
  
  abline(0, if (detrend) 0 else 1, lwd = ref.lwd, col = ref.col)
  if (!missing(id.n)) {
  	res <- car::showLabels(chi2q, y, labels=labs, id.method=id.method, 
  		id.n=id.n,  id.cex = id.cex, id.col = id.col)
  }

	res <- dsq  
  invisible(res)
}

