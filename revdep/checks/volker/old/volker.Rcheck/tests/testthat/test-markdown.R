#
# Markdown rendering tests
#

library(testthat)
library(volker)
library(knitr)

# Rendering tables (may have different line endings on different systems, by now, just test errors)
test_that("Tables in markdown documents render without error", {
  expect_no_error(rmarkdown::render("_markdown/tables.Rmd"))
  unlink("_markdown/tables.html")
})

# Rendering plots (pixel accuracy is out of scope by now, just test errors)
test_that("Plots in markdown documents render without error", {
  expect_no_error(rmarkdown::render("_markdown/plots.Rmd"))
  unlink("_markdown/plots.html")
})

# Rendering reports (pixel accuracy is out of scope by now, just test errors)
test_that("Volker reports render without error", {
  expect_no_error(rmarkdown::render("_markdown/reports.Rmd"))
  unlink("_markdown/reports.html")
})


