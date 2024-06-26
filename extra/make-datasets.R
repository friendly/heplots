# make a dataset of heplots datasets
library(stringr)
library(dplyr)
library(here)

dsets <- vcdExtra::datasets("heplots")[, c("Item", "dim", "Title")]
rowcols <- as.data.frame(stringr::str_split_fixed(dsets$dim,"x", 2))
colnames(rowcols) <- c("rows", "cols")

dsets.table <- cbind("dataset" = dsets$Item, rowcols, "title" =dsets$Title)
head(dsets.table)

write.csv(dsets.table, file = here::here("extra", "datasets.csv"))

# use DT to display

library(here)
library(glue)
library(dplyr)
dsets <- read.csv(here::here("extra", "datasets.csv"))
dsets <- dsets[,-1]  # remove row number

refurl <- "http://friendly.github.io/heplots/reference/"

dsets <- dsets |>
  mutate(dataset = glue::glue("[{dataset}]({refurl}{dataset}.html)")) 

#knitr::kable(dsets)

library(DT)
DT::datatable(dsets, 
              options = list(pageLength = 15),
              rownames = FALSE,
              filter = "none")
