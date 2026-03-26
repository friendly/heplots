# Find the bounding box of a `rgl::mesh3d` or `rgl::qmesh3d` object

Ellipsoids are created by rgl functions as meshes of points, segments,
... from coordinates in various forms. This function calculates the
bounding box, defined as the range of the x, y, and z coordinates.

## Usage

``` r
bbox3d(x, ...)
```

## Arguments

- x:

  A mesh3d object

- ...:

  ignored

## Value

    A 2 x 3 matrix, giving the minimum and maximum values in the rows and x, y, z coordinates
            in the columns.

## See also

Other 3D plotting:
[`arrow3d()`](https://friendly.github.io/heplots/reference/arrow3d.md),
[`cross3d()`](https://friendly.github.io/heplots/reference/cross3d.md),
[`ellipse3d.axes()`](https://friendly.github.io/heplots/reference/ellipse3d.axes.md),
[`heplot3d()`](https://friendly.github.io/heplots/reference/heplot3d.md)
