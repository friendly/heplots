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

