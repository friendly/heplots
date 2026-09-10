# DONE: stdcoef() fixed (sd() can't take a data.frame; sapply(..., sd) / [[1]] instead) 9/10/2026
# DONE: stdmodel()/stdcoef.mlm() added for multivariate response support, for coefplot.mlm(std=) 9/10/2026

#' Standardize a Fitted Linear Model
#'
#' @description
#' `stdmodel()` refits a fitted `lm`/`mlm` object on standardized (mean 0, SD 1)
#' versions of its response variable(s) and its numeric predictors, leaving
#' factor-coded predictors on their original (raw 0/1 dummy) scale. This is the
#' engine behind [stdcoef()] for multivariate models, and behind
#' `coefplot.mlm(..., std = TRUE)`.
#'
#' Since the result is just an ordinary refit `"lm"`/`"mlm"` object, it also
#' works with other tools that expect one, e.g. [lmtest::coeftest()] and
#' [broom::tidy.coeftest()] on its result.
#'
#' @details
#' Only the response(s) and *numeric* predictors are standardized; factor
#' predictors are left as-is, since "one SD" isn't a meaningful unit for a
#' 0/1 dummy variable. This still gives an interpretable, commonly-used effect
#' size for factor predictors: "SD units of `y` per unit change in the
#' predictor."
#'
#' Interactions and main effects of raw variables (e.g. `SES * (n + s)`) are
#' handled correctly, since [stats::model.frame()] reduces a formula down to
#' its base variables before any interaction terms are built -- refitting on
#' the standardized base variables reconstructs the interaction terms
#' correctly.
#'
#' Computed/transformed predictor terms (e.g. `log(x)`, `poly(x, 2)`) are
#' **not** supported and raise an error, since standardizing the *already
#' computed* column would not do what a user expects once the model is
#' refit and the original expression is re-evaluated. Similarly, a
#' computed univariate response (e.g. `log(y) ~ ...`) is not supported.
#' Pre-compute these if you want to use such variables.
#'
#' `subset=`/`weights=`/`na.action=` in the original fitting call are not
#' specially handled -- `stdmodel()` is designed for models fit directly via
#' `lm(formula, data = ...)`.
#'
#' @param object A fitted `"lm"` or `"mlm"` object
#' @param ... Additional arguments. Not used.
#' @return The refit model, of the same class as `object`
#' @author Michael Friendly
#' @seealso [stdcoef()], [coefplot.mlm()], [lmtest::coeftest()], [broom::tidy.coeftest()]
#' @family multivariate linear models
#' @keywords manip
#' @examples
#' rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data = Rohwer)
#' coef(rohwer.mod)
#' 
#' rohwer.std <- stdmodel(rohwer.mod)
#' coef(rohwer.std)
#'
#' @export
stdmodel <- function(object, ...) {
  UseMethod("stdmodel")
}

#' @rdname stdmodel
#' @exportS3Method stdmodel lm
stdmodel.lm <- function(object, ...) {
  mf <- model.frame(object)
  y <- model.response(mf)
  predictors <- mf[-1]

  bad <- grepl("[()]", names(predictors))
  if (any(bad)) {
    stop(glue::glue(
      "stdmodel() doesn't support computed/transformed predictor terms: ",
      "{paste(names(predictors)[bad], collapse = ', ')}. ",
      "Use plain variable names -- interactions and factors are fine."
    ))
  }

  data <- as.data.frame(predictors)

  if (is.matrix(y)) {
    for (j in colnames(y)) data[[j]] <- zscore(y[, j])
  } else {
    resp <- formula(object)[[2]]
    if (!is.name(resp)) {
      stop(glue::glue(
        "stdmodel() doesn't support a computed/transformed response ",
        "({deparse(resp)}). Use a plain variable name, or cbind(...) of them."
      ))
    }
    data[[as.character(resp)]] <- zscore(y)
  }

  numeric_predictors <- names(predictors)[sapply(predictors, is.numeric)]
  for (nm in numeric_predictors) data[[nm]] <- zscore(data[[nm]])

  update(object, data = data)
}

#' Standardized Regression Coefficients
#'
#' @description
#' Computes standardized ("beta") regression coefficients for a fitted `lm`
#' or `mlm` object, i.e. the coefficients that would result from fitting the
#' same model with all numeric variables rescaled to mean 0, SD 1.
#'
#' For an `"mlm"` object, standardization follows [stdmodel()]'s convention:
#' the response(s) and numeric predictors are standardized; factor
#' predictors are left raw.
#'
#' @param object A fitted `"lm"` or `"mlm"` object
#' @param ... Additional arguments. Not used.
#' @return For an `"lm"` object, a named numeric vector of standardized
#'   coefficients (intercept excluded). For an `"mlm"` object, a numeric
#'   matrix of standardized coefficients (parameters x responses,
#'   intercept row excluded).
#' @author Michael Friendly
#' @seealso [stdmodel()], [coefplot.mlm()]. For standard errors, test statistics
#'   and p-values on the standardized scale, run [lmtest::coeftest()] (and, for
#'   a tidy data frame, [broom::tidy.coeftest()]) on [stdmodel()]'s result.
#' @family multivariate linear models
#' @keywords manip
#' @examples
#' data(Prestige, package = "carData")
#' prestige.mod <- lm(prestige ~ income + education, data = Prestige)
#' stdcoef(prestige.mod)
#'
#' rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data = Rohwer)
#' stdcoef(rohwer.mod)
#'
#' @export
stdcoef <- function(object, ...) {
  UseMethod("stdcoef")
}

#' @rdname stdcoef
#' @exportS3Method stdcoef lm
stdcoef.lm <- function(object, ...) {
  b <- summary(object)$coef[-1, 1]
  sx <- sapply(object$model[-1], sd)
  sy <- sd(object$model[[1]])
  b * sx / sy
}

#' @rdname stdcoef
#' @exportS3Method stdcoef mlm
stdcoef.mlm <- function(object, ...) {
  coef(stdmodel(object))[-1, , drop = FALSE]
}
