\name{NeuroCog}
\alias{NeuroCog}
\docType{data}
\title{
Neurocognitive Measures in Psychiatric Groups
}
\description{
The primary purpose of the study (Hartman, 2016, Heinrichs etal. (2015)) was to evaluate patterns and 
levels of
performance on neurocognitive measures among individuals with schizophrenia and schizoaffective disorder
using a well-validated, comprehensive neurocognitive battery specifically
designed for individuals with psychosis (Heinrichs etal. (2008))

The main interest was in determining how well these measures distinguished among all
groups and whether there were variables that distinguished between the 
schizophrenia and schizoafective groups.


}
\usage{data("NeuroCog")}
\format{
  A data frame with 242 observations on the following 10 variables.
  \describe{
    \item{\code{Dx}}{Diagnostic group, a factor with levels \code{Schizophrenia} \code{Schizoaffective} \code{Control}}
    \item{\code{Speed}}{Speed of processing domain T score, a numeric vector}
    \item{\code{Attention}}{Attention/Vigilance Domain T score, a numeric vector}
    \item{\code{Memory}}{Working memory a numeric vector}
    \item{\code{Verbal}}{Verbal Learning Domain T score, a numeric vector}
    \item{\code{Visual}}{Visual Learning Domain T score, a numeric vector}
    \item{\code{ProbSolv}}{Reasoning/Problem Solving Domain T score, a numeric vector}
    \item{\code{SocialCog}}{Social Cognition Domain T score, a numeric vector}
    \item{\code{Age}}{Subject age, a numeric vector}
    \item{\code{Sex}}{Subject gender, a factor with levels \code{Female} \code{Male}}
  }
}
\details{
Neurocognitive function was assessed using the MATRICS Consensus Cognitive
Battery (MCCB; Nuechterlein et al., 2008).
The MCCB consists of 10 individually administered tests that measure cognitive
performance in seven domains: speed of processing, attention/vigilance, working
memory, verbal learning, visual learning, reasoning and problem solving, and
social cognition.

The clinical sample comprised 116 male and female patients who met the following
criteria: 1) a diagnosis of schizophrenia (n = 70) or schizoaffective disorder
(n = 46) confirmed by the Structured Clinical Interview for DSM-IV-TR Axis I
Disorders; 2) outpatient status; 3) a history free of developmental or learning
disability; 4) age 18-65; 5) a history free of neurological or endocrine
disorder; and 6) no concurrent DSM-IV-TR diagnosis of substance use disorder.

Non-psychiatric control participants (N = 146) were screened for medical and
psychiatric illness and history of substance abuse. Patients were recruited from
three outpatient clinics in Hamilton, Ontario, Canada. Control participants were
recruited through local newspaper and online classified advertisements for paid
research participation.

}
\source{
Hartman, L. I. (2016). Schizophrenia and Schizoaffective Disorder: One Condition or Two?
Unpublished PhD dissertation, York University.

Heinrichs, R.W., Pinnock, F., Muharib, E., Hartman, L.I., Goldberg, J.O., & McDermid Vaz, S. (2015). 
Neurocognitive normality in schizophrenia revisited. 
\emph{Schizophrenia Research: Cognition},  \bold{2} (4), 227-232.  
\code{doi: 10.1016/j.scog.2015.09.001}

}
\references{
Heinrichs, R. W., Ammari, N., McDermid Vaz, S. & Miles, A. (2008). Are schizophrenia and schizoaffective disorder neuropsychologically distinguishable? 
\emph{Schizophrenia Research}, \bold{99}, 149-154.

Nuechterlein KH, Green MF, Kern RS, Baade LE, Barch D, Cohen J, Essock S, 
Fenton WS, Frese FJ, Gold JM, Goldberg T, Heaton R, Keefe RSE, Kraemer H, 
Mesholam-Gately R, Seidman LJ, Stover E, Weinberger DR, Young AS, Zalcman S, Marder SR. (2008) 
The MATRICS Consensus Cognitive Battery, Part 1: Test selection, reliability, and validity. 
\emph{American Journal of Psychiatry}, \bold{165} (2), 203-213.
\url{http://www.ncbi.nlm.nih.gov/pubmed/18172019}.

}
\examples{
data(NeuroCog)
## maybe str(NeuroCog) ; plot(NeuroCog) ...
}
\keyword{datasets}
