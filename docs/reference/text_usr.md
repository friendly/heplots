# Add Text to a Plot at Normalized Device Coordinates

`text_usr()` draws the strings given in the vector labels at the
coordinates given by `x` and `y`, but using normalized device
coordinates (0, 1) to position text at absolute locations in a plot.
This is useful when you know where in a plot you want to add some text
annotation, but don't want to figure out what the data coordinates are.

## Usage

``` r
text_usr(x, y, labels, ...)
```

## Source

From
<https://stackoverflow.com/questions/25450719/plotting-text-in-r-at-absolute-position>

## Arguments

- x, y:

  numeric vectors of coordinates in (0, 1) where the text `labels`
  should be written. If the length of `x` and `y` differs, the shorter
  one is recycled. Alternatively, a single argument `x` can be provided.

- labels:

  a character vector or
  [`expression`](https://rdrr.io/r/base/expression.html) specifying the
  text to be written

- ...:

  other arguments passed to
  [`text`](https://rdrr.io/r/graphics/text.html), such as `pos`, `cex`,
  `col`, ...

## Details

`y` may be missing since
[`xy.coords`](https://rdrr.io/r/grDevices/xy.coords.html) is used for
construction of the coordinates.

The function also works with `par(xlog) == TRUE` and `par(ylog) == TRUE`
when either of these is set for log scales.

## Examples

``` r
library(heplots)
x = c(0.5, rep(c(0.05, 0.95), 2))
y = c(0.5, rep(c(0.05, 0.95), each=2))
plot(x, y, pch = 16,
     xlim = c(0,1),
     ylim = c(0,1))
text_usr(0.05, 0.95, "topleft",    pos = 4)
text_usr(0.95, 0.95, "topright",   pos = 2)
text_usr(0.05, 0.05, "bottomleft", pos = 4)
text_usr(0.95, 0.05, "bottomright",pos = 2)

```
