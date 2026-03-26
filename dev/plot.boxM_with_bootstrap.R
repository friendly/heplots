# Modified plot.boxM() with bootstrap CI support
#
# This is a prototype modification of plot.boxM() that integrates
# bootstrap confidence intervals for eigenvalue statistics.
#
# DONE: ✔️ Fixed dotchart labels - now shows group names on y-axis 12/28/2024
# DONE: ✔️ Fixed CI alignment - reorder CI bounds and points to match yorder 12/28/2024
# DONE: ✔️ Fixed pooled CI alignment - use CI$statistic instead of eigstats measure 12/28/2024
#
# Usage:
#   source("dev/eigstatCI.R")
#   source("dev/plot.boxM_with_bootstrap.R")
#
#   boxm <- boxM(iris[,1:4], iris$Species)
#   plot_boxM_boot(boxm, Y = iris[,1:4], group = iris$Species,
#                  which = "sum", gplabel = "Species")

#' Plot for Box's M test with bootstrap CIs
#'
#' @description
#' Enhanced version of `plot.boxM()` that supports bootstrap confidence
#' intervals for eigenvalue-based statistics in addition to the existing
#' analytic CIs for log determinants.
#'
#' @param x A `"boxM"` object resulting from `boxM()`
#' @param Y Optional data matrix (required for bootstrap CIs with eigenvalue stats)
#' @param group Optional grouping variable (required for bootstrap CIs with eigenvalue stats)
#' @param gplabel Character string used to label the group factor
#' @param which Measure to be plotted
#' @param log Logical; if TRUE, the log of the measure is plotted
#' @param pch Point symbols for groups and pooled data
#' @param cex Character size of point symbols
#' @param col Colors for point symbols
#' @param rev Logical; if TRUE, reverse order of groups on vertical axis
#' @param xlim X limits for the plot
#' @param conf Coverage for confidence intervals (0 to suppress)
#' @param method CI method for logDet (see `logdetCI()`)
#' @param bias.adj Bias adjustment for logDet CIs
#' @param lwd Line width for confidence intervals
#' @param boot.R Number of bootstrap replicates (for eigenvalue stats only)
#' @param boot.type Type of bootstrap CI ("perc", "bca", "norm", "basic")
#' @param boot.parallel Use parallel processing for bootstrap
#' @param boot.ncpus Number of CPUs for parallel bootstrap
#' @param boot.seed Random seed for bootstrap reproducibility
#' @param ... Additional arguments passed to `dotchart()`
#'
#' @return Invisibly returns the confidence interval data frame (if computed)
#'
#' @examples
#' \dontrun{
#' library(boot)
#' source("dev/eigstatCI.R")
#' source("dev/plot.boxM_with_bootstrap.R")
#'
#' # Iris data with bootstrap CIs
#' boxm <- boxM(iris[,1:4], iris$Species)
#'
#' # logDet with analytic CI (same as before)
#' plot_boxM_boot(boxm, gplabel = "Species")
#'
#' # Sum of eigenvalues with bootstrap CI
#' plot_boxM_boot(boxm, Y = iris[,1:4], group = iris$Species,
#'                which = "sum", gplabel = "Species", boot.R = 1000)
#' }
#'
#' @export
plot_boxM_boot <- function(x,
                           Y = NULL,
                           group = NULL,
                           gplabel = NULL,
                           which = c("logDet", "product", "sum", "precision", "max"),
                           log = which == "product",
                           pch = c(16, 15),
                           cex = c(2, 2.5),
                           col = c("blue", "red"),
                           rev = FALSE,
                           xlim,
                           conf = 0.95,
                           method = 1,
                           bias.adj = TRUE,
                           lwd = 2,
                           boot.R = 1000,
                           boot.type = c("perc", "bca", "norm", "basic"),
                           boot.parallel = FALSE,
                           boot.ncpus = 2,
                           boot.seed = NULL,
                           ...) {

  which <- match.arg(which)
  boot.type <- match.arg(boot.type)

  CI <- NULL  # Will store CI data if computed

  # ============================================================================
  # Handle logDet case (existing analytic CI)
  # ============================================================================

  if (which == "logDet") {
    # Filter out singular groups
    valid_idx <- is.finite(x$logDet)
    measure <- x$logDet[valid_idx]
    xlab <- "log determinant"

    # Track which groups are valid (excluding pooled)
    valid_groups <- head(valid_idx, -1)
  }

  # ============================================================================
  # Handle eigenvalue statistics (bootstrap CI)
  # ============================================================================

  else {
    eigstats <- summary(x, quiet = TRUE)$eigstats
    measure <- eigstats[which, ]
    if (log) measure <- log(measure)
    xlab <- paste(if (log) "log" else "", which, "of eigenvalues")

    # For eigstats, filter is already handled by summary()
    valid_groups <- rep(TRUE, length(x$logDet))

    # Check if we can compute bootstrap CIs
    if (conf > 0) {
      if (is.null(Y) || is.null(group)) {
        warning(glue::glue(
          "Bootstrap CIs for '{which}' require Y and group arguments. ",
          "Plotting without confidence intervals. ",
          "Use: plot(..., Y = data, group = grouping_var)"
        ))
        conf <- 0  # Disable CIs
      }
    }
  }

  # ============================================================================
  # Set up plot dimensions
  # NOTE: ng is computed here, but may be updated after bootstrap CI computation
  # ============================================================================

  ng <- length(measure) - 1

  if (missing(xlim)) {
    xlim <- range(measure[is.finite(measure)])
  }

  # ============================================================================
  # Compute confidence intervals
  # ============================================================================

  if (conf > 0) {

    # ------------------------------------------------------------------------
    # logDet: Use analytic CI
    # ------------------------------------------------------------------------
    if (which == "logDet") {
      cov_valid <- x$cov[valid_groups]
      cov <- c(cov_valid, list(pooled = x$pooled))
      df_valid <- x$df[c(valid_groups, TRUE)]  # Include pooled
      n <- df_valid + 1

      CI <- logdetCI(cov, n = n, conf = conf,
                     method = method, bias.adj = bias.adj)

      xlim[1] <- min(xlim[1], CI$lower)
      xlim[2] <- max(xlim[2], CI$upper)
    }

    # ------------------------------------------------------------------------
    # Eigenvalue stats: Use bootstrap CI
    # ------------------------------------------------------------------------
    else {
      cat(glue::glue("Computing bootstrap CIs for '{which}' (R = {boot.R})...\n"))

      # Compute bootstrap CIs
      CI <- eigstatCI(Y = Y,
                      group = group,
                      which = which,
                      R = boot.R,
                      conf = conf,
                      type = boot.type,
                      parallel = boot.parallel,
                      ncpus = boot.ncpus,
                      seed = boot.seed)

      # Adjust measure if using log scale
      if (log) {
        CI$statistic <- log(CI$statistic)
        CI$lower <- log(CI$lower)
        CI$upper <- log(CI$upper)
      }

      # IMPORTANT: Use bootstrap statistic as the measure to plot
      # This ensures perfect alignment between points and CIs
      measure <- CI$statistic
      names(measure) <- CI$group

      # Recalculate ng in case measure length changed
      ng <- length(measure) - 1

      # Update xlim to include CIs
      xlim[1] <- min(xlim[1], CI$lower, na.rm = TRUE)
      xlim[2] <- max(xlim[2], CI$upper, na.rm = TRUE)
    }
  }

  # ============================================================================
  # Create the plot
  # ============================================================================

  yorder <- if (rev) c(ng:1, ng + 1) else 1:(ng + 1)

  # Get labels from measure names if available, or from CI data if bootstrap was used
  if (!is.null(CI)) {
    labels <- CI$group[yorder]
  } else {
    labels <- names(measure)[yorder]
  }

  dotchart(measure[yorder],
           labels = labels,
           xlab = xlab,
           xlim = xlim,
           ...)

  # Add confidence intervals
  if (conf > 0 && !is.null(CI)) {
    arrows(CI$lower[yorder], yorder,
           CI$upper[yorder], yorder,
           lwd = lwd,
           angle = 90,
           length = 0.075,
           code = 3,
           col = "gray50")
  }

  # Add points on top of CI bars
  points(measure[yorder], yorder,
         cex = c(rep(cex[1], ng), cex[2]),
         pch = c(rep(pch[1], ng), pch[2]),
         col = c(rep(col[1], ng), col[2]))

  # Add group label
  if (!is.null(gplabel)) {
    text(par("usr")[1], ng + 0.5, gplabel, pos = 4, cex = 1.25)
  }

  # Return CI data invisibly
  invisible(CI)
}


# ============================================================================
# Example usage and comparison
# ============================================================================

if (FALSE) {  # Set to TRUE to run examples

  # library(heplots)
  # library(boot)
  # #source("dev/eigstatCI.R")
  # 
  # # Iris data
  # iris.boxm <- boxM(iris[, 1:4], iris[, "Species"])
  # 
  # # Original plot.boxM (analytic CI for logDet)
  # par(mfrow = c(1, 2))
  # plot(iris.boxm, gplabel = "Species", main = "Original plot.boxM")
  # 
  # # New version (same result for logDet)
  # plot_boxM_boot(iris.boxm, gplabel = "Species", main = "plot_boxM_boot")
  # 
  # # Compare eigenvalue statistics: old (no CI) vs new (bootstrap CI)
  # par(mfrow = c(2, 2), mar = c(5, 4, 3, 1))
  # 
  # # Product
  # plot(iris.boxm, which = "product", gplabel = "Species",
  #      main = "Product (no CI)")
  # 
  # plot_boxM_boot(iris.boxm, Y = iris[, 1:4], group = iris$Species,
  #                which = "product", gplabel = "Species",
  #                main = "Product (bootstrap CI)", boot.R = 500)
  # 
  # # Sum
  # plot(iris.boxm, which = "sum", gplabel = "Species",
  #      main = "Sum (no CI)")
  # 
  # plot_boxM_boot(iris.boxm, Y = iris[, 1:4], group = iris$Species,
  #                which = "sum", gplabel = "Species",
  #                main = "Sum (bootstrap CI)", boot.R = 500)
  # 
  # 
  # 
  # # Skulls data
  # data(Skulls)
  # skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data = Skulls)
  # skulls.boxm <- boxM(skulls.mod)
  # 
  # par(mfrow = c(2, 2), mar = c(5, 4, 3, 1))
  # 
  # plot_boxM_boot(skulls.boxm, gplabel = "Epoch",
  #                main = "logDet (analytic CI)")
  # 
  # plot_boxM_boot(skulls.boxm,
  #                Y = as.matrix(Skulls[, c("mb", "bh", "bl", "nh")]),
  #                group = Skulls$epoch,
  #                which = "sum", gplabel = "Epoch",
  #                main = "Sum (bootstrap CI)", boot.R = 500)
  # 
  # plot_boxM_boot(skulls.boxm,
  #                Y = as.matrix(Skulls[, c("mb", "bh", "bl", "nh")]),
  #                group = Skulls$epoch,
  #                which = "precision", gplabel = "Epoch",
  #                main = "Precision (bootstrap CI)", boot.R = 500)
  # 
  # plot_boxM_boot(skulls.boxm,
  #                Y = as.matrix(Skulls[, c("mb", "bh", "bl", "nh")]),
  #                group = Skulls$epoch,
  #                which = "max", gplabel = "Epoch",
  #                main = "Max (bootstrap CI)", boot.R = 500)
}
