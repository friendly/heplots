# Draw an Ellipsoid in an rgl Scene

This is an experimental function designed to separate internal code in
`link{heplot3d}`.

## Usage

``` r
Ellipsoid(x, ...)

# S3 method for class 'data.frame'
Ellipsoid(x, which = 1:3, method = c("classical", "mve", "mcd"), ...)

# Default S3 method
Ellipsoid(
  x,
  center = c(0, 0, 0),
  which = 1:3,
  radius = 1,
  df = Inf,
  label = "",
  cex.label = 1.5,
  col = "pink",
  lwd = 1,
  segments = 40,
  shade = TRUE,
  alpha = 0.1,
  wire = TRUE,
  verbose = FALSE,
  warn.rank = FALSE,
  ...
)
```

## Arguments

- x:

  An object. In the default method the parameter x should be a square
  positive definite matrix at least 3x3 in size. It will be treated as
  the correlation or covariance of a multivariate normal distribution.
  For the `data.frame` method, it should be a numeric data frame with at
  least 3 columns.

- ...:

  Other arguments

- which:

  This parameter selects which variables from the object will be
  plotted. The default is the first 3.

- method:

  the covariance method to be used: classical product-moment
  (`"classical"`), or minimum volume ellipsoid (`"mve"`), or minimum
  covariance determinant (`"mcd"`

- center:

  center of the ellipsoid, a vector of length 3, typically the mean
  vector of data

- radius:

  size of the ellipsoid

- df:

  degrees of freedom associated with the covariance matrix, used to
  calculate the appropriate F statistic

- label:

  label for the ellipsoid

- cex.label:

  text size of label

- col:

  color of the ellipsoid

- lwd:

  line with for the wire-frame version

- segments:

  number of segments composing each ellipsoid; defaults to `40`.

- shade:

  logical; should the ellipsoid be smoothly shaded?

- alpha:

  transparency of the shaded ellipsoid

- wire:

  logical; should the ellipsoid be drawn as a wire frame?

- verbose:

  logical; for debugging

- warn.rank:

  logical; warn if the ellipsoid is less than rank 3?

## Value

returns the bounding box of the ellipsoid invisibly; otherwise used for
it's side effect of drawing the ellipsoid

## Examples

``` r
# none yet
```
