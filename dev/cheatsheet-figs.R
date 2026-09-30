# Generate thumbnail images for the heplots cheatsheet (see dev/cheatsheet.md)
# Output: dev/cheatsheet/fig/*.png
#
# Run from the package root:  source("dev/cheatsheet-figs.R")
# Page 1 uses iris (plus Rohwer for MMRA, Plastic for 3D); page 2 uses peng.

# TODO: 🚩 Fine-tune sizes / cex once the cheatsheet layout (PowerPoint or Quarto) is fixed
# TODO: 🚩 A1 key diagram: annotated version (arrows/labels) done in the layout tool, or here?

library(heplots)
library(car)
library(candisc)

figdir <- here::here("dev", "cheatsheet", "fig")
dir.create(figdir, recursive = TRUE, showWarnings = FALSE)

# thumbnail helper: square PNG, small margins, no axis tick labels
thumb <- function(name, expr, size = 1.6, pointsize = 7, mar = c(1, 1, 1, 1),
                  axes = FALSE) {
  file <- file.path(figdir, paste0(name, ".png"))
  png(file, width = size, height = size, units = "in", res = 300,
      pointsize = pointsize)
  op <- par(mar = mar, mgp = c(1.2, 0.3, 0), tcl = -0.2)
  if (!axes) par(xaxt = "n", yaxt = "n")
  on.exit({ par(op); dev.off() })
  force(expr)
  message(glue::glue("wrote {basename(file)}"))
  invisible(file)
}

# ---- Models ---------------------------------------------------------------
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species,
               data = iris)
rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data = Rohwer)
peng.mod <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species,
               data = peng)
iris.col <- c("red", "blue", "darkgreen", "brown")

# ---- PAGE 1 ---------------------------------------------------------------

# A1: key diagram strip — data ellipses -> HE plot
thumb("A1a-data-ellipses",
  covEllipses(iris[, 1:2], iris$Species, fill = TRUE, pooled = FALSE,
              col = iris.col[-1], xlab = "", ylab = "", cex.lab = 0.1))
thumb("A1b-heplot",
  heplot(iris.mod, fill = TRUE, fill.alpha = 0.1, xlab = "", ylab = "",
         cex = 1.2, label.pos = c("S", "N")))

# B: HE plot family
thumb("B1-heplot",
  heplot(iris.mod, fill = TRUE, fill.alpha = 0.1, xlab = "", ylab = "", cex = 1.2))
thumb("B2-heplot-effect",
  heplot(iris.mod, size = "effect", fill = TRUE, fill.alpha = 0.1,
         xlab = "", ylab = "", cex = 1.2))
thumb("B3-pairs",
  pairs(iris.mod, variables = 1:3, fill = TRUE, fill.alpha = 0.1, var.cex = 1.1),
  mar = c(0.5, 0.5, 0.5, 0.5))
thumb("B5-heplot1d",
  heplot1d(iris.mod, variables = 3, xlab = "", main = ""),
  mar = c(1, 1, 1, 1))
iris.can <- candisc(iris.mod)
thumb("B6-candisc",
  heplot(iris.can, cex = 1.2, var.cex = 0.9, var.col = "black", var.lwd = 1,
         fill = TRUE, fill.alpha = 0.1, prefix = ""))
# B4: 3D — static snapshot from the vignette
file.copy(here::here("vignettes", "images", "plastic-HE3D.png"),
          file.path(figdir, "B4-heplot3d.png"), overwrite = TRUE)

# C: linear hypotheses
hyp <- list("S:VV"  = "Speciesversicolor + Speciesvirginica = 0",
            "Vc:Vg" = "Speciesversicolor = Speciesvirginica")
thumb("C1-hypotheses",
  heplot(iris.mod, hypotheses = hyp, fill = TRUE, fill.alpha = 0.1,
         xlab = "", ylab = "", cex = 1.1,
         col = c("red", "blue", "darkgreen", "purple")))
thumb("C2-mmra",
  heplot(rohwer.mod, hypotheses = list("Regr" = c("n", "s", "ns", "na", "ss")),
         fill = TRUE, fill.alpha = 0.1, xlab = "", ylab = "", cex = 1.1,
         col = c("red", "black", "blue", "brown", "gray40", "darkgreen", "magenta", "orange")))

# D1: label.pos diagram
thumb("D1-label-pos", {
  ell <- car::ellipse(c(0, 0), shape = matrix(c(1, 0.5, 0.5, 1), 2, 2), radius = 2,
                      draw = FALSE)
  plot(ell, type = "l", asp = 1, xlab = "", ylab = "", lwd = 1.5,
       xlim = c(-2.8, 2.8), ylim = c(-2.8, 2.8))
  for (pos in c("C", "N", "S", "E", "W", "NE", "SE", "SW", "NW"))
    label.ellipse(ell, pos, label.pos = pos, col = "blue", cex = 1.1)
})

# E: coefficients
thumb("E1-coefplot",
  coefplot(lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data = Rohwer),
           fill = TRUE, lwd = 1.5, level = 0.68, main = "", xlab = "", ylab = "",
           cex = 1.1))

# ---- PAGE 2 ---------------------------------------------------------------

# F: homogeneity of covariance
thumb("F1-covEllipses",
  covEllipses(peng[, 3:4], peng$species, fill = TRUE, pooled = TRUE,
              xlab = "", ylab = "", cex = 1.1, center = TRUE))
thumb("F2-covEllipses-matrix",
  covEllipses(peng[, 3:6], peng$species, variables = 1:3, fill = TRUE, labels = "",
              var.cex = 1),
  mar = c(0.5, 0.5, 0.5, 0.5))
peng.boxm <- boxM(peng.mod)
thumb("F3-boxM",
  plot(peng.boxm, gplabel = ""),
  mar = c(2.2, 4.5, 0.5, 0.5), axes = TRUE)
thumb("F4-boxM-boot",
  plot_boxM_boot(peng.boxm, Y = peng[, 3:6], group = peng$species,
                 which = "sum", boot.R = 500, boot.seed = 42, gplabel = ""),
  mar = c(2.2, 4.5, 0.5, 0.5), axes = TRUE)

# G: normality, outliers, robust
thumb("G1-cqplot",
  cqplot(peng.mod, main = "", xlab = "", ylab = "", id.n = 3))
thumb("G2-distancePlot",
  distancePlot(peng.mod, main = ""),
  mar = c(2.5, 2.5, 0.5, 0.5), axes = TRUE)
peng.rob <- robmlm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species,
                   data = peng)
thumb("G3-robmlm-weights",
  plot(peng.rob, main = "", xlab = "", ylab = ""))
thumb("G4-robust-heplot", {
  heplot(peng.rob, fill = TRUE, fill.alpha = 0.1, xlab = "", ylab = "", cex = 1.1)
  heplot(peng.mod, add = TRUE, lty = 2, lwd = 1, term.labels = FALSE,
         error.ellipse = TRUE)
})

# I: other plots
thumb("I1-interpPlot", {
  # data (centered) -> within-group residuals, for a subsample
  set.seed(1)
  sub <- sample(nrow(peng), 60)
  xy1 <- scale(peng[, 3:4], scale = FALSE)[sub, ]
  xy2 <- residuals(peng.mod)[sub, 1:2]
  spcol <- c("red", "darkgreen", "blue")[peng$species[sub]]
  interpPlot(xy1, xy2, alpha = 1, xlab = "", ylab = "", col = spcol, pch = 16,
             cex = 0.6, segments = TRUE, segment.col = "gray60",
             xlim = range(xy1[, 1]), ylim = range(xy1[, 2]))
  points(xy1, col = spcol, pch = 1, cex = 0.6)
})
thumb("I2-pvPlot",
  pvPlot(as.data.frame(peng[, 3:6]), vars = c("bill_length", "bill_depth"), labels = FALSE,
         cex = 0.5))

# hex logo, for the banner
file.copy(here::here("man", "figures", "logo.png"), file.path(figdir, "logo.png"),
          overwrite = TRUE)
