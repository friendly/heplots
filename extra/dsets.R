library(here)
library(dplyr)
library(tinytable)
dsets <- read.csv(here::here("extra", "datasets.csv"))
dsets <- dsets |> dplyr::select(-X) |> arrange(tolower(dataset))

# link dataset to pkgdown doc
refurl <- "http://friendly.github.io/heplots/reference/"

dsets <- dsets |>
  mutate(dataset = glue::glue("[{dataset}]({refurl}{dataset}.html)")) 

tinytable::tt(dsets[1:6,])

concepts <- dsets |>
  select(dataset, tags) |>
  tidyr::separate_longer_delim(tags, delim = " ") |>
  arrange(tags, dataset) |>
  summarize(datasets = toString(dataset), .by = tags) |>
  rename(concept = tags)

