# Multivariate Box-Cox transformations: notes for heplots

Idea (2026-11-25): Rencher & Christensen (2012), Sec. 4.5.2, "Multivariate Transformations to
Normality", describes the multivariate Box-Cox method. `car::bcPower()` is the univariate
transformation. Could heplots provide a multivariate version?

**Short answer:** the *estimation* already exists, in `car::powerTransform()`, and matches the
book exactly (checked below). What's missing is the **graphics** and the **workflow** for
mlms: profile-likelihood plots for several λs (car's `boxCox()` is univariate only, and
`powerTransform` objects have no `plot()` method), a way to refit an mlm with the
transformed responses, and before/after comparisons with HE plots, `cqplot()` and
`boxM()`. Those fit heplots well.

## What the book says (Sec. 4.5, pp. 110–112 of the book; PDF pp. 130–133)

- **Univariate (4.42)**, Box & Cox (1964): choose λ to maximize
  ℓ(λ) = −(n/2) log s²_λ + (λ − 1) Σ log yᵢ, where s²_λ is the ML variance of the transformed
  y^(λ) = (y^λ − 1)/λ (log y for λ = 0). In practice, plot ℓ(λ) against λ.
- **Multivariate (4.43)**, Andrews, Gnanadesikan & Warner (1971): choose λ = (λ₁, …, λ_p) to
  maximize
  ℓ(λ) = −(n/2) log |S_λ| + Σⱼ (λⱼ − 1) Σᵢ log yᵢⱼ,
  where S_λ is the ML covariance matrix of the transformed data. The motivation: "the
  optimal transformation to p-variate normality is not necessarily based on the collection
  of p transformations obtained when targeting marginal normality", although "in practice,
  the collection of univariately transformed variables will often be very close". The book
  suggests maximizing directly or evaluating ℓ(λ) on a p-dimensional grid.
- **Example 4.5.2**, soil data of Table 3.3 (Fe, K, Mg): univariate λ = (1.0, −0.3, 0.1);
  multivariate, by a grid search, λ = (1.0, −0.4, 0.2), "predictably similar". Figure 4.8
  shows histograms before and after, and the univariate ℓ(λ) curves. (Table 3.3 is not in
  the rencher package.)

## What already exists

- **`car::powerTransform()`** (car 3.1.5) has methods `default` (a matrix or data frame of
  responses), `formula`, `lm` (including **mlm**) and `lmerMod`. It estimates λ by ML for
  multivariate normality, with families `bcPower` (Box-Cox), `bcnPower` (Box-Cox with
  negatives) and `yjPower` (Yeo-Johnson). `summary()` gives the estimates, rounded powers,
  Wald intervals, and LR tests of λ = 0 (all logs) and λ = 1 (no transformation);
  `testTransform(p, lambda)` tests any other vector; `coef(p, round = TRUE)` gives
  convenient powers. Returned components include `lambda`, `roundlam`, `invHess`, `llik`.
- **Marginal vs conditional.** `powerTransform(Y)` makes the *responses* as normal as
  possible; `powerTransform(mlm)` (or `powerTransform(cbind(...) ~ group, data)`) makes the
  *residuals* as normal as possible, which is what MANOVA and HE plots assume. They usually
  differ a little.
- **`car::boxCox()`** draws the profile log-likelihood with a confidence interval, but only
  for a univariate response: on an mlm it stops with "This function is for univariate
  response only". `MASS::boxcox()` is also univariate.
- **heplots** has `cqplot()` (including `cqplot.mlm()` for residuals), `boxM()` and its
  plots, `robmlm()`, `covEllipses()`: everything needed to show *whether* a transformation
  helped. Nothing in heplots currently mentions Box-Cox or `powerTransform`.

**Check:** on the dystrophy data (`rencher::table5.7`, four enzymes), maximizing (4.43) with
`optim()` gives λ = (−0.343, 2.049, −0.145, 0.031); `powerTransform()` gives
(−0.343, 2.05, −0.146, 0.032). The log-likelihoods differ only by a constant. So **don't
re-implement the estimation**: build on `powerTransform()`.

## A worked example: the dystrophy enzymes

From `dev/Rencher-demos.R` (Problem 5.19; CK, hemopexin, PK, LD; `group + age + month`):

| λ for (CK, Hpx, PK, LD) | LR test vs the ML estimate | |
|---|---|---|
| ML, conditional on the mlm: (−0.36, 2.25, −0.15, 0.02) | — | |
| rounded: (−0.5, 2, 0, 0) | χ²₄ = 3.7, p = .45 | fine |
| (0, 2, 0, 0) | χ²₄ = 10.0, p = .04 | marginal |
| **(0, 1, 0, 0), used in the demo** | χ²₄ = 27.2, p < .0001 | rejected |
| (1, 1, 1, 1), no transformation | χ²₄ = 219, p < .0001 | rejected |

Two things the multivariate estimate shows that "log the skewed ones" missed:

- **Hemopexin wants λ ≈ 2:** it is skewed to the *left*, so it should be squared, not left
  alone.
- **CK wants λ ≈ −0.5,** a stronger transformation than log.

So the demo's choice (log CK, raw Hpx, log PK, log LD) is clearly worse than the rounded
ML powers. `dev/Rencher-demos.R` should be updated, and the HE plots compared, which is
exactly the workflow below.

## What heplots could add

### 1. Plots of the profile likelihood for an mlm (the main gap)

- **1-D profiles, one panel per response:** ℓ as a function of λⱼ, maximizing over the
  other λs (a true profile) or holding them at their MLEs (a slice, much cheaper). Mark the
  MLE, the rounded value and a 95% interval (χ²₁ cut-off), as `car::boxCox()` does for one
  response. This is the multivariate version of the book's Figure 4.8, middle row.
- **2-D contours for a pair (λⱼ, λₖ):** contours of the profile log-likelihood, with the
  LR confidence region (χ²₂ cut-off) and, overlaid, the **Wald confidence ellipse** from
  `invHess`. That's a data ellipse for parameters, in the spirit of `heplots`, and it shows
  how well the quadratic (Wald) approximation works. Candidate values (0, ½, 1, 2, −½, −1)
  as reference lines, so you can see which "nice" powers fall inside.
- A `pairs()` version: all pairs of λs, 2-D contours below the diagonal, 1-D profiles on
  the diagonal.
- Possible names: `plot.powerTransform()` (but that's a method for a car class; better
  proposed to car, or provided by heplots as a separate function), or
  `boxCoxPlot(mod, ...)` / `profileBC(mod, ...)` in heplots.

### 2. Refit an mlm with the transformed responses

A small helper so the comparison is one line:

```r
pt   <- car::powerTransform(mod)                         # mod is an mlm
mod2 <- bc_refit(mod, lambda = coef(pt, round = TRUE))   # same model, transformed Y
```

It would apply `car::bcPower()` to each response column with its λ, rename the responses
(`CK^-0.5`, `Hpx^2`, `log(PK)`, …), and `update()` the model. Questions: keep the Box-Cox
scaling (y^λ − 1)/λ, which preserves the direction of the effect for negative λ, or use
plain powers? Use `bcnPower` when there are zeros or negatives?

### 3. Before/after comparisons

- `cqplot()` of the residuals of `mod` and `mod2`, side by side (multivariate normality).
- HE plots of `mod` and `mod2`. They can't be overlaid, since the scales differ, but in
  canonical space or with `size = "effect"` they can be compared, and the test statistics
  can be tabulated (`Anova()` before and after).
- `boxM()` before and after: does the transformation also make the covariance matrices
  more similar? (Next point.)

### 4. A new idea: transforming toward equal covariance matrices

Box-Cox targets normality. For MANOVA, **homogeneity of covariance matrices** is often the
more important assumption, and heplots already has `boxM()`, `covEllipses()` and
`bartlettTests()` / `leveneTests()` for it. Two possibilities:

- Choose λ to **minimize Box's M** (or the log-determinant spread across groups), the
  multivariate analogue of Tukey's spread-versus-level plot for choosing a transformation.
- Or maximize a likelihood that allows separate covariance matrices per group and see how
  much λ changes.

Normality and homogeneity may pull in different directions; a plot of both criteria
against λ (or a trade-off curve) would show it. I don't know of an R implementation of
this; it would be new.

### 5. Relation to robust fitting

`robmlm()` handles heavy tails and outliers by down-weighting; a transformation handles
skewness. For the dystrophy data both are candidates. Worth showing the two side by side in
a vignette or example.

## Example data

- **`rencher::table5.7`** (dystrophy): skewed in *both* directions (CK right, hemopexin
  left), four responses, two groups plus covariates. The best example found so far.
- **Rencher Table 3.3** (Baker corn field soil data; Fe, K, Mg used in Example 4.5.2): the
  book's own example, but not in the rencher package; it would need typing in (it has 11
  variables on a spatial grid).
- Others to try: the cancer survival times (`rencher::table6.22`, very skewed);
  `heplots::Diabetes` (glucose and insulin measures).

## Suggested first step

Write `dev/box-cox-demo.R` for the dystrophy data:

1. `powerTransform()` on the mlm; `summary()`; `testTransform()` for the candidate vectors
   in the table above.
2. A first, simple version of the 1-D profile plot (slices at the MLE) and one 2-D contour
   plot with its Wald ellipse, for (CK, Hpx).
3. Refit with the rounded powers; compare `cqplot()`, `Anova()`, `boxM()` and HE plots
   before and after.

That would show whether the plots in point 1 are worth turning into a heplots function,
and whether point 4 (homogeneity) gives a different answer from normality on real data.
