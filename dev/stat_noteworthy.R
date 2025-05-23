# https://github.com/ggplot2-extenders/ggplot-extension-club/discussions/91
# library(ggplot2)
# library(ggrepel)

#' Selectively label noteworthy (unusual) points in a 2D scatterplot
#' 
#' @description
#' An important feature of many statistical plots is the ability to selectively label "unusual" or "noteworthy"
#' observations such as those with large residuals, high leverage, or those outside a given confidence
#' envelope in a QQ plot. \code{stat_noteworthy} provides a wide variety of methods for doing this.
#' 
#' Standard methods include Mahalanobis  and Euclidean distance from the centroid \eqn{(\bar{x}, \bar{y})},
#' absolute value of distance from the mean of x or y, absolute value \eqn{|y|} of y  and absolute value of 
#' the residual in a model \code{y ~ x}.
#' 
#' In simple cases, such labels can be added to a ggplot object using \code{stat_noteworthy()} directly, with a choice of
#' \code{geom} to draw the label (e.g., \code{"text", "label", "repel"}).
#' Alternatively, you can use \code{geom_text()}, \code{geom_label()}, ... and specify
#' \code{stat = StatNoteworthy} to select the points to be labeled
#' 
#' @details
#' 
#' The `method` argument determines how the points to be identified are selected:
#' \describe{
#'  \item{\code{"mahal"}}{Treat (x, y) as if it were a bivariate sample, 
#'       and select cases according to their Mahalanobis distance from \code{(mean(x), mean(y))}.}
#'  \item{\code{"dsq"}}{Similar to \code{"mahal"} but uses squared Euclidean distance.}  
#'  \item{\code{"x"}}{Select points according to their value of \code{abs(x - mean(x))}.}
#'  \item{\code{"y"}}{Select points according to their value of \code{abs(y - mean(y))}.}
#'  \item{\code{"r"}}{Select points according to their value of \code{abs(y)}, as may be appropriate 
#'       in residual plots, or others with a meaningful origin at 0, such as a chi-square QQ plot.}
#'  \item{\code{"ry"}}{Fit the linear model, \code{y ~ x} and select points according to their absolute residuals.}
#'  \item{case IDs}{\code{method} can be an integer vector of case numbers in \code{1:length{x}}, in which case those cases 
#'       will be labeled.}
#'  \item{numeric vector}{\code{method} can be a vector of the same length as x consisting of values to determine the points 
#'       to be labeled. For example, for a linear model \code{mod}, setting \code{method=cooks.distance(mod)} will label the 
#'       \code{n} points corresponding to the largest values of Cook's distance. Warning: If missing data are present, 
#'       points may be incorrectly selected.}
#' }
#' 
#' In the case of \code{method == "mahal"} a value for \code{level} can be supplied.
#' This is used as a filter to select cases whose criterion value
#' exceeds \code{level}. In this case, the number of points identified will be less than or equal to \code{n}.
#' 


#' StatNoteworthy
#' @rdname stat_noteworthy
#' @importFrom dplyr row_number
#' @format NULL
#' @usage NULL
#' @keywords internal
#' @export

StatNoteworthy <- ggproto(
  "StatNoteworthy", Stat,
  
  required_aes = c("x", "y"),
  
  # using compute_group rather than compute_panel here would allow for factor aesthetics
  compute_panel = function(data, scales, method = "mahal", n = 5, level = NULL) {
    
    data <- data |>
      mutate(id = dplyr::row_number())   # use `.id` here to avoid name clash?
    
    idx <- heplots::noteworthy(x = data$x, y = data$y, n = n, method = method, level = level)
    data[idx, , drop = FALSE]
  },
  
  default_aes = aes(label = after_stat(id))   # << set default label to row number  
  
)


#' 
#' @rdname stat_noteworthy
#' @inheritParams ggplot2 layer
#' @inheritParams ggplot2 geom_point
#' @importFrom rlang list2
#' @importFrom ggplot2 layer
#' @export
#' 

# Constructor: standard stuff + method + n + level
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
ids <- order(DSQ, decreasing = TRUE)[1:3] |> print()
#> [1] 283  10  35



ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_point() +
  #  scale_size_manual(values = c(1.5, 4)) +
  # geom_text(data = subset(peng_plot, note==TRUE),
  #           aes(label = id),
  #           nudge_y = .4, color = "black", size = 5) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.1) +
  stat_noteworthy(method = ids, label = ids)
  
# Test Gina's modifications

peng |> 
  dplyr::select(x = bill_length, y = bill_depth) |>
  StatNoteworthy$compute_panel(n=3)

# penguin colors
peng_colors <- c(
  "Adelie"    = "darkorange",
  "Chinstrap" = "purple",
  "Gentoo"    =  "cyan4"
  )


gpeng <- ggplot(peng, 
               aes(x = bill_length, 
                   y = bill_depth,
                   color = species, 
                   shape = species)) +
  geom_point() +
  geom_smooth(method = "lm", 
              formula = y ~ x,
              se = FALSE, 
              linewidth = 2) +
  stat_ellipse(aes(fill = species),
               geom = "polygon", level = 0.95, alpha = 0.1) +
  scale_color_manual(values = peng_colors) +
  scale_fill_manual(values = peng_colors) 
gpeng

gpeng + 
  geom_text(stat = StatNoteworthy, method = ids, n = 3, color = "black", size = 5)

gpeng + 
  geom_label(stat = StatNoteworthy, method = ids, n = 3, size = 5)



# DOESN'T WORK
gpeng + 
  stat_noteworthy(method = ids, label = ids)
}



