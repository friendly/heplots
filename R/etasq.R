# partial eta^2 measures of association for multivariate tests
# (mod of car:::print.Anova.mlm, just for testing)
# added etasq.lm 7/29/2010
# fixed buglet in etasq.lm 12/5/2010
# copied stats:::Pillai, etc. to utility.R to avoid using :::
# fixed issue #1 in etasq.lm 3/26/2019



#' Measures of Partial Association (Eta-squared) for Linear Models
#' 
#' Calculates partial eta-squared for linear models or multivariate analogs of
#' eta-squared (or R^2), indicating the partial association for each term in a
#' multivariate linear model. There is a different analog for each of the four
#' standard multivariate test statistics: Pillai's trace, Hotelling-Lawley
#' trace, Wilks' Lambda and Roy's maximum root test.
#' 
#' For univariate linear models, classical 
#' \eqn{\eta^2} = SSH / SST and partial
#' \eqn{\eta^2} = SSH / (SSH + SSE).  These are identical in one-way designs.
#' 
#' Partial eta-squared describes the proportion of total variation attributable
#' to a given factor, partialing out (excluding) other factors from the total
#' nonerror variation. These are commonly used as measures of effect size or
#' measures of (non-linear) strength of association in ANOVA models.
#' 
#' All multivariate tests are based on the \eqn{s=min(p, df_h)} latent roots of
#' \eqn{H E^{-1}}. The analogous multivariate partial \eqn{\eta^2} measures are
#' calculated as:
#' 
#' \describe{ 
#' \item{Pillai's trace (V)}{\eqn{\eta^2 = V/s}}
#' \item{Hotelling-Lawley trace (T)}{\eqn{\eta^2 = T/(T+s)}} 
#' \item{Wilks' Lambda (L)}{\eqn{\eta^2 = L^{1/s}}} 
#' \item{Roy's maximum root (R)}{\eqn{\eta^2 = R/(R+1)}} 
#' }
#' 
#' @aliases etasq etasq.lm etasq.mlm etasq.Anova.mlm
#' @param x A \code{lm}, \code{mlm} or \code{Anova.mlm} object
#' @param anova A logical, indicating whether the result should also contain
#'         the test statistics produced by \code{Anova()}.
#' @param partial A logical, indicating whether to calculate partial or
#'         classical eta^2.
#' @param \dots Other arguments passed down to \code{\link[car]{Anova}}.
#' @return When \code{anova=FALSE}, a one-column data frame containing the
#' eta-squared values for each term in the model.
#' 
#' When \code{anova=TRUE}, a 5-column (lm) or 7-column (mlm) data frame
#' containing the eta-squared values and the test statistics produced by
#' \code{print.Anova()} for each term in the model.
#' 
#' @author Michael Friendly
#' @seealso \code{\link[car]{Anova}}
#' @references Muller, K. E. and Peterson, B. L. (1984). Practical methods for
#' computing power in testing the Multivariate General Linear Hypothesis
#' \emph{Computational Statistics and Data Analysis}, 2, 143-158.
#' 
#' Muller, K. E. and LaVange, L. M. and Ramey, S. L. and Ramey, C. T. (1992).
#' Power Calculations for General Linear Multivariate Models Including Repeated
#' Measures Applications. \emph{Journal of the American Statistical
#' Association}, 87, 1209-1226.
#' @keywords multivariate
#' @examples
#' 
#' data(Soils, package="carData")
#' soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth, data=Soils)
#' #Anova(soils.mod)
#' etasq(Anova(soils.mod))
#' etasq(soils.mod) # same
#' etasq(Anova(soils.mod), anova=TRUE)
#' 
#' etasq(soils.mod, test="Wilks")
#' etasq(soils.mod, test="Hotelling")
#' 
#' @importFrom car Anova
#' @export etasq
etasq <- function(x, ...){
	UseMethod("etasq", x)
}

#' @rdname etasq
#' @exportS3Method  etasq mlm
etasq.mlm <- function(x, ...) {
	etasq(Anova(x, ...))
}

#' @rdname etasq
#' @exportS3Method  etasq Anova.mlm
etasq.Anova.mlm <- function(x, anova=FALSE, ...){
	test <- x$test
	if (test == "Roy") warning("eta^2 not defined for Roy's test")
	repeated <- x$repeated
	ntests <- length(x$terms)
	tests <- matrix(NA, ntests, 4)
	assoc <- rep(NA, ntests)
	if (!repeated) SSPE.qr <- qr(x$SSPE) 
	for (term in 1:ntests){
		# some of the code here adapted from stats:::summary.manova
		eigs <- Re(eigen(qr.coef(if (repeated) qr(x$SSPE[[term]]) else SSPE.qr,
								x$SSP[[term]]), symmetric = FALSE)$values)
		tests[term, 1:4] <- switch(test,
				Pillai = Pillai(eigs, x$df[term], x$error.df),
				Wilks = Wilks(eigs, x$df[term], x$error.df),
				"Hotelling-Lawley" = HL(eigs, x$df[term], x$error.df),
				Roy = Roy(eigs, x$df[term], x$error.df))
		s <- min(length(eigs), x$df[term])
		assoc[term] <- switch(test,
			Pillai = tests[term,1] / s,
			Wilks = 1 - tests[term,1] ^(1/s),
			"Hotelling-Lawley" = tests[term,1] / (tests[term,1] + s),
			Roy = tests[term,1] / (tests[term,1] + 1))
			
	}
	ok <- tests[, 2] >= 0 & tests[, 3] > 0 & tests[, 4] > 0
	ok <- !is.na(ok) & ok
	if(anova) {
  	result <- cbind(assoc, x$df, tests, pf(tests[ok, 2], tests[ok, 3], tests[ok, 4], 
  					lower.tail = FALSE))
  	rownames(result) <- x$terms
  	colnames(result) <- c("eta^2", "Df", "test stat", "approx F", "num Df", "den Df", "Pr(>F)")
  	result <- structure(as.data.frame(result), 
  			heading = paste("\nType ", x$type, if (repeated) " Repeated Measures",
  					" MANOVA Tests: ", test, " test statistic", sep=""), 
  			class = c("anova", "data.frame"))
	}
	else {
		result <- data.frame(assoc)
  	rownames(result) <- x$terms
  	colnames(result) <- "eta^2"
		
	}
	
	result      
}

#' @rdname etasq
#' @exportS3Method  etasq lm
etasq.lm <- function(x, anova=FALSE, partial=TRUE, ...) {
	aov <-Anova(x, ...)
	neff <- nrow(aov)
	SSH <- aov[-neff,1]
	SSE <- aov[neff,1]
#	SST <- sum(SSH) + SSE
	# fix etasq per philchalmers #1
	y <- model.frame(x)[ ,1]
	SST <- sum( (y - mean(y))^2 )
	eta2 <- if (partial) c(SSH / (SSH + SSE), NA) else c(SSH / SST, NA)
	etalab <- if (partial) "Partial eta^2" else "eta^2"
	if (anova) {
		result <- cbind(eta2, aov)
		rownames(result) <- rownames(aov)
		colnames(result) <- c(etalab, colnames(aov))
		result <- structure(as.data.frame(result), 
				heading = attr(aov, "heading"), 
				class = c("anova", "data.frame"))
	}
	else {
		result <- data.frame(eta2)
		rownames(result) <- rownames(aov)
		colnames(result) <- etalab
	}
	result      
}

