# Relative Difference between two Arrays or Data Frames

Calculates the relative difference, defined as \$\$\frac{\vert x - y
\vert}{x} \$\$ between two arrays or data frames, where `x` are
considered reference values.

## Usage

``` r
rel_diff(x, y, pct = TRUE, epsilon = 10 * .Machine$double.eps)
```

## Arguments

- x:

  An array or data frame, considered the reference values

- y:

  Comparison array or data frame

- pct:

  Logical; if `TRUE` the relative differences are multiplied by 100,
  giving values in percent difference from `x`.

- epsilon:

  Threshold for values near zero

## Value

An array or data frame the same size as `x` and `y` containing the
relative differences

## Details

Beyond the obvious, a natural use case is to compare coefficients for
alternative models for the same data, e.g., a classical and a robust
model.

## See also

`link{robmlm}`

## Examples

``` r
# simple example
m1 <- cbind(c(0,1), c(1,1))
m2 <- cbind(c(0,1), c(1.01,1.11))
rel_diff(m1, m2, pct = FALSE) 
#>      [,1] [,2]
#> [1,]    0 0.01
#> [2,]    0 0.11
rel_diff(m1, m2) 
#>      [,1] [,2]
#> [1,]    0    1
#> [2,]    0   11

# compare coefficients
data(Skulls)

# fit manova model, classically and robustly
sk.mlm <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
sk.rlm <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
rel_diff(coef(sk.mlm),
         coef(sk.rlm))
#>                       mb          bh           bl           nh
#> (Intercept)   0.01446592  0.08977463   0.04729215   0.08496078
#> epoch.L       3.46042186 -0.59951299  -3.48922244   3.87957519
#> epoch.Q     -20.74713900 -3.30993862 -51.99508454 125.92364818
#> epoch.C     -25.78059257 -1.43305167   4.19962200  -0.62550036
#> epoch^4      85.33424274  9.19478314 -15.44695305 -49.00471013
```
