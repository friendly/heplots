\name{AddHealth}
\alias{AddHealth}
\docType{data}
\title{
Adolescent Health Data
}
\description{
This data was taken from the National Longitudinal Study
of Adolescent Health.  It is a cross-sectional sample
of participants from grades 7--12,
described and analyzed by Warne (2014).
}
\usage{data("AddHealth")}
\format{
  A data frame with 4344 observations on the following 3 variables.
  \describe{
    \item{\code{grade}}{an ordered factor with levels \code{7} < \code{8} < \code{9} < \code{10} < \code{11} < \code{12}}
    \item{\code{depression}}{a numeric vector}
    \item{\code{anxiety}}{a numeric vector}
  }
}
\details{
\code{depression} is the response to the question
"In the last month, how often did you feel depressed or blue?"

\code{anxiety} is the response to the question
"In the last month, how often did you have trouble relaxing?"

The responses for \code{depression} and \code{anxiety} were recorded on a
5-point Likert scale, with
categories 
\code{0="Never", 1="Rarely", 2="Occasionally", 3="Often", 4="Every day"}
}
\source{
Warne, R. T. (2014). A primer on Multivariate Analysis of Variance (MANOVA)
for Behavioral Scientists.  \emph{Practical Assessment, Research & Evaluation},
19 (1).
\url{https://scholarworks.umass.edu/pare/vol19/iss1/17/}
}
%\references{
%%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(AddHealth)
# fit mlm
AH.mod <- lm(cbind(depression, anxiety) ~ grade, data=AddHealth)

Anova(AH.mod)
summary(Anova(AH.mod))

heplot(AH.mod, hypotheses="grade.L", fill=c(TRUE, FALSE))
}
\keyword{datasets}
