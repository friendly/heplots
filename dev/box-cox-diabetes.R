# Multivariate Box-Cox transformations: a second example, heplots::Diabetes
# (see dev/box-cox.md; functions in dev/box-cox-functions.R)
#
# Reaven & Miller's data: 145 patients in 3 groups (Normal, Chemical_Diabetic,
# Overt_Diabetic), 5 responses. A good test case: the glucose and insulin measures are
# skewed, the covariance matrices are very unequal (Box's M = 397 on 30 df), and the
# lambdas for glufast and glutest are correlated (0.40), unlike in Dystrophy.
#
# Run from the package root:   source("dev/box-cox-diabetes.R")
#
# DONE: ✔️ Created, to try out bc_profile(extend_range = TRUE) and bc_boxM() on a second
#       dataset 11/26/2026

devtools::load_all(".", quiet = TRUE)
library(car)
source("dev/box-cox-functions.R")

data(Diabetes)
mod <- lm(cbind(relwt, glufast, glutest, instest, sspg) ~ group, data = Diabetes)
Y <- model.response(model.frame(mod))

# ==========================================================================================
# 1. Estimate the powers
# ==========================================================================================
pt <- powerTransform(mod)
summary(pt)
(lam <- coef(pt, round = TRUE))        # relwt 1, glufast -1, glutest -0.5, instest 1/3, sspg 0.5
round(cov2cor(pt$invHess), 2)          # glufast and glutest estimates correlated, 0.40

# ==========================================================================================
# 2. Profile plots
# ==========================================================================================
# 1-D, all five, extended to lambda = 1; profile (solid) and slice (dashed)
op <- par(mfrow = c(2, 3), mar = c(4, 4, 4, 1))
for (v in colnames(Y)) {
  prof <- bc_profile(pt, v, extend_range = TRUE)
  plot(prof, main = v)
  slice <- bc_profile(pt, v, type = "slice", extend_range = TRUE)
  lines(slice$axes[[1]], slice$loglik, lty = 2, col = "darkgreen")
}
par(op)

# 2-D for the correlated pair (glufast, glutest): profile vs slice, then extended
t0 <- Sys.time()
p_prof  <- bc_profile(pt, c("glufast", "glutest"))
cat("2-D profile (3 other lambdas), 61 x 61:",
    round(as.numeric(Sys.time() - t0, units = "secs"), 1), "s\n")
p_slice <- bc_profile(pt, c("glufast", "glutest"), type = "slice")
p_ext   <- bc_profile(pt, c("glufast", "glutest"), extend_range = TRUE, n = 81)
p_ins   <- bc_profile(pt, c("instest", "sspg"), extend_range = TRUE, n = 81)
op <- par(mfrow = c(2, 2), mar = c(4, 4, 4, 1))
plot(p_prof); plot(p_slice)
plot(p_ext);  plot(p_ins)
par(op)

# ==========================================================================================
# 3. Refit with the rounded powers; before / after
# ==========================================================================================
mod2 <- bc_refit(mod, lam)
colnames(coef(mod2))

op <- par(mfrow = c(1, 2))
cqplot(mod,  main = "Raw")
cqplot(mod2, main = "Box-Cox, rounded powers")
par(op)

pillai <- function(m) {
  a <- Anova(m)
  sapply(a$terms, function(t) {
    e <- Re(eigen(solve(a$SSPE) %*% a$SSP[[t]], only.values = TRUE)$values)
    sum(e / (1 + e))
  })
}
round(c(raw = pillai(mod), BoxCox = pillai(mod2)), 3)

# within-group covariance ellipses: does the transformation make them more alike?
op <- par(mfrow = c(1, 2))
covEllipses(Y[, c("glufast", "glutest")], Diabetes$group, fill = TRUE, fill.alpha = 0.1,
            main = "Raw")
Z <- model.response(model.frame(mod2))
covEllipses(Z[, 2:3], Diabetes$group, fill = TRUE, fill.alpha = 0.1,
            main = "Box-Cox")
par(op)

op <- par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
heplot(mod,  variables = c("glufast", "glutest"), fill = TRUE, fill.alpha = 0.1, main = "Raw")
heplot(mod2, variables = 2:3, fill = TRUE, fill.alpha = 0.1, main = "Box-Cox")
par(op)

# ==========================================================================================
# 4. Normality vs equal covariance matrices
# ==========================================================================================
bmin <- bc_boxM(Y, Diabetes$group, start = pt$lambda)
cands <- list(none = rep(1, 5), "normality MLE" = pt$lambda, "normality, rounded" = lam,
              "min Box's M" = bmin$lambda)
# each candidate on both criteria: LR test against the normality MLE, and Box's M
crit <- t(sapply(cands, function(l) {
  LR <- 2 * (bc_loglik(pt$lambda, pt) - bc_loglik(l, pt))
  bm <- boxM(car::bcPower(Y, l), Diabetes$group)
  c(round(l, 2), LR = LR, p_normal = pchisq(LR, 5, lower.tail = FALSE),
    M = unname(bm$statistic), p_boxM = bm$p.value)
}))
colnames(crit)[1:5] <- colnames(Y)
signif(crit, 3)
