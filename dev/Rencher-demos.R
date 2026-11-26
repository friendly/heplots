# Sample analyses and HE plots for three rencher datasets (see dev/Rencher-datasets.md)
#   1. table6.18  Snap beans: two-way MANOVA, sowing date x variety
#   2. table5.7   Muscular dystrophy carriers: MANCOVA, skewed responses, robust fit
#   3. table6.28  Plasma inorganic phosphate: repeated measures, unequal time spacing
#
# Run from the package root:   source("dev/Rencher-demos.R")
# Each section first fixes the data: tibble -> data.frame, numeric group codes -> factors,
# generic y1, y2, ... -> names from Rencher & Christensen (2012), not from the rencher help
# pages. Problem numbers refer to the book.
#
# DONE: ✔️ table6.18: variable names from Problem 6.28 (the book gives no sowing dates) 11/25/2026
# DONE: ✔️ table5.7: names from Problem 5.19; the book lists y5 = LD, y6 = PK, but the
#       values fit PK, LD (see dev/Rencher-datasets.md), so PK, LD are used here 11/25/2026
# TODO: 🚩 table5.7: confirm the PK / LD order in Andrews & Herzberg (1985), pp. 223-228

library(heplots)
library(car)
library(candisc)

ld <- function(name) {                       # a rencher dataset, as a plain data.frame
  e <- new.env()
  data(list = name, package = "rencher", envir = e)
  as.data.frame(e[[name]])
}

# ==========================================================================================
# 1. table6.18: Snap beans, 4 sowing dates x 3 varieties, 5 plots per cell
# ==========================================================================================
# Problem 6.28 (Keuls et al. 1984): y1 = yield earliness, y2 = specific leaf area (SLA)
# earliness, y3 = total yield, y4 = average SLA
beans <- ld("table6.18")
names(beans)[4:7] <- c("yieldEarly", "SLAEarly", "yield", "SLA")
beans <- within(beans, {
  S  <- ordered(S, labels = paste0("S", 1:4))   # sowing date: ordered -> polynomial contrasts
  V  <- factor(V,  labels = paste0("V", 1:3))   # variety
  ID <- NULL                                    # plot number within cell
})
str(beans)
with(beans, table(S, V))                        # balanced: 5 per cell

# Contrasts for variety, as the book asks: V2 vs V1 and V3 ("in previous experiments, the
# second variety gave higher yields"), and V1 vs V3
contrasts(beans$V) <- cbind("2vs13" = c(-1, 2, -1), "1vs3" = c(1, 0, -1))

beans.mod <- lm(cbind(yieldEarly, SLAEarly, yield, SLA) ~ S * V, data = beans)
Anova(beans.mod)                                # S, V and S:V all highly significant

# HE plot: three effects of different rank. S (3 df) is almost one-dimensional
# (96% of its eigenvalues on the first dimension); S:V is not.
heplot(beans.mod, variables = c("yield", "SLA"), fill = TRUE, fill.alpha = 0.1,
       main = "Snap beans: sowing date x variety")

# Polynomial contrasts for sowing date (the book: linear, quadratic, cubic; "interpretation
# of these for mean vectors is not as straightforward as for univariate means")
hyp <- list("S linear" = "S.L", "S quad" = "S.Q", "S cubic" = "S.C")
heplot(beans.mod, terms = "S", hypotheses = hyp, variables = c("yield", "SLA"),
       main = "Sowing date: polynomial components")
for (h in hyp) print(linearHypothesis(beans.mod, h), SSP = FALSE)

# Variety: V2 vs V1 and V3
heplot(beans.mod, terms = "V", hypotheses = list("V2 vs V1,V3" = "V2vs13"),
       variables = c("yield", "SLA"), main = "Variety 2 vs varieties 1 and 3")
linearHypothesis(beans.mod, "V2vs13") |> print(SSP = FALSE)
# Pillai 0.92, but V2 has the *lowest* total yield here (mean about 40.9 vs about 41.7),
# the opposite of the book's "in previous experiments, the second variety gave higher yields"
aggregate(cbind(yield, SLA) ~ V, data = beans, FUN = mean)

pairs(beans.mod, fill = TRUE, fill.alpha = 0.1)

# Canonical views: for S, one dimension does nearly all the work; for the
# interaction, the structure needs two
beans.canS <- candisc(beans.mod, term = "S")
beans.canS
plot(beans.canS, main = "Canonical view of sowing date (S)")
beans.canSV <- candisc(beans.mod, term = "S:V")
beans.canSV
# factor.means = FALSE: heplot.candisc() otherwise looks for a factor named "S:V" and
# stops ("S:V not among factors"); a candisc issue for interaction terms
heplot(beans.canSV, factor.means = FALSE, main = "Canonical HE plot for S:V")

# ==========================================================================================
# 2. table5.7: Carriers vs noncarriers of Duchenne muscular dystrophy
# ==========================================================================================
# The help page calls y1-y6 "biomarkers". Problem 5.19: y1 age, y2 month in which
#   measurements are taken, y3 creatine kinase (CK), y4 hemopexin (H), then y5, y6 listed as
#   lactate dehydrogenase (LD), pyruvate kinase (PK). The values (y5 3.5-110, y6 87-412) and
#   the original data's order say y5 = PK, y6 = LD, which is used here.
#   Hemopexin is named Hpx here, so it isn't confused with the H matrix.
dmd <- ld("table5.7")
names(dmd) <- c("group", "age", "month", "CK", "Hpx", "PK", "LD")
dmd$group <- factor(dmd$group, levels = c("Noncarriers", "Carriers"))
str(dmd)
table(dmd$group)

# The enzymes are skewed with large outliers (CK up to 657): compare raw and log scales
op <- par(mfrow = c(1, 2))
cqplot(dmd[, c("CK", "Hpx", "PK", "LD")], main = "Raw enzymes")
dmd <- within(dmd, { logCK <- log(CK); logPK <- log(PK); logLD <- log(LD) })
cqplot(dmd[, c("logCK", "Hpx", "logPK", "logLD")], main = "CK, PK, LD logged")
par(op)

# Age and month are covariates, not responses: MANCOVA. Each term has 1 df, so each H
# ellipse is a line, showing the direction in which that term moves the enzymes.
dmd.mod <- lm(cbind(logCK, Hpx, logPK, logLD) ~ group + age + month, data = dmd)
Anova(dmd.mod)

heplot(dmd.mod, variables = c("logCK", "logPK"), fill = TRUE, fill.alpha = 0.1,
       main = "Carrier status, adjusting for age and month")
pairs(dmd.mod, fill = TRUE, fill.alpha = 0.1)

# Problem 5.19(b): CK and H are cheap to measure, PK and LD expensive. Do PK and LD add to
# the separation of the groups beyond CK and H? Equivalently: with CK and H as covariates,
# is there still a group effect on PK and LD?
dmd.mod2 <- lm(cbind(logPK, logLD) ~ group + logCK + Hpx + age + month, data = dmd)
Anova(dmd.mod2)
heplot(dmd.mod2, fill = TRUE, fill.alpha = 0.1,
       main = "PK and LD, adjusting for CK, H, age and month")
# Yes: group Pillai 0.19, p = .001; the group ellipse still extends beyond E. (The means
# drawn are the unadjusted group means.)

# Robust fit: does down-weighting the outliers change the picture?
dmd.rob <- robmlm(cbind(logCK, Hpx, logPK, logLD) ~ group + age + month, data = dmd)
Anova(dmd.rob)
plot(dmd.rob, main = "Weights from robmlm()")         # which cases were down-weighted
heplot(dmd.mod, variables = c("logCK", "logPK"), lty = 2, fill = FALSE,
       main = "Classical (dashed) vs robust (solid) fit")
heplot(dmd.rob, variables = c("logCK", "logPK"), add = TRUE, lwd = 2, fill = FALSE)

# The 1-df group effect in canonical space is a single discriminant axis
dmd.can <- candisc(dmd.mod, term = "group")
dmd.can                                      # structure coefficients: which enzymes separate
plot(dmd.can)                                # 1 dimension: boxplots of Can1 + structure

# ==========================================================================================
# 3. table6.28: Plasma inorganic phosphate after a glucose challenge, control vs obese
# ==========================================================================================
# Measured at 0, 0.5, 1, 1.5, 2, 3, 4, 5 hours: unequal spacing. The help page lists the
# columns as M_1 ... M_60, but the data have H_0 ... H_5.
phos <- ld("table6.28")
phos$Group <- factor(phos$Group)
hours <- c(0, 0.5, 1, 1.5, 2, 3, 4, 5)
resp <- paste0("H_", c(0, 0.5, 1, 1.5, 2, 3, 4, 5))
stopifnot(identical(names(phos)[3:10], resp))
table(phos$Group)

# Mean profiles: controls dip deeply and early (4.09 -> 2.63 at 1.5 h), the obese group
# less and later (4.53 -> 3.19 at 2 h)
means <- aggregate(phos[, resp], list(Group = phos$Group), mean)
matplot(hours, t(means[, resp]), type = "b", pch = 16, lty = 1, col = c("blue", "red"),
        xlab = "Hours after glucose challenge", ylab = "Mean plasma phosphate (mg/dl)",
        main = "Mean profiles")
legend("top", legend = means$Group, col = c("blue", "red"), lty = 1, pch = 16, bty = "n")

# Within-S design: orthogonal polynomials in the *actual* hours, not 1:8
idata <- data.frame(hour = ordered(hours))
contrasts(idata$hour) <- contr.poly(8, scores = hours)

phos.mod <- lm(as.matrix(phos[, resp]) ~ Group, data = phos)
phos.aov <- Anova(phos.mod, idata = idata, idesign = ~hour)
phos.aov                                     # hour and Group:hour highly significant
summary(phos.aov, multivariate = FALSE)      # univariate tests, with GG/HF corrections

# Which polynomial components differ between the groups? Univariate tests on each:
Yp <- as.matrix(phos[, resp]) %*% contrasts(idata$hour)
round(sapply(colnames(Yp), \(j) anova(lm(Yp[, j] ~ Group, data = phos))[1, "Pr(>F)"]), 4)
# linear p = .002, quadratic p = .999, cubic p = .0005, quartic p = .0004:
# both profiles are equally U-shaped (no difference in the quadratic); they differ in
# *where* and how sharply they dip, which is carried by the odd and higher components.

# Within-S HE plots in the space of the hour contrasts. In the linear x quadratic view the
# groups differ only along hour.L, and Group:hour stays inside E: this view misses most
# of the interaction.
heplot(phos.mod, idata = idata, idesign = ~hour, iterm = "hour",
       variables = c("hour.L", "hour.Q"), fill = TRUE, fill.alpha = 0.1,
       main = "Phosphate: linear vs quadratic")
# The linear x cubic view does better: Group:hour runs diagonally, at an angle to the hour
# effect, and reaches the edge of E. No 2-D view shows it far outside E, because the
# interaction is spread over three components (L, C, ^4); the pairs plot shows them all.
heplot(phos.mod, idata = idata, idesign = ~hour, iterm = "hour",
       variables = c("hour.L", "hour.C"), fill = TRUE, fill.alpha = 0.1,
       main = "Phosphate: linear vs cubic")

# All pairs of the first four polynomial components
pairs(phos.mod, idata = idata, idesign = ~hour, iterm = "hour", variables = 1:4,
      fill = TRUE, fill.alpha = 0.1)
