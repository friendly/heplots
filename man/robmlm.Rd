\name{robmlm}
\alias{print.robmlm}
\alias{print.summary.robmlm}
\alias{robmlm}
\alias{robmlm.default}
\alias{robmlm.formula}
\alias{summary.robmlm}
\alias{vcov.mlm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Robust Fitting of Multivariate Linear Models
}
\description{
Fit a multivariate linear model by robust regression using a simple M estimator.

These S3 methods are designed to provide a specification of a class of
robust methods which extend \code{mlm}s, and are therefore compatible with
other  \code{mlm} extensions, including \code{\link[car]{Anova}} and
\code{\link{heplot}}.
}
\usage{

robmlm(X, ...)

\method{robmlm}{formula}(formula, data, subset, weights, na.action, 
	model = TRUE, contrasts = NULL, ...)

\method{robmlm}{default}(X, Y, w, 
	P = 2 * pnorm(4.685, lower.tail = FALSE), tune, max.iter = 100, 
	psi = psi.bisquare, tol = 1e-06, initialize, verbose = FALSE, ...)


\method{print}{robmlm}(x, ...)

\method{print}{summary.robmlm}(x, ...)

\method{summary}{robmlm}(object, ...)

\method{vcov}{mlm}(object, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{formula}{
a formula of the form \code{cbind(y1, y2, ...) ~ x1 + x2 + ...}.
}
  \item{data}{
a data frame from which variables specified in \code{formula} are preferentially to be taken.
}
  \item{subset}{
An index vector specifying the cases to be used in fitting. 
}
  \item{weights}{
a vector of prior weights for each case. }

  \item{na.action}{
A function to specify the action to be taken if \code{NA}s are found. 
The 'factory-fresh' default action in R is 
\code{\link[stats]{na.omit}}, and can be changed by \code{\link[base]{options}}\code{(na.action=)}. 
}
  \item{model}{
should the model frame be returned in the object?
}
  \item{contrasts}{
optional contrast specifications; see \code{\link[stats]{lm}} for details. 
}
  \item{\dots}{
other arguments, passed down. In particular relevant control arguments
can be passed to the to the \code{robmlm.default} method.
}

  \item{X}{
for the default method, a model matrix, including the constant (if present)
}
  \item{Y}{
for the default method, a response matrix
}

  \item{w}{
prior weights
}
  \item{P}{
two-tail probability, to find cutoff quantile for chisq (tuning constant);
default is set for bisquare weight function
}
  \item{tune}{
tuning constant (if given directly)
}
  \item{max.iter}{
maximum number of iterations
}
  \item{psi}{
robustness weight function; \code{\link[MASS]{psi.bisquare}} is the default
}
  \item{tol}{
convergence tolerance, maximum relative change in coefficients
}
  \item{initialize}{
modeling function to find start values for coefficients,
equation-by-equation; if absent WLS (\code{lm.wfit}) is used
}
  \item{verbose}{
show iteration history? (\code{TRUE} or \code{FALSE})
}
  \item{x}{
a \code{robmlm} object
}

  \item{object}{
a \code{robmlm} object
}

}
\details{
Fitting is done by iterated re-weighted least squares (IWLS),
using weights based on the Mahalanobis squared distances of the
current residuals from the origin, and a scaling (covariance) matrix
calculated by \code{\link[MASS]{cov.trob}}.
The design of these methods were loosely modeled on \code{\link[MASS]{rlm}}.

\code{vcov.mlm} is an extension of the standard \code{\link[stats]{vcov}} methods

}
\value{
An object of class \code{"robmlm"} inheriting from \code{c("mlm", "lm")}.

This means that the returned \code{"robmlm"} contains all the components
of \code{"mlm"} objects described for \code{\link[stats]{lm}},
plus the following:
%%  If it is a LIST, use
\item{weights }{final observation weights}
\item{iterations }{number of iterations}
\item{converged }{logical: did the IWLS process converge?}
%% ...

The generic accessor functions 
\code{\link[stats]{coefficients}}, 
\code{\link[stats]{effects}}, 
\code{\link[stats]{fitted.values}} and 
\code{\link[stats]{residuals}}
extract various useful features of the value returned by \code{robmlm}. 
}
\references{
A. Marazzi (1993) \emph{Algorithms, Routines and S Functions for Robust Statistics}. 
Wadsworth & Brooks/Cole.


}
\author{
John Fox; packaged by Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
	
\code{\link[MASS]{rlm}},
\code{\link[MASS]{cov.trob}}
}
\examples{
# Skulls data

# make shorter labels for epochs and nicer variable labels in heplots
Skulls$epoch <- factor(Skulls$epoch, labels=sub("c","",levels(Skulls$epoch)))
# variable labels
vlab <- c("maxBreadth", "basibHeight", "basialLength", "nasalHeight")

# fit manova model, classically and robustly
sk.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
sk.rmod <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)

# standard mlm methods apply here
coefficients(sk.rmod)

# index plot of weights
plot(sk.rmod$weights, type="h", xlab="Case Index", ylab="Robust mlm weight", col="gray")
points(sk.rmod$weights, pch=16, col=Skulls$epoch)
axis(side=1, at=15+seq(0,120,30), labels=levels(Skulls$epoch), tick=FALSE, cex.axis=1)

# heplots to see effect of robmlm vs. mlm
heplot(sk.mod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), xlab=vlab[1], ylab=vlab[2], cex=1.25, lty=1)
heplot(sk.rmod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), 
	add=TRUE, error.ellipse=TRUE, lwd=c(2,2), lty=c(2,2), term.labels=FALSE, hyp.labels=FALSE, err.label="")

##############
# Pottery data

pottery.mod <- lm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
pottery.rmod <- robmlm(cbind(Al,Fe,Mg,Ca,Na)~Site, data=Pottery)
Anova(pottery.mod)
Anova(pottery.rmod)

# index plot of weights
plot(pottery.rmod$weights, type="h")
points(pottery.rmod$weights, pch=16, col=Pottery$Site)

# heplots to see effect of robmlm vs. mlm
heplot(pottery.mod, cex=1.3, lty=1)
heplot(pottery.rmod, add=TRUE, error.ellipse=TRUE, lwd=c(2,2), lty=c(2,2), term.labels=FALSE, err.label="")


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{multivariate}
\keyword{robust}% __ONLY ONE__ keyword per line
