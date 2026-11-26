# Repeated-measures hypotheses in heplot(), heplot1d(), heplot3d(): the bug and the fix
# (issues/ggHEplot.md, "Choices it turned up", 3; issues/ggHEplot-review-comparison.md)
#
# Run from the package root:   source("dev/repeated-hypotheses-test.R")
#
# The bug. With idata/iterm, heplot() works in the within-S space: Y %*% P, where P is the
# basis for `iterm` (for Adopted, Age.L, Age.Q, Age.C), and E is the SSPE for that block.
# But hypotheses were tested with linearHypothesis(mod, h), which gives SSPH in the
# *original* responses (Age2IQ, ..., Age13IQ). Then SSPH[variables, variables] took, e.g.,
# the Age2IQ x Age4IQ block and drew it on the Age.L x Age.Q axes, over E.
#
# The fix. Pass P = P[[iterm]] to linearHypothesis(), which tests L B P = 0. For a between-S
# hypothesis L B = 0, that is its interaction with the within-S term: do the predictors in
# L predict the profile over age? Check: the hypothesis "AMED" must then give exactly the
# AMED:Age term ellipse.

suppressMessages(devtools::load_all(".", quiet = TRUE))
library(car)

Adopted.mod <- lm(cbind(Age2IQ, Age4IQ, Age8IQ, Age13IQ) ~ AMED + BMIQ, data = Adopted)
Age <- data.frame(Age = ordered(c(2, 4, 8, 13)))
hyp <- list("Reg" = c("AMED", "BMIQ"))

ok <- function(label, cond) {
  cat(sprintf("%-66s %s\n", label, if (isTRUE(cond)) "PASS" else "FAIL"))
  invisible(isTRUE(cond))
}
maxdiff <- function(a, b) {
  stopifnot(length(a) > 0, length(a) == length(b))      # no vacuous PASS on NULL
  max(abs(unname(a) - unname(b))) }
quiet <- function(expr) { pdf(NULL); on.exit(dev.off()); expr }   # compute without a window

# ---- 1. The two spaces --------------------------------------------------------------------
aov <- Anova(Adopted.mod, idata = Age, idesign = ~Age)
names(aov$P) <- names(aov$SSPE)
P <- aov$P[["Age"]]
cat("Within-S basis P for iterm = 'Age' (columns are the axes of the within-S plot):\n")
print(round(P, 3))
cat("\nSSPH for 'Reg' without P (old code):", paste(rownames(linearHypothesis(Adopted.mod, hyp$Reg)$SSPH), collapse = ", "))
cat("\nSSPH for 'Reg' with P    (fixed)   :", paste(rownames(linearHypothesis(Adopted.mod, hyp$Reg, P = P)$SSPH), collapse = ", "), "\n\n")

# ---- 2. The fixed heplot(): a hypothesis equals the matching term --------------------------
# "AMED" as a hypothesis, in the Age plot, must coincide with the AMED:Age term ellipse
he <- quiet(heplot(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age",
                   hypotheses = list("AMED" = "AMED", "BMIQ" = "BMIQ")))
ok("heplot(): hypothesis 'AMED' == term 'AMED:Age'", maxdiff(he$H$AMED, he$H$`AMED:Age`) < 1e-10)
ok("heplot(): hypothesis 'BMIQ' == term 'BMIQ:Age'", maxdiff(he$H$BMIQ, he$H$`BMIQ:Age`) < 1e-10)
he13 <- quiet(heplot(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age",
                     variables = c(1, 3), hypotheses = list("AMED" = "AMED")))
ok("heplot(), variables = c(1, 3): 'AMED' == 'AMED:Age'", maxdiff(he13$H$AMED, he13$H$`AMED:Age`) < 1e-10)

# ---- 3. heplot1d() and heplot3d(): the same check ------------------------------------------
# heplot1d() also had a separate bug: it called termMeans() for every term, which failed for
# covariates and within-S terms ("AMED not in the model"), so heplot1d(Adopted.mod) failed
# even between-S. It now computes term means itself, only for terms made of factors, in
# the space plotted. See section 4 for old vs new on factor models.
runs <- function(expr) !inherits(tryCatch(quiet(expr), error = function(e) e), "error")
ok("heplot1d(): between-S Adopted (covariates) runs",
   runs(heplot1d(Adopted.mod, hypotheses = hyp)))
h1 <- quiet(heplot1d(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age",
                     hypotheses = list("AMED" = "AMED")))
ok("heplot1d(): hypothesis 'AMED' == term 'AMED:Age'", maxdiff(h1$H$AMED, h1$H$`AMED:Age`) < 1e-10)
# a within-S design with between-S factors: means for treatment:phase are by treatment,
# in the transformed (phase) space
OBK.mod <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5, post.1, post.2, post.3, post.4, post.5,
                    fup.1, fup.2, fup.3, fup.4, fup.5) ~ treatment * gender, data = OBrienKaiser)
OBK.idata <- expand.grid(hour = ordered(1:5), phase = factor(c("pre", "post", "fup"), levels = c("pre", "post", "fup")))
ok("heplot1d(): OBrienKaiser within-S (phase), factor means, runs",
   runs(heplot1d(OBK.mod, idata = OBK.idata, idesign = ~phase * hour, iterm = "phase")))

if (requireNamespace("rgl", quietly = TRUE)) {
  options(rgl.useNULL = TRUE)
  h3 <- heplot3d(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age",
                 hypotheses = list("AMED" = "AMED"))
  rgl::close3d()
  v <- function(m) if (is.list(m) && !is.null(m$vb)) m$vb else m
  ok("heplot3d(): hypothesis 'AMED' == term 'AMED:Age'",
     maxdiff(v(h3$H$AMED), v(h3$H$`AMED:Age`)) < 1e-10)
} else cat("heplot3d(): rgl not installed, skipped\n")

# ---- 4. Old vs new: only within-S hypotheses change ---------------------------------------
# Load the committed (pre-fix) heplot.mlm() from git, in the package namespace
old_src <- tryCatch(system2("git", c("show", "HEAD:R/heplot.R"), stdout = TRUE), error = function(e) NULL)
if (length(old_src)) {
  old_env <- new.env(parent = asNamespace("heplots"))
  eval(parse(text = old_src), envir = old_env)
  heplot_old <- old_env$heplot.mlm
  same <- function(a, b) maxdiff(unlist(a$H), unlist(b$H)) < 1e-10 && maxdiff(a$E, b$E) < 1e-10

  # between-S: P is NULL, results must be identical
  ok("between-S Adopted, hypothesis 'Reg': old == new",
     same(quiet(heplot_old(Adopted.mod, hypotheses = hyp)), quiet(heplot(Adopted.mod, hypotheses = hyp))))
  iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data = iris)
  ih <- list("V:V" = "Speciesversicolor - Speciesvirginica")
  ok("iris, hypothesis: old == new",
     same(quiet(heplot_old(iris.mod, hypotheses = ih)), quiet(heplot(iris.mod, hypotheses = ih))))
  # within-S, no hypotheses: identical
  ok("within-S Adopted, terms only: old == new",
     same(quiet(heplot_old(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age")),
          quiet(heplot(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age"))))
  # within-S with a hypothesis: terms and E identical, the hypothesis differs
  o <- quiet(heplot_old(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age", hypotheses = hyp))
  n <- quiet(heplot(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age", hypotheses = hyp))
  terms <- c("Age", "AMED:Age", "BMIQ:Age")
  stopifnot(identical(names(n$H), c(terms, "Reg")))
  ok("within-S Adopted + 'Reg': terms and E unchanged",
     maxdiff(o$E, n$E) < 1e-10 && maxdiff(unlist(o$H[terms]), unlist(n$H[terms])) < 1e-10)
  ok("within-S Adopted + 'Reg': 'Reg' changes (the fix)", maxdiff(o$H$Reg, n$H$Reg) > 1)
  cat(sprintf("%-66s %.1f\n", "  max |old - new| for 'Reg'", maxdiff(o$H$Reg, n$H$Reg)))

  # heplot1d(), factor models: same ellipses, limits and plotted means as the old version
  eval(parse(text = system2("git", c("show", "HEAD:R/heplot1d.R"), stdout = TRUE)), envir = old_env)
  heplot1d_old <- old_env$heplot1d.mlm
  # record what points() draws, to compare the factor means
  drawn <- function(f, ...) {
    pts <- list()
    tr <- function(x, y, ...) pts[[length(pts) + 1]] <<- unname(x)
    environment(f) <- list2env(list(points = tr), parent = environment(f))
    r <- quiet(f(...))
    list(r = r, pts = pts)
  }
  same1d <- function(a, b) maxdiff(unlist(a$r$H), unlist(b$r$H)) < 1e-10 &&
    maxdiff(a$r$E, b$r$E) < 1e-10 && maxdiff(a$r$xlim, b$r$xlim) < 1e-10 &&
    maxdiff(unlist(a$pts), unlist(b$pts)) < 1e-10
  ok("heplot1d(), iris ~ Species: old == new (H, E, xlim, means)",
     same1d(drawn(heplot1d_old, iris.mod, variables = 3), drawn(heplots:::heplot1d.mlm, iris.mod, variables = 3)))
  Plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate * additive, data = Plastic)
  # for interactions, the old xlim (from marginal means) left some cell means outside the plot
  po <- drawn(heplot1d_old, Plastic.mod); pn <- drawn(heplots:::heplot1d.mlm, Plastic.mod)
  ok("heplot1d(), Plastic ~ rate * additive: old == new (H, E, means)",
     maxdiff(unlist(po$r$H), unlist(pn$r$H)) < 1e-10 && maxdiff(po$r$E, pn$r$E) < 1e-10 &&
       maxdiff(unlist(po$pts), unlist(pn$pts)) < 1e-10)
  cell <- range(po$pts[[4]])                 # rate:additive cell means
  cat(sprintf("  rate:additive means %.2f to %.2f; xlim old %.2f to %.2f, new %.2f to %.2f\n",
              cell[1], cell[2], po$r$xlim[1], po$r$xlim[2], pn$r$xlim[1], pn$r$xlim[2]))
  ok("heplot1d(), Plastic: new xlim contains all cell means",
     pn$r$xlim[1] <= cell[1] && pn$r$xlim[2] >= cell[2])

  # heplot1d() hypothesis labels: were indexed by term number, so drew "NA" after any term
  labels_drawn <- function(f, ...) {
    labs <- character()
    tx <- function(x, y, labels, ...) labs <<- c(labs, as.character(labels))
    environment(f) <- list2env(list(text = tx), parent = environment(f))
    quiet(f(...))
    labs
  }
  lo <- labels_drawn(heplot1d_old, iris.mod, variables = 3, hypotheses = ih)
  ln <- labels_drawn(heplots:::heplot1d.mlm, iris.mod, variables = 3, hypotheses = ih)
  cat("  labels drawn, old:", paste(lo, collapse = ", "), "\n  labels drawn, new:", paste(ln, collapse = ", "), "\n")
  ok("heplot1d(): hypothesis label is 'V:V' (was NA)", tail(ln, 1) == "V:V")

  # ---- 5. Picture: the old and the fixed 'Reg' in the within-S plot -----------------------
  # same axis limits in both panels. After the fix, Reg (AMED and BMIQ jointly) spans the
  # two 1-df term lines AMED:Age and BMIQ:Age, as their joint test should
  pts <- rbind(do.call(rbind, o$H), do.call(rbind, n$H), o$E)
  lims <- list(xlim = range(pts[, 1]), ylim = range(pts[, 2]))
  op <- par(mfrow = c(1, 2), mar = c(4, 4, 3, 1) + 0.1)
  do.call(heplot_old, c(list(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age",
          hypotheses = hyp,
          main = "Before: 'Reg' from Age2IQ x Age4IQ"), lims))
  do.call(heplot, c(list(Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age",
          hypotheses = hyp,
          main = "After: 'Reg' in Age.L x Age.Q"), lims))
  par(op)
} else cat("git not found from R: old-vs-new comparison skipped\n")
