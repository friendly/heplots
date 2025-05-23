#
# Test labeling functions
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt

# Data_prepare
test_data <- tibble::tibble(
  var1 = c(1, 2, -1, 5),
  var2 = c(-2, -3, -3, -9)
)

attr(test_data$var1, "-1") <- "LABELED RESIDUAL VALUE"
attr(test_data$var2, "-3") <- "NOT A RESIDUAL VALUE" # NOT in VLKR_NA_NUMBERS, should not be removed
#attr(test_data$var2, "-9") <- "UNLABELED RESIDUAL VALUE" # In VLKR_NA_NUMBERS but not in attributes, should be removed

# Keep residuals
test_that("No values are recoded to missings", {
  prepared_data <- data_prepare(test_data, var1, var2, clean = FALSE)
  expect_snapshot(prepared_data, cran = TRUE)

  expect_true(is.null(attr(prepared_data, "missings")))

})

# Recode residuals
test_that("Residual values are recoded to missings", {
  prepared_data <- data_prepare(test_data, var1, var2, clean = TRUE)
  expect_snapshot(prepared_data, cran = TRUE)

  expect_true(!is.null(attr(prepared_data, "missings")))

})

# Remove residual negative values
test_that("Residual negative values are removed", {

  tibble::tibble(var1 = c(1, 2, -1, -9, -50, -999)) |>
    data_clean() |>
    expect_snapshot(cran = TRUE)

})

# Remove residual negative values from data in SPPS format
test_that("Residual negative values are removed from data in SPSS format", {

  spss_data <- tibble::tibble(var1 = c(1, 2, -50, -999))
  attr(spss_data$var1, "label") <- "Country"
  attr(spss_data$var1, "format.spss") <- "F3.0"
  attr(spss_data$var1, "labels") <- c(`Refused` = -999, `Missing value` = -555)

  spss_data |>
    data_clean(remove.na.numbers = c(-999, -555)) |>
    expect_snapshot(cran = TRUE)

})

# Remove all negative values
test_that("All negatives are removed", {

  tibble::tibble(var1 = c(1,2,-1,-9)) |>
    data_rm_negatives(var1) |>
    expect_snapshot(cran = TRUE)
})


# Keep negative values
test_that("Negatives are kept", {
  options("vlkr.na.numbers"=FALSE)
  tibble::tibble(var1 = c(1,2,-9)) |>
    data_clean() |>
    expect_snapshot(cran = TRUE)
  options("vlkr.na.numbers"= VLKR_NA_NUMBERS)
})

# Remove NA levels
test_that("NA levels are kept", {
  options("vlkr.na.levels" = FALSE)
  tibble::tibble(value1 = factor(c("A", "B", "[no answer]"))) |>
    data_rm_na_levels() |>
    expect_snapshot(cran = TRUE)
  options(vlkr.na.levels = VLKR_NA_LEVELS)
})


# Get baseline
test_that("Baseline is extracted", {
  result <- volker::tab_counts(data,
    tidyselect::starts_with("cg_adoption_"), sd_gender,
    category = c("agree", "strongly agree")
 )
  get_baseline(result) |>
    expect_snapshot(cran = TRUE)

})

test_that("Baseline for zeros", {
  data <- tibble::tibble(
    id = 1:4,
    value1 = c(0, 2, 0, 4),
    value2 = c(1, 0, 3, 4)
  )
  result <- plot_metrics(data, value1, value2, metric= TRUE, log = TRUE)
  get_baseline(result) |>
    expect_snapshot(cran = TRUE)
})

test_that("Baseline for negatives", {
  data <- tibble::tibble(var1 = c(1,2,-1,-9)) |>
    data_rm_negatives(var1)

 result <- volker::tab_metrics(data, var1)
 get_baseline(result) |>
   expect_snapshot(cran = TRUE)

})

test_that("Zero removal", {

  # Zeros are removed
  zeros <- tibble(
    id = 1:6,
    value1 = c(0, 2, 0, 4, 5, 0),
    value2 = c(1, 0, 3, 4, 2, 6)
  )

  # Apply the function to test data
  result <- data_rm_zeros(zeros, cols = c(value1, value2))

  # Test if rows with zeros are removed correctly
  expect_equal(nrow(result), 2)

  expect_true(!is.null(attr(result, "missings")))
  expect_true(!is.null(attr(result, "missings")$zero))

  zero_info <- attr(result, "missings")$zero
  expect_equal(zero_info$n, 4)
  expect_equal(zero_info$cols, "c(value1, value2)")
})


