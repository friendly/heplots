# Bootstrap Confidence Intervals for Eigenvalue-Based Statistics
#
# This provides bootstrap CIs for eigenvalue statistics (product, sum, precision, max)
# of covariance matrices, to complement the analytic logdetCI() function.

#' Bootstrap Confidence Intervals for Eigenvalue Statistics
#'
#' @description
#' Computes bootstrap confidence intervals for statistics based on eigenvalues
#' of grouped covariance matrices. This is intended for use with `plot.boxM()`
#' to provide confidence intervals for measures beyond the default "logDet".
#'
#' @details
#' For each group (and the pooled data), this function performs nonparametric
#' bootstrap resampling to estimate the sampling distribution of the specified
#' eigenvalue-based statistic. Confidence intervals are computed using the
#' percentile method or bias-corrected and accelerated (BCa) method.
#'
#' Unlike `logdetCI()` which uses analytic approximations based on asymptotic
#' theory, this function makes no distributional assumptions and can handle
#' small to moderate sample sizes, though computational cost increases with
#' the number of bootstrap replicates.
#'
#' @param Y A numeric matrix of response variables (n x p)
#' @param group A factor or vector specifying group membership
#' @param which The eigenvalue-based statistic to compute. One of:
#'        \describe{
#'          \item{product}{Product of eigenvalues (= determinant)}
#'          \item{sum}{Sum of eigenvalues (= trace)}
#'          \item{precision}{Harmonic mean of eigenvalues}
#'          \item{max}{Maximum eigenvalue}
#'        }
#' @param R Number of bootstrap replicates. Default is 1000.
#' @param conf Confidence level for intervals (0 < conf < 1). Default is 0.95.
#' @param type Type of bootstrap confidence interval. Options:
#'        \describe{
#'          \item{perc}{Percentile method (default, most robust)}
#'          \item{bca}{Bias-corrected and accelerated}
#'          \item{norm}{Normal approximation}
#'          \item{basic}{Basic bootstrap}
#'        }
#' @param parallel Logical or character string. If TRUE, use parallel processing
#'        via the boot package. Can also be "multicore" or "snow". Default is FALSE.
#' @param ncpus Number of CPUs to use if parallel=TRUE. Default is 2.
#' @param seed Random seed for reproducibility. If NULL, no seed is set.
#' @param ... Additional arguments (currently unused)
#'
#' @return A data frame with one row for each group plus the pooled data.
#'         Columns include:
#'         \describe{
#'           \item{group}{Group name (factor level)}
#'           \item{statistic}{Observed value of the statistic}
#'           \item{lower}{Lower confidence limit}
#'           \item{upper}{Upper confidence limit}
#'           \item{bias}{Bootstrap estimate of bias (if available)}
#'           \item{se}{Bootstrap standard error (if available)}
#'         }
#'
#' @author Michael Friendly
#'
#' @seealso \code{\link{boxM}}, \code{\link{plot.boxM}}, \code{\link{logdetCI}}
#'
#' @references
#' Efron, B., & Tibshirani, R. J. (1994).
#' \emph{An Introduction to the Bootstrap}. CRC Press.
#'
#' @examples
#' \dontrun{
#' library(boot)
#' data(iris)
#'
#' # Bootstrap CI for product of eigenvalues
#' CI_prod <- eigstatCI(iris[,1:4], iris$Species, which="product", R=500)
#' CI_prod
#'
#' # Bootstrap CI for sum of eigenvalues (= trace)
#' CI_sum <- eigstatCI(iris[,1:4], iris$Species, which="sum", R=500)
#' CI_sum
#'
#' # Use with parallel processing for speed
#' CI_max <- eigstatCI(iris[,1:4], iris$Species, which="max",
#'                     R=1000, parallel=TRUE, ncpus=4)
#' }
#'
#' @importFrom boot boot boot.ci
#' @export
eigstatCI <- function(Y,
                      group,
                      which = c("product", "sum", "precision", "max"),
                      R = 1000,
                      conf = 0.95,
                      type = c("perc", "bca", "norm", "basic"),
                      parallel = FALSE,
                      ncpus = 2,
                      seed = NULL,
                      ...) {

  # Match arguments
  which <- match.arg(which)
  type <- match.arg(type)

  # Input validation
  if (!is.matrix(Y)) Y <- as.matrix(Y)
  if (!is.factor(group)) group <- as.factor(as.character(group))

  # Check for missing data
  valid <- complete.cases(Y, group)
  if (sum(!valid) > 0) {
    warning(glue::glue("{sum(!valid)} cases with missing data have been removed."))
    Y <- Y[valid, , drop = FALSE]
    group <- group[valid]
  }

  p <- ncol(Y)
  n <- table(group)
  levels <- levels(group)
  ngroups <- nlevels(group)

  # Set seed if provided
  if (!is.null(seed)) set.seed(seed)

  # Define the statistic function for bootstrap
  # This takes a data matrix and indices, returns the eigenvalue statistic
  stat_fun <- function(data, indices) {
    dat <- data[indices, , drop = FALSE]

    # Check if we have enough observations
    if (nrow(dat) <= ncol(dat)) {
      return(NA)
    }

    cov_mat <- cov(dat, use = "complete.obs")
    eigs <- eigen(cov_mat, symmetric = TRUE, only.values = TRUE)$values

    # Compute the requested statistic
    result <- switch(which,
                     "product" = prod(eigs),
                     "sum" = sum(eigs),
                     "precision" = 1 / sum(1 / eigs),  # harmonic mean
                     "max" = max(eigs)
    )

    return(result)
  }

  # Helper function to extract CI from boot.ci object
  extract_ci <- function(bootci_obj, ci_type) {
    if (is.null(bootci_obj)) {
      return(c(lower = NA, upper = NA))
    }

    if (ci_type == "perc" && !is.null(bootci_obj$percent)) {
      return(c(lower = bootci_obj$percent[4],
               upper = bootci_obj$percent[5]))
    } else if (ci_type == "bca" && !is.null(bootci_obj$bca)) {
      return(c(lower = bootci_obj$bca[4],
               upper = bootci_obj$bca[5]))
    } else if (ci_type == "norm" && !is.null(bootci_obj$normal)) {
      return(c(lower = bootci_obj$normal[2],
               upper = bootci_obj$normal[3]))
    } else if (ci_type == "basic" && !is.null(bootci_obj$basic)) {
      return(c(lower = bootci_obj$basic[4],
               upper = bootci_obj$basic[5]))
    } else {
      warning(glue::glue("CI type '{ci_type}' not available, trying 'perc'"))
      if (!is.null(bootci_obj$percent)) {
        return(c(lower = bootci_obj$percent[4],
                 upper = bootci_obj$percent[5]))
      } else {
        return(c(lower = NA, upper = NA))
      }
    }
  }

  # Initialize results storage
  results <- list()

  # Bootstrap for each group
  for (i in seq_along(levels)) {
    lev <- levels[i]
    group_data <- Y[group == lev, , drop = FALSE]

    # Check if group has enough observations
    if (nrow(group_data) <= p) {
      warning(glue::glue("Group '{lev}' has n <= p ({nrow(group_data)} <= {p}), skipping bootstrap"))
      results[[lev]] <- list(
        statistic = NA,
        lower = NA,
        upper = NA,
        bias = NA,
        se = NA
      )
      next
    }

    # Perform bootstrap
    boot_result <- tryCatch({
      boot::boot(data = group_data,
                 statistic = stat_fun,
                 R = R,
                 parallel = if (isTRUE(parallel)) "multicore" else parallel,
                 ncpus = ncpus)
    }, error = function(e) {
      warning(glue::glue("Bootstrap failed for group '{lev}': {e$message}"))
      return(NULL)
    })

    if (is.null(boot_result)) {
      results[[lev]] <- list(
        statistic = NA,
        lower = NA,
        upper = NA,
        bias = NA,
        se = NA
      )
      next
    }

    # Compute confidence interval
    ci_result <- tryCatch({
      boot::boot.ci(boot_result, conf = conf, type = type)
    }, error = function(e) {
      warning(glue::glue("CI computation failed for group '{lev}': {e$message}"))
      return(NULL)
    })

    # Extract CI bounds
    ci_bounds <- extract_ci(ci_result, type)

    # Store results
    results[[lev]] <- list(
      statistic = boot_result$t0,
      lower = ci_bounds["lower"],
      upper = ci_bounds["upper"],
      bias = mean(boot_result$t[,1], na.rm = TRUE) - boot_result$t0,
      se = sd(boot_result$t[,1], na.rm = TRUE)
    )
  }

  # Bootstrap for pooled data
  boot_result_pooled <- tryCatch({
    boot::boot(data = Y,
               statistic = stat_fun,
               R = R,
               parallel = if (isTRUE(parallel)) "multicore" else parallel,
               ncpus = ncpus)
  }, error = function(e) {
    warning(glue::glue("Bootstrap failed for pooled data: {e$message}"))
    return(NULL)
  })

  if (!is.null(boot_result_pooled)) {
    ci_result_pooled <- tryCatch({
      boot::boot.ci(boot_result_pooled, conf = conf, type = type)
    }, error = function(e) {
      warning(glue::glue("CI computation failed for pooled data: {e$message}"))
      return(NULL)
    })

    ci_bounds_pooled <- extract_ci(ci_result_pooled, type)

    results[["pooled"]] <- list(
      statistic = boot_result_pooled$t0,
      lower = ci_bounds_pooled["lower"],
      upper = ci_bounds_pooled["upper"],
      bias = mean(boot_result_pooled$t[,1], na.rm = TRUE) - boot_result_pooled$t0,
      se = sd(boot_result_pooled$t[,1], na.rm = TRUE)
    )
  } else {
    results[["pooled"]] <- list(
      statistic = NA,
      lower = NA,
      upper = NA,
      bias = NA,
      se = NA
    )
  }

  # Convert to data frame
  result_df <- data.frame(
    group = names(results),
    statistic = sapply(results, function(x) x$statistic),
    lower = sapply(results, function(x) x$lower),
    upper = sapply(results, function(x) x$upper),
    bias = sapply(results, function(x) x$bias),
    se = sapply(results, function(x) x$se),
    row.names = NULL,
    stringsAsFactors = FALSE
  )

  # Add attributes for metadata
  attr(result_df, "which") <- which
  attr(result_df, "R") <- R
  attr(result_df, "conf") <- conf
  attr(result_df, "type") <- type

  return(result_df)
}


#' Helper function to use eigstatCI with a boxM object
#'
#' @description
#' This is a convenience wrapper that extracts the necessary information
#' from a boxM object, but still requires the original data and grouping
#' variable since these are not stored in the boxM object.
#'
#' @param boxm A "boxM" object from `boxM()`
#' @param Y Original data matrix used in `boxM()`
#' @param group Original grouping variable used in `boxM()`
#' @param ... Additional arguments passed to `eigstatCI()`
#'
#' @return A data frame with bootstrap confidence intervals
#'
#' @examples
#' \dontrun{
#' library(boot)
#' data(iris)
#'
#' # Fit boxM
#' res <- boxM(iris[,1:4], iris$Species)
#'
#' # Get bootstrap CIs (must provide original data again)
#' CI <- eigstatCI_boxM(res, Y = iris[,1:4], group = iris$Species,
#'                      which = "sum", R = 500)
#' }
#'
#' @export
eigstatCI_boxM <- function(boxm, Y, group, ...) {
  if (!inherits(boxm, "boxM")) {
    stop("boxm must be a 'boxM' object")
  }

  eigstatCI(Y = Y, group = group, ...)
}
