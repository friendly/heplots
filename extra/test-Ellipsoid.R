library(heplots)
data(iris)

#source("R/Ellipsoid.R")
#source("R/label.ellipse.R")

# 
xyz <- iris[, 1:3]
mu <- apply(xyz, 2, mean)
sigma <- cov(xyz)
dfe <- nrow(xyz)
level <- 0.68
radius <- sqrt(3 * qf(level, 3, dfe))
ell <- Ellipsoid(sigma, center = mu, radius = radius)
print(ell) 

class(ell)
bbox3d(ell)

label.ellipse3d(ell, label = "Iris data")
# test data.frame method

ell2 <- Ellipsoid(xyz)
print(ell2)

# test bbox3d
ell3d <- rgl::ellipse3d(sigma, centre = mu)
bbox3d(ell3d)
