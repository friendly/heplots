# Box's M-test for Homogeneity of Covariance Matrices

boxM <-
	function(Y, ...) UseMethod("boxM")


boxM.default <- function(Y, group, ...)
{
   dname <- deparse(substitute(Y))
   if (!inherits(Y, c("data.frame", "matrix")))
      stop(paste(dname, "must be a numeric data.frame or matrix!"))
   if (length(group) != nrow(Y))
      stop("incompatible dimensions!")

   Y <- as.matrix(Y)
   group <- as.factor(as.character(group))

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
   rownames(means) <- c(rn, "_pooled_")

   logdet <- c(logdet, pooled=log(det(pooled)))
   out <- structure(
      list(statistic = c("Chi-Sq (approx.)" = X2),
         parameter = c(df = dfchi),
         p.value = pval,
         cov = mats, pooled = pooled, logDet = logdet, means = means,
         data.name = dname,
         method = "Box's M-test for Homogeneity of Covariance Matrices"
         ),
      class = c("htest", "boxM")
      )
   return(out)
}

boxM.formula <- function(Y, data, ...)
{
	form <- Y
	mf <- model.frame(form, data)
	if (any(sapply(2:dim(mf)[2], function(j) is.numeric(mf[[j]])))) 
		stop("Box's M test is not appropriate with quantitative explanatory variables.")

	Y <- mf[,1]
	if (dim(Y)[2] < 2) stop("There must be two or more response variables.")

	if(dim(mf)[2]==2) group <- mf[,2]
	else {
		if (length(grep("\\+ | \\| | \\^ | \\:",form))>0) stop("Model must be completely crossed formula only.")
		group <- interaction(mf[,2:dim(mf)[2]])
	}
	boxM.default(Y=Y, group=group, ...)

}


boxM.lm <- function(Y, ...) {
  data <- getCall(Y)$data
  Y <- if (!is.null(data)) {
    data <- eval(data, envir = environment(formula(Y)))
    update(Y, formula(Y), data = data)
  }
  else update(Y, formula(Y))
	boxM.formula(formula(Y), data=eval(data, envir = environment(formula(Y))), ...)
}
