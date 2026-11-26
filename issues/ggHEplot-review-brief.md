# Review brief: ggHEplot design notes and the heplot_compute() prototype

You are reviewing design work on the R package **heplots** (this repository), which draws
hypothesis-error (HE) plots for multivariate linear models (`mlm`) in base graphics. The
author is considering how to bring HE plots into ggplot2. Please give an independent,
critical review. Do not edit any files.

## What to read

1. `issues/ggHEplot.md`: the design notes. Start here.
2. `dev/heplot_compute.R`: a first-pass prototype that separates computation from drawing.
3. `dev/heplot_compute-test.R`: checks the prototype against what `heplot()` returns.
4. For context, as needed: `R/heplot.R` (especially `heplot.mlm()` and `ell()`),
   `R/pairs.mlm.R`, `R/heplot3d.R`, `R/ellipse.axes.R`, `R/ellipse.box.R`,
   `R/label.ellipse.R`, `DESCRIPTION`, `NAMESPACE`.

## What I want from you

Please address these in order, and be specific: cite file and line, and give short code
where it helps.

1. **The central design.** The notes argue for a pure `heplot_compute()` that stores
   *symbolic* ellipses (full p x p scaled shape matrices, plus df, rank, size factor), with
   points produced only at render time. Is this the right abstraction? What is missing from
   the object, or what is in it that shouldn't be?
2. **The open decisions** listed under "Choices it turned up" in the notes, especially:
   - (2) store pre-scaled shapes, or raw SSP plus `scale`/`factor`?
   - (3) the possible bug with `hypotheses` in repeated-measures (`iterm`) designs: is the
     analysis right, and what should a between-S hypothesis mean in a within-S plot?
   - (8) a new class vs. extending the existing `"heplot"` result.
   Give a recommendation for each, with reasons.
3. **Correctness of the prototype.** Read `dev/heplot_compute.R` carefully. Look for bugs,
   edge cases the test script does not cover (e.g. rank-deficient H, a single-df term,
   `variables` given by index, models with one factor vs. several, `size = "effect"` vs.
   `"evidence"`, missing data), and places where it silently differs from `heplot.mlm()`.
4. **The ggplot2 route.** The notes rank four approaches (tidy/fortify methods,
   `autoplot.mlm()`, a `stat_he()` layer, a separate package) and recommend refactoring
   first, then `tidy()`, then a prototype `autoplot()`. Do you agree? Is anything wrong in the
   argument against `stat_he()` (that a stat only sees the two mapped variables, so
   `size = "evidence"` scaling would use the wrong p)? Are there ggplot2 extension idioms
   or existing packages the notes overlook?
5. **API and naming.** Comments on function names, argument names, return-value structure,
   S3 methods (`as.data.frame()`, `tidy()`, `autoplot()`, making `ellipse.axes()` generic),
   and backward compatibility for existing `heplot()` users and for packages that depend on
   heplots (e.g. candisc).
6. **Anything else** you think the author should hear, including things to drop or
   simplify.

## Constraints

- This is a read-only review: don't modify, create or delete files. Reading files and
  running read-only commands is fine. If you can run R (`Rscript`) to check a claim, say
  what you ran and what it showed; if you can't, say the claim is unverified.
- Separate what you **verified** (by reading code or running it) from what you
  **suspect**.
- Prioritise: lead with the few points that matter most. No need to restate the notes.

## Output

A single Markdown document with these sections:

1. Summary (5 to 8 bullets, most important first)
2. Central design
3. Open decisions (one subsection per decision, each ending in a recommendation)
4. Prototype: bugs and gaps (each item: file:line, what's wrong, a suggested fix, and
   verified or suspected)
5. ggplot2 route
6. API and naming
7. Other comments
