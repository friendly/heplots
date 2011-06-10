\name{Hernior}
\alias{Hernior}
\docType{data}
\title{
Recovery from Elective Herniorrhaphy
}
\description{
A data set on measures of post-operative recovery of 32 patients undergoing an
elective herniorrhaphy operation,  in relation to pre-operative measures.
}
\usage{data(Hernior)}
\format{
  A data frame with 32 observations on the following 9 variables.
  \describe{
    \item{\code{age}}{patient age}
    \item{\code{sex}}{patient sex, a factor with levels \code{f} \code{m}}
    \item{\code{pstat}}{physical status (ignoring that associated with the operation). A 1-5
    	scale, with 1=perfect health, 5=very poor health.}
    \item{\code{build}}{body build, a 1-5 scale, with 1=emaciated, 2=thin, 3=average, 4=fat, 5=obsese.}
    \item{\code{cardiac, resp}}{preoperative complications with heart and respiration, 1-4 scales,
    	with 1=none, 2=mild, 3=moderate, 4=severe.}
    \item{\code{leave}}{condition upon leaving the recovery room, a 1-4 scale, with 
    	1=routine recovery, 2=intensive care for observation overnight,
    	3=intensive care, with moderate care required,
    	4=intensive care, with moderate care required.
    	}
    \item{\code{los}}{length of stay in hospital after operation (days)}
    \item{\code{nurse}}{level of nursing required one week after operation, a 1-5 scale, with
    	1=intense, 2=heavy, 3=moderate, 4=light, 5=none (?); see Details}
  }
}
\details{
\code{leave}, \code{nurse} and \code{los} are outcome measures;
the remaining variables are potential predictors of recovery status.

The variable \code{nurse} is recorded as 1-4, with remaining (20) entries entered as
"-" in both sources.  It is not clear whether this means "none" or NA.  
The former interpretation was used in constructing the R data frame,
so \code{nurse==5} for these observations. Using
\code{Hernior$nurse[Hernior$nurse==5] <- NA} would change to the other
interpretation, but render \code{nurse} useless in a multivariate analysis.

The ordinal predictors could instead be treated as factors, and there are also
potential interactions to be explored.
}
\source{
Mosteller, F. and Tukey, J. W. (1977), \emph{Data analysis and regression},
Reading, MA: Addison-Wesley. Exhibit 8, 567-568.
Their source: A study by B. McPeek and J. P. Gilbert of the Harvard
Anesthesia Center.
}
\references{
Hand, D. J., Daly, F., Lunn, A. D., McConway, K. J. and Ostrowski, E. (1994),
\emph{A Handbook of Small Data Sets}, Number 484, 390-391.
}
\examples{
str(Hernior)
mod <- lm(cbind(leave, nurse, los) ~ age + sex +  pstat +  build + cardiac, data=Hernior)
Anova(mod, test="Roy") # actually, all tests are identical

clr <- c("red", "darkgray", "blue", "darkgreen", "magenta", "brown", "black")
heplot(mod, col=clr)
pairs(mod, col=clr)

# Add ellipse to test all 5 regressors simultaneously
hyp <- list("Regr" = c("age", "sexm", "pstat", "build", "cardiac"))
pairs(mod, hypotheses=hyp, col=clr)

}
\keyword{datasets}
