# Classical and Robust Mahalanobis Distances

This function is a convenience wrapper to
[`mahalanobis`](https://rdrr.io/r/stats/mahalanobis.html) offering also
the possibility to calculate robust Mahalanobis squared distances using
MCD and MVE estimators of center and covariance (from
[`cov.rob`](https://rdrr.io/pkg/MASS/man/cov.rob.html))

## Usage

``` r
Mahalanobis(
  x,
  center,
  cov,
  method = c("classical", "mcd", "mve"),
  nsamp = "best",
  ...
)
```

## Arguments

- x:

  a numeric matrix or data frame with, say, \\p\\ columns

- center:

  mean vector of the data; if this and `cov` are both supplied, the
  function simply calls
  [`mahalanobis`](https://rdrr.io/r/stats/mahalanobis.html) to calculate
  the result

- cov:

  covariance matrix (p x p) of the data

- method:

  estimation method used for center and covariance, one of:
  `"classical"` (product-moment), `"mcd"` (minimum covariance
  determinant), or `"mve"` (minimum volume ellipsoid).

- nsamp:

  passed to [`cov.rob`](https://rdrr.io/pkg/MASS/man/cov.rob.html)

- ...:

  other arguments passed to
  [`cov.rob`](https://rdrr.io/pkg/MASS/man/cov.rob.html)

## Value

a vector of length `nrow(x)` containing the squared distances.

## Details

Any missing data in a row of `x` causes `NA` to be returned for that
row.

## See also

[`mahalanobis`](https://rdrr.io/r/stats/mahalanobis.html),
[`cov.rob`](https://rdrr.io/pkg/MASS/man/cov.rob.html)

## Author

Michael Friendly

## Examples

``` r
summary(Mahalanobis(iris[, 1:4]))
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.3195  2.1871  3.0628  3.9733  4.8053 13.1011 
summary(Mahalanobis(iris[, 1:4], method="mve"))
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.4461  2.5331  4.0110  5.5585  6.8295 25.7951 
summary(Mahalanobis(iris[, 1:4], method="mcd"))
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.4352  2.7301  5.7160 19.2207 36.7121 98.0335 

```
