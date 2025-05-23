#
# Test index, cluster and factor
#

library(testthat)
library(volker)


test_that("pca results are reproducable", {

  data <- volker::chatgpt
  set.seed(137)

  expect_snapshot({
    data %>% add_factors(
      tidyselect::starts_with("cg_adoption"), k = 3) %>%
      factor_tab(starts_with("fct_cg_adoption"))
  })
})
