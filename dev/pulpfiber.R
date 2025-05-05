# Robust regression example
#
# Measurements of aspects pulp fibers and the paper produced from them. 
# Four properties of each are measured in sixty-two samples.
# From: Rousseeuw, P. J., Van Aelst, S., Van Driessen, K., and Agulló, J. (2004) Robust multivariate regression; Technometrics 46, 293–305
# Data from: Lee, J. (1992) Relationships Between Properties of Pulp-Fibre and Paper, unpublished doctoral thesis, U. Toronto, Faculty of Forestry


library(dplyr)
library(car)

data(pulpfiber, package="robustbase")

# pulpfiber |>
#   rename(
#     fiber_length  = X1,
#     long_fraction = X2,
#     fine_fraction = X3,
#     zero_span     = X4,
# 
#     breaking_length = Y1,
#     elastic_modulus = Y2,
#     failure_stress  = Y3,
#     burst_strength  = Y4
#   )

labels <- c(
  X1 = "fiber_length",
  X2 = "long_fraction",
  X3 = "fine_fraction",
  X4 = "zero_span",
  
  Y1 = "breaking_length",
  Y2 = "elastic_modulus",
  Y3 = "failure_stress",
  Y4 = "burst_strength"
  )


pulp.mod <- lm(cbind(Y1, Y2, Y3, Y4) ~ X1 + X2 + X3 + X4, data = pulpfiber)
Anova(pulp.mod)

heplot(pulp.mod)
pairs(pulp.mod,
      var.labels = labels[5:8])

pulp.rlm <- robmlm(cbind(Y1, Y2, Y3, Y4) ~ X1 + X2 + X3 + X4, data = pulpfiber)
Anova(pulp.rlm)

plot(pulp.rlm, segments = TRUE)

heplot(pulp.rlm)
pairs(pulp.rlm,
      var.labels = labels[5:8])





