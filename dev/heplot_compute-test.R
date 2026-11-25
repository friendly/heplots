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
# expected to differ for "Reg": heplot() does not transform the hypothesis by P[[iterm]]
r <- compare("Adopted, within-S, hypothesis 'Reg'", Adopted.mod, idata = Age, idesign = ~Age,
             iterm = "Age", hypotheses = list("Reg" = c("AMED", "BMIQ")))

# --- symbolic object ---------------------------------------------------------------
hc <- heplot_compute(iris.mod, hypotheses = hyp)
print(hc)

# rank of the same term in the full space vs. in a 2D view
cat("\nRank-2 term `Species`, full space:", hc$ellipses$Species$rank, "\n")
pts <- as.data.frame(hc, variables = c("Sepal.Length", "Sepal.Width"))
print(unique(pts[, c("ellipse", "type", "rank")]))
