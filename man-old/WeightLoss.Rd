\name{WeightLoss}
\Rdversion{1.1}
\alias{WeightLoss}
\docType{data}
\title{
Weight Loss Data
}
\description{
Contrived data on weight loss and self esteem over three months,
for three groups of individuals: Control, Diet and Diet + Exercise.
The data constitute a double-multivariate design.
}
\usage{data(WeightLoss)}
\format{
  A data frame with 34 observations on the following 7 variables.
  \describe{
    \item{\code{group}}{a factor with levels \code{Control} \code{Diet} \code{DietEx}.}
    \item{\code{wl1}}{Weight loss at 1 month}
    \item{\code{wl2}}{Weight loss at 2 months}
    \item{\code{wl3}}{Weight loss at 3 months}
    \item{\code{se1}}{Self esteem at 1 month}
    \item{\code{se2}}{Self esteem at 2 months}
    \item{\code{se3}}{Self esteem at 3 months}
  }
}
\details{
Helmert contrasts are assigned to \code{group}, comparing \code{Control} vs. (\code{Diet} \code{DietEx})
and \code{Diet} vs. \code{DietEx}.
}
\source{
Originally taken from \url{http://www.csun.edu/~ata20315/psy524/main.htm},
but modified slightly
}
\references{
  Friendly, Michael  (2010). HE Plots for Repeated Measures Designs. \emph{Journal of Statistical Software},
  37(4), 1-40.
%  URL \url{https://www.jstatsoft.org/v37/i04/}.
  \doi{10.18637/jss.v037.i04}.

}
\examples{
data(WeightLoss)
str(WeightLoss)
table(WeightLoss$group)

contrasts(WeightLoss$group) <- matrix(c(-2,1,1, 0, -1, 1),ncol=2)
(wl.mod<-lm(cbind(wl1,wl2,wl3,se1,se2,se3)~group, data=WeightLoss))

heplot(wl.mod, hypotheses=c("group1", "group2"))
pairs(wl.mod, variables=1:3)
pairs(wl.mod, variables=4:6)

# within-S variables
within <- data.frame(measure=rep(c("Weight loss", "Self esteem"),each=3), month=rep(ordered(1:3),2))

# doubly-multivariate analysis: requires car 2.0+
\dontrun{
if (packageDescription("car")[["Version"]] >= 2) {
imatrix <- matrix(c(
	1,0,-1, 1, 0, 0,
	1,0, 0,-2, 0, 0,
	1,0, 1, 1, 0, 0,
	0,1, 0, 0,-1, 1,
	0,1, 0, 0, 0,-2,
	0,1, 0, 0, 1, 1), 6, 6, byrow=TRUE)

# NB: for heplots the columns of imatrix should have names
colnames(imatrix) <- c("WL", "SE", "WL.L", "WL.Q", "SE.L", "SE.Q")
rownames(imatrix) <- colnames(WeightLoss)[-1]
(imatrix <- list(measure=imatrix[,1:2], month=imatrix[,3:6]))
contrasts(WeightLoss$group) <- matrix(c(-2,1,1, 
                                        0,-1,1), ncol=2) 

(wl.mod<-lm(cbind(wl1, wl2, wl3, se1, se2, se3)~group, data=WeightLoss))
(wl.aov <- Anova(wl.mod, imatrix=imatrix, test="Roy"))

heplot(wl.mod, imatrix=imatrix, iterm="group:measure")
}
}

# do the correct analysis 'manually'
unit <- function(n, prefix="") {
	J <-matrix(rep(1, n), ncol=1)
	rownames(J) <- paste(prefix, 1:n, sep="")
	J
}                

measure <- kronecker(diag(2), unit(3, 'M')/3, make.dimnames=TRUE)
colnames(measure)<- c('WL', 'SE')

between <- as.matrix(WeightLoss[,-1]) %*% measure

between.mod <- lm(between ~ group, data=WeightLoss)
Anova(between.mod)

heplot(between.mod, hypotheses=c("group1", "group2"), 
	xlab="Weight Loss", ylab="Self Esteem",
	col=c("red", "blue", "brown"),
	main="Weight Loss & Self Esteem: Group Effect")

month <- kronecker(diag(2), poly(1:3), make.dimnames=TRUE)
colnames(month)<- c('WL', 'SE')
trends <- as.matrix(WeightLoss[,-1]) %*% month
within.mod <- lm(trends ~ group, data=WeightLoss)
Anova(within.mod)

heplot(within.mod)
heplot(within.mod, hypotheses=c("group1", "group2"), 
	xlab="Weight Loss", ylab="Self Esteem",
	type="III", remove.intercept=FALSE,
	term.labels=c("month", "group:month"),
	main="Weight Loss & Self Esteem: Within-S Effects")
mark.H0()
}
\keyword{datasets}
