\name{Oslo}
\alias{Oslo}
\docType{data}
\title{
Oslo Transect Subset Data
}
\description{
The Oslo  data set contains chemical concentrations of
332 samples of different plant species collected along a 120 km transect running through the city of Oslo, Norway.
It is a subset of the \code{\link[rrcov]{OsloTransect}} data provided by the
\code{rrcov} package.
}
\usage{data(Oslo)}
\format{
  A data frame with 332 observations on the following 14 variables.
  \describe{
    \item{\code{site}}{transect site ID, a factor with levels \code{102} \code{103} \code{104} \code{105} \code{106} \code{107} \code{108} \code{109} \code{111} \code{112} \code{113} \code{114} \code{115} \code{116} \code{117} \code{118} \code{119} \code{121} \code{122} \code{123} \code{124} \code{125} \code{126} \code{127} \code{128} \code{129} \code{131} \code{132} \code{133} \code{134} \code{135} \code{136} \code{138} \code{139} \code{141} \code{142} \code{143} \code{144}}
    \item{\code{XC}}{X coordinate, a numeric vector}
    \item{\code{YC}}{Y coordinate, a numeric vector}
    \item{\code{forest}}{forrest type, a factor with levels \code{birspr} \code{mixdec} \code{pine} \code{sprbir} \code{sprpin} \code{spruce}}
    \item{\code{weather}}{weather type, a factor with levels \code{cloud} \code{moist} \code{nice} \code{rain}}
    \item{\code{litho}}{lithological type, a factor with levels \code{camsed} (Cambro-Silurian sedimentary), 
    	\code{gneis_o} (Precambrian gneisses - Oslo), \code{gneis_r} (- Randsfjord), 
    	\code{magm} (Magmatic rocks)}
    \item{\code{altitude}}{altitude, a numeric vector}
    \item{\code{Cu}}{Copper, a numeric vector}
    \item{\code{Fe}}{Iron, a numeric vector}
    \item{\code{K}}{Potassium, a numeric vector}
    \item{\code{Mg}}{Magnesium, a numeric vector}
    \item{\code{Mn}}{Manganese, a numeric vector}
    \item{\code{P}}{Lead, a numeric vector}
    \item{\code{Zn}}{Zinc, a numeric vector}
  }
}
\details{
The \code{\link[rrcov]{OsloTransect}} contains 360 observations, with 9 observations per site.
Only 7 chemical elements were retained from the 25 contained in the 
\code{\link[rrcov]{OsloTransect}} data,
and these were all log-transformed, following Todorov and Filzmoser (2009).

Only complete cases on these variables were retained, and two lithological types of
low frequency were removed,
leaving 332 observations. 
}
\source{
Reimann, C., Arnoldussen, A., Boyd, R., Finne, T.E., Koller, F., Nordgulen, Oe., And Englmaier, P. (2007) 
Element contents in leaves of four plant species (birch, mountain ash, fern and spruce) along anthropogenic and 
geogenic concentration gradients, 
\emph{The Science of the Total Environment}, 377, 416-433.

}
\references{
Todorov V. and Filzmoser P. (2009) 
Robust statistic for the one-way MANOVA, submitted to the \emph{Journal of Environmetrics}. 
}
\examples{
data(Oslo)
table(Oslo$litho)

Oslo.mod <- lm(cbind(Cu, K, Mg, Mn, P, Zn) ~ litho, data=Oslo)
Anova(Oslo.mod)

heplot(Oslo.mod, var=c("Cu", "Mn"))
pairs(Oslo.mod)

\dontrun{
if(require(candisc)) {
  Oslo.can <- candisc(Oslo.mod)
  Oslo.can
  heplot(Oslo.can)
  heplot3d(Oslo.can, shade=TRUE, wire=FALSE, alpha=0.5, var.col="red")
}
}

}
\keyword{datasets}
