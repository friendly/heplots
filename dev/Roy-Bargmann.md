# Notes: Roy-Bargmann Stepdown Analysis for MLMs

## Goal

Background/framework notes for the **Roy-Bargmann stepdown analysis** topic in
`dev/GK-Project.md` (Gavin's funding-project topic list), before sketching a
`RoyBargmann()` function. Follows up on Gavin's own note in his fork
(`gklorfine/heplots@GK-work:dev/GK/august-notes.md`), which already correctly
flagged that the StackOverflow-derived sketch in `GK-Project.md` is "not
strictly an RB test" and proposed an all-univariate alternative. This note
works out *why* that's the right call, from the original source.

---

## What the procedure is

Setup: a set of $p$ response variables $Y_1, \dots, Y_p$, ordered *a priori* by
theoretical/substantive importance (not chosen from the data), analyzed via a
single MLM

```r
lm(cbind(Y1, Y2, ..., Yp) ~ X1 + X2 + ...)
```

The overall MANOVA tests the _compound hypothesis_ that **none** of the $X$ terms
affect *any* linear combination of the $Y$'s. Roy-Bargmann stepdown analysis
decomposes that compound hypothesis into $p$ **univariate** hypotheses, tested
in the given priority order:

* **Step 1**: test $Y_1$ alone -- the ordinary univariate ANOVA/regression of
  $Y_1$ on the $X$'s.
* **Step $i$** (for $i = 2, \dots, p$): test $Y_i$ *conditional on* the
  higher-priority responses $Y_1, \dots, Y_{i-1}$ -- i.e. an ANCOVA: regress
  $Y_i$ on the $X$'s **with $Y_1, \dots, Y_{i-1}$ added as covariates**. The
  F-test for the $X$ terms in that model is the "stepdown F" for $Y_i$: does
  $Y_i$ add unique discriminating power beyond what the higher-priority
  responses already capture?

Every step uses the *same* $X$ terms; what grows from step to step is the set
of covariates. This only makes sense with a defensible substantive ordering --
it's explicitly not a data-driven variable-selection method.

This is confirmed directly from Roy (1958) itself (see References): step $i$
tests "the _conditional_ univariate distribution of the $i$-th variate given the
first $i-1$ variates," and "the compound multivariate hypothesis is accepted
[only] if all the component univariate hypotheses are accepted."

### Related motivating idea

This is similar, on the Y side, to what is done in _sequential, Type I_ tests for the Xs
in a uni/multi variate linear model. Each sequential test relates to the part of
Y not explained by the previous Xs, ordered by substance to aid in understanding the
overall F statistic in a model `lm(Y ~ x1 + x2 + x3 + ...)`

This may have been what motivated Sketch 1 below.

---

## Two candidate formulations -- and why only one is right

`GK-Project.md` currently records two sketches. Worth spelling out the
difference explicitly since it's easy to conflate them.

**Sketch 1** (from Stack Overflow -- a *shrinking multivariate block* at each
step):

```r
lm(cbind(y1, y2, y3) ~ x1 + x2 + x3 + ...)
lm(cbind(    y2, y3) ~ x1 + x2 + x3 + y1 + ...)
lm(cbind(        y3) ~ x1 + x2 + x3 + y1 + y2 + ...)
```

**Sketch 2** (Gavin's proposed correction -- a single univariate response at
each step):

```r
lm(y1 ~ x1 + x2 + x3 + ...)
lm(y2 ~ x1 + x2 + x3 + y1 + ...)
lm(y3 ~ x1 + x2 + x3 + y1 + y2 + ...)
```

**Sketch 2 is the actual Roy-Bargmann procedure.** Sketch 1 tests something
different at each step -- a MANOVA on the *remaining* variates, controlling for
the ones already stepped through -- rather than isolating a single conditional
univariate hypothesis. That distinction matters for more than terminology: as
laid out below, it's precisely the univariate, one-variate-at-a-time
construction of Sketch 2 that makes the stepdown F-tests:

(a) mutually independent under the null and 
(b) exactly reconstitute the overall Wilks' $\Lambda$ when multiplied together. Sketch 1 has neither property.

Sketch 1 was motivated by the idea of visualizing the multivariate tests using HE plots.
At each stage, could show the remaining associations of the remaining Ys, having controlled for
or partialed out the previous Ys. It doesn't have a neat decomposition associated with it,
but might still be worth considering for this project.

---

## Relation to overall Wilks' $\Lambda$

For the full MLM, Wilks' $\Lambda = |\mathbf{E}| / |\mathbf{E} + \mathbf{H}|$,
where $\mathbf{E}$ is the error (within-group) SSCP matrix and $\mathbf{H}$ is
the hypothesis SSCP matrix for the $X$ terms being tested.

A determinant of a $p \times p$ SSCP matrix can be factored, via successive
conditioning in a chosen variable order, into a product of $p$ terms: the
first is the (marginal) sum of squares of $Y_1$, and the $i$-th is the
*residual* sum of squares of $Y_i$ after regressing it on $Y_1, \dots,
Y_{i-1}$ (this is the same idea as a Cholesky decomposition of the SSCP
matrix, or building up $R^2$ one predictor at a time). Applying that
factorization to $\mathbf{E}$ *and* to $\mathbf{E} + \mathbf{H}$, in the same
variable order, and taking the ratio term-by-term, gives

$$
\Lambda = \prod_{i=1}^{p} \lambda_i, \qquad
\lambda_i = \frac{\text{error SS for } Y_i \mid Y_1,\dots,Y_{i-1}}
                 {\text{error} + \text{hypothesis SS for } Y_i \mid Y_1,\dots,Y_{i-1}}
$$

Each $\lambda_i$ is exactly the univariate "Wilks' lambda" for the stepdown
ANCOVA F-test of $Y_i$ from Sketch 2 above, related to its stepdown $F_i$ the
usual univariate way ($\lambda_i = 1 / (1 + (df_h/df_e) F_i)$ for the $X$
terms' hypothesis and error df at that step).

So the product of the $p$ stepdown $\lambda_i$'s **reconstructs the overall
multivariate $\Lambda$ exactly**, and -- this is Roy's actual result, not just
an identity -- the $p$ stepdown F-tests are *mutually independent* under the
null. That's what makes "test each step, reject overall if any step is
significant" a valid decomposition of the single multivariate test, rather
than just a post-hoc probe.

This is standard material covered in general multivariate-methods texts (e.g.
Bock 1975; Timm 2002) but I have not yet pinned down a fully worked citable
derivation for this note -- worth doing before writing this up for a paper or
vignette, but the identity itself is well established and not really in
question.

---

## Open attribution question

Sources consistently write "Roy-Bargmann," but the single reference the user
supplied is Roy (1958) alone. Bargmann is sometimes credited (in an
unpublished dissertation/technical report, ~1962-70) with formalizing the
ANCOVA-based computational procedure people actually use today from Roy's
more general step-down principle. Worth pinning down the actual Bargmann
citation before writing anything citable (a vignette, paper, or even
`RoyBargmann()`'s `@references`) -- flagging here rather than guessing.

---

## Implementation sketch for `RoyBargmann()` (for the follow-up)

Not attempting this yet -- just noting the shape of it for next time:

* Required input: the MLM's response variables **in priority order** --
  this has to come from the user (an argument, or the column order of the
  `cbind()` in the fitted `"mlm"` object, documented as significant), never
  inferred from the data. 
  
* For step $i$: fit `lm(Y_i ~ <original X terms> + Y_1 + ... + Y_(i-1))` and
  run `car::Anova()` on it to get the stepdown F-test for the $X$ terms.
  
* Also fit/report the overall MLM's Wilks' $\Lambda$ (`car::Anova(mlm_fit)`)
  for reference, and as a sanity check: $\prod_i \lambda_i$ from the stepdown
  steps should numerically match the overall $\Lambda$ -- a good unit test.
  
* Output: probably an object with `print`/`summary` methods (matching this
  package's `default`/`lm`/`mlm` S3 convention elsewhere), reporting a table
  of (variable, df, F, p, stepdown $\lambda$) analogous to SAS/SPSS stepdown
  output. Check how SAS, `PROC GLM / STEPDOWN` does this and reports it.
  + In R, this might look like a `"lmlist"` object, with one slot for each of the
    successive models.
  
* Visualization ideas already sketched in `GK-Project.md` (`heplot()`,
  `pvPlot()`-style conditioned scatterplots) -- not duplicating those here.

---

## References

* Roy, S. N. (1958). Step-Down Procedure in Multivariate Analysis. *The
  Annals of Mathematical Statistics*, **29**(4), 1177-1187.
  <http://www.jstor.org/stable/2236954> (open-access mirror:
  <https://projecteuclid.org/euclid.aoms/1177706449>). Confirmed directly
  from this source: at step $i$ the test is univariate, conditional on
  $Y_1, \dots, Y_{i-1}$; the compound hypothesis holds only if every
  component univariate hypothesis holds.

* Secondary descriptions consulted (general confirmation of the ANCOVA-style
  procedure, not the $\Lambda$-decomposition detail):
  [IBM: Where are the Roy-Bargman Stepdown tests?](https://www.ibm.com/support/pages/where-are-roy-bargman-stepdown-tests)
  and
  [Finch, "Performance of the Roy-Bargmann Stepdown Procedure as a Follow Up to a Significant MANOVA"](https://www.semanticscholar.org/paper/Performance-of-the-Roy-Bargmann-Stepdown-Procedure-Finch/394bca3bb0f25869318d18c2d57188be3335efee).

* Bock, R. D. (1975). *Multivariate Statistical Methods in Behavioral
  Research*. McGraw-Hill. -- standard textbook treatment of stepdown analysis
  and its relation to Wilks' $\Lambda$; not yet re-checked against this note,
  worth doing before citing formally.

* Timm, N. H. (2002). *Applied Multivariate Analysis*. Springer. -- likewise,
  a standard reference for the $\Lambda$-decomposition result; not yet
  re-checked.
