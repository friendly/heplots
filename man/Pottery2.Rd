\name{Pottery2}
\alias{Pottery2}
\docType{data}
\title{
Chemical Analysis of Romano-British Pottery
}
\description{
Results of chemical analyses of 48 specimens of Romano-British pottery published by Tubb et al. (1980). 
The numbers are the percentage of various metal oxides found in each sample
for elements of concentrations greater than 0.01\%.
This is the original data set from Tubb et al. (1980), in contrast to \code{\link[carData]{Pottery}}.
}
\usage{data(Pottery2)}
\format{
  A data frame with 48 observations on the following 12 variables.
  \describe{
    \item{\code{Region}}{a factor with levels \code{Gl} \code{NF} \code{Wales}}
    \item{\code{Site}}{a factor with levels \code{AshleyRails} \code{Caldicot} \code{Gloucester} \code{IsleThorns} \code{Llanedryn}}
    \item{\code{Kiln}}{a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5}}
    \item{\code{Al}}{amount of aluminum oxide, \eqn{Al_2O_3}}
    \item{\code{Fe}}{amount of iron oxide, \eqn{Fe_2O_3}}
    \item{\code{Mg}}{amount of magnesium oxide, MgO}
    \item{\code{Ca}}{amount of calcium oxide, CaO}
    \item{\code{Na}}{amount of sodium oxide, \eqn{Na_2O}}
    \item{\code{K}}{amount of potassium oxide, \eqn{K_2O}}
    \item{\code{Ti}}{amount of titanium oxide, \eqn{TiO_2} }
    \item{\code{Mn}}{amount of manganese oxide, MnO}
    \item{\code{Ba}}{amount of BaO}
  }
}
\details{
The specimens are identified by their \code{rownames} in the data frame.
\code{Kiln} indicates at which kiln site the pottery was found;
\code{Site} gives the location names of those sites.
The kiln sites come from three \code{Region}s,  \code{("Gl"=1, "Wales"=(2, 3), "NF"=(4, 5))},
where the full names are "Gloucester", "Wales", and "New Forrest".

The variable \code{Kiln} comes pre-supplied with contrasts to test interesting
hypotheses related to \code{Site} and \code{Region}. 
}
\source{
Originally slightly modified from files by David Carlson,
now at \code{\link[archdata]{RBPottery}}.
% \url{http://people.tamu.edu/~dcarlson/quant/data/RBPottery.html}

}
\references{
Baxter, M. J. 2003. \emph{Statistics in Archaeology}. Arnold, London.

Carlson, David L. 2017. \emph{Quantitative Methods in Archaeology Using R}. Cambridge University
Press, pp 247-255, 335-342.

Tubb, A., A. J. Parker, and G. Nickless. 1980. 
The Analysis of Romano-British Pottery by Atomic Absorption Spectrophotometry. 
\emph{Archaeometry}, \bold{22}, 153-171.
}
\seealso{
	\code{\link[carData]{Pottery}} for the related (subset) data set;
	\code{\link[archdata]{RBPottery}} for a newer version with more variables.
}
\examples{
data(Pottery2)
# contrasts for Kiln correspond to between Region [,1:2] and within Region [,3:4]
contrasts(Pottery2$Kiln)

pmod <-lm(cbind(Al,Fe,Mg,Ca,Na,K,Ti,Mn,Ba)~Kiln, data=Pottery2)
Anova(pmod)

# extract coefficient names for linearHypotheses
coefs <- rownames(coef(pmod))[-1]

# test differences among regions
linearHypothesis(pmod, coefs[1:2])
# test differences within regions B, C
linearHypothesis(pmod, coefs[3:4])

heplot(pmod, fill=c(TRUE,FALSE), hypotheses=list("Region" =coefs[1:2], "WithinBC"=coefs[3:4]))

# all pairwise views;  note that Ba shows no effect
pairs(pmod, fill=c(TRUE,FALSE))

# canonical view, via candisc::heplot

if (require(candisc)) {

# canonical analysis: how many dimensions?
(pcan <- candisc(pmod))

heplot(pcan, scale=18, fill=c(TRUE,FALSE), var.col="darkgreen", var.lwd=2, var.cex=1.5)

\dontrun{
heplot3d(pcan, scale=8)
}
}

}
\keyword{datasets}
\concept{MANOVA}
\concept{candisc}
