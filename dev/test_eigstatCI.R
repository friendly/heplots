# Test script for eigstatCI()
#
# This script demonstrates how to use the eigstatCI() function to compute
# bootstrap confidence intervals for eigenvalue-based statistics
# in the context of Box's M test.

library(heplots)
library(boot)

# Source the new function
source("dev/eigstatCI.R")

# ============================================================================
# Example 1: Iris data (3 groups, balanced design)
# ============================================================================

cat("\n=== Example 1: Iris Data ===\n\n")

# Fit Box's M test
iris.boxm <- boxM(iris[,1:4], iris$Species)
print(iris.boxm)

# Current plot with analytic CI for logDet
plot(iris.boxm, gplabel="Species", main="logDet with analytic CI")

# Now get bootstrap CIs for eigenvalue statistics
# Note: Using R=500 for speed; increase to 1000+ for production

cat("\n--- Bootstrap CI for product of eigenvalues ---\n")
CI_product <- eigstatCI(Y = iris[,1:4],
                        group = iris$Species,
                        which = "product",
                        R = 500,
                        seed = 123)
print(CI_product)

cat("\n--- Bootstrap CI for sum of eigenvalues ---\n")
CI_sum <- eigstatCI(Y = iris[,1:4],
                    group = iris$Species,
                    which = "sum",
                    R = 500,
                    seed = 123)
print(CI_sum)

cat("\n--- Bootstrap CI for precision (harmonic mean) ---\n")
CI_precision <- eigstatCI(Y = iris[,1:4],
                          group = iris$Species,
                          which = "precision",
                          R = 500,
                          seed = 123)
print(CI_precision)

cat("\n--- Bootstrap CI for max eigenvalue ---\n")
CI_max <- eigstatCI(Y = iris[,1:4],
                    group = iris$Species,
                    which = "max",
                    R = 500,
                    seed = 123)
print(CI_max)

# ============================================================================
# Example 2: Skulls data (5 groups)
# ============================================================================

cat("\n\n=== Example 2: Skulls Data ===\n\n")

data(Skulls)
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
skulls.boxm <- boxM(skulls.mod)
print(skulls.boxm)

# Current plots without CIs
op <- par(mfrow=c(2,2), mar=c(5,4,3,1))
plot(skulls.boxm, gplabel="Epoch", which="logDet", main="logDet (with analytic CI)")
plot(skulls.boxm, gplabel="Epoch", which="product", main="product (no CI)")
plot(skulls.boxm, gplabel="Epoch", which="sum", main="sum (no CI)")
plot(skulls.boxm, gplabel="Epoch", which="max", main="max (no CI)")
par(op)

# Get bootstrap CI for sum
cat("\n--- Bootstrap CI for sum of eigenvalues (Skulls) ---\n")
CI_skulls_sum <- eigstatCI(Y = as.matrix(Skulls[, c("mb", "bh", "bl", "nh")]),
                           group = Skulls$epoch,
                           which = "sum",
                           R = 500,
                           seed = 456)
print(CI_skulls_sum)

# ============================================================================
# Example 3: Visualization with bootstrap CIs
# ============================================================================

cat("\n\n=== Example 3: Manual plot with bootstrap CIs ===\n\n")

# Recreate a plot.boxM-style visualization with bootstrap CIs
plot_with_boot_ci <- function(boxm_obj, ci_data, gplabel = NULL, main = NULL) {

  # Extract the measure from the CI data
  measure <- ci_data$statistic
  which_stat <- attr(ci_data, "which")

  ng <- nrow(ci_data) - 1  # exclude pooled

  # Set up plot
  yorder <- 1:(ng+1)
  xlim <- range(c(ci_data$lower, ci_data$upper), na.rm = TRUE)

  dotchart(measure[yorder],
           xlab = paste(which_stat, "of eigenvalues"),
           xlim = xlim,
           main = main)

  # Add bootstrap CIs as arrows
  arrows(ci_data$lower, yorder,
         ci_data$upper, yorder,
         lwd = 2, angle = 90, length = 0.075, code = 3,
         col = "gray50")

  # Add points
  pch <- c(rep(16, ng), 15)
  cex <- c(rep(2, ng), 2.5)
  col <- c(rep("blue", ng), "red")
  points(measure, yorder, cex = cex, pch = pch, col = col)

  # Add group label
  if (!is.null(gplabel)) {
    text(par("usr")[1], ng + 0.5, gplabel, pos = 4, cex = 1.25)
  }
}

# Plot with bootstrap CIs for iris data
op <- par(mfrow=c(2,2), mar=c(5,4,3,1))

plot_with_boot_ci(iris.boxm, CI_product,
                  gplabel = "Species",
                  main = "Product (bootstrap CI)")

plot_with_boot_ci(iris.boxm, CI_sum,
                  gplabel = "Species",
                  main = "Sum (bootstrap CI)")

plot_with_boot_ci(iris.boxm, CI_precision,
                  gplabel = "Species",
                  main = "Precision (bootstrap CI)")

plot_with_boot_ci(iris.boxm, CI_max,
                  gplabel = "Species",
                  main = "Max (bootstrap CI)")

par(op)

# ============================================================================
# Example 4: Compare bootstrap vs normal-approximation CIs
# ============================================================================

cat("\n\n=== Example 4: Comparing CI methods ===\n\n")

# Percentile method (default, most robust)
CI_perc <- eigstatCI(iris[,1:4], iris$Species,
                     which = "sum", R = 500, type = "perc", seed = 789)

# BCa method (bias-corrected and accelerated)
CI_bca <- eigstatCI(iris[,1:4], iris$Species,
                    which = "sum", R = 500, type = "bca", seed = 789)

# Normal approximation
CI_norm <- eigstatCI(iris[,1:4], iris$Species,
                     which = "sum", R = 500, type = "norm", seed = 789)

cat("\nPercentile method:\n")
print(CI_perc[, c("group", "statistic", "lower", "upper")])

cat("\nBCa method:\n")
print(CI_bca[, c("group", "statistic", "lower", "upper")])

cat("\nNormal approximation:\n")
print(CI_norm[, c("group", "statistic", "lower", "upper")])

# ============================================================================
# Example 5: Verify convexity property
# ============================================================================

cat("\n\n=== Example 5: Verify convexity property ===\n\n")
cat("The pooled statistic should be intermediate between group statistics\n")
cat("(This was the problem with using broom::tidy())\n\n")

for (stat_name in c("product", "sum", "precision", "max")) {
  CI <- eigstatCI(iris[,1:4], iris$Species,
                  which = stat_name, R = 500, seed = 999)

  group_vals <- CI$statistic[1:3]  # First 3 are groups
  pooled_val <- CI$statistic[4]    # Last is pooled

  is_convex <- pooled_val >= min(group_vals) && pooled_val <= max(group_vals)

  cat(glue::glue("{stat_name}: "),
      glue::glue("Groups = [{paste(round(group_vals, 2), collapse=', ')}], "),
      glue::glue("Pooled = {round(pooled_val, 2)}, "),
      glue::glue("Convex? {ifelse(is_convex, '✓ YES', '✗ NO')}"),
      "\n")
}

cat("\n=== Tests complete ===\n")
