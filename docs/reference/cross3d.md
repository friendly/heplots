# Draw a 3D cross in an rgl scene

Draws a 3D cross or axis vectors in an rgl scene.

## Usage

``` r
cross3d(centre = rep(0, 3), scale = rep(1, 3), ...)
```

## Arguments

- centre:

  A scalar or vector of length 3, giving the centre of the 3D cross

- scale:

  A scalar or vector of length 3, giving the lengths of the arms of the
  3D cross

- ...:

  Other arguments, passed on to
  [`segments3d`](https://dmurdoch.github.io/rgl/dev/reference/primitives.html)

## Value

Used for its side-effect, but returns (invisibly) a 6 by 3 matrix
containing the end-points of three axes, in pairs.

## See also

[`segments3d`](https://dmurdoch.github.io/rgl/dev/reference/primitives.html)

## Author

Michael Friendly
