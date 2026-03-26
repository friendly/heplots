# Bootstrap Confidence Intervals for Eigenvalue Statistics

Computes bootstrap confidence intervals for statistics based on
eigenvalues of grouped covariance matrices. This is intended for use
with
[`plot.boxM()`](https://friendly.github.io/heplots/reference/plot.boxM.md)
to provide confidence intervals for measures beyond the default
"logDet".

This is a convenience wrapper that extracts the necessary information
from a boxM object, but still requires the original data and grouping
variable since these are not stored in the boxM object.

## Usage

``` r
eigstatCI(
  Y,
  group,
  which = c("product", "sum", "precision", "max"),
  R = 1000,
  conf = 0.95,
  type = c("perc", "bca", "norm", "basic"),
  parallel = FALSE,
  ncpus = 2,
  seed = NULL,
  ...
)

eigstatCI_boxM(boxm, Y, group, ...)
```

## Arguments

- Y:

  Original data matrix used in
  [`boxM()`](https://friendly.github.io/heplots/reference/boxM.md)

- group:

  Original grouping variable used in
  [`boxM()`](https://friendly.github.io/heplots/reference/boxM.md)

- which:

  The eigenvalue-based statistic to compute. One of:

  product

  :   Product of eigenvalues (= determinant)

  sum

  :   Sum of eigenvalues (= trace)

  precision

  :   Harmonic mean of eigenvalues

  max

  :   Maximum eigenvalue

- R:

  Number of bootstrap replicates. Default is 1000.

- conf:

  Confidence level for intervals (0 \< conf \< 1). Default is 0.95.

- type:

  Type of bootstrap confidence interval. Options:

  perc

  :   Percentile method (default, most robust)

  bca

  :   Bias-corrected and accelerated

  norm

  :   Normal approximation

  basic

  :   Basic bootstrap

- parallel:

  Logical or character string. If TRUE, use parallel processing via the
  boot package. Can also be "multicore" or "snow". Default is FALSE.

- ncpus:

  Number of CPUs to use if parallel=TRUE. Default is 2.

- seed:

  Random seed for reproducibility. If NULL, no seed is set.

- ...:

  Additional arguments passed to `eigstatCI()`

- boxm:

  A "boxM" object from
  [`boxM()`](https://friendly.github.io/heplots/reference/boxM.md)

## Value

A data frame with one row for each group plus the pooled data. Columns
include:

- group:

  Group name (factor level)

- statistic:

  Observed value of the statistic

- lower:

  Lower confidence limit

- upper:

  Upper confidence limit

- bias:

  Bootstrap estimate of bias (if available)

- se:

  Bootstrap standard error (if available)

A data frame with bootstrap confidence intervals

## Details

For each group (and the pooled data), this function performs
nonparametric bootstrap resampling to estimate the sampling distribution
of the specified eigenvalue-based statistic. Confidence intervals are
computed using the percentile method or bias-corrected and accelerated
(BCa) method.

Unlike
[`logdetCI()`](https://friendly.github.io/heplots/reference/logdetCI.md)
which uses analytic approximations based on asymptotic theory, this
function makes no distributional assumptions and can handle small to
moderate sample sizes, though computational cost increases with the
number of bootstrap replicates.

## References

Efron, B., & Tibshirani, R. J. (1994). *An Introduction to the
Bootstrap*. CRC Press.

## See also

[`boxM`](https://friendly.github.io/heplots/reference/boxM.md),
[`plot.boxM`](https://friendly.github.io/heplots/reference/plot.boxM.md),
[`logdetCI`](https://friendly.github.io/heplots/reference/logdetCI.md)

Other diagnostic plots:
[`cqplot()`](https://friendly.github.io/heplots/reference/cqplot.md),
[`distancePlot()`](https://friendly.github.io/heplots/reference/distancePlot.md),
[`plot.boxM()`](https://friendly.github.io/heplots/reference/plot.boxM.md)

## Author

Michael Friendly

## Examples

``` r
if (FALSE) { # \dontrun{
library(boot)
data(iris)

# Bootstrap CI for product of eigenvalues
CI_prod <- eigstatCI(iris[,1:4], iris$Species, which="product", R=500)
CI_prod

# Bootstrap CI for sum of eigenvalues (= trace)
CI_sum <- eigstatCI(iris[,1:4], iris$Species, which="sum", R=500)
CI_sum

# Use with parallel processing for speed
CI_max <- eigstatCI(iris[,1:4], iris$Species, which="max",
                    R=1000, parallel=TRUE, ncpus=4)
} # }

if (FALSE) { # \dontrun{
library(boot)
data(iris)

# Fit boxM
res <- boxM(iris[,1:4], iris$Species)

# Get bootstrap CIs (must provide original data again)
CI <- eigstatCI_boxM(res, Y = iris[,1:4], group = iris$Species,
                     which = "sum", R = 500)
} # }
```
