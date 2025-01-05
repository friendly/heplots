# Find noteworthy points in a 2D scatterplot

noteworthy <- function(x, y, 
                       n,
                       method = "mahal",
                       level = 0.95){

  method <- match.arg(method)
  method <- pmatch(method, c("mahal", "x", "y", "r"))
  
  id.criterion <- switch(method,
    'x' = abs(x - mean(x)),
    'y' = abs(y - mean(y)),
    'r' = abs(y),
    'mahal' = rowSums( qr.Q(qr(cbind(1, x, y)))^2)
  )
}
              
