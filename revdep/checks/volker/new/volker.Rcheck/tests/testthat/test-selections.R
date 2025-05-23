#
# Test column selections
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt
data <- volker::data_clean(data)

# Single column
test_that("Single column selections work", {
  expect_no_error(
    volker::plot_metrics(data, use_private)
  )
  expect_no_error(
    volker::tab_metrics(data, use_private)
  )
  expect_no_error(
    volker::plot_counts(data, use_private)
  )
  expect_no_error(
    volker::tab_counts(data, use_private)
  )
})

# Single column in multicolumn functions
test_that("Single column selections work", {
  expect_no_error(
    volker::plot_metrics_items(data, use_private)
  )
  expect_no_error(
    volker::tab_metrics_items(data, use_private)
  )
  expect_no_error(
    volker::plot_counts_items(data, use_private)
  )
  expect_no_error(
    volker::tab_counts_items(data, use_private)
  )
})


# Multiple columns
test_that("List column selections work", {
  expect_no_error(
    volker::plot_metrics(data, c(use_private, use_work))
  )
  expect_no_error(
    volker::tab_metrics(data, c(use_private, use_work))
  )
  expect_no_error(
    volker::plot_counts(data, c(use_private, use_work))
  )
  expect_no_error(
    volker::tab_counts(data, c(use_private, use_work))
  )
})

# Multiple columns using starts_with()
test_that("Starts with column selections work", {
  expect_no_error(
    volker::plot_metrics(data, tidyselect::starts_with("use_"))
  )
  expect_no_error(
    volker::tab_metrics(data, tidyselect::starts_with("use_"))
  )
  expect_no_error(
    volker::plot_counts(data, tidyselect::starts_with("use_"))
  )
  expect_no_error(
    volker::tab_counts(data, tidyselect::starts_with("use_"))
  )
})

