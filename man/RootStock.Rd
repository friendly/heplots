\name{RootStock}
\Rdversion{1.1}
\alias{RootStock}
\docType{data}
\title{
Growth of Apple Trees from Different Root Stocks
}
\description{
In a classic experiment carried out from 1918 to 1934, growth
of apple trees of six different rootstocks were compared on 
four measures of size.
}
\usage{data(RootStock)}
\format{
  A data frame with 48 observations on the following 5 variables.
  \describe{
    \item{\code{rootstock}}{a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5} \code{6}}
    \item{\code{girth4}}{a numeric vector: trunk girth at 4 years (mm x 100)}
    \item{\code{ext4}}{a numeric vector: extension growth at 4 years (m)}
    \item{\code{girth15}}{a numeric vector: trunk girth at 15 years (mm x 100)}
    \item{\code{weight15}}{a numeric vector: weight of tree above ground at 15 years (lb x 1000)}
  }
}
\details{
This is a balanced, one-way MANOVA design, with n=8 trees for each rootstock.
}
\source{
Andrews, D. and Herzberg, A. (1985). \emph{Data: A Collection of Problems from Many Fields for the Student and Research Worker}
Springer-Verlag,
pp. 357--360.
}
\references{
Rencher, A. C. (1995). \emph{Methods of Multivariate Analysis}.
New York: Wiley, Table 6.2
}
\examples{
data(RootStock)
## maybe str(RootStock) ; plot(RootStock) ...
root.mod <- lm(cbind(girth4, ext4, girth15, weight15) ~ rootstock, data=RootStock)
Anova(root.mod)

pairs(root.mod)

}
\keyword{datasets}
