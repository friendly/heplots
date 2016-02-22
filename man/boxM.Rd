\name{boxM}
\alias{boxM}
\alias{boxM.formula}
\alias{boxM.lm}
\alias{boxM.default}

\title{ Box's M-test }

\description{
\code{boxM} performs the Box's (1949) M-test for homogeneity of covariance matrices
obtained from multivariate normal data according to one or more classification
factors. The test compares the product of the log determinants of the
separate covariance matrices to the log determinant of the pooled
covariance matrix, analogous to a likelihood ratio test.
The test statistic uses a chi-square approximation.
}

\usage{
boxM(Y, ...)

\method{boxM}{formula}(Y, data, ...)

\method{boxM}{lm}(Y, ...)

\method{boxM}{default}(Y, group, ...)


}

\arguments{
  \item{Y}{The response variable matrix for the default method, or a \code{"mlm"} or \code{"formula"} object
  for a multivariate linear model.
  If \code{Y} is a linear-model object or a formula, the variables on the right-hand-side of the model must all be factors 
  and must be completely crossed, e.g., \code{A:B}}
  \item{data}{ a numeric data.frame or matrix containing \emph{n} observations of \emph{p} variables;
	it is expected that \emph{n > p}. }
  \item{group}{ a factor defining groups, or a vector of length \emph{n} doing the same.}
  \item{...}{Arguments passed down, currently unused.}
}

\value{
A list with class \code{c("htest", "boxM")} containing the following components:
  \item{statistic }{an approximated value of the chi-square distribution.}
  \item{parameter }{the degrees of freedom related of the test statistic in this case that it follows a Chi-square distribution.}
  \item{p.value }{the p-value of the test.}
  \item{cov }{a list containing the within covariance matrix for each level of \code{grouping}.}
  \item{pooled }{the pooled covariance matrix.}
  \item{logDet }{a vector containing the natural logarithm of each matrix in \code{cov}, followed by the value for the pooled 
  covariance matrix}
  \item{means}{a matrix of the means for all groups, followed by the grand means}
  \item{df}{a vector of the degrees of freedom for all groups, followed by that for the pooled covariance matrix}
  \item{data.name }{a character string giving the names of the data.}
  \item{method }{the character string "Box's M-test for Homogeneity of Covariance Matrices".}
}

\details{
As an object of class \code{"htest"}, the statistical test is printed normally by default.

There is no general provision as yet for handling missing data.  Missing data are simply
removed, with a warning.

As well, the computation assumes that the covariance matrix for each group is non-singular,
so that \eqn{log det(S_i)} can be calculated for each group.

Box's M test for a multivariate linear model highly sensitive to departures from multivariate normality,
just as the analogous univariate test.  It is also affected adversely by 
unbalanced designs.  Some people reccommend to ignore the result unless it is very highly significant,
e.g., p < .0001 or worse.

}


\references{
Box, G. E. P. (1949). A general distribution theory for a class of likelihood criteria. \emph{Biometrika}, 36, 317-346.

Morrison, D.F. (1976) \emph{Multivariate Statistical Methods}.

}

\author{
The default method was taken from the \pkg{biotools} package, 
Anderson Rodrigo da Silva <anderson.agro@hotmail.com>

Generalized by Michael Friendly and John Fox
}

\seealso{
\code{\link[car]{leveneTest}} carries out homogeneity of variance tests for
univariate models with better statistical properties.

\code{\link{plot.boxM}}, a simple plot of the log determinants

}

\examples{
data(iris)

# default method
res <- boxM(iris[, 1:4], iris[, "Species"])
res

# visualize (what is done in the plot method) 
dets <- res$logDet
ng <- length(res$logDet)-1
dotchart(dets, xlab = "log determinant")
points(dets , 1:4,  
	cex=c(rep(1.5, ng), 2.5), 
	pch=c(rep(16, ng), 15),
	col= c(rep("blue", ng), "red"))

# formula method
boxM( cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)

# lm method
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
boxM(skulls.mod)



}
