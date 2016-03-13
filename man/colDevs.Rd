\name{colDevs}
\alias{colDevs}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate column deviations from central values
}
\description{
\code{colDevs} calculates the column deviations of data values from
a central value (mean, median, etc.), possibly stratified by a grouping variable.

Conceptually, the function is similar to a column-wise \code{\link[base]{sweep}},
by group, allowing an arbitrary \code{center} function.

}
\usage{
colDevs(x, group, center = mean, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
A numeric data frame or matrix. 
}
  \item{group}{
A factor (or variable that can be coerced to a factor) indicating
the membership of each observation in \code{x} in one or more groups.
If missing, all the data is treated as a single group.
}
  \item{center}{
A function used to center the values (for each group if \code{group} is specified.
The function must take a vector argument and return a scalar result.
}
  \item{\dots}{
Arguments passed down
}
}
\details{
Non-numeric columns of \code{x} are removed, with a warning.

}
\value{
A numeric matrix containing the deviations from the centering function.
%%  ~Describe the value returned
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
%%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[base]{colMeans}} for column means,

\code{\link[base]{sweep}} 
}
\examples{
data(iris)

Species <- iris$Species
irisdev <- colDevs(iris[,1:4], Species, mean)
irisdev <- colDevs(iris[,1:4], Species, median)
# trimmed mean, using an anonymous function
irisdev <- colDevs(iris[,1:4], Species, function(x) mean(x, trim=0.25))

# no grouping variable: deviations from column grand means
# include all variables (but suppress warning for this doc)
irisdev <- suppressWarnings( colDevs(iris) )
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
