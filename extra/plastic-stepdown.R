#' ---
#' title: Stepdown analysis for MLMs
#' ---
#' 
library(heplots)
library(dplyr)
library(broom)
library(purrr)
library(car)
data("Plastic")

plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
Anova(plastic.mod)

# sequential analysis, entering previous responses as predictors
plastic.1 <- lm(tear ~ rate*additive, data=Plastic)
plastic.2 <- lm(gloss ~ rate*additive + tear, data=Plastic)
plastic.3 <- lm(opacity ~ rate*additive + tear + gloss, data=Plastic)

# how to get model summaries?
#glance(plastic.1, plastic.2, plastic.3)
map(list(plastic.1, plastic.2, plastic.3), glance)
map(list(plastic.1, plastic.2, plastic.3), tidy)

# use successive residuals from earlier predictors

lm2 <- lm(gloss ~ tear, data=Plastic)
lm3 <- lm(opacity ~ tear + gloss, data=Plastic)

Plastic <- Plastic |>
  mutate(`gloss|tear` = residuals(lm2),
         `opacity|tear+gloss` = residuals(lm3))

# fit model using orthogonal predictors: same result as original MLM
plastic.seq <- lm(cbind(tear, `gloss|tear`, `opacity|tear+gloss`) ~ rate*additive, data=Plastic)
Anova(plastic.seq)

heplot(plastic.mod, fill=TRUE, fill.alpha=0.05)

heplot(plastic.seq, fill=TRUE, fill.alpha=0.05)

pairs(plastic.mod, fill=TRUE, fill.alpha=0.05)

pairs(plastic.seq, fill=TRUE, fill.alpha=0.05)












