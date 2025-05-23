#
# Test utils
#

library(testthat)
library(volker)

# Data frames for testing
df1 <- data.frame(
  A = c(1, 2, 3),
  B = c("x", "y", "z"),
  C = c("apple", "banana", "cherry")
)

df2 <- data.frame(
  A = c(4, 5, 6),
  B = c("u", "v", "w"),
  C = c("orange", "grape", "melon")
)

test_that("combines data frames correctly with space and no brackets", {
  volker:::zip_tables(df1, df2, newline = TRUE, brackets = FALSE) %>%
  expect_snapshot(cran = T)

})

test_that("combines data frames correctly with space and no brackets", {
  volker:::zip_tables(df1, df2, newline = TRUE, brackets = TRUE) %>%
  expect_snapshot(cran = T)

})
