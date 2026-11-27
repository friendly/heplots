# Rencher & Christensen §4.6.2: multivariate outliers, and what it means for `cqplot()`

Notes from 2026-11-26. Source: Rencher & Christensen (2012), *Methods of Multivariate Analysis*,
3rd ed., §4.4.2 (pp. 106–107) and §4.6.2 (pp. 113–117), Example 4.6.2 and Figure 4.10.
Data: Table 3.7, the ramus bone data (20 boys, ramus height at 8, 8.5, 9, 9.5 years), from the
**rencher** package as `table3.7` (drop the `Individual` column).

**Bottom line:** Figure 4.10 is the same kind of plot as `cqplot()`, rescaled: sorted D²
against theoretical quantiles. What differs is the reference distribution. Rencher uses the
**exact beta** distribution of D² (Gnanadesikan & Kettenring 1972), and `cqplot()` uses the
**χ² approximation**. With small n or larger p the difference is real: the χ² reference makes
the largest distances look less extreme. So the method itself adds little, but the reference
distribution is worth adding, as an option. The same idea extends to `cqplot.mlm()`, which is
probably the more useful change (see "For `cqplot.mlm()`" below).

## What the book does

With **S** the usual (n − 1) covariance matrix,

- (4.27) D²ᵢ = (**y**ᵢ − **ȳ**)′ **S**⁻¹ (**y**ᵢ − **ȳ**)
- (4.28) uᵢ = n D²ᵢ / (n − 1)², which is **exactly** Beta(a, b) with a = p/2, b = (n − p − 1)/2,
  if the **y**ᵢ are multivariate normal (Gnanadesikan & Kettenring 1972).
- (4.29)–(4.31) vᵢ are beta quantiles at plotting positions (i − α)/(n − α − β + 1), with
  α = (p − 2)/(2p) and β = (n − p − 3)/(2(n − p − 1)).
- Figure 4.10 plots the sorted u₍ᵢ₎ (horizontal) against vᵢ (vertical), both on 0–1 scales, and
  doesn't draw a reference line. A nonlinear pattern means non-normality or outliers.

Rencher notes (p. 107, citing Small 1978 and his §5.3.2) that the χ²_p approximation to D² is
"very poor for even moderate values of p", and that plots of D² against χ² quantiles are
misleading. That is the main argument for the beta version.

§4.6.2 adds two tests, which are separate from the plot:

- **Wilks (1963) / Yang & Lee (1987)**, for a single outlier: w = 1 − n D²₍ₙ₎/(n − 1)², and
  Fᵢ = ((n − p − 1)/p) [1/(1 − n D²ᵢ/(n − 1)²) − 1] ~ F(p, n − p − 1), with
  P(max Fᵢ > f) = 1 − [P(F ≤ f)]ⁿ. Note that Fᵢ is a monotone function of D²ᵢ, so it ranks the
  observations the same way. It only adds an exact p-value for the most extreme one.
- **Mardia's kurtosis b₂,ₚ** (Schwager & Margolin 1982), an overall test for "some outliers"
  that needs no guess at their number, so it avoids masking and swamping.

## Reproducing Example 4.6.2

Script: `dev/outliers-Rencher.R` (needs the **rencher** package; writes `rencher-1.png` and
`rencher-2.png` to the working directory). The core is short:

```r
data(table3.7, package = "rencher"); Y <- as.matrix(table3.7[, -1])
n <- nrow(Y); p <- ncol(Y)
D2 <- mahalanobis(Y, colMeans(Y), cov(Y))
u  <- n * D2 / (n - 1)^2
al <- (p - 2) / (2 * p); be <- (n - p - 3) / (2 * (n - p - 1))
v  <- qbeta((1:n - al) / (n - al - be + 1), p/2, (n - p - 1)/2)
plot(sort(u), v)                               # Figure 4.10
qb <- (n - 1)^2 / n * v                        # the same quantiles on the D^2 scale
```

Results (n = 20, p = 4):

- **D² values** match Table 4.1 closely but not exactly. For example obs 7 is 4.06 here and
  4.29 in the book, obs 8 is 8.11 vs 7.99, and obs 10 is 5.85 vs 5.35. The largest three are
  the same (obs 9, 12, 20: 10.95, 10.58, 10.17 vs 11.03, 10.57, 10.09). The rencher package's
  data probably differ slightly from the printed Table 3.7. Worth checking a few values against
  the table if this becomes an example.
- **Mardia's statistics:** b₁,ₚ = 11.343 and b₂,ₚ = 28.917, against the book's 11.338 and
  28.884. Both are significant, as in the book.
- **Yang–Lee max F:** max Fᵢ = 5.79 (obs 9), with P(max F > f) = 0.097. So the single-outlier
  test doesn't reject, matching the book's conclusion that D²₍₂₀₎ = 11.03 < 11.63. The three
  largest are masking each other.
- **Plots:** the Figure 4.10 shape reproduces: three points well off the line, possibly a
  fourth (obs 8).

**χ² vs beta quantiles on the D² scale**, for the top four:

| i | χ²₄ quantile | beta quantile × (n−1)²/n | D² (sorted) |
|---|---|---|---|
| 17 | 6.34 | 5.92 | 8.11 |
| 18 | 7.21 | 6.55 | 10.17 |
| 19 | 8.50 | 7.42 | 10.58 |
| 20 | 11.14 | 8.94 | 10.95 |

Against χ², obs 9 (D² = 10.95) sits right on the line (quantile 11.14), so `cqplot()` makes it
look unremarkable. Against the beta quantile (8.94) it is clearly high, like obs 12 and 20.
The beta distribution is bounded: D² ≤ (n − 1)²/n = 18.05 here, while χ² has an unbounded
upper tail. That's why the gap is largest at the top, exactly where outliers are judged.

`cqplot(Y, id.n = 3)` flags the same three observations (9, 12, 20), but all the points are
inside its envelope. The envelope is wide, partly because the χ² reference itself is
too spread out in the upper tail at this n.

## What this could add to `cqplot()`

1. **An exact beta reference for `method = "classical"`.** For example a `dist = c("chisq",
   "beta")` argument, or "beta" by default for the classical method. Plot sorted D² against
   (n − 1)²/n × qbeta(ppoints(n), p/2, (n − p − 1)/2), keeping the D² scale and the χ²-style
   axis label ("Beta quantile, scaled"). The reference line stays y = x. As n grows the two
   agree, so the beta reference only ever matters in small samples, where it's the right one.
   - The plotting positions: Rencher's (i − α)/(n − α − β + 1) vs `ppoints(n)`. The
     difference is minor; ppoints is fine.
   - It **does not apply to `method = "mcd"` or `"mve"`**. For robust distances keep χ²
     (or use the Hardin & Rocke 2005 F approximation for MCD, if that's ever wanted).
2. **An envelope that matches.** The current envelope uses the χ² density with an IQR scale.
   For the beta reference, pointwise order-statistic intervals are easy: the i-th order
   statistic of n Uniforms is Beta(i, n − i + 1), so the band is
   qbeta(qbeta(c(.025, .975), i, n − i + 1), a, b) × (n − 1)²/n. This is only approximate,
   since the D²ᵢ are not independent (they sum to (n − 1)p exactly). A simulation envelope is
   the other option.
3. **Tests (lower priority).** The Yang–Lee max-F p-value could go in the returned data
   frame for the labelled points, as a Bonferroni-type exact p. A Mardia test exists
   elsewhere (e.g., **MVN**), and heplots has nothing for it now. It's probably better
   mentioned in the docs than added.
4. **Docs.** `?cqplot` could cite Gnanadesikan & Kettenring (1972) and Small (1978), and say
   that χ² is an approximation that is poor for small n relative to p.

### For `cqplot.mlm()`

`cqplot.mlm()` now takes the raw residuals and treats them like a sample: `Mahalanobis()`
centers them at their (zero) means, with the n − 1 covariance. It ignores two things:

- the residuals have unequal variances, cov(**e**ᵢ) = (1 − hᵢᵢ)Σ;
- the error df are n − r, not n − 1 (r = number of coefficients).

The exact analogue of (4.28) for regression residuals appears to be

  qᵢᵢ / (1 − hᵢᵢ) ~ Beta(p/2, (n − r − p)/2),  where qᵢᵢ = **e**ᵢ′(**E**′**E**)⁻¹**e**ᵢ.

A quick simulation (n = 30, r = 3, p = 3, 2000 replicates, a low- and a high-leverage case)
agrees: the means were 0.112 and 0.109 against 0.111, and KS tests against that beta gave
p = .35 and .12. I haven't found a reference for it yet; it's the multivariate form of the
standard result for internally studentized residuals, and should be checked in the
literature (Barrett & Ling 1992 is a likely place to start).

So a better `cqplot.mlm()` would plot (n − r) qᵢᵢ/(1 − hᵢᵢ), i.e., leverage-adjusted squared
distances in units of S = **E**′**E**/(n − r), against (n − r) × beta quantiles. Note the link
to **mvinfluence**: qᵢᵢ and hᵢᵢ are the Barrett & Ling Q and H for m = 1, and qᵢᵢ/(1 − hᵢᵢ) is
the "residual component" R there. But it's the version computed from *ordinary* residuals,
which mvinfluence doesn't currently compute (its Q uses deleted residuals; see mvinfluence
`issues/Q-deleted-residuals.md`).

## Found in passing

- `cqplot.default()`: `miss <- nrow(data) - length(OK)` is always 0, since `OK` is a logical
  vector of length `nrow(data)`. It should be `sum(!OK)`, so the "points with missing values"
  warning never fires. (`Mahalanobis()` prints its own message, so missing cases are still
  reported.)

## References

- Gnanadesikan, R. & Kettenring, J. R. (1972). Robust estimates, residuals, and outlier
  detection with multiresponse data. *Biometrics*, 28, 81–124.
- Small, N. J. H. (1978). Plotting squared radii. *Biometrika*, 65, 657–658.
- Wilks, S. S. (1963). Multivariate statistical outliers. *Sankhyā A*, 25, 407–426.
- Yang, S.-S. & Lee, Y. (1987). Identification of a multivariate outlier. Presented at the
  Annual Meeting of the American Statistical Association, San Francisco, August 1987.
- Schwager, S. J. & Margolin, B. H. (1982). Detection of multivariate normal outliers.
  *Annals of Statistics*, 10, 943–954.
- Hardin, J. & Rocke, D. M. (2005). The distribution of robust distances. *JCGS*, 14, 928–946.
