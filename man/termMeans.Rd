\name{termMeans}
\alias{termMeans}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate Means for a Term in a Multivariate Linear Model
}
\description{
\code{termMeans} is a utility function designed to calculate 
means for the levels of factor(s) for any term
in a multivariate linear model.
}
\usage{
termMeans(mod, term, label.factors=FALSE, abbrev.levels=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mod}{
An mlm model object
}
  \item{term}{
A character string indicating a given term in the model.
All factors in the term must be included in the model, even if they are in the
model data frame.
 
}
  \item{label.factors}{
If true, the rownames for each row in the result include
the name(s) of the factor(s) involved, followed by the
level values. Otherwise, the rownames include only the levels
of the factor(s), with multiple factors separated by ':'
}
  \item{abbrev.levels}{
Either a logical or an integer, specifying whether the levels values
of the factors in the \code{term} are to be abbreviated in
constructing the rownames.  An integer specifies the minimum length
of the abbreviation for each factor in the term.
}

}
%\details{
%%%  ~~ If necessary, more details than the description above ~~
%}
\value{
Returns a matrix whose columns correspond to the response variables
in the model and whose rows correspond to the levels of the factor(s)
in the \code{term}.
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
\code{\link[stats]{aggregate}}, \code{\link[base]{colMeans}}

\code{\link{statList}}, \code{\link{colMeansList}}
}
\examples{
factors <- expand.grid(A=factor(1:3),B=factor(1:2),C=factor(1:2))
n <- nrow(factors)
responses <-data.frame(Y1=10+round(10*rnorm(n)),Y2=10+round(10*rnorm(n)))
test <- data.frame(factors, responses)
mod <- lm(cbind(Y1,Y2) ~ A*B, data=test)

termMeans(mod, "A")
termMeans(mod, "A:B")
termMeans(mod, "A:B", label.factors=TRUE)
\dontrun{
termMeans(mod, "A:B:C")    # generates an error
}

plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
colors = c("red", "darkblue", "darkgreen", "brown")
heplot(plastic.mod, col=colors, cex=1.25)
# add means for interaction term
intMeans <- termMeans(plastic.mod, 'rate:additive', abbrev=2)
points(intMeans[,1], intMeans[,2], pch=18, cex=1.2, col="brown")
text(intMeans[,1], intMeans[,2], rownames(intMeans), adj=c(0.5,1), col="brown")


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}
\keyword{models}% __ONLY ONE__ keyword per line
