library(dplyr)
schooldata_sites <- read.csv("data-raw/schooldata-sites.csv")

schooldata_sites <- schooldata_sites |>
  mutate(type = factor(type, levels = c("PFT", "NFT")),
         model = factor(model),
         region = factor(region),
         city_size = factor(city_size))
str(schooldata_sites)
