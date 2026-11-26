# ggplot versions of heplots

How to bring heplots into the ggplot world?

- What would be the advantages of this?
- What would be the challenges?

- Possible approaches:
  - Embed ggplot inside heplot() methods with arguments for this, as done in some other packages [which??]
  - New ggHEplot() functions?
  - Entirely new package

---

## Ideas & suggestions (2026-11-25, with Claude)

### Key observation: computation and rendering are entangled

In `heplot.mlm()`, `car::Anova()` → SSP matrices → scaling (`lambda.crit(alpha, p, dfh, dfe)`,
`heplot.R` ~line 534) → ellipse coordinates (`ell()`) are interleaved with base-graphics calls.
The returned `"heplot"` object holds the H/E ellipse coordinates and `center`, but not the
factor means, label positions, or colors.

So the first step, whatever the approach, is to **split out a pure computation function**,
`heplot_compute(mod, terms, hypotheses, size, level, variables, ...)`, returning everything
needed to draw, with no drawing:

- `ellipses`: a **symbolic** representation (center, shape, radius, rank, ...), not boundary
  points — see "The `ellipses` slot: symbolic, not points" below
- `means`: data frame of factor-level means on all `p` responses
- `center`, `level`, `dfe`, `p`, `size`, `alpha`, `response.names`

Points (and label positions, axis limits) are produced from it only when rendering.

`heplot.mlm()` then becomes the base-graphics renderer of that object (fully backward
compatible). Any ggplot renderer becomes a thin layer. Worth doing even with no ggplot
plans: it makes `heplot()` testable (useful for a future testthat setup).

### The `ellipses` slot: symbolic, not points

**What happens now.** `ell(center, shape, radius)` (`R/heplot.R:418`) maps a unit circle of
`segments + 1` points through a pivoted Cholesky factor of `shape`. Each H is subset to the
two plotted `variables`, scaled by `scale/factor` (`factor = lambda.crit(alpha, p, dfh, dfe)`
for `size = "evidence"`, `:529-541`), passed to `ell()`, and the **scaled 2x2 matrix is then
discarded**. `H.rank` is computed for terms (`:541`), never for hypotheses, and not returned
(hence the stalled `# TODO: take account of rank=1?` at `:519`, `:603`). The returned object
is just `H` (list of 61x2 point matrices), `E`, `center`, `xlim`, `ylim`, `radius`; the docs
say "No methods for manipulating these objects are currently available." It is the
*rendering*, minus the information that defines it.

**Why symbolic.** An ellipse here is fully determined by (center, shape, radius) + rank:

1. Existing helpers already want it: `ellipse.axes(x, center, scale, radius, ...)` and
   `ellipse.box(x, center, radius, ...)` take a *shape matrix*. Today users can't add axes
   or a box to an HE plot without recomputing H themselves.
2. Rank-1 handling: with shape + rank, draw the segment `center ± radius*sqrt(λ1)*v1`
   instead of a collapsed polygon — resolves both TODOs.
3. Points on demand at any resolution (60 segments for base, more for smooth PDF/ggplot,
   a mesh for `heplot3d()`).
4. Rescale after the fact: `size = "evidence"` vs `"effect"` differ only by the scalar
   `factor`; store it and switching size / `alpha` / `level` needs no new `Anova()`.
5. **Store full p x p scaled matrices, not 2x2.** Because `scale` and `lambda.crit()` already
   use full `p`, the scaled p x p H and E are correct for *every* pair of variables; the 2x2
   for any pair is a submatrix.
   - `pairs.mlm()` calls `heplot()` per panel (`R/pairs.mlm.R:175`), re-scaling each time;
     it could compute once and subset.
   - Removes the `p` problem for a ggplot `stat_he()` (it reads a precomputed object
     instead of refitting on two variables).
   - Canonical / other projections are just `t(A) %*% H %*% A`.
6. Proper `print()`, `summary()`, `plot()`, `as.data.frame()` methods, generating points
   only for output.

**Sketch:**
```r
he <- heplot_compute(mod, terms, hypotheses, size, level, alpha, ...)
# $ ellipses: one element per H term / hypothesis, plus E
#     $ <term>: list(shape  = <p x p scaled matrix>,
#                    type   = "H" | "E",
#                    source = "term" | "hypothesis",
#                    df     = dfh,
#                    factor = lambda.crit(...) or 1,   # size scaling already applied
#                    rank   = qr(shape)$rank)
# $ center  : grand mean (length p)
# $ level, dfe, p, size, alpha, response.names
# $ means   : factor-level means on all p responses

as.data.frame(he, variables = c("SL", "SW"), segments = 100)   # expand to points
#   term type  x  y  rank
```

Caveat on `radius`: it is dimension-dependent (`sqrt(2 * qf(level, 2, dfe))` in 2-D, 3 in
`heplot3d()`), so compute it at expansion time from `level`, `dfe` and the target dimension
rather than storing a single value.

### Making `heplot()`'s result useful for base-R add-ons

Independent of ggplot, the symbolic object makes the *returned value* of `heplot()` a
toolkit for annotating the plot just drawn. Today a user gets point matrices and axis
limits, and anything beyond `lines(he$H$group)` means recomputing H.

What users plausibly want to add, and what it needs:

| Add-on | Needs | Today |
|---|---|---|
| Ellipse axes / principal directions | shape, center, radius → `ellipse.axes()` | recompute H |
| Bounding box / conjugate diameters | shape → `ellipse.box()` | recompute H |
| Rank-1 H as a segment / arrow | shape + rank (eigenvector) | not available |
| Re-draw one term, different style / fill | points for one term | `polygon(he$H$term)` ok |
| Extra labels, own placement | `label.ellipse()` on points | ok, but label positions not returned |
| Overlay a second `level` / `size` | shape + factor + dfe | re-run `heplot()` |
| Data ellipse or points on same scale | center, `xlim`/`ylim`, variables used | partly (`center`, lims) |
| Factor means, re-labelled / highlighted | `means` | recompute with `aggregate()` |
| Projection of an observation / contrast direction | shape (for Mahalanobis-type scaling) | recompute |

Proposals (all additive; existing `he$H`, `he$E`, `he$center`, `he$xlim`, `he$ylim`,
`he$radius` stay exactly as now):

- Add components to the `"heplot"` result: `shapes` (the scaled 2x2 H and E actually
  drawn), `rank`, `factor`, `df`, `variables`, `means`, `label.xy` (where labels went —
  `label.ellipse()` already returns its coordinates invisibly), and the drawing attributes
  used (`col`, `lty`, `lwd`, `fill.col`) so add-ons can match styles.
  Alternatively attach the full `heplot_compute()` object, e.g. `he$compute`.
- Small `add` helpers that accept a `"heplot"` object and a term name:

  ```r
  he <- heplot(mod)
  ellipse.axes(he, term = "Species")      # new method dispatching on "heplot"
  ellipse.box(he, term = "E")
  lines(he, term = "Species", lwd = 3)    # lines.heplot / points.heplot methods
  ```

  Making `ellipse.axes()` / `ellipse.box()` generic (with `.default` = current behaviour)
  keeps backward compatibility.
- `print.heplot()` / `summary.heplot()`: show terms, df, rank, size factor, and the 2x2
  shapes — currently printing the result dumps raw coordinates.
- Document the components in `@return` with a worked "annotating an HE plot" example
  (axes for one term, rank-1 arrow, re-labelled means).

### Bug found: hypothesis label positions (checked 2026-11-25)

In `heplot.mlm()`, hypothesis labels use `label.pos[hyp]` (`R/heplot.R:619`), but
`label.pos` was expanded by `he.rep(label.pos, n.ell)` to the order `H1, ..., Hn, E`, so the
right index is `label.pos[ell]` (as already used for `col[ell]`, `lty[ell]`, `lwd[ell]`).
Hypotheses therefore take the positions meant for the first *terms*. Verified by tracing
`label.ellipse()` with
`heplot(lm(cbind(Sepal.Length, Sepal.Width) ~ Species, iris), hypotheses = list("V-S" = ..., "V-Vi" = ...), label.pos = c("S", "N", "E", "W"))`:
`Species` → N (correct), `V-S` → N (should be E), `V-Vi` → E (should be W), Error → S.
Only visible when `label.pos` has length > 1 and `hypotheses` are given. `heplot1d()`,
`heplot3d()` don't index `label.pos` this way. **Fixed 2026-11-25** (v1.8.7). Affected
examples (labels move, now as their `label.pos` specifies): iris in `?heplot`, `?Parenting`,
and the AddHealth figure in the `HE_manova` vignette. All examples run cleanly.

Also: `H.rank` is not computed for hypotheses (`:544-555`).

### Approaches, least → most ambitious

1. **`as.data.frame()` / `fortify()` / `tidy()` methods for `"heplot"` objects.** Cheap, no
   ggplot2 dependency; `tidy.heplot()` sits naturally beside the existing `glance.mlm()`.
   ```r
   he <- heplot(mod, plot = FALSE)        # would need a plot= argument
   ggplot(tidy(he), aes(x, y, group = term, colour = term)) + geom_polygon(fill = NA)
   ```

2. **`autoplot.mlm()` / `ggHEplot()` in heplots, ggplot2 in Suggests.** `autoplot()` is the
   established convention (ggfortify, forecast). Preferable to `heplot(..., engine = "ggplot")`:
   an engine switch means every base arg (`lty`, `lwd`, `col`, `offset.axes`, `add = TRUE`, ...)
   needs a ggplot meaning or must be rejected, and `add = TRUE` has no ggplot analogue.
   A separate function can have a smaller, idiomatic interface: scales for colour/fill,
   `theme()` for the rest, `+` instead of `add`.

3. **A true `stat_he()` / `geom_he()` layer.** Most ggplot-native, but harder for a
   statistical reason: a stat only sees the two variables mapped to `x`, `y`. For
   between-S designs that is mostly fine (the 2x2 H, E submatrices of the full mlm equal those
   from refitting on just those two responses), but:
   - `size = "evidence"` scaling uses `p` (total responses) in `lambda.crit()`; a stat
     seeing 2 variables would silently compute 2-D significance scaling. Needs a `p =`
     parameter, or default to `size = "effect"`.
   - Repeated-measures designs (`idata`, `imatrix`, `iterm`) and canonical-space plots
     (candisc) don't fit "map two columns to x, y".
   - The stat needs the model formula as a parameter (`stat_he(formula = ~ group)`),
     a bit unusual in ggplot.

   So: a nice add-on for simple MANOVA designs, not a replacement.

4. **Separate package (ggheplots?).** Only if 3 grows: geoms, facet-based HE pairs plots,
   ggplot versions of `covEllipses` / `boxM` plots. Keeps heplots base-graphics and
   CRAN-stable; cost is keeping computation in sync — tolerable only if it *calls*
   `heplots::heplot_compute()` rather than copying it (another reason to refactor first).

### Advantages

- Faceting: HE plots across subsets / levels of a third factor nearly free; pairs plots via
  `facet_grid` on long data.
- Composition with patchwork; themes consistent with book figures.
- Legends instead of hand-placed term labels (optional — direct labels via geomtextpath
  or ggrepel).
- Natural companion to `stat_ellipse()` (data ellipses) — HE plots as the "model" analogue.

### Challenges

- Aspect ratio: HE plots need comparable scales — `coord_equal()` for commensurate
  variables, otherwise apply to standardized data.
- Rank-deficient H: rank 1 needs `geom_segment`/`geom_path`, not `geom_polygon`; fill must
  handle this.
- Drawing order and transparency: E usually first / behind; per-term `fill.alpha`.
- `markH0` / `mark.H0()` and `label.ellipse()` positions become annotation layers.
- 3-D: `heplot3d()` stays rgl; ggplot doesn't help.
- Feature parity is a long tail (`pairs.mlm`, `heplot1d`, candisc methods) — pick a core
  and document what is not covered.

### Recommended path

1. Refactor: `heplot_compute()` (compute) + `heplot.mlm()` (render), add `plot = FALSE`.
   Verify base output unchanged by comparing returned `H` / `E` before and after on the
   package examples.
2. Add `tidy.heplot()` / `as.data.frame.heplot()`.
3. Prototype `autoplot.mlm()` in `dev/`, reproducing a few vignette examples
   (Iris, Plastic, Rohwer) to see where the API pain is.
4. Only then decide whether `stat_he()` or a separate package is worth it.

## First-pass prototype: `dev/heplot_compute.R` (2026-11-25)

`heplot_compute.mlm()` + `as.data.frame()` (points for any 2 responses) + `print()`;
checked by `dev/heplot_compute-test.R` against the coordinates `heplot()` returns.
**Identical (max diff 0)** for iris (hypotheses, variables by name / reversed,
`size = "effect"`), Parenting, AddHealth, Rohwer (terms, a 2-var subset, a hypothesis),
RatWeight and Adopted within-S — except one case, below. This confirms that the full p x p
scaled shapes + submatrix give exactly what `heplot()` draws for any pair of variables.

### Choices it turned up

1. **Rank depends on the view.** Stored `rank` is in the full response space; the rank of a
   2-D projection can be lower (e.g. a 2-df term seen in a view where it collapses). So
   rank must be recomputed when points are made (`as.data.frame()` does, per view); the
   stored one is only informative. Decide whether to keep both.
2. **Pre-scaled shapes vs raw SSP.** The prototype stores `SSP * scale / factor` and records
   `factor`. Storing the raw SSP plus `scale`/`factor` would make switching `size` or `alpha`
   a cheap rescale rather than a recompute. Pre-scaled is simpler for users adding
   `ellipse.axes()` etc.
   **Done 2026-11-25:** the prototype now stores the raw `SSP` and `df`.
   `he_factor(x, ellipse, size, alpha)` and `he_shape(x, ellipse, size, alpha)` give the
   scaling and the scaled `p x p` shape on demand (the one-call answer for `ellipse.axes()`),
   and `as.data.frame()` takes `size =` and `alpha =`. Checked in
   `dev/heplot_compute-test.R`: rescaling a saved object equals refitting, and equals
   `heplot(alpha = 0.01)`.
3. **Hypotheses in repeated-measures designs — possible bug in `heplot()`.** With `iterm`,
   `heplot.mlm()` does the within-S work in the transformed space `Y %*% P[[iterm]]` (e.g.
   `Age.L, Age.Q, Age.C`), but `car::linearHypothesis(mod, h)` returns SSPH in the
   *untransformed* responses (`Age2IQ, Age4IQ, ...`), which are then subset
   `[variables, variables]`. So in `example(Adopted)`'s within-S plot, the `"Reg"` ellipse
   seems to be in a different space from E and the other H's. The prototype passes
   `P = P[[iterm]]` to `linearHypothesis()`; its `Reg` ellipse differs (max diff 19).
   **Needs your judgement** on what a between-S hypothesis should mean in a within-S plot
   (presumably the hypothesis × `iterm` interaction, which is what `P =` gives).
   **Resolved and fixed 2026-11-25** (commit 56cf2760): yes, the interaction; see below.
4. **Labels for unnamed hypotheses.** For `hypotheses = c("grade.L", "grade.Q")`, the H
   components of `heplot()`'s result are named `NA` (names come from `names(hypotheses)`).
   The prototype uses the hypothesis text when unnamed. Same fix could go into `heplot()`.
5. **Radius is 2-D specific.** Kept out of the object; `as.data.frame()` computes
   `sqrt(2 * qf(level, 2, dfe))` and accepts a different `level`. A 3-D expander would use 3.
6. **Terms with a different-sized SSP** (the "Skipping H term" case) are dropped with a
   warning at compute time, since the shape must be p x p; `heplot()` checks per plotted
   variables instead.
7. **Center.** `heplot.mlm()` has `gmean <- if (missing(data)) c(0,0) else colMeans(Y)`,
   but `data` is not an argument (it's `model.frame(mod)`), so this is always `colMeans(Y)`.
   The prototype just uses `colMeans(Y)`; dead branch to remove in `heplot()`.
8. **Class.** New `"heplot_compute"` class vs adding the symbolic parts to `"heplot"`;
   and whether `heplot()` should return it (e.g. as `$compute`) for base-R add-ons.

### Next steps

- Decide 8 (2 and 3 done); then have `heplot.mlm()` call `heplot_compute()` (the test script becomes
  the regression check).
- `ellipse.axes()` / `ellipse.box()` methods for these objects; segment output for rank 1.
- Rewrite the two hand-made ggplot HE figures from the blog on top of the prototype, as a
  test of the API (below).

## Test case for the API: HE plots already drawn by hand in ggplot (2026-11-25)

The ggplot question didn't come from nowhere. Two figures in the draft blog post "How big is
it?" are HE plots drawn in ggplot2 *without* `heplot()`, because they needed things base
`heplot()` doesn't do easily: side-by-side panels (patchwork) in the same style as the
post's other ggplot figures, annotations (brackets for √λ, "E = I"), and hand-placed labels
(the Ashley Rails / Isle Thorns overlap that `means.pos` now fixes in heplots, but not yet in
candisc). The extending-lm post, by contrast, uses `heplot()` / `heplot.candisc()`
throughout.

In `friendly.github.io/blog/drafts/How-big/R/`:

- **`h-relative-e.R`** (117 lines) is "How big is H, relative to E?" for `mathscore`, in three
  panels: (A) data space, where H is a line (2 groups); (B) after `z = E^{-1/2}(y - ybar)`, so E
  is the unit circle; (C) rotated to the axes of H*, leaving only the λs.
- **`pottery-he.R`** (129 lines) is Pottery in two panels: (A) Al vs Fe in data space, one
  "shadow" of five dimensions; (C) canonical space, with E = I, H on the axes (semi-axes
  √λ), structure-correlation arrows and site labels.

Each one re-implements, in about 30 lines, what `heplot()` computes internally:

- H and E from `car::Anova()`, divided by `dfe` (effect scaling only; evidence scaling
  would need `lambda.crit()`, which isn't exported);
- its own `msqrt()` and `ell()`, to turn a shape matrix into points for `geom_polygon()`;
- the canonical transformation `A = E^{-1/2} W` (W the eigenvectors of E^{-1/2} H E^{-1/2}),
  with `stopifnot()` checks that `A'EA = I` and `A'HA = diag(λ)`;
- the factor means, from `aggregate()`, and mapping them through the same `A`.

That duplication is what `heplot_compute()` is meant to remove, so **rewriting these two
scripts on top of the prototype is a realistic test of the API**: it shows what's awkward
before any `geom_he()` is written. What each panel would need:

| panel | needs | prototype has it? |
|---|---|---|
| data space, 2 chosen responses | `as.data.frame(hc, variables = c("Al", "Fe"), size = "effect")` | yes |
| factor means in that view | `hc$means`, columns for the 2 responses | yes, but a long frame for *all* factors; needs the ones for a term |
| E as the unit circle (metric change, `E^{-1/2}`) | a **linear view**: shapes `t(A) %*% SSP %*% A`, center and means mapped by `A` | **no** |
| canonical space (rotate to H*) | the same linear view with `A` from the eigenvectors, plus the λs | **no**; λs not stored |
| √λ brackets, `λ` text | eigenvalues of E^{-1} H for a term | **no** (both reviews: store them) |
| structure-correlation arrows | `cor(Y, Z)`: needs the data, not just the SSPs | no; belongs to candisc |
| scaled shape for annotations | `he_shape(hc, "Site", size = "effect")` | yes (decision 2) |

So the rewrite would turn up the main missing piece: a **projection, or "linear view"**,
`as.data.frame(hc, A = <p x 2 matrix>)` (or a `project(hc, A)` that returns another object),
applying `t(A) %*% SSP %*% A` to every ellipse and `A` to `center` and `means`. Codex's
review recommended this ("A linear view with basis `A` uses `crossprod(A, SSP %*% A)` and
projects the center and means by the same `A`."), and it is also what candisc's canonical
plots do. With it, panel A of `pottery-he.R` becomes roughly

```r
hc <- heplot_compute(lm(cbind(Al, Fe, Mg, Ca, Na) ~ Site, data = Pottery))
ggplot(as.data.frame(hc, variables = c("Al", "Fe"), size = "effect"),
       aes(x, y, group = ellipse, colour = type)) +
  geom_polygon(fill = NA) + coord_equal()
```

and panel C the same with `A = canonical_basis(hc, "Site")` in place of `variables`.

**Suggested test:** write `dev/pottery-he-compute.R` that reproduces `figures/pottery-he.png`
from `heplot_compute()` plus the smallest additions it forces (a linear view, stored
eigenvalues, means for one term), and compare the coordinates with those the blog script
computes. Then do the same for `h-relative-e.R`, whose panel B (metric change but no
rotation) checks that the linear view isn't limited to canonical bases.

## Reviews: Codex and Claude (2026-11-25)

Two independent reviews of these notes and the prototype, from the same brief:

- `ggHEplot-review-brief.md`: the brief.
- `ggHEplot-codex-review.md`: Codex CLI 0.172.0, read-only sandbox. It couldn't run R there,
  so its "verified" means verified by reading the source.
- `ggHEplot-claude-review.md`: Claude, with checks run in R.
- `ggHEplot-review-comparison.md`: the two compared (agreements, single-reviewer findings,
  differences), with suggested next steps.

Both agree on: decision 2, store raw SSP + df and derive the shapes; decision 3, a real bug;
decision 8, a new class, leaving the `"heplot"` result unchanged; stable IDs for ellipses;
and a ggplot layer built from the computed object, so p is not a problem.

### Fixed: repeated-measures hypotheses (decision 3), commit 56cf2760

`heplot()`, `heplot1d()` and `heplot3d()` now pass `P = P[[iterm]]` to
`car::linearHypothesis()`, so a between-S hypothesis in a within-S plot is its interaction
with `iterm` (L B P = 0). Check: hypothesis `"AMED"` gives exactly the `AMED:Age` term
ellipse. The same commit fixes `heplot1d()` failing for any covariate or within-S term
(it called `termMeans()` for every term), and its hypothesis labels drawn as `NA`.
`dev/repeated-hypotheses-test.R` checks all of this against the pre-fix commit 6a22dec5,
with a before/after plot for `Adopted`.
