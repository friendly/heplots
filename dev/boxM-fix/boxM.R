# Box's M-test for Homogeneity of Covariance Matrices
# FIXED: handles singular covariance matrices


#' Box's M-test
#' 
#' \code{boxM} performs the Box's (1949) M-test for homogeneity of covariance
#' matrices obtained from multivariate normal data according to one or more
#' classification factors. The test compares the product of the log
#' determinants of the separate covariance matrices to the log determinant of
#' the pooled covariance matrix, analogous to a likelihood ratio test. The test
#' statistic uses a chi-square approximation.
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
#' @return A list with class \code{c("htest", "boxM")} containing the following
#'   components:
#'   \item{statistic}{the chi-square (approximate) statistic}
#'   \item{parameter}{the degrees of freedom related of the test statistic in this 
#'     case that it follows a Chi-square distribution.}
#'   \item{p.value}{the p-value of the test}
#'   \item{cov}{a list of the group covariance matrices}
#'   \item{pooled}{the pooled covariance matrix}
#'   \item{logDet}{a vector containing the natural logarithm of each matrix in 
#'     \code{cov}, followed by the value for the pooled covariance matrix}
#'   \item{df}{a vector of the degrees of freedom for all groups, followed by 
#'     that for the pooled covariance matrix}
#'   \item{data.name}{a character string giving the names of the data}
#'   \item{method}{the character string \code{"Box's M-test for Homogeneity of 
#'     Covariance Matrices"}}
#'
#' @details
#' As an object of class \code{"htest"}, the statistical test is printed
#' normally by default. As an object of class \code{"boxM"}, a few methods are
#' available.
#' 
#' There is no general provision as yet for handling missing data.  Missing
#' data are simply removed, with a warning.
#' 
#' As well, the computation assumes that the covariance matrix for each group
#' is non-singular, so that \eqn{log det(S_i)} can be calculated for each
#' group. At the minimum, this requires that \eqn{n > p} for each group.
#' 
#' Box's M test for a multivariate linear model highly sensitive to departures
#' from multivariate normality, just as the analogous univariate test.  It is
#' also affected adversely by unbalanced designs.  Some people recommend to
#' ignore the result unless it is very highly significant, e.g., p < .0001 or
#' worse.
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
#' @author The default method was taken from the \pkg{biotools} package,
#'   Anderson Rodrigo da Silva \email{anderson.agro@@hotmail.com}
#'   
#'   Generalized by Michael Friendly and John Fox
#'   
#' @seealso 
#' \code{\link[car]{leveneTest}} carries out homogeneity of variance
#' tests for univariate models with better statistical properties.
#' 
#' \code{\link{plot.boxM}}, a simple plot of the log determinants
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
#' # default method
#' res <- boxM(iris[, 1:4], iris[, "Species"])
#' res
#' 
#' # summary method gives details
#' summary(res)
#' 
#' # visualize (what is done in the plot method)
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
#' boxM(skulls.mod)
#' 
#' @export
boxM <- function(Y, ...) {
  UseMethod("boxM")
}

#' @rdname boxM
#' @export
boxM.formula <- function(formula, data, ...) {
  form <- as.character(formula)
  if (form[1] != "~" || length(form) != 2)
    stop("Formula must be one-sided.")
  
  Y <- as.matrix(data[, all.vars(formula[[2]])])
  group <- interaction(data[, all.vars(formula[[3]])])
  boxM.default(Y, group, ...)
}

#' @rdname boxM
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
#' @export
boxM.default <- function(Y, group, ...) {
  if (!is.matrix(Y))
    Y <- as.matrix(Y)
  
  dname <- paste(deparse(substitute(Y)), "by", deparse(substitute(group)))
  
  # Check for missing data
  na_rows <- apply(is.na(Y), 1, any)
  if (any(na_rows)) {
    warning(sum(na_rows), " cases with missing data have been removed.")
    Y <- Y[!na_rows, , drop = FALSE]
    group <- group[!na_rows]
  }
  
  group <- as.factor(as.character(group))
  nlev <- nlevels(group)
  lev <- levels(group)
  
  # Sample sizes
  n <- table(group)
  N <- nrow(Y)
  p <- ncol(Y)
  
  # Degrees of freedom for each group
  dfs <- n - 1
  
  # Compute covariance matrix for each group
  mats <- aux <- list()
  for (i in 1:nlev) {
    mats[[i]] <- cov(Y[group == lev[i], , drop = FALSE])
    aux[[i]] <- mats[[i]] * dfs[i]
  }
  names(mats) <- lev
  
  # Pooled covariance matrix
  pooled <- Reduce("+", aux) / sum(dfs)
  
  # CORRECTED: Identify groups with singular covariance matrices
  # A group has singular cov matrix if dfs[i] < p (i.e., n[i] <= p)
  singular <- dfs < p
  
  if (any(singular)) {
    singular_groups <- lev[singular]
    warning("Groups ", paste(singular_groups, collapse = ", "), 
            " have fewer observations than variables (n <= p) ",
            "and have been excluded from the calculations.")
  }
  
  # Use only non-singular groups for calculations
  valid_idx <- !singular
  dfs_valid <- dfs[valid_idx]
  nlev_valid <- sum(valid_idx)
  
  # CORRECTED: Calculate logdet, minus2logM, and sum1 using only valid groups
  logdet_all <- rep(-Inf, nlev)  # Initialize with -Inf for all groups
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
    cov = mats,
    pooled = pooled,
    logDet = logdet_all,
    df = c(dfs, pooled = sum(dfs)),
    data.name = dname,
    method = "Box's M-test for Homogeneity of Covariance Matrices"
  )
  
  class(result) <- c("boxM", "htest")
  result
}

#' @rdname boxM
#' @export
print.boxM <- function(x, ...) {
  cat("\n", x$method, "\n\n")
  cat("data: ", x$data.name, "\n")
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
  eigs <- lapply(object$cov, eigen, only.values = TRUE)
  eigs <- lapply(eigs, "[[", "values")
  names(eigs) <- names(object$cov)
  
  eigstats <- data.frame(
    product = sapply(eigs, prod),
    sum = sapply(eigs, sum),
    precision = sapply(eigs, function(x) max(x) / min(x)),
    max = sapply(eigs, max),
    min = sapply(eigs, min)
  )
  
  if (!quiet) {
    cat("\n", object$method, "\n\n")
    cat("data: ", object$data.name, "\n\n")
    cat("Chi-Sq (approx.) = ", object$statistic, "\n")
    cat("df:\t", object$parameter, "\n")
    fp <- format.pval(object$p.value, digits = max(1L, digits - 3L))
    cat("p-value:", fp, "\n\n")
    
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