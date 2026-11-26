# Multivariate Box-Cox transformations for an mlm: first demo (see dev/box-cox.md)
# Data: heplots::Dystrophy (Rencher Table 5.7), four enzymes ~ group + age + month
# Functions: dev/box-cox-functions.R. A second example: dev/box-cox-diabetes.R
#
#   1. car::powerTransform() on the mlm; summary(); testTransform() for candidate powers
#   2. Profile log-likelihood plots: bc_profile() does 1-D (one variable) or 2-D (two),
#      as a true profile or a slice at the MLE; extend_range = TRUE to include lambda = 1
#   3. Refit with the rounded powers; compare cqplot(), Anova(), boxM() and HE plots
#   4. The powers that make the covariance matrices most equal (minimize Box's M)
#
# Run from the package root:   source("dev/box-cox-demo.R")
#
# DONE: ✔️ Functions moved to dev/box-cox-functions.R 11/26/2026

devtools::load_all(".", quiet = TRUE)
library(car)
source("dev/box-cox-functions.R")

# ==========================================================================================
# 1. Estimate the powers
# ==========================================================================================
data(Dystrophy)
mod <- lm(cbind(CK, Hpx, PK, LD) ~ group + age + month, data = Dystrophy)

pt <- powerTransform(mod)               # residuals as close to multinormal as possible
summary(pt)
coef(pt, round = TRUE)                  # (-0.5, 2, 0, 0)

# the candidate vectors in dev/box-cox.md
cands <- list("ML, rounded"           = c(-0.5, 2, 0, 0),
              "log CK, Hpx^2, logs"   = c(0, 2, 0, 0),
              "demo: log, raw, logs"  = c(0, 1, 0, 0),
              "all logs"              = c(0, 0, 0, 0),
              "none"                  = c(1, 1, 1, 1))
# (testTransform() returns pval as a formatted string, e.g. "< 2.22e-16", so recompute it)
lr <- t(sapply(cands, function(l) {
  tt <- testTransform(pt, l)
  c(LRT = tt$LRT, df = tt$df, pval = pchisq(tt$LRT, tt$df, lower.tail = FALSE))
}))
round(lr, 4)

# check: bc_loglik() gives the same LR statistics as car
lr_mine <- sapply(cands, function(l) 2 * (bc_loglik(pt$lambda, pt) - bc_loglik(l, pt)))
stopifnot(isTRUE(all.equal(unname(lr_mine), unname(lr[, "LRT"]), tolerance = 1e-6)))

# marginal powers (for the responses themselves, ignoring the model) differ a little
coef(powerTransform(Dystrophy[, c("CK", "Hpx", "PK", "LD")]))

# ==========================================================================================
# 2. Profile plots
# ==========================================================================================
# 1-D: one panel per response; true profile (solid) and slice at the MLE (dashed),
# extended to show lambda = 1
op <- par(mfrow = c(2, 2), mar = c(4, 4, 4, 1))
for (v in colnames(pt$y)) {
  prof <- bc_profile(pt, v, extend_range = TRUE)
  plot(prof, main = v)
  slice <- bc_profile(pt, v, type = "slice", extend_range = TRUE)
  lines(slice$axes[[1]], slice$loglik, lty = 2, col = "gray40", lwd = 2)
}
par(op)
# The profile and slice are close: the estimates are nearly uncorrelated (invHess)
round(cov2cor(pt$invHess), 2)

# 2-D: (CK, Hpx), the two that want the strongest transformations, and (CK, PK), the
# most correlated pair of estimates. Top: around the MLE; bottom: extended to (1, 1).
t0 <- Sys.time()
prof2 <- bc_profile(pt, c("CK", "Hpx"))
cat("2-D profile, 61 x 61 grid:", round(as.numeric(Sys.time() - t0, units = "secs"), 1), "s\n")
prof3 <- bc_profile(pt, c("CK", "PK"))
prof2x <- bc_profile(pt, c("CK", "Hpx"), extend_range = TRUE, n = 81)
prof3x <- bc_profile(pt, c("CK", "PK"), extend_range = TRUE, n = 81)
op <- par(mfrow = c(2, 2), mar = c(4, 4, 4, 1))
plot(prof2); plot(prof3)
plot(prof2x); plot(prof3x)
par(op)
# The LR region and Wald ellipse nearly coincide: the quadratic approximation is good here.
# The rounded powers (x) are well inside. (1, 1) is far outside, especially in CK.

# ==========================================================================================
# 3. Refit with the rounded powers, and compare before / after
# ==========================================================================================
lam <- coef(pt, round = TRUE)
mod2 <- bc_refit(mod, lam)
colnames(coef(mod2))                    # CK_m0.5, Hpx_2, logPK, logLD
mod1 <- bc_refit(mod, c(0, 1, 0, 0))    # the demo's choice, for comparison

# multivariate normality of residuals
op <- par(mfrow = c(1, 3))
cqplot(mod,  main = "Raw")
cqplot(mod1, main = "log CK, PK, LD")
cqplot(mod2, main = "Box-Cox (-0.5, 2, 0, 0)")
par(op)

# tests: Pillai for each term
pillai <- function(m) {
  a <- Anova(m)
  sapply(a$terms, function(t) {
    e <- Re(eigen(solve(a$SSPE) %*% a$SSP[[t]], only.values = TRUE)$values)
    sum(e / (1 + e))
  })
}
round(cbind(raw = pillai(mod), demo = pillai(mod1), BoxCox = pillai(mod2)), 3)

# homogeneity of covariance matrices, carriers vs noncarriers (group only; boxM() for an lm
# needs all predictors to be factors)
bm <- lapply(list(raw = mod, demo = mod1, BoxCox = mod2),
             function(m) boxM(model.response(model.frame(m)), Dystrophy$group))
t(sapply(bm, function(b) c(M = unname(b$statistic), p = b$p.value)))

# HE plots before / after (scales differ, so side by side, not overlaid)
op <- par(mfrow = c(1, 3), mar = c(4, 4, 3, 1))
heplot(mod,  variables = c("CK", "Hpx"), fill = TRUE, fill.alpha = 0.1, main = "Raw")
heplot(mod1, variables = c("logCK", "Hpx"), fill = TRUE, fill.alpha = 0.1,
       main = "log CK, raw Hpx")
heplot(mod2, variables = c("CK_m0.5", "Hpx_2"), fill = TRUE, fill.alpha = 0.1,
       main = "Box-Cox: CK^-0.5, Hpx^2")
par(op)

# ==========================================================================================
# 4. The powers that make the covariance matrices most equal (dev/box-cox.md point 4)
# ==========================================================================================
Y <- model.response(model.frame(mod))
bmin <- bc_boxM(Y, Dystrophy$group, start = pt$lambda)
round(rbind(normality = pt$lambda, equalCov = bmin$lambda), 2)
c(M_at_normality_MLE = bmin$M_start, M_min = bmin$M, M_raw = bmin$M_of(rep(1, 4)))
