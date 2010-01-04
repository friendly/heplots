\name{ReactTime}
\Rdversion{1.1}
\alias{ReactTime}
\docType{data}
\title{
Reaction Time Data 
}
\description{
	Data from Maxwell and Delaney (1990, p. 497) representing the reaction times of 10 subjects
	in some task where visual stimuli are tilted at 0, 4, and 8 degrees; with noise absent or present. 
	Each subject responded to 3 tilt x 2 noise = 6 conditions.  The data thus comprise a
	repeated measure design with two within-S factors.

}
\usage{data(ReactTime)}
\format{
  A data frame with 10 observations giving the reaction time for the 6 conditions.
  \describe{
    \item{\code{deg0NA}}{a numeric vector}
    \item{\code{deg4NA}}{a numeric vector}
    \item{\code{deg8NA}}{a numeric vector}
    \item{\code{deg0NP}}{a numeric vector}
    \item{\code{deg4NP}}{a numeric vector}
    \item{\code{deg8NP}}{a numeric vector}
  }
}
%\details{
%%  ~~ If necessary, more details than the __description__ above ~~
%}
\source{
Baron, J. and Li, Y. (2003).
 \emph{Notes on the use of R for psychology experiments and questionnaires},
 \url{http://cran.r-project.org/doc/contrib/Baron-rpsych.pdf}

}
\references{
Maxwell, S. E. & Delaney, H. D. (1990). 
\emph{Designing Experiments and Analyzing Data: A model comparison perspective}.
Pacific Grove, CA: Brooks/Cole.
}
\examples{
data(ReactTime)
(RT.mod <- lm(as.matrix(ReactTime)~1))

# within-S factors
within <- expand.grid(tilt=ordered(c(0,4,8)), noise=c("NA", "NP"))
Anova(RT.mod, idata=within, idesign=~tilt * noise)
}

\keyword{datasets}
