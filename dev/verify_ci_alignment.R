# Script to verify CI alignment fix
# This demonstrates that CIs now properly align with their data points

library(heplots)
library(boot)

# Source the fixed functions
source('dev/eigstatCI.R')
source('dev/plot.boxM_with_bootstrap.R')

# Iris data
iris.boxm <- boxM(iris[, 1:4], iris[, "Species"])

cat("\n=== Testing CI Alignment with plot_boxM_boot() ===\n\n")

# Create plots for different statistics
par(mfrow = c(2, 2), mar = c(5, 4, 3, 1))

# Product
cat("Computing bootstrap CIs for product...\n")
plot_boxM_boot(iris.boxm,
               Y = iris[, 1:4],
               group = iris$Species,
               which = "product",
               gplabel = "Species",
               main = "Product (bootstrap CI)",
               boot.R = 200,
               boot.seed = 123)

# Sum
cat("Computing bootstrap CIs for sum...\n")
plot_boxM_boot(iris.boxm,
               Y = iris[, 1:4],
               group = iris$Species,
               which = "sum",
               gplabel = "Species",
               main = "Sum (bootstrap CI)",
               boot.R = 200,
               boot.seed = 123)

# Precision
cat("Computing bootstrap CIs for precision...\n")
plot_boxM_boot(iris.boxm,
               Y = iris[, 1:4],
               group = iris$Species,
               which = "precision",
               gplabel = "Species",
               main = "Precision (bootstrap CI)",
               boot.R = 200,
               boot.seed = 123)

# Max
cat("Computing bootstrap CIs for max...\n")
plot_boxM_boot(iris.boxm,
               Y = iris[, 1:4],
               group = iris$Species,
               which = "max",
               gplabel = "Species",
               main = "Max (bootstrap CI)",
               boot.R = 200,
               boot.seed = 123)

cat("\n*** Verify that: ***\n")
cat("  1. Y-axis shows group labels (setosa, versicolor, virginica, pooled)\n")
cat("  2. Confidence intervals are centered on data points (blue dots & red square)\n")
cat("  3. Red square (pooled) has its CI properly aligned with it\n")
cat("  4. No CIs are 'floating' above or below their corresponding data points\n")

par(mfrow = c(1, 1))
