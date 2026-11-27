# Build script for three datasets from Rencher & Christensen (2012), Methods of Multivariate
# Analysis, 3rd ed., taken from the rencher package (v0.1.7), where they are named only by
# table number. See dev/Rencher-datasets.md for the survey of all 48 rencher datasets and
# dev/Rencher-demos.R for the analyses these were chosen from.
#
#   SnapBeans   <- table6.18  two-way MANOVA, sowing date x variety (Keuls et al. 1984)
#   Dystrophy   <- table5.7   carriers vs noncarriers of muscular dystrophy (Andrews & Herzberg 1985)
#   Phosphate   <- table6.28  plasma phosphate, control vs obese, 8 times (Zerbe 1979a)
#   Ramus       <- table3.7   ramus bone height of 20 boys at 4 ages (Elston & Grizzle 1962)
#
# For each: tibble -> data.frame, numeric codes -> factors, generic y1, y2, ... -> names from
# the book (the rencher help pages are often generic or wrong), and contrasts for the factors.
# Problem numbers refer to the book.
#
# DONE: ✔️ Created from dev/Rencher-demos.R 11/26/2026
# DONE: ✔️ Added Ramus (table3.7) 11/27/2026
# TODO: 🚩 Dystrophy: confirm the PK / LD order in Andrews & Herzberg (1985), pp. 223-228

# Run from the package root: source("data-raw/Rencher-import.R")

rencher_data <- function(name) {               # a rencher dataset, as a plain data.frame
  e <- new.env()
  data(list = name, package = "rencher", envir = e)
  as.data.frame(e[[name]])
}

# ------------------------------------------------------------------------------------------
# SnapBeans: table6.18, 4 sowing dates x 3 varieties x 5 plots
# ------------------------------------------------------------------------------------------
# Problem 6.28: y1 = yield earliness, y2 = specific leaf area (SLA) earliness,
# y3 = total yield, y4 = average SLA. The book does not give the actual sowing dates.
beans <- rencher_data("table6.18")
stopifnot(identical(names(beans), c("S", "V", "ID", "y1", "y2", "y3", "y4")))

SnapBeans <- data.frame(
  sowing     = ordered(beans$S, labels = paste0("S", 1:4)),
  variety    = factor(beans$V, labels = paste0("V", 1:3)),
  yieldEarly = beans$y1,
  SLAEarly   = beans$y2,
  yield      = beans$y3,
  SLA        = beans$y4
)
# sowing is ordered, so it gets contr.poly(): linear, quadratic and cubic trends (6.28(c)).
# variety: variety 2 vs varieties 1 and 3, as Problem 6.28(b) asks, and 1 vs 3
contrasts(SnapBeans$variety) <- cbind("2vs13" = c(-1, 2, -1), "1vs3" = c(1, 0, -1))
stopifnot(all(table(SnapBeans$sowing, SnapBeans$variety) == 5))

# ------------------------------------------------------------------------------------------
# Dystrophy: table5.7, 39 noncarriers and 34 carriers
# ------------------------------------------------------------------------------------------
# Problem 5.19: y1 age, y2 month in which measurements are taken, y3 creatine kinase (CK),
# y4 hemopexin, y5 lactate dehydrogenase (LD), y6 pyruvate kinase (PK).
# The values say y5 and y6 are the other way round: y5 runs 3.5-110 and y6 87-412, and the
# original data (Andrews & Herzberg; StatLib "biomed") have the order CK, H, PK, LD.
# So here y5 = PK and y6 = LD. Hemopexin is `Hpx`, so it isn't confused with an H matrix.
dmd <- rencher_data("table5.7")
stopifnot(identical(names(dmd), c("Group", paste0("y", 1:6))))

Dystrophy <- data.frame(
  group = factor(dmd$Group, levels = c("Noncarriers", "Carriers")),
  age   = dmd$y1,
  month = dmd$y2,
  CK    = dmd$y3,
  Hpx   = dmd$y4,
  PK    = dmd$y5,
  LD    = dmd$y6
)
stopifnot(!anyNA(Dystrophy$group))

# ------------------------------------------------------------------------------------------
# Phosphate: table6.28, 13 control and 20 obese patients, 8 times after a glucose challenge
# ------------------------------------------------------------------------------------------
# Times are 0, 0.5, 1, 1.5, 2, 3, 4, 5 hours (unequally spaced). The rencher help page
# lists the columns as M_1 ... M_60 (minutes); the data have H_0 ... H_5 (hours).
# `Patient` numbers patients within each group and is dropped.
phos <- rencher_data("table6.28")
hours <- c(0, 0.5, 1, 1.5, 2, 3, 4, 5)
stopifnot(identical(names(phos), c("Patient", "Group", paste0("H_", hours))))

Phosphate <- data.frame(group = factor(phos$Group, levels = c("Control", "Obese")),
                        phos[, paste0("H_", hours)])
names(Phosphate)[-1] <- paste0("hr", hours)
stopifnot(!anyNA(Phosphate$group))

# ------------------------------------------------------------------------------------------
# Ramus: table3.7, ramus bone height (mm) of 20 boys at 8, 8.5, 9 and 9.5 years
# ------------------------------------------------------------------------------------------
# Checked against the printed Table 3.7: all 80 values agree. `Individual` (1:20) is dropped;
# the row names are the same numbers.
ramus <- rencher_data("table3.7")
stopifnot(identical(names(ramus), c("Individual", paste0("y", 1:4))),
          identical(ramus$Individual, as.numeric(1:20)))
Ramus <- ramus[, paste0("y", 1:4)]
names(Ramus) <- c("Age8", "Age8.5", "Age9", "Age9.5")

# ------------------------------------------------------------------------------------------
usethis::use_data(SnapBeans, Dystrophy, Phosphate, Ramus, overwrite = TRUE)
