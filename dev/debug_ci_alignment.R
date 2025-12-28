# Debug script to diagnose CI alignment issue
library(heplots)
library(boot)

source('dev/eigstatCI.R')
source('dev/plot.boxM_with_bootstrap.R')

# Create boxM object
iris.boxm <- boxM(iris[, 1:4], iris[, "Species"])

# Get the eigstats from summary
eigstats <- summary(iris.boxm, quiet = TRUE)$eigstats

cat("\n=== Eigstats from boxM summary ===\n")
print(eigstats)
cat("\nColumn names:", colnames(eigstats), "\n")
cat("Product values:", eigstats["product", ], "\n")

# Compute bootstrap CIs
cat("\n=== Computing bootstrap CIs ===\n")
CI_product <- eigstatCI(Y = iris[, 1:4],
                        group = iris$Species,
                        which = "product",
                        R = 100,
                        seed = 123)

cat("\n=== Bootstrap CI dataframe ===\n")
print(CI_product)

# Now simulate what happens in plot_boxM_boot
cat("\n=== Simulating plot_boxM_boot logic ===\n")

which <- "product"
log <- TRUE

# Get measure (this is what plot does)
measure <- eigstats[which, ]
if (log) measure <- log(measure)

cat("\nMeasure (from eigstats):\n")
print(data.frame(
  index = 1:length(measure),
  name = names(measure),
  value = measure
))

# Get CI (this is what plot does)
CI <- CI_product
if (log) {
  CI$statistic <- log(CI$statistic)
  CI$lower <- log(CI$lower)
  CI$upper <- log(CI$upper)
}

cat("\nCI (from bootstrap):\n")
print(data.frame(
  index = 1:nrow(CI),
  group = CI$group,
  statistic = CI$statistic,
  lower = CI$lower,
  upper = CI$upper
))

# Check alignment
cat("\n=== Alignment Check ===\n")
cat("measure names:", names(measure), "\n")
cat("CI$group:", CI$group, "\n")
cat("\nDo they match?", identical(names(measure), CI$group), "\n")

# Create yorder
ng <- length(measure) - 1
yorder <- 1:(ng + 1)

cat("\nyorder:", yorder, "\n")
cat("\nmeasure[yorder]:", measure[yorder], "\n")
cat("CI$statistic[yorder]:", CI$statistic[yorder], "\n")
cat("\nAre measure and CI$statistic in same order?\n")
print(data.frame(
  position = yorder,
  measure_name = names(measure)[yorder],
  measure_val = measure[yorder],
  CI_group = CI$group[yorder],
  CI_stat = CI$statistic[yorder],
  match = abs(measure[yorder] - CI$statistic[yorder]) < 0.001
))
