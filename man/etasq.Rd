\name{etasq}
\Rdversion{1.1}
\alias{etasq}
\alias{etasq.mlm}
\alias{etasq.Anova.mlm}
\title{
Multivariate Measures of Partial Association (Eta-squared)
}
\description{
Calculates multivariate analogs of eta-squared (or R^2), indicating
the partial association for each term in a multivariate linear model.
There is a different analog for each of the four standard multivariate
test statistics: Pillai's trace, Hotelling-Lawley trace, Wilks' Lambda
and Roy's maximum root test.
}
\usage{

etasq(x, ...)

\method{etasq}{mlm}(x, ...)

\method{etasq}{Anova.mlm}(x, anova = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{x}{
A \code{mlm} or \code{Anova.mlm} object
}
  \item{anova}{
A logical, indicating whether the result should also contain the
test statistics produced by \code{print.Anova.mlm()}.
}
  \item{\dots}{
Other arguments passed down 
}

}
\details{
All multivariate tests are based on the \eqn{s=min(p, df_h)}
latent roots of \eqn{H E^{-1}}. The \eqn{\eta^2} measures are
calculated as:

\describe{
	\item{Pillai's trace (V)}{\eqn{\eta^2 = V/s}}
	\item{Hotelling-Lawley trace (T)}{\eqn{\eta^2 = T/(T+s)}}
	\item{Wilks' Lambda (L)}{\eqn{\eta^2 = L^{1/s}}}
	\item{Roy's maximum root (R)}{\eqn{\eta^2 = R/(R+1)}}

}

}
\value{
When \code{anova=FALSE}, a one-column data frame containing the
eta-squared values for each term in the model.

When \code{anova=TRUE}, a 7-column data frame containing the
eta-squared values and the test statistics produced by \code{print.Anova.mlm()}
for each term in the model.

}
\references{
Muller, K. E. and Peterson, B. L. (1984).
Practical methods for computing power in testing the Multivariate General Linear Hypothesis 
\emph{Computational Statistics and Data Analysis}, 2, 143-158.

Muller, K. E. and LaVange, L. M. and Ramey, S. L. and Ramey, C. T. (1992).
Power Claculations for General Linear Multivariate Models Including Repeated Measures Applications.
\emph{Journal of the American Statistical Association}, 87, 1209-1226.

}
\author{
Michael Friendly
}
%\note{
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[car]{Anova}}
}
\examples{
data(Soils)  # from car package
soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth, data=Soils)
#Anova(soils.mod)
etasq(Anova(soils.mod))
etasq(soils.mod) # same
etasq(Anova(soils.mod), anova=TRUE)

etasq(soils.mod, test="Wilks")
etasq(soils.mod, test="Hotelling")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{multivariate }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
