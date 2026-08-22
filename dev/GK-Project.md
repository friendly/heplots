# GK Funding Project

These are just some suggestions for framing your project, if you want to go an MLM way.

How about a title: 

* _Advancing Multivariate Linear Models_
* _Multivariate Linear Models for the 21^st Century_ (aspirational, or over-the-top?)

Could use some material / frame-setting from my paper
Friendly, M., & Sigal, M. (2014). Recent Advances in Visualizing Multivariate Linear Models. _Revista Colombiana de Estadistíca_, **37**(2), 261–283. https://doi.org/http://dx.doi.org/10.15446/rce.v37n2spe.47934

## Possible topics:

* **Roy-Bargmann stepdown analysis** -- see notes below. Needs: a general function,
  diagnostics/printing, and a visualization story (how would HE plots or other displays
  make the stepdown sequence easier to interpret than a table of stepdown F tests?).

* **predict.mlm()** - to give predicted values AND std.errors/CIs for observations in
  an MLM. Some work on this in `dev/pred.mlm.R`, and background notes in
  `issues/AskClaude.md`. Open question: how to *visualize* prediction/confidence
  regions for a new observation in the multivariate case (ellipses again?).

* **Robust extensions** -- `robmlm.R` already implements a robust MLM fit. Could
  Roy-Bargmann and `predict.mlm()` both get robust counterparts? Is there a unifying
  story here ("robust multivariate inference toolkit") that ties the pieces together
  better than three disconnected features?

* **Effect size / model comparison tools** -- `etasq.R` already provides effect sizes
  for MLMs. Are there other standard effect-size or model-comparison measures for MLMs
  missing from the R ecosystem that would round this out?

* **Canonical correlation / canonical discriminant links** -- `heplots` already
  interoperates with `candisc`. Is there a natural extension connecting stepdown
  analysis, prediction, and canonical-space visualization into one coherent "MLM
  analysis workflow" story, rather than a grab-bag of separate functions?

* **Teaching / dissemination materials** -- vignette(s), worked examples, possibly a
  paper (e.g. Journal of Statistical Software) or conference talk (useR!, JSM).
  Funding bodies often expect a dissemination plan alongside the software itself.

* What else? -- there's no `issues/TASKS.md` currently; the closest existing file is
  `issues/AskClaude.md` (has the `predict.mlm()` notes above). Worth deciding whether
  a proper task list should be created, and whether other `issues/*.md` files
  (`family-tags-suggestions.md`, etc.) have relevant candidate topics.

## Open questions for Gavin

* Which of the above topics does do you want to lead with vs. treat as stretch goals?

* Focus on a tightly-scoped single topic (e.g. just Roy-Bargmann) or a broader "toolkit" framing?

* Is this just for OGS now, or do you want something you could also use for NSERC.

* Does your application need explicit innovation framing relative to
  existing tools (`car::Manova()`, base `stats::manova()`, SAS PROC GLM, SPSS
  MANOVA), i.e. what's novel here beyond re-implementing known methods in R?



## Notes on Roy-Bargmann Stepdown Analysis for Manova

In a standard MLM,

```
lm(cbind(y1, y2, y3, ...) ~ x1 + x2 + x3 + ...)
```

Roy & Bargmann () proposed analyzing the collection of response variables sequentially 
in a defined order, where in each model after the first, a response on the left-hand-side becomes a predictor on the right-hand-side,
```
# Source - https://stackoverflow.com/q/79594493
# Posted by user101089
# Retrieved 2026-08-21, License - CC BY-SA 4.0

lm(cbind(y1, y2, y3) ~ x1 + x2 + x3 + ...)
lm(cbind(    y2, y3) ~ x1 + x2 + x3 + y1 + ...)
lm(cbind(        y3) ~ x1 + x2 + x3 + y1, y2 + ...)
```

In an answer to this question, Ben Bolker proposed how the set of these model formulas could be constructed:

```
# Source - https://stackoverflow.com/a/79594565
# Posted by Ben Bolker
# Retrieved 2026-08-21, License - CC BY-SA 4.0

np <- 3; nr <- 5
resp_vars <- paste0("y", 1:np)
pred_vars <- paste0("x", 1:nr)
ffun <- function(i) {
   pp <- sprintf("cbind(%s)", paste(resp_vars[i:np], collapse = ", "))
   rr <- c(pred_vars, resp_vars[seq_len(i-1)])
   ff <- reformulate(rr, resp = pp)
}
(form_list <- lapply(1:np, ffun))
```

### R-B Goals:

* Create a general function, `RoyBargmann()` which would create and fit the collection of such models
from a model formula.

* Visualizations:
  + heplot()
  + is there any role here for an analog of `pvPlot()` -- visualize conditioned relations after each successive `y` is
    "conditioned on" by moving to the RHS of model. Maybe some relation to `car::avPlots()` ?



