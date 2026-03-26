# TODO: 🚩 Move to R/equatiomatic.R once design is confirmed; add equatiomatic
#          to Suggests: in DESCRIPTION and @exportS3Method to NAMESPACE.
# TODO: 🚩 Test with wrap = TRUE to verify post-processing works on multiline
#          align environments.
# TODO: 🚩 use_generic_names = "predictors" for symbolic form is limited to
#          simple continuous main effects. Factor variables and interactions
#          need further work.

#' Extract Equation for a Multivariate Linear Model
#'
#' @description
#' Provides an [equatiomatic::extract_eq()] method for `"mlm"` objects
#' (multivariate linear models fit by [stats::lm()] with a `cbind()` response).
#' Renders the model as a LaTeX equation using matrix/vector notation, with bold
#' symbols for the response vector (`\mathbf{y}`), coefficient vectors
#' (`\boldsymbol{\beta}_j`), and the error vector (`\boldsymbol{\epsilon}`).
#'
#' The strategy is to fit a prototype univariate [stats::lm()] on the first
#' response column so that [equatiomatic::extract_eq()] can parse the RHS
#' structure (predictors, interactions, factor levels, etc.) normally. The
#' resulting LaTeX string is then post-processed: the scalar LHS is replaced
#' with bold response-vector notation and scalar Greek symbols are replaced
#' with bold equivalents.
#'
#' When `use_coefs = TRUE` the coefficient display is built directly from
#' [stats::coef()], showing the full **B** matrix (q responses × p predictors)
#' multiplied by the predictor vector **x**, rather than using equatiomatic's
#' per-coefficient scalar output.
#'
#' @param model An `"mlm"` object created by [stats::lm()] with a multivariate
#'        (`cbind()`) response.
#' @param response_form Character; controls how the response vector is displayed
#'        on the LHS. One of:
#'   * `"bold"` (default): comma-separated bold names,
#'     e.g. `\mathbf{read}, \mathbf{math}`
#'   * `"pmatrix"`: column vector in parentheses
#'   * `"bmatrix"`: column vector in square brackets
#'   When `use_coefs = TRUE`, `"bold"` is silently upgraded to `"pmatrix"` so
#'   the response vector is dimensionally consistent with the coefficient matrix.
#' @param use_coefs Logical; if `TRUE`, display fitted coefficient values from
#'        [stats::coef()] as a full **B** matrix × predictor vector **x**,
#'        rounded to `coef_digits` significant figures. Default `FALSE`.
#' @param use_generic_names `FALSE` (default) to use actual variable names, or
#'        a character vector containing one or both of `"response"` and
#'        `"predictors"` to substitute generic labels:
#'   * `"response"`: replaces response names with
#'     `\mathbf{y}_1, \mathbf{y}_2, \ldots`
#'   * `"predictors"`: replaces predictor names with `x_1, x_2, \ldots`
#'     (fully supported only when `use_coefs = TRUE`; for the symbolic form,
#'     only simple continuous main effects are replaced)
#' @param dots_threshold Integer; when the number of responses or predictors
#'        exceeds this value, the coefficient matrix and predictor vector are
#'        truncated with `\vdots`, `\cdots`, and `\ddots`. Default `3`. Only
#'        used when `use_coefs = TRUE`.
#' @param coef_digits Integer; number of significant figures for coefficient
#'        values when `use_coefs = TRUE`. Passed to [base::signif()].
#'        Default `2`.
#' @param \dots Additional arguments passed to [equatiomatic::extract_eq()]
#'        when building the symbolic (`use_coefs = FALSE`) form, for example
#'        `wrap = TRUE`, `greek_colors`, `var_colors`. Ignored when
#'        `use_coefs = TRUE`.
#'
#' @details
#' Underscores in variable names are replaced with `.` in the LaTeX output,
#' since `_` is the subscript operator in LaTeX math mode. For example, a
#' response named `reaction_time` appears as `\mathbf{reaction.time}`.
#'
#' @return An object of class `c("equation", "character")`, the same class
#'   returned by [equatiomatic::extract_eq()], which renders automatically
#'   as a LaTeX display equation in knitr/rmarkdown chunks.
#'
#' @seealso [equatiomatic::extract_eq()], [stats::lm()], [heplots::tidy.mlm()]
#' @exportS3Method equatiomatic::extract_eq mlm
#'
#' @examples
#' mod <- lm(cbind(read, math) ~ income + educ, data = heplots::NLSY)
#'
#' if (requireNamespace("equatiomatic", quietly = TRUE)) {
#'   # Symbolic form (default)
#'   equatiomatic::extract_eq(mod)
#'
#'   # Response displayed as a column vector
#'   equatiomatic::extract_eq(mod, response_form = "pmatrix")
#'
#'   # Full coefficient matrix with fitted values
#'   equatiomatic::extract_eq(mod, use_coefs = TRUE)
#'
#'   # Generic labels for both sides
#'   equatiomatic::extract_eq(mod,
#'     use_generic_names = c("response", "predictors"))
#' }
extract_eq.mlm <- function(model,
                            response_form     = c("bold", "pmatrix", "bmatrix"),
                            use_coefs         = FALSE,
                            use_generic_names = FALSE,
                            dots_threshold    = 3,
                            coef_digits       = 2,
                            ...) {

  if (!requireNamespace("equatiomatic", quietly = TRUE)) {
    stop("Package 'equatiomatic' is required. ",
         "Install it with: install.packages('equatiomatic')")
  }

  response_form <- match.arg(response_form)

  # Validate use_generic_names
  if (!isFALSE(use_generic_names)) {
    valid_generic <- c("response", "predictors")
    bad <- setdiff(use_generic_names, valid_generic)
    if (length(bad) > 0) {
      stop(
        "Invalid use_generic_names value(s): ",
        paste(bad, collapse = ", "),
        ". Must be FALSE or a subset of c('response', 'predictors')."
      )
    }
  }

  # Response names, sanitized for LaTeX (underscore -> dot)
  Y <- model$model[[1]]
  resp_names_latex <- gsub("_", ".", colnames(Y), fixed = TRUE)

  if (use_coefs) {
    .build_coef_matrix_eq(model, response_form, use_generic_names,
                          resp_names_latex, dots_threshold, coef_digits)
  } else {
    .build_symbolic_eq(model, response_form, use_generic_names,
                       resp_names_latex, ...)
  }
}

# ---- Internal helpers -------------------------------------------------------

# Sanitize a character vector of names for LaTeX: replace _ with .
.sanitize_latex <- function(x) gsub("_", ".", x, fixed = TRUE)

# Build the LHS LaTeX string for the response vector.
#
# resp_names  : character vector, already sanitized (no underscores)
# response_form : "bold", "pmatrix", or "bmatrix"
# use_generic_names : FALSE or character vector possibly containing "response"
.build_response_lhs <- function(resp_names, response_form, use_generic_names) {
  q <- length(resp_names)

  bold_names <- if (!isFALSE(use_generic_names) && "response" %in% use_generic_names) {
    paste0("\\mathbf{y}_{", seq_len(q), "}")
  } else {
    paste0("\\mathbf{", resp_names, "}")
  }

  if (response_form == "bold") {
    paste(bold_names, collapse = ", ")
  } else {
    paste0("\\begin{", response_form, "}",
           paste(bold_names, collapse = " \\\\ "),
           "\\end{", response_form, "}")
  }
}

# Build a LaTeX matrix environment from a numeric matrix, with optional
# dots notation when dimensions exceed dots_threshold.
#
# mat            : numeric matrix
# dots_threshold : integer
# mat_type       : "pmatrix" or "bmatrix"
.build_matrix_latex <- function(mat, dots_threshold, mat_type = "pmatrix") {
  q <- nrow(mat)
  p <- ncol(mat)

  use_row_dots <- q > dots_threshold
  use_col_dots <- p > dots_threshold

  row_show <- if (use_row_dots) c(seq_len(dots_threshold), NA_integer_, q) else seq_len(q)
  col_show <- if (use_col_dots) c(seq_len(dots_threshold), NA_integer_, p) else seq_len(p)

  rows_latex <- vapply(row_show, function(i) {
    cells <- vapply(col_show, function(j) {
      if (is.na(i) && is.na(j)) "\\ddots"
      else if (is.na(i))        "\\vdots"
      else if (is.na(j))        "\\cdots"
      else                       as.character(mat[i, j])
    }, character(1))
    paste(cells, collapse = " & ")
  }, character(1))

  paste0("\\begin{", mat_type, "}",
         paste(rows_latex, collapse = " \\\\ "),
         "\\end{", mat_type, "}")
}

# Build a LaTeX column vector (matrix environment) from a character vector of
# display names, with optional dots notation.
#
# names          : character vector of display names (already sanitized);
#                  the value "1" is rendered as bare "1" (for the intercept),
#                  all others as \operatorname{name}
# dots_threshold : integer
# mat_type       : "pmatrix" or "bmatrix"
.build_vector_latex <- function(names, dots_threshold, mat_type = "pmatrix") {
  n <- length(names)
  use_dots <- n > dots_threshold

  show_idx <- if (use_dots) c(seq_len(dots_threshold), NA_integer_, n) else seq_len(n)

  cells <- vapply(show_idx, function(i) {
    if (is.na(i))           "\\vdots"
    else if (names[i] == "1") "1"
    else                    paste0("\\operatorname{", names[i], "}")
  }, character(1))

  paste0("\\begin{", mat_type, "}",
         paste(cells, collapse = " \\\\ "),
         "\\end{", mat_type, "}")
}

# Build a prototype univariate lm from the first response column of an mlm.
# Equatiomatic is then called on this to obtain a correctly-structured RHS.
.proto_lm <- function(model) {
  mf        <- model.frame(model)
  mf[[1]]   <- model$model[[1]][, 1]
  names(mf)[1] <- "YPROTO"
  lm(YPROTO ~ ., data = mf)
}

# Build the symbolic (use_coefs = FALSE) equation string.
.build_symbolic_eq <- function(model, response_form, use_generic_names,
                                resp_names_latex, ...) {
  proto  <- .proto_lm(model)
  eq     <- equatiomatic::extract_eq(proto, ...)
  eq_str <- as.character(eq)

  # Replace prototype LHS with our response vector notation
  lhs    <- .build_response_lhs(resp_names_latex, response_form, use_generic_names)
  eq_str <- sub("\\operatorname{YPROTO}", lhs, eq_str, fixed = TRUE)

  # Boldify Greek letters (fixed = TRUE is safe: equatiomatic only uses plain
  # \alpha, \beta, \epsilon; these substrings never appear inside \operatorname{})
  eq_str <- gsub("\\alpha",   "\\boldsymbol{\\alpha}",   eq_str, fixed = TRUE)
  eq_str <- gsub("\\beta",    "\\boldsymbol{\\beta}",    eq_str, fixed = TRUE)
  eq_str <- gsub("\\epsilon", "\\boldsymbol{\\epsilon}", eq_str, fixed = TRUE)

  # Optionally replace predictor names with generic x_j labels.
  # NOTE: limited to simple continuous main effects; interactions and factor
  # level labels are not handled and will retain their original names.
  if (!isFALSE(use_generic_names) && "predictors" %in% use_generic_names) {
    pred_terms <- .sanitize_latex(attr(terms(model), "term.labels"))
    for (j in seq_along(pred_terms)) {
      eq_str <- gsub(
        paste0("\\operatorname{", pred_terms[j], "}"),
        paste0("x_{", j, "}"),
        eq_str, fixed = TRUE
      )
    }
  }

  class(eq_str) <- class(eq)
  eq_str
}

# Build the use_coefs = TRUE equation as a full B matrix × x vector product.
.build_coef_matrix_eq <- function(model, response_form, use_generic_names,
                                   resp_names_latex, dots_threshold, coef_digits) {
  # coef(model) is p x q (predictors x responses); transpose to q x p
  B     <- t(coef(model))
  B_sig <- signif(B, coef_digits)

  pred_names <- .sanitize_latex(colnames(B))

  # Predictor display names: (Intercept) -> "1", or generic x_j labels
  if (!isFALSE(use_generic_names) && "predictors" %in% use_generic_names) {
    p            <- ncol(B)
    pred_display <- c("1", paste0("x_{", seq_len(p - 1), "}"))
  } else {
    pred_display <- pred_names
    pred_display[pred_display == "(Intercept)"] <- "1"
  }

  # For use_coefs, "bold" is promoted to "pmatrix" so the LHS is a column
  # vector that is dimensionally consistent with the matrix product B x
  mat_type <- if (response_form == "bold") "pmatrix" else response_form

  lhs   <- .build_response_lhs(resp_names_latex, mat_type, use_generic_names)
  b_mat <- .build_matrix_latex(B_sig, dots_threshold, mat_type)
  x_vec <- .build_vector_latex(pred_display, dots_threshold, mat_type)

  eq_body <- paste0(lhs, " = ", b_mat, x_vec, " + \\boldsymbol{\\epsilon}")
  eq_str  <- paste0("$$\n", eq_body, "\n$$")

  class(eq_str) <- c("equation", "character")
  eq_str
}
