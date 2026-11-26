# Rencher datasets: candidates for heplots examples

The **rencher** package (v0.1.7) has 48 datasets from Rencher & Christensen (2012),
*Methods of Multivariate Analysis*, 3rd ed., named only by table number (`table6.18`).
This note says what each one is, tags its design the way `R/datasets.R` does, and rates it
as a possible heplots example.

**How this was made (2026-11-25).**
- Descriptions come from the package's help pages. Many of those are generic ("variable 1",
  "Biomarker 1"); where I filled in a meaning from the book, it's marked *(book)* and should
  be checked against the text.
- Each likely candidate was fitted quickly with `car::Anova()`: Pillai's test, p-value, and
  the % of the H eigenvalues on each dimension ("dims"). This shows whether an HE plot would
  have something to show. The script is in the session scratchpad, not here; the numbers
  below are from it.

**Tags** (as in `@concept`): `MANOVA`, `MANCOVA`, `MMRA`, `repeated`, `candisc`, `cancor`,
`contrasts`, `robust`. Also used here:
- `T2`: two groups (Hotelling T²; the H ellipse is a line, rank 1)
- `paired`: matched pairs (T² on differences)
- `doubly`: doubly multivariate repeated measures (several responses at each occasion)
- `growth`: one-sample growth curve (intercept-only between-S)
- `not HE`: for factor analysis, clustering, MDS or contingency tables; not useful here

**Rating:** ★★★ strong candidate · ★★ worth a look · ★ usable but small or weak or
available elsewhere · – not useful for heplots.

## Already in heplots (or close)

| rencher | heplots | note |
|---|---|---|
| `table8.3` | `FootHead` | same data; `CIRCUM` rounded to 1 decimal in rencher (57.2 vs 57.15) |
| `table3.6` | `Probe1` | same 11 subjects × 5 probe positions |
| `table7.1` | `Sake` | same 30 sakes (Siotani et al.) |
| `table6.25` | `RatWeight` | same Box (1950) rats; rencher has the *weekly gains* (differences of `wt0`–`wt4`) |
| `table3.5` | `Diabetes` | 46 patients, apparently a subset of the Reaven & Miller data |
| (Table 6.2) | `RootStock` | not in rencher |

## Summary

| dataset | n × vars | what | tags | rating |
|---|---|---|---|---|
| `table6.18` | 60 × 7 | Snap beans: sowing date × variety | MANOVA, candisc, contrasts | ★★★ |
| `table5.7` | 73 × 7 | Muscular dystrophy carriers vs noncarriers | T2, MANCOVA, robust | ★★★ |
| `table6.28` | 33 × 10 | Plasma phosphate, control vs obese, 8 times | repeated, growth | ★★★ |
| `table6.17` | 12 × 12 | Fish scores, 3 cooking methods (wide) | MANOVA, candisc | ★★ |
| `table6.22` | 63 × 7 | Cancer survival with ascorbate, 6 cancer types | MANCOVA, robust, candisc | ★★ |
| `table10.1` | 19 × 7 | Chemical reaction, 3 yields ~ 3 conditions | MMRA | ★★ |
| `table6.16` | 27 × 6 | Potthoff & Roy dental growth, boys vs girls | repeated, growth | ★★ |
| `table6.26` | 36 × 8 | Dogs' coronary potassium, 4 groups × 7 times | repeated | ★★ |
| `table6.29` | 18 × 11 | Mandible: 3 measures × 3 times, 2 groups | doubly, repeated | ★★ |
| `table6.19` | 20 × 13 | Blood: 3 measures × 4 reagents | doubly, repeated | ★★ |
| `table6.21` | 28 × 5 | Cork borings N, E, S, W (Rao) | repeated, contrasts | ★★ |
| `table5.5` | 39 × 6 | Flea beetles, 2 species | T2, candisc | ★★ |
| `table5.6` | 20 × 12 | Engineer apprentices vs pilots, 6 tests (wide) | T2 | ★ |
| `table5.1` | 64 × 5 | Beall: 4 psych tests, males vs females | T2 | ★ |
| `table6.6` | 16 × 5 | Bar steel: lubricant × A (wide) | MANOVA | ★ |
| `table6.8` | 15 × 8 | Guinea pigs, vitamin E × 6 weeks | repeated | ★ |
| `table6.24` | 12 × 5 | Trout albumin, 3 groups × 4 times | repeated | ★ |
| `table6.27` | 31 × 7 | Rat blood pressure, 4 groups × 6 times | repeated | ★ |
| `table6.23` | 13 × 8 | Mouse weights, 7 times | growth | ★ |
| `table3.7` | 20 × 5 | Ramus bone length, 4 ages | growth | ★ |
| `table3.8` | 25 × 4 | First and second sons' heads (Frets) | cancor | ★ |
| `table7.2` | 46 × 11 | Temperature, humidity, evaporation | MMRA, cancor | ★ |
| `table3.9` | 49 × 6 | Blood glucose on 3 occasions, two sets | cancor, MMRA | ★ |
| `table5.8` | 19 × 6 | Consumer vs producer goods cycles | T2 | ★ |
| `table8.1` | 12 × 3 | Steel at 2 rolling temperatures | T2 | ★ |
| `table4.2` | 51 × 7 | Hematology on 51 workers | robust (one sample) | ★ |
| `table5.3` | 15 × 7 | Pipe pits, coated vs uncoated | paired | ★ |
| `table5.9` | 15 × 7 | Words and verbs, informal vs formal essays | paired | ★ |
| `table5.10` | 16 × 4 | Bronchus cancer survival vs matched controls | paired | ★ |
| `table3.4` | 10 × 4 | Calcium in soil and turnip greens | MMRA | – |
| `table3.1` | 20 × 3 | Height and weight, 20 men | – | – |
| `table3.2` | 6 × 7 | Republican vote, 6 states × 6 elections | – | – |
| `table15.14` | 12 × 5 | Winter wheat yields, 12 sites × 4 years | not HE | – |
| `table15.13` | 41 × 8 | Air pollution in US cities | not HE | – |
| `table13.1` | 7 × 6 | Ratings of 7 people on 5 adjectives | not HE | – |
| `table15.1`, `15.7` | | City crime; European protein consumption | not HE | – |
| `table16.1`, `16.8`, `16.13`, `16.16`, `16.17`, `16.19` | | Distances, categories, contingency tables | not HE | – |
| `table8.3`, `3.6`, `7.1`, `6.25`, `3.5` | | already in heplots (see above) | | – |

## Strong candidates

### `table6.18`: Snap beans, sowing date × variety ★★★
`MANOVA` `candisc` `contrasts`

60 plots: 4 sowing dates (`S`) × 3 varieties (`V`) × 5 replicates (`ID`). Four responses
`y1`–`y4` (*book*: yield and quality measures of snap beans; Keuls et al. 1984).

- A balanced two-way MANOVA with **all three effects large**:
  `S` Pillai 2.36 (df 3, dims 96/3/1), `V` Pillai 1.10 (df 2, dims 98/2), and the
  interaction `S:V` Pillai 1.33 (df 6, dims 77/14/6/3), all p < 1e-7.
- So an HE plot shows three H ellipses of different rank and a real interaction; the
  canonical plot for `S` is essentially one-dimensional, and `S:V` is not. Sowing date is
  ordered, so polynomial contrasts (linear / quadratic in `S`) suit `hypotheses =`.
- Needs: `S` and `V` as factors (numeric codes in rencher); `ID` dropped; responses
  named from the book.
- heplots has few balanced two-way MANOVA examples with a strong interaction (`Plastic`
  has no interaction), so this one fills a gap.

### `table5.7`: Muscular dystrophy carriers ★★★
`T2` `MANCOVA` `robust`

73 women, 34 carriers and 39 noncarriers of Duchenne muscular dystrophy (Andrews & Herzberg
1985). The help page calls `y1`–`y6` "biomarkers", but the ranges match the book: *(book)*
`y1` age (20–59), `y2` month of the year the blood was taken (1–11), then four serum
enzymes: `y3` creatine kinase (15–657, very skewed), `y4` hemopexin, `y5` pyruvate kinase
(3.5–110), `y6` lactate dehydrogenase.

- Two groups clearly separated: Pillai 0.50, F(6, 66) = 11.1, p < 1e-8.
- More interesting than a plain T²: **age and month are covariates**, not responses, so the
  natural model is MANCOVA, `cbind(y3, y4, y5, y6) ~ Group + y1 + y2`.
- The enzymes are skewed with outliers (CK up to 657), which makes it a natural example
  for `robmlm()`, or for logging the responses and seeing what changes in the HE plot.
- A clinical screening question, and less familiar than iris-style examples.

### `table6.28`: Plasma inorganic phosphate, control vs obese ★★★
`repeated` `growth`

33 patients (13 control, 20 obese) measured at 8 times after a glucose challenge,
`H_0`, `H_0.5`, …, `H_5` (hours; Zerbe 1979).

- Strong within-S effects: `hour` Pillai 0.92 (p < 1e-11), and a large **group × hour
  interaction**, Pillai 0.62, F(7, 25) = 5.7, p = 0.0005. Group is also significant.
- Controls dip deeply and early (means 4.09 → 2.63 at 1.5 h, back to 3.94); the obese
  group starts higher and dips less and later (4.53 → 3.19 at 2 h, back to 4.01).
- **Not a difference in curvature:** on the polynomial components (in the actual hours), the
  groups differ on the linear (p = .002), cubic (p = .0005) and quartic (p = .0004), and not
  at all on the quadratic (p = .999). Both curves are equally U-shaped; they differ in where
  and how sharply they dip. So the obvious linear × quadratic HE plot misses most of the
  interaction (`G:hour` stays inside E), while linear × cubic and the `pairs()` plot show
  it. That's a good lesson about choosing the view. See `dev/Rencher-demos.R`. Unequal time spacing
  (0, 0.5, 1, 1.5, 2, 3, 4, 5) is a good reason to show `imatrix` / polynomial contrasts
  with the actual times.
- The help page lists the columns as `M_1 … M_60`, but the data have `H_0 … H_5`.

## Worth a look

### `table6.17`: Fish prepared by three methods ★★
`MANOVA` `candisc`

Four scores (aroma, flavor, texture, moisture) for fish cooked by 3 methods, 12 per method.
It is stored **wide**: `y1_1 … y1_4` are method 1's four scores, then `y2_*`, `y3_*`; it
needs reshaping to 36 rows × (method + 4 scores).

- After reshaping: method Pillai 0.86, F(8, 62) = 5.9, p < 1e-4, with dims 96/4. The
  canonical plot is essentially one-dimensional; an example where `candisc` shows that
  four sensory scores line up on one axis.
- Check in the book whether the 12 rows are 12 judges (then it's repeated measures on
  judges) or 12 independent fish (one-way MANOVA, as Rencher treats it).

### `table6.22`: Cancer survival with ascorbate ★★
`MANCOVA` `robust` `candisc`

63 patients with 6 types of cancer, `Gender`, `Age`, and four survival times: `y1` treated
with ascorbate, `y2` mean of 10 matched untreated controls, `y3` and `y4` the same after
treatment stopped (Cameron & Pauling 1978).

- Type of cancer is significant, Pillai 0.86 (df 5, p < 1e-4, dims 64/28): two dimensions,
  so a nontrivial canonical plot. Gender is not significant; age is borderline.
- Survival times are very skewed, so they need logging, and the pairing (treated vs control)
  suggests analysing differences or ratios. It makes a good example of "think before you
  MANOVA", but needs care.
- `TypeofCancer` and `Gender` are numeric codes; the help page gives the labels.

### `table10.1`: Chemical reaction ★★
`MMRA`

19 runs of a planned experiment (Box & Youle 1955): three outcomes, `y1` % unchanged
starting material, `y2` % converted to the product, `y3` % unwanted by-product; and three
conditions, `x1` temperature, `x2` concentration, `x3` time.

- All three predictors are strong: Pillai 0.95, 0.89 and 0.76 (each df 1, p < 0.001). Each
  H ellipse is a line (1 df) in a different direction, so it's a clean MMRA HE plot.
- **Teaching point:** the three responses are percentages that almost add to 100
  (row sums 92.6–99.6), so E is nearly singular in one direction. That would show up in the
  HE plot and in `pairs()`.
- The help page says the source is "Table 8.3"; it is Table 10.1.

### `table6.16`: Potthoff & Roy dental growth ★★
`repeated` `growth`

27 children (16 boys, 11 girls), distance at ages 8, 10, 12, 14.

- Famous growth-curve data. `age` strong (Pillai 0.83); sex significant (p = 0.006);
  `Sex:age` borderline (p = 0.07).
- Widely available elsewhere (e.g. `nlme::Orthodont`, in long format), so less new; its
  value would be a familiar repeated-measures example in a wide, `heplot()`-ready form.

### `table6.26`: Dogs' coronary sinus potassium ★★
`repeated`

36 dogs in 4 treatment groups (control, and three kinds of cardiac denervation), potassium
at 7 times after coronary occlusion (Grizzle & Allen 1969).

- Group significant (p = 0.001), time strong, and `G:time` significant (Pillai 0.84,
  df 3, p = 0.03, dims 59/34): a two-dimensional interaction, so a less trivial within-S
  plot than with two groups.

### `table6.29`: Mandible measurements ★★
`doubly` `repeated`

18 subjects in 2 groups; three measurements `A1`, `A2`, `A3` *(the help page says three
"activators"; the very different scales, about 117, 60 and 20, suggest three different
measurements)*, each at three times (Timm 1980).

- Measures and times differ hugely; group and all its interactions are null (p > 0.4).
- Useful mainly as a **doubly multivariate** example with `imatrix`, which heplots documents
  with few examples. With no group effect, it shows what "nothing between-S" looks like.
- The quick fit treated the 9 columns as a 3 × 3 within-S factorial; a proper doubly
  multivariate analysis would use `imatrix`.

### `table6.19`: Blood data, four reagents ★★
`doubly` `repeated`

20 subjects, three blood measurements (`y1`–`y3`) each with 4 reagents (Burdick 1979).
The help page lists only 3 reagents; the data have 4 (`R1_*` … `R4_*`).

- One sample. Reagent effect significant (p < 1e-4) and a large measure × reagent
  interaction. A doubly multivariate within-S design with no between-S factor.

### `table6.21`: Cork borings ★★
`repeated` `contrasts`

28 trees, weight of cork borings in the four directions N, E, S, W (Rao's classic).

- One sample; direction significant (Pillai 0.43, p = 0.002). The natural contrasts
  (N + S vs E + W, N vs S, E vs W) make it a good example for `hypotheses =` with a
  within-S term and no between-S design.

### `table5.5`: Flea beetles ★★
`T2` `candisc`

39 beetles of two species (*Haltica oleracea* 19, *H. carduorum* 20), four measurements.

- Very strong separation: Pillai 0.78, p < 1e-10. A two-group example: the H ellipse is a
  line, the rank-1 case. (`tourr::flea` is a different flea-beetle dataset: 3 species,
  6 variables.)

## Usable but limited (★)

- **`table5.1`**: Beall (1945), 4 psych tests, 32 men and 32 women. T², very significant
  (Pillai 0.61). Simple and clean, but just two groups.
- **`table5.6`**: 20 engineer apprentices and 20 pilots, 6 tests, stored side by side
  (`E_y1 … E_y6`, `P_y1 … P_y6`). After reshaping, T² Pillai 0.64, p < 1e-5. The help page
  lists `E_y3` twice and no `E_y6`; the data are fine.
- **`table6.6`**: Bar steel (Posten 1962), 4 lubricants × 2 levels of `A` *(book: probably
  two temperatures)*, torque and strain, 4 per cell; stored wide. Only `A` is significant
  (p = 0.0002); lubricant and the interaction are null.
- **`table6.8`**: Guinea pigs, 3 vitamin E levels × 5, weights at weeks 1, 3, 4, 5, 6, 7.
  `week` strong; group and the interaction not significant (p = 0.38, 0.09). The help page
  says weeks 1–7; the data have 6 weeks.
- **`table6.24`**: Trout albumin, 3 groups × 4 fish, 4 times. Group significant, but n = 12.
- **`table6.27`**: Rat blood pressure after induced heart attack, 4 halothane groups × 6
  times (Crepeau et al. 1985). Nothing is significant (all p > 0.19).
- **`table6.23`**, **`table3.7`**: one-sample growth curves (13 mice × 7 days; 20 boys'
  ramus bone at 4 ages). Strong time effects; only within-S plots possible.
- **`table3.8`**: First and second adult sons' head length and breadth, 25 families (Frets).
  Canonical correlations 0.79 and 0.05; the classic cancor example, but also in
  `boot::frets`. The help page mentions a `Group` column that isn't in the data.
- **`table7.2`**: 46 days of air and soil temperature, humidity, wind and evaporation. Can be
  set up as soil temperatures ~ air temperature + humidity + wind (several significant), but
  Rencher uses it for tests of covariance structure, and the variables are many and similar.
- **`table3.9`**: Blood glucose on three occasions, two sets of three (`y1`–`y3`, `x1`–`x3`;
  *(book) fasting and one hour after sugar intake*). As MMRA only `x3` is significant
  (p = 0.04). The help page says 50 rows; there are 49.
- **`table5.8`**: Consumer vs producer goods, 4 cycle measures, 9 vs 10 items. T², p = 0.03.
- **`table8.1`**: Steel at 2 rolling temperatures, yield point and strength, 5 vs 7.
  T², p = 0.004; tiny.
- **`table4.2`**: Hematology, 51 workers, 6 measures. One sample: for `cqplot()` /
  `covEllipses()` / outlier detection, not HE plots.
- **`table5.3`**, **`table5.9`**, **`table5.10`**: paired designs (coated vs uncoated
  pipes; informal vs formal essays; treated vs matched controls). The difference columns are
  already included in 5.3 and 5.9. An HE plot of a paired T² is a one-sample test on the
  differences.

## Not useful for heplots (–)

`table3.1` (bivariate height and weight), `table3.2` (6 states), `table3.4` (n = 10), and
the factor-analysis, cluster, MDS and correspondence-analysis data: `table13.1`,
`table15.1`, `table15.7`, `table15.13`, `table15.14`, `table16.1`, `table16.8`,
`table16.13`, `table16.16`, `table16.17`, `table16.19`.

## Data issues to fix in any dataset brought into heplots

- All are **tibbles**; convert with `as.data.frame()`.
- **Group variables are numeric codes** in most of chapter 6 (`Group` = 1, 2, 3, …), so
  `lm()` would treat them as covariates. Make them factors with the labels from the help
  page.
- **Wide layouts** that need reshaping to give a grouping factor: 5.6, 6.6, 6.17.
- **Non-syntactic names**: `Day 3`, `Week 1`, `Fruit/Veg`, `De Gaulle`, `Mao Tse`, and
  `d1 = y1-x1` in 5.9.
- **Generic names** (`y1`, `y2`, …) everywhere; the book gives the meanings.
- **Help pages that don't match the data**: 3.6 (says 27 rows, has 11), 3.8 (a `Group`
  column that doesn't exist), 3.9 (50 rows vs 49), 5.6 (`E_y3` listed twice), 6.8 (weeks
  1–7 vs 6 columns), 6.19 (3 reagents vs 4), 6.25 (says 13 rows, has 27), 6.28 (`M_*`
  columns vs `H_*`), 10.1 (source given as Table 8.3).

## Suggested first picks

1. **`table6.18` (snap beans)**: a balanced two-way MANOVA with a strong interaction and
   effects of different rank; fills a gap in heplots.
2. **`table5.7` (muscular dystrophy)**: two groups, but with covariates (MANCOVA) and skewed
   responses (robust); a clinical context.
3. **`table6.28` (phosphate)**: repeated measures with a strong group × time interaction and
   unequal time spacing.

Each would need factor coding, real variable names from the book, and a check of the
*(book)* claims above before it goes into `R/datasets.R`.
