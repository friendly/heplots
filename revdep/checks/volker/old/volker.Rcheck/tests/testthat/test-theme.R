#
# Test theme
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

  test_that("theme_vlkr applies correct theme settings", {

    library(ggplot2)

    # Set the custom theme
    theme_set(theme_vlkr(base_size=15, base_color="blue", base_fill = list("red"), base_gradient = c("blue", "green")))

    # Create a plot
    p <- plot_counts(data, sd_gender)

    # Save the plot to a temporary file
    plot_file <- tempfile(fileext = ".png")
    ggsave(plot_file, plot = p)

    # Capture the plot as a snapshot
    expect_snapshot_file(plot_file, "bar_plot_theme_vlkr.png")

    # Another example with gradient
    p_gradient <- plot_counts(data, sd_gender, adopter, ordered=1)

    # Save the gradient plot to a temporary file
    plot_file_gradient <- tempfile(fileext = ".png")
    ggsave(plot_file_gradient, plot = p_gradient)

    # Capture the gradient plot as a snapshot
    expect_snapshot_file(plot_file_gradient, "bar_plot_theme_vlkr_gradient.png")
  })
}
