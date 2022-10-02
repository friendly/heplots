#' Glance at an mlm object
#' 
#' This function takes an "mlm" object, fit by \code{\link[stats](lm)} with a multivariate response.
#' The goal is to return something analogous to \code{\link[broom](glance.lm)} for a univariate response linear model.
#' 
#' In the multivariate case, it returns a \code{\link[tibble](tibble)} with one row for each
#' response variable, containing goodness of fit measures, F-tests and p-values.
#' 
#' @param x An \code{mlm} object created by \code{\link[stats]{lm}}, i.e., with a multivariate response.
#' @param ... Additional arguments. Not used.
#' @method glance mlm
#' @return A \code{\link[tibble]{tibble}} with one row for each response variable and the columns:
#' \describe{
#'   \item{\code{r.squared}}{R squared statistic, or the percent of variation explained by the model.}
#'   \item{\code{adj.r.squared}}{Adjusted R squared statistic, which is like the R squared statistic except taking degrees of freedom into account.}
#'   \item{\code{sigma}}{Estimated standard error of the residuals}
#'   \item{\code{fstatitic}}{Overall F statistic for the model}
#'   \item{\code{numdf}}{Numerator degrees of freedom for the overall test}
#'   \item{\code{dendf}}{Denominator degrees of freedom for the overall test}
#'   \item{\code{p.value}}{P-value corresponding to the F statistic}
#'   \item{\code{nobs}}{Number of observations used}
#' }
#' @importFrom broom glance
#' @importFrom magrittr extract
#' @importFrom purrr map_dfr map
#' @importFrom tibble as_tibble
#' @export
#' @examples 
#' iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
#' glance(iris.mod)

# glance <- function(x, ...) {
#   UseMethod("glance")
# }



#' Glance at an mlm object
#' 
#' This function takes an "mlm" object, fit by \code{\link[stats]{lm}} with a
#' multivariate response. The goal is to return something analogous to
#' \code{\link[broom]{glance.lm}} for a univariate response linear model.
#' 
#' In the multivariate case, it returns a \code{\link[tibble]{tibble}} with one
#' row for each response variable, containing goodness of fit measures, F-tests
#' and p-values.
#' 
#' 
#' @param x An \code{mlm} object created by \code{\link[stats]{lm}}, i.e., with
#' a multivariate response.
#' @param \dots Additional arguments. Not used.
#' @return A \code{\link[tibble]{tibble}} with one row for each response
#' variable and the columns: \describe{ \item{list("r.squared")}{R squared
#' statistic, or the percent of variation explained by the model.}
#' \item{list("adj.r.squared")}{Adjusted R squared statistic, which is like the
#' R squared statistic except taking degrees of freedom into account.}
#' \item{list("sigma")}{Estimated standard error of the residuals}
#' \item{list("fstatitic")}{Overall F statistic for the model}
#' \item{list("numdf")}{Numerator degrees of freedom for the overall test}
#' \item{list("dendf")}{Denominator degrees of freedom for the overall test}
#' \item{list("p.value")}{P-value corresponding to the F statistic}
#' \item{list("nobs")}{Number of observations used} }
#' @author Michael Friendly
#' @seealso \code{\link[broom]{glance}}, \code{\link[broom]{glance.lm}}
#' @keywords multivariate models
#' @examples
#' 
#' iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
#' glance(iris.mod)
#' 
#' @export glance.mlm
glance.mlm <- function(x, ...) {
#  warn_on_subclass(x, "glance")
  int_only <- nrow(coefficients(x)) == 1

  sumry <- summary(x)
  response <- sub("Response ", "", names(sumry))
  # basic model summary statistics
  stats <- purrr::map_dfr(sumry, magrittr::extract, c("r.squared", "adj.r.squared", "sigma"))

  # get the F statistic & df for each response
  fstats <- purrr::map(sumry, magrittr::extract, c("fstatistic"))
  fstats <- t(as.data.frame(fstats))
  colnames(fstats)[1] <- "fstatistic"
  row.names(fstats) <- NULL

  # handle intercept-only case
  p.value = if (!int_only) {
    pf(fstats[,"fstatistic"], fstats[,"numdf"], 
       fstats[,"dendf"], lower.tail = FALSE)
    }
    else NA_real_
  if(int_only) {
    fstats[,"numdf"] <- NA_real_
    fstats[,"dendf"] <- NA_real_
  }

  nobs <- nobs(x)
  
  # join results together
  res <- cbind(response, stats, fstats, p.value, nobs)
  tibble::as_tibble(res)
}

