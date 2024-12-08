library(car)
library(heplots)
library(dplyr)

iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ 
                 Species, data=iris)

glance(iris.mod)

glance(iris.mod) |>
  select( -adj.r.squared, -nobs)


tidy(iris.mod)

(iris.aov <- Manova(iris.mod))
names(iris.aov)

(iris.manova <- manova(iris.mod))
glance(iris.manova)
tidy(iris.manova)


# soils data
data(Soils, package="carData")
soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth,
                data=Soils)
Manova(soils.mod)
summary(Anova(soils.mod), univariate=TRUE, multivariate=FALSE)

print(summary(Anova(soils.mod), univariate=FALSE, multivariate=TRUE), SSP=FALSE)
