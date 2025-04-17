# https://github.com/ggplot2-extenders/ggplot-extension-club/discussions/91
# library(ggplot2)
# library(ggrepel)

#' Label noteworthy (unusual) points in a 2D scatterplot
#' 
#' @description
#' An important feature of many statistical plots is the ability to label "unusual" or "noteworthy"
#' observations such as those with large residuals, high leverage, or those outside a given confidence
#' envelope in a QQ plot. \code{stat_noteworthy} provides a wide variety of methods for doing this.
#' 
#' Standard methods include Mahalanobis  and Euclidean distance from the centroid \eqn{(\bar{x}, \bar{y})},
#' absolute value of distance from the mean of x or y, absolute value \eqn{|y|} of y  and absolute value of 
#' the residual in a model \code{y ~ x}.
#' 


# Class
StatNoteworthy <- ggproto(
  "StatNoteworthy", Stat,
  
  required_aes = c("x", "y"),
  
  compute_group = function(data, scales, method = "mahal", n = 5, level = NULL) {
    idx <- heplots::noteworthy(x = data$x, y = data$y, n = n, method = method, level = level)
    data[idx, , drop = FALSE]
  }
)

# Constructor: standard stuff + method + n
stat_noteworthy <- function(
    mapping = NULL, data = NULL, geom = "text", position = "identity",
    ..., method = "mahal", n = 5, level = NULL,
    na.rm = FALSE, show.legend = NA, inherit.aes = TRUE
) {
  layer(
    data = data, mapping = mapping, stat = StatNoteworthy, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = rlang::list2(
      method = method,
      n = n,
      level = level,
      ...
    )
  )
}

if(FALSE) {
# Examples
gp <- ggplot(mpg, aes(x = displ, y = hwy, label = model)) +
  geom_point() 

# default: method = "mahal"
gp + stat_noteworthy()

# specify level to filter by qchisq() > level 
gp + stat_noteworthy(n = 10, level = 0.99)

# use ggrepel
gp + stat_noteworthy(geom = "text_repel")
gp + stat_noteworthy(geom = "label_repel")

gp + stat_noteworthy(method = "x")
gp + stat_noteworthy(method = "y")
gp + stat_noteworthy(method = "ry")

# select cases using row IDs
gp + stat_noteworthy(method = seq(10, 100, 20))

# select cases using a computed vector
mod <- lm(hwy ~ displ, data=mpg)
gp + stat_noteworthy(method = cooks.distance(mod))
gp + stat_noteworthy(method = hatvalues(mod))


# Try with Penguins data

data(peng, package = "heplots")
# Multivariate outliers, using *all* numeric variables
DSQ <- heplots::Mahalanobis(peng[, 3:6])
noteworthy <- order(DSQ, decreasing = TRUE)[1:3] |> print()
#> [1] 283  10  35

}



