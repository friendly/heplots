\name{boxM}
\alias{boxM}

\title{ Box's M-test }

\description{
It performs the Box's M-test for homogeneity of covariance matrices
obtained from multivariate normal data according to one classification
factor. The test is based on the chi-square approximation.
}

\usage{
boxM(data, grouping)
}

\arguments{
  \item{data}{ a numeric data.frame or matrix containing \emph{n} observations of \emph{p} variables;
	it is expected that \emph{n > p}. }
  \item{grouping}{ a vector of length \emph{n} containing the class of each observation;
	it is usualy a factor. }
}

\value{
A list with class \code{c("htest", "boxM")} containing the following components:
  \item{statistic }{an approximated value of the chi-square distribution.}
  \item{parameter }{the degrees of freedom related of the test statistic in this case that it follows a Chi-square distribution.}
  \item{p.value }{the p-value of the test.}
  \item{cov }{a list containing the within covariance matrix for each level of \code{grouping}.}
  \item{pooled }{the pooled covariance matrix.}
  \item{logDet }{a vector containing the natural logarithm of each matrix in \code{cov}.}
  \item{means}{a matrix of the means for all groups, followed by the grand means}
  \item{data.name }{a character string giving the names of the data.}
  \item{method }{the character string "Box's M-test for Homogeneity of Covariance Matrices".}
}

\references{
Morrison, D.F. (1976) \emph{Multivariate Statistical Methods}.
}

\author{
Taken from the \pkg{biotools} package, 
Anderson Rodrigo da Silva <anderson.agro@hotmail.com>
}

\examples{
data(iris)

res <- boxM(iris[, 1:4], iris[, "Species"])
res

# visualize
ng <- length(res$logDet)
dets <- c(res$logDet, pooled=log(det(res$pooled)))
dotchart(dets, xlab = "log determinant")
points(dets , 1:4,  
	cex=c(rep(1.5, ng), 2.5), pch=c(rep(16, ng), 15),
	col= c(rep("blue", ng), "red"))


}
