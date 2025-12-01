# Draw a 3D Arrow in an RGL Scene

Draws a 3D arrow in an rgl scene with barbs at the arrow head

## Usage

``` r
arrow3d(
  p0 = c(0, 0, 0),
  p1 = c(1, 1, 1),
  barblen,
  s = 0.05,
  theta = pi/6,
  n = 3,
  ...
)
```

## Arguments

- p0:

  Initial point (tail of arrow)

- p1:

  Ending point (head of arrow)

- barblen:

  Length of each barb, in data units

- s:

  length of barb as fraction of line length (unless barblen is
  specified)

- theta:

  opening angle of barbs

- n:

  number of barbs

- ...:

  args passed to lines3d for line styling, e.g., `color`, `lwd`, etc.
  See
  [`material3d`](https://dmurdoch.github.io/rgl/dev/reference/material.html).

## Value

Returns (invisibly): integer ID of the line added to the scene %%

## See also

[`lines3d`](https://dmurdoch.github.io/rgl/dev/reference/primitives.html),
[`segments3d`](https://dmurdoch.github.io/rgl/dev/reference/primitives.html),

## Author

Barry Rowlingson, posted to R-help, 1/10/2010

## Examples

``` r
arrow3d(c(0,0,0), c(2,2,2), barblen=.2, lwd=3, col="black")
arrow3d(c(0,0,0), c(-2,2,2), barblen=.2, lwd=3, col="red")
```
