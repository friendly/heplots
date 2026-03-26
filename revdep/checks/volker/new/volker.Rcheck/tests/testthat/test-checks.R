#
# Test check functions and error messages
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt

test_that("check_is_dataframe", {

  # Test with valid data frame
  expect_true(check_is_dataframe(data))

  # Define non-valid data frames
  non_df <- list(
    list(a = 1, b = 2),
    c(1, 2, 3),
    matrix(1:9, nrow = 3),
    42,
    "not a dataframe",
    data.frame(),
    factor(c("a", "b", "c"))
  )

  # Test each non_df object
  for (obj in non_df) {
    expect_error(check_is_dataframe(obj, stopit = TRUE))
  }

  # Test for stopit = FALSE
  for (obj in non_df) {
    expect_no_error(check_is_dataframe(obj, stopit = FALSE))
  }

  # Test error messages

  # Test with a non-data frame (factor)
  expect_error(check_is_dataframe(data$case),"Check your params: Did you provide a data frame?")

  # Test with an empty data frame
  expect_error(check_is_dataframe(data.frame()), "Check your data: Are they empty?")

})

# Check has column
test_that("check_has_column", {

  expect_no_error(check_has_column(data, sd_age))

  expect_error(check_has_column(data), "Did you miss to say which column to use?")

  expect_error(check_has_column(data, novalidcolumn), "The column selection is not valid, check your parameters.")

})

# Check check_is_param method
test_that("Parameter checks work as expected", {

  expect_equal(check_is_param("n", c("n", "p"), stopit = FALSE), c("n"))

  expect_false(check_is_param(NULL, c("n", "p"), stopit = FALSE))

  expect_true(check_is_param(NULL, c("n", "p"), allownull = TRUE, stopit = FALSE))

  expect_false(check_is_param(c("n", "p"), c("n", "p"), stopit = FALSE))

  expect_equal(check_is_param(c("n", "p"), c("n", "p"), allowmultiple = TRUE, stopit = FALSE), c("n", "p"))

  expect_false(check_is_param(c("n", "x"), c("n", "p"), allowmultiple = TRUE, stopit = FALSE))

  expect_error(check_is_param(NULL, c("n", "p"), stopit = TRUE), "cannot be NULL.")

  expect_error(check_is_param("x", c("n", "p"), stopit = TRUE), "not supported")

  expect_error(check_is_param(c("n", "p"), c("n", "p"), allowmultiple = FALSE, stopit = TRUE), "Only a single value is allowed")

})


# Check parameter expansion
test_that("Parameters are expanded", {

  expect_error(check_is_param("class", c("reliability", "classification"), stopit = TRUE))
  expect_error(check_is_param("club", c("reliability", "classification"), expand = TRUE, stopit = TRUE))

  expect_equal(check_is_param("class", c("reliability", "classification"), expand = TRUE, stopit = FALSE), c("classification"))
  expect_equal(check_is_param(c("rel", "cl"), c("reliability", "classification"), allowmultiple = TRUE, expand = TRUE, stopit = FALSE), c("reliability", "classification"))


})


