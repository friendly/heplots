\name{Iwasaki_Big_Five}
\alias{Iwasaki_Big_Five}
\docType{data}
\title{
Personality Traits of Cultural Groups
}
\description{
This dataset, from Grice & Iwasaki (2007), gives scores on the five personality scales of the NEO PI-r (Costa & McCrae, 1992),
called the "Big Five" personality traits: Neuroticism, Extraversion, Openness-to-Experience, Agreeableness, and Conscientiousness.
}
\usage{data("Iwasaki_Big_Five")}
\format{
  A data frame with 203 observations on the following 7 variables.
  \describe{
    \item{\code{ID}}{ID number}
    \item{\code{Group}}{a factor with levels \code{Eur} \code{Asian_Amer} \code{Asian_Intl}}
    \item{\code{N}}{Neuroticism score}
    \item{\code{E}}{Extraversion score}
    \item{\code{O}}{Openness score}
    \item{\code{A}}{Agreeableness score}
    \item{\code{C}}{Conscientiousness score}
  }
}
\details{
The groups are:
\describe{
  \item{Eur}{European Americans (Caucasians living in the United States their entire lives)}
  \item{Asian_Amer}{Asian Americans (Asians living in the United States since before the age of 6 years)}
  \item{Asian_Intl}{Asian Internationals (Asians who moved to the United States after their 6th birthday)}
}

The factor \code{Group} is set up to compare E vs. Asian and the two Asian groups
}
\source{
Grice, J., & Iwasaki, M. (2007). A truly multivariate approach to MANOVA. 
\emph{Applied Multivariate Research}, \bold{12}, 199-226. https://doi.org/10.22329/amr.v12i3.660.

}
\references{
Costa Jr, P. T., & McCrae, R. R. (1992). 
\emph{Revised NEO Personality Inventory (NEO PI-R) and NEO Five-Factor Inventory (NEOFFI) professional manual}. 
Psychological Assessment Resources.
}
\examples{
data(Iwasaki_Big_Five)
str(Iwasaki_Big_Five)

mod <- lm(cbind(N, E, O, A, C) ~ Group, data=Iwasaki_Big_Five)

Anova(mod)

# heplots
labs <- c("Neuroticism", "Extraversion", "Openness", "Agreeableness", "Consientiousness" )

heplot(mod,
       fill = TRUE, fill.alpha = 0.2, 
       cex.lab = 1.5,
       xlab = labs[1], ylab = labs[2])

heplot(mod, variables = c(2,5),
       fill = TRUE, fill.alpha = 0.2,
       cex.lab = 1.5,
       xlab = labs[2], ylab = labs[5])

pairs(mod, 
      fill = TRUE, fill.alpha = 0.2, var.labels = labs)


}
\keyword{datasets}
\concept{MANOVA}

