# Calculate column deviations from central values

`colDevs` calculates the column deviations of data values from a central
value (mean, median, etc.), possibly stratified by a grouping variable.

## Usage

``` r
colDevs(x, group, center = mean, group.var = FALSE, ...)
```

## Arguments

- x:

  A numeric data frame or matrix.

- group:

  A factor (or variable that can be coerced to a factor) indicating the
  membership of each observation in `x` in one or more groups. If
  missing, all the data is treated as a single group. You can also
  specify the [`interaction`](https://rdrr.io/r/base/interaction.html)
  of two or more factors.

- center:

  A function used to center the values (for each group if `group` is
  specified. The function must take a vector argument and return a
  scalar result.

- group.var:

  logical or character. If `TRUE`, the `group` variable containing
  factor levels is prepended to the matrix of deviations. If a character
  variable, this is taken as the name to be used for the group variable.

- ...:

  Arguments passed down

## Value

By default, it returns a numeric matrix containing the deviations from
the centering function. If `levels==TRUE`, it returns a data.frame
containing the group factor prepended to the matrix of deviations.

## Details

Conceptually, the function is similar to a column-wise
[`sweep`](https://rdrr.io/r/base/sweep.html), by group, allowing an
arbitrary `center` function.

Non-numeric columns of `x` are removed, with a warning.

## See also

[`colMeans`](https://rdrr.io/r/base/colSums.html) for column means,

[`sweep`](https://rdrr.io/r/base/sweep.html)

## Author

Michael Friendly

## Examples

``` r
data(iris)

Species <- iris$Species
irisdev <- colDevs(iris[,1:4], Species, mean)

irisdev <- colDevs(iris[,1:4], Species, median)
# trimmed mean, using an anonymous function
irisdev <- colDevs(iris[,1:4], Species, function(x) mean(x, trim=0.25))

# include the group factor in output
irisdev <- colDevs(iris[,1:4], Species, group.var = "Species")
head(irisdev)
#>   Species Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1  setosa        0.094       0.072       -0.062      -0.046
#> 2  setosa       -0.106      -0.428       -0.062      -0.046
#> 3  setosa       -0.306      -0.228       -0.162      -0.046
#> 4  setosa       -0.406      -0.328        0.038      -0.046
#> 5  setosa       -0.006       0.172       -0.062      -0.046
#> 6  setosa        0.394       0.472        0.238       0.154

# no grouping variable: deviations from column grand means
# include all variables (but suppress warning for this doc)
irisdev <- suppressWarnings( colDevs(iris) )

# two-way design
colDevs(Plastic[,1:3], Plastic[,"rate"])
#>     tear gloss opacity
#> 1   0.01 -0.07    0.61
#> 2  -0.29  0.33    2.61
#> 3  -0.69  0.03   -0.79
#> 4   0.01  0.03    0.31
#> 5   0.01 -0.37   -2.99
#> 6   0.41 -0.47    1.91
#> 7   0.71  0.43   -1.79
#> 8   0.41  0.33    0.11
#> 9  -0.39 -0.07   -1.89
#> 10 -0.19 -0.17    1.91
#> 11 -0.38  0.04   -1.28
#> 12 -0.48  0.24    0.02
#> 13  0.12 -0.76   -0.28
#> 14  0.02 -0.66   -2.48
#> 15 -0.28 -0.56   -0.68
#> 16  0.02  0.14    4.32
#> 17 -0.08 -0.26    1.12
#> 18  0.12  0.64    2.82
#> 19  0.42  1.04   -1.38
#> 20  0.52  0.14   -2.18
colDevs(Plastic[,1:3], Plastic[,"additive"])
#>     tear gloss opacity
#> 1  -0.09  0.36    0.96
#> 2  -0.39  0.76    2.96
#> 3  -0.79  0.46   -0.44
#> 4  -0.09  0.46    0.66
#> 5  -0.09  0.06   -2.64
#> 6  -0.08 -0.39    1.27
#> 7   0.22  0.51   -2.43
#> 8  -0.08  0.41   -0.53
#> 9  -0.88  0.01   -2.53
#> 10 -0.68 -0.09    1.27
#> 11  0.11 -0.04   -0.64
#> 12  0.01  0.16    0.66
#> 13  0.61 -0.84    0.36
#> 14  0.51 -0.74   -1.84
#> 15  0.21 -0.64   -0.04
#> 16  0.12 -0.29    3.97
#> 17  0.02 -0.69    0.77
#> 18  0.22  0.21    2.47
#> 19  0.52  0.61   -1.73
#> 20  0.62 -0.29   -2.53
# cell deviations
#' colDevs(Plastic[,1:3], interaction(Plastic[,c("rate", "additive")]))
```
