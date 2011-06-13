\name{SocGrades}
\alias{SocGrades}
\docType{data}
\title{
Grades in a Sociology Course
}
\description{
The data set \code{SocGrades} contains four outcome measures on student performance
in an introductory sociology course together with six potential predictors.
These data were used by Marascuilo and Levin (1983) for an example of
canonical correlation analysis, but are also suitable as examples of
multivariate multiple regression, MANOVA, MANCOVA and step-down analysis
in multivariate linear models.
}
\usage{data(SocGrades)}
\format{
  A data frame with 40 observations on the following 10 variables.
  \describe{
    \item{\code{class}}{Social class, an ordered factor with levels \code{1} > \code{2} > \code{3}}
    \item{\code{sex}}{sex, a factor with levels \code{F} \code{M}}
    \item{\code{gpa}}{grade point average}
    \item{\code{boards}}{College Board test scores}
    \item{\code{hssoc}}{previous high school unit in sociology, a factor with 2  \code{no}, \code{yes}}
    \item{\code{pretest}}{score on course pretest}
    \item{\code{midterm1}}{score on first midterm exam}
    \item{\code{midterm2}}{score on second midterm exam}
    \item{\code{final}}{score on final exam}
    \item{\code{eval}}{course evaluation}
  }
}
\details{
The factors \code{class}, \code{sex}, and \code{hssoc} can be used with
\code{as.numeric} in correlational analyses.
}
\source{
Marascuilo, L. A. and Levin, J. R. (1983).
\emph{Multivariate Statistics in the Social Sciences}
Monterey, CA: Brooks/Cole, Table 5-1, p. 192.
}
%\references{
%%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(SocGrades)
# basic MLM
grades.mod <- lm(cbind(midterm1, midterm2, final, eval) ~ 
	class + sex + gpa + boards + hssoc + pretest, data=SocGrades)
	
Anova(grades.mod, test="Roy")

clr <- c("red", "blue", "darkgreen", "magenta", "brown", "black", "darkgray")
heplot(grades.mod, col=clr)
pairs(grades.mod, col=clr)

heplot3d(grades.mod, col=clr, wire=FALSE)
}
\keyword{datasets}
