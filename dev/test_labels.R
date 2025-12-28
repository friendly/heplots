# Quick test to verify y-axis labels appear correctly
library(heplots)
library(boot)

# Source the fixed function
source('dev/eigstatCI.R')

# Test with iris data
cat('\n=== Testing plot labels with iris data ===\n\n')

# Compute bootstrap CIs
CI_sum <- eigstatCI(Y = iris[,1:4],
                    group = iris$Species,
                    which = 'sum',
                    R = 100,
                    seed = 123)

cat('CI data structure:\n')
print(CI_sum)

# Test the plot_with_boot_ci function
cat('\n\nCreating test plot...\n')

# Define the helper function from test_eigstatCI.R
plot_with_boot_ci <- function(boxm_obj, ci_data, gplabel = NULL, main = NULL) {

  # Extract the measure from the CI data
  measure <- ci_data$statistic
  which_stat <- attr(ci_data, "which")

  ng <- nrow(ci_data) - 1  # exclude pooled

  # Set up plot
  yorder <- 1:(ng+1)
  xlim <- range(c(ci_data$lower, ci_data$upper), na.rm = TRUE)

  dotchart(measure[yorder],
           labels = ci_data$group[yorder],
           xlab = paste(which_stat, "of eigenvalues"),
           xlim = xlim,
           main = main)

  # Add bootstrap CIs as arrows
  arrows(ci_data$lower[yorder], yorder,
         ci_data$upper[yorder], yorder,
         lwd = 2, angle = 90, length = 0.075, code = 3,
         col = "gray50")

  # Add points
  pch <- c(rep(16, ng), 15)
  cex <- c(rep(2, ng), 2.5)
  col <- c(rep("blue", ng), "red")
  points(measure[yorder], yorder, cex = cex, pch = pch, col = col)

  # Add group label
  if (!is.null(gplabel)) {
    text(par("usr")[1], ng + 0.5, gplabel, pos = 4, cex = 1.25)
  }
}

# Create the plot
iris.boxm <- boxM(iris[, 1:4], iris[, "Species"])
plot_with_boot_ci(iris.boxm, CI_sum,
                  gplabel = "Species",
                  main = "Sum (bootstrap CI) - Test Labels")

cat('\n*** Check the plot: ***\n')
cat('  - Y-axis should show: setosa, versicolor, virginica, pooled\n')
cat('  - Confidence intervals should be centered on the data points\n')
cat('  - Red square (pooled) CI should align with the red square position\n')

# Print some diagnostics
cat('\n=== Diagnostic Information ===\n')
cat('Data values (in plot order):\n')
print(data.frame(
  position = 1:4,
  group = CI_sum$group,
  statistic = round(CI_sum$statistic, 3),
  lower = round(CI_sum$lower, 3),
  upper = round(CI_sum$upper, 3)
))
