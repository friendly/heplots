# Make Colors Transparent

Takes a vector of colors (as color names or rgb hex values) and adds a
specified alpha transparency to each.

## Usage

``` r
trans.colors(col, alpha = 0.5, names = NULL)
```

## Arguments

- col:

  A character vector of colors, either as color names or rgb hex values

- alpha:

  alpha transparency value(s) to apply to each color (0 means fully
  transparent and 1 means opaque)

- names:

  optional character vector of names for the colors

## Value

A vector of color values of the form `"#rrggbbaa"`

## Details

Colors (`col`) and `alpha` need not be of the same length. The shorter
one is replicated to make them of the same length.

## See also

[`col2rgb`](https://rdrr.io/r/grDevices/col2rgb.html),
[`rgb`](https://rdrr.io/r/grDevices/rgb.html),
[`adjustcolor`](https://rdrr.io/r/grDevices/adjustcolor.html),

## Author

Michael Friendly

## Examples

``` r
trans.colors(palette(), alpha=0.5)
#> [1] "#00000080" "#DF536B80" "#61D04F80" "#2297E680" "#28E2E580" "#CD0BBC80"
#> [7] "#F5C71080" "#9E9E9E80"

# alpha can be vectorized
trans.colors(palette(), alpha=seq(0, 1, length=length(palette())))
#> [1] "#00000000" "#DF536B24" "#61D04F49" "#2297E66D" "#28E2E592" "#CD0BBCB6"
#> [7] "#F5C710DB" "#9E9E9EFF"

# lengths need not match: shorter one is repeated as necessary
trans.colors(palette(), alpha=c(.1, .2))
#> [1] "#0000001A" "#DF536B33" "#61D04F1A" "#2297E633" "#28E2E51A" "#CD0BBC33"
#> [7] "#F5C7101A" "#9E9E9E33"

trans.colors(colors()[1:20])
#>  [1] "#FFFFFF80" "#F0F8FF80" "#FAEBD780" "#FFEFDB80" "#EEDFCC80" "#CDC0B080"
#>  [7] "#8B837880" "#7FFFD480" "#7FFFD480" "#76EEC680" "#66CDAA80" "#458B7480"
#> [13] "#F0FFFF80" "#F0FFFF80" "#E0EEEE80" "#C1CDCD80" "#838B8B80" "#F5F5DC80"
#> [19] "#FFE4C480" "#FFE4C480"

# single color, with various alphas
trans.colors("red", alpha=seq(0,1, length=5))
#> [1] "#FF000000" "#FF000040" "#FF000080" "#FF0000BF" "#FF0000FF"
# assign names
trans.colors("red", alpha=seq(0,1, length=5), names=paste("red", 1:5, sep=""))
#>        red1        red2        red3        red4        red5 
#> "#FF000000" "#FF000040" "#FF000080" "#FF0000BF" "#FF0000FF" 

```
