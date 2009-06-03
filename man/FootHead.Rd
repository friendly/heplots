\name{FootHead}
\Rdversion{1.1}
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
\references{
%%  ~~ possibly secondary sources and usages ~~
}
\examples{
data(FootHead)
str(FootHead) ; plot(FootHead)
}
\keyword{datasets}
