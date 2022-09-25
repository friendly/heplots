#' Glance at an mlm object
#' 
#' This function takes an "mlm" object, fit by \code{lm()} with a multivariate response.
#' The goal is to return something analogous to glance for a linear model.
#' 
#' @param x An \code{mlm} object created by \code{\link[stats]{lm}}, i.e., with a multivariate response.
#' @param ... Additional arguments. Not used.
#' @return A \code{\link[tibble]{tibble}} with one row for each response variable and the columns:

glance.mlm <- function(x, ...) {
#  warn_on_subclass(x, "glance")
  int_only <- nrow(coefficients(x)) == 1
  
  sumry <- summary(x)
  response <- sub("Response ", "", names(sumry))
  # basic model summary statistics
  stats <- purrr::map_dfr(sumry, magrittr::extract, c("r.squared", "adj.r.squared", "sigma"))

  # get the F statistics for each response
  fstats <- map(sumry, magrittr::extract, c("fstatistic"))
  fstats <- t(as.data.frame(fstats))
  colnames(fstats)[1] <- "fstatistic"
  row.names(fstats) <- NULL

  nobs <- nobs(x)
  
  # join results together
  res <- cbind(response, stats, fstats, nobs)
  as.tibble(res)
}




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
