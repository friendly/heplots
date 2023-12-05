# test ggplot stat_ellipse to add axes

library(ggplot2)
library(dplyr)

data(iris) 

gg1 <-
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point() +
  stat_ellipse() +
  theme_bw() 
gg1

# Extract components
build <- ggplot_build(gg1)$data
ell <- build[[2]]   # the data ellipse

gg2 <-
  ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) +
  geom_point() +
  stat_ellipse() +
  theme_bw() +
  theme(legend.position = "top")

build <- ggplot_build(gg2)$data
ell <- build[[2]]   # the data ellipse
str(ell)



