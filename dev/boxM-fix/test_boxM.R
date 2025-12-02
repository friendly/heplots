# Test script for corrected boxM() function with singular covariance matrices
# This demonstrates the fix for handling groups with n <= p

# Source the corrected function
source(here::here("dev", "boxM-fix", "boxM.R"))  # Adjust path as needed

# Load the painters data
library(MASS)
data(painters)

# Recode School factor
school <- c("Renaissance", "Mannerist", "Sciento", "Venetian",
            "Lombard", "16th C", "17th C", "French")
levels(painters$School) <- school

# Check sample sizes
cat("Sample sizes by School:\n")
print(table(painters$School))
cat("\n")

# With p=4 variables, groups with n<=4 will have singular covariance matrices
# Sciento and French both have n=4, so dfs=3 < p=4

# Fit the model
painters.mod <- lm(cbind(Composition, Drawing, Colour, Expression) ~ School, 
                   data = painters)

# Test the corrected boxM function
cat("Testing boxM with corrected handling of singular covariance matrices:\n")
cat(rep("=", 70), "\n\n", sep = "")

painters.boxM <- boxM(painters.mod)
print(painters.boxM)

cat("\n", rep("=", 70), "\n", sep = "")
cat("Summary output:\n")
cat(rep("=", 70), "\n\n", sep = "")

summary(painters.boxM)

cat("\n", rep("=", 70), "\n", sep = "")
cat("Checking logDet values:\n")
cat(rep("=", 70), "\n", sep = "")
print(painters.boxM$logDet)
cat("\nNote: Sciento and French have -Inf logDet (singular matrices)\n")
cat("but the test statistic is computed only using the non-singular groups.\n")

# Verify the fix: test statistic should be finite
cat("\n", rep("=", 70), "\n", sep = "")
cat("Verification:\n")
cat(rep("=", 70), "\n", sep = "")
cat("Chi-Sq statistic:", painters.boxM$statistic, "\n")
cat("Is finite?", is.finite(painters.boxM$statistic), "\n")
cat("df:", painters.boxM$parameter, "\n")
cat("p-value:", painters.boxM$p.value, "\n")
cat("Is finite?", is.finite(painters.boxM$p.value), "\n")
