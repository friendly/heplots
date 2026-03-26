# Plot for Box's M test with bootstrap CIs

Enhanced version of
[`plot.boxM()`](https://friendly.github.io/heplots/reference/plot.boxM.md)
that supports bootstrap confidence intervals for eigenvalue-based
statistics in addition to the existing analytic CIs for log
determinants.

## Usage

``` r
plot_boxM_boot(
  x,
  Y = NULL,
  group = NULL,
  gplabel = NULL,
  which = c("logDet", "product", "sum", "precision", "max"),
  log = which == "product",
  pch = c(16, 15),
  cex = c(2, 2.5),
  col = c("blue", "red"),
  rev = FALSE,
  xlim,
  conf = 0.95,
  method = 1,
  bias.adj = TRUE,
  lwd = 2,
  boot.R = 1000,
  boot.type = c("perc", "bca", "norm", "basic"),
  boot.parallel = FALSE,
  boot.ncpus = 2,
  boot.seed = NULL,
  ...
)
```

## Arguments

- x:

  A `"boxM"` object resulting from
  [`boxM()`](https://friendly.github.io/heplots/reference/boxM.md)

- Y:

  Optional data matrix (required for bootstrap CIs with eigenvalue
  stats)

- group:

  Optional grouping variable (required for bootstrap CIs with eigenvalue
  stats)

- gplabel:

  Character string used to label the group factor

- which:

  Measure to be plotted

- log:

  Logical; if TRUE, the log of the measure is plotted

- pch:

  Point symbols for groups and pooled data

- cex:

  Character size of point symbols

- col:

  Colors for point symbols

- rev:

  Logical; if TRUE, reverse order of groups on vertical axis

- xlim:

  X limits for the plot

- conf:

  Coverage for confidence intervals (0 to suppress)

- method:

  CI method for logDet (see
  [`logdetCI()`](https://friendly.github.io/heplots/reference/logdetCI.md))

- bias.adj:

  Bias adjustment for logDet CIs

- lwd:

  Line width for confidence intervals

- boot.R:

  Number of bootstrap replicates (for eigenvalue stats only)

- boot.type:

  Type of bootstrap CI ("perc", "bca", "norm", "basic")

- boot.parallel:

  Use parallel processing for bootstrap

- boot.ncpus:

  Number of CPUs for parallel bootstrap

- boot.seed:

  Random seed for bootstrap reproducibility

- ...:

  Additional arguments passed to
  [`dotchart()`](https://rdrr.io/r/graphics/dotchart.html)

## Value

Invisibly returns the confidence interval data frame (if computed)

## Details

This implementation is still **Experimental**

## Examples

``` r
if (FALSE) { # \dontrun{
library(boot)
# source("dev/eigstatCI.R")
# source("dev/plot.boxM_with_bootstrap.R")

# Iris data with bootstrap CIs
boxm <- boxM(iris[,1:4], iris$Species)

# logDet with analytic CI (same as before)
plot_boxM_boot(boxm, gplabel = "Species")

# Sum of eigenvalues with bootstrap CI
plot_boxM_boot(boxm, Y = iris[,1:4], group = iris$Species,
               which = "sum", gplabel = "Species", boot.R = 1000)
} # }
```
