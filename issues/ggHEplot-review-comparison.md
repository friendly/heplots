# ggHEplot reviews compared: Codex and Claude (2026-11-25)

Sources: `ggHEplot-codex-review.md` (Codex CLI 0.172.0, read-only sandbox) and
`ggHEplot-claude-review.md`. Both were written independently from `ggHEplot-review-brief.md`.

**How the two were made.** Codex could not run R: in the read-only sandbox,
`Rscript` failed with "cannot create 'R_TempDir'". So its "verified" means verified by reading
the source. It also read `car`'s source on GitHub. Claude ran R. After reading the Codex review,
Claude re-ran three of Codex's claims in R (marked ✔ below).

## Where they agree (treat as settled unless you disagree)

| Point | Codex | Claude |
|---|---|---|
| Pure compute step with full-space shapes is the right design | yes | yes |
| **Decision 2:** store raw SSP + df; derive the scaled shape with an accessor | yes | yes |
| **Decision 3:** real bug in `heplot.mlm()`; `P =` is right; it means L B P = 0, the between × within interaction | yes, from car's source | yes, verified numerically (`AMED` with `P` = `SSP[["AMED:Age"]]`) |
| **Decision 8:** a new class, keep the `"heplot"` result unchanged | yes | yes |
| Rank belongs to the view; df ≠ rank; rank-1 drawn as a segment | yes | yes |
| Names can collide and merge ellipses → give each ellipse a stable ID | by reading | verified (`"Error"` hypothesis → one 122-point polygon) |
| `variables` validation is weak (0, negative, duplicates) | by reading | verified |
| A ggplot stat/layer can take the computed object as a parameter, so the "wrong p" objection to `stat_he()` falls away | yes | yes |
| `ggforce::geom_ellipse()` is prior art | yes | yes |
| The test script should assert invariants, not just match `heplot()` | yes | yes |

## Found by only one

**Codex only. Worth acting on:**
- ✔ **`manova =` with a repeated-measures `Anova` but no `idata`** goes down the
  non-repeated branch and fails with a cryptic error ("argument must be coercible to
  non-negative integer"). Decide repeated-ness from the `Anova` object, not from the inputs.
  `heplot.mlm()` has the same logic.
- ✔ **Unknown term name** → "values must be length 1, but FUN(X[[1]]) result is length 0",
  rather than a useful message.
- ✔ **`...` is unused**, so `heplot_compute(mod, variables = 3:4)` silently ignores
  `variables`. Reject unused arguments.
- **`pairs.mlm()` already computes `Anova()` once** and passes `manova =` to each panel
  (`R/pairs.mlm.R:107,175`). The saving from a shared object is the per-panel hypotheses and
  scaling, not the refit. This corrects the notes' "re-scaling each time" point, and makes
  Claude's "cheapest early win" an overstatement.
- **Means are observed marginal means.** In unbalanced or ANCOVA designs they need not match
  the adjusted effect H shows. Document what they estimate.
- **Don't define `autoplot.mlm()`.** It claims the plot for every `mlm`, and can change
  dispatch in other packages. Put `autoplot()` on the computation class, or use an explicit
  `ggheplot()`. This argues against the notes' approach 2 as written.
- **`ellipse.axes()` / `ellipse.box()` default to a chi-square radius,** so an HE accessor must
  supply the F-based radius explicitly.
- Smaller points: term selection by `grep(iterm, terms)` can match the wrong term; give an
  undefined-scaling error when `dfe` is too small for Roy; the `na.exclude` path should be
  tested (suspected, not shown).

**Claude only. Worth acting on:**
- **`qr()$rank` depends on scale** (verified: a full-rank E is reported as rank 1 when one
  response is on a 1e9 scale). Use the eigenvalues of E⁻¹H, bounded by `min(df, p)`.
  Codex raised a tolerance issue in `chol` but not this one.
- Store `test.statistic`, the hypothesis matrices `L`, and `call` in the object.
- Put `xvar` and `yvar` as columns in `as.data.frame()` output, not only as an attribute,
  which also makes faceted pairs plots possible.
- Rename fields that clash: `factor` (shadows `base::factor`) and `type` (vs. `type = "II"`).
- Before fixing decision 3 in `heplot()`, also check `heplot1d()` and `heplot3d()`.

## Where they differ

- **Attaching the object to `heplot()`'s result.** Claude: add `$compute` now. Codex: defer
  until an annotation API needs it, because adding list components can break code that
  enumerates or compares the result. *Codex's caution is reasonable; deferring costs nothing.*
- **Naming.** Claude: `he_ellipses()` / class `"he_ellipses"`. Codex: `heplotData()` /
  `"heplot_data"`, to match the package's camelCase (`heplotData` matches `heplot3d`,
  `covEllipses`). *Your call. Codex's suggestion fits the package better.*
- **Scope of the first renderer.** Codex: polygon / segment / explicit rank-0 policy, E
  drawn first, grouped by ID. Claude: a `geom_he()` that returns layers. These are compatible;
  Codex is more specific.

## Suggested next steps (triage for you)

1. Fix `heplot.mlm()` for decision 3 (and check 1d/3d), with a NEWS item. Both reviews agree.
2. In the prototype: stable IDs, raw SSP + accessor, scale-free rank, argument validation
   (terms, variables, `...`), repeated-ness from the `Anova` object.
3. Turn `dev/heplot_compute-test.R` into assertions with independent invariants.
4. Settle the name and the `autoplot` target (the computation class, not `mlm`) before writing
   the ggplot prototype.
