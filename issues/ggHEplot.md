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

- `ellipses`: long data frame — `term`, `type` ("H"/"E"), `x`, `y`, `rank` (so a renderer
  can draw a rank-1 H as a segment, not a filled polygon)
- `means`: data frame — `factor`, `level`, `x`, `y`
- `labels`: label positions from the `label.ellipse()` logic, as data
- `center`, `radius`, `xlim`, `ylim`, `dfe`, per-term scaling factor

`heplot.mlm()` then becomes the base-graphics renderer of that object (fully backward
compatible). Any ggplot renderer becomes a thin layer. Worth doing even with no ggplot
plans: it makes `heplot()` testable (useful for a future testthat setup).

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
