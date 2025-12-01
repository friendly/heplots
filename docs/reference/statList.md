# Calculate statistics for levels of factors

`statList` provides a general method for calculating univariate or
multivariate statistics for a matrix or data.frame stratified by one or
more factors.

## Usage

``` r
statList(X, factors, FUN, drop = FALSE, ...)
```

## Arguments

- X:

  A matrix or data frame containing the variables to be summarized

- factors:

  A vector, matrix or data frame containing the factors for which `X` is
  to be summarized. If `factors` is not specified, the result is
  calculated for all of the data in `X`.

- FUN:

  A function to be applied to the pieces of `X`, as split by `factors`.

- drop:

  Logical, indicating whether empty levels of `factors` are to be
  dropped from the result.

- ...:

  Other arguments, passed to `FUN`.

## Value

Returns a list of items corresponding to the unique elements in
`factors`, or the interaction of `factors`. Each item is the result of
applying `FUN` to that collection of rows of `X`. The items are named
according to the levels in `factors`.

## Details

`statList` is the general function. `X` is first `split` by `factors`,
and `FUN` is applied to the result.

`colMeansList` and `covList` are just calls to `statList` with the
appropriate `FUN`.

## See also

[`colMeans`](https://rdrr.io/r/base/colSums.html),
[`termMeans`](https://friendly.github.io/heplots/reference/termMeans.md)

## Author

Michael Friendly

## Examples

``` r
# grand means
statList(iris[,1:4], FUN=colMeans)
#> [[1]]
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>     5.843333     3.057333     3.758000     1.199333 
#> 
# species means
statList(iris[,1:4], iris$Species, FUN=colMeans)
#> $setosa
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        5.006        3.428        1.462        0.246 
#> 
#> $versicolor
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        5.936        2.770        4.260        1.326 
#> 
#> $virginica
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        6.588        2.974        5.552        2.026 
#> 
# same
colMeansList(iris[,1:4], iris$Species)
#> $setosa
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        5.006        3.428        1.462        0.246 
#> 
#> $versicolor
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        5.936        2.770        4.260        1.326 
#> 
#> $virginica
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        6.588        2.974        5.552        2.026 
#> 

# var-cov matrices, by species
covList(iris[,1:4], iris$Species)
#> $setosa
#>              Sepal.Length Sepal.Width Petal.Length Petal.Width
#> Sepal.Length   0.12424898 0.099216327  0.016355102 0.010330612
#> Sepal.Width    0.09921633 0.143689796  0.011697959 0.009297959
#> Petal.Length   0.01635510 0.011697959  0.030159184 0.006069388
#> Petal.Width    0.01033061 0.009297959  0.006069388 0.011106122
#> 
#> $versicolor
#>              Sepal.Length Sepal.Width Petal.Length Petal.Width
#> Sepal.Length   0.26643265  0.08518367   0.18289796  0.05577959
#> Sepal.Width    0.08518367  0.09846939   0.08265306  0.04120408
#> Petal.Length   0.18289796  0.08265306   0.22081633  0.07310204
#> Petal.Width    0.05577959  0.04120408   0.07310204  0.03910612
#> 
#> $virginica
#>              Sepal.Length Sepal.Width Petal.Length Petal.Width
#> Sepal.Length   0.40434286  0.09376327   0.30328980  0.04909388
#> Sepal.Width    0.09376327  0.10400408   0.07137959  0.04762857
#> Petal.Length   0.30328980  0.07137959   0.30458776  0.04882449
#> Petal.Width    0.04909388  0.04762857   0.04882449  0.07543265
#> 

# multiple factors
iris$Dummy <- sample(c("Hi","Lo"),150, replace=TRUE)
colMeansList(iris[,1:4], iris[,5:6])
#> $setosa.Hi
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>    5.0363636    3.4954545    1.4363636    0.2545455 
#> 
#> $versicolor.Hi
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>     6.007407     2.766667     4.277778     1.329630 
#> 
#> $virginica.Hi
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        6.476        2.936        5.564        1.968 
#> 
#> $setosa.Lo
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>    4.9821429    3.3750000    1.4821429    0.2392857 
#> 
#> $versicolor.Lo
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>     5.852174     2.773913     4.239130     1.321739 
#> 
#> $virginica.Lo
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        6.700        3.012        5.540        2.084 
#> 


```
