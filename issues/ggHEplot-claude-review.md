# Review of ggHEplot.md and dev/heplot_compute.R (Claude, 2026-11-25)

Written from `issues/ggHEplot-review-brief.md`, independently of the Codex review: I did not
read `ggHEplot-codex-review.md` before writing this. Checks were run in R 4.6.2 with
`devtools::load_all()`; the scripts are in the session scratchpad, and the key lines are quoted
below.

## 1. Summary

1. **The design is right.** A pure compute step holding full p x p shapes, with points made at
   render time, is the correct abstraction. Your test script already shows it reproduces
   `heplot()` exactly. Do the refactor whatever happens to the ggplot plans.
2. **Decision 3 is a real bug in `heplot()`, now verified.** In a within-S plot,
   `heplot.mlm()` draws a between-S hypothesis using the *untransformed* responses
   (`Age2IQ, Age4IQ`) on axes that are the *transformed* ones (`Age.L, Age.Q`). The
   prototype's `P = P[[iterm]]` is correct: `linearHypothesis(m, "AMED", P = P)` reproduces
   `SSP[["AMED:Age"]]` exactly.
3. **Two prototype bugs, both verified.** (a) A hypothesis named like a term or `"Error"`
   gives duplicate list names, and `as.data.frame()` silently merges the two ellipses into one
   122-point polygon. (b) `rank = qr(shape)$rank` depends on the scale: a full-rank 2 x 2
   E is reported as rank 1 when one response is in units 1e9 times larger.
4. **Decision 2: store the raw SSP and df, and derive the shape.** "Rescale without
   refitting" is the main payoff of the symbolic object, and pre-scaling gives it up.
5. **Decision 8: make it a new class with a noun name, and have `heplot()` return it as
   `$compute`.** The existing `"heplot"` components stay as they are.
6. **The ggplot route: agree with the order.** One change: think of the ggplot end as a
   *layer built from the computed object* (`geom_he(hc, variables = ...)`), not a stat that
   refits from mapped columns. That avoids the "wrong p" problem altogether. Also look at
   `ggforce::geom_ellipse()`, which already draws ellipses from symbolic parameters.
7. Rename a few fields (`factor`, `type`) that clash with argument names or base functions.

## 2. Central design

The split is what the notes say it is: `heplot.mlm()` becomes a renderer, and the test script
becomes the regression check. Things I would add to the object:

- **`test.statistic`** (Roy or HLT). `lambda.crit()` takes it (`R/heplots-internal.R:26`). If
  you store a `factor` or a means to recompute it, record which critical value it came from.
- **The hypothesis matrices themselves** (`lh$L`, or the hypothesis text) for each
  `source = "hypothesis"`. You need them to relabel, to re-test, or to project a contrast
  direction (the last row of the add-ons table).
- **`P`** for repeated-measures objects, so a reader can tell the shapes are in the
  transformed space. At the moment only `iterm` says so.
- **Which factor goes with which term**, for the `means`. At present `means` is one long
  frame for every factor in the model frame (`dev/heplot_compute.R:132-137`). An `autoplot()`
  wants "the means that belong to term `rate`". For `Plastic` (`rate * additive`), `means`
  has 4 rows and no cell means for `rate:additive`. That matches `heplot()`, but a ggplot
  version will want them as an option.
- **`call`**, so you can `update()` the object.

What I would leave out is `level`, or keep it only as a default (which is how it is used now).
It belongs to rendering, and the notes already make the point for `radius`.

## 3. Open decisions

### (2) Pre-scaled shapes, or raw SSP plus scaling

Store **`SSP` (raw), `df` and `dfe`**, and compute the shape with an accessor:

```r
he_shape(hc, "Species", size = hc$size, alpha = hc$alpha)   # SSP / dfe / factor
rescale(hc, size = "effect")                                # new object, no Anova()
```

Reasons:
- Point 4 of "Why symbolic" (switching `size`, `alpha` or `level` without a new `Anova()`)
  only works if you keep the raw SSP. With pre-scaled shapes plus `factor`, you can undo the
  scaling (`shape * factor`), but then every consumer has to know to do that.
- candisc and any future projection want raw H and E: `t(A) %*% H %*% A` and
  E^{-1/2} H E^{-1/2} (see the next point).
- Users adding `ellipse.axes()` still get a one-call answer from the accessor, so the
  simplicity argument for pre-scaling isn't lost.

### (3) Hypotheses in repeated-measures designs

**Verified bug in `heplot.mlm()`.** Running `example(Adopted)`'s model:

```
linearHypothesis(m, c("AMED","BMIQ"))$SSPH          # 4 x 4: Age2IQ Age4IQ Age8IQ Age13IQ
linearHypothesis(m, c("AMED","BMIQ"), P = P)$SSPH   # 3 x 3: Age.L Age.Q Age.C
all.equal(linearHypothesis(m, "AMED", P = P)$SSPH, a$SSP[["AMED:Age"]])   # TRUE
```

`heplot.mlm()` (`R/heplot.R:546-547`) calls `linearHypothesis(mod, h)` without `P`, then
takes `[variables, variables]`. With the default `variables = 1:2`, that is the
Age2IQ/Age4IQ block, drawn over E in Age.L/Age.Q coordinates. The ellipse is not
meaningless; it is simply in the wrong space.

**Meaning.** With `P`, the hypothesis L B = 0 becomes L B P = 0: "the between-S
predictors in L interact with the within-S term", i.e. they predict the *profile over age*. In
the plot, that is exactly what the `AMED:Age` and `BMIQ:Age` term ellipses already show, so the
`P`-transformed "Reg" is their joint test. This is the only reading consistent with the other
ellipses in that plot. Recommendation: fix `heplot.mlm()` the same way, and say so in NEWS,
since the `Adopted` example's figure will change. It is also worth checking `heplot3d.mlm()`
and `heplot1d.mlm()` for the same pattern.

### (8) A new class, or extending `"heplot"`

A **new class**, kept separate, with `heplot()` attaching it:

```r
he <- heplot(mod)        # draws, as now
he$compute               # the symbolic object; he$H, he$E, he$center ... unchanged
```

- Extending `"heplot"` would mix two things: the points drawn in one 2-D view, and the
  symbolic object that covers every view. A `print()` method for one would be wrong for the
  other.
- **Name.** `heplot_compute` names the verb, not the object. I'd suggest the function
  `he_ellipses()` (or keep `heplot_compute()`) returning class `"he_ellipses"`. Then
  `as.data.frame(<he_ellipses>)` and `autoplot(<he_ellipses>)` read naturally.

## 4. Prototype: bugs and gaps

1. **Name collisions merge ellipses.** `dev/heplot_compute.R:126,141`. Verified:
   `heplot_compute(iris.mod, hypotheses = list(Error = "Speciesversicolor"))` gives names
   `"Species" "Error" "Error"`. `as.data.frame()` then reports `table(d$ellipse)` as
   `Error = 122, Species = 61`, so one polygon is drawn through both. The same happens for a
   hypothesis named like a term. Fix: `make.unique()` the names, or error on a duplicate. It
   is also safer to keep the error ellipse in its own slot (`$E`) rather than as list element
   `"Error"`.

2. **Rank depends on scale.** `dev/heplot_compute.R:104,189`. Verified: with responses
   `a ~ N(0,1)` and `b ~ N(0,1) * 1e9`, `qr(E)$rank` is 1 for the full-rank 2 x 2 E.
   `qr(cov2cor(E))$rank` gives 2. The scale-free answer for an H is the number of nonzero
   eigenvalues of E^{-1/2} H E^{-1/2} (equivalently of E^{-1}H), bounded by `min(df, p)`. Those
   eigenvalues are also what candisc uses, so it is natural to store them. `heplot.mlm()` has
   the same weakness (`R/heplot.R:543`), but there it only feeds a TODO.

3. **`variables` are not validated.** `dev/heplot_compute.R:168`. Verified:
   `variables = c(0, 1)` fails with "non-conformable arguments"; `variables = -1` gets a
   misleading message ("got 1"). Fix: check `all(variables >= 1)`, that they are whole
   numbers, and that there are no duplicates (`c(1, 1)` would draw a degenerate line).

4. **Rank-1 output.** Suspected rather than tested as a bug: for a rank-1 view, `chol(pivot =
   TRUE)` gives a polygon that doubles back along a segment. `geom_polygon()` and `polygon()`
   both draw that acceptably. Still, `as.data.frame()` could return just the two endpoints
   when `rank == 1`, plus a `geom` hint column, as the TODO at line 11 suggests.

5. **`hyp_names` for character hypotheses.** Works (verified: an unnamed
   `list(c("Speciesversicolor", "Speciesvirginica"))` is labelled
   `"Speciesversicolor, Speciesvirginica"`). For long hypotheses this gets unwieldy; consider
   `"H1"`, `"H2"`, ... with the text kept in a field.

6. **No factors.** Fine (verified: `means` is `NULL` for `Rohwer ~ n + s + ns`). Two notes:
   character predictors are not picked up as factors (`is.factor` at `:132`), the same as in
   `heplot()`; and in repeated designs `means` are in the transformed space. That is right,
   but should be documented.

7. **Tests.** The test script only compares against `heplot()`, which (as point 3 of the
   decisions shows) can itself be wrong. Add a few checks that don't depend on it:
   `E$shape == crossprod(residuals(mod)) / dfe`; `size = "effect"` gives `factor == 1`; the
   eigenvalues of E^{-1}H match `Anova()`'s statistics. These convert directly into testthat.

## 5. The ggplot2 route

I agree with the order: refactor, then `tidy()`/`as.data.frame()`, then a prototype
`autoplot()`, and only then decide about a stat.

On `stat_he()`: the argument is correct as far as it goes, but it argues against a *stat*,
not against a *layer*. A ggplot extension doesn't have to compute from mapped columns:

```r
hc <- he_ellipses(mod)
ggplot() + geom_he(hc, variables = c("SL", "SW"), fill = TRUE) + geom_he_means(hc)
```

Here `geom_he()` is an ordinary function that returns a list of layers built from
`as.data.frame(hc, variables)`. It is "ggplot-native" in use (`+`, scales, themes,
`facet_wrap()` over a long frame of several variable pairs), and p, `iterm` and candisc
projections are all handled before ggplot sees anything. This is the pattern ggforce and
ggdist use for precomputed objects.

Overlooked prior art:
- **`ggforce::geom_ellipse(aes(x0, y0, a, b, angle))`** draws ellipses from symbolic
  parameters. An `he_ellipses` 2 x 2 shape converts to (a, b, angle) by eigen-decomposition,
  so `as.data.frame(hc, symbolic = TRUE)` could feed it directly.
- `ggplot2::stat_ellipse()` for data ellipses, which is the obvious companion layer, as the
  notes say.
- **Registration detail.** For `autoplot()` with ggplot2 in Suggests, use
  `@exportS3Method ggplot2::autoplot` (delayed registration, roxygen2 >= 7.3). For `tidy()`,
  heplots already imports `generics` (`DESCRIPTION`, `NAMESPACE:108`), so `tidy.he_ellipses`
  costs nothing.

## 6. API and naming

- **Field names.** `factor` (`:104`) shadows `base::factor` in `e$factor`-style code and
  confuses readers; use `crit` or `size_factor`. The `type` element (`"H"`/`"E"`) clashes in
  meaning with the `type = "II"` argument; use `matrix`.
- **`size` values.** `match.arg()` turns `"effect"` into `"effect.size"`, and that is what gets
  stored. That's fine, but the notes and tests say `"effect"`. Settle on one spelling for
  printing.
- **`as.data.frame()` output.** Add `variables` as columns (`xvar`, `yvar`), not only as an
  attribute. Attributes are lost through dplyr verbs and `rbind()`, and the column is what
  makes a faceted pairs plot (`facet_grid(yvar ~ xvar)`) possible.
- **Making `ellipse.axes()` / `ellipse.box()` generic** with `.default` = current behaviour is
  safe. Check reverse dependencies (candisc at least) for code that calls them positionally.
- **Backward compatibility.** Everything proposed is additive. The two visible changes are the
  bug fixes (label positions, already in 1.8.7, and the repeated-measures hypothesis), and
  both belong in NEWS.

## 7. Other comments

- Removing the dead `gmean` branch (`R/heplot.R:499`), which the notes mention, is safe.
  `data` is assigned at `:436`, so `missing(data)` is always `FALSE` there.
- `pairs.mlm()` is the cheapest early win after the refactor: compute once, then subset per
  panel. It also shows the abstraction pays off before any ggplot work.
- I'd drop approach 4 (a separate package) from the active list until there is a working
  `geom_he()`. The notes already make the case well.
