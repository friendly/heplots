% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{AddHealth}
\alias{AddHealth}
\title{Adolescent Mental Health Data}
\format{
A data frame with 4344 observations on the following 3 variables.
\describe{ 
  \item{\code{grade}}{an ordered factor with levels \code{7} <
      \code{8} < \code{9} < \code{10} < \code{11} < \code{12}}
  \item{\code{depression}}{a numeric vector} 
  \item{\code{anxiety}}{a numeric vector} 
  }
}
\source{
Warne, R. T. (2014). A primer on Multivariate Analysis of Variance
(MANOVA) for Behavioral Scientists.  
\emph{Practical Assessment, Research & Evaluation}, 19 (1).
}
\description{
This data was taken from the National Longitudinal Study of Adolescent
Health.  It is a cross-sectional sample of participants from grades 7--12,
described and analyzed by Warne (2014).
}
\details{
\code{depression} is the response to the question "In the last month, how
often did you feel depressed or blue?"

\code{anxiety} is the response to the question "In the last month, how often
did you have trouble relaxing?"

The responses for \code{depression} and \code{anxiety} were recorded on a
5-point Likert scale, with categories \code{0="Never", 1="Rarely",
2="Occasionally", 3="Often", 4="Every day"}
}
\examples{

data(AddHealth)

if(require(dplyr) & require(ggplot2)) {
# find means & std.errors by grade
means <- AddHealth |>
group_by(grade) |>
  summarise(
    n = n(),
    dep_se = sd(depression, na.rm = TRUE) / sqrt(n),
    anx_se = sd(anxiety, na.rm = TRUE) / sqrt(n),
    depression = mean(depression),
    anxiety = mean(anxiety) ) |> 
  relocate(depression, anxiety, .after = grade) |>
  print()
  
# plot means with std.error bars
ggplot(data = means, aes(x = anxiety, y = depression, 
color = grade)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = anxiety - anx_se, 
                     xmax = anxiety + anx_se)) +
  geom_errorbar(aes(ymin = depression - dep_se, 
                    ymax = depression + dep_se)) +
  geom_line(aes(group = 1), linewidth = 1.5) +
  geom_label(aes(label = grade), 
             nudge_x = -0.015, nudge_y = 0.02) +
  scale_color_discrete(guide = "none") +
  theme_bw(base_size = 15)
}

# fit mlm
AH.mod <- lm(cbind(anxiety, depression) ~ grade, data=AddHealth)

car::Anova(AH.mod)
summary(car::Anova(AH.mod))

heplot(AH.mod, hypotheses="grade.L", 
       fill=c(TRUE, FALSE),
       level = 0.4)

}
\concept{MANOVA}
\concept{ordered}
\keyword{datasets}
