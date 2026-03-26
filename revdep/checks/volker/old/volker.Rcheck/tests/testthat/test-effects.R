#
# Test effect calculations
#

options(vlkr.na.omit=TRUE)

# Categorical
test_that("effect_counts_one", {

  data <- volker::chatgpt

  expect_snapshot(
    data |>
      dplyr::filter(sd_gender != "diverse") |>
      volker::effect_counts(sd_gender),
    cran = TRUE
  )

})

test_that("effect_counts_one_grouped", {

  data <- volker::chatgpt

  expect_snapshot(
    data |>
      dplyr::filter(sd_gender != "diverse") |>
      dplyr::mutate(sd_age_group = ifelse(sd_age > 40,"40+","< 40")) |>
      volker::effect_counts(sd_gender, sd_age_group),
    cran = TRUE
  )

})

test_that("effect_counts_items", {

  data <- volker::chatgpt

  expect_snapshot(
    data |>
      volker::effect_counts(starts_with("cg_adoption_advantage")),
    cran = TRUE
  )

})

test_that("effect_counts_items_grouped", {
  set.seed(123)
  data <- volker::chatgpt

  expect_snapshot(
    data |>
      volker::effect_counts(starts_with("cg_adoption_advantage"), sd_gender),
    cran = TRUE
  )

})

test_that("effect_counts_items_grouped_items", {
  set.seed(123)
  data <- volker::chatgpt

  expect_snapshot(
    data |>
      volker::effect_counts(starts_with("cg_adoption_adv"), starts_with("use_")),
    cran = TRUE
  )
})


# Metric

test_that("effect_metrics_one", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, sd_age), cran = TRUE)
})

test_that("effect_metrics_one_grouped", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, sd_age, adopter), cran = TRUE)
})

test_that("effect_metrics_one_grouped with t.test", {
  data <- volker::chatgpt
  data <- data |>
    filter(sd_gender != "diverse")

  expect_snapshot(volker::effect_metrics(data, sd_age, sd_gender, method = "t.test"), cran = TRUE)
})

test_that("effect_metrics_one_cor", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, sd_age, use_private, metric=TRUE), cran = TRUE)
})

test_that("effect_metrics_one_cor with pearson", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, sd_age, use_private, metric=TRUE, method="pearson"), cran = TRUE)
})


test_that("effect_metrics_one_cor with spearman", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, sd_age, use_private, metric=TRUE, method="spearman"), cran = TRUE)
})

test_that("effect_metrics_items", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, tidyselect::starts_with("use_")), cran = TRUE)
})

test_that("effect_metrics_items_cor with one variable", {
  data <- volker::chatgpt
  expect_snapshot(volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"), sd_age, metric=TRUE), cran = TRUE)
})

test_that("effect_metrics_items_cor with one variable and spearman", {
  data <- volker::chatgpt
  expect_snapshot(
    volker::effect_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_age,metric=TRUE,
      method = "spearman"
    ),
    cran = TRUE)
})

test_that("effect_metrics_items_cor with items", {
  data <- volker::chatgpt
  expect_snapshot(
    volker::effect_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("cg_adoption_"),
      metric=TRUE
    ), cran = TRUE
  )
})

test_that("effect_metrics_items_cor_items with two batteries", {
  data <- volker::chatgpt
  expect_snapshot(
    volker::effect_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"),
      metric=TRUE
    ), cran = TRUE
  )
})

test_that("effect_metrics_items_cor_items with spearman", {
  data <- volker::chatgpt
  expect_snapshot(
    volker::effect_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"),
      metric=TRUE,
      method= "spearman"
    ), cran = TRUE
  )
})

test_that("Missing values are skipped in item batteries", {
  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tibble(
    f1 = factor(rep(c(1, 2, 3, NA), each = 5)),
    f2 = factor(rep(c(4, 5, 6, NA), each = 5)),
    f3 = factor(rep(c(7, 8, 9, 10), each = 5))
  )

  expect_snapshot(
    volker::effect_counts(data_with_missings, starts_with("f")),
    cran = TRUE
  )

  expect_snapshot(
    volker::effect_metrics(data_with_missings, starts_with("f")),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})

test_that("Missing values are skipped in single variables", {
  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tibble(
    f1 = factor(rep(c(1,2,3,NA), each = 5))
  )

  expect_snapshot(
    volker::effect_counts(data_with_missings, f1),
    cran = TRUE
  )

  expect_snapshot(
    volker::effect_metrics(data_with_missings, f1),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})

# test_that("Cramer's V and Chi-square-test for each item with missings", {
#
#   options(vlkr.na.omit=FALSE)
#
#   data_with_missings <- tibble::tribble(
#     ~f1, ~f2, ~f3,  ~gr,
#     1,     NA,    1, "A",
#     2,     2,    NA, "B",
#     3,     3,    NA, "A",
#     4,     4,     4, "A",
#     5,     5,     5, NA
#   )
#
#   # TODO: Check effect_counts_items_grouped
#   # expect_snapshot(
#   #   volker::effect_counts(data_with_missings, starts_with("f"), gr),
#   #   cran = TRUE
#   # )
#
#   expect_snapshot(
#     volker::effect_metrics(data_with_missings, starts_with("f"), gr),
#     cran = TRUE
#   )
#
#   options(vlkr.na.omit=TRUE)
# })


test_that("Missing values are skipped in single variable comparisons", {

  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tribble(
    ~f1, ~f2, ~f3,  ~gr,
    1,     NA,    1, "A",
    2,     2,    NA, "B",
    3,     3,    NA, "A",
    4,     4,     4, "A",
    5,     5,     5, NA
  )

  expect_snapshot(
    suppressWarnings(volker::effect_counts(data_with_missings, f2, gr)),
    cran = TRUE
  )

  expect_snapshot(
    volker::effect_metrics(data_with_missings, f2, gr),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})

test_that("Missing values are skipped in single variable correlations", {

  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tibble(
    f1 = c(1:20),
    f2 = c(1:18, NA, NA)
  )

  # TODO: implement effect_counts_one_cor
  # expect_snapshot(
  #   volker::effect_counts(data_with_missings, f2, gr, metric = TRUE),
  #   cran = TRUE
  # )

  expect_snapshot(
    volker::effect_metrics(data_with_missings, f1,f2, metric = TRUE),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})


test_that("Missing values are skipped in item correlations with another variable", {

  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tribble(
    ~f1, ~f2, ~f3,  ~gr,
    1,     NA,    1, 1,
    2,     2,    NA, 2,
    3,     3,    NA, 3,
    4,     4,     4, 4,
    5,     5,     5, NA,
    6,     6,     6, 6
  )

  # TODO: implement
  # expect_snapshot(
  #   volker::effect_counts(data_with_missings, starts_with("f"), gr, metric = TRUE),
  #   cran = TRUE
  # )

  expect_snapshot(
    volker::effect_metrics(data_with_missings, starts_with("f"), gr, metric = TRUE),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})


test_that("Missing values are skipped in item correlations with items", {

  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tribble(
    ~f1, ~f2, ~g1,  ~g2,
    1,     NA,    1, 1,
    2,     2,    NA, 2,
    3,     3,    NA, 3,
    4,     4,     4, 4,
    5,     5,     5, NA,
    6,     6,     6, 6
  )

  # TODO: implement effect_counts_items_cor_items
  #expect_snapshot(
  #  volker::tab_counts(data_with_missings, starts_with("f"), starts_with("g"), metric = TRUE),
  #  cran = TRUE
  #)

  expect_snapshot(
    volker::effect_metrics(data_with_missings, starts_with("f"), starts_with("g"), metric = TRUE),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})
