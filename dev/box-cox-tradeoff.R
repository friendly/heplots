# Normality vs equal covariance matrices: the two criteria for choosing Box-Cox powers,
# shown together (see dev/box-cox.md, point 4, and "Second round")
# Functions: dev/box-cox-functions.R. Data: heplots::Dystrophy and heplots::Diabetes.
#
# bc_profile(group = ) computes Box's M at every grid point, using the same full lambda
# vector as the log-likelihood there; plot() shows M on a second axis (1-D) or as dashed
# contours (2-D), with its minimum marked.
#
# Run from the package root:   source("dev/box-cox-tradeoff.R")
#
# DONE: ✔️ Created 11/26/2026

devtools::load_all(".", quiet = TRUE)
library(car)
source("dev/box-cox-functions.R")

data(Dystrophy)
data(Diabetes)
dmd.mod  <- lm(cbind(CK, Hpx, PK, LD) ~ group + age + month, data = Dystrophy)
diab.mod <- lm(cbind(relwt, glufast, glutest, instest, sspg) ~ group, data = Diabetes)
dmd.pt  <- powerTransform(dmd.mod)
diab.pt <- powerTransform(diab.mod)

# ------------------------------------------------------------------------------------------
# Check: the fast bc_M_fun() gives the same statistic as heplots::boxM()
# ------------------------------------------------------------------------------------------
M_fast <- bc_M_fun(diab.pt$y, Diabetes$group)
for (l in list(rep(1, 5), diab.pt$lambda, c(0.5, 0, -1, 2, 1))) {
  slow <- unname(boxM(car::bcPower(diab.pt$y, l), Diabetes$group)$statistic)
  stopifnot(isTRUE(all.equal(M_fast(l), slow)))
}
system.time(for (i in 1:500) M_fast(diab.pt$lambda))       # per call, about 1/500 of this

# ------------------------------------------------------------------------------------------
# 1-D: log-likelihood profile and Box's M against each lambda
# ------------------------------------------------------------------------------------------
op <- par(mfrow = c(2, 2), mar = c(4, 4, 4, 4))
for (v in colnames(dmd.pt$y))
  plot(bc_profile(dmd.pt, v, extend_range = TRUE, group = Dystrophy$group), main = v)
par(op)

op <- par(mfrow = c(2, 3), mar = c(4, 4, 4, 4))
for (v in colnames(diab.pt$y))
  plot(bc_profile(diab.pt, v, extend_range = TRUE, group = Diabetes$group), main = v)
par(op)

# ------------------------------------------------------------------------------------------
# 2-D: M contours over the likelihood regions
# ------------------------------------------------------------------------------------------
t0 <- Sys.time()
d2 <- bc_profile(dmd.pt, c("CK", "Hpx"), extend_range = TRUE, n = 81, group = Dystrophy$group)
cat("2-D profile + M, 81 x 81:", round(as.numeric(Sys.time() - t0, units = "secs"), 1), "s\n")
g2 <- bc_profile(diab.pt, c("glufast", "glutest"), extend_range = TRUE, n = 81,
                 group = Diabetes$group)
g3 <- bc_profile(diab.pt, c("relwt", "glufast"), extend_range = TRUE, n = 81,
                 group = Diabetes$group)
d3 <- bc_profile(dmd.pt, c("CK", "PK"), extend_range = TRUE, n = 81, group = Dystrophy$group)
op <- par(mfrow = c(2, 2), mar = c(4, 4, 4, 1))
plot(d2); plot(d3)
plot(g2); plot(g3)
par(op)
