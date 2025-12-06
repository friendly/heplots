#
# Test table appearance
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt

# Frequency table
# tab_counts_one
test_that("Frequency table", {
  expect_snapshot(volker::tab_counts(data, sd_gender), cran = TRUE)
})


# Cross table of categorical variables
# tab_counts_one_grouped
test_that("Cross table of categorical variables", {
  expect_snapshot(volker::tab_counts(data, adopter, sd_gender), cran = TRUE)
})

# Cross table of categorical variables with cols
# tab_counts_one_grouped
test_that("Cross table of categorical variables with cols", {
  expect_snapshot(volker::tab_counts(
      data,
      adopter,
      sd_gender,
      prop = "cols"
    ),
    cran = TRUE
  )
})

# Cross table of categorical variables with p
# tab_counts_one_grouped
test_that("Cross table of categorical variables with percent", {
  expect_snapshot(volker::tab_counts(
      data,
      adopter,
      sd_gender,
      values = "p"
    ),
    cran = TRUE
  )
})

# Cross table of categorical variables with counts
# tab_counts_one_grouped
test_that("Cross table of categorical variables with counts", {
  expect_snapshot(volker::tab_counts(
      data,
      adopter,
      sd_gender,
      values = "n"
    ),
    cran = TRUE
  )
})

# Frequency table for multiple categorical variables
# tab_counts_items
test_that("Frequency table for multiple categorical variables", {
  expect_snapshot(
    volker::tab_counts(data, tidyselect::starts_with("cg_adoption_")),
    cran = TRUE
  )
})

# Frequency table for multiple categorical variables
# tab_counts_items
test_that("Frequency table for multiple categorical variables with percent", {
  expect_snapshot(
    volker::tab_counts(
      data,
      tidyselect::starts_with("cg_adoption_"),
      values = "p"
    ),
    cran = TRUE
  )
})

# Frequency table for multiple categorical variables
# tab_counts_items
test_that("Frequency table for multiple categorical variables with counts", {
  expect_snapshot(
    volker::tab_counts(
      data,
      tidyselect::starts_with("cg_adoption_"),
      values = "n"
    ),
    cran = TRUE
  )
})

# Frequency table for multiple categorical variables grouped
# tab_counts_items_grouped
test_that("Frequency table for multiple categorical variables by grouping variable", {
  expect_snapshot(
    volker::tab_counts(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_gender,
      category = c("agree", "strongly agree")
    ),
    cran = TRUE
  )

  expect_error(
    volker::tab_counts(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_gender,
      category = c("agree", "strongly")
    ),
    "One or more specified categories do not exist in the data."
  )
})

# Frequency table for multiple categorical variables grouped
# tab_counts_items_grouped
test_that("Frequency table for multiple categorical variables by binary grouping variable", {

  data <- data |>
    dplyr::mutate(dplyr::across(starts_with("cg_adoption_advantage"), \(x) x > 3))

  expect_snapshot(
    volker::tab_counts(
      data,
      tidyselect::starts_with("cg_adoption_advantage"),
      sd_gender
    ),
    cran = TRUE
  )
})

# Distribution table for age
# tab_metrics_one
test_that("Distribution table for age", {
  expect_snapshot(volker::tab_metrics(data, sd_age), cran = TRUE)
})

# tab_metrics_one
test_that("Distribution table for age with ci", {
  expect_snapshot(volker::tab_metrics(data, sd_age, ci = TRUE), cran = TRUE)
})

# Group comparison of a metric variable
# tab_metrics_one_grouped
test_that("Group comparison of a metric variable", {
  expect_snapshot(volker::tab_metrics(data, sd_age, sd_gender), cran = TRUE)
})

# Correlations of two variables
# tab_metrics_one_cor
test_that("Correlations with two variables", {
  expect_snapshot(
    volker::tab_metrics(
      data, use_work, use_private,
      metric=TRUE
    ),
    cran = TRUE
  )
})

test_that("Correlations with two variables with no common prefix", {
  expect_snapshot(
    volker::tab_metrics(
      data, sd_age, use_private,
      metric=TRUE), cran = TRUE)
})

# Correlations of two variables
# tab_metrics_one_cor
test_that("Correlation with two variables and ci", {
  expect_snapshot(
    volker::tab_metrics(
      data, use_work, use_private,
      metric=TRUE,
      ci = TRUE
    ),
    cran = TRUE
  )
})

# tab_metrics_one_cor
test_that("Correlation with two variables and spearman", {
  expect_snapshot(
    volker::tab_metrics(
      data, use_work, use_private,
      metric=TRUE,
      method = "spearman"
    ),
    cran = TRUE
  )
})


# Distribution table for multiple metric items
# tab_metrics_items
test_that("Distribution table for multiple metric items", {
  expect_snapshot(
    volker::tab_metrics(
      data, tidyselect::starts_with("cg_adoption_")
    ),
    cran = TRUE
  )
})

test_that("Distribution table for multiple metric items with ci", {
  expect_snapshot(
    volker::tab_metrics(
      data, tidyselect::starts_with("cg_adoption_"),
      ci = TRUE
    ),
    cran = TRUE
  )
})

# Compare means of multiple items
# tab_metrics_items_grouped
test_that("Compare means of multiple items with and without common prefix", {
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_gender
    ),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics(
      data,
      c("sd_age", "use_work"),
      sd_gender
    ),
    cran = TRUE
  )
})


# Compare means of multiple items
# tab_metrics_items_grouped
test_that("Compare means of multiple items with sd or mean", {
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_gender,
      values = "sd"
    ),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_gender,
      values = "m"
    ),
    cran = TRUE
  )
})


# Correlations of an item battery with one variable
# tab_metrics_items_cor
test_that("Correlations of an item battery with one variable", {
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_age, metric=TRUE
    ),
    cran = TRUE
  )
})

# Correlations of an item battery with one variable and spearman
# tab_metrics_items_cor
test_that("Correlations of an item battery with one variable and spearman", {
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      sd_age, metric=TRUE, method = "spearman"
    ),
    cran = TRUE
  )
})

# Correlations of two item batteries
# tab_metrics_items_cor_items
test_that("Correlate two item batteries", {
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"),
      metric=TRUE
    ),
    cran = TRUE
  )

  # shared prefix
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("cg_adoption_"),
      metric=TRUE
    ),
    cran = TRUE
  )
})


# Correlations of two item batteries with ci
# tab_metrics_items_cor_items
test_that("Correlate two item batteries with ci", {
  expect_snapshot(
    volker::tab_metrics(
      data, starts_with("cg_adoption_adv"),
      starts_with("use_"),
      metric = TRUE, ci = T
    ),
    cran = TRUE
  )
})

# Correlations of two item batteries and spearman
# tab_metrics_items_cor_items
test_that("Correlate two item batteries with spearman", {
  expect_snapshot(
    volker::tab_metrics(
      data,
      tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"),
      metric=TRUE, method = "spearman",
    ),
    cran = TRUE
  )
})


# ...with missings
test_that("Missing values make no trouble", {
  data <- volker::chatgpt
  data %>%
#    volker::labs_store() |>
    dplyr::bind_rows(tibble::tibble(sd_gender = c("X", "X", "X"))) %>%
#    volker::labs_restore() |>
    volker::tab_metrics_items_grouped(
      tidyselect::starts_with("cg_adoption_"), sd_gender) %>%
    expect_snapshot(cran = TRUE)
})

# Item order reflects column order
test_that("Item order is kept", {
  expect_snapshot(

    tibble::tribble(
      ~f1, ~f2, ~f10,
      1,     1,    1,
      1,     2,    1,
      2,     2,    2
    ) |>
      tab_counts_items(c(f1:f10)),

    cran = TRUE
  )
})


# Apply value labels
test_that("Values are relabeled", {
  expect_snapshot(

    data %>%
      dplyr::filter(sd_gender != "diverse") %>%
      volker::labs_apply(
        cols = sd_gender,
        values = list(
          "female" = "Weiblich",
          "male" = "Maennlich"
        )
      ) %>%
      volker::tab_metrics(sd_age, sd_gender),

    cran = TRUE
  )
})


test_that("Missing values are skipped in item batteries", {
  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tribble(
    ~f1, ~f2, ~f3,
    1,     NA,    1,
    2,     2,    NA,
    3,     3,    NA,
    4,     4,    4
  )

  expect_snapshot(
    volker::tab_counts(data_with_missings, starts_with("f")),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics(data_with_missings, starts_with("f")),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})

test_that("Missing values are skipped in single variables", {
  options(vlkr.na.omit=FALSE)

  data_with_missings <-  tibble::tribble(
    ~f1, ~f2, ~f3,
    1,     NA,    1,
    2,     2,    NA,
    3,     3,    NA
  )

  expect_snapshot(
    volker::tab_counts(data_with_missings, f2),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics(data_with_missings, f2),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})


test_that("Missing values are skipped in item comparisons", {

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
    volker::tab_counts(data_with_missings, starts_with("f"), gr),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics(data_with_missings, starts_with("f"), gr),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})

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
    volker::tab_counts(data_with_missings, f2, gr),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics(data_with_missings, f2, gr),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})


test_that("Missing values are skipped in single variable correlations", {

  options(vlkr.na.omit=FALSE)

  data_with_missings <- tibble::tribble(
    ~f1, ~f2, ~f3,  ~gr,
    1,     NA,    1, 1,
    2,     2,    NA, 2,
    3,     3,    NA, 3,
    4,     4,     4, 4,
    5,     5,     5, NA
  )

  expect_snapshot(
    volker::tab_counts(data_with_missings, f2, gr, metric = TRUE),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics_one_cor(data_with_missings, f2, gr, metric = TRUE),
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

  expect_snapshot(
    volker::tab_counts(data_with_missings, starts_with("f"), gr, metric = TRUE),
    cran = TRUE
  )

  expect_snapshot(
    volker::tab_metrics_one_cor(data_with_missings, starts_with("f"), gr, metric = TRUE),
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

  # TODO: implement tab_counts_items_cor_items
  #expect_snapshot(
  #  volker::tab_counts(data_with_missings, starts_with("f"), starts_with("g"), metric = TRUE),
  #  cran = TRUE
  #)

  expect_snapshot(
    volker::tab_metrics(data_with_missings, starts_with("f"), starts_with("g"), metric = TRUE),
    cran = TRUE
  )

  options(vlkr.na.omit=TRUE)
})
