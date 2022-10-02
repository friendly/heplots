\name{FootHead}
%\Rdversion{1.1}
\alias{FootHead}
\docType{data}
\title{
Head measurements of football players
}
\description{
Data collected as part of a preliminary study examining the
relation between football helmet design and neck injuries.
There are 30 subjects in each of three groups:
High school football players, college players and non-football players.
}
\usage{data(FootHead)}
\format{
  A data frame with 90 observations on the following 7 variables.
  \describe{
    \item{\code{group}}{a factor with levels \code{High school} \code{College} \code{Non-football}}
    \item{\code{width}}{a numeric vector: head width at widest dimension}
    \item{\code{circum}}{a numeric vector: head circumference}
    \item{\code{front.back}}{a numeric vector: front to back distance at eye level}
    \item{\code{eye.top}}{a numeric vector: eye to top of head}
    \item{\code{ear.top}}{a numeric vector:ear to top of head}
    \item{\code{jaw}}{a numeric vector: jaw width}
  }
}
%\details{
%%  ~~ If necessary, more details than the __description__ above ~~
%}
\source{
Rencher, A. C. (1995), \emph{Methods of Multivariate Analysis},
New York: Wiley, Table 8.3.
}
%\references{
%%  ~~ possibly secondary sources and usages ~~
%}
\examples{
data(FootHead)
str(FootHead)
require(car)

# use Helmert contrasts for group
contrasts(FootHead$group) <- contr.helmert
contrasts(FootHead$group)

foot.mod <- lm(cbind(width, circum,front.back,eye.top,ear.top,jaw) ~ group, 
               data=FootHead)
Manova(foot.mod)

# show the HE plot for the first two variables
heplot(foot.mod, main="HE plot for width and circumference", fill=TRUE,
	col=c("red", "blue"))

# show it with tests of Helmert contrasts
heplot(foot.mod, hypotheses=list("group.1"="group1","group.2"="group2"),
	col=c("red", "blue", "green3", "green3" ),
	main="HE plot with orthogonal Helmert contrasts")

# show all pairwise HE plots
pairs(foot.mod)

# ... with tests of Helmert contrasts
pairs(foot.mod, hypotheses=list("group.1"="group1","group.2"="group2"),
	col=c("red", "blue", "green3", "green3"), hyp.labels=FALSE)

# see that the hypothesis for groups really is 2D
if(requireNamespace("rgl")){
heplot3d(foot.mod, variables=c(1,2,6),
	hypotheses=list("group.1"="group1","group.2"="group2"),
	col=c("red", "blue", "green3", "green3" ), wire=FALSE)
}
}
\keyword{datasets}
\concept{MMRA}
\concept{contrasts}

