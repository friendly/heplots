# heplots cheatsheet — working notes

A 2-page landscape cheatsheet for **heplots**, in the style of the Posit cheatsheets
(<https://github.com/rstudio/cheatsheets>): a banner title, hex logo, colored section
panels, and small thumbnails, each with a one-line call and a short description.

* **Current PDF**: <https://friendly.github.io/heplots/heplots-cheatsheet.pdf>
  (source copy: [`pkgdown/assets/heplots-cheatsheet.pdf`](../pkgdown/assets/heplots-cheatsheet.pdf))
* **Status (2026-09-30)**: first complete build of both pages. The content is settled;
  the work left is mostly visual polish of the thumbnails and page 1 layout.

## Other cheatsheets to learn from

* **Posit**: <https://github.com/rstudio/cheatsheets>. The model for the look of this
  one (e.g., ggplot2), and a possible place to contribute it later.
* **mlr3 family**: <https://github.com/mlr-org/mlr3cheatsheets>, published at
  <https://cheatsheets.mlr-org.com/>. Five sheets: mlr, mlr3, mlr3pipelines,
  mlr3tuning, mlr3fselect. Ideas worth a look:
  - Several related sheets that share one design. **candisc** and **mvinfluence** could
    get companion sheets.
  - They're written in R Markdown with the **cheatdown** package
    (<https://github.com/be-marc/cheatdown>): HTML/CSS layout, previewed in Chrome,
    printed to PDF.
  - GitHub Actions builds the PDFs and deploys them to `gh-pages`; only the sources and
    images are committed. Here, `build.R` is run by hand and the PDF is committed.
  - Not reviewed yet: how they lay out content and diagrams, which would be the most
    useful part to borrow.
* **cheatdown** (reviewed 2026-10-01): **not useful here**. It's an R Markdown output
  format that pours `##` sections into four columns on an A4 landscape page, then
  prints to PDF with headless Chrome. It can't do the panel/thumbnail-grid layout this
  sheet uses, and it hasn't been updated since 2021 (version 0.0.0.9000; depends on
  **crrri**, which is GitHub-only and also no longer maintained). Quarto + Typst already
  does more. `pagedown::chrome_print()` (CRAN) does the same Chrome printing if it's ever
  needed.

### Idea: an HTML version

Posit asks for text-based HTML versions of cheatsheets (`html/*.qmd` in their repo)
because they're accessible to screen readers and searchable, which a PDF of thumbnails
isn't. A Quarto HTML page with the same sections, calls and captions, with alt text on
the few images that are kept, could go on the pkgdown site next to the PDF. Best done
once the PDF content is stable, so the two don't drift apart.

## Files & build

| File | Role |
|---|---|
| [`dev/cheatsheet-figs.R`](cheatsheet-figs.R) | makes all thumbnails → `dev/cheatsheet/fig/*.png` (1.6 in square, 300 dpi, pointsize 7) |
| [`dev/cheatsheet/heplots-cheatsheet.qmd`](cheatsheet/heplots-cheatsheet.qmd) | the sheet: Quarto → Typst; layout in raw Typst with `panel()` and `thumb()` helpers |
| [`dev/cheatsheet/page.typ`](cheatsheet/page.typ) | Typst template partial: landscape page, margins, footer |
| [`dev/cheatsheet/build.R`](cheatsheet/build.R) | does it all: figures → PDF → publish |

```r
source("dev/cheatsheet/build.R")   # from the package root; close the PDF in any viewer first
```

`build.R` copies the PDF to `pkgdown/assets/` (served at the site root on the next
pkgdown build) and writes `man/figures/cheatsheet-thumbs.png`, which the README
"Cheatsheet" section uses. The pkgdown navbar has a "Cheatsheet" link.
Requires: Quarto (with Typst), and the **quarto**, **png**, **here**, **candisc**, **rgl** packages.

Layout: page ① *Fit & visualize* (Basics, template, HE plot family, linear hypotheses);
page ② *Check, refine & report* (covariance homogeneity, normality/outliers/robust,
customizing, coefficients, other plots, model statistics, learn more + datasets).
Highlight color is the logo blue `#4472C4`.

## To do

Ranked roughly by how much they'd improve the sheet.

### Page 1

- [ ] **Empty space**: about 1 in at the bottom of page 1. Use it for larger thumbnails,
      or move a panel (e.g., *Coefficients*) over from page 2.
- [ ] **Overlapping labels in iris sepal space** (A1b, B1, C1). Iris effects are so
      large that, with evidence scaling, E is a dot and the group/"Error" labels pile up
      in the center. Options: `size = "effect"` for these, a smaller `label.cex` with
      nudged `label.pos`, or a dataset with moderate effects.
- [ ] **A1 Basics diagram**: add the annotations from the outline ("E: residual
      variation", "H: the term", "group means", "outside E ⇒ significant"), so that it
      works like the "data + geom = plot" strip on the ggplot2 sheet.
- [ ] **B3 `pairs(mod)`**: unreadable at thumbnail size. Drop the factor-mean labels or
      show 3 variables.
- [ ] **B4 `heplot3d`**: the big pink E ellipsoid and tiny axis text don't read as an
      HE plot. Use a cleaner snapshot (e.g., `vignettes/images/plastic-HE3D.png`) or
      remove the axis labels.
- [ ] **B5 `heplot1d`**: the thick red bar is confusing, and "Species" overlaps it.
- [ ] **B6 `candisc`** and **C2 Rohwer**: crowded variable vectors / hypothesis labels.
      Iris has one dominant canonical dimension; another dataset may show the
      variable vectors better.

### Page 2

- [ ] Overlapping labels in `coefplot` (Coefficients), the `robmlm` weights plot (G3),
      and "SW"/"S" in the `label.pos` diagram.
- [ ] G4 robust vs. classical currently uses simulated data; consider a real dataset
      where they differ (e.g., `Skulls`).
- [ ] Fix the call shown for `pvPlot()`: the first argument is `X`, so `pvPlot(X, vars)`.

### Polish & build

- [ ] Title: Posit sheets put spaces in the separator: `heplots : : CHEATSHEET`.
- [ ] The version and date in the footer are typed into `page.typ`
      ("heplots 1.8.5 • Updated: 2026-09"). Have `build.R` fill them in from `DESCRIPTION`.
- [ ] Proofread all calls against the current API, and run each one as shown.
- [ ] Check legibility in print (Posit asks for text no smaller than ~10pt; some
      captions are smaller).
- [ ] Later: offer it to `rstudio/cheatsheets` as a contributed cheatsheet
      (license CC BY-SA 4.0), once it's stable.

### Package bugs found while making it

- [x] `label.ellipse()`: `"SE"` and `"NW"` were swapped (fixed in 9940881).
- [ ] `covEllipses()`: documents `label.pos = NULL` but errors on it (in `rep_fun()`).
- [ ] `pvPlot()`: fails on a tibble (e.g., `peng`); needs `as.data.frame()`.

---

# Original outline (2026-09-29)

The plan this was built from. Panel letters (A–J) and image IDs (A1, B3, …) match the
file names in `dev/cheatsheet/fig/`. Some panels were moved in the final layout (see above).

## 0. Production notes

### Templates

The Posit repo <https://github.com/rstudio/cheatsheets> provides:

* `powerpoints/0-template.ppt` and `keynotes/0-template.key`: the official
  templates, with layout tips. These produce the classic PDF look.
* `html/*.qmd`: newer text-based HTML versions written in Quarto. These are more
  accessible but lose most of the visual appeal. They could serve as a companion.

Their guidelines: reuse the visual theme, pick **one distinct highlight color**,
leave plenty of white space, keep text at least ~10pt, "be very concise, rely on
diagrams where possible", "if in doubt, leave it out". License CC BY-SA 4.0.

**Options for producing it**

1. PowerPoint template (recommended for version 1): gives the most control over the
   thumbnail grid and matches the look of the other sheets.
2. Quarto → PDF (Typst or LaTeX) with a CSS grid / multi-column layout: reproducible
   from `dev/`, easier to update when the API changes, but it takes more effort to
   make it look like a cheatsheet.
3. Both: build the PDF in PowerPoint, and generate the thumbnails reproducibly with
   `dev/cheatsheet-figs.R`.

**Highlight color**: take it from the hex logo (`man/figures/logo.png`) so that
section headers match the logo.

### Thumbnails

* Generate all images with one script, `dev/cheatsheet-figs.R` → `dev/cheatsheet/fig/*.png`.
* Tiny size (~1 in square, e.g., `png(width = 300, height = 300, res = 150)`), with
  `par(mar = c(1,1,1,1))`, no axis labels or titles, and `cex` reduced so that labels
  stay legible at thumbnail size.
* Use a few datasets throughout so the reader recognizes them:
  `iris` (MANOVA, 3 groups), `Rohwer` (MMRA), `Plastic` (2-way MANOVA),
  `peng` (penguins, for assumptions).
* Use a consistent palette: H ellipses in color, E ellipse in gray/red as usual in heplots.

---

## PAGE 1 — Visualizing effects

### Panel A: Basics (left column, ~25% width)

Short text:

* A **multivariate linear model** `lm(cbind(y1, y2, ...) ~ x1 + x2 + ...)`
  gives an object of class `"mlm"`. Tests of each term are based on two
  **SSP matrices**: **H** (hypothesis) and **E** (error).
* An **HE plot** shows **H** and **E** as ellipses (ellipsoids in 3D) in
  the space of two (or three) response variables.
* **Significance scaling** (the default, `size = "evidence"`): a term is
  significant by Roy's test (α = .05) **iff its H ellipse projects outside the E
  ellipse** somewhere. With `size = "effect"`, the two are on the same scale
  as the data (effect size).
* The **direction** of the H ellipse shows *how* the responses are related to
  the effect.

**Image A1 (key diagram)**: an annotated HE plot with labels pointing to
"E ellipse (residual variation)", "H ellipse (term)", "group means",
"grand mean", and "outside E ⇒ significant". Something like the
data + geom = plot diagram in ggplot2. Possibly a 3-panel strip:
*data ellipses by group* → *E & H* → *HE plot*.

```r
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species,
               data = iris)
covEllipses(iris[,1:2], iris$Species, fill = TRUE)    # data ellipses
heplot(iris.mod, fill = TRUE, fill.alpha = 0.1)        # HE plot
```

**Template box** (like ggplot2's "Complete the template"):

```r
mod <- lm(cbind(<Y1>, <Y2>, ...) ~ <TERMS>, data = <DATA>)
car::Anova(mod)                     # multivariate tests
heplot(mod, variables = <1:2>,      # which responses
       terms = <TERMS>,             # which H ellipses
       hypotheses = <CONTRASTS>,    # linear hypotheses
       size = "evidence",           # or "effect"
       fill = TRUE)
```

### Panel B: HE plot family (center, the main panel)

Grid of thumbnails with a code line and a 1-line description:

| Image | Call | What it shows |
|---|---|---|
| B1 | `heplot(mod)` | 2D HE plot for two responses |
| B2 | `heplot(mod, size = "effect")` | effect-size scaling |
| B3 | `pairs(mod)` | all pairwise HE plots (scatterplot matrix) |
| B4 | `heplot3d(mod)` | 3D HE ellipsoids (rgl) — use a static snapshot, e.g., `vignettes/images/plastic-HE3D.png` |
| B5 | `heplot1d(mod)` | 1D HE plot (intervals) |
| B6 | `candisc::heplot(candisc(mod))` | HE plot in canonical space (cross-reference to **candisc**) |

**Suggested data**: `iris.mod` for B1–B3, B5; `Plastic` for B4
(`lm(cbind(tear, gloss, opacity) ~ rate*additive)`); `Rohwer` for an MMRA example.

### Panel C: Tests of linear hypotheses

The `hypotheses =` argument accepts contrasts / linear combinations, which are drawn as
degenerate ellipses (lines for 1 df).

| Image | Call |
|---|---|
| C1 | `heplot(mod, hypotheses = list("V:N" = c("SpeciesVersicolor", ...)))` — 1-df contrasts as lines |
| C2 | MMRA: `heplot(rohwer.mod, hypotheses = list("Regr" = c("n","s","ns","na","ss")))` — the overall regression test vs. separate predictors (Rohwer, like `mmra-rohwer-HE1`) |

Text: 1-df H "ellipses" are lines; for a quantitative predictor the line
shows the direction of the regression coefficients in the response space.

### Panel D: Customizing HE plots (arguments)

Compact list, in the style of ggplot2's "Aes" panel:

* `variables` — which responses (indices or names)
* `terms`, `hypotheses` — what to draw; `term.labels`, `hyp.labels`
* `size = "evidence" | "effect"`, `alpha`, `level`
* `col`, `lty`, `lwd`, `fill`, `fill.alpha` (vectors, one per ellipse)
* `label.pos` — `0:4`, compass `"N","NE",…`, or a fraction 0–1 (`label.ellipse()`)
* `factor.means`, `grand.mean`, `markH0`, `center.pch`
* `add = TRUE` — overlay; `xlim`, `ylim`, `offset.axes`
* Repeated measures designs: `idata`, `idesign`, `imatrix`, `iterm`

**Image D1**: small `label.pos` diagram — ellipse with labels at C, N, NE, E, … (from
`label.ellipse()` examples).

### Panel E: Coefficients (small)

| Image | Call | What it shows |
|---|---|---|
| E1 | `coefplot(mod)` | joint confidence ellipses for coefficients (Rohwer, like `mmra-rohwer-coefplot-1.png`) |
| E2 | `stdcoef(mod)` / `stdmodel(mod)` | standardized coefficients |

---

## PAGE 2 — Assumptions, statistics & utilities

### Panel F: Homogeneity of covariance matrices

| Image | Call | What it shows |
|---|---|---|
| F1 | `covEllipses(peng[,3:6], peng$species, fill = TRUE)` | within-group covariance ellipses (+ pooled) |
| F2 | `covEllipses(..., variables = 1:4)` | scatterplot matrix version |
| F3 | `plot(boxM(mod))` | log determinants of group covariance matrices with CIs |
| F4 | `plot_boxM_boot(...)` | bootstrap CIs for the Box's M statistics (new) |

Text: `boxM(Y, group)` or `boxM(mod)`: Box's M test; `eigstatCI()`, `logdetCI()`,
`traceCI()` for other summaries of the matrices;
`bartlettTests()` and `leveneTests()` for univariate tests, one per response.

### Panel G: Multivariate normality, outliers & robust fitting

| Image | Call | What it shows |
|---|---|---|
| G1 | `cqplot(mod)` | χ² QQ plot of squared Mahalanobis distances of residuals |
| G2 | `distancePlot(mod)` | distances by observation, cutoff line, labeled outliers |
| G3 | `plot(robmlm(mod))` | observation weights from a robust MLM |
| G4 | `heplot(robmlm(...)); heplot(mod, add = TRUE, lty = 2)` | robust vs. classical HE plot |

Text: `Mahalanobis()` (with robust center/cov), `noteworthy()` to find unusual points to
label in a 2D plot.
Cross-reference: **mvinfluence** for influence diagnostics.

### Panel H: Model statistics (text only, 2 columns)

| Function | Returns |
|---|---|
| `car::Anova(mod)` | multivariate tests (Pillai, Wilks, H-L, Roy) |
| `etasq(mod)` | multivariate η² (partial effect size) for each term |
| `uniStats(mod)` | univariate R², F, p for each response |
| `glance(mod)` | one row per response, like `broom::glance()` |
| `vcov(mod)` | covariance matrix of coefficients |
| `termMeans(mod, "term")` | means of the responses for the levels of a factor |
| `df.terms(mod)` | df for each term |

### Panel I: Other plots & utilities (small)

| Image | Call |
|---|---|
| I1 | `interpPlot(X1, X2)` — interpolate between two related data sets (e.g., data → residuals) |
| I2 | `pvPlot(Y, X)` — partial variables plot |
| — | `ellipse.axes()`, `ellipse.box()`, `label.ellipse()`, `mark.H0()` — additions to plots |
| — | `trans.colors(col, alpha)` — transparent colors for `fill` |
| — | `colMeansList()`, `covList()`, `colDevs()`, `statList()` — statistics for groups |
| — | `gsorth()` — Gram-Schmidt orthogonalization |
| — | 3D (rgl) helpers: `Ellipsoid()`, `arrow3d()`, `bbox3d()`, `cross3d()`, `ellipse3d.axes()` |

### Panel J: Datasets (small strip along the bottom)

37 datasets for MANOVA / MMRA examples. List the most useful ones with their designs:

* **MANOVA**: `Plastic` (2-way), `Skulls` (1-way, ordered), `AddHealth`, `MockJury`, `Pottery2`, `Iwasaki_Big_Five`, `peng`
* **MMRA**: `Rohwer`, `Hernior`, `SocGrades`, `NLSY`, `schooldata`
* **Repeated measures**: `VocabGrowth`, `WeightLoss`, `Adopted`, `ReactTime`, `RatWeight`
* See `vignette("datasets", package = "heplots")` for a classified table.

### Footer

* Vignettes: `HE_manova`, `HE_mmra`, `Robust`, `datasets`
* Related packages: **candisc** (canonical views), **mvinfluence** (influence),
  **car** (`Anova()`, `linearHypothesis()`), **rgl** (3D)
* Reference: Friendly (2007), *HE plots for multivariate linear models*, JCGS;
  Friendly, Monette & Fox (2013), *Elliptical insights*, Statistical Science.
* `CC BY-SA 4.0 • Michael Friendly • friendly.github.io/heplots • heplots 1.8.5 • Updated 2026-09`

---

## Decisions log (2026-09-30)

* **Decided**: 2 pages; include a `candisc` panel (B6); no formula box.
* **Q3 (main example)** — no reply; going with `iris` for page 1, `peng` for page 2.
* **Q4 (production path)** — Quarto → Typst, built reproducibly by `dev/cheatsheet/build.R`.
* **Thumbnails**: `dev/cheatsheet-figs.R` → `dev/cheatsheet/fig/*.png` (22 images,
  1.6 in square at 300 dpi, pointsize 7). Every panel image from the outline exists, except
  A1 annotations and E2 (`stdcoef()`, which is text only).
* **Still rough**: overlapping group labels in iris sepal space (A1b, B1, C1, B6);
  crowded variable vectors in B6 (iris has one dominant canonical dimension); G4 robust vs.
  classical differ little for `peng`. Maybe use `Skulls` there instead.
* **Page 1 prototype (Quarto → Typst)**: `dev/cheatsheet/heplots-cheatsheet.qmd` →
  `.pdf`. Layout is in raw Typst with `panel()` and `thumb()` helpers. The page setup
  (landscape, margins, footer) is in the `page.typ` template partial; setting it in the
  body gave a blank first page. The highlight color is the logo's blue `#4472C4`.
  Still to do: fill about 1.3 in of empty space at the bottom (bigger thumbnails, or
  move panels between columns), make the thumbnails schematic, and write page 2.
* **Layout chosen: variant "C"** (two pages, by workflow): ① *Fit & visualize*, ② *Check,
  refine & report*. B's "Other plots" and datasets list were merged into page 2. The trials
  (`dev/cheatsheet/try-*`) are git-ignored and kept locally only.
* **Build & publish**: `source("dev/cheatsheet/build.R")` regenerates the figures, renders
  the PDF, and copies it to `pkgdown/assets/heplots-cheatsheet.pdf`, which is served at
  <https://friendly.github.io/heplots/heplots-cheatsheet.pdf>. It also writes
  `man/figures/cheatsheet-thumbs.png`. The README (section "Cheatsheet") and the pkgdown
  navbar link to it.
* **Package bugs found while doing this**:
  - FIXED: `label.ellipse()` had `"SE"` / `"NW"` swapped.
  - TODO: `covEllipses()` documents `label.pos = NULL` but errors on it (`rep_fun()`).
  - TODO: `pvPlot()` fails on a tibble (`peng`); needs `as.data.frame()`.

## Questions from the outline (resolved; see the log above)

1. **1 or 2 pages?** The content above needs 2. For 1 page, drop Panels E, I, and J,
   and move H into a narrow sidebar.
   MF: Let's do 2 pages, as is most oftn done.
   
2. **Scope of candisc**: include a canonical panel (B6) even though it's a different package?
   It's the natural "next step" after an HE plot.
   MF: Yes, show an analogous `candisc` example
3. **Main example**: `iris` is familiar, but `peng` or `Plastic` would show more
   package-specific data. I'd use `iris` for Page 1 (familiar) and `peng` for Page 2.
   
4. **Production path**: PowerPoint template vs. Quarto (see §0).

5. Should the Basics panel include a small formula box (H, E, Roy's θ,
   `H E⁻¹` eigenvalues), or keep the sheet formula-free?
   MF: Keep the formula box out of it.
