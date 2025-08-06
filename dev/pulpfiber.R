# Robust regression example
#
# Measurements of aspects pulp fibers and the paper produced from them. 
# Four properties of each are measured in sixty-two samples.
# From: Rousseeuw, P. J., Van Aelst, S., Van Driessen, K., and Agulló, J. (2004) Robust multivariate regression; Technometrics 46, 293–305
# Data from: Lee, J. (1992) Relationships Between Properties of Pulp-Fibre and Paper, unpublished doctoral thesis, U. Toronto, Faculty of Forestry


library(heplots)
library(dplyr)
library(car)

data(pulpfiber, package="robustbase")

# pulpfiber |>
#   rename(
#     fiber_len  = X1,
#     long_frac = X2,
#     fine_frac = X3,
#     zero_span     = X4,
# 
#     breaking_len = Y1,
#     elastic_mod = Y2,
#     failure_stress  = Y3,
#     burst_strength  = Y4
#   )

labels <- c(
  X1 = "fiber_len",
  X2 = "long_frac",
  X3 = "fine_frac",
  X4 = "zero_span",
  
  Y1 = "breaking_len",
  Y2 = "elastic_mod",
  Y3 = "failure_stress",
  Y4 = "burst_stren"
  )


pulp.mod <- lm(cbind(Y1, Y2, Y3, Y4) ~ X1 + X2 + X3 + X4, data = pulpfiber)
Anova(pulp.mod)

cqplot(pulp.mod, id.n = 5)

heplot(pulp.mod)
pairs(pulp.mod,
      var.labels = labels[5:8])

pulp.rlm <- robmlm(cbind(Y1, Y2, Y3, Y4) ~ X1 + X2 + X3 + X4, data = pulpfiber)
Anova(pulp.rlm)

plot(pulp.rlm, segments = TRUE)

heplot(pulp.rlm)
pairs(pulp.rlm,
      var.labels = labels[5:8])

# diagnostic plot: Mahalanobis distances of X vs distances of residuals
# reproduce figs in Rousseeuw et al (2004), Robust Multivariate Regression

dist.X <- pulpfiber |>
  select(X1:X4) |>
  Mahalanobis() |>
  sqrt()

dist.resids <- residuals(pulp.mod) |>
  Mahalanobis() |>
  sqrt()

cutoff <- qchisq(.975, 4) |> sqrt()
out <- dist.X > cutoff | dist.resids > cutoff
plot(dist.X, dist.resids,
     pch = ifelse(out, 16, 1),
     xlab = "Mahalanobis distance of X",
     ylab = "Mahalanobis distance of residuals")
abline(h = cutoff, v = cutoff)
outIDs <- which(dist.X > cutoff | dist.resids > cutoff)
text(dist.X[outIDs], dist.resids[outIDs], (1:nrow(pulpfiber))[outIDs], pos = 2)

#source("C:/R/Projects/heplots/dev/distancePlot.R")
distancePlot.mlm(pulp.mod)

# do the same for robust distances

dist.X <- pulpfiber |>
  select(X1:X4) |>
  Mahalanobis(method = "mcd") |>
  sqrt()

dist.resids <- residuals(pulp.rlm) |>
  Mahalanobis(method = "mcd") |>
  sqrt()

cutoff <- qchisq(.975, 4) |> sqrt()
out <- dist.X > cutoff | dist.resids > cutoff
plot(dist.X, dist.resids,
     pch = ifelse(out, 16, 1),
     xlab = "Robust Mahalanobis distance of X",
     ylab = "Robust Mahalanobis distance of residuals")
abline(h = cutoff, v = cutoff)
outIDs <- which(dist.X > cutoff | dist.resids > cutoff)
text(dist.X[outIDs], dist.resids[outIDs], (1:nrow(pulpfiber))[outIDs], pos = 2)

# try distPlot()

source(here::here("dev", "distancePlot.R"))

distancePlot(pulpfiber[, 1:4], pulpfiber[, 5:8])

distancePlot(pulpfiber[, 1:4], residuals(pulp.mod),
             ylab = "Mahalanobis distance of residuals")

distancePlot(pulpfiber[, 1:4], residuals(pulp.mod),
             method ="mcd",
             ylab = "Mahalanobis distance of residuals")



