\name{glance.mlm}
%\alias{glance}
\alias{glance.mlm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Glance at an mlm object
}
\description{
This function takes an "mlm" object, fit by \code{\link[stats]{lm}} with a multivariate response.
The goal is to return something analogous to \code{\link[broom]{glance.lm}} for a univariate response linear model.

In the multivariate case, it returns a \code{\link[tibble]{tibble}} with one row for each
response variable, containing goodness of fit measures, F-tests and p-values.

}
\usage{
% glance(x, ...)

\method{glance}{mlm}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{An \code{mlm} object created by \code{\link[stats]{lm}}, i.e., with a multivariate response.}
  \item{\dots}{Additional arguments. Not used.}
}

%\details{}

\value{
A \code{\link[tibble]{tibble}} with one row for each response variable and the columns:
\describe{
  \item{\code{r.squared}}{R squared statistic, or the percent of variation explained by the model.}
  \item{\code{adj.r.squared}}{Adjusted R squared statistic, which is like the R squared statistic except taking degrees of freedom into account.}
  \item{\code{sigma}}{Estimated standard error of the residuals}
  \item{\code{fstatitic}}{Overall F statistic for the model}
  \item{\code{numdf}}{Numerator degrees of freedom for the overall test}
  \item{\code{dendf}}{Denominator degrees of freedom for the overall test}
  \item{\code{p.value}}{P-value corresponding to the F statistic}
  \item{\code{nobs}}{Number of observations used}
}
}
%\references{
%% ~put references to the literature/web site here ~
%}
\author{
Michael Friendly
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[broom]{glance}}, \code{\link[broom]{glance.lm}}
}
\examples{
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
glance(iris.mod)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{multivariate}
\keyword{models}
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
