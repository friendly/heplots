# Notes: `extract_eq.mlm()` for multivariate linear models

## Goal

Provide an `equatiomatic::extract_eq()` S3 method for `"mlm"` objects
(multivariate linear models fit by `lm(cbind(y1, y2, ...) ~ ...)`).

Related: <https://github.com/datalorax/equatiomatic/issues/243>
raised this issue there, but there's been no response.
Let's try to flesh this out here.

---

## Current behavior (equatiomatic default)

Calling `extract_eq()` on an mlm currently produces garbled LaTeX:
it treats the `cbind(...)` response as a single operatorname and
concatenates all response equations end-to-end with duplicate predictor blocks:

```
\operatorname{cbind(read,\ math)} = \alpha + \beta_1(\operatorname{income}) + ... +
                                    \alpha + \beta_4(\operatorname{income}) + ... + \epsilon
```

---

## Resolved design decisions

Some decisions have to be made about how to represent the elements in a "mlm" in matrices/vectors
with a readable, reasonably compact notation.

| Element              | LaTeX                              | Notes                                      |
|----------------------|------------------------------------|--------------------------------------------|
| Intercept            | `\boldsymbol{\alpha}`              | Bold alpha vector, not `\boldsymbol{\beta}_0` |                      |
| Predictor coefs      | `\boldsymbol{\beta}_j`             | Bold beta vectors (columns of **B**)       |
| Error term           | `\boldsymbol{\epsilon}`            | Bold epsilon vector;                       |
| LHS default          | `\mathbf{y_1}, \mathbf{y_2}`       | Bold response names, comma-separated       |
| LHS pmatrix option   | `\begin{pmatrix}...\end{pmatrix}`  | via `response_form = "pmatrix"/"bmatrix"`  |
| `use_coefs` layout   | Full coefficient matrix (see below)| With `dots_threshold` for large models     |

---

## Symbolic form (default, `use_coefs = FALSE`)

For `lm(cbind(read, math) ~ income + educ)`:

**`response_form = "bold"` (default)**:
```latex
\mathbf{read}, \mathbf{math} = \boldsymbol{\alpha} +
  \boldsymbol{\beta}_1(\operatorname{income}) +
  \boldsymbol{\beta}_2(\operatorname{educ}) + \boldsymbol{\epsilon}
```

**`response_form = "pmatrix"`**:
```latex
\begin{pmatrix}\mathbf{read}\\\mathbf{math}\end{pmatrix} = \boldsymbol{\alpha} +
  \boldsymbol{\beta}_1(\operatorname{income}) +
  \boldsymbol{\beta}_2(\operatorname{educ}) + \boldsymbol{\epsilon}
```

---

## `use_coefs = TRUE` form

Show the full **B** matrix (q responses × p predictors) together with the
predictor vector **x**, i.e. the explicit matrix × vector equation:

```latex
\begin{pmatrix}\mathbf{read}\\\mathbf{math}\end{pmatrix} =
\begin{pmatrix}15.9 & 0.015 & 0.947 \\ 8.76 & 0.092 & 1.27\end{pmatrix}
\begin{pmatrix}1\\\operatorname{income}\\\operatorname{educ}\end{pmatrix}
+ \boldsymbol{\epsilon}
```

Rows = responses, columns = predictors (intercept first).

### `dots_threshold` argument (default `3`)

When `nrow(B) > dots_threshold` (many responses) insert `\vdots` after row
`dots_threshold` and show the last row:

```latex
\begin{pmatrix}b_{11} & b_{12} \\ b_{21} & b_{22} \\ \vdots & \vdots \\ b_{q1} & b_{q2}\end{pmatrix}
```

When `ncol(B) > dots_threshold` (many predictors) insert `\cdots` after column
`dots_threshold` and show the last column:

```latex
\begin{pmatrix}b_{11} & b_{12} & \cdots & b_{1p} \\ b_{21} & b_{22} & \cdots & b_{2p}\end{pmatrix}
```

Both can apply simultaneously (corner element becomes `\ddots`).

---

## Implementation strategy

**Approach: use equatiomatic on a prototype univariate lm, then post-process.**

The RHS structure (predictors, interactions, transformations, offsets) is
identical for every response in an MLM. So:

1. **Extract a prototype lm** — refit the model on just the first response column
   so equatiomatic can parse the RHS normally.

   ```r
   proto_lm <- lm(update(formula(model), Y1 ~ .), data = model.frame(model))
   ```
   where `Y1` is the first response column extracted from `model$model`.

2. **Get prototype equation string** via `equatiomatic::extract_eq(proto_lm, ...)`.

3. **Post-process the LaTeX string**:
   - Replace LHS (`\operatorname{Y1}`) with bold response notation
     (comma list or pmatrix, depending on `response_form`).
   - Replace `\alpha` → `\boldsymbol{\alpha}`.
   - Replace `\beta_j` → `\boldsymbol{\beta}_j`.
   - Replace `\epsilon` → `\boldsymbol{\epsilon}`.

4. **If `use_coefs = TRUE`**: instead, build the coefficient-matrix LaTeX from
   scratch using `coef(model)` and the predictor names, ignoring equatiomatic's
   `use_coefs` output entirely (since per-response column-vector layout is
   replaced by the full-matrix form).

### Extracting the prototype lm

```r
extract_proto_lm <- function(model) {
  mf <- model.frame(model)
  Y  <- model$model[[1]]           # matrix of responses
  y1 <- Y[, 1, drop = FALSE]
  colnames(y1) <- ".y1"
  mf[[1]] <- y1
  lm(.y1 ~ ., data = mf)
}
```

### Building the coefficient matrix LaTeX (`use_coefs = TRUE`)

```r
B      <- t(coef(model))          # q x p  (responses x predictors)
resp   <- rownames(B)
preds  <- colnames(B)

# Apply dots_threshold to rows and/or columns, then format as pmatrix
```

---

## Function signature

```r
extract_eq.mlm <- function(model,
                            response_form   = c("bold", "pmatrix", "bmatrix"),
                            use_coefs       = FALSE,
                            dots_threshold  = 3,
                            coef_digits     = 2,
                            ...) { ... }
```

`...` is passed to `equatiomatic::extract_eq()` for the prototype lm (for
arguments like `wrap`, `greek_colors`, `var_colors`, etc.) **except** when
`use_coefs = TRUE`, where the coefficient display is built directly.

---

## Still to clarify

- **Exact LHS label style**: `\mathbf{read}` uses the variable name verbatim —
  should subscripts in variable names be escaped? (e.g. `y_1` → needs
  `\mathbf{y_1}` which LaTeX renders as "y" with subscript "1", which is fine
  in math mode; but `\mathbf{reaction_time}` would give subscript "time").
  Possibly sanitize by replacing `_` with `\_` inside `\mathbf{}`, or
  substitute `.` for `_` (as nestedLogit does).

- **Generic labels option**: Should there be a `use_response_names = FALSE`
  option that substitutes `\mathbf{y}_1, \mathbf{y}_2, \ldots` instead of
  the actual variable names?

- **Coefficient rounding**: `coef_digits` arg for `round(B, coef_digits)`.
  Default 2 or 3?-- Use `coef_digits = 2`.

- **`wrap` interaction**: when `wrap = TRUE` is passed through to the prototype
  `lm()` equation, does the post-processing still work cleanly on the multiline
  LaTeX `align` environment? Needs testing.

---

## Package setup needed

If this method is not adopted in {`equatiomatic`}, could do so here:

- Add `equatiomatic` to `Suggests:` in DESCRIPTION
- Use `@exportS3Method equatiomatic::extract_eq mlm` (same pattern as nestedLogit)
- No `@importFrom equatiomatic` needed — S3 dispatch handles it

---

## Example target output

```r
mod <- lm(cbind(read, math) ~ income + educ, data = heplots::NLSY)

# Symbolic (default):
extract_eq(mod)
# \mathbf{read}, \mathbf{math} = \boldsymbol{\alpha} +
#   \boldsymbol{\beta}_1(\operatorname{income}) +
#   \boldsymbol{\beta}_2(\operatorname{educ}) + \boldsymbol{\epsilon}

# With response as column vector:
extract_eq(mod, response_form = "pmatrix")
# \begin{pmatrix}\mathbf{read}\\\mathbf{math}\end{pmatrix} = ...

# With numeric coefficients:
extract_eq(mod, use_coefs = TRUE)
# \begin{pmatrix}\mathbf{read}\\\mathbf{math}\end{pmatrix} =
#   \begin{pmatrix}15.9 & 0.015 & 0.947 \\ 8.76 & 0.092 & 1.27\end{pmatrix}
#   \begin{pmatrix}1\\\operatorname{income}\\\operatorname{educ}\end{pmatrix}
#   + \boldsymbol{\epsilon}
```
