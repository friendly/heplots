# Test to verify pooled CI alignment fix
library(heplots)
library(boot)

source('dev/eigstatCI.R')
source('dev/plot.boxM_with_bootstrap.R')

cat("\n=== Testing Pooled CI Alignment Fix ===\n\n")

# Create boxM object
iris.boxm <- boxM(iris[, 1:4], iris[, "Species"])

# Create a single plot to check alignment
cat("Creating test plot for 'sum' statistic...\n")
plot_boxM_boot(iris.boxm,
               Y = iris[, 1:4],
               group = iris$Species,
               which = "sum",
               gplabel = "Species",
               main = "Sum (bootstrap CI) - Pooled Alignment Test",
               boot.R = 100,
               boot.seed = 123)

cat("\n*** Verification Instructions: ***\n")
cat("  1. The red square (pooled) should have its CI centered on it\n")
cat("  2. All blue circles should have their CIs centered on them\n")
cat("  3. No CIs should be 'floating' away from their data points\n")
cat("  4. Y-axis should show: setosa, versicolor, virginica, pooled\n\n")

# Also create the 4-panel comparison
cat("\nCreating 4-panel comparison plot...\n")
par(mfrow = c(2, 2), mar = c(5, 4, 3, 1))

for (stat in c("product", "sum", "precision", "max")) {
  plot_boxM_boot(iris.boxm,
                 Y = iris[, 1:4],
                 group = iris$Species,
                 which = stat,
                 gplabel = "Species",
                 main = paste(stat, "(bootstrap CI)"),
                 boot.R = 100,
                 boot.seed = 123)
}

par(mfrow = c(1, 1))

cat("\n=== Test Complete ===\n")
cat("If all CIs are properly aligned with their points, the fix is successful!\n")
