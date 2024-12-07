# MANOVA of absolute deviations, extending the idea of Levine test

leveneTests(iris[,1:4], iris$Species)



iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, 
               data=iris)

bm <- boxM(iris.mod) |> print()
plot(bm)

devs <- abs( colDevs(iris[, 1:4], iris$Species) )
dev.mod <- lm(devs ~ iris$Species)
Anova(dev.mod)


irisDevs <- data.frame(Species = iris$Species, devs)
dev.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, 
              data=irisDevs)
#Anova(dev.mod)

heplot(dev.mod)
pairs(dev.mod)

library(car)
spm(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width | Species,
    data=irisDevs)

col = c("red", "blue", "darkgreen", "black")
covEllipses(irisDevs[, -1], irisDevs$Species,
            fill=TRUE,
            fill.alpha = 0.1,
            lwd = 3,
            col = col)

covEllipses(irisDevs[, -1], irisDevs$Species, center=TRUE,
            fill=TRUE,
            fill.alpha = 0.1,
            lwd = 3,
            col = col)

