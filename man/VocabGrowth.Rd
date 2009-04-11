\name{VocabGrowth}
\alias{VocabGrowth}
\docType{data}
\title{Vocabulary growth data}
\description{
Data from the Laboratory School of the University  of Chicago.  
They consist of scores from a cohort of pupils in grades 8-11 on
the vocabulary section of the Cooperative Reading Test.  The
scores are scaled to a common, but arbitrary origin and unit
of measurement, so as to be comparable over the four grades.

}
\usage{data(VocabGrowth)}
\format{
  A data frame with 64 observations on the following 4 variables.
  \describe{
    \item{\code{grade8}}{Grade 8 vocabulary score}
    \item{\code{grade9}}{Grade 9 vocabulary score}
    \item{\code{grade10}}{Grade 10 vocabulary score}
    \item{\code{grade11}}{Grade 11 vocabulary score}
  }
}
\details{
Since these data cover an age range in which physical growth
is beginning to decelerate, it is of interest whether a
similar effect occurs in the acquisition of new vocabulary.
}
\source{
  R.D.  Bock,
  \emph{Multivariate statistical methods in behavioral research}, McGraw-Hill, New York,
1975, pp453.  
}
\references{
  Keesling, J.W., Bock, R.D. et al, "The Laboratory School study of vocabulary growth",
  University of Chicago, 1975.
}
\examples{
data(VocabGrowth)

# Standard Multivariate & Univariate repeated measures analysis
Vocab.mod <- lm(cbind(grade8,grade9,grade10,grade11) ~ 1, data=VocabGrowth)
idata <-data.frame(grade=ordered(8:11))
Anova(Vocab.mod, idata=idata, idesign=~grade)

# calculate Y M, using polynomial contrasts
trends <- as.matrix(VocabGrowth) \%*\% poly(8:11, degree=3)
colnames(trends)<- c("Linear", "Quad", "Cubic")

within.mod <- lm(trends ~ 1)

Manova(within.mod)
heplot(within.mod, terms="(Intercept)", col=c("red", "blue"), type="3",
	main="HE plot for Grade effect")
points(0,0, cex=2.5, col="green", pch=19)
text(0,0, col="green", pos=2, labels="H0")

}
\keyword{datasets}
