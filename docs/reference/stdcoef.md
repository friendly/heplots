# Standardized Regression Coefficients

Computes standardized ("beta") regression coefficients for a fitted `lm`
or `mlm` object, i.e. the coefficients that would result from fitting
the same model with all numeric variables rescaled to mean 0, SD 1.

For an `"mlm"` object, standardization follows
[`stdmodel()`](https://friendly.github.io/heplots/reference/stdmodel.md)'s
convention: the response(s) and numeric predictors are standardized;
factor predictors are left raw.

## Usage

``` r
stdcoef(object, ...)

# S3 method for class 'lm'
stdcoef(object, ...)

# S3 method for class 'mlm'
stdcoef(object, ...)
```

## Arguments

- object:

  A fitted `"lm"` or `"mlm"` object

- ...:

  Additional arguments. Not used.

## Value

For an `"lm"` object, a named numeric vector of standardized
coefficients (intercept excluded). For an `"mlm"` object, a numeric
matrix of standardized coefficients (parameters x responses, intercept
row excluded).

## See also

[`stdmodel()`](https://friendly.github.io/heplots/reference/stdmodel.md),
[`coefplot.mlm()`](https://friendly.github.io/heplots/reference/coefplot.md).
For standard errors, test statistics and p-values on the standardized
scale, run
[`lmtest::coeftest()`](https://rdrr.io/pkg/lmtest/man/coeftest.html)
(and, for a tidy data frame,
[`broom::tidy.coeftest()`](https://broom.tidymodels.org/reference/tidy.coeftest.html))
on
[`stdmodel()`](https://friendly.github.io/heplots/reference/stdmodel.md)'s
result.

Other multivariate linear models:
[`coefplot()`](https://friendly.github.io/heplots/reference/coefplot.md),
[`glance.mlm()`](https://friendly.github.io/heplots/reference/glance.mlm.md),
[`stdmodel()`](https://friendly.github.io/heplots/reference/stdmodel.md)

## Author

Michael Friendly

## Examples

``` r
data(Prestige, package = "carData")
prestige.mod <- lm(prestige ~ income + education, data = Prestige)
stdcoef(prestige.mod)
#>    income education 
#> 0.3359243 0.6561537 

rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data = Rohwer)
stdcoef(rohwer.mod)
#>               SAT          PPVT        Raven
#> SES1  0.147027414  0.5067869165  0.255713484
#> n     0.202149151  0.0005263032  0.018048991
#> s     0.003769722 -0.0924254802  0.256124149
#> ns   -0.481088194 -0.0983270477  0.197100216
#> na    0.438041696  0.4835442475 -0.019473052
#> ss    0.187478718  0.1734997047 -0.008684568
```
