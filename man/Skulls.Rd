\name{Skulls}
\alias{Skulls}
\docType{data}
\title{ Egyptian Skulls }
\description{

  Measurements made on Egyptian skulls from five epochs.

}
\usage{data("Skulls")}
\format{
  A data frame with 150 observations on the following 5 variables.
  \describe{
    \item{\code{epoch}}{the epoch the skull as assigned to, 
                        an ordered factor with levels \code{c4000BC} \code{c3300BC},
                        \code{c1850BC},  \code{c200BC}, and  \code{cAD150},
                        where the years are only given approximately, of
                        course.}
    \item{\code{mb}}{maximal breadth of the skull.}
    \item{\code{bh}}{basibregmatic height of the skull.}
    \item{\code{bl}}{basialveolar length of the skull.}
    \item{\code{nh}}{nasal height of the skull.}
  }
}
\details{

  The question is whether the measurements change over time.
  Non-constant measurements of the skulls over time would indicate
  interbreeding with immigrant populations.

  Note that using polynomial contrasts for \code{epoch} essentially treats
  the time points as equally spaced.
}
\source{


  D. J. Hand, F. Daly, A. D. Lunn, K. J. McConway and E. Ostrowski (1994).
  \emph{A Handbook of Small Datasets}, Chapman and Hall/CRC, London.

}

\references{
  Thomson, A. and Randall-Maciver, R. (1905) \emph{Ancient Races of the Thebaid}, Oxford: Oxford University Press. 

  Egyptian Skull Development, StatLib Data and Story Library,
  \url{http://lib.stat.cmu.edu/DASL/Stories/EgyptianSkullDevelopment.html}
}

\examples{
data(Skulls)
# make shorter labels for epochs
Skulls$epoch <- factor(Skulls$epoch, labels=sub("c","",levels(Skulls$epoch)))
# variable labels
vlab <- c("maxBreadth", "basibHeight", "basialLength", "nasalHeight")

# fit manova model
sk.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)

Manova(sk.mod)
summary(Manova(sk.mod))

# test trends over epochs
linearHypothesis(sk.mod, "epoch.L") # linear component
linearHypothesis(sk.mod, "epoch.Q") # quadratic component

# typical scatterplots are not very informative
scatterplot(mb ~ bh|epoch, data=Skulls, ellipse=TRUE, levels=0.68, smooth=FALSE, legend.coords="topright")
scatterplot(mb ~ bl|epoch, data=Skulls, ellipse=TRUE, levels=0.68, smooth=FALSE, legend.coords="topright")

# HE plots

heplot(sk.mod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), xlab=vlab[1], ylab=vlab[2])
pairs(sk.mod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), var.labels=vlab)
# 3D plot shows that nearly all of hypothesis variation is linear!
heplot3d(sk.mod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), col=c("pink", "blue"))

# view in canonical space
if (require(candisc)) {
	sk.can <- candisc(sk.mod)
	sk.can
	heplot(sk.can)
	heplot3d(sk.can)
}

}
\keyword{datasets}
