#' @name rel_diff
#' @title Relative Difference between two Arrays or Data Frames
#'
#' @description
#'  
#' Calculates the relative difference, defined as
#' \deqn{\frac{\vert x - y \vert}{x} }
#' between two arrays or data frames, where \code{x} are considered reference values.
#'
#' @param x  An array or data frame, considered the reference values
#' @param y  Comparison array or data frame
#' @param pct Logical; if \code{TRUE} the relative differences are multiplied by 100, giving values in percent difference from \code{x}.
#' @param epsilon Threshold for values near zero
#' @return An array or data frame the same size as \code{x} and \code{y} containing the relative differences
#' @export
#' @examples
#' # example code
#' m1 <- cbind(c(0,1), c(1,1))
#' m2 <- cbind(c(0,1), c(1.01,1.11))
#' rel_diff(m1, m2, pct = FALSE) 
#' rel_diff(m1, m2) 

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