\name{Parenting}
\alias{Parenting}
\docType{data}
\title{
Father Parenting Competence
}
\description{
The data, from an exercise given by Meyers et al. (2006)
relates to 60 fathers assessed on three subscales of a Perceived Parenting Competence Scale.
The fathers were selected from three groups:
(a) fathers of a child with no disabilities;
(b) fathers with a physically disabled child;
(c) fathers with a mentally disabled child. 
}
\usage{data("Parenting")}
\format{
  A data frame with 60 observations on the following 4 variables.
  \describe{
    \item{\code{group}}{a factor with levels \code{Normal} \code{Physical Disability} \code{Mental Disability}}
    \item{\code{caring}}{caretaking responsibilities, a numeric vector}
    \item{\code{emotion}}{emotional support provided to the child, a numeric vector}
    \item{\code{play}}{recreational time spent with the child, a numeric vector}
  }
}
\details{
The scores on the response variables are discrete.
}
\source{
Meyers, L. S., Gamst, G, & Guarino, A. J. (2006).
\emph{Applied Multivariate Research: Design and Interpretation},
Thousand Oaks, CA: Sage Publications,
\url{https://studysites.sagepub.com/amrStudy/}, Exercises 10B.
}
%\references{
%%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(Parenting)
require(car)

# fit the MLM
parenting.mod <- lm(cbind(caring, emotion, play) ~ group, data=Parenting)
Anova(parenting.mod)

# Box's M test
boxM(parenting.mod)
plot(boxM(parenting.mod))

parenting.mod <- lm(cbind(caring, emotion, play) ~ group, data=Parenting)
Anova(parenting.mod)
# test contrasts
print(linearHypothesis(parenting.mod, "group1"), SSP=FALSE)
print(linearHypothesis(parenting.mod, "group2"), SSP=FALSE)


heplot(parenting.mod)
# display tests of contrasts
hyp <- list("N:MP" = "group1", "M:P" = "group2")
heplot(parenting.mod, hypotheses=hyp)

# make a prettier plot
heplot(parenting.mod, hypotheses=hyp, asp=1,
       fill=TRUE, fill.alpha=c(0.3,0.1), 
       col=c("red", "blue"), 
       lty=c(0,0,1,1), label.pos=c(1,1,3,2),
       cex=1.4, cex.lab=1.4, lwd=3)

pairs(parenting.mod, fill=TRUE, fill.alpha=c(0.3, 0.1))

\dontrun{
heplot3d(parenting.mod, wire=FALSE)
}


}
\keyword{datasets}
\concept{MANOVA}
