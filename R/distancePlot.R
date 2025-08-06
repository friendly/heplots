# plot two sets of Malahanobis distances

#' @name distancePlot
#' 
#' @title
#' Distance Plot for Multivariate Model Diagnosis
#' 
#' @description This plot, suggested by Rousseeu et al. (2004) typically plots Mahalanobis distances (\eqn{D}) of the \code{Y} response
#' variables against the distances of the \code{X} variables in a multivariate linear model (MLM).
#' When applied to a multivariate linear model itself, it plots the distances of the \emph{residuals} for the \code{Y} variables
#' against the predictor terms in the \emph{model.matrix} \code{X}.
#' 
#' This diagnostic plot combines the information on regression outliers and leverage points, and often more useful than either distance separately.
#' 
#' @details
#' 
#' Observations with "large" distances on \code{X} or \code{Y} are labeled with their \code{ids}. The cutoffs are calculated as 
#' \eqn{\sqrt{\chi^2_{k, \text{level}}}}.
#'
#' @param X       A multivariate linear model fit by \code{\link[stats]{lm}}, or a numeric data frame giving the predictors in the MLM
#' @param Y       A numeric data frame giving the responses in the MLM or the residuals
#' @param data    For the formula method, the dataset containing the variables
#' @param method  Estimation method used for center and covariance, one of: \code{"classical"} (product-moment), 
#'                \code{"mcd"} (minimum covariance determinant), or \code{"mve"} (minimum volume ellipsoid). 
#' @param level   Lower-tail probability beyond which observations will be labeled.
#' @param ids     Labels for observations
#' @param pch     A vector of two point symbols, for the regular points and those beyond the cutoffs
#' @param col     A vector of two colors, for the regular points and those beyond the cutoffs
#' @param label.pos  Position of the label relative to the point; see \code{\link[graphics]{text}} 
#' @param xlab    Label stub for horizontal axis
#' @param ylab    Label stub for vertical axis
#' @param verbose Logical; if \code{TRUE} print the cutoff values to the console
#' @param ...     Other arguments passed to methods
#'
#' @return        Returns invisibly a data frame containing the distances, \code{distX}, \code{distY}
#' 
#' @seealso \code{\link{Mahalanobis}}
#' @references 
#' Rousseeuw, P. J., Van Driessen, K., Van Aelst, S., & Agullo, J. (2004). Robust multivariate regression. 
#' \emph{Technometrics}, \bold{46}(3), 293–305. \doi{10.1198/004017004000000329}.
#' @export
#'
#' @examples
#'
#' if(require("robustbase")) {
#'   # Examples from Rousseeuw etal (2004)
#'   data(pulpfiber, package="robustbase")
#'   # Figure 1
#'   distancePlot(pulpfiber[, 1:4], pulpfiber[, 5:8])   
#'   # Figure 3
#'   pulp.mod <- lm(cbind(Y1, Y2, Y3, Y4) ~ X1 + X2 + X3 + X4, data = pulpfiber)
#'   distancePlot(pulp.mod, method = "mcd")
#' }
#' 
#' # NLSY data
#' data(NLSY, package = "heplots")
#' NLSY.mlm <- lm(cbind(math, read) ~ income + educ + antisoc + hyperact,
#'                data = NLSY)
#' 
#' distancePlot(NLSY.mlm)
#'
#' # gives the same result
#' distancePlot(NLSY[, 3:6], residuals(NLSY.mlm), level = 0.975)
#' 
#' distancePlot(NLSY.mlm, method ="mve")
#' 
#' # distancePlot(cbind(math, read) ~ income + educ + antisoc + hyperact,
#' #                data = NLSY)
#' 
#' # schooldata dataset
#' data(schooldata)
#' school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
#' distancePlot(school.mod)
#' 
#' data(Hernior)
#' Hern.mod <- lm(cbind(leave, nurse, los) ~
#'                age + sex +  pstat +  build + cardiac + resp, data=Hernior)
#' distancePlot(Hern.mod)
#' 
#' @export distancePlot
distancePlot <-
  function(X, Y, ...) UseMethod("distancePlot")

 
#' @rdname distancePlot
#' @exportS3Method distancePlot default
distancePlot.default <- function(X, Y, 
                         method = c("classical", "mcd", "mve"),
                         level = 0.975,
                         ids = rownames(X),
                         pch = c(1, 16),
                         col = c("black", "red"),
                         label.pos = 2,
                         xlab,
                         ylab,
                         verbose = FALSE,
                         ...) {
  
  if (nrow(X) != nrow(Y)) stop(paste("Number of rows in", deparse(substitute(X)), 
                                     "and", deparse(substitute(X)), "differ."))
  
  numeric_X <- sapply(X, is.numeric)
  if (!all(numeric_X)) stop("All columns in X must be numeric")
  numeric_Y <- sapply(Y, is.numeric)
  if (!all(numeric_Y)) stop("All columns in Y must be numeric")
  
  method = match.arg(method)
  method.case <- ifelse(method == "classical", "Classical", toupper(method))

  if(missing(xlab)) xlab <- paste("Mahalanobis distances of", deparse(substitute(X)))
  if(missing(ylab)) ylab <- paste("Mahalanobis distances of", deparse(substitute(Y)))
  xlab <- paste(method.case, xlab)
  ylab <- paste(method.case, ylab)

  # Calculate distances  
  distX <- Mahalanobis(X, method = method) |> sqrt()
  distY <- Mahalanobis(Y, method = method) |> sqrt()
  
  q <- ncol(X)
  p <- ncol(Y)
  cutoffs <- qchisq(level, c(q, p)) |> sqrt()
  cat(level, "distance cutoffs:", cutoffs, "\n")
  out <- (distX > cutoffs[1]) | distY > cutoffs[2]
  out.rows <- which(out)
  
  # browser()
  
  
  plot(distX, distY,
       pch = ifelse(out, pch[2], pch[1]),
       col = ifelse(out, col[2], col[1]),
       xlab = xlab, ylab = ylab,
       ...)
  abline(v = cutoffs[1], h = cutoffs[2], col = col[2])
  text(distX[out.rows], distY[out.rows], 
       labels = ids[out.rows],
       pos = label.pos)
  
  res <- data.frame(distX = distX, distY = distY)
  rownames(res) <- ids
  res <- res[out.rows, ]
  invisible(res)
}

#' @rdname distancePlot
#' @exportS3Method distancePlot formula

distancePlot.formula <- function(X, Y, data, ...) {
  form <- X
  mf <- model.frame(form, data, ...)
  Y <- mf[, 1]
  X <- mf[,-1]

  distancePlot.default(X, Y, ...)
  
}

#' @rdname distancePlot
#' @exportS3Method distancePlot mlm
#' 
distancePlot.mlm <- function(X, ...) {
  Y <- residuals(X)
  X <- as.data.frame(model.matrix(X)[,-1])
  ylab <- "Mahalanobis distances of residuals"

  distancePlot.default(X, Y, ylab = ylab, ...)
} 


if (FALSE){
  # data(NLSY, package = "heplots")
  # NLSY.mlm <- lm(cbind(math, read) ~ income + educ + antisoc + hyperact,
  #                data = NLSY)
  # 
  # distancePlot(NLSY[, 3:6], residuals(NLSY.mlm), level = 0.975)
  # 
  # distancePlot(NLSY.mlm)
  # 
  # X <- model.matrix(NLSY.mlm)
  # Y <- residuals(NLSY.mlm)
  # distancePlot(X, Y)
  
  insight::get_data(NLSY.mlm) |> str()
  insight::get_response(NLSY.mlm) |> str()
  insight::find_response(NLSY.mlm)
  insight::find_formula(NLSY.mlm) 
  
}