# Box's M-test for Homogeneity of Covariance Matrices



#' Box's M-test
#' 
#' `boxM` performs the Box's (1949) M-test for homogeneity of covariance
#' matrices obtained from multivariate normal data according to one or more
#' classification factors. The test compares the product of the log
#' determinants of the separate covariance matrices to the log determinant of
#' the pooled covariance matrix, analogous to a likelihood ratio test. The test
#' statistic uses a chi-square approximation.
#' 
#' As an object of class `"htest"`, the statistical test is printed
#' normally by default. As an object of class `"boxM"`, a few methods are
#' available.
#' 
#' There is no general provision as yet for handling missing data.  Missing
#' data are simply removed, with a warning.
#' 
#' As well, the computation assumes that the covariance matrix for each group
#' is non-singular, so that \eqn{\log det(S_i)} can be calculated for each
#' group. At the minimum, this requires that \eqn{n_i > p} for each group.
#' 
#' Box's M test for a multivariate linear model highly sensitive to departures
#' from multivariate normality, just as the analogous univariate test.  It is
#' also affected adversely by unbalanced designs.  Some people recommend to
#' ignore the result unless it is very highly significant, e.g., p < .0001 or
#' worse.
#' 
#' The `summary` method prints a variety of additional statistics based on
#' the eigenvalues of the covariance matrices.  These are returned invisibly,
#' as a list containing the following components: 
#' \itemize{ 
#' \item `logDet` - log determinants 
#' \item `eigs` - eigenvalues of the covariance matrices 
#' \item `eigstats` - statistics computed on the eigenvalues for each covariance matrix:\cr 
#'     `product`: the product of eigenvalues, \eqn{\prod{\lambda_i}};\cr 
#'     `sum`: the sum of eigenvalues, \eqn{\sum{\lambda_i}};\cr 
#'     `precision`: the average precision of eigenvalues, \eqn{1/\sum(1/\lambda_i)};\cr 
#'     `max`: the maximum eigenvalue, \eqn{\lambda_1} 
#' }
#' 
#' @aliases boxM boxM.formula boxM.lm boxM.default summary.boxM
#' @param Y The response variable matrix for the default method, or a
#'         `"mlm"` or `"formula"` object for a multivariate linear model.  If
#'         `Y` is a linear-model object or a formula, the variables on the
#'         right-hand-side of the model must all be factors and must be completely
#'         crossed, e.g., `A:B`
#' @param data a numeric data.frame or matrix containing *n* observations
#'         of *p* variables; it is expected that *n > p*.
#' @param group a factor defining groups, or a vector of length *n* doing
#'         the same.
#' @param object a `"boxM"` object for the `summary` method
#' @param digits number of digits to print for the `summary` method
#' @param cov logical; if `TRUE` the covariance matrices are printed.
#' @param quiet logical; if `TRUE` printing from the `summary` is
#'         suppressed
#' @param ... Arguments passed down to methods.
#' @return A list with class `c("htest", "boxM")` containing the following
#' components: 
#' \item{statistic }{an approximated value of the chi-square
#' distribution.} 
#' \item{parameter }{the degrees of freedom related of the test
#' statistic in this case that it follows a Chi-square distribution.}
#' \item{p.value }{the p-value of the test.} 
#' \item{cov }{a list containing the
#' within covariance matrix for each level of `grouping`.} 
#' \item{pooled}{the pooled covariance matrix.} 
#' \item{logDet }{a vector containing the natural logarithm of each matrix in `cov`, followed by the value for
#' the pooled covariance matrix} 
#' \item{means}{a matrix of the means for all groups, followed by the grand means} 
#' \item{df}{a vector of the degrees of freedom for all groups, followed by that for the pooled covariance matrix}
#' \item{data.name }{a character string giving the names of the data.}
#' \item{method }{the character string "Box's M-test for Homogeneity of
#' Covariance Matrices".}
#' 
#' @author The default method was taken from the \pkg{biotools} package,
#' Anderson Rodrigo da Silva \email{anderson.agro@@hotmail.com}
#' 
#' Generalized by Michael Friendly and John Fox
#' @seealso 
#' \code{\link[car]{leveneTest}} carries out homogeneity of variance
#' tests for univariate models with better statistical properties.
#' 
#' \code{\link{plot.boxM}}, a simple plot of the log determinants
#' 
#' \code{\link{covEllipses}} plots covariance ellipses in variable space for
#' several groups.
#' @references 
#' Box, G. E. P. (1949). A general distribution theory for a class
#' of likelihood criteria. *Biometrika*, 36, 317-346.
#' 
#' Morrison, D.F. (1976) *Multivariate Statistical Methods*.
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
#' points(dets , 1:4,  
#' 	cex=c(rep(1.5, ng), 2.5), 
#' 	pch=c(rep(16, ng), 15),
#' 	col= c(rep("blue", ng), "red"))
#' 	
#' 	# plot method gives confidence intervals for logDet
#' plot(res, gplabel="Species")
#' 
#' # formula method
#' boxM( cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
#' 
#' ### Skulls dat
#' data(Skulls)
#' # lm method
#' skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' boxM(skulls.mod)
#' 
#' 
#' 
#' 
#' @export boxM
boxM <-
	function(Y, ...) UseMethod("boxM")


#' @rdname boxM
#' @exportS3Method boxM default
boxM.default <- function(Y, group, ...)
{
   dname <- deparse(substitute(Y))
   if (!inherits(Y, c("data.frame", "matrix")))
      stop(paste(dname, "must be a numeric data.frame or matrix!"))
   if (length(group) != nrow(Y))
      stop("incompatible dimensions in Y and group!")

   Y <- as.matrix(Y)
   gname <- deparse(substitute(group))
   if (!is.factor(group)) group <- as.factor(as.character(group))

   valid <- complete.cases(Y, group)
   if (nrow(Y) > sum(valid)) 
      warning(paste(nrow(Y) - sum(valid)), " cases with missing data have been removed.")
   Y <- Y[valid,]
   group <- group[valid]

   p <- ncol(Y)
   nlev <- nlevels(group)
   lev <- levels(group)
   dfs <- tapply(group, group, length) - 1
   if (any(dfs < p)) 
      warning("there are one or more levels with less observations than variables!")
   mats <- aux <- list()
   for(i in 1:nlev) {
      mats[[i]] <- cov(Y[group == lev[i], ])
      aux[[i]] <- mats[[i]] * dfs[i]
   }
   names(mats) <- lev
   pooled <- Reduce("+", aux) / sum(dfs)
   logdet <- log(unlist(lapply(mats, det)))
   minus2logM <- sum(dfs) * log(det(pooled)) - sum(logdet * dfs)
   sum1 <- sum(1 / dfs) 
   Co <- (((2 * p^2) + (3 * p) - 1) / (6 * (p + 1) *
     (nlev - 1))) * (sum1 - (1 / sum(dfs)))
   X2 <- minus2logM * (1 - Co)
   dfchi <- (choose(p, 2) + p) * (nlev - 1)
   pval <- pchisq(X2, dfchi, lower.tail = FALSE)

   means <- aggregate(Y, list(group), mean)
   rn <- as.character(means[,1])
   means <- means[,-1]
   means <- rbind( means, colMeans(Y) )
   rownames(means) <- c(rn, "pooled")

   logdet <- c(logdet, pooled=log(det(pooled)))
   df <- c(dfs, pooled=sum(dfs))
   out <- structure(
      list(statistic = c("Chi-Sq (approx.)" = X2),
         parameter = c(df = dfchi),
         p.value = pval,
         cov = mats, pooled = pooled, logDet = logdet, means = means, df=df,
         data.name = dname, group = gname,
         method = "Box's M-test for Homogeneity of Covariance Matrices"
         ),
      class = c("htest", "boxM")
      )
   return(out)
}

# NB: This relies on `print.htest()` Do we need a better print method?

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
#' @exportS3Method boxM lm
boxM.lm <- function(Y, ...) {
  data <- getCall(Y)$data
  Y <- if (!is.null(data)) {
    data <- eval(data, envir = environment(formula(Y)))
    update(Y, formula(Y), data = data)
  }
  else update(Y, formula(Y))
  
	boxM.formula(formula(Y), data=eval(data, envir = environment(formula(Y))), ...)
}

#' @rdname boxM
#' @exportS3Method summary boxM
summary.boxM <- function(object, 
                         digits = getOption("digits"),
                         cov=FALSE, quiet=FALSE, ...)
{

  covs <- c(object$cov, pooled=list(object$pooled))
  eigs <- sapply(covs, FUN=function(x) eigen(x)$values)
  rownames(eigs) <- 1:nrow(eigs)
  
  eigstats <- rbind(
    product = apply(eigs, 2, prod),
    sum = apply(eigs, 2, sum),
    precision = 1/apply(1/eigs, 2, sum),
    max = apply(eigs, 2, max)
  )

  if (!quiet) {
    cat("Summary for Box's M-test of Equality of Covariance Matrices\n\n")
    
    cat("Chi-Sq:\t", object$statistic, "\n")
    cat("df:\t", object$parameter, "\n")
    fp <- format.pval(object$p.value, digits = max(1L, digits - 3L))
    cat("p-value:", fp, "\n\n")
    
    cat("log of Covariance determinants:\n")
    print(object$logDet, digits=digits)
    
    cat("\nEigenvalues:\n")
    print(eigs, digits=digits)
    
    cat("\nStatistics based on eigenvalues:\n")
    print(eigstats, digits=digits)	
    
    if (cov) {
      cat("\nCovariance matrices:\n")
      print(object$cov, digits=digits)
      cat("\nPooled:\n")
      print(object$pooled, digits=digits)
      
    }
  }
  ret <- list(logDet=object$logDet, eigs=eigs, eigstats=eigstats)
  if (cov) ret <- c(ret, cov=list(covs))
  invisible(ret)
}
