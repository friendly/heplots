# Univariate Test Statistics for a Multivariate Linear Model

Univariate Test Statistics for a Multivariate Linear Model

## Usage

``` r
uniStats(x, ...)
```

## Arguments

- x:

  A `"mlm"` object fitted by [`lm`](https://rdrr.io/r/stats/lm.html)
  with two or more response variables

- ...:

  Other arguments, ignored

## Value

An object of class `c("anova", "data.frame")` containing, for each
response variable the overall \\R^2\\ for all terms in the model and the
overall \\F\\ statistic together with its degrees of freedom and
p-value.

## See also

[`glance.mlm`](https://friendly.github.io/heplots/reference/glance.mlm.md)

## Examples

``` r
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
car::Anova(iris.mod)
#> 
#> Type II MANOVA Tests: Pillai test statistic
#>         Df test stat approx F num Df den Df    Pr(>F)    
#> Species  2    1.1919   53.466      8    290 < 2.2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
uniStats(iris.mod)
#> Univariate tests for responses in the multivariate linear model iris.mod 
#> 
#>                  R^2       F df1 df2    Pr(>F)    
#> Sepal.Length 0.61871  119.26   2 147 < 2.2e-16 ***
#> Sepal.Width  0.40078   49.16   2 147 < 2.2e-16 ***
#> Petal.Length 0.94137 1180.16   2 147 < 2.2e-16 ***
#> Petal.Width  0.92888  960.01   2 147 < 2.2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

data(Plastic, package = "heplots")
plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
# multivariate tests
car::Anova(plastic.mod)
#> 
#> Type II MANOVA Tests: Pillai test statistic
#>               Df test stat approx F num Df den Df   Pr(>F)   
#> rate           1   0.61814   7.5543      3     14 0.003034 **
#> additive       1   0.47697   4.2556      3     14 0.024745 * 
#> rate:additive  1   0.22289   1.3385      3     14 0.301782   
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
