ellipse.axes <- function(
    x, 
    centre = c(0, 0), 
    center = center,
    scale = c(1, 1), 
    level = 0.95,
    t = sqrt(qchisq(level, 2)), 
    which = 1:2, 
    labels=TRUE, 
    label.ends=c(2,4), ...) 
{
  stopifnot(is.matrix(x)) 
  stopifnot(dim(x)[1] ==  dim(x)[2])  # square matrix?
  
  cov <- x[which, which]
  eig <- eigen(cov)

  # coordinate axes, (-1, 1), in pairs, for X, Y,
  axes <- matrix(
    c(-1, 0,
       1, 0,
       0, -1,
       0, 1), nrow = 4, ncol = 2, byrow = TRUE)
  rownames(axes)<- apply(expand.grid(c("min","max"),c("X","Y"))[,2:1],
                         1, paste, collapse="")
  colnames(axes) <- colnames(cov)

  # transform to PC axes
  result <- axes %*% sqrt(diag(eig$values)) %*% t(eig$vectors)
  colnames(result) <- colnames(cov)
  # scale
  result <- result %*% diag(rep(t, 2))
  # center at values of centre
  result <- sweep(result, 2L, centre, FUN="+")
  # convert to something that can be used by lines()
  
  result
  
}

data(iris)
cov <- cov(iris[,1:2])
mu <- colMeans(iris[,1:2])

radius <- sqrt(qchisq(0.68, 2))
plot(iris[,1:2])
car::ellipse(mu, cov, radius = radius)
res <- ellipse.axes(cov, centre=mu, level = 0.68)
lines(res[1:2,], lwd=2)
lines(res[3:4,])


