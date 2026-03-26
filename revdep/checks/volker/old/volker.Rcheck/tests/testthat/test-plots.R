#
# Test plot features
#

library(testthat)
library(volker)
library(dplyr)

# --- Setup ------------------------------------------------------------------

# If vdiffr is not installed, skip all visual tests
if (requireNamespace("vdiffr", quietly = TRUE) && utils::packageVersion('testthat') >= '3.0.3') {
  library(vdiffr)
  expect_doppelganger <- vdiffr::expect_doppelganger
} else {
  expect_doppelganger <- function(...) skip("vdiffr is not installed.")
}

# Only run plot tests if explicitly enabled
# because they will fail on different machines due
# to different rendering engines.
#
# Enable:
# Sys.setenv("R_LOCALTESTS" = "1")
# Disable:
# Sys.unsetenv("R_LOCALTESTS")


# Load the sample data
data <- volker::chatgpt

test_that("Empty plots are empty", {
  test_data <- tibble(var1=c(NA))

  plot_counts(test_data, var1) |>
    expect_error("Check your data: Are they empty?")

})


if (Sys.getenv("R_LOCALTESTS") == "1") {

  ggplot2::theme_set(ggplot2::theme_test())
  #ggplot2::theme_set(volker::theme_vlkr())

  test_that("Categorical plots render as expected", {

    expect_doppelganger("plot_counts_one", {
      data |> plot_counts(adopter)
    })

    expect_doppelganger("plot_counts_one with binary data", {
      data |> mutate(adopter = adopter == "I try new offers immediately") |> plot_counts(adopter)
    })

    expect_doppelganger("plot_counts_one with focus category", {
      data |> plot_counts(adopter, category = "I try new offers immediately")
    })

    expect_doppelganger("plot_counts_one_grouped", {
      plot_counts(data, sd_gender, adopter)
    })

    expect_doppelganger("plot_counts_one_grouped with rowsprops", {
      data |> plot_counts(adopter, sd_gender, prop = "rows", numbers = "p")
    })

    expect_doppelganger("plot_counts_one_grouped with cols props", {
      plot_counts(data, adopter, sd_gender, prop = "cols", numbers = "p", ordered = -1)
    })

    expect_doppelganger("plot_counts_one_grouped_reversed", {
      data |> mutate(adopter = factor(adopter, levels = rev(levels(adopter)))) |>
        plot_counts(adopter, sd_gender, prop = "cols")
    })

    expect_doppelganger("plot_counts_one_cor", {
      plot_counts(data, adopter, sd_age, metric = TRUE)
    })

    expect_doppelganger("plot_counts_one_cor with rows props", {
      plot_counts(data, adopter, sd_age, metric = TRUE, prop = "rows")
    })


    expect_doppelganger("plot_counts_items", {
      plot_counts(data, starts_with("cg_adoption_"), numbers = "p")
    })

    expect_doppelganger("plot_counts_items with binary data", {
      data |> mutate(across(starts_with("cg_adoption_advantage"), \(x) x > 3)) |>
        plot_counts(starts_with("cg_adoption_advantage"))
    })

    expect_doppelganger("plot_counts_items_grouped", {
      plot_counts(
        data, starts_with("cg_adoption_"), adopter,
        category = c("agree", "strongly agree")
      )
    })

    # TODO: Fix theming of tile stroke width
    # expect_doppelganger("plot_counts_items_grouped_items", {
    #   plot_counts(
    #     data, starts_with("cg_adoption_"), starts_with("cg_adoption_")
    #   )
    # })

    expect_doppelganger("plot_counts_items_cor", {
      plot_counts(
        data, starts_with("cg_adoption_"), sd_age, metric = TRUE,
        category = c(4, 5)
      )
    })

  })

  test_that("Metric distribution plots render as expected", {

    expect_doppelganger("plot_metrics_one", {
      plot_metrics(data, sd_age)
    })

    expect_doppelganger("plot_metrics_one with box", {
      plot_metrics(data, sd_age, box = TRUE)
    })

    expect_doppelganger("plot_metrics_one with ci", {
      plot_metrics(data, sd_age, ci = TRUE)
    })

    expect_doppelganger("plot_metrics_one_grouped", {
      plot_metrics(data, sd_age, sd_gender)
    })

    expect_doppelganger("plot_metrics_one_cor", {
      plot_metrics(data, sd_age, use_work, metric = TRUE)
    })

    expect_doppelganger("plot_metrics_one_cor with log scale", {
      plot_metrics(data, sd_age, use_work, metric = TRUE, log = TRUE)
    })

    expect_doppelganger("plot_metrics_one_cor without title", {
      plot_metrics(data, sd_age, use_work, metric = TRUE, title = FALSE)
    })

    expect_doppelganger("plot_metrics_items", {
      plot_metrics(data, starts_with("cg_adoption_"))
    })

    expect_doppelganger("plot_metrics_items_grouped", {
      plot_metrics(data, starts_with("cg_adoption_"), sd_gender)
    })

    expect_doppelganger("plot_metrics_items_cor with pearson's r", {
      plot_metrics(data, starts_with("use_"), sd_age, metric = TRUE)
    })

    expect_doppelganger("plot_metrics_items_cor with spearman's rho", {
      plot_metrics(data, starts_with("use_"), sd_age, metric = TRUE, method = "spearman")
    })

    # TODO: Fix theming of tile stroke width
    # expect_doppelganger("plot_metrics_items_cor_items", {
    #   plot_metrics(data, starts_with("cg_adoption_adv"), starts_with("use_"), metric = TRUE)
    # })

    # TODO: Fix theming of tile stroke width
    # expect_doppelganger("plot_metrics_items_cor_items with numbers", {
    #   plot_metrics(
    #     data, starts_with("cg_adoption_adv"),
    #     starts_with("use_"),
    #     metric = TRUE,
    #     numbers = TRUE
    #   )
    # })
  })

  test_that("Index plots render as expected", {

    expect_doppelganger("index_distribution_grouped", {
      data %>%
        add_index(starts_with("cg_adoption_social_")) %>%
        add_index(starts_with("cg_adoption_fearofuse_")) %>%
        add_index(starts_with("cg_adoption_advantage_")) %>%
        labs_apply(tribble(
          ~item_name, ~item_label,
          "idx_cg_adoption_social", "ChatGPT-Erwartung: Social",
          "idx_cg_adoption_fearofuse", "ChatGPT-Erwartung: Fear of Use",
          "idx_cg_adoption_advantage", "ChatGPT-Erwartung: Advantage"
        )) %>%
        plot_metrics(starts_with("idx_cg_adoption"), adopter)
    })

  })

  test_that("New labels render as expected", {

    expect_doppelganger("apply_value_labels_plot", {
      data %>%
        filter(sd_gender != "diverse") %>%
        labs_apply(
          cols = sd_gender,
          values = list(
            "female" = "Weiblich",
            "male" = "Maennlich"
          )
        ) %>%
        plot_metrics(sd_age, sd_gender)
    })
  })


} else {
  skip("R_LOCALTESTS not set; skipping visual tests.")
}

