# Bartlett Tests of Homogeneity of Variances

This function extends
[`bartlett.test`](https://rdrr.io/r/stats/bartlett.test.html) to a
multivariate response setting. It performs the Bartlett test of
homogeneity of variances for each of a set of response variables, and
prints a compact summary.

Bartlett's test is the univariate version of Box's M test for equality
of covariance matrices. This function provides a univariate follow-up
test to Box's M test to give one simple assessment of which response
variables contribute to significant differences in variances among
groups.

## Usage

``` r
bartlettTests(y, ...)

# Default S3 method
bartlettTests(y, group, ...)

# S3 method for class 'formula'
bartlettTests(y, data, ...)

# S3 method for class 'lm'
bartlettTests(y, ...)
```

## Arguments

- y:

  A data frame or matrix of numeric response variables for the default
  method, or a model formula for a multivariate linear model, or the
  multivariate linear model itself. In the case of a formula or model,
  the variables on the right-hand-side of the model must all be factors
  and must be completely crossed.

- ...:

  other arguments, passed to
  [`bartlett.test`](https://rdrr.io/r/stats/bartlett.test.html)

- group:

  a vector or factor object giving the group for the corresponding
  elements of the rows of `y` for the default method

- data:

  the data set, for the `formula` method

## Value

An object of classes "anova" and "data.frame", with one observation for
each response variable in `y`.

## References

Bartlett, M. S. (1937). Properties of sufficiency and statistical tests.
*Proceedings of the Royal Society of London Series A*, **160**, 268-282.

## See also

[`boxM`](https://friendly.github.io/heplots/reference/boxM.md) for Box's
M test for all responses together.

Other homogeneity tests:
[`leveneTests()`](https://friendly.github.io/heplots/reference/leveneTests.md)

## Author

Michael Friendly

## Examples

``` r
bartlettTests(iris[,1:4], iris$Species)
#> Bartlett's Tests for Homogeneity of Variance  
#> 
#>                Chisq df Pr(>Chisq)    
#> Sepal.Length 16.0057  2  0.0003345 ***
#> Sepal.Width   2.0911  2  0.3515028    
#> Petal.Length 55.4225  2  9.229e-13 ***
#> Petal.Width  39.2131  2  3.055e-09 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

data(Skulls, package="heplots")
bartlettTests(Skulls[,-1], Skulls$epoch)
#> Bartlett's Tests for Homogeneity of Variance  
#> 
#>     Chisq df Pr(>Chisq)
#> mb 7.3382  4     0.1191
#> bh 0.7315  4     0.9474
#> bl 3.5155  4     0.4755
#> nh 4.3763  4     0.3575

# formula method
bartlettTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#> Bartlett's Tests for Homogeneity of Variance  
#> 
#>     Chisq df Pr(>Chisq)
#> mb 7.3382  4     0.1191
#> bh 0.7315  4     0.9474
#> bl 3.5155  4     0.4755
#> nh 4.3763  4     0.3575
```
