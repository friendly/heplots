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
  
  MF: Need a fine enough grid of \lambda values so contours become smooth-ish.
  It would be nice to display these as lightly filled contours varying in alspha, so the maximum region is clear
  Could the same function do both 1D and 2D profiles, depending on what is passed
  as the `variables` argument?
  
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

MF: Keep the BC scaling. Renaming responses: (`CK^-0.5`, `Hpx^2`, `log(PK)`, …) aren't valid names in R

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

## First step done: `dev/box-cox-demo.R` (2026-11-26)

Uses `heplots::Dystrophy`, `cbind(CK, Hpx, PK, LD) ~ group + age + month`. Prototype
functions in the script:

- `bc_loglik(lambda, pt)`: the log-likelihood (4.43), with residuals from the model.
  **Reproduces car's `testTransform()` LR statistics exactly** (a `stopifnot()` checks it),
  so it can drive the plots without re-implementing the estimation.
- `bc_profile(pt, variables, type = c("profile", "slice"), range = 3.5, n)`: **one function
  for 1-D and 2-D**, depending on `length(variables)` (MF comment). A "profile" maximizes over
  the other λs at each grid point (warm-started `optim()`); a "slice" holds them at the MLE.
  The grid is ±`range` Wald SEs around the MLE, 101 points in 1-D, 61 × 61 in 2-D.
- `plot.bc_profile()`: 1-D: log-likelihood curve with the χ²₁ cut-off, LR interval, MLE and
  rounded power. 2-D: **nested, lightly filled LR regions** (coverage .99, .95, .90, .75, .50,
  .25, .10), each with a low alpha so the fill builds up toward the MLE (MF comment); the 95%
  LR contour; the 95% **Wald ellipse** (marginal `invHess` for a profile, conditional
  `solve(hessian)` for a slice); reference lines at nice powers; MLE and rounded points.
- `bc_refit(mod, lambda)`: refits with `car::bcPower()`, **keeping the Box-Cox scaling**
  (MF). Response names are syntactic: λ = 1 keeps the name, λ = 0 gives `logPK`, others
  `CK_m0.5`, `Hpx_2` (MF: `CK^-0.5` is not a valid name). The λs are kept in
  `attr(mod2, "lambda")`.

### What it shows

- **Profile vs slice:** almost the same here. The λ estimates are nearly uncorrelated
  (largest correlation from `invHess`, CK–PK, 0.13), so the cheap slice would do for these
  data. That won't hold in general; keep both.
- **LR region vs Wald ellipse:** nearly coincide for (CK, Hpx) and (CK, PK); the quadratic
  approximation is good. The one visible difference is along Hpx, whose profile is slightly
  asymmetric (1-D LR interval 1.61–3.02 around 2.25): the LR region reaches a little higher
  and less far down than the symmetric Wald ellipse.
- **Timing:** a 61 × 61 2-D profile takes about 9.5 s (3721 small `optim()` calls). Fine for
  a dev plot; a function might default to `type = "slice"` for 2-D, or a coarser grid with
  smoothing, or `n` as an argument (it is).
- **1-D intervals:** CK (−0.61, −0.12) excludes log (0) as well as −1; Hpx (1.61, 3.02)
  excludes 1, so hemopexin really does want squaring.
- **Before / after** (raw; the demo's log CK, PK, LD; Box-Cox (−0.5, 2, 0, 0)):

  | | raw | demo logs | Box-Cox |
  |---|---|---|---|
  | Pillai, group | 0.349 | 0.439 | 0.469 |
  | Pillai, age | 0.091 | 0.086 | 0.090 |
  | Pillai, month | 0.118 | 0.129 | 0.133 |
  | Box's M (group), p | 134.5, < 1e-23 | 28.3, .0016 | 13.6, **.19** |

  `cqplot()`s: raw residuals far from multinormal; logs leave one large outlier; Box-Cox
  residuals lie within the envelope. The HE plots look much alike in shape: the
  transformation changes the fit to the assumptions more than the geometry of the effects.
- **Point 4 (equal covariance) gives a related but different answer.** Minimizing Box's M
  over λ (`optim()`, M is invariant to rescaling, so no Jacobian needed) gives
  λ = (−1.13, 1.76, −0.24, −0.18), vs the normality MLE (−0.36, 2.25, −0.15, 0.02):
  M falls from 15.5 to 8.1. Same direction for every variable, but CK is pushed further
  (toward a reciprocal). Normality alone already removes most of the heterogeneity here
  (raw M = 134.5); a plot of both criteria against λ would show the trade-off.

### Next decisions

- Response naming in `bc_refit()`: this scheme, or keep the original names and put λ in
  the axis labels?
- Default `type` for 2-D (profile is slow; slice is a good approximation when the λs are
  nearly uncorrelated, which `cov2cor(invHess)` shows).
- `pairs()` version (1-D on the diagonal, 2-D below); names (`bcProfile()`?
  `plot.bc_profile()`?); whether to propose a `plot()` method for `powerTransform` to car.

## Second round (2026-11-26): MF comments, a second dataset

MF: response names `CK_m0.5`, `Hpx_2`, `logPK`, `logLD` are OK; show λ on the axis
labels; add `extend_range` to show how far λ = 1 is; try another dataset; minimizing Box's M
is a great idea.

- Functions moved to **`dev/box-cox-functions.R`**, sourced by `dev/box-cox-demo.R`
  (Dystrophy) and the new **`dev/box-cox-diabetes.R`** (`heplots::Diabetes`).
- **λ in axis labels:** `λ_CK` etc. (plotmath) in 1-D and 2-D plots. (The earlier PNGs
  lacked it only because `pdftoppm` had no Symbol font.)
- **`extend_range = TRUE`** (with `ref = 1`, recycled) widens each axis to include the
  reference powers, and the plot marks them (orange lines and point), annotates the LR test
  of λ = ref for those variables, profiling over the others (χ²₁ in 1-D, χ²₂ in 2-D), and in
  2-D adds gray labelled deviance contours between the filled regions and the reference
  point, so you can see how fast the likelihood falls off toward it. Use a larger `n`
  (81) with the wider range.
- Legend goes in the corner farthest from the MLE, rounded and reference points.
- **`bc_boxM(Y, group, start)`**: λ minimizing Box's M (Nelder-Mead), with `M_of()` returned
  for evaluating other λs.

### Diabetes: `cbind(relwt, glufast, glutest, instest, sspg) ~ group`

- ML powers (1.19, −0.76, −0.27, 0.19, 0.55); rounded (1, −1, −0.5, 0.33, 0.5); LR test of
  the rounded vs the MLE χ²₅ = 6.4, p = .27. No transformation: χ²₅ = 337.
- `relwt` needs nothing (λ = 1 inside its interval, p = .74); `glufast` and `glutest` want
  strong transformations (≈ reciprocal and reciprocal square root), `instest` ≈ cube root,
  `sspg` ≈ square root.
- **Profile vs slice differ here**, for `glufast` and `glutest`, whose estimates are
  correlated (0.40): in 1-D, the slice falls off faster away from the MLE; in 2-D the region
  is tilted. So the slice is only a safe shortcut when `cov2cor(invHess)` is near diagonal.
  2-D profile with 3 other λs: 13 s on 61 × 61.
- **`covEllipses()` before/after** is the clearest picture of the gain: raw, the overt
  diabetics' ellipse dwarfs the others; after Box-Cox the three are much closer in size
  (orientation still differs).
- Pillai for `group`: 1.22 raw, 1.32 after.

### Normality vs equal covariance: the two criteria on both datasets

| Diabetes λ (relwt, glufast, glutest, instest, sspg) | LR vs normality MLE | Box's M |
|---|---|---|
| none (1, 1, 1, 1, 1) | 337, p ≈ 0 | 397 |
| normality MLE (1.19, −0.76, −0.27, 0.19, 0.55) | 0 | 149 |
| normality, rounded (1, −1, −0.5, 0.33, 0.5) | 6.4, p = .27 | 145 |
| min Box's M (6.33, −1.01, −0.60, 0.31, 0.57) | 76, p ≈ 0 | 138 |

- The normality transformation already removes most of the heterogeneity (M 397 → 145).
  Minimizing M directly gains little more (138), and every M is still hugely significant:
  the overt diabetics really are more variable, and no power transformation fixes that.
- **Caution:** minimizing M sent `relwt` to λ = 6.3, where M is nearly flat in λ, at a large
  cost in normality (LR 76). Minimizing M needs bounds or a penalty, or better, should be
  shown as a *plot*: M (or −log p) against λⱼ beside the normality profile, so a flat
  direction is visible rather than optimized blindly.
- On Dystrophy the two criteria agreed better (same direction for every λ, CK pushed toward
  −1; M 15.5 → 8.1).

### Next decisions

- A 1-D plot showing **both criteria** against λⱼ (log-likelihood profile and Box's M, two
  y axes or two panels) would make the trade-off visible; and/or a combined criterion.
- Default 2-D `type`: "profile" is right in general (Diabetes shows the slice can mislead),
  but slow; maybe "profile" with a coarser grid and smoothing.
- `pairs()` version; function names.

## Third round (2026-11-26): both criteria in one plot

`bc_profile(..., group = )` now also computes **Box's M at every grid point**, at the same
full λ vector as the log-likelihood (for a profile, the other λs at their profile optimum).
`plot()` shows M on a **second (right) axis** in 1-D and as **dashed contours** in 2-D, and
marks its minimum on the grid (an open triangle / "still falling" in the legend when the
minimum is at the edge of the grid). A fast `bc_M_fun(Y, group)` gives the same statistic
as `boxM()` (checked with `stopifnot()`) at about 0.2 ms a call; a 2-D 81 × 81 profile with M
takes about 20 s. Script: **`dev/box-cox-tradeoff.R`**.

What the plots show (much clearer than optimizing M blindly):

- **Diabetes:** for `glufast`, `glutest`, `instest`, `sspg`, M is smallest close to the
  normality MLE: the criteria **agree**. In 2-D (`glufast`, `glutest`) the M minimum sits
  almost on the rounded powers (−1, −0.5), inside the 95% region.
- **`relwt` explains the λ = 6.3 from `bc_boxM()`:** M decreases monotonically in λ, but only
  from 158 to 145, so its "minimum" is wherever the search stops. In 2-D (`relwt`,
  `glufast`) the M contours are horizontal: M depends on `glufast`, not on `relwt`.
- **Dystrophy:** M is minimized inside the LR interval for Hpx (1.74), PK (−0.2) and LD
  (−0.17); only for **CK do the criteria disagree**: M keeps falling below −0.89, beyond the
  LR interval (−0.62, −0.12), i.e. toward a reciprocal.
- So the useful summary is per variable: agree / disagree / M flat. A table of that, from
  the 1-D results, might be worth returning.

Next: a `pairs()` layout; a summary table per variable (normality MLE and interval, M
minimum, agree?); then decide what goes into the package.

## Moved to `R/` (2026-11-26)

MF: all the proposals OK; larger `cex.lab` by default; scope `bcPower` only (zeros and
negative values, `bcnPower`, are a separate story).

- **`R/bcProfile.R`**: `bcProfile()` (generic; methods for `"powerTransform"` and `"mlm"`),
  `plot.bcProfile()`, `print.bcProfile()`, `bcRefit()`, `bcBoxM()`; internal helpers
  `bc_loglik()`, `bc_M_fun()`, `bc_index()`, `bc_names()`, `bc_lab()`, `bc_fmt_p()`,
  `bc_corner()`. `bcRefit()` also accepts a `powerTransform` object (uses its rounded powers).
- Plot colours are arguments: `col` (blue), `ref.col` (`NULL`: red in 1-D, darkorange in
  2-D), `round.col` (purple), `wald.col` (black), `M.col` (darkgreen); `cex.lab = 1.3`.
- The λ = 1 annotation is plotmath, not Unicode, so it works on `pdf()` devices.
- Examples: Dystrophy (1-D, ~1 s; 2-D in `\donttest`, ~30 s), `bcRefit()` before/after
  `cqplot()` and `boxM()`, `bcBoxM()` on Diabetes without `relwt`.
- NEWS, pkgdown reference section "Transformations".
- The dev files (`box-cox-functions.R` etc.) are kept as the record of the prototypes.
