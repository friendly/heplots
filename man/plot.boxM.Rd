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
             gplabel = NULL,
             pch = c(16, 15), 
             cex = c(2, 2.5), 
             col = c("blue", "red"),  
             xlim,
             conf=0.95, method=2, bias.adj=TRUE, lwd=2,
             ...)
}

\arguments{
  \item{x}{A \code{"boxM"} object resulting from \code{\link{boxM}} }
  \item{gplabel}{character string used to label the group factor.}
  \item{pch}{a vector of two point symbols to use for the individual groups and the pooled data, respectively}
  \item{cex}{character size, a vector of length two for groups and pooled data }
  \item{col}{colors for point symbols, a vector of length two}
  \item{xlim}{x limits for the plot}
  \item{conf}{coverage for approximate confidence intervals, \code{0 <= conf < 1} ; use \code{conf=0} to suppress these }
  \item{method}{confidence interval method; see \code{\link{logdetCI}}}
  \item{bias.adj}{confidence interval bias adjustment; see \code{\link{logdetCI}}}
  \item{lwd}{line width for confidence interval}
  \item{...}{Arguments passed down to \code{\link[graphics]{dotchart}}.}
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

\author{Michael Friendly}

\seealso{
\code{\link{boxM}}, \code{\link{logdetCI}}

\code{\link[graphics]{dotchart}}
}
\examples{
# Iris data
res <- boxM(iris[, 1:4], iris[, "Species"])
plot(res, gplabel="Species")

# Skulls data
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
skulls.boxm <- boxM(skulls.mod)
plot(skulls.boxm, gplabel="Epoch")
plot(skulls.boxm, gplabel="Epoch", bias.adj=FALSE)


}
\keyword{hgraph}
