#
# Test labeling functions
#

library(testthat)
library(volker)

# Load and recode data
data <- volker::chatgpt
data <- volker::data_clean(data)

# Get labels
test_that("Labels are retrieved", {
  volker::codebook(data) |>
    print(n=Inf) |>
    expect_snapshot(cran = TRUE)
})

# What happens when labels are empty?
test_that("Missing labels make no trouble", {
  data %>%
    dplyr::select(starts_with("cg_adoption")) %>%
    volker::labs_clear() %>%
    volker::codebook() %>%
    expect_snapshot(cran = TRUE)
})

# Detect the scale
test_that("Factors are unordered", {
  data %>%
    get_direction(adopter) |>
    expect_equal(0)
})

test_that("Items are ordered", {
  data %>%
    get_direction(use_private) |>
    expect_equal(1)
})

# Test store and clear labels
test_that("Store and clear the codebook", {
  data %>%
    volker::labs_store() %>%
    volker::labs_clear() %>%
    codebook() %>%
    print(n=Inf) |>
    expect_snapshot(cran = TRUE)
})

# Test store and restore labels
test_that("Store, clear and restore the codebook", {
  data %>%
    volker::labs_store() %>%
    volker::labs_clear() %>%
    volker::labs_restore() %>%
    codebook() %>%
    print(n=Inf) |>
    expect_snapshot(cran = TRUE)
})

# Replace item values
test_that("Item values are replaced and keep their order", {

  data |>
    dplyr::select(adopter) |>
    volker:::labs_replace(adopter, volker::codebook(data, adopter)) |>
    dplyr::pull(adopter) |>
    levels() |>
    expect_snapshot(cran = TRUE)

    #Even if the column was converted to character beforehand
    data |>
      dplyr::select(adopter) |>
      dplyr::mutate(adopter = as.character(adopter)) |>
      volker:::labs_replace(adopter, volker::codebook(data, adopter)) |>
      dplyr::pull(adopter) |>
      levels() |>
      expect_snapshot(cran = TRUE)
})


# Replace item values
test_that("Item values are kept even if they are not in the codebook", {

  codes <- data |>
    codebook(use_private) |>
    filter(value_name %in% c("1","5"))

  data |>
    dplyr::distinct(from = use_private) |>
    dplyr::mutate(to = from) |>
    volker:::labs_replace(to, codes) |>
    dplyr::arrange(to) |>
    expect_snapshot(cran = TRUE)
})


# Replace item values and keep the comment
test_that("The column title is kept when values are replaced", {

  df <- tibble(
      values = c("A", "B", "C")
    ) |>
    labs_apply(tibble(
      item_name = c("values"),
      item_label = c("VALS")
    ))

  codes <- tibble(
    value_name = c("A", "B", "C"),
    value_label = c("1", "2", "3")
  )

  df <- volker:::labs_replace(df, values, codes, col_from="value_name", col_to="value_label")

  tab_counts(df, values)  |>
    expect_snapshot(cran = TRUE)

})

# Get prefix from labels
test_that("A common prefix is removed from labels", {

  data |>
    dplyr::select(starts_with("use")) |>
    codebook() |>
    dplyr::pull(item_label) |>
    get_prefix() |>
    expect_snapshot(cran = TRUE)
})

# Remove prefix from labels
test_that("A common prefix is removed from labels", {

  data |>
    dplyr::select(starts_with("use")) |>
    codebook() |>
    dplyr::pull(item_label) |>
    trim_prefix() |>
    expect_snapshot(cran = TRUE)
})

# Labeling coded numeric values
test_that("Numeric values are relabeled", {

  data %>%
    labs_apply(
      cols=starts_with("cg_adoption_advantage"),
      values = list(
        "1" = "Stimme überhaupt nicht zu",
        "2" = "Stimme nicht zu",
        "3" = "Unentschieden",
        "4" = "Stimme zu",
        "5" =  "Stimme voll und ganz zu"
      )
    ) %>%
    tab_counts(starts_with("cg_adoption_advantage")) |>
    expect_snapshot(cran = TRUE)

})



# Labeling using a named vector equals labeling by a named list
test_that("Numeric values are relabeled by a named vector", {

  result_vector <- data %>%
    labs_apply(
      cols=starts_with("cg_adoption_advantage"),
      values = c(
        "1" = "Stimme überhaupt nicht zu",
        "2" = "Stimme nicht zu",
        "3" = "Unentschieden",
        "4" = "Stimme zu",
        "5" =  "Stimme voll und ganz zu"
      )
    ) %>%
    tab_counts(cg_adoption_advantage_01)

  result_list <- data %>%
    labs_apply(
      cols=starts_with("cg_adoption_advantage"),
      values = list(
        "1" = "Stimme überhaupt nicht zu",
        "2" = "Stimme nicht zu",
        "3" = "Unentschieden",
        "4" = "Stimme zu",
        "5" =  "Stimme voll und ganz zu"
      )
    ) %>%
    tab_counts(cg_adoption_advantage_01)


  expect_identical(result_list, result_vector)
})

# Labeling uncoded factor values
test_that("Factor values are relabeled", {

 data %>%
    labs_apply(
      cols=sd_gender,
      values = list(
        "female" = "Weiblich",
        "male" = "Männlich",
        "diverse" = "Divers"
      )
    )  |>
    tab_counts(sd_gender) |>
    expect_snapshot(cran = TRUE)

})


# Labeling elliptical numeric values (where some labels are present)
test_that("Elliptical numeric values are relabeled", {

  testdata <- select(data , use_private)
  attr(testdata$use_private,"2") <- NULL
  attr(testdata$use_private,"3") <- NULL
  attr(testdata$use_private,"4") <- NULL

  testdata %>%
    labs_apply(
      cols=use_private,
      values = list(
        "1" = "never",
        "2" = "2",
        "3" = "3",
        "4" = "4",
        "5" = "almost daily"
      )
    ) |>
    codebook(use_private) |>
    expect_snapshot(cran = TRUE)

})

# Label wrapping
test_that("Labels are wrapped at whitespace and slashes", {

  volker:::wrap_label("Super long/short label\\s", width=3) |>
    expect_snapshot_value(cran = TRUE)

})
