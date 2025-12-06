#
# Test theme
#

library(testthat)
library(volker)

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

if (Sys.getenv("R_LOCALTESTS") == "1") {

  skip("Theme tests skipped; need revision.")

  test_that("theme_vlkr applies correct theme settings", {

    library(ggplot2)

    # Set the custom theme
    theme_set(theme_vlkr(base_size=15, base_color="blue", base_fill = list("red"), base_gradient = c("blue", "green")))

    expect_doppelganger("bar_plot_theme_vlkr", {
      plot_counts(data, sd_gender)
    })

    expect_doppelganger("bar_plot_theme_vlkr with gradient", {
      plot_counts(data, sd_gender, adopter, ordered=1)
    })

  })
}
