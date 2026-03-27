# Test script for extract_eq.mlm()
# Source equatiomatic.R first, then run sections interactively.
#
# Requirements:
#   install.packages("equatiomatic")   # or remotes::install_github("datalorax/equatiomatic")
#   library(equatiomatic)              # must be loaded for S3 dispatch to find extract_eq.mlm

library(heplots)
library(equatiomatic)

source(here::here("dev/equatiomatic.R"))

# ---- Example model ----------------------------------------------------------

mod <- lm(cbind(read, math) ~ income + educ, data = heplots::NLSY)
class(mod)       # should be c("mlm", "lm")
coef(mod)        # 3 x 2: (Intercept, income, educ) x (read, math)

# ---- 1. Symbolic form (default) ---------------------------------------------

eq1 <- extract_eq(mod)
eq1
# Expected LHS: \mathbf{read}, \mathbf{math}
# Expected: \boldsymbol{\alpha} + \boldsymbol{\beta}_{1}(\operatorname{income}) + ...

# Comment: the LHS side should appear with () or [] here, e.g.,
# \[ \mathbf{read}, \mathbf{math} \]

# ---- 2. response_form = "pmatrix" -------------------------------------------

eq2 <- extract_eq(mod, response_form = "pmatrix")
eq2
# Expected LHS: \begin{pmatrix}\mathbf{read}\\\mathbf{math}\end{pmatrix}

# ---- 3. response_form = "bmatrix" -------------------------------------------

eq3 <- extract_eq(mod, response_form = "bmatrix")
eq3

# ---- 4. use_coefs = TRUE (full B matrix) ------------------------------------

eq4 <- extract_eq(mod, use_coefs = TRUE)
eq4
# Expected: B is 2x3, x-vector has 3 elements (1, income, educ)
# LHS auto-promoted to pmatrix

# Comment: The output here has doubled $$ and the start and end of the output string.

eq4b <- extract_eq(mod, use_coefs = TRUE, response_form = "bmatrix")
eq4b

# ---- 5. use_coefs = TRUE with more digits -----------------------------------

eq5 <- extract_eq(mod, use_coefs = TRUE, coef_digits = 3)
eq5

# ---- 6. Generic response names ----------------------------------------------

eq6 <- extract_eq(mod, use_generic_names = "response")
eq6
# Expected LHS: \mathbf{y}_{1}, \mathbf{y}_{2}

# Comment: needs () or [] here

# ---- 7. Generic predictor names (symbolic) ----------------------------------

eq7 <- extract_eq(mod, use_generic_names = "predictors")
eq7
# Expected: income -> x_{1}, educ -> x_{2}

# ---- 8. Generic names for both sides ----------------------------------------

eq8 <- extract_eq(mod, use_generic_names = c("response", "predictors"))
eq8

# ---- 9. use_coefs + generic names -------------------------------------------

eq9 <- extract_eq(mod, use_coefs = TRUE, use_generic_names = c("response", "predictors"))
eq9

# ---- 10. dots_threshold: model with many predictors -------------------------

mod_many <- lm(cbind(read, math) ~ income + educ + antisoc + hyperact,
               data = heplots::NLSY)
coef(mod_many)   # 5 x 2

eq10a <- extract_eq(mod_many, use_coefs = TRUE, dots_threshold = 3)
eq10a
# Expect: first 3 predictor columns shown, then \cdots, then last column
# (x vector: 1, income, educ, \vdots, hyperact)

eq10b <- extract_eq(mod_many, use_coefs = TRUE, dots_threshold = 5)
eq10b
# Expect: all 5 columns shown (no dots)

# ---- 11. dots_threshold: model with many responses --------------------------

mod_iris <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species,
               data = iris)
coef(mod_iris)   # 3 x 4

eq11a <- extract_eq(mod_iris, use_coefs = TRUE, dots_threshold = 2)
eq11a
# Expect: first 2 response rows, then \vdots, then last row in B matrix

eq11b <- extract_eq(mod_iris, use_coefs = TRUE, dots_threshold = 4)
eq11b
# Expect: all 4 rows (no vdots)

# ---- 12. Both dots triggered simultaneously ---------------------------------

mod_big <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
              Species + Sepal.Length:Sepal.Width,
              data = iris)
eq12 <- extract_eq(mod_big, use_coefs = TRUE, dots_threshold = 2)
eq12
# Expect: \ddots in the corner cell where both row and column are truncated

# ---- 13. Factor predictors (symbolic form) ----------------------------------

mod_factor <- lm(cbind(Sepal.Length, Sepal.Width) ~ Species, data = iris)
eq13 <- extract_eq(mod_factor)
eq13
# Factor levels should render correctly via equatiomatic's prototype lm

# ---- 14. Underscore in variable names ---------------------------------------

NLSY2 <- heplots::NLSY
names(NLSY2)[names(NLSY2) == "read"] <- "read_score"
names(NLSY2)[names(NLSY2) == "math"] <- "math_score"
mod_under <- lm(cbind(read_score, math_score) ~ income + educ, data = NLSY2)

eq14 <- extract_eq(mod_under)
eq14
# Expect: \mathbf{read.score}, \mathbf{math.score}  (underscores -> dots)

# ---- 15. wrap = TRUE (multiline RHS) ----------------------------------------

eq15 <- extract_eq(mod_many, wrap = TRUE, terms_per_line = 2)
eq15
# Expect: aligned environment; Greek letters still bolded

# ---- 16. Return class -------------------------------------------------------

cat("Class of symbolic eq:", class(eq1), "\n")
cat("Class of coef eq:    ", class(eq4), "\n")
# Both should be c("equation", "character")

# ---- Render in knitr (run interactively in an Rmd chunk) --------------------
# ```{r}
# library(equatiomatic)
# source("dev/equatiomatic.R")
# mod <- lm(cbind(read, math) ~ income + educ, data = heplots::NLSY)
# extract_eq(mod)
# extract_eq(mod, use_coefs = TRUE)
# ```
