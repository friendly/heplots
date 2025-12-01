# Internal heplots functions

Internal functions for the heplots package

## Usage

``` r
lambda.crit(
  alpha,
  p,
  dfh,
  dfe,
  test.statistic = c("Roy", "HLT", "Hotelling-Lawley")
)

Roy.crit(alpha, p, dfh, dfe)

HLT.crit(alpha, p, dfh, dfe)

he.rep(x, n)

Pillai(eig, q, df.res)

Wilks(eig, q, df.res)

HL(eig, q, df.res)

Roy(eig, q, df.res)
```

## Arguments

- alpha:

  significance level for critical values of multivariate statistics

- p:

  Number of variables

- dfh:

  degrees of freedom for hypothesis

- dfe:

  degrees of freedom for error

- test.statistic:

  Test statistic used for the multivariate test

- x:

  An argument to
  [`heplot`](https://friendly.github.io/heplots/reference/heplot.md) or
  [`heplot3d`](https://friendly.github.io/heplots/reference/heplot3d.md)
  that is to be repeated for Error and all hypothesis terms

- n:

  Number of hypothesis terms

## Value

The critical value of the test statistic

## Details

These functions calculate critical values of multivariate test
statistics (Wilks' Lambda, Hotelling-Lawley trace, Roy's maximum root
test) used in setting the size of H ellipses relative to E. They are not
intended to be called by the user.

## Author

Michael Friendly <friendly@yorku.ca>
