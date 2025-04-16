#
# Test index functions
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt
set.seed(137)

test_that("idx_add is deprecated", {
  expect_snapshot({
    data %>% idx_add(
        tidyselect::starts_with("cg_adoption")
      ) %>%
      tab_metrics_one_grouped(idx_cg_adoption, adopter)
  })
})

test_that("Index is calculated", {
  expect_snapshot({
    data %>%
      add_index(
        tidyselect::starts_with("cg_adoption")
      ) %>%
      tab_metrics_one_grouped(idx_cg_adoption, adopter)
  })
})

test_that("Items are reversed", {

  dist_reversed <- data %>%
    add_index(
      tidyselect::starts_with("cg_adoption_advantage"),
      newcol = "idx"
    ) %>%
    tab_metrics(idx)

  dist_unreversed <- data %>%
    add_index(
      tidyselect::starts_with("cg_adoption_advantage"),
      cols.reverse = starts_with("cg_adoption_"),
      newcol = "idx"
    ) %>%
    tab_metrics(idx)

  expect_snapshot({ dist_reversed })
  expect_snapshot({ dist_unreversed })

  dist_reversed <- as.list(tibble::deframe(dist_reversed))
  dist_unreversed <- as.list(tibble::deframe(dist_unreversed))


  expect_equal(dist_reversed$alpha, dist_unreversed$alpha)
  expect_equal(6 - as.numeric(dist_unreversed$mean), as.numeric(dist_reversed$mean))
})
