\name{statList}
\Rdversion{1.1}
\alias{statList}
\alias{covList}
\alias{colMeansList}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate statistics for levels of factors
}
\description{
\code{statList} provides a general method for calculating univariate or
multivariate statistics for a matrix or data.frame stratified by one
or more factors.
}
\usage{
statList(X, factors, FUN, drop = FALSE, ...)

colMeansList(X, factors, drop = FALSE, ...)

covList(X, factors, drop = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{
A matrix or data frame containing the variables to be summarized
}
  \item{factors}{
A vector, matrix or data frame containing the factors for which
\code{X} is to be summarized. 
If \code{factors} is not specified, the result is calculated for
all of the data in \code{X}.
}
  \item{FUN}{
A function to be applied to the pieces of \code{X},
as split by \code{factors}.
}
  \item{drop}{
Logical, indicating whether empty levels of \code{factors}
are to be dropped from the result.
}
  \item{\dots}{
Other arguments, passed to \code{FUN}.
}
}
\details{
\code{statList} is the general function.
\code{X} is first \code{split} by \code{factors}, and \code{FUN}
is applied to the result.

\code{colMeansList} and \code{covList} are just calls to
\code{statList} with the appropriate \code{FUN}.
}
\value{
Returns a list of items corresponding to the unique elements in
\code{factors}, or the interaction of \code{factors}.
Each item is the result of applying \code{FUN} to that
collection of rows of \code{X}.
The items are named according to the levels in \code{factors}.
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
\code{\link[base]{colMeans}}, \code{\link{termMeans}}
}
\examples{
# grand means
statList(iris[,1:4], FUN=colMeans)
# species means
statList(iris[,1:4], iris$Species, FUN=colMeans)
# same
colMeansList(iris[,1:4], iris$Species)

# var-cov matrices, by species
covList(iris[,1:4], iris$Species)

# multiple factors
iris$Dummy <- sample(c("Hi","Lo"),150, replace=TRUE)
colMeansList(iris[,1:4], iris[,5:6])


}
\keyword{utilities}
\keyword{multivariate}% __ONLY ONE__ keyword per line
