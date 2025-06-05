# plot two sets of Malahanobis distances

#' Plot two sets of Mahalanobis distances for the same dataset
#' 
distancePlot <- function(X, Y, 
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
  
  dist.X <- Mahalanobis(X, method = method) |> sqrt()
  dist.Y <- Mahalanobis(Y, method = method) |> sqrt()
  
  q <- ncol(X)
  p <- ncol(Y)
  cutoffs <- qchisq(level, c(q, p)) |> sqrt()
  out <- dist.X > cutoffs[1] | dist.Y > cutoffs[2]
  out.rows <- which(out)
  
  
  plot(dist.X, dist.Y,
       pch = ifelse(out, pch[2], pch[1]),
       col = ifelse(out, col[2], col[1]),
       xlab = xlab, ylab = ylab,
       ...)
  abline(h = cutoffs[1], v = cutoffs[2], col = col[2])
  text(dist.X[out.rows], dist.Y[out.rows], 
       labels = ids[out.rows],
       pos = label.pos)
}