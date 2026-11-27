# Datasets from Rencher & Christensen (2012), via the rencher package.
# Built by data-raw/Rencher-import.R; see dev/Rencher-datasets.md for the survey of the
# rencher datasets, and dev/Rencher-demos.R for the fuller analyses.
#
# DONE: ✔️ Added SnapBeans, Dystrophy, Phosphate 11/26/2026
# DONE: ✔️ Added Ramus 11/27/2026
# TODO: 🚩 Dystrophy: confirm the PK / LD order in Andrews & Herzberg (1985), pp. 223-228
# TODO: 🚩 Consider adding Box's (1950) fabric wear data (Rencher Table 6.20; not in rencher)

#' Snap Bean Yield and Leaf Area by Sowing Date and Variety
#'
#' @description
#' A balanced two-way experiment on snap beans: 3 varieties were each sown
#' on 4 dates, with 5 plots for each combination. Four responses were
#' recorded: the earliness of yield and of specific leaf area (SLA), and
#' their totals or averages over the season.
#'
#' All three effects, sowing date, variety and their interaction, are
#' large, and they have different ranks (3, 2 and 6 df), so this is a good
#' example of a two-way MANOVA with a real interaction.
#'
#' @name SnapBeans
#' @docType data
#' @format A data frame with 60 observations on the following 6 variables.
#'   * `sowing`: sowing date, an ordered factor with levels `S1` < `S2` <
#'        `S3` < `S4`. The actual dates are not given.
#'   * `variety`: a factor with levels `V1`, `V2`, `V3`
#'   * `yieldEarly`: yield earliness
#'   * `SLAEarly`: specific leaf area earliness
#'   * `yield`: total yield
#'   * `SLA`: average specific leaf area
#'
#' @details
#' The responses come in pairs: earliness (`yieldEarly`, `SLAEarly`) and
#' season totals (`yield`, `SLA`); or yield (`yieldEarly`, `yield`) and leaf
#' area (`SLAEarly`, `SLA`).
#'
#' `sowing` is an ordered factor, so it has polynomial contrasts
#' (`sowing.L`, `sowing.Q`, `sowing.C`) for linear, quadratic and cubic
#' trends over the sowing dates, assuming they are equally spaced.
#' `variety` comes with contrasts comparing variety 2 to varieties 1 and 3
#' (`variety2vs13`), and variety 1 to variety 3 (`variety1vs3`). Rencher &
#' Christensen (2012, Problem 6.28) ask for the first of these because "in
#' previous experiments, the second variety gave higher yields". In these
#' data, variety 2 has the *lowest* mean total yield, although the contrast is
#' highly significant.
#'
#' @source
#' Rencher, A. C. & Christensen, W. F. (2012), Table 6.18, from the
#' `rencher` package (`table6.18`). Originally from Keuls, M., Martakis,
#' G. F. P., & Magid, A. H. A. (1984). The relationship between pod yield
#' and specific leaf area in snapbeans; an example of stepwise multivariate
#' analysis of variance. *Scientia Horticulturae*, 23, 231--246.
#'
#' @references
#' Rencher, A. C. & Christensen, W. F. (2012). *Methods of Multivariate
#' Analysis*, 3rd ed. Hoboken, NJ: Wiley. Problems 6.28, 7.27.
#'
#' @keywords datasets
#' @concept MANOVA
#' @concept contrasts
#' @concept candisc
#' @examples
#' data(SnapBeans)
#' with(SnapBeans, table(sowing, variety))
#' contrasts(SnapBeans$variety)
#'
#' beans.mod <- lm(cbind(yieldEarly, SLAEarly, yield, SLA) ~ sowing * variety,
#'                 data = SnapBeans)
#' car::Anova(beans.mod)
#'
#' heplot(beans.mod, variables = c("yield", "SLA"),
#'        fill = TRUE, fill.alpha = 0.1)
#'
#' # polynomial trends over sowing dates
#' hyp <- list("linear" = "sowing.L", "quad" = "sowing.Q", "cubic" = "sowing.C")
#' heplot(beans.mod, terms = "sowing", hypotheses = hyp,
#'        variables = c("yield", "SLA"),
#'        main = "Sowing date: polynomial components")
#'
#' # variety 2 vs varieties 1 and 3
#' car::linearHypothesis(beans.mod, "variety2vs13") |> print(SSP = FALSE)
#' heplot(beans.mod, terms = "variety",
#'        hypotheses = list("V2 vs V1,V3" = "variety2vs13"),
#'        variables = c("yield", "SLA"))
#' aggregate(cbind(yield, SLA) ~ variety, data = SnapBeans, FUN = mean)
#'
#' pairs(beans.mod, fill = TRUE, fill.alpha = 0.1)
#'
#' # sowing date is essentially one-dimensional in canonical space
#' if (requireNamespace("candisc", quietly = TRUE)) {
#'   beans.can <- candisc::candisc(beans.mod, term = "sowing")
#'   print(beans.can)
#'   plot(beans.can)
#' }
NULL

#' Carriers and Noncarriers of Duchenne Muscular Dystrophy
#'
#' @description
#' Data from a study to find a screening procedure for women who carry
#' Duchenne muscular dystrophy, which is passed from female carriers to some
#' of their sons. Four blood enzymes were measured in 39 noncarriers and 34
#' carriers, together with their age and the month the measurements were
#' taken.
#'
#' The study asked: how well do the enzymes separate the two groups? Two of
#' them, creatine kinase and hemopexin, are cheap to measure, and two,
#' pyruvate kinase and lactate dehydrogenase, are expensive. Do the
#' expensive ones add anything? Age and month can be treated as covariates,
#' giving a MANCOVA.
#'
#' @name Dystrophy
#' @docType data
#' @format A data frame with 73 observations on the following 7 variables.
#'   * `group`: a factor with levels `Noncarriers`, `Carriers`
#'   * `age`: age, in years
#'   * `month`: month in which the measurements were taken (1--12)
#'   * `CK`: creatine kinase
#'   * `Hpx`: hemopexin
#'   * `PK`: pyruvate kinase
#'   * `LD`: lactate dehydrogenase
#'
#' @details
#' Rencher & Christensen (2012, Problem 5.19) list the last two variables
#' as lactate dehydrogenase then pyruvate kinase. The values suggest the
#' reverse (the fifth column runs 3.5--110, the sixth 87--412), and the
#' original data of Andrews & Herzberg (1985) have the order CK, H, PK, LD,
#' which is used here.
#'
#' Hemopexin is called `Hpx` here, rather than `H`, so it is not confused
#' with an \eqn{\mathbf{H}}{H} matrix.
#'
#' The enzyme measurements are positively skewed, with some large values
#' (`CK` up to 657), so analyses are usually on log scales for `CK`, `PK`
#' and `LD`. This also makes the data useful for comparing classical and
#' robust fits ([robmlm()]).
#'
#' @source
#' Rencher, A. C. & Christensen, W. F. (2012), Table 5.7, from the
#' `rencher` package (`table5.7`). Originally from Andrews, D. F. &
#' Herzberg, A. M. (1985). *Data: A Collection of Problems from Many Fields
#' for the Student and Research Worker*. New York: Springer, pp. 223--228.
#'
#' @references
#' Rencher, A. C. & Christensen, W. F. (2012). *Methods of Multivariate
#' Analysis*, 3rd ed. Hoboken, NJ: Wiley. Problems 5.19, 7.23, 8.9.
#'
#' @keywords datasets
#' @concept MANOVA
#' @concept MANCOVA
#' @concept robust
#' @concept candisc
#' @examples
#' data(Dystrophy)
#' table(Dystrophy$group)
#'
#' # the enzymes are skewed; log CK, PK and LD
#' Dystrophy <- within(Dystrophy, {
#'   logCK <- log(CK); logPK <- log(PK); logLD <- log(LD)
#' })
#' op <- par(mfrow = c(1, 2))
#' cqplot(Dystrophy[, c("CK", "Hpx", "PK", "LD")], main = "Raw enzymes")
#' cqplot(Dystrophy[, c("logCK", "Hpx", "logPK", "logLD")],
#'        main = "CK, PK, LD logged")
#' par(op)
#'
#' # MANCOVA: age and month are covariates. Each term has 1 df, so each
#' # H ellipse is a line.
#' dmd.mod <- lm(cbind(logCK, Hpx, logPK, logLD) ~ group + age + month,
#'               data = Dystrophy)
#' car::Anova(dmd.mod)
#' heplot(dmd.mod, variables = c("logCK", "logPK"),
#'        fill = TRUE, fill.alpha = 0.1)
#' pairs(dmd.mod, fill = TRUE, fill.alpha = 0.1)
#'
#' # Do the expensive enzymes (PK, LD) separate the groups beyond the cheap
#' # ones (CK, Hpx)? Use the cheap ones as covariates.
#' dmd.mod2 <- lm(cbind(logPK, logLD) ~ group + logCK + Hpx + age + month,
#'                data = Dystrophy)
#' car::Anova(dmd.mod2)
#' heplot(dmd.mod2, fill = TRUE, fill.alpha = 0.1,
#'        main = "PK and LD, adjusting for CK, Hpx, age and month")
#'
#' # robust fit: does down-weighting outlying cases change the picture?
#' dmd.rob <- robmlm(cbind(logCK, Hpx, logPK, logLD) ~ group + age + month,
#'                   data = Dystrophy)
#' plot(dmd.rob)
#' heplot(dmd.mod, variables = c("logCK", "logPK"), lty = 2,
#'        main = "Classical (dashed) vs robust (solid) fit")
#' heplot(dmd.rob, variables = c("logCK", "logPK"), add = TRUE, lwd = 2)
NULL

#' Plasma Inorganic Phosphate after a Glucose Challenge
#'
#' @description
#' Plasma inorganic phosphate (mg/dl) was measured in 13 control and 20
#' obese patients at 8 times, from 0 to 5 hours after an oral glucose
#' challenge. The times are not equally spaced.
#'
#' Both groups show a U-shaped curve over time, but the controls dip more
#' deeply and earlier (lowest at about 1.5 hours) than the obese patients
#' (lowest at about 2 hours), giving a strong group by time interaction.
#'
#' @name Phosphate
#' @docType data
#' @format A data frame with 33 observations on the following 9 variables.
#'   * `group`: a factor with levels `Control`, `Obese`
#'   * `hr0`: phosphate at 0 hours (before the challenge)
#'   * `hr0.5`: at 0.5 hours
#'   * `hr1`: at 1 hour
#'   * `hr1.5`: at 1.5 hours
#'   * `hr2`: at 2 hours
#'   * `hr3`: at 3 hours
#'   * `hr4`: at 4 hours
#'   * `hr5`: at 5 hours
#'
#' @details
#' For a repeated measures analysis, use polynomial contrasts in the
#' *actual* times, `contr.poly(8, scores = c(0, 0.5, 1, 1.5, 2, 3, 4, 5))`,
#' rather than equally spaced ones, as in the examples.
#'
#' The two groups differ on the linear, cubic and quartic components of
#' time, but not at all on the quadratic: the curves are equally U-shaped,
#' and differ in where and how sharply they dip. So an HE plot of the
#' linear and quadratic components misses most of the interaction; other
#' views, or [pairs.mlm()], show it.
#'
#' Rencher & Christensen (2012) note that the first patient in each group
#' has nearly identical values (they differ only at 4 and 5 hours), which
#' they take to be coincidental.
#'
#' @source
#' Rencher, A. C. & Christensen, W. F. (2012), Table 6.28, from the
#' `rencher` package (`table6.28`). Originally from Zerbe, G. O. (1979).
#' Randomization analysis of the completely randomized design extended to
#' growth curves. *Journal of the American Statistical Association*, 74,
#' 215--221.
#'
#' @references
#' Rencher, A. C. & Christensen, W. F. (2012). *Methods of Multivariate
#' Analysis*, 3rd ed. Hoboken, NJ: Wiley. Problems 6.43, 6.44.
#'
#' @keywords datasets
#' @concept MANOVA
#' @concept repeated
#' @concept contrasts
#' @examples
#' data(Phosphate)
#' table(Phosphate$group)
#' hours <- c(0, 0.5, 1, 1.5, 2, 3, 4, 5)
#' resp <- paste0("hr", hours)
#'
#' # mean profiles
#' means <- aggregate(Phosphate[, resp], list(group = Phosphate$group), mean)
#' matplot(hours, t(means[, resp]), type = "b", pch = 16, lty = 1,
#'         col = c("blue", "red"),
#'         xlab = "Hours after glucose challenge",
#'         ylab = "Mean plasma phosphate (mg/dl)")
#' legend("top", legend = means$group, col = c("blue", "red"),
#'        lty = 1, pch = 16, bty = "n")
#'
#' # within-S design: orthogonal polynomials in the actual hours
#' idata <- data.frame(hour = ordered(hours))
#' contrasts(idata$hour) <- contr.poly(8, scores = hours)
#'
#' phos.mod <- lm(cbind(hr0, hr0.5, hr1, hr1.5, hr2, hr3, hr4, hr5) ~ group,
#'                data = Phosphate)
#' car::Anova(phos.mod, idata = idata, idesign = ~hour)
#'
#' # linear x quadratic: group:hour stays inside E in this view
#' heplot(phos.mod, idata = idata, idesign = ~hour, iterm = "hour",
#'        variables = c("hour.L", "hour.Q"), fill = TRUE, fill.alpha = 0.1)
#' # linear x cubic shows more of the interaction
#' heplot(phos.mod, idata = idata, idesign = ~hour, iterm = "hour",
#'        variables = c("hour.L", "hour.C"), fill = TRUE, fill.alpha = 0.1)
#'
#' pairs(phos.mod, idata = idata, idesign = ~hour, iterm = "hour",
#'       variables = 1:4, fill = TRUE, fill.alpha = 0.1)
NULL


#' Ramus Bone Height of Boys at Four Ages
#'
#' @description
#' The height of the ramus (the vertical part of the lower jaw bone), in mm,
#' measured on 20 boys at ages 8, 8.5, 9 and 9.5 years.
#'
#' This is a classic small dataset for growth curves (repeated measures on a single
#' group), and for multivariate normality and outliers. With \eqn{n = 20} and
#' \eqn{p = 4}, it shows how the \eqn{\chi^2} approximation to the distribution of
#' squared Mahalanobis distances can hide outliers that the exact beta distribution
#' reveals (see [cqplot()]).
#'
#' @name Ramus
#' @docType data
#' @format A data frame with 20 observations on the following 4 variables.
#'   * `Age8`: ramus height at 8 years
#'   * `Age8.5`: at 8.5 years
#'   * `Age9`: at 9 years
#'   * `Age9.5`: at 9.5 years
#'
#' @details
#' Rencher & Christensen (2012, Example 4.6.2) use these data to look for multivariate
#' outliers. No variable shows univariate outliers, but a beta Q-Q plot of the squared
#' Mahalanobis distances \eqn{D^2} shows that three boys (9, 12, 20), and possibly a
#' fourth (8), depart from multivariate normality. A test for a single outlier does
#' not reject, because the three largest distances mask each other. Mardia's test
#' of multivariate kurtosis is significant.
#'
#' The values of \eqn{D^2} in their Table 4.1 differ slightly from those computed from
#' these data, mostly for boys 7 and 10. The data here agree exactly with the printed
#' Table 3.7, and their \eqn{D^2} sum to \eqn{(n-1)p = 76}, as they must, whereas
#' those in Table 4.1 sum to 75.5.
#'
#' For a repeated measures analysis, the four ages are equally spaced, so the default
#' polynomial contrasts for an ordered factor give the linear, quadratic and cubic
#' components of growth.
#'
#' @source
#' Rencher, A. C. & Christensen, W. F. (2012), Table 3.7, from the `rencher` package
#' (`table3.7`). Originally from Elston, R. C. & Grizzle, J. E. (1962). Estimation of
#' time-response curves and their confidence bands. *Biometrics*, 18, 148--159.
#'
#' @references
#' Rencher, A. C. & Christensen, W. F. (2012). *Methods of Multivariate Analysis*,
#' 3rd ed. Hoboken, NJ: Wiley. Example 4.6.2; Problems 3.18--3.20.
#'
#' @keywords datasets
#' @concept repeated
#' @concept outliers
#' @examples
#' data(Ramus)
#' ages <- c(8, 8.5, 9, 9.5)
#'
#' # growth curves for each boy, and the mean
#' matplot(ages, t(Ramus), type = "l", lty = 1, col = "gray",
#'         xlab = "Age (years)", ylab = "Ramus height (mm)")
#' lines(ages, colMeans(Ramus), lwd = 3)
#'
#' # multivariate outliers: chi-square vs exact beta reference
#' op <- par(mfrow = c(1, 2))
#' cqplot(Ramus, id.n = 4, main = "Chi-square")
#' cqplot(Ramus, id.n = 4, dist = "beta", main = "Beta")
#' par(op)
#'
#' # repeated measures: a single group, so only the intercept and age
#' idata <- data.frame(age = ordered(ages))
#' ramus.mod <- lm(cbind(Age8, Age8.5, Age9, Age9.5) ~ 1, data = Ramus)
#' car::Anova(ramus.mod, idata = idata, idesign = ~age, type = 3)
#'
#' # linear x quadratic components of growth
#' heplot(ramus.mod, idata = idata, idesign = ~age, iterm = "age",
#'        variables = c("age.L", "age.Q"), fill = TRUE)
NULL
