# plot two sets of Malahanobis distances

#' Distance Plot for Multivariate Model Diagnosis
#' 
#' @description The plot, suggested by Rousseeu et al. () typically plots Mahalanobis distances of the \code{Y} response
#' variables against the distances of the \code{X} variables in a multivariate linear model.
#' When applied to a multivariate linear model itself, it plots the distances of the residuals for the \code{Y} variables
#' against the predictor terms in the model.matrix \code{X} 
#'
#' @param X 
#' @param Y 
#' @param method 
#' @param level 
#' @param ids 
#' @param pch 
#' @param col 
#' @param label.pos 
#' @param xlab 
#' @param ylab 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
distancePlot.default <- function(X, Y, 
                         method = c("classical", "mcd", "mve"),
                         level = 0.975,
                         ids = rownames(X),
                         pch = c(1, 16),
                         col = c("black", "red"),
                         label.pos = 2,
                         xlab = "Mahalanobis distances of X",
                         ylab = "Mahalanobis distances of Y",
                         ...) {
  
  if (nrow(X) != nrow(Y)) stop("Number of rows in X and Y differ.")
  method = match.arg(method)
  method.case <- ifelse(method == "classical", "Classical", toupper(method))
  xlab <- paste(method.case, xlab)
  ylab <- paste(method.case, ylab)
  
  distX <- Mahalanobis(X, method = method) |> sqrt()
  distY <- Mahalanobis(Y, method = method) |> sqrt()
  
  q <- ncol(X)
  p <- ncol(Y)
  cutoffs <- qchisq(level, c(q, p)) |> sqrt()
  cat(cutoffs, "\n")
  out <- (distX > cutoffs[1]) | distY > cutoffs[2]
  out.rows <- which(out)
  
#  browser()
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

#' @rdname distPlot
#' @exportS3Method distPlot formula

distancePlot.formula <- function(X, Y, ...) {
  form <- X
  mf <- model.frame(form, data)
  Y <- mf[, 1]
  X <- mf[,-1]

  distancePlot.default(X, Y, ...)
  
}

#' @rdname distPlot
#' @exportS3Method distPlot mlm
distancePlot.mlm <- function(X, ...) {
  Y <- residuals(X)
  X <- model.matrix(X)[,-1]

  distancePlot.default(X, Y, ...)
} 


if (FALSE){
  data(NLSY, package = "heplots")
  NLSY.mlm <- lm(cbind(math, read) ~ income + educ + antisoc + hyperact,
                 data = NLSY)
  
  distancePlot(NLSY[, 3:6], residuals(NLSY.mlm), level = 0.975)
  
  distancePlot(NLSY.mlm)

  X <- model.matrix(NLSY.mlm)
  Y <- residuals(NLSY.mlm)
  
  insight::get_data(NLSY.mlm) |> str()
  insight::get_response(NLSY.mlm) |> str()
  insight::find_response(NLSY.mlm)
  insight::find_formula(NLSY.mlm) 
  
}