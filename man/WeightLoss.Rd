\name{WeightLoss}
\Rdversion{1.1}
\alias{WeightLoss}
\docType{data}
\title{
Weight Loss Data
}
\description{
Fictitious data on weight loss and self esteem over three months,
for three groups of individuals: Control, Diet and Diet + Exercise.
The data constitute a double-multivariate design.
}
\usage{data(WeightLoss)}
\format{
  A data frame with 34 observations on the following 7 variables.
  \describe{
    \item{\code{group}}{a factor with levels \code{Control} \code{Diet} \code{Diet+Ex}}
    \item{\code{wl1}}{Weight loss at 1 month}
    \item{\code{wl2}}{Weight loss at 2 months}
    \item{\code{wl3}}{Weight loss at 3 months}
    \item{\code{se1}}{Self esteem at 1 month}
    \item{\code{se2}}{Self esteem at 2 months}
    \item{\code{se3}}{Self esteem at 3 months}
  }
}
%\details{
%%  ~~ If necessary, more details than the __description__ above ~~
%}
\source{
\url{http://www.csun.edu/~ata20315/psy524/main.htm}
}
%\references{
%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(WeightLoss)
str(WeightLoss)
table(WeightLoss$group)

contrasts(WeightLoss$group) <- matrix(c(-2,1,1, 0, -1, 1),ncol=2)
(wl.mod<-lm(cbind(wl1,wl2,wl3,se1,se2,se3)~group, data=WeightLoss))

heplot(wl.mod, hypotheses=c("group1", "group2"))
pairs(wl.mod, variables=1:3)
pairs(wl.mod, variables=4:6)

}
\keyword{datasets}
