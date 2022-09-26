# testing for glance.mlm

## devel stuff
library(purrr)

data(Hernior)
Hern.mod <- lm(cbind(leave, nurse, los) ~ age + sex +  pstat +  build + cardiac + resp, 
               data=Hernior)
#Anova(Hern.mod)
Hern.summary <- summary(Hern.mod)

# What are the statistics in the summary for each response?
names(sumry[[1]])
# [1] "call"          "terms"         "residuals"     "coefficients"  "aliased"       "sigma"         "df"            "r.squared"    
# [9] "adj.r.squared" "fstatistic"    "cov.unscaled" 

coefficients(Hern.mod)

map(sumry, magrittr::extract, c("r.squared", "sigma"))

map_dfr(sumry, magrittr::extract, c("r.squared", "adj.r.squared", "sigma"))

fstats <- map(sumry, magrittr::extract, c("fstatistic"))

## test
source(here::here("extra", "glance.mlm.R"))
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
glance(iris.mod)

