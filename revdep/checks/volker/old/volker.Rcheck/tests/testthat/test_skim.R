#
# Skim tests
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt

test_that("skim_metrics",{
         skim_metrics(data)
         expect_snapshot(data, cran = TRUE)
})

test_that("five-point-summary", {
  expect_snapshot({
    list(
      iqr_age = .iqr(data$sd_age),
      whisker_lower = .whisker_lower(data$sd_age),
      whisker_upper = .whisker_upper(data$sd_age),
      outliers = .outliers(data$sd_age)
    )
  })
})
