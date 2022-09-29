\name{schooldata}
\alias{schooldata}
\docType{data}
\title{ School Data}
\description{
 School Data, from Charnes et al. (1981). The aim is to explain scores on 3 
different tests, \code{reading}, \code{mathematics} and \code{selfesteem}
from 70 school sites by means of 5 explanatory variables.

}
\usage{data(schooldata)}
\format{
  A data frame with 70 observations on the following 8 variables.

\describe{
\item{\code{education}}{ education level of mother as measured in terms of percentage of high school 
graduates among female parents}
\item{\code{occupation}}{ highest occupation of a family member according to a pre-arranged rating scale}
\item{\code{visit}}{ parental visits index representing the number of visits to the school site}
\item{\code{counseling}}{ parent counseling index calculated from data on time spent with child on 
school-related topics such as reading together, etc.}
\item{\code{teacher}}{ number of teachers at a given site}
\item{\code{reading}}{ total reading score as measured by the Metropolitan Achievement Test}
\item{\code{mathematics}}{ total mathematics score as measured by the Metropolitan Achievement Test}
\item{\code{selfesteem}}{ Coopersmith Self-Esteem Inventory, intended as a measure of self-esteem}
} 
}
\details{
This dataset was shamelessly borrowed from the \code{FRB} package.

The relationships among these variables are unusual, a fact only revealed by plotting.
}
\source{
 A. Charnes, W.W. Cooper and E. Rhodes (1981). Evaluating Program and Managerial Efficiency: An Application of Data
Envelopment Analysis to Program Follow Through. \emph{Management Science}, \bold{27}, 668-697.
}

\examples{
data(schooldata)
# initial screening
plot(schooldata)

# better plot
library(corrgram)
corrgram(schooldata, lower.panel=panel.ellipse, upper.panel=panel.pts)

#fit the MMreg model
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ 
		education + occupation + visit + counseling + teacher, data=schooldata)
# shorthand
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
Anova(school.mod)

heplot(school.mod)
heplot3d(school.mod)

# robust model, using robmlm()
school.rmod <- robmlm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
# note that counseling is now significant
Anova(school.rmod)

# Index plot of the weights
wts <- school.rmod$weights
notable <- which(wts < 0.8)
plot(wts, type = "h", col="gray", ylab = "Observation weight")
points(1:length(wts), wts, 
       pch=16,
       col = ifelse(wts < 0.8, "red", "black"))

text(notable, wts[notable],
     labels = notable,
     pos = 3,
     col = "red")


# compare classical HE plot with that based on the robust model
heplot(school.mod, cex=1.4, lty=1, fill=TRUE, fill.alpha=0.1)
heplot(school.rmod, 
       add=TRUE, 
       error.ellipse=TRUE, 
       lwd=c(2,2), lty=c(2,2), 
	     term.labels=FALSE, err.label="", 
	     fill=TRUE)

}
\keyword{datasets}
