library(dplyr)
schoolsites <- read.csv("data-raw/schoolsites.csv")

schoolsites <- schoolsites |>
  mutate(type = factor(type, levels = c("PFT", "NFT")),
         model = factor(model),
         region = factor(region),
         city_size = ordered(city_size, levels = c("Rural", "Small", "Medium", "Large")))
str(schoolsites)

save(schoolsites, file = "data/schoolsites.RData")

source("C:/Dropbox/R/functions/use_data_doc.R")
use_data_doc(schoolsites, filename = "data-raw/schoolsites-doc.R")

# examples
data(schoolsites)
data(schooldata)
schools <- cbind(schooldata, schoolsites)

schools.mod0 <- lm(cbind(education, occupation, visit, counseling, teacher, reading, mathematics, selfesteem) ~
                    type + model + region, data = schools)
car::Anova(schools.mod)

schools.mod <- lm(cbind(reading, mathematics, selfesteem) ~
                    education + occupation + visit + counseling + teacher +
                    type + region, data = schools)
car::Anova(schools.mod)

heplot(schools.mod)

pairs(schools.mod, terms = "type")

library(candisc)
schools.can <- candisc(schools.mod, term = "type")
schools.can
plot(schools.can)


