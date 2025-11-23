# Measures of Partial Association (\\\eta^2\\) for Linear Models

Calculates partial eta-squared for linear models or multivariate analogs
of eta-squared (or R^2), indicating the partial association for each
term in a multivariate linear model. For a multivariate model, this is a
summary across all response variables.

## Usage

``` r
etasq(x, ...)

# S3 method for class 'mlm'
etasq(x, ...)

# S3 method for class 'Anova.mlm'
etasq(x, anova = FALSE, ...)

# S3 method for class 'lm'
etasq(x, anova = FALSE, partial = TRUE, ...)
```

## Arguments

- x:

  A `lm`, `mlm` or `Anova.mlm` object

- ...:

  Other arguments passed down to
  [`Anova`](https://rdrr.io/pkg/car/man/Anova.html).

- anova:

  A logical, indicating whether the result should also contain the test
  statistics produced by
  [`Anova()`](https://rdrr.io/pkg/car/man/Anova.html).

- partial:

  A logical, indicating whether to calculate partial or classical eta^2.

## Value

When `anova=FALSE`, a one-column data frame containing the eta-squared
values for each term in the model.

When `anova=TRUE`, a 5-column (lm) or 7-column (mlm) data frame
containing the eta-squared values and the test statistics produced by
`print.Anova()` for each term in the model.

## Details

There is a different analog of \\\eta^2\\ for each of the four standard
multivariate test statistics: Pillai's trace, Hotelling-Lawley trace,
Wilks' Lambda and Roy's maximum root test.

For univariate linear models, classical \\\eta^2\\ = SSH / SST and
partial \\\eta^2\\ = SSH / (SSH + SSE). These are identical in one-way
designs.

Partial eta-squared describes the proportion of total variation
attributable to a given factor, partialling out (excluding) other
factors from the total nonerror variation. These are commonly used as
measures of effect size or measures of (non-linear) strength of
association in ANOVA models.

All multivariate tests are based on the \\s=min(p, df_h)\\ latent roots
of \\H E^{-1}\\. The analogous multivariate partial \\\eta^2\\ measures
are calculated as:

- Pillai's trace (V):

  \\\eta^2 = V/s\\

- Hotelling-Lawley trace (T):

  \\\eta^2 = T/(T+s)\\

- Wilks' Lambda (L):

  \\\eta^2 = L^{1/s}\\

- Roy's maximum root (R):

  \\\eta^2 = R/(R+1)\\

## References

Muller, K. E. and Peterson, B. L. (1984). Practical methods for
computing power in testing the Multivariate General Linear Hypothesis
*Computational Statistics and Data Analysis*, **2**, 143-158.

Muller, K. E. and LaVange, L. M. and Ramey, S. L. and Ramey, C. T.
(1992). Power Calculations for General Linear Multivariate Models
Including Repeated Measures Applications. *Journal of the American
Statistical Association*, **87**, 1209-1226.

## See also

[`Anova`](https://rdrr.io/pkg/car/man/Anova.html)

[`eta_squared`](https://easystats.github.io/effectsize/reference/eta_squared.html)
for a function that calculates this effect size measure for each
response variable separately.

## Author

Michael Friendly

## Examples

``` r
library(car)
data(Soils, package="carData")
soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth, data=Soils)
#Anova(soils.mod)
etasq(Anova(soils.mod))
#>                   eta^2
#> Block         0.5585973
#> Contour       0.6692989
#> Depth         0.5983772
#> Contour:Depth 0.2058495
etasq(soils.mod) # same
#>                   eta^2
#> Block         0.5585973
#> Contour       0.6692989
#> Depth         0.5983772
#> Contour:Depth 0.2058495
etasq(Anova(soils.mod), anova=TRUE)
#> 
#> Type II MANOVA Tests: Pillai test statistic
#>                 eta^2 Df test stat approx F num Df den Df    Pr(>F)    
#> Block         0.55860  3    1.6758   3.7965     27     81 1.777e-06 ***
#> Contour       0.66930  2    1.3386   5.8468     18     52 2.730e-07 ***
#> Depth         0.59838  3    1.7951   4.4697     27     81 8.777e-08 ***
#> Contour:Depth 0.20585  6    1.2351   0.8640     54    180    0.7311    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

etasq(soils.mod, test="Wilks")
#>                   eta^2
#> Block         0.5701385
#> Contour       0.7434504
#> Depth         0.8294239
#> Contour:Depth 0.2250388
etasq(soils.mod, test="Hotelling")
#>                   eta^2
#> Block         0.5823516
#> Contour       0.8009753
#> Depth         0.9421533
#> Contour:Depth 0.2456774
```
