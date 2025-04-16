#
# Test plot features
#

library(testthat)
library(volker)

# Load the sample data
data <- volker::chatgpt

# Only run plot tests if explicitly configured
# because they will fail on different machines due
# to different rendering engines and fonts.
# To enable, call oonce on your machine:
#
#   Sys.setenv("R_LOCALTESTS" = "1")
#
# To disable, call:
#
# Sys.unsetenv("R_LOCALTESTS")
#


if (Sys.getenv("R_LOCALTESTS") == "1") {

  test_that("boxplot", {

    library(ggplot2)

    p <- plot_metrics(data, sd_age, box = T)

    # Save the plot to a temporary file
    plot_file <- tempfile(fileext = ".png")
    ggsave(plot_file, plot = p)

    # Capture the plot as a snapshot
    expect_snapshot_file(plot_file, "plot_metrics_box.png")

  })

  test_that("applying boxplot to metric plot", {

    library(ggplot2)

    p <- plot_metrics(data, sd_age, ci = TRUE)

    # Save the plot to a temporary file
    plot_file <- tempfile(fileext = ".png")
    ggsave(plot_file, plot = p)

    # Capture the plot as a snapshot
    expect_snapshot_file(plot_file, "plot_metrics_ci.png")

  })

  test_that("applying boxplot to categorical plot", {

    library(ggplot2)

    p <- plot_counts(data, sd_gender, ci = TRUE)

    # Save the plot to a temporary file
    plot_file <- tempfile(fileext = ".png")
    ggsave(plot_file, plot = p)

    # Capture the plot as a snapshot
    expect_snapshot_file(plot_file, "plot_counts_ci.png")

  })

}

test_that("Empty plots are empty", {
   test_data <- tibble(var1=c(NA))

   plot_counts(test_data, var1) |>
     expect_error("Check your data: Are they empty?")

})
