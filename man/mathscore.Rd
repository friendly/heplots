\name{mathscore}
\alias{mathscore}
\docType{data}
\title{
Math scores for basic math and word problems
}
\description{
Scores for two groups of school children taught by different math teachers and tested
for both basic math (BM) problems and solving word problems (WP).
}
\usage{data("mathscore")}
\format{
  A data frame with 12 observations on the following 3 variables.
  \describe{
    \item{\code{group}}{a factor with levels \code{1} \code{2}}
    \item{\code{BM}}{Basic Math score, a numeric vector}
    \item{\code{WP}}{Word Problems score, a numeric vector}
  }
}
%\details{
%%  ~~ If necessary, more details than the __description__ above ~~
%}
\source{
Fictitious data
}
\examples{
data(mathscore)
str(mathscore)

math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
car::Anova(math.mod)

# scatterplot with data ellipses
car::scatterplot(WP ~ BM | group, data=mathscore, 
	ellipse=list(levels=0.68), smooth=FALSE, pch=c(15,16), 
	legend=list(coords = "topright"))

# HE plot
heplot(math.mod, fill=TRUE, 
  cex=2, cex.lab=1.8,
	xlab="Basic math", ylab="Word problems")



}
\keyword{datasets}
