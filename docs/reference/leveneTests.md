# Levene Tests of Homogeneity of Variances

This function extends
[`leveneTest`](https://rdrr.io/pkg/car/man/leveneTest.html) to a
multivariate response setting. It performs the Levene test of
homogeneity of variances for each of a set of response variables, and
prints a compact summary.

## Usage

``` r
leveneTests(y, ...)

# Default S3 method
leveneTests(y, group, center = median, ...)

# S3 method for class 'formula'
leveneTests(y, data, ...)

# S3 method for class 'lm'
leveneTests(y, ...)
```

## Arguments

- y:

  A data frame or matrix of numeric response variables for the default
  method, or a model formula for a multivariate linear model, or the
  multivariate linear model itself. In the case of a formula or model,
  the variables on the right-hand-side of the model must all be factors
  and must be completely crossed.

- ...:

  arguments to be passed down to
  [`leveneTest`](https://rdrr.io/pkg/car/man/leveneTest.html), e.g.,
  `data` for the `formula` and `lm` methods; can also be used to pass
  arguments to the function given by center (e.g., center=mean and
  trim=0.1 specify the 10% trimmed mean) other arguments.

- group:

  a vector or factor object giving the group for the corresponding
  elements of the rows of `y` for the default method

- center:

  The name of a function to compute the center of each group; `mean`
  gives the original Levene's (1960) test; the default, `median`,
  provides a more robust test suggested by Brown and Forsythe (1974).

- data:

  the data set, for the `formula` method

## Value

An object of classes "anova" and "data.frame", with one observation for
each response variable in `y`.

## References

Levene, H. (1960). Robust Tests for Equality of Variances. In Olkin, I.
*et al.* (Eds.), *Contributions to Probability and Statistics: Essays in
Honor of Harold Hotelling*, Stanford University Press, 278-292.

Brown, M. B. & Forsythe, A. B. (1974). Robust Tests For Equality Of
Variances *Journal of the American Statistical Association*, **69**,
364-367.

## See also

[`leveneTest`](https://rdrr.io/pkg/car/man/leveneTest.html),
[`bartlettTests`](https://friendly.github.io/heplots/reference/bartlettTests.md)

Other homogeneity tests:
[`bartlettTests()`](https://friendly.github.io/heplots/reference/bartlettTests.md)

## Author

Michael Friendly

## Examples

``` r
leveneTests(iris[,1:4], iris$Species)
#> Levene's Tests for Homogeneity of Variance (center = median)
#> 
#>              df1 df2 F value    Pr(>F)    
#> Sepal.Length   2 147  6.3527  0.002259 ** 
#> Sepal.Width    2 147  0.5902  0.555518    
#> Petal.Length   2 147 19.4803 3.129e-08 ***
#> Petal.Width    2 147 19.8924 2.261e-08 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# handle a 1-column response?
leveneTests(iris[,1, drop=FALSE], iris$Species)
#> Levene's Tests for Homogeneity of Variance (center = median)
#> 
#>              df1 df2 F value   Pr(>F)   
#> Sepal.Length   2 147  6.3527 0.002259 **
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

data(Skulls, package="heplots")
leveneTests(Skulls[,-1], Skulls$epoch)
#> Levene's Tests for Homogeneity of Variance (center = median)
#> 
#>    df1 df2 F value Pr(>F)
#> mb   4 145  1.0367 0.3905
#> bh   4 145  0.7171 0.5816
#> bl   4 145  0.6797 0.6071
#> nh   4 145  1.0418 0.3878

# formula method
leveneTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#> Levene's Tests for Homogeneity of Variance (center = median)
#> 
#>    df1 df2 F value Pr(>F)
#> mb   4 145  1.0367 0.3905
#> bh   4 145  0.7171 0.5816
#> bl   4 145  0.6797 0.6071
#> nh   4 145  1.0418 0.3878

# use 10% trimmed means
leveneTests(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls, trim = 0.1)
#> Levene's Tests for Homogeneity of Variance (center = median: 0.1)
#> 
#>    df1 df2 F value Pr(>F)
#> mb   4 145  1.0367 0.3905
#> bh   4 145  0.7171 0.5816
#> bl   4 145  0.6797 0.6071
#> nh   4 145  1.0418 0.3878


# mlm method
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
leveneTests(skulls.mod)
#> Levene's Tests for Homogeneity of Variance (center = median)
#> 
#>    df1 df2 F value Pr(>F)
#> mb   4 145  1.0367 0.3905
#> bh   4 145  0.7171 0.5816
#> bl   4 145  0.6797 0.6071
#> nh   4 145  1.0418 0.3878
```
