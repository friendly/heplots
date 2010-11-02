\name{RatWeight}
\Rdversion{1.1}
\alias{RatWeight}
\docType{data}
\title{
Weight Gain in Rats Exposed to Thiouracil and Thyroxin
}
\description{
The data are from a study of weight gain, where investigators randomly assigned
30 rats to three treatment groups: treatment 1 was a control (no additive); 
treatments 2 and 3 consisted of two different additives (thiouracil and thyroxin
respectively) to the rats drinking water. Weight was measured at
baseline (week 0) and at weeks 1, 2, 3, and 4.
Due to an accident at the beginning of the study, data on 3 rats from the
thyroxin group are unavailable.
}
\usage{data(RatWeight)}
\format{
  A data frame with 27 observations on the following 6 variables.
  \describe{
    \item{\code{trt}}{a factor with levels \code{Control} \code{Thiouracil} \code{Thyroxin}}
    \item{\code{wt0}}{Weight at Week 0 (baseline weight)}
    \item{\code{wt1}}{Weight at Week 1}
    \item{\code{wt2}}{Weight at Week 2}
    \item{\code{wt3}}{Weight at Week 3}
    \item{\code{wt4}}{Weight at Week 4}
  }
}
\details{
The \code{trt} factor comes supplied with contrasts comparing \code{Control} to each of 
\code{Thiouracil} and \code{Thyroxin}.
}
\source{
Originally from Box (1950), Table D (page 389), where the values for weeks 1-4
were recorded as the gain in weight for that week.

Fitzmaurice, G. M. and Laird, N. M. and Ware, J. H (2004).
\emph{Applied Longitudinal Analysis}, New York, NY: Wiley-Interscience.
\url{http://biosun1.harvard.edu/~fitzmaur/ala/rat.txt}.
}
\references{
Box, G.E.P. (1950). Problems in the analysis of 
growth and wear curves.  \emph{Biometrics}, 6, 362-389.

Friendly, Michael (2010). HE Plots for Repeated Measures Designs. \emph{Journal of Statistical Software},
  37(4), 1-40. URL \url{http://www.jstatsoft.org/v37/i04/}.

}
\examples{
data(RatWeight)
contrasts(RatWeight$trt)

rat.mod <- lm(cbind(wt0, wt1, wt2, wt3, wt4) ~ trt, data=RatWeight)
rat.mod

idata <- data.frame(week = ordered(0:4))
Anova(rat.mod, idata=idata, idesign=~week, test="Roy")

# quick look at between group effects
pairs(rat.mod)

# between-S, baseline & week 4
heplot(rat.mod, col=c("red", "blue", "green3", "green3"),
	variables=c(1,5),
	hypotheses=c("trt1", "trt2"),
	main="Rat weight data, Between-S effects") 

# within-S
heplot(rat.mod, idata=idata, idesign=~week, iterm="week",
	col=c("red", "blue", "green3"),
#	hypotheses=c("trt1", "trt2"),
	main="Rat weight data, Within-S effects")

}
\keyword{datasets}
