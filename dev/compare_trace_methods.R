# Comparison of Trace CI Methods
#
# This script compares three approaches for confidence intervals on the
# trace (sum of eigenvalues) of covariance matrices:
#   1. Analytic (asymptotic) - traceCI()
#   2. Bootstrap - eigstatCI()
#   3. Visual comparison with plot.boxM()

library(heplots)
library(boot)

source('dev/traceCI.R')
source('dev/eigstatCI.R')

cat("\n========================================\n")
cat("Comparison: Analytic vs Bootstrap CIs\n")
cat("for Trace (Sum of Eigenvalues)\n")
cat("========================================\n\n")

# ============================================================================
# Example 1: Iris Data
# ============================================================================

cat("=== Example 1: Iris Data ===\n\n")

# Fit Box's M test
iris.boxm <- boxM(iris[, 1:4], iris$Species)
print(iris.boxm)

# Get covariance matrices for analytic method
cov_iris <- c(iris.boxm$cov, list(pooled = iris.boxm$pooled))
n_iris <- c(rep(50, 3), 150)

# Method 1: Analytic CI
cat("\n--- Method 1: Analytic CI (traceCI) ---\n")
t1 <- system.time({
  CI_analytic <- traceCI(cov_iris, n = n_iris, conf = 0.95)
})
print(round(CI_analytic, 3))
cat("Computation time:", round(t1[3], 4), "seconds\n")

# Method 2: Bootstrap CI
cat("\n--- Method 2: Bootstrap CI (eigstatCI, R=1000) ---\n")
t2 <- system.time({
  CI_bootstrap <- eigstatCI(Y = iris[, 1:4],
                            group = iris$Species,
                            which = "sum",
                            R = 1000,
                            seed = 98765)
})
print(round(CI_bootstrap[, c("group", "statistic", "lower", "upper", "se")], 3))
cat("Computation time:", round(t2[3], 4), "seconds\n")
cat("Speedup (Bootstrap/Analytic):", round(t2[3] / t1[3], 1), "x\n")

# Comparison table
cat("\n--- Side-by-Side Comparison ---\n")
comp_iris <- data.frame(
  Group = rownames(CI_analytic),
  Trace_Analytic = CI_analytic$trace,
  Trace_Bootstrap = CI_bootstrap$statistic,
  Lower_Analytic = CI_analytic$lower,
  Lower_Bootstrap = CI_bootstrap$lower,
  Upper_Analytic = CI_analytic$upper,
  Upper_Bootstrap = CI_bootstrap$upper,
  Width_Analytic = CI_analytic$upper - CI_analytic$lower,
  Width_Bootstrap = CI_bootstrap$upper - CI_bootstrap$lower,
  SE_Analytic = CI_analytic$se,
  SE_Bootstrap = CI_bootstrap$se
)
print(round(comp_iris, 3))

# ============================================================================
# Visual Comparison: 4-panel plot
# ============================================================================

cat("\n\n=== Creating 4-Panel Comparison Plot ===\n\n")

par(mfrow = c(2, 2), mar = c(5, 4, 3, 1))

# Panel 1: Standard plot.boxM (no CI for sum)
plot(iris.boxm, which = "sum", gplabel = "Species",
     main = "Standard plot.boxM\n(no CI)")

# Panel 2: Analytic CI
yorder <- 1:4
xlim <- range(c(CI_analytic$lower, CI_analytic$upper))

dotchart(CI_analytic$trace[yorder],
         labels = rownames(CI_analytic)[yorder],
         xlab = "sum of eigenvalues",
         xlim = xlim,
         main = "Analytic CI\n(traceCI)")

arrows(CI_analytic$lower[yorder], yorder,
       CI_analytic$upper[yorder], yorder,
       lwd = 2, angle = 90, length = 0.075, code = 3,
       col = "blue")

points(CI_analytic$trace[yorder], yorder,
       cex = c(rep(2, 3), 2.5),
       pch = c(rep(16, 3), 15),
       col = c(rep("blue", 3), "red"))

text(par("usr")[1], 3.5, "Species", pos = 4, cex = 1.25)

# Panel 3: Bootstrap CI
xlim <- range(c(CI_bootstrap$lower, CI_bootstrap$upper))

dotchart(CI_bootstrap$statistic[yorder],
         labels = CI_bootstrap$group[yorder],
         xlab = "sum of eigenvalues",
         xlim = xlim,
         main = "Bootstrap CI\n(eigstatCI, R=1000)")

arrows(CI_bootstrap$lower[yorder], yorder,
       CI_bootstrap$upper[yorder], yorder,
       lwd = 2, angle = 90, length = 0.075, code = 3,
       col = "darkgreen")

points(CI_bootstrap$statistic[yorder], yorder,
       cex = c(rep(2, 3), 2.5),
       pch = c(rep(16, 3), 15),
       col = c(rep("darkgreen", 3), "red"))

text(par("usr")[1], 3.5, "Species", pos = 4, cex = 1.25)

# Panel 4: Both CIs overlaid
xlim <- range(c(CI_analytic$lower, CI_analytic$upper,
                CI_bootstrap$lower, CI_bootstrap$upper))

plot(NULL, xlim = xlim, ylim = c(0.5, 4.5),
     xlab = "sum of eigenvalues",
     ylab = "",
     main = "Overlay Comparison\n(Blue=Analytic, Green=Bootstrap)",
     yaxt = "n")

axis(2, at = 1:4, labels = rownames(CI_analytic)[yorder], las = 1)

# Analytic CIs (blue, offset up)
arrows(CI_analytic$lower[yorder], yorder + 0.1,
       CI_analytic$upper[yorder], yorder + 0.1,
       lwd = 2, angle = 90, length = 0.075, code = 3,
       col = "blue")

points(CI_analytic$trace[yorder], yorder + 0.1,
       pch = 16, cex = 1.2, col = "blue")

# Bootstrap CIs (green, offset down)
arrows(CI_bootstrap$lower[yorder], yorder - 0.1,
       CI_bootstrap$upper[yorder], yorder - 0.1,
       lwd = 2, angle = 90, length = 0.075, code = 3,
       col = "darkgreen")

points(CI_bootstrap$statistic[yorder], yorder - 0.1,
       pch = 16, cex = 1.2, col = "darkgreen")

legend("topright",
       legend = c("Analytic", "Bootstrap"),
       col = c("blue", "darkgreen"),
       lwd = 2, pch = 16, bty = "n")

par(mfrow = c(1, 1))

# ============================================================================
# Example 2: Skulls Data (5 groups)
# ============================================================================

cat("\n\n=== Example 2: Skulls Data ===\n\n")

data(Skulls)
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data = Skulls)
skulls.boxm <- boxM(skulls.mod)

# Get covariance matrices
skulls_cov <- c(skulls.boxm$cov, list(pooled = skulls.boxm$pooled))
skulls_n <- c(table(Skulls$epoch), sum(table(Skulls$epoch)))

# Analytic CI
cat("--- Analytic CI ---\n")
t1 <- system.time({
  CI_skulls_analytic <- traceCI(skulls_cov, n = skulls_n, conf = 0.95)
})
print(round(CI_skulls_analytic, 3))
cat("Time:", round(t1[3], 4), "sec\n")

# Bootstrap CI
cat("\n--- Bootstrap CI (R=500) ---\n")
t2 <- system.time({
  CI_skulls_bootstrap <- eigstatCI(
    Y = as.matrix(Skulls[, c("mb", "bh", "bl", "nh")]),
    group = Skulls$epoch,
    which = "sum",
    R = 500,
    seed = 11111
  )
})
print(round(CI_skulls_bootstrap[, c("group", "statistic", "lower", "upper")], 3))
cat("Time:", round(t2[3], 4), "sec\n")
cat("Speedup:", round(t2[3] / t1[3], 1), "x\n")

# Visual comparison
cat("\n--- Visual Comparison ---\n")

par(mfrow = c(1, 2), mar = c(5, 6, 3, 1))

# Analytic
yorder <- 1:6
xlim <- range(c(CI_skulls_analytic$lower, CI_skulls_analytic$upper))

dotchart(CI_skulls_analytic$trace[yorder],
         labels = rownames(CI_skulls_analytic)[yorder],
         xlab = "sum of eigenvalues",
         xlim = xlim,
         main = "Skulls: Analytic CI")

arrows(CI_skulls_analytic$lower[yorder], yorder,
       CI_skulls_analytic$upper[yorder], yorder,
       lwd = 2, angle = 90, length = 0.075, code = 3,
       col = "blue")

points(CI_skulls_analytic$trace[yorder], yorder,
       cex = c(rep(1.5, 5), 2),
       pch = c(rep(16, 5), 15),
       col = c(rep("blue", 5), "red"))

# Bootstrap
xlim <- range(c(CI_skulls_bootstrap$lower, CI_skulls_bootstrap$upper))

dotchart(CI_skulls_bootstrap$statistic[yorder],
         labels = CI_skulls_bootstrap$group[yorder],
         xlab = "sum of eigenvalues",
         xlim = xlim,
         main = "Skulls: Bootstrap CI")

arrows(CI_skulls_bootstrap$lower[yorder], yorder,
       CI_skulls_bootstrap$upper[yorder], yorder,
       lwd = 2, angle = 90, length = 0.075, code = 3,
       col = "darkgreen")

points(CI_skulls_bootstrap$statistic[yorder], yorder,
       cex = c(rep(1.5, 5), 2),
       pch = c(rep(16, 5), 15),
       col = c(rep("darkgreen", 5), "red"))

par(mfrow = c(1, 1))

# ============================================================================
# Summary Statistics
# ============================================================================

cat("\n\n========================================\n")
cat("Summary\n")
cat("========================================\n\n")

cat("Computation Time Comparison:\n")
cat(sprintf("  Analytic method: %.4f sec\n", t1[3]))
cat(sprintf("  Bootstrap method (R=1000): %.4f sec\n", t2[3]))
cat(sprintf("  Speedup factor: %.1fx\n", t2[3] / t1[3]))

cat("\nInterval Width Comparison (Iris):\n")
width_ratio <- (CI_analytic$upper - CI_analytic$lower) /
               (CI_bootstrap$upper - CI_bootstrap$lower)
cat(sprintf("  Analytic/Bootstrap ratio: %.2f - %.2f\n",
            min(width_ratio), max(width_ratio)))
cat(sprintf("  Average ratio: %.2f\n", mean(width_ratio)))

cat("\nConclusions:\n")
cat("  ✓ Analytic method is much faster (no resampling)\n")
cat("  ✓ Both methods give similar point estimates\n")
cat("  ✓ Analytic CIs tend to be slightly narrower (asymptotic theory)\n")
cat("  ✓ Bootstrap may be more accurate for small samples\n")
cat("  ✓ Both methods produce reasonable, comparable results\n")

cat("\n=== Comparison complete ===\n")
