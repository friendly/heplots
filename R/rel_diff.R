#' @name rel_diff
#' @title Relative Difference between two Arrays or Data Frames
#'
#' @description
#'  
#' Calculates the relative difference, defined as
#' \deqn{\frac{\vert x - y \vert}{x} }
#' between two arrays or data frames, where `x` are considered reference values.
#' 
#' @details
#' Beyond the obvious, a natural use case is to compare coefficients for alternative models for the same data, e.g., a classical
#' and a robust model.
#' 
#'
#' @param x  An array or data frame, considered the reference values
#' @param y  Comparison array or data frame
#' @param pct Logical; if `TRUE` the relative differences are multiplied by 100, giving values in percent difference from `x`.
#' @param epsilon Threshold for values near zero
#' @return An array or data frame the same size as `x` and `y` containing the relative differences
#' @export
#' @seealso \code{link{robmlm}}
#' @examples
#' # simple example
#' m1 <- cbind(c(0,1), c(1,1))
#' m2 <- cbind(c(0,1), c(1.01,1.11))
#' rel_diff(m1, m2, pct = FALSE) 
#' rel_diff(m1, m2) 
#' 
#' # compare coefficients
#' data(Skulls)
#' 
#' # fit manova model, classically and robustly
#' sk.mlm <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' sk.rlm <- robmlm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' rel_diff(coef(sk.mlm),
#'          coef(sk.rlm))

rel_diff <- function(x, y,
                     pct = TRUE,
                     epsilon = 10*.Machine$double.eps) {
  diff <- abs(x - y)
  mag <- pmax(abs(x)) # Use the maximum of the absolute values
  # Handle cases where both x is very close to zero
  diff <- ifelse(mag > epsilon, diff / x, 0)
  if (pct) diff <- 100 * diff
  diff
}
