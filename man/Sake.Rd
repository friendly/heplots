\name{Sake}
\alias{Sake}
\docType{data}
\title{
Taste Ratings of Japanese Rice Wine (Sake)
}
\description{
Siotani et al. (1985) describe a study of Japanese rice wine (sake)
used to investigate the relationship between two subjective ratings
(\code{taste} and \code{smell}) and a number of physical measurements
on 30 brands of sake.

These data provide one example of a case where a multivariate regression
doesn't benefit from having multiple outcome measures, using the standard
tests.  Barrett (2003) uses this data to illustrate influence measures for
multivariate regression models.
}
\usage{data(Sake)}
\format{
  A data frame with 30 observations on the following 10 variables.
  \describe{
    \item{\code{taste}}{mean taste rating}
    \item{\code{smell}}{mean smell rating}
    \item{\code{pH}}{pH measurement}
    \item{\code{acidity1}}{one measure of acidity}
    \item{\code{acidity2}}{another measure of acidity}
    \item{\code{sake}}{Sake-meter score}
    \item{\code{rsugar}}{direct reducing sugar content}
    \item{\code{tsugar}}{total sugar content}
    \item{\code{alcohol}}{alcohol content}
    \item{\code{nitrogen}}{formol-nitrogen content}
  }
}
\details{
The \code{taste} and \code{smell} values are the mean ratings of 10 experts
on some unknown scale.
}
\source{
Siotani, M. Hayakawa, T. & Fujikoshi, Y. (1985).
\emph{Modern Multivariate Statistical Analysis: A Graduate Course and Handbook}.
American Sciences Press, p. 217.
}
\references{
Barrett, B. E. (2003). Understanding Influence in Multivariate Regression.
\emph{Communications in Statistics - Theory and Methods}
32 (3), 667-680.
}
\examples{
data(Sake)
# quick look at the data
boxplot(scale(Sake))

Sake.mod <- lm(cbind(taste,smell) ~ ., data=Sake)

library(car)
Anova(Sake.mod)

predictors <- colnames(Sake)[-(1:2)]                 
# overall multivariate regression test
linearHypothesis(Sake.mod, predictors)

heplot(Sake.mod, hypotheses=list("Regr" = predictors))
}
\keyword{datasets}
