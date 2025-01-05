# Find noteworthy points in a 2D scatterplot

noteworthy <- function(x, y, 
                       n,
                       method = "mahal",
                       level = 0.95){

#  method <- match.arg(method)
  method <- pmatch(method, c("dsq", "mahal", "x", "y", "r", "qx", "qy"))
  
  id.criterion <- switch(method,
    'mahal' = rowSums( qr.Q(qr(cbind(1, x, y)))^2 ),
    'x' = abs(x - mean(x)),
    'y' = abs(y - mean(y)),
    'r' = abs(y),
    'qx' = quantile(x),
    'qy' = quantile(y)
  )
  if(method %in% c("qx", "qy"))
    id.criterion <- id.criterion[id.criterion > level]
  if(method %in% c("dsq", "mahal"))
    id.criterion <- id.criterion[id.criterion > qchisq(2, level)]
  if(length(id.criterion) == 0) return(NULL)
  index <-  order(id.criterion, decreasing=TRUE)[1L:min(length(id.criterion), n)]
  index
}
              
if(FALSE) {
  set.seed(47)
  x <- c(runif(100), 1.5, 1.6)
  y <- c(2*x[1:100] + rnorm(100, sd = 1.2), -2, 6 )
  plot(x, y)
  abline(lm(y ~ x))
  
  noteworthy(x, y, n=5, method = "mahal")
  noteworthy(x, y, n=5, method = "x")
  noteworthy(x, y, n=5, method = "y")
  noteworthy(x, y, n=5, method = "r")
  noteworthy(x, y, n=5, method = "qx")
  noteworthy(x, y, n=5, method = "qy")
  
}