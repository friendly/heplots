# Confidence Intervals for Trace of Covariance Matrices
#
# This implements asymptotic confidence intervals for the trace (sum of eigenvalues)
# of sample covariance matrices based on the CLT for linear spectral statistics.
#
# DONE: ✔️ Initial implementation using simplified Bai-Silverstein variance 12/28/2024

#' Calculate Confidence Interval for Trace of Covariance Matrices
#'
#' @description
#' This function uses asymptotic results from random matrix theory to calculate
#' approximate, normal theory confidence intervals for the trace (sum of eigenvalues)
#' of one or more sample covariance matrices.
#'
#' The trace of a covariance matrix equals the sum of its eigenvalues, which
#' represents the total variance in the system. For large samples, the trace
#' follows an approximate normal distribution with variance that can be
#' calculated from the eigenvalue structure.
#'
#' @details
#' The confidence interval is based on the asymptotic normality of the trace:
#' \deqn{ trace(\widehat{\Sigma}) \pm z_{1 - \alpha/2} \times SE }
#' where \eqn{\widehat{\Sigma}} is the sample covariance matrix and
#' \eqn{SE} is the standard error.
#'
#' The variance of the trace is calculated using the formula from
#' Bai & Silverstein (2004):
#' \deqn{ Var(trace) = \frac{2}{n} \sum_{i=1}^{p} \lambda_i^2 = \frac{2}{n} trace(\Sigma^2) }
#' where \eqn{\lambda_i} are the eigenvalues of \eqn{\Sigma}.
#'
#' This is a simplified version of the general CLT for linear spectral statistics.
#' For i.i.d. components with finite fourth moments, the trace is asymptotically
#' normal with this variance.
#'
#' **Asymptotic regime:** The theory applies when both sample size \eqn{n} and
#' dimension \eqn{p} can grow, typically requiring \eqn{n >> p} for good
#' finite-sample performance. The approximation improves as the sample size
#' increases.
#'
#' **Comparison with bootstrap:** For small to moderate samples, bootstrap
#' confidence intervals (see `eigstatCI()`) may provide better coverage.
#' This asymptotic approach is faster but may be anticonservative (too narrow)
#' when \eqn{n} is small relative to \eqn{p}.
#'
#' @param cov A covariance matrix or a (named) list of covariance matrices,
#'        all the same size
#' @param n Sample size, or vector of sample sizes, one for each covariance
#'        matrix
#' @param conf Confidence level (default: 0.95)
#'
#' @return A data frame with one row for each covariance matrix. Columns:
#'   \describe{
#'     \item{trace}{The trace (sum of eigenvalues) of the covariance matrix}
#'     \item{se}{Standard error of the trace}
#'     \item{lower}{Lower confidence limit}
#'     \item{upper}{Upper confidence limit}
#'   }
#'
#' @author Michael Friendly
#'
#' @seealso
#' `boxM()`, `plot.boxM()`, `logdetCI()`, `eigstatCI()`
#'
#' @references
#' Bai, Z. D., & Silverstein, J. W. (2004).
#' CLT for linear spectral statistics of large-dimensional sample covariance matrices.
#' *Annals of Probability*, 32(1A), 553-605.
#' \doi{10.1214/aop/1078415845}
#'
#' Anderson, T. W. (2003).
#' *An Introduction to Multivariate Statistical Analysis* (3rd ed.).
#' Wiley-Interscience.
#'
#' @keywords manip
#'
#' @examples
#' # Iris data example
#' data(iris)
#' iris.mod <- lm(as.matrix(iris[,1:4]) ~ iris$Species)
#' iris.boxm <- boxM(iris.mod)
#'
#' # Get covariance matrices
#' cov <- c(iris.boxm$cov, list(pooled = iris.boxm$pooled))
#' n <- c(rep(50, 3), 150)
#'
#' # Calculate trace CIs
#' CI <- traceCI(cov, n = n, conf = 0.95)
#' CI
#'
#' # Compare with plot
#' plot(iris.boxm, which = "sum", gplabel = "Species",
#'      main = "Sum of eigenvalues (trace)")
#' arrows(CI$lower, 1:4, CI$upper, 1:4,
#'        lwd = 3, angle = 90, length = 0.1, code = 3, col = "red")
#'
#' # Single covariance matrix
#' S <- cov(iris[,1:4])
#' traceCI(S, n = 150)
#'
#' # Compare different confidence levels
#' traceCI(cov, n = n, conf = 0.90)
#' traceCI(cov, n = n, conf = 0.95)
#' traceCI(cov, n = n, conf = 0.99)
#'
#' @export
traceCI <- function(cov, n, conf = 0.95) {

  # Input validation
  if (missing(cov)) {
    stop("Argument 'cov' is required")
  }
  if (missing(n)) {
    stop("Argument 'n' is required")
  }
  if (conf <= 0 || conf >= 1) {
    stop("Confidence level 'conf' must be between 0 and 1")
  }

  # Get dimension p and ensure all matrices are same size
  p <- if (is.list(cov)) {
    sapply(cov, nrow)
  } else {
    nrow(cov)
  }

  if (length(p) > 1) {
    if (!all(p == p[1])) {
      stop("All covariance matrices must be the same size")
    } else {
      p <- p[1]
    }
  }

  # Check sample size
  if (any(n <= p)) {
    warning(paste("Sample size n should be larger than dimension p =", p,
                  "for asymptotic theory to apply"))
  }

  # Calculate trace for each covariance matrix
  trace_vals <- if (is.list(cov)) {
    sapply(cov, function(S) sum(diag(S)))
  } else {
    sum(diag(cov))
  }

  # Calculate variance of trace
  # Var(trace) = 2/n * sum(lambda_i^2) = 2/n * trace(Sigma^2)
  trace_sq_vals <- if (is.list(cov)) {
    sapply(cov, function(S) sum(diag(S %*% S)))
  } else {
    sum(diag(cov %*% cov))
  }

  # Standard error
  var_trace <- 2 / n * trace_sq_vals
  se <- sqrt(var_trace)

  # Confidence interval
  z <- qnorm((1 - conf) / 2, lower.tail = FALSE)
  lower <- trace_vals - z * se
  upper <- trace_vals + z * se

  # Return as data frame
  result <- data.frame(
    trace = trace_vals,
    se = se,
    lower = lower,
    upper = upper,
    row.names = if (is.list(cov)) names(cov) else NULL
  )

  return(result)
}
