\name{gsorth}
\Rdversion{1.1}
\alias{gsorth}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Orthogonalize successive columns of a data frame or matrix
}
\description{
\code{gsorth} uses sequential, orthogonal projections, as
in the Gram-Schmidt method, to transform a matrix or numeric
columns of a data frame into an uncorrelated set, possibly
retaining the same column means and standard deviations as the original.
}
\usage{
gsorth(y, order, recenter = TRUE, rescale = TRUE, adjnames = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{
A numeric data frame or matrix
}
  \item{order}{
An integer vector specifying the order of and/or a subset of
the columns of \code{y} to be orthogonalized.
If missing, \code{order=1:p} where \code{p=ncol(y)}.
}
  \item{recenter}{
If \code{TRUE}, the result has same column means as original;
else means = 0 for cols \code{2:p}.
}
  \item{rescale}{
If \code{TRUE}, the result has same column standard deviations as original;
else sd = residual variance for cols \code{2:p}
}
  \item{adjnames}{
If \code{TRUE}, the column names of the result  are adjusted to the form
Y1, Y2.1, Y3.12, by adding the suffixes '.1', '.12', etc. to the
original column names.
}
}
\details{
The method is equivalent to setting each of columns \code{2:p} to
the residuals from a linear regression of that column on all prior
columns, i.e.,

\code{z[,j] <- resid( lm( z[,j] ~ as.matrix(z[,1:(j-1)]), data=z) )}

However, for accuracy and speed the transformation is carried out using the QR decomposition.
}
\value{
Returns a matrix or data frame with uncorrelated columns.  Row and column names are
copied to the result.
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
%\references{
%%% ~put references to the literature/web site here ~
%}
\author{
Michael Friendly
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[base]{qr}}, 
}
\examples{
GSiris <- gsorth(iris[,1:4])
GSiris <- gsorth(iris, order=1:4)   # same, using order
str(GSiris)
zapsmall(cor(GSiris))
colMeans(GSiris)
# sd(GSiris) -- sd(<matrix>) now deprecated
apply(GSiris, 2, sd)

# orthogonalize Y side
GSiris <- data.frame(gsorth(iris[,1:4]), Species=iris$Species)
iris.mod1 <- lm(as.matrix(GSiris[,1:4]) ~ Species, data=GSiris)
Anova(iris.mod1)

# orthogonalize X side
rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer)
Anova(rohwer.mod)

# type I tests for Rohwer data
Rohwer.orth <- cbind(Rohwer[,1:5], gsorth(Rohwer[, c("n", "s", "ns", "na", "ss")], adjnames=FALSE))

rohwer.mod1 <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer.orth)
Anova(rohwer.mod1)
# compare with anova()
anova(rohwer.mod1)


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
