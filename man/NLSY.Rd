\name{NLSY}
\alias{NLSY}
\docType{data}
\title{
National Longitudinal Survey of Youth Data
}
\description{
The dataset come from a small random sample of 
the U.S. National Longitudinal Survey of Youth.
}
\usage{data(NLSY)}
\format{
  A data frame with 243 observations on the following 6 variables.
  \describe{
    \item{\code{math}}{Math achievement test score}
    \item{\code{read}}{Reading achievement test score}
    \item{\code{antisoc}}{score on a measure of child's antisocial behavior, \code{0:6}}
    \item{\code{hyperact}}{score on a measure of child's hyperactive behavior, \code{0:5}}
    \item{\code{income}}{yearly income of child's father}
    \item{\code{educ}}{years of education of child's father}
  }
}
\details{
In this dataset, \code{math} and \code{read} scores are taken at the outcome
variables.
Among the remaining predictors, \code{income} and \code{educ} might be
considered as background variables necessary to control for.
Interest might then be focused on whether 
the behavioural variables \code{antisoc} and \code{hyperact} contribute beyond that.
}
\source{
This dataset was derived from a larger one used by Patrick Curran
at the 1997 meeting of the Society for Research on Child Development (SRCD).
A description now only exists on the WayBack Machine,
\url{http://web.archive.org/web/20050404145001/http://www.unc.edu/~curran/example.html}.

More details are available at
\url{http://web.archive.org/web/20060830061414/http://www.unc.edu/~curran/srcd-docs/srcdmeth.pdf}.

}
%\references{
%%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(NLSY)

#examine the data
scatterplotMatrix(NLSY, smooth=FALSE)

# test control variables by themselves
# -------------------------------------
mod1 <- lm(cbind(read,math) ~ income+educ, data=NLSY)
Anova(mod1)
heplot(mod1, fill=TRUE)

# test of overall regression
coefs <- rownames(coef(mod1))[-1]
linearHypothesis(mod1, coefs)
heplot(mod1, fill=TRUE, hypotheses=list("Overall"=coefs))

 
# additional contribution of antisoc + hyperact over income + educ
# ----------------------------------------------------------------
mod2 <- lm(cbind(read,math) ~ antisoc + hyperact + income + educ, data=NLSY)
Anova(mod2)

coefs <- rownames(coef(mod2))[-1]
heplot(mod2, fill=TRUE, hypotheses=list("Overall"=coefs, "mod2|mod1"=coefs[1:2]))
linearHypothesis(mod2, coefs[1:2])

heplot(mod2, fill=TRUE, hypotheses=list("mod2|mod1"=coefs[1:2]))

}
\keyword{datasets}
\concept{MMRA}
