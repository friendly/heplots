pkgname <- "volker"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('volker')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("add_clusters")
### * add_clusters

flush(stderr()); flush(stdout())

### Name: add_clusters
### Title: Add cluster number to a data frame
### Aliases: add_clusters

### ** Examples

library(volker)
ds <- volker::chatgpt

volker::add_clusters(ds, starts_with("cg_adoption"), k = 3)



cleanEx()
nameEx("add_factors")
### * add_factors

flush(stderr()); flush(stdout())

### Name: add_factors
### Title: Add PCA columns along with summary statistics (KMO and Bartlett
###   test) to a data frame
### Aliases: add_factors

### ** Examples

library(volker)
ds <- volker::chatgpt

volker::add_factors(ds, starts_with("cg_adoption"))



cleanEx()
nameEx("add_index")
### * add_index

flush(stderr()); flush(stdout())

### Name: add_index
### Title: Calculate the mean value of multiple items
### Aliases: add_index

### ** Examples

ds <- volker::chatgpt
volker::add_index(ds, starts_with("cg_adoption"))



cleanEx()
nameEx("add_model")
### * add_model

flush(stderr()); flush(stdout())

### Name: add_model
### Title: Add a column with predicted values from a regression model
### Aliases: add_model
### Keywords: internal

### ** Examples

library(volker)
data <- filter(volker::chatgpt, sd_gender != "diverse")

data <- data |>
  add_model(use_work, categorical = c(sd_gender, adopter), metric = sd_age)




cleanEx()
nameEx("agree_tab")
### * agree_tab

flush(stderr()); flush(stdout())

### Name: agree_tab
### Title: Agreement for multiple items
### Aliases: agree_tab
### Keywords: internal

### ** Examples

library(dplyr)
library(volker)

data <- volker::chatgpt

# Prepare example data.
# First, recode "x" to TRUE/FALSE for the first coder's sample.
data_coder1 <- data |>
  mutate(across(starts_with("cg_act_"), ~ ifelse(is.na(.), FALSE, TRUE))) %>%
  mutate(coder = "coder one")

# Second, recode using a dictionary approach for the second coder's sample.
data_coder2 <- data |>
  mutate(across(starts_with("cg_act_"), ~ ifelse(is.na(.), FALSE, TRUE))) %>%
  mutate(cg_act_write = grepl("write|text|translate", tolower(cg_activities))) %>%
  mutate(coder="coder two")

data_coded <- bind_rows(
  data_coder1,
  data_coder2
)

# Reliability coefficients are strictly only appropriate for manual codings
agree_tab(data_coded, cg_act_write,  coder, case, method = "reli")

# Better use classification performance indicators to compare the
# dictionary approach with human coding
agree_tab(data_coded, cg_act_write,  coder, case, method = "class")




cleanEx()
nameEx("cluster_plot")
### * cluster_plot

flush(stderr()); flush(stdout())

### Name: cluster_plot
### Title: Get plot for clustering result
### Aliases: cluster_plot
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

cluster_plot(data, starts_with("cg_adoption"), k = 2)




cleanEx()
nameEx("cluster_tab")
### * cluster_tab

flush(stderr()); flush(stdout())

### Name: cluster_tab
### Title: Get tables for clustering result
### Aliases: cluster_tab
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

cluster_tab(data, starts_with("cg_adoption"), k = 2)




cleanEx()
nameEx("codebook")
### * codebook

flush(stderr()); flush(stdout())

### Name: codebook
### Title: Get variable and value labels from a data set
### Aliases: codebook

### ** Examples

volker::codebook(volker::chatgpt)



cleanEx()
nameEx("data_clean")
### * data_clean

flush(stderr()); flush(stdout())

### Name: data_clean
### Title: Prepare dataframe for the analysis
### Aliases: data_clean
### Keywords: internal

### ** Examples

ds <- volker::chatgpt
ds <- data_clean(ds)



cleanEx()
nameEx("data_clean_default")
### * data_clean_default

flush(stderr()); flush(stdout())

### Name: data_clean_default
### Title: Prepare data originating from SoSci Survey or SPSS
### Aliases: data_clean_default
### Keywords: internal

### ** Examples

ds <- volker::chatgpt
ds <- data_clean_default(ds)



cleanEx()
nameEx("data_prepare")
### * data_prepare

flush(stderr()); flush(stdout())

### Name: data_prepare
### Title: Prepare data for calculation
### Aliases: data_prepare
### Keywords: internal

### ** Examples

data <- volker::chatgpt
data_prepare(data, sd_age, sd_gender)




cleanEx()
nameEx("diagnostics_cooksd")
### * diagnostics_cooksd

flush(stderr()); flush(stdout())

### Name: diagnostics_cooksd
### Title: Cook's distance plot
### Aliases: diagnostics_cooksd
### Keywords: internal

### ** Examples

library(volker)
data <- filter(volker::chatgpt, sd_gender != "diverse")

data <- add_model(data, use_work, metric = sd_age)

fit <- attr(data$prd_use_work, "lm.fit")
diagnostics_cooksd(fit)




cleanEx()
nameEx("diagnostics_qq")
### * diagnostics_qq

flush(stderr()); flush(stdout())

### Name: diagnostics_qq
### Title: Normal Q-Q
### Aliases: diagnostics_qq
### Keywords: internal

### ** Examples

library(volker)
data <- filter(volker::chatgpt, sd_gender != "diverse")

data <- add_model(data, use_work, metric = sd_age)

fit <- attr(data$prd_use_work, "lm.fit")
diagnostics_qq(fit)




cleanEx()
nameEx("diagnostics_resid_fitted")
### * diagnostics_resid_fitted

flush(stderr()); flush(stdout())

### Name: diagnostics_resid_fitted
### Title: Residuals vs Fitted plot
### Aliases: diagnostics_resid_fitted
### Keywords: internal

### ** Examples

library(volker)
data <- filter(volker::chatgpt, sd_gender != "diverse")

data <- add_model(data, use_work, metric = sd_age)

fit <- attr(data$prd_use_work, "lm.fit")
diagnostics_resid_fitted(fit)



cleanEx()
nameEx("diagnostics_scale_location")
### * diagnostics_scale_location

flush(stderr()); flush(stdout())

### Name: diagnostics_scale_location
### Title: Scale-Location (Spread-Location)
### Aliases: diagnostics_scale_location
### Keywords: internal

### ** Examples

library(volker)
data <- filter(volker::chatgpt, sd_gender != "diverse")

data <- add_model(data, use_work, metric = sd_age)

fit <- attr(data$prd_use_work, "lm.fit)
diagnostics_scale_location(fit")




cleanEx()
nameEx("effect_counts")
### * effect_counts

flush(stderr()); flush(stdout())

### Name: effect_counts
### Title: Output effect sizes and test statistics for count data
### Aliases: effect_counts

### ** Examples

library(volker)
data <- volker::chatgpt

effect_counts(data, sd_gender, adopter)




cleanEx()
nameEx("effect_counts_items")
### * effect_counts_items

flush(stderr()); flush(stdout())

### Name: effect_counts_items
### Title: Test homogeneity of category shares for multiple items
### Aliases: effect_counts_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_counts_items(data, starts_with("cg_adoption_adv"))




cleanEx()
nameEx("effect_counts_items_grouped")
### * effect_counts_items_grouped

flush(stderr()); flush(stdout())

### Name: effect_counts_items_grouped
### Title: Effect size and test for comparing multiple variables by a
###   grouping variable
### Aliases: effect_counts_items_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_counts_items_grouped(
  data, starts_with("cg_adoption_adv"),  sd_gender
)




cleanEx()
nameEx("effect_counts_items_grouped_items")
### * effect_counts_items_grouped_items

flush(stderr()); flush(stdout())

### Name: effect_counts_items_grouped_items
### Title: Effect size and test for comparing multiple variables by
###   multiple grouping variables
### Aliases: effect_counts_items_grouped_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_counts(
  data,
  starts_with("cg_adoption_adv"),
  starts_with("use_")
)




cleanEx()
nameEx("effect_counts_one")
### * effect_counts_one

flush(stderr()); flush(stdout())

### Name: effect_counts_one
### Title: Test homogeneity of category shares
### Aliases: effect_counts_one
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

data |>
  filter(sd_gender != "diverse") |>
  effect_counts_one(sd_gender)




cleanEx()
nameEx("effect_counts_one_grouped")
### * effect_counts_one_grouped

flush(stderr()); flush(stdout())

### Name: effect_counts_one_grouped
### Title: Output test statistics and effect size for contingency tables
### Aliases: effect_counts_one_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_counts_one_grouped(data, adopter, sd_gender)




cleanEx()
nameEx("effect_metrics")
### * effect_metrics

flush(stderr()); flush(stdout())

### Name: effect_metrics
### Title: Output effect sizes and test statistics for metric data
### Aliases: effect_metrics

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics(data, sd_age, sd_gender)




cleanEx()
nameEx("effect_metrics_items")
### * effect_metrics_items

flush(stderr()); flush(stdout())

### Name: effect_metrics_items
### Title: Test whether a distribution is normal for each item
### Aliases: effect_metrics_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics_items(data, starts_with("cg_adoption"))





cleanEx()
nameEx("effect_metrics_items_cor")
### * effect_metrics_items_cor

flush(stderr()); flush(stdout())

### Name: effect_metrics_items_cor
### Title: Output correlation coefficients for items and one metric
###   variable
### Aliases: effect_metrics_items_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics_items_cor(
  data, starts_with("cg_adoption_adv"), sd_age
)




cleanEx()
nameEx("effect_metrics_items_cor_items")
### * effect_metrics_items_cor_items

flush(stderr()); flush(stdout())

### Name: effect_metrics_items_cor_items
### Title: Output correlation coefficients for multiple items
### Aliases: effect_metrics_items_cor_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics_items_cor_items(
  data,
  starts_with("cg_adoption_adv"),
  starts_with("use"),
  metric = TRUE
)




cleanEx()
nameEx("effect_metrics_items_grouped")
### * effect_metrics_items_grouped

flush(stderr()); flush(stdout())

### Name: effect_metrics_items_grouped
### Title: Compare groups for each item by calculating F-statistics and
###   effect sizes
### Aliases: effect_metrics_items_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics(data, starts_with("cg_adoption_"), adopter)




cleanEx()
nameEx("effect_metrics_one")
### * effect_metrics_one

flush(stderr()); flush(stdout())

### Name: effect_metrics_one
### Title: Test whether a distribution is normal
### Aliases: effect_metrics_one
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics_one(data, sd_age)




cleanEx()
nameEx("effect_metrics_one_cor")
### * effect_metrics_one_cor

flush(stderr()); flush(stdout())

### Name: effect_metrics_one_cor
### Title: Test whether the correlation is different from zero
### Aliases: effect_metrics_one_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics_one_cor(data, sd_age, use_private, metric = TRUE)




cleanEx()
nameEx("effect_metrics_one_grouped")
### * effect_metrics_one_grouped

flush(stderr()); flush(stdout())

### Name: effect_metrics_one_grouped
### Title: Output a regression table with estimates and macro statistics
### Aliases: effect_metrics_one_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

effect_metrics_one_grouped(data, sd_age, sd_gender)




cleanEx()
nameEx("factor_plot")
### * factor_plot

flush(stderr()); flush(stdout())

### Name: factor_plot
### Title: Get plot with factor analysis result
### Aliases: factor_plot
### Keywords: internal

### ** Examples

library(volker)
ds <- volker::chatgpt

volker::factor_plot(ds, starts_with("cg_adoption"), k = 3)



cleanEx()
nameEx("factor_tab")
### * factor_tab

flush(stderr()); flush(stdout())

### Name: factor_tab
### Title: Get tables with factor analysis results
### Aliases: factor_tab
### Keywords: internal

### ** Examples

library(volker)
ds <- volker::chatgpt

volker::factor_tab(ds, starts_with("cg_adoption"), k = 3)



cleanEx()
nameEx("html_report")
### * html_report

flush(stderr()); flush(stdout())

### Name: html_report
### Title: Volker style HTML document format
### Aliases: html_report

### ** Examples

## Not run: 
##D # Add `volker::html_report` to the output options of your Markdown document:
##D #
##D # ```
##D # ---
##D # title: "How to create reports?"
##D # output: volker::html_report
##D # ---
##D # ```
## End(Not run)



cleanEx()
nameEx("knit_print.vlkr_plt")
### * knit_print.vlkr_plt

flush(stderr()); flush(stdout())

### Name: knit_print.vlkr_plt
### Title: Printing method for volker plots when knitting
### Aliases: knit_print.vlkr_plt
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

pl <- plot_metrics(data, sd_age)
print(pl)




cleanEx()
nameEx("labs_apply")
### * labs_apply

flush(stderr()); flush(stdout())

### Name: labs_apply
### Title: Set column and value labels
### Aliases: labs_apply

### ** Examples

library(volker)

# Set column labels using the items-parameter
volker::chatgpt %>%
  labs_apply(
   items = list(
     "cg_adoption_advantage_01" = "Allgemeine Vorteile",
     "cg_adoption_advantage_02" = "Finanzielle Vorteile",
     "cg_adoption_advantage_03" = "Vorteile bei der Arbeit",
     "cg_adoption_advantage_04" = "Macht mehr Spaß"
   )
 ) %>%
 tab_metrics(starts_with("cg_adoption_advantage_"))

# Set value labels using the values-parameter
 volker::chatgpt %>%
   labs_apply(
     cols=starts_with("cg_adoption"),
     values = list(
       "1" = "Stimme überhaupt nicht zu",
       "2" = "Stimme nicht zu",
       "3" = "Unentschieden",
       "4" = "Stimme zu",
       "5" =  "Stimme voll und ganz zu"
     )
   ) %>%
   plot_metrics(starts_with("cg_adoption"))




cleanEx()
nameEx("labs_clear")
### * labs_clear

flush(stderr()); flush(stdout())

### Name: labs_clear
### Title: Remove all comments from the selected columns
### Aliases: labs_clear

### ** Examples

library(volker)
volker::chatgpt |>
  labs_clear()



cleanEx()
nameEx("labs_restore")
### * labs_restore

flush(stderr()); flush(stdout())

### Name: labs_restore
### Title: Restore labels from the codebook store in the codebook
###   attribute.
### Aliases: labs_restore

### ** Examples

library(dplyr)
library(volker)

volker::chatgpt |>
  labs_store() |>
  mutate(sd_age = 2024 - sd_age) |>
  labs_restore() |>
  tab_metrics(sd_age)



cleanEx()
nameEx("labs_store")
### * labs_store

flush(stderr()); flush(stdout())

### Name: labs_store
### Title: Get the current codebook and store it in the codebook attribute.
### Aliases: labs_store

### ** Examples

library(dplyr)
library(volker)

volker::chatgpt |>
  labs_store() |>
  mutate(sd_age = 2024 - sd_age) |>
  labs_restore() |>
  tab_metrics(sd_age)



cleanEx()
nameEx("model_metrics_plot")
### * model_metrics_plot

flush(stderr()); flush(stdout())

### Name: model_metrics_plot
### Title: Plot regression coefficients
### Aliases: model_metrics_plot model_plot
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

data |>
  filter(sd_gender != "diverse") |>
  model_metrics_plot(use_work, categorical = c(sd_gender, adopter), metric = sd_age)




cleanEx()
nameEx("model_metrics_tab")
### * model_metrics_tab

flush(stderr()); flush(stdout())

### Name: model_metrics_tab
### Title: Output a regression table with estimates and macro statistics
###   for multiple categorical or metric independent variables
### Aliases: model_metrics_tab model_tab
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

data |>
  filter(sd_gender != "diverse") |>
  model_metrics_tab(use_work, categorical = c(sd_gender, adopter), metric = sd_age)




cleanEx()
nameEx("pdf_report")
### * pdf_report

flush(stderr()); flush(stdout())

### Name: pdf_report
### Title: Volker style PDF document format
### Aliases: pdf_report

### ** Examples

## Not run: 
##D # Add `volker::pdf_report` to the output options of your Markdown document:
##D #
##D # ```
##D # ---
##D # title: "How to create reports?"
##D # output: volker::pdf_report
##D # ---
##D # ```
## End(Not run)



cleanEx()
nameEx("plot_counts")
### * plot_counts

flush(stderr()); flush(stdout())

### Name: plot_counts
### Title: Output a frequency plot
### Aliases: plot_counts

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts(data, sd_gender)




cleanEx()
nameEx("plot_counts_items")
### * plot_counts_items

flush(stderr()); flush(stdout())

### Name: plot_counts_items
### Title: Output frequencies for multiple variables
### Aliases: plot_counts_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts_items(data, starts_with("cg_adoption_"))




cleanEx()
nameEx("plot_counts_items_cor")
### * plot_counts_items_cor

flush(stderr()); flush(stdout())

### Name: plot_counts_items_cor
### Title: Plot percent shares of multiple items compared by a metric
###   variable split into groups
### Aliases: plot_counts_items_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts_items_cor(
  data, starts_with("cg_adoption_"), sd_age,
  category=c("agree","strongly agree")
)

plot_counts_items_cor(
  data, starts_with("cg_adoption_"), sd_age,
  category=c(4,5)
)




cleanEx()
nameEx("plot_counts_items_grouped")
### * plot_counts_items_grouped

flush(stderr()); flush(stdout())

### Name: plot_counts_items_grouped
### Title: Plot percent shares of multiple items compared by groups
### Aliases: plot_counts_items_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt
plot_counts_items_grouped(
  data, starts_with("cg_adoption_"), adopter,
  category=c("agree","strongly agree")
)

plot_counts_items_grouped(
  data, starts_with("cg_adoption_"), adopter,
  category=c(4,5)
)




cleanEx()
nameEx("plot_counts_items_grouped_items")
### * plot_counts_items_grouped_items

flush(stderr()); flush(stdout())

### Name: plot_counts_items_grouped_items
### Title: Correlation of categorical items with categorical items
### Aliases: plot_counts_items_grouped_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts_items_grouped_items(
  data,
  starts_with("cg_adoption_advantage"),
  starts_with("cg_adoption_fearofuse"),
  method ="cramer"
)




cleanEx()
nameEx("plot_counts_one")
### * plot_counts_one

flush(stderr()); flush(stdout())

### Name: plot_counts_one
### Title: Plot the frequency of values in one column
### Aliases: plot_counts_one
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts_one(data, sd_gender)




cleanEx()
nameEx("plot_counts_one_cor")
### * plot_counts_one_cor

flush(stderr()); flush(stdout())

### Name: plot_counts_one_cor
### Title: Plot frequencies cross tabulated with a metric column that will
###   be split into groups
### Aliases: plot_counts_one_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts_one_cor(data, adopter, sd_age)




cleanEx()
nameEx("plot_counts_one_grouped")
### * plot_counts_one_grouped

flush(stderr()); flush(stdout())

### Name: plot_counts_one_grouped
### Title: Plot frequencies cross tabulated with a grouping column
### Aliases: plot_counts_one_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_counts_one_grouped(data, adopter, sd_gender)




cleanEx()
nameEx("plot_metrics")
### * plot_metrics

flush(stderr()); flush(stdout())

### Name: plot_metrics
### Title: Output a plot with distribution parameters such as the mean
###   values
### Aliases: plot_metrics

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics(data, sd_age)




cleanEx()
nameEx("plot_metrics_items")
### * plot_metrics_items

flush(stderr()); flush(stdout())

### Name: plot_metrics_items
### Title: Output averages for multiple variables
### Aliases: plot_metrics_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_items(data, starts_with("cg_adoption_"))




cleanEx()
nameEx("plot_metrics_items_cor")
### * plot_metrics_items_cor

flush(stderr()); flush(stdout())

### Name: plot_metrics_items_cor
### Title: Multiple items correlated with one metric variable
### Aliases: plot_metrics_items_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_items_cor(data, starts_with("use_"), sd_age)




cleanEx()
nameEx("plot_metrics_items_cor_items")
### * plot_metrics_items_cor_items

flush(stderr()); flush(stdout())

### Name: plot_metrics_items_cor_items
### Title: Heatmap for correlations between multiple items
### Aliases: plot_metrics_items_cor_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_items_cor_items(data, starts_with("cg_adoption_adv"), starts_with("use_"))




cleanEx()
nameEx("plot_metrics_items_grouped")
### * plot_metrics_items_grouped

flush(stderr()); flush(stdout())

### Name: plot_metrics_items_grouped
### Title: Output averages for multiple variables compared by a grouping
###   variable
### Aliases: plot_metrics_items_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_items_grouped(data, starts_with("cg_adoption_"), sd_gender)




cleanEx()
nameEx("plot_metrics_one")
### * plot_metrics_one

flush(stderr()); flush(stdout())

### Name: plot_metrics_one
### Title: Output a density plot for a single metric variable
### Aliases: plot_metrics_one
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_one(data, sd_age)




cleanEx()
nameEx("plot_metrics_one_cor")
### * plot_metrics_one_cor

flush(stderr()); flush(stdout())

### Name: plot_metrics_one_cor
### Title: Correlate two items
### Aliases: plot_metrics_one_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_one_cor(data, use_private, sd_age)




cleanEx()
nameEx("plot_metrics_one_grouped")
### * plot_metrics_one_grouped

flush(stderr()); flush(stdout())

### Name: plot_metrics_one_grouped
### Title: Output averages for multiple variables
### Aliases: plot_metrics_one_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

plot_metrics_one_grouped(data, sd_age, sd_gender)




cleanEx()
nameEx("print.vlkr_list")
### * print.vlkr_list

flush(stderr()); flush(stdout())

### Name: print.vlkr_list
### Title: Printing method for volker lists
### Aliases: print.vlkr_list
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

rp <- report_metrics(data, sd_age, sd_gender, effect = TRUE)
print(rp)




cleanEx()
nameEx("print.vlkr_plt")
### * print.vlkr_plt

flush(stderr()); flush(stdout())

### Name: print.vlkr_plt
### Title: Printing method for volker plots
### Aliases: print.vlkr_plt plot.vlkr_plt
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

pl <- plot_metrics(data, sd_age)
print(pl)




cleanEx()
nameEx("print.vlkr_rprt")
### * print.vlkr_rprt

flush(stderr()); flush(stdout())

### Name: print.vlkr_rprt
### Title: Printing method for volker reports
### Aliases: print.vlkr_rprt
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

rp <- report_metrics(data, sd_age)
print(rp)




cleanEx()
nameEx("print.vlkr_tbl")
### * print.vlkr_tbl

flush(stderr()); flush(stdout())

### Name: print.vlkr_tbl
### Title: Printing method for volker tables.
### Aliases: print.vlkr_tbl
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tb <- tab_metrics(data, sd_age)
print(tb)




cleanEx()
nameEx("report_counts")
### * report_counts

flush(stderr()); flush(stdout())

### Name: report_counts
### Title: Create table and plot for categorical variables
### Aliases: report_counts

### ** Examples

library(volker)
data <- volker::chatgpt

report_counts(data, sd_gender)




cleanEx()
nameEx("report_metrics")
### * report_metrics

flush(stderr()); flush(stdout())

### Name: report_metrics
### Title: Create table and plot for metric variables
### Aliases: report_metrics

### ** Examples

library(volker)
data <- volker::chatgpt

report_metrics(data, sd_age)




cleanEx()
nameEx("skim_metrics")
### * skim_metrics

flush(stderr()); flush(stdout())

### Name: skim_metrics
### Title: A reduced skimmer for metric variables Returns a five point
###   summary, mean and sd, items count and alpha for scales added by
###   add_index()
### Aliases: skim_metrics
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

skim_metrics(data)




cleanEx()
nameEx("tab_counts")
### * tab_counts

flush(stderr()); flush(stdout())

### Name: tab_counts
### Title: Output a frequency table
### Aliases: tab_counts

### ** Examples

library(volker)
data <- volker::chatgpt

tab_counts(data, sd_gender)




cleanEx()
nameEx("tab_counts_items")
### * tab_counts_items

flush(stderr()); flush(stdout())

### Name: tab_counts_items
### Title: Output frequencies for multiple variables
### Aliases: tab_counts_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_counts_items(data, starts_with("cg_adoption_"))




cleanEx()
nameEx("tab_counts_items_cor")
### * tab_counts_items_cor

flush(stderr()); flush(stdout())

### Name: tab_counts_items_cor
### Title: Compare the values in multiple items by a metric column that
###   will be split into groups
### Aliases: tab_counts_items_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt
tab_counts_items_cor(
  data, starts_with("cg_adoption_"), sd_age,
  category=c("agree", "strongly agree")
)




cleanEx()
nameEx("tab_counts_items_grouped")
### * tab_counts_items_grouped

flush(stderr()); flush(stdout())

### Name: tab_counts_items_grouped
### Title: Compare the values in multiple items by a grouping column
### Aliases: tab_counts_items_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt
tab_counts_items_grouped(
  data, starts_with("cg_adoption_"), adopter,
  category=c("agree", "strongly agree")
)




cleanEx()
nameEx("tab_counts_one")
### * tab_counts_one

flush(stderr()); flush(stdout())

### Name: tab_counts_one
### Title: Output a frequency table for the values in one column
### Aliases: tab_counts_one
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_counts_one(data, sd_gender)




cleanEx()
nameEx("tab_counts_one_cor")
### * tab_counts_one_cor

flush(stderr()); flush(stdout())

### Name: tab_counts_one_cor
### Title: Count values by a metric column that will be split into groups
### Aliases: tab_counts_one_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_counts_one_cor(data, adopter, sd_age)




cleanEx()
nameEx("tab_counts_one_grouped")
### * tab_counts_one_grouped

flush(stderr()); flush(stdout())

### Name: tab_counts_one_grouped
### Title: Output frequencies cross tabulated with a grouping column
### Aliases: tab_counts_one_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_counts_one_grouped(data, adopter, sd_gender)




cleanEx()
nameEx("tab_metrics")
### * tab_metrics

flush(stderr()); flush(stdout())

### Name: tab_metrics
### Title: Output a table with distribution parameters
### Aliases: tab_metrics

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics(data, sd_age)




cleanEx()
nameEx("tab_metrics_items")
### * tab_metrics_items

flush(stderr()); flush(stdout())

### Name: tab_metrics_items
### Title: Output a five point summary table for multiple items
### Aliases: tab_metrics_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_items(data, starts_with("cg_adoption_"))




cleanEx()
nameEx("tab_metrics_items_cor")
### * tab_metrics_items_cor

flush(stderr()); flush(stdout())

### Name: tab_metrics_items_cor
### Title: Output a correlation table for item battery and one metric
###   variable
### Aliases: tab_metrics_items_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_items_cor(
  data,
  starts_with("cg_adoption_adv"),
  sd_age,
  metric = TRUE
)




cleanEx()
nameEx("tab_metrics_items_cor_items")
### * tab_metrics_items_cor_items

flush(stderr()); flush(stdout())

### Name: tab_metrics_items_cor_items
### Title: Output a correlation table for item battery and item battery
### Aliases: tab_metrics_items_cor_items
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_items_cor_items(
  data,
  starts_with("cg_adoption_adv"),
  starts_with("use"),
  metric = TRUE
)




cleanEx()
nameEx("tab_metrics_items_grouped")
### * tab_metrics_items_grouped

flush(stderr()); flush(stdout())

### Name: tab_metrics_items_grouped
### Title: Output the means for groups in one or multiple columns
### Aliases: tab_metrics_items_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_items_grouped(data, starts_with("cg_adoption_"), sd_gender)




cleanEx()
nameEx("tab_metrics_one")
### * tab_metrics_one

flush(stderr()); flush(stdout())

### Name: tab_metrics_one
### Title: Output a five point summary table for the values in multiple
###   columns
### Aliases: tab_metrics_one
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_one(data, sd_age)




cleanEx()
nameEx("tab_metrics_one_cor")
### * tab_metrics_one_cor

flush(stderr()); flush(stdout())

### Name: tab_metrics_one_cor
### Title: Correlate two columns
### Aliases: tab_metrics_one_cor
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_one_cor(data, use_private, sd_age)




cleanEx()
nameEx("tab_metrics_one_grouped")
### * tab_metrics_one_grouped

flush(stderr()); flush(stdout())

### Name: tab_metrics_one_grouped
### Title: Output a five point summary for groups
### Aliases: tab_metrics_one_grouped
### Keywords: internal

### ** Examples

library(volker)
data <- volker::chatgpt

tab_metrics_one_grouped(data, sd_age, sd_gender)




cleanEx()
nameEx("theme_vlkr")
### * theme_vlkr

flush(stderr()); flush(stdout())

### Name: theme_vlkr
### Title: Define a default theme for volker plots
### Aliases: theme_vlkr

### ** Examples

library(volker)
library(ggplot2)
data <- volker::chatgpt

theme_set(theme_vlkr(base_size=15, base_fill = list("red")))
plot_counts(data, sd_gender)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
