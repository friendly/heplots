# Check dev/heplot_compute.R against the coordinates returned by heplot()
# Run with the package loaded via devtools::load_all()

devtools::load_all(".", quiet = TRUE)
source("dev/heplot_compute.R")
library(car)

# compare heplot() result with as.data.frame(heplot_compute()) for the same args
compare <- function(label, mod, ..., variables = 1:2) {
  pdf(NULL); on.exit(dev.off())
  old <- heplot(mod, ..., variables = variables)
  hc  <- heplot_compute(mod, ...)
  pts <- as.data.frame(hc, variables = variables)
  new_H <- lapply(split(pts[pts$type == "H", c("x", "y")],
                        factor(pts$ellipse[pts$type == "H"], levels = names(hc$ellipses))),
                  as.matrix)
  new_H <- new_H[vapply(new_H, nrow, 0) > 0]
  new_E <- as.matrix(pts[pts$type == "E", c("x", "y")])
  diff_H <- unlist(Map(function(a, b) max(abs(unname(a) - unname(b))), old$H, new_H))
  diff_E <- max(abs(unname(old$E) - unname(new_E)))
  diff_c <- max(abs(unname(old$center) - unname(hc$center[variables])))
  H_txt <- paste(names(old$H), signif(diff_H, 2), sep = "=", collapse = "  ")
  cat(format(label, width = 38),
      glue::glue("max|diff|: E {signif(diff_E, 2)}, center {signif(diff_c, 2)}, H: {H_txt}"), "\n")
  invisible(list(old = old, hc = hc, pts = pts))
}

# --- MANOVA, with hypotheses --------------------------------------------------------
data(iris)
contrasts(iris$Species) <- matrix(c(0,-1,1, 2, -1, -1), 3,2)
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)
hyp <- list("V:V"="Species1","S:VV"="Species2")
compare("iris, hypotheses", iris.mod, hypotheses = hyp)
compare("iris, variables = Petal (by name)", iris.mod, hypotheses = hyp,
        variables = c("Petal.Length", "Petal.Width"))
compare("iris, variables = c(4, 1)", iris.mod, variables = c(4, 1))
compare("iris, size = effect", iris.mod, hypotheses = hyp, size = "effect")

data(Parenting)
parenting.mod <- lm(cbind(caring, emotion, play) ~ group, data=Parenting)
compare("Parenting", parenting.mod, hypotheses = list("N:MP" = "group1", "M:P" = "group2"))

data(AddHealth)
AH.mlm <- lm(cbind(anxiety, depression) ~ grade, data = AddHealth)
compare("AddHealth, character hypotheses", AH.mlm, hypotheses = c("grade.L", "grade.Q"))

# --- MMRA / ANCOVA ---------------------------------------------------------------
data(Rohwer)
rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data=Rohwer)
compare("Rohwer, all terms", rohwer.mod)
compare("Rohwer, SAT x Raven", rohwer.mod, variables = c("SAT", "Raven"))
compare("Rohwer, hypothesis 'Regr'", rohwer.mod, hypotheses = list("Regr" = c("n", "s", "ns", "na", "ss")))

# --- repeated measures ------------------------------------------------------------
data(RatWeight)
rat.mod <- lm(cbind(wt0, wt1, wt2, wt3, wt4) ~ trt, data=RatWeight)
idata <- data.frame(week = ordered(0:4))
compare("RatWeight, within-S (week)", rat.mod, idata = idata, idesign = ~week, iterm = "week")

data(Adopted)
Adopted.mod <- lm(cbind(Age2IQ, Age4IQ, Age8IQ, Age13IQ) ~ AMED + BMIQ, data=Adopted)
Age <- data.frame(Age=ordered(c(2,4,8,13)))
compare("Adopted, within-S, no hypotheses", Adopted.mod, idata = Age, idesign = ~Age, iterm = "Age")
# "Reg" differed (max 19) until heplot() was fixed to transform hypotheses by P[[iterm]]
# (commit 56cf2760); now it matches
r <- compare("Adopted, within-S, hypothesis 'Reg'", Adopted.mod, idata = Age, idesign = ~Age,
             iterm = "Age", hypotheses = list("Reg" = c("AMED", "BMIQ")))

# --- symbolic object ---------------------------------------------------------------
hc <- heplot_compute(iris.mod, hypotheses = hyp)
print(hc)

# rank of the same term in the full space vs. in a 2D view
cat("\nRank-2 term `Species`, full space:", hc$ellipses$Species$rank, "\n")
pts <- as.data.frame(hc, variables = c("Sepal.Length", "Sepal.Width"))
print(unique(pts[, c("ellipse", "type", "rank")]))

# --- raw SSP, scaled on demand (decision 2) ----------------------------------------
cat("\nRaw SSP stored, rescaled without refitting:\n")
check <- function(label, cond) cat(format(label, width = 60), if (isTRUE(cond)) "PASS" else "FAIL", "\n")
aov <- car::Anova(iris.mod)
check("SSP for Species is the raw Anova() SSP",
      isTRUE(all.equal(unname(hc$ellipses$Species$SSP), unname(aov$SSP$Species))))
check("SSP for Error is the raw SSPE",
      isTRUE(all.equal(unname(hc$ellipses$Error$SSP), unname(aov$SSPE))))
check("he_shape(Error) == SSPE / dfe",
      isTRUE(all.equal(he_shape(hc, "Error"), hc$ellipses$Error$SSP / hc$dfe)))

# switching size / alpha on a saved object == refitting with them == heplot()
same_pts <- function(a, b) max(abs(a$x - b$x), abs(a$y - b$y)) < 1e-10
check("as.data.frame(size = 'effect') == heplot_compute(size = 'effect')",
      same_pts(as.data.frame(hc, size = "effect"),
               as.data.frame(heplot_compute(iris.mod, hypotheses = hyp, size = "effect"))))
check("as.data.frame(alpha = 0.01) == heplot_compute(alpha = 0.01)",
      same_pts(as.data.frame(hc, alpha = 0.01),
               as.data.frame(heplot_compute(iris.mod, hypotheses = hyp, alpha = 0.01))))
pdf(NULL)
old01 <- heplot(iris.mod, hypotheses = hyp, alpha = 0.01)
dev.off()
new01 <- as.data.frame(hc, alpha = 0.01)
check("as.data.frame(alpha = 0.01) == heplot(alpha = 0.01), Species",
      max(abs(unname(old01$H$Species) - as.matrix(new01[new01$ellipse == "Species", c("x", "y")]))) < 1e-10)
