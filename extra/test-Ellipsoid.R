data(iris)
# 
xyz <- iris[, 1:3]
mu <- apply(xyz, 2, mean)
sigma <- cov(xyz)
dfe <- nrow(xyz)
level <- 0.68
radius <- sqrt(3 * qf(level, 3, dfe))
ell <- Ellipsoid(sigma, center = mu, radius = radius)
print(ell)  
