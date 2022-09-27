# create a reduced version of the TIPI data, incorporating the reversed items

load("C:/Dropbox/R/NetworkTrees/TIPI.Rdata")
str(TIPI)

#' The first 10 columns are the personality items. The letters stand for Extraversion, Agreeableness, Conscientiousness, Neuroticism, and Openness. The _r means that item is asked in reverse.

#' Let's score the domains and create a vector of the personality domain names for later convenience:

TIPI$Extraversion <- (TIPI$E + (8-TIPI$E_r))/2
TIPI$Neuroticism <- (TIPI$N + (8-TIPI$N_r))/2
TIPI$Conscientiousness <- (TIPI$C + (8-TIPI$C_r))/2
TIPI$Agreeableness <- (TIPI$A + (8-TIPI$A_r))/2
TIPI$Openness <- (TIPI$O + (8-TIPI$O_r))/2

orig_items <- c("E","A_r","C","N","O","E_r","A","C_r","N_r","O_r")
items <- c("Extraversion", "Neuroticism", "Conscientiousness", "Agreeableness", "Openness")


TIPI <- TIPI |>
  select(Extraversion:Openness, education:familysize)

save(TIPI, file = "TIPI-orig.RData")

load("TIPI-orig.RData")


library(dplyr)
library(forcats)
library(car)
library(heplots)
library(candisc)

# need to abbreviate levels
table(TIPI$gender)  # other?
levels(TIPI$education)  # abbreviate
levels(TIPI$engnat)  # abbreviate ?
levels(TIPI$race)  # abbreviate ?

TIPI <- TIPI |>
  filter(gender != "Other") |>
  mutate(gender = factor(gender, labels = c("M", "F"), exclude = "Other")) |>
  #  fct_drop(gender) |>
  mutate(education = ordered(education, labels = c("<HS", "HS", "Univ", "Grad"))) |> 
  mutate(engnat = factor(engnat, labels = c("Native", "Non-native"))) |>
  mutate(race = factor(race, labels = c("Asian", "Arab", "Black", "Indig-White", "Other"))) 

#  droplevels() 

save(TIPI, file = "TIPI.RData")
promptData(TIPI)
