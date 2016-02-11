\name{plot.boxM}
\alias{plot.boxM}
\docType{data}
\title{
Plot Box's M test
}
\description{
This function creates a simple dot chart showing the contributions
(log determinants)
of the various groups to Box's M test for equality of covariance matrices.
}
\usage{
\method{plot}{boxM}(x,
             pch=c(16, 15), 
             cex=c(2, 2.5), 
             col=c("blue", "red"), ...) 
}

\arguments{
  \item{x}{A \code{"boxM"} object resulting from \code{\link{boxM}} }
  \item{pch}{a vector of two point symbols to use for the individual groups and the pooled data}
  \item{cex}{character size, a vector of length two }
  \item{col}{colors for point symbols, a vector of length two}
  \item{...}{Arguments passed down, currently unused.}
}

%\details{
%%%  ~~ If necessary, more details than the __description__ above ~~
%}
%\source{
%%%  ~~ reference to a publication or URL from which the data were obtained ~~
%}
%\references{
%%%  ~~ possibly secondary sources and usages ~~
%}
\seealso{
\code{\link{boxM}}
}
\examples{
res <- boxM(iris[, 1:4], iris[, "Species"])
plot(res)

}
\keyword{hgraph}
