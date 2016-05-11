\name{SocialCog}
\alias{SocialCog}
\docType{data}
\title{
Social Cognitive Measures in Psychiatric Groups
}
\description{
The general purpose of the study (Hartman, 2016, Heinrichs etal. (2015)) was to evaluate patterns and levels 
of performance on neurocognitive measures among individuals with schizophrenia and schizoaffective disorder 
using a well-validated, comprehensive neurocognitive battery specifically designed for individuals with psychosis 
(Heinrichs etal. (2008)) 

The data here are for a subset of the observations in \code{\link{NeuroCog}} for which
measures on various scales of social cognition were also available.
Interest here is on whether the schizophrenia group can be distinguished from the
schizoaffective group on these measures.
}

\usage{data("SocialCog")}
\format{
  A data frame with 139 observations on the following 5 variables.
  \describe{
    \item{\code{Dx}}{Diagnostic group, a factor with levels \code{Schizophrenia}, \code{Schizoaffective}, \code{Control}}
    \item{\code{MgeEmotions}}{Score on the Managing emotions test, a numeric vector}
    \item{\code{ToM}}{Score on the The Reading the Mind in the Eyes test (theory of mind), a numeric vector}
    \item{\code{ExtBias}}{Externalizing Bias score, a numeric vector}
    \item{\code{PersBias}}{Personal Bias score, a numeric vector}
  }
}
\details{
See \code{\link{NeuroCog}} for a description of the sample.
Only those with complete data on all the social cognitive measures are included in this data set.

There is one extreme outier in the schizophrenia group and other possible
outliers in the control group, left in here for tutorial purposes.
}
\source{
Hartman, L. I. (2016). Schizophrenia and Schizoaffective Disorder: One Condition or Two? Unpublished PhD dissertation, York University.

Heinrichs, R.W., Pinnock, F., Muharib, E., Hartman, L.I., Goldberg, J.O., & McDermid Vaz, S. (2015). 
Neurocognitive normality in schizophrenia revisited. 
\emph{Schizophrenia Research: Cognition}, \bold{2} (4), 227-232. doi: 10.1016/j.scog.2015.09.001 }

%\references{
%%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(SocialCog)
SC.mod <- lm(cbind(MgeEmotions, ToM, ExtBias, PersBias) ~ Dx, data=SocialCog)
SC.mod
Anova(SC.mod)

# test hypotheses of interest in terms of contrasts
print(linearHypothesis(SC.mod, "Dx1"), SSP=FALSE)
print(linearHypothesis(SC.mod, "Dx2"), SSP=FALSE)

#' ## HE plots

heplot(SC.mod, hypotheses=list("Dx1"="Dx1", "Dx2"="Dx2"),
	fill=TRUE, fill.alpha=.1)
	
pairs(SC.mod, fill=c(TRUE,FALSE), fill.alpha=.1) 

}
\keyword{datasets}
