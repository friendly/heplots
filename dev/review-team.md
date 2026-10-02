# heplots cheatsheet — review notes

Review of the cheatsheet (`pkgdown/assets/heplots-cheatsheet.pdf`, as of commit 74628ba,
2026-09-30), with its source `dev/cheatsheet/heplots-cheatsheet.qmd` and the figure
script `dev/cheatsheet-figs.R`.

**How it was done.** Two AI reviewer agents (Claude) worked separately: one focused on
multivariate theory, the other on teaching and usability. Each read the sheet, the
figure script, and the package source. Each also ran every call on the sheet with the
dev version (1.8.5, via `pkgload::load_all()`). Every finding below was then checked
again by running R. Items already on the to-do list in `dev/cheatsheet.md` are left out,
apart from noting that the `pvPlot()` items there were also confirmed.

Sections 1 and 2 are the must-fix items. Two of them are **package bugs** (§1.1 and
§1.2), not just cheatsheet wording.

---

## 1. Package bugs

### 1.1 `termMeans()` mislabels rows when data aren't in factor-level order

In `R/termMeans.R:63–66`, the row names come from `unique(factor.values)`, which is in
order of appearance. The values come from `tapply()`, which is in factor-level order.
When the two orders differ, the labels are attached to the wrong means.

```r
peng.mod <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data = peng)
termMeans(peng.mod, "species")   # row "Gentoo" holds the Chinstrap means
plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data = Plastic)
termMeans(plastic.mod, "rate:additive")
#           tear gloss opacity
# Low:Low   6.30  9.56    3.74
# Low:High  6.88  8.72    3.14   <- actually rate = High, additive = Low
# High:Low  6.68  9.58    3.84   <- actually rate = Low,  additive = High
# High:High 7.28  9.40    5.02
```

Where it shows up:

* **`HE_manova` vignette, Plastic interaction figure (line 417).** The middle two cell
  labels are swapped. The text below the figure (lines 425–440) is correct, because it
  matches the true cell means. So the labels in the figure contradict the text next to
  it.
* **`heplot1d()`**, which calls `termMeans()` for its mean labels (`R/heplot1d.R:383`).
* **The cheatsheet is not affected.** iris is already sorted by `Species`, so the B5
  thumbnail is correct. The bug will matter if `termMeans()` ever appears on the sheet
  with `peng`.

**Fix:** take the row labels from the `tapply()` result (or from the factor levels)
instead of from `unique()`.

### 1.2 `eigstatCI()` "pooled" is really the total covariance

The "pooled" bootstrap in `R/eigstatCI.R:253–268` resamples all rows of `Y` and ignores
`group`. It therefore estimates `cov(Y)`, which includes the between-group spread, rather
than the pooled within-group covariance. This feeds the "pooled" point in
`plot_boxM_boot()` and the F4 thumbnail.

| peng, `which = "sum"` | trace |
|---|---|
| Adelie / Chinstrap / Gentoo | 210,384 / 147,777 / 251,532 |
| "pooled" from `eigstatCI()` (plotted) | **648,603** (= `trace(cov(Y))`) |

A pooled within-group trace is a weighted average of the group traces, so it can't fall
outside their range. The plotted value does.

**Fix:** resample within groups, then pool (or compute the pooled point from
`boxM()$pooled`).

A separate problem: on raw `peng` units, `body_mass` is 99.97% of the pooled trace. So
`which = "sum"` here amounts to comparing `body_mass` variances. For F4, use
`which = "logDet"` or `"precision"`, or standardize the data first.

---

## 2. Statistical statements on the sheet

### 2.1 p.1 Basics: "significant by Roy's test (α = .05) iff its H ellipse projects outside E"

This "iff" is exact only in the **full** response space. A 2-D view uses `H[v,v]` and
`E[v,v]`. The largest root of the 2-D pair can't exceed the largest root in the full
space, so in a plot the rule only works one way: H outside E ⇒ significant, but H inside
E ⇏ not significant.

The counterexample is `Plastic`, the dataset in the B4 thumbnail:

| term | Roy p | largest root ÷ critical value: full 3-D | 2-D: tear–gloss | tear–opacity | gloss–opacity |
|---|---|---|---|---|---|
| `additive` | .025 | **1.27** | 0.92 | 0.93 | 0.45 |

`additive` is significant, but its H line stays inside E in all three pairwise plots.

Suggested wording:

> If H sticks out beyond E anywhere in the plot, the term is significant by Roy's test.
> H inside E in one view does not mean "not significant": the effect may lie in another
> direction (check `pairs()`, `candisc`, or `car::Anova()`).

**A smaller point, optional.** `Roy.crit()` (`R/heplots-internal.R:39`) uses the same
upper-bound F approximation that `car::Anova(test = "Roy")` reports. That approximation
is exact when s = min(p, df_h) = 1, and liberal otherwise. In a null simulation (2000
reps), H crossed E 5.2% of the time for a 1-df term, 16% at iris dimensions (p = 4,
df_h = 2, df_e = 147), and 33% with p = 4, df_h = 3, df_e = 60. Saying "α = .05" on the
sheet slightly overstates its precision for multi-df terms.

### 2.2 p.2 Coefficients: "an ellipse excluding (0, 0) is significant"

`coefplot.mlm()` draws an unadjusted joint region for the **two plotted responses**,
with radius `sqrt(2 * qf(level, 2, dfe))`. The E1 thumbnail is drawn at `level = 0.68`
(see `dev/cheatsheet-figs.R`), so it contradicts the caption:

| predictor | excludes 0 at 68%? | bivariate p (SAT, PPVT) | excludes 0 at 95%? | Pillai p (3 responses) |
|---|---|---|---|---|
| `n` | yes | .149 | no | .284 |
| `s` | no | .500 | no | .097 |
| `ns` | yes | .007 | yes | .002 |
| `na` | yes | .007 | yes | .006 |
| `ss` | yes | .063 | no | .116 |

**Fix:** redraw at the default `level = 0.95`, and reword the caption, e.g., "a 95%
ellipse excluding (0, 0) ⇒ the predictor is significant for these two responses jointly
(unadjusted)".

### 2.3 p.1 B2 / Basics: "H and E on the data scale"; the data ellipses → HE plot arrow

* **E is identical under both scalings** (`E/dfe`, `R/heplot.R:527`); only H changes.
  The B2 caption implies that both change. Suggested caption: "E = residual covariance
  (the same in both); `"evidence"` inflates H to show significance, `"effect"` shows its
  size."
* **The A1 arrow reads as one picture turning into the other, but it doesn't.** Evidence
  scaling inflates the H radius by 3.9× for iris, and the two panels have different axes,
  so E shrinks to a dot. Drawing A1b with `size = "effect"` on the same `xlim`/`ylim` as
  A1a makes the link visible: E ≈ the pooled within-group ellipse, and H spans the group
  means. (The to-do list mentions `size = "effect"`, but only as a fix for overlapping
  labels.)

---

## 3. Calls that don't run, or don't draw what the sheet shows

| Panel | As shown | Problem (verified) | Suggested |
|---|---|---|---|
| G3 | `plot(robmlm(mod))` | Error: `argument "Y" is missing`. `robmlm` has only `default(X, Y)` and `formula` methods. | `rmod <- robmlm(formula(mod), data = peng)`, or add a `robmlm.mlm` method |
| G4 | `heplot(rmod)` / `heplot(mod, add = TRUE)` | Both fits are drawn with the same line styles. In the thumbnail, the robust **E is dashed** too, because the default `lty = 2:1` gives the first value to E. So "robust (solid) vs. classical (dashed)" isn't what's drawn. The thumbnail also isn't made by this call: the script draws the classical fit first, with `size = "effect"`. | `heplot(rmod, lty = 1)`; `heplot(mod, add = TRUE, lty = 2)` |
| I1 | `interpPlot(xy1, xy2)` | Error: `argument "alpha" is missing` (no default, `R/interpPlot.R:170`). | Show `alpha = 0.5`, or give `alpha` a default |
| F4 | `plot_boxM_boot(...)` | Without `Y` and `group`, it warns and draws no bootstrap CIs. The default `which = "logDet"` uses analytic CIs (`logdetCI()`), not a bootstrap. | `plot_boxM_boot(boxM(mod), Y, group, which = ...)` (and see §1.2) |
| B1, B2, C1, A1b | `heplot(mod)` | Plots Sepal.Length × Sepal.Width (the default `variables = 1:2`); the thumbnails use vars 2:3. | Add `variables = 2:3` to the calls shown |
| B5 | `heplot1d(mod)` | Defaults to `variables = 1`; the thumbnail shows variable 3. | `heplot1d(mod, variables = 3)` |
| B4 | `heplot3d(mod)` | The thumbnail is the `Plastic` snapshot, under the iris subtitle. | Note `Plastic` in the caption |
| B6 | `heplot(candisc(mod))` | `could not find function "candisc"` unless candisc is loaded. | Prefix `library(candisc)` |
| C1 | `hypotheses = hyp` | `hyp` is never defined on the sheet. Coefficient names depend on the contrasts, which is a common trap. | Show it, e.g., `hyp <- list("Vc:Vg" = "Speciesversicolor = Speciesvirginica")` |
| C2 | "overall test of all predictors vs. each one" | `Regr` covers the five PA predictors; `SES` is in the model but not in `Regr`. | "the five PA predictors jointly vs. each one" |
| Customizing | "`col`, `lty`, `lwd`, `fill`, `fill.alpha`: one per ellipse" | The **first** element goes to E, the rest to the H terms (`he.rep()`, `R/heplots-internal.R`). This is easy to get wrong, and it is what caused the G4 mistake. | Add "(first = E)" |

The rest run as shown: `pairs`, `size = "effect"`, `covEllipses(..., variables = 1:3)`,
`boxM` (both forms), `cqplot`, `distancePlot`, `coefplot`, `stdcoef`, `stdmodel`,
`etasq`, `uniStats`, `glance` (re-exported from generics, so broom isn't needed),
`vcov`, `termMeans(mod, "Species")`, `df.terms`, `colMeansList`, `covList`, `noteworthy`,
and `Mahalanobis()`. The `label.pos` caption "0:4 = C, S, W, N, E" matches
`R/label.ellipse.R`.

---

## 4. Worth considering

* **G2 `distancePlot` on a one-way MANOVA is degenerate.** The X are dummy codes, so the
  X distances take only 3 values (1.13, 1.34, 1.97): three vertical stripes. The X cutoff,
  `sqrt(qchisq(.975, 2))` = 2.72, falls off the plot. An MMRA model (`NLSY`, the doc
  example, or `Rohwer`) would show what the plot is for.
* **Use `Plastic` instead of iris for Basics?** In iris every effect is huge, so E
  collapses to a dot. `Plastic` has one clearly significant term (`rate`), one
  non-significant one (`rate:additive`, p = .30), and `additive`, which shows the 2-D
  caveat in §2.1.
* **Short caption notes:**
  - `heplot1d()` "evidence" scaling uses the univariate F critical value, not Roy's
    (`R/heplot1d.R:204`).
  - `etasq()` is Pillai-based by default (iris `Species`: 0.60, vs. 0.85 with Wilks).
  - `uniStats()` and `glance()` give the same per-response R², F, and p, so one row of
    the Model statistics table could go.
* **One-liners that could help:**
  - Box's M is very sensitive to non-normality, which is why the sheet's emphasis on the
    plots makes sense.
  - The C2 Rohwer model assumes equal slopes for `SES`. `HE_mmra` has a "Testing
    homogeneity of regression" section (line 343).
