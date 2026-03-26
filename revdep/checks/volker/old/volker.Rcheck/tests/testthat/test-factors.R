#
# Test factor calculations
#

test_that("PCA results are reproducable", {

  data <- volker::chatgpt
  set.seed(137)

  expect_snapshot({
    data %>% add_factors(
      tidyselect::starts_with("cg_adoption"), k = 3) %>%
      factor_tab(starts_with("fct_cg_adoption"))
  })
})


test_that("Calculation with missings", {

  options(vlkr.na.omit=FALSE)

  data <- volker::chatgpt
  set.seed(137)

  expect_snapshot({
    data %>% add_factors(
      tidyselect::starts_with("cg_adoption"), k = 3) %>%
      factor_tab(starts_with("fct_cg_adoption"))
  })

  options(vlkr.na.omit=TRUE)
})
