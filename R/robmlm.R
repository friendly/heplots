### robust multivariate linear regression

## John Fox 2012-06-02
## revised: 2013-08-20 to avoid calling summary.mlm() directly in vcov.mlm()
## TODO: what about using MASS::cob.rob, allowing MCD, MVE?



#' Robust Fitting of Multivariate Linear Models
#'
#' @description
#'  
#' Fit a multivariate linear model by robust regression using a simple M
#' estimator that down-weights observations with large residuals
#' 
#' Fitting is done by iterated re-weighted least squares (IWLS), using weights
#' based on the Mahalanobis squared distances of the current residuals from the
#' origin, and a scaling (covariance) matrix calculated by
#' \code{\link[MASS]{cov.trob}}. The design of these methods were loosely
#' modeled on \code{\link[MASS]{rlm}}.
#' 
#' These S3 methods are designed to provide a specification of a class of
#' robust methods which extend \code{mlm}s, and are therefore compatible with
#' other \code{mlm} extensions, including \code{\link[car]{Anova}} and
#' \code{\link{heplot}}.
#' 
#' An internal \code{vcov.mlm} function is an extension of the standard
#' \code{\link[stats]{vcov}} method providing for the use of observation weights.
#' A \code{\link{plot.robmlm}} method provides simple index plots of case weights
#' to visualize those that were down-weighted.

#' @details
#' 
#' Weighted least squares provides a method for correcting a variety of problems in linear models
#' by estimating parameters that minimize the \emph{weighted} sum of squares of residuals
#' \eqn{\Sigma w_i e_i^2} for specified weights \eqn{w_i, i = 1, 2, \dots n}.
#' 
#' M-estimation generalizes this by minimizing the sum of a symmetric function 
#' \eqn{\rho(e_i)} of the residuals, where the function is designed to reduce the influence
#' of outliers or badly fit observations. The function \eqn{\rho(e_i) = | e_i |}
#' minimizes the least absolute values, while the \emph{bisquare} function uses an upper bound
#' on influence. For multivariate problems, a simple method is to use Mahalanobis \eqn{D^2 (\mathbf{e}_i)}
#' to calculate the weights.
#' 
#' Because the weights and the estimated coefficients depend on each other, this is done
#' iteratively, computing weights and then re-estimating the model with those weights
#' until convergence.
#' 
#' @aliases print.robmlm print.summary.robmlm robmlm robmlm.default
#'          robmlm.formula summary.robmlm
#' @param formula a formula of the form \code{cbind(y1, y2, ...) ~ x1 + x2 + ...}.
#' @param data a data frame from which variables specified in \code{formula}
#'        are preferentially to be taken.
#' @param subset An index vector specifying the cases to be used in fitting.
#' @param weights a vector of prior weights for each case.
#' @param na.action A function to specify the action to be taken if \code{NA}s
#'        are found.  The 'factory-fresh' default action in R is
#'        \code{\link[stats]{na.omit}}, and can be changed by
#'        \code{\link[base]{options}}\code{(na.action=)}.
#' @param model should the model frame be returned in the object?
#' @param contrasts optional contrast specifications; see
#'        \code{\link[stats]{lm}} for details.
#' @param \dots other arguments, passed down. In particular relevant control
#'         arguments can be passed to the to the \code{robmlm.default} method.
#' @param X for the default method, a model matrix, including the constant (if
#'        present)
#' @param Y for the default method, a response matrix
#' @param w prior observation weights
#' @param P two-tail probability, to find cutoff quantile for chisq (tuning
#'        constant); default is set for bisquare weight function
#' @param tune tuning constant (if given directly)
#' @param max.iter maximum number of iterations
#' @param psi robustness weight function; \code{\link[MASS]{psi.bisquare}} is
#'        the default
#' @param tol convergence tolerance, maximum relative change in coefficients
#' @param initialize modeling function to find start values for coefficients,
#'        equation-by-equation; if absent WLS (\code{lm.wfit}) is used
#' @param verbose show iteration history? (\code{TRUE} or \code{FALSE})
#' @param x a \code{robmlm} object
#' @param object a \code{robmlm} object
#' @return An object of class \code{"robmlm"} inheriting from \code{c("mlm",
#' "lm")}.
#' 
#'  This means that the returned \code{"robmlm"} contains all the components of
#'  \code{"mlm"} objects described for \code{\link[stats]{lm}}, plus the
#'  following: 
#'  \describe{
#'    \item{weights }{final observation weights} 
#'    \item{iterations }{number of iterations} 
#'    \item{converged }{logical: did the IWLS process converge?}
#'  }
#' 
#' The generic accessor functions \code{\link[stats]{coefficients}},
#' \code{\link[stats]{effects}}, \code{\link[stats]{fitted.values}} and
#' \code{\link[stats]{residuals}} extract various useful features of the value
#' returned by \code{robmlm}.
#' @author John Fox; packaged by Michael Friendly
#' 
#' @seealso
#'  \code{\link{plot.robmlm}} for a plot method;
#'     \code{\link[MASS]{rlm}}, \code{\link[MASS]{cov.trob}}
#' @references 
#' A. Marazzi (1993) \emph{Algorithms, Routines and S Functions for
#' Robust Statistics}.  Wadsworth & Brooks/Cole.
#' @keywords multivariate robust
#' @examples
#' 
#' # Skulls data
#' # -----------
#' data(Skulls)
#' 
#' # make shorter labels for epochs and nicer variable labels in heplots
#' Skulls$epoch <- factor(Skulls$epoch, labels=sub("c","",levels(Skulls$epoch)))
#' # variable labels
#' vlab <- c("maxBreadth", "basibHeight", "basialLength", "nasalHeight")
#' 
#' # fit manova model, classically and robustly
#' sk.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' sk.rmod <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' 
#' # standard mlm methods apply here
#' coefficients(sk.rmod)
#' 
#' # index plot of weights
#' plot(sk.rmod, segments = TRUE, col = Skulls$epoch)
#' points(sk.rmod$weights, pch=16, col=Skulls$epoch)
#' text(x = 15+seq(0,120,30), y = 1.05, labels=levels(Skulls$epoch), xpd=TRUE)
#' 
#' # heplots to see effect of robmlm vs. mlm
#' heplot(sk.mod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), 
#'     xlab=vlab[1], ylab=vlab[2], cex=1.25, lty=1)
#' heplot(sk.rmod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), 
#'     add=TRUE, error.ellipse=TRUE, lwd=c(2,2), lty=c(2,2), 
#'     term.labels=FALSE, hyp.labels=FALSE, err.label="")
#' 
#' ##############
#' # Pottery data
#' 
#' data(Pottery, package = "carData")
#' pottery.mod <- lm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
#' pottery.rmod <- robmlm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
#' car::Anova(pottery.mod)
#' car::Anova(pottery.rmod)
#' 
#' # index plot of weights
#' plot(pottery.rmod$weights, type="h")
#' points(pottery.rmod$weights, pch=16, col=Pottery$Site)
#' 
#' # heplots to see effect of robmlm vs. mlm
#' heplot(pottery.mod, cex=1.3, lty=1)
#' heplot(pottery.rmod, add=TRUE, error.ellipse=TRUE, lwd=c(2,2), lty=c(2,2), 
#'     term.labels=FALSE, err.label="")
#' 
#' ###############
#' # Prestige data
#' data(Prestige, package = "carData")
#' 
#' # treat women and prestige as response variables for this example
#' prestige.mod <- lm(cbind(women, prestige) ~ income + education + type, data=Prestige)
#' prestige.rmod <- robmlm(cbind(women, prestige) ~ income + education + type, data=Prestige)
#' 
#' coef(prestige.mod)
#' coef(prestige.rmod)
#' # how much do coefficients change?
#' round(coef(prestige.mod) - coef(prestige.rmod),3)
#' 
#' # pretty plot of case weights
#' plot(prestige.rmod$weights, type="h", xlab="Case Index", ylab="Robust mlm weight", col="gray")
#' points(prestige.rmod$weights, pch=16, col=Prestige$type)
#' legend(0, 0.7, levels(Prestige$type), pch=16, col=palette()[1:3], bg="white")
#' 
#' heplot(prestige.mod, cex=1.4, lty=1)
#' heplot(prestige.rmod, add=TRUE, error.ellipse=TRUE, lwd=c(2,2), lty=c(2,2), 
#'     term.labels=FALSE, err.label="")
#' 
#' 
#' 
#' @export robmlm
robmlm <- function(X, ...){
  UseMethod("robmlm")
}

#' @rdname robmlm
#' @exportS3Method robmlm default
#' @importFrom MASS psi.bisquare cov.trob
robmlm.default <- function(X, Y, w, P=2*pnorm(4.685, lower.tail=FALSE), 
                           tune, max.iter=100, psi=psi.bisquare, tol=1e-6, 
                           initialize, verbose=FALSE, ...){
  # args:
  #   X: model matrix, including constant (if present)
  #   Y: response matrix
  #   w: prior weights
  #   P: two-tail probability, to find cutoff quantile for chisq (tuning constant);
  #       default is set for bisquare weight function
  #   tune: tuning constant (if given directly)
  #   max.iter: iteration limit
  #   psi: robustness weight function; psi.bisquare (from MASS) is default
  #   tol: convergence tolerance, maximum relative change in coefficients
  #   initialize: modeling function to find start values for coefficients,
  #       equation-by-equation; if absent WLS is used
  #   verbose: show iteration history?
  #if (!require(MASS)) stop("MASS package missing")
  p <- ncol(Y)
  if (missing(w) || is.null(w)) w <- rep(1, nrow(Y))
  if (missing(tune)) tune <- qchisq(1 - P, df=p)
  if (missing(initialize)){
    fit.last <- lm.wfit(X, Y, w)
  }
  else{
    k <- ncol(X)
    n <- nrow(X)
    coef <- matrix(0, k, p)
    res <- matrix(0, n, p)
    for (j in 1:p){
      modj <- initialize(Y[, j] ~ X - 1, weights=w)
      coef[, j] <- coef(modj)
      res[, j] <- residuals(modj)
    }
    fit.last <- list(coefficients=coef, residuals=res)
  }
  B.last <- B.new <- fit.last$coefficients
  iter <- 0
  if (verbose){
    coefnames <- abbreviate(outer(rownames(B.new), colnames(B.new), function(x, y) paste(x, ":", y, sep="")), 10)
    b <- as.vector(B.new)
    names(b) <- coefnames
    cat("\n", iter, ":\n", sep="")
    print(b)
  }
  repeat {
    iter <- iter + 1
    if (iter > max.iter) break
    E <- fit.last$residuals
    S <- MASS::cov.trob(E, center=FALSE)$cov
    mahal <- mahalanobis(E, 0, S)
    wts <- psi(mahal, tune)
    fit.new <- lm.wfit(X, Y, w*wts)
    B.last <- B.new
    B.new <- fit.new$coefficients
    if (verbose){
      b <- as.vector(B.new)
      names(b) <- coefnames
      cat("\n", iter, ":\n", sep="")
      print(b)
    }
    if (max(abs((B.last - B.new)/(B.last + tol))) < tol) break
    fit.last <- fit.new
  }
  if (iter > max.iter) warning("maximum iterations exceeded")
  fit.new$iterations <- iter
  fit.new$weights <- wts
  fit.new$converged <- iter <= max.iter
  fit.new
}

#' @rdname robmlm
#' @exportS3Method robmlm formula
robmlm.formula <- function(formula, data, subset, weights, na.action, model = TRUE,
                         contrasts = NULL, ...) {
  # ... passed to robmlm.default
  call <- match.call()  
  call[[1]] <- as.name("robmlm")
  mf <- match.call(expand.dots = FALSE)  
  args <- match(c("formula", "data", "subset", "weights", "na.action"),
                names(mf), 0)  
  mf <- mf[c(1, args)]
  mf$drop.unused.levels <- TRUE
  mf[[1]] <- as.name("model.frame")
  mf <- eval.parent(mf)  
  terms <- attr(mf, "terms")  
  Y <- model.response(mf, type="numeric")  
  X <- model.matrix(terms, mf, contrasts) 
  w <- as.vector(model.weights(mf))
  mod <- robmlm.default(X, Y, w, ...)
  mod$na.action <- attr(mf, "na.action")
  mod$contrasts <- attr(X, "contrasts")
  mod$xlevels <- .getXlevels(terms, mf)
  mod$call <- call
  mod$terms <- terms
  if (model)  mod$model <- mf
  class(mod) <- c("robmlm", "mlm", "lm")
  mod
}

#' @rdname robmlm
#' @exportS3Method print robmlm
print.robmlm <- function(x, ...){
  if (!x$converged) warning("failed to converge")
  NextMethod()
  cat("iterations = ", x$iterations)
  invisible(x)
}

#' @rdname robmlm
#' @exportS3Method summary robmlm
summary.robmlm <- function(object, ...){
  res <- list()
  res[[1]] <- NextMethod()
  res$iterations <- object$iterations
  res$converged <- object$converged
  class(res) <- c("summary.robmlm", class(res[[1]]))
  res
}

#' @rdname robmlm
#' @exportS3Method print summary.robmlm
print.summary.robmlm <- function(x, ...){
  if (!x$converged) warning("failed to converge")
  print(x[[1]])
  cat("iterations = ", x$iterations)
  invisible(x)
}

#' @exportS3Method stats::vcov
#' @importFrom car wcrossprod
vcov.mlm <- function (object, ...) {
# override stats::vcov.mlm to allow weights
#   adapted from code provided by Michael Friendly
# For R 3.1.0, to avoid calling summary.mlm directly, change the object class
#   temporarily to c("mlm", "lm")
	SSD.mlm <- function (object, ...) {
		if (!is.null(object$weights)) { 
			SSD <- car::wcrossprod(residuals(object), w=object$weights)
			df <- sum(object$weights)
		}
		else {
			SSD <- crossprod(residuals(object))
			df <- object$df.residual
		}
		structure(list(SSD=SSD, call = object$call, 
						df = df), class = "SSD")
	}
	estVar.mlm <- function (object, ...) estVar(SSD(object))
	obj <- object
	class(obj) <- c("mlm", "lm")  # remove robmlm class temporarily
	so <- summary(obj)[[1L]]
	kronecker(estVar(object), so$cov.unscaled, make.dimnames = TRUE)
}
