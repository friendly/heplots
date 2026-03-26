# Quick test to verify the parallel argument fix
library(heplots)
library(boot)

# Source the fixed function
source('dev/eigstatCI.R')

# Test with iris data
cat('\n=== Testing eigstatCI with iris data ===\n\n')
CI_sum <- eigstatCI(Y = iris[,1:4],
                    group = iris$Species,
                    which = 'sum',
                    R = 100,  # Using fewer iterations for quick test
                    seed = 123)

cat('\nResults:\n')
print(CI_sum)

# Check that results are not all NA
if (all(is.na(CI_sum$statistic))) {
  cat('\n*** FAILED: All statistics are NA ***\n')
} else {
  cat('\n*** SUCCESS: Bootstrap completed successfully! ***\n')
  cat('Statistics computed:\n')
  print(CI_sum[, c("group", "statistic", "lower", "upper")])
}
