# Box's M-test for Homogeneity of Covariance Matrices
# DONE: ✔️ handles singular covariance matrices
# DONE: ✔️ Fixed summary() method to print eigenvalues as a matrix (not a list)
# DONE: ✔️ print/summary methods now show the number of groups actually used when some are excluded
# TODO: 🚩 Don't need "htest" because there's a `print.boxM()` method
# TODO: 🚩 simplify print and summary methods, now the `ngroups` is saved by boxM.default


#' Box's M-test for Homogeneity of Covariance Matrices
#' 
#' `boxM()` performs the Box's (1949) M-test for homogeneity of covariance
#' matrices obtained from multivariate normal data according to one or more
#' classification factors. The test compares the product of the log
#' determinants of the separate covariance matrices to the log determinant of
#' the pooled covariance matrix, analogous to a likelihood ratio test. The test
#' statistic uses a chi-square approximation.
#' 
#' @details
#' As an object of class `"boxM"`, a few methods are
#' available:  `print.boxM()`, `summary.boxM()` and `plot.boxM()`.
#' 
#' There is no general provision as yet for handling missing data.  Missing
#' data are simply removed, with a warning.
#' 
#' As well, the computation assumes that the covariance matrix for each group
#' is non-singular, so that \eqn{\log det(S_i)} can be calculated for each
#' group. At the minimum, this requires that \eqn{n > p} for each group.
#' 
#' Box's M test for a multivariate linear model highly sensitive to departures
#' from multivariate normality, just as the analogous univariate test.  It is
#' also affected adversely by unbalanced designs.  Some people recommend to
#' ignore the result unless it is very highly significant, e.g., p < .0001 or
#' worse.
#' 
#' In general, heterogeneity of covariance matrices can be more easily seen and understood by plotting
#' the covariance ellipses using \code{\link{covEllipses}}.
#' 
#' The \code{summary} method prints a variety of additional statistics based on
#' the eigenvalues of the covariance matrices. These are returned invisibly, as
#' a list containing the following components:
#' \describe{
#'   \item{logDet}{the vector of log determinants}
#'   \item{eigs}{eigenvalues of the covariance matrices}
#'   \item{eigstats}{statistics computed on the eigenvalues for each covariance
#'     matrix:
#'     \describe{
#'       \item{product}{the product of eigenvalues, \eqn{\prod{\lambda_i}}}
#'       \item{sum}{the sum of eigenvalues, \eqn{\sum{\lambda_i}}}
#'       \item{precision}{the average precision of eigenvalues, 
#'         \eqn{1/\sum(1/\lambda_i)}}
#'       \item{max}{the maximum eigenvalue, \eqn{\lambda_1}}
#'     }
#'   }
#' }
#'
#' @param Y The response variable matrix for the default method, or a \code{"mlm"} 
#'   or \code{"formula"} object for a multivariate linear model. If \code{Y} is a 
#'   linear-model object or a formula, the variables on the right-hand-side of the 
#'   model must all be factors and must be completely crossed, e.g., \code{A:B}
#' @param group A vector specifying the groups. Used only for the default method.
#' @param data A data frame containing the variables in the model. Used only for
#'   the formula method.
#' @param object A \code{"boxM"} object, result of a call to \code{boxM}
#' @param digits Number of digits in printed output
#' @param cov Logical; if \code{TRUE}, the covariance matrices for each group and 
#'   the pooled covariance matrix are printed
#' @param quiet Logical; if \code{TRUE}, suppress printed output
#' @param ... Other arguments passed down
#'
#' @return A list with class \code{c("boxM", "htest")} containing the following
#'   components:
#'   \item{statistic}{the chi-square (approximate) statistic for Box's M test, where large values 
#'         imply the covariance matrices differ.}
#'   \item{parameter}{the degrees of freedom for the test statistic.}
#'   \item{p.value}{the p-value of the test}
#'   \item{ngroups}{the number of levels of the `group` variable}
#'   \item{cov}{a list of the group covariance matrices, of length `ngroups`}
#'   \item{pooled}{the pooled covariance matrix}
#'   \item{means}{a matrix whose `ngroups+1` rows are the means of the variables, followed by those for pooled data.}
#'   \item{logDet}{a vector of length `ngroups+1` containing the natural logarithm of each matrix in 
#'     \code{cov}, followed by that for the pooled covariance matrix}
#'   \item{df}{a vector of the degrees of freedom for all groups, followed by 
#'     that for the pooled covariance matrix}
#'   \item{data.name}{a character string giving the names of the data, as extracted from the call}
#'   \item{method}{the character string \code{"Box's M-test for Homogeneity of 
#'     Covariance Matrices"}}
#'
#' @author The default method was taken from the \pkg{biotools} package,
#'   Anderson Rodrigo da Silva \email{anderson.agro@@hotmail.com}
#'   
#'   Generalized by Michael Friendly and John Fox
#'   
#' @seealso 
#' \code{\link[car]{leveneTest}} carries out homogeneity of variance
#' tests for univariate models with better statistical properties.
#' 
#' \code{\link{plot.boxM}}, a simple dot plot of the log determinants compared with that of the pooled covariance matrix, and also of other quantities computed from their eigenvalues
#' 
#' \code{\link{covEllipses}} plots covariance ellipses in variable space for
#' several groups.
#' 
#' @references 
#' Box, G. E. P. (1949). A general distribution theory for a class
#' of likelihood criteria. \emph{Biometrika}, 36, 317-346.
#' 
#' Morrison, D.F. (1976) \emph{Multivariate Statistical Methods}.
#' 
#' @examples
#' 
#' data(iris)
#' 
#' # default method, using `Y`, `group` 
#' res <- boxM(iris[, 1:4], iris[, "Species"])
#' res
#' 
#' # summary method gives details
#' summary(res)
#' 
#' # visualize (this is what is done in the plot method)
#' dets <- res$logDet
#' ng <- length(res$logDet)-1
#' dotchart(dets, xlab = "log determinant")
#' points(dets , 1:4, cex=c(rep(1.5, ng), 2.5), pch=c(rep(16, ng), 15),
#'        col= c(rep("blue", ng), "red"))
#' 
#' # plot method gives confidence intervals for logDet
#' plot(res, gplabel="Species")
#' 
#' # formula method
#' boxM( cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species,
#'       data=iris)
#' 
#' ### Skulls data
#' data(Skulls)
#' 
#' # lm method
#' skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' skulls.boxM <- boxM(skulls.mod) |>
#'   print()
#' summary(skulls.boxM)
#' 
#' @export
boxM <- function(Y, ...) {
  UseMethod("boxM")
}

#' @rdname boxM
#' @exportS3Method boxM formula
boxM.formula <- function(Y, data, ...)
{
	form <- Y
	mf <- model.frame(form, data)
	if (any(sapply(2:dim(mf)[2], function(j) is.numeric(mf[[j]])))) 
		stop("Box's M test is not appropriate with quantitative explanatory variables.")

	Y <- mf[,1]
	if (dim(Y)[2] < 2) stop("There must be two or more response variables.")

	if(dim(mf)[2]==2) {
	  group <- mf[,2]
	  group.name <- names(mf[2])
	}
	else {
		if (length(grep("\\+ | \\| | \\^ | \\:",form))>0) stop("Model must be completely crossed formula only.")
		group <- interaction(mf[,2:dim(mf)[2]])
		# **TESTME**
		group.name <- paste0(names(mf[2:dim(mf)[2]]), sep = ":")
	}

	group.name <- names(mf[2])

	res <- boxM.default(Y=Y, group=group, ...)
	# fix up slot data names
	res$data.name <- deparse(substitute(data))
	res$group <- group.name
	res

}

#' @rdname boxM
#' @importFrom stats terms
#' @export
boxM.lm <- function(Y, ...) {
  if (!inherits(Y, "lm"))
    stop(deparse(substitute(Y)), " must be a 'lm' object")
  
  Y <- model.frame(Y)
  factors <- attr(terms(Y), "factors")
  res.terms <- rownames(factors)[apply(factors, 1, sum) == 0]
  group <- interaction(Y[, colnames(factors), drop = FALSE])
  
  Y <- as.matrix(Y[, res.terms])
  boxM.default(Y, group, ...)
}

#' @rdname boxM
#' @importFrom stats aggregate
#' @export
boxM.default <- function(Y, group, ...) {

  # Create data name - collapse deparse output properly
  y_name <- deparse(substitute(Y))
  group_name <- deparse(substitute(group))
  dname <- paste(y_name, "by", group_name)
  
  if (!is.matrix(Y))
    Y <- as.matrix(Y)
  
  # Check for missing data
  na_rows <- apply(is.na(Y), 1, any)
  if (any(na_rows)) {
    warning(sum(na_rows), " cases with missing data have been removed.")
    Y <- Y[!na_rows, , drop = FALSE]
    group <- group[!na_rows]
  }
  
  group <- as.factor(as.character(group))
  ngroups <- nlevels(group)
  lev <- levels(group)
  
  # Sample sizes
  n <- table(group)
  N <- nrow(Y)
  p <- ncol(Y)
  
  # Degrees of freedom for each group
  dfs <- n - 1
  
  # Compute covariance matrix for each group
  mats <- aux <- list()
  for (i in 1:ngroups) {
    mats[[i]] <- cov(Y[group == lev[i], , drop = FALSE])
    aux[[i]] <- mats[[i]] * dfs[i]
  }
  names(mats) <- lev
  
  # Pooled covariance matrix
  pooled <- Reduce("+", aux) / sum(dfs)
  
  # compute means (for use with `covEllises.boxm()`)
  means <- aggregate(Y, by = list(group), FUN = mean)
  gm <- colMeans(Y)
  means <- rbind(means[, -1], gm)
  row.names(means) <- c(lev, "pooled")
  
  # CORRECTED: Identify groups with singular covariance matrices
  # A group has singular cov matrix if dfs[i] < p (i.e., n[i] <= p)
  singular <- dfs < p
  
  if (any(singular)) {
    singular_groups <- lev[singular]
    warning("Groups: ", paste0('"', paste(singular_groups, collapse='", "'), '"'),
            " have fewer observations than variables (n <= p) ",
            "and have been excluded from the calculations.")
  }
  
  # Use only non-singular groups for calculations
  valid_idx <- !singular
  dfs_valid <- dfs[valid_idx]
  nlev_valid <- sum(valid_idx)
  
  # CORRECTED: Calculate logdet, minus2logM, and sum1 using only valid groups
  logdet_all <- rep(-Inf, ngroups)  # Initialize with -Inf for all groups
  if (nlev_valid > 0) {
    # Compute log determinants only for valid groups
    logdet_valid <- log(sapply(mats[valid_idx], det))
    logdet_all[valid_idx] <- logdet_valid
    
    # Test statistic using only valid groups
    minus2logM <- sum(dfs_valid) * log(det(pooled)) - sum(logdet_valid * dfs_valid)
    sum1 <- sum(1 / dfs_valid)
  } else {
    # All groups are singular
    minus2logM <- NA
    sum1 <- NA
  }
  names(logdet_all) <- lev

  # Append pooled log determinant
  logdet_all <- c(logdet_all, pooled = log(det(pooled)))

  # Correction factors using valid groups only
  Co <- (((2 * p^2) + (3 * p) - 1) / (6 * (p + 1) * (nlev_valid - 1))) *
    (sum1 - (1 / sum(dfs_valid)))
  
  # Test statistic
  X2 <- minus2logM * (1 - Co)
  dfchi <- (choose(p, 2) + p) * (nlev_valid - 1)
  pval <- pchisq(X2, dfchi, lower.tail = FALSE)
  
  # Return as both htest and boxM object
  result <- list(
    statistic = c("Chi-Sq (approx.)" = X2),
    parameter = c(df = dfchi),
    p.value = pval,
    ngroups = ngroups,
    cov = mats,
    pooled = pooled,
    means = means,
    logDet = logdet_all,
    df = c(dfs, pooled = sum(dfs)),
    data.name = dname,
    method = "Box's M-test for Homogeneity of Covariance Matrices"
  )
  
  class(result) <- c("boxM", "htest")
  result
}

#' @rdname boxM
#' @param x a class `"boxM"` object, for the `print()` method
#' @importFrom utils head
#' @export
print.boxM <- function(x, ...) {
  cat("\n", x$method, "\n\n")
  cat("data: ", x$data.name, "\n")

  # Count number of groups used (excluding pooled, and excluding groups with -Inf logDet)
  logdet_groups <- head(x$logDet, -1L)
  ngroups_total <- length(logdet_groups)
  ngroups_used <- sum(is.finite(logdet_groups))

  if (ngroups_used < ngroups_total) {
    cat("Groups: ", ngroups_used, " of ", ngroups_total, " (",
        ngroups_total - ngroups_used, " excluded due to singular covariance matrices)\n",
        sep = "")
  }

  out <- character()
  out <- c(out, paste(names(x$statistic), "=",
                      format(round(x$statistic, 4))))
  out <- c(out, paste(names(x$parameter), "=",
                      format(round(x$parameter, 3))))
  fp <- format.pval(x$p.value, digits = max(1, getOption("digits") - 3))
  out <- c(out, paste("p-value =", fp))
  cat(strwrap(paste(out, collapse = ", ")), sep = "\n")
  cat("\n")
  invisible(x)
}

#' @rdname boxM
#' @export
summary.boxM <- function(object, digits = getOption("digits") - 2,
                         cov = FALSE, quiet = FALSE, ...) {
  # Compute eigenvalues for all covariance matrices including pooled
  covs <- c(object$cov, pooled = list(object$pooled))
  eigs <- sapply(covs, FUN = function(x) eigen(x)$values)
  rownames(eigs) <- 1:nrow(eigs)

  # Compute statistics based on eigenvalues
  eigstats <- rbind(
    product = apply(eigs, 2, prod),
    sum = apply(eigs, 2, sum),
    precision = 1 / apply(1 / eigs, 2, sum),
    max = apply(eigs, 2, max)
  )
  
  if (!quiet) {
    cat("\n", object$method, "\n\n")
    cat("data: ", object$data.name, "\n\n")

    # Count number of groups used (excluding pooled)
    logdet_groups <- head(object$logDet, -1L)
    ngroups_total <- length(logdet_groups)
    ngroups_used <- sum(is.finite(logdet_groups))

    cat("Chi-Sq (approx.) = ", object$statistic, "\n")
    cat("df:\t", object$parameter, "\n")
    fp <- format.pval(object$p.value, digits = max(1L, digits - 3L))
    cat("p-value:", fp, "\n")

    if (ngroups_used < ngroups_total) {
      cat("Groups used: ", ngroups_used, " of ", ngroups_total, " (",
          ngroups_total - ngroups_used, " excluded due to singular covariance matrices)\n",
          sep = "")
    }
    cat("\n")

    cat("log of Covariance determinants:\n")
    print(object$logDet, digits = digits)

    cat("\nEigenvalues:\n")
    print(eigs, digits = digits)

    cat("\nStatistics based on eigenvalues:\n")
    print(eigstats, digits = digits)

    if (cov) {
      cat("\nCovariance matrices:\n")
      print(object$cov, digits = digits)
      cat("\nPooled:\n")
      print(object$pooled, digits = digits)
    }
  }
  
  ret <- list(logDet = object$logDet, eigs = eigs, eigstats = eigstats)
  if (cov) ret <- c(ret, cov = list(object$cov))
  invisible(ret)
}