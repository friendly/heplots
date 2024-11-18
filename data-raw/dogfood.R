library(readr)
#dogfood <- read_table("data-raw/dogfood.dat")
dogfood <- read.csv("data-raw/dogfood.dat", sep="")
#View(dogfood)

# make a factor, with levels in our order
dogfood$formula <- factor(dogfood$formula,
                          levels = c("Old", "New", "Major", "Alps"))

save(dogfood, file="data/dogfood.RData")


C <- matrix(
  c( 1,  1, -1, -1,         #Ours vs. Theirs
     0,  0,  1, -1,           #Major vs. Alps
     1, -1,  0,  0),             #New vs. Old
  nrow=4, ncol=3)

contrasts(dogfood$formula) <- C

str(dogfood)

save(dogfood, file="data-raw/dogfood.RData")

# create documentation
source("C:/Dropbox/R/functions/use_data_doc.R")
use_data_doc(dogfood, "data-raw/dogfood.Rd")

# analysis steps

library(car)
dog.mod <- lm(cbind(start, amount) ~ formula, data=dogfood)
Anova(dog.mod)

linearHypothesis(dog.mod, "formula1", title="Ours vs. Theirs")
linearHypothesis(dog.mod, "formula2", title="Old vs. New")
linearHypothesis(dog.mod, "formula3", title="Alps vs. Major")

heplot(dog.mod)

