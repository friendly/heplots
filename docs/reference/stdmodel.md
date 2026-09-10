# Standardize a Fitted Linear Model

`stdmodel()` refits a fitted `lm`/`mlm` object on standardized (mean 0,
SD 1) versions of its response variable(s) and its numeric predictors,
leaving factor-coded predictors on their original (raw 0/1 dummy) scale.
This is the engine behind
[`stdcoef()`](https://friendly.github.io/heplots/reference/stdcoef.md)
for multivariate models, and behind `coefplot.mlm(..., std = TRUE)`.

Since the result is just an ordinary refit `"lm"`/`"mlm"` object, it
also works with other tools that expect one, e.g.
[`lmtest::coeftest()`](https://rdrr.io/pkg/lmtest/man/coeftest.html) and
[`broom::tidy.coeftest()`](https://broom.tidymodels.org/reference/tidy.coeftest.html)
on its result.

## Usage

``` r
stdmodel(object, ...)

# S3 method for class 'lm'
stdmodel(object, ...)
```

## Arguments

- object:

  A fitted `"lm"` or `"mlm"` object

- ...:

  Additional arguments. Not used.

## Value

The refit model, of the same class as `object`

## Details

Only the response(s) and *numeric* predictors are standardized; factor
predictors are left as-is, since "one SD" isn't a meaningful unit for a
0/1 dummy variable. This still gives an interpretable, commonly-used
effect size for factor predictors: "SD units of `y` per unit change in
the predictor."

Interactions and main effects of raw variables (e.g. `SES * (n + s)`)
are handled correctly, since
[`stats::model.frame()`](https://rdrr.io/r/stats/model.frame.html)
reduces a formula down to its base variables before any interaction
terms are built – refitting on the standardized base variables
reconstructs the interaction terms correctly.

Computed/transformed predictor terms (e.g. `log(x)`, `poly(x, 2)`) are
**not** supported and raise an error, since standardizing the *already
computed* column would not do what a user expects once the model is
refit and the original expression is re-evaluated. Similarly, a computed
univariate response (e.g. `log(y) ~ ...`) is not supported. Pre-compute
these if you want to use such variables.

`subset=`/`weights=`/`na.action=` in the original fitting call are not
specially handled – `stdmodel()` is designed for models fit directly via
`lm(formula, data = ...)`.

## See also

[`stdcoef()`](https://friendly.github.io/heplots/reference/stdcoef.md),
[`coefplot.mlm()`](https://friendly.github.io/heplots/reference/coefplot.md),
[`lmtest::coeftest()`](https://rdrr.io/pkg/lmtest/man/coeftest.html),
[`broom::tidy.coeftest()`](https://broom.tidymodels.org/reference/tidy.coeftest.html)

Other multivariate linear models:
[`coefplot()`](https://friendly.github.io/heplots/reference/coefplot.md),
[`glance.mlm()`](https://friendly.github.io/heplots/reference/glance.mlm.md),
[`stdcoef()`](https://friendly.github.io/heplots/reference/stdcoef.md)

## Author

Michael Friendly

## Examples

``` r
rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data = Rohwer)
coef(rohwer.mod)
#>                     SAT         PPVT        Raven
#> (Intercept)  2.63222809 39.787696418 11.539554838
#> SES1         4.39890814  8.438605540  0.792886532
#> n            1.60529134  0.002326037  0.014854078
#> s            0.02572959 -0.351086293  0.181169384
#> ns          -2.62735105 -0.298858164  0.111555592
#> na           2.10585136  1.293740583 -0.009701907
#> ss           0.92983272  0.478906033 -0.004463874

rohwer.std <- stdmodel(rohwer.mod)
coef(rohwer.std)
#>                      SAT          PPVT        Raven
#> (Intercept)  0.010654160  0.0367236896  0.018529963
#> SES1         0.147027414  0.5067869165  0.255713484
#> n            0.202149151  0.0005263032  0.018048991
#> s            0.003769722 -0.0924254802  0.256124149
#> ns          -0.481088194 -0.0983270477  0.197100216
#> na           0.438041696  0.4835442475 -0.019473052
#> ss           0.187478718  0.1734997047 -0.008684568
```
