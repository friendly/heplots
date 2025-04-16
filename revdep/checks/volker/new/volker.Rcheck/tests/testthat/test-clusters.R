#
# Test index, cluster and factor
#

library(testthat)
library(volker)
library(tibble)

# Load and recode data
data <- volker::chatgpt

test_that("clusters are added", {

  set.seed(137)
  data <- tibble(
    item1 = c(c(1:10), c(20:30)),
    item2 = c(c(1:10), c(20:30))
  )

  data <- suppressWarnings(add_clusters(data, c(item1, item2), k = NULL))

  expect_snapshot({
    cluster_tab(data, cls_item)
  })
})

