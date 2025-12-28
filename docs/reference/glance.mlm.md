# Glance at an mlm object

This function takes an "mlm" object, fit by
[`lm`](https://rdrr.io/r/stats/lm.html) with a multivariate response.
The goal is to return something analogous to
[`glance.lm`](https://broom.tidymodels.org/reference/glance.lm.html) for
a univariate response linear model.

## Usage

``` r
# S3 method for class 'mlm'
glance(x, ...)
```

## Arguments

- x:

  An `"mlm"` object created by [`lm`](https://rdrr.io/r/stats/lm.html),
  i.e., with a multivariate response.

- ...:

  Additional arguments. Not used.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
one row for each response variable and the columns:

- `r.squared`:

  R squared statistic, or the percent of variation explained by the
  model.

- `sigma`:

  Estimated standard error of the residuals

- `fstatitic`:

  Overall F statistic for the model

- `numdf`:

  Numerator degrees of freedom for the overall test

- `dendf`:

  Denominator degrees of freedom for the overall test

- `p.value`:

  P-value corresponding to the F statistic

- `nobs`:

  Number of observations used

## Details

In the multivariate case, it returns a
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with one
row for each response variable, containing goodness of fit measures,
F-tests and p-values.

## See also

Other multivariate linear models:
[`coefplot()`](https://friendly.github.io/heplots/reference/coefplot.md)

## Examples

``` r
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
glance(iris.mod)
#> # A tibble: 4 × 8
#>   response     r.squared sigma fstatistic numdf dendf  p.value  nobs
#>   <chr>            <dbl> <dbl>      <dbl> <dbl> <dbl>    <dbl> <int>
#> 1 Sepal.Length     0.619 0.515      119.      2   147 1.67e-31   150
#> 2 Sepal.Width      0.401 0.340       49.2     2   147 4.49e-17   150
#> 3 Petal.Length     0.941 0.430     1180.      2   147 2.86e-91   150
#> 4 Petal.Width      0.929 0.205      960.      2   147 4.17e-85   150
```
