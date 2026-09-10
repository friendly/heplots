# Verification script for stdmodel()/stdcoef()/coefplot.mlm(std=) -- see
# issues/TASKS.md and R/standardize.R. This package isn't on testthat yet
# (see CLAUDE.md), so verification lives here as a dev/ script, matching
# dev/T-F-example.R's role for LearnDis.

Sys.setenv(RGL_USE_NULL = TRUE)
devtools::load_all(quiet = TRUE)

pass <- function(label, ok) cat(if (ok) "PASS" else "FAIL", "--", label, "\n")

## 1. Rohwer (mixed factor + continuous): stdmodel()/stdcoef.mlm() match the
##    analytic diagonal rescale of the original fit, to float precision.
data(Rohwer, package = "heplots")
Rohwer$SES <- relevel(Rohwer$SES, ref = "Lo")
mod1 <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data = Rohwer)

predictors <- c("n", "s", "ns", "na", "ss")
responses  <- c("SAT", "PPVT", "Raven")
sx <- sapply(Rohwer[predictors], sd)
sy <- sapply(Rohwer[responses], sd)
B <- coef(mod1)[predictors, , drop = FALSE]
B_analytic <- diag(sx[predictors]) %*% B %*% diag(1 / sy[responses])
dimnames(B_analytic) <- dimnames(B)

B_stdcoef <- stdcoef(mod1)[predictors, ]
pass("Rohwer: stdcoef.mlm matches analytic diag-rescale",
     max(abs(B_stdcoef - B_analytic)) < 1e-10)

mod1.std <- stdmodel(mod1)
pass("Rohwer: stdmodel() SES coefficient row still present (factor untouched)",
     "SESHi" %in% rownames(coef(mod1.std)))
pass("Rohwer: stdmodel() response is standardized (mean ~0)",
     abs(mean(mod1.std$model[[1]][, "SAT"])) < 1e-10)

## coefplot(std=TRUE) smoke test
png(tempfile(fileext = ".png"))
res <- tryCatch({
  coefplot(mod1, parm = 2:6, std = TRUE, fill = TRUE, level = 0.68)
  TRUE
}, error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); FALSE })
dev.off()
pass("Rohwer: coefplot(..., std=TRUE) runs without error", res)

## coefplot(std=FALSE) unchanged vs. current master behavior (regression safety)
png(tempfile(fileext = ".png"))
res2 <- tryCatch({
  coefplot(mod1, parm = 2:6, fill = TRUE, level = 0.68)
  TRUE
}, error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); FALSE })
dev.off()
pass("Rohwer: coefplot(..., std=FALSE, default) still runs without error", res2)

## 2. dogfood (all-factor predictor): only the response(s) get standardized;
##    closes out the old scale()-based bug (unnamed coefficients / heplot()
##    "subscript out of bounds").
data(dogfood, package = "heplots")
dogfood.mod <- lm(cbind(start, amount) ~ formula, data = dogfood)
dogfood.std <- stdmodel(dogfood.mod)
pass("dogfood: standardized model keeps named coefficients",
     identical(rownames(coef(dogfood.std)), rownames(coef(dogfood.mod))))
pass("dogfood: response columns are standardized (mean ~0)",
     all(abs(colMeans(dogfood.std$model[[1]])) < 1e-10))

png(tempfile(fileext = ".png"))
res3 <- tryCatch({ heplot(dogfood.std); TRUE },
                 error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); FALSE })
dev.off()
pass("dogfood: heplot(stdmodel(dogfood.mod)) runs without error", res3)

## 3. Prestige (plain lm): stdcoef.lm dispatch still matches lm.beta()
##    (regression check against the fix shipped in commit 80229e7f).
data(Prestige, package = "carData")
source("dev/standardize.R")  # for lm.beta() reference implementation
prestige.mod <- lm(prestige ~ income + education, data = Prestige)
pass("Prestige: stdcoef() (lm method) matches lm.beta()",
     max(abs(stdcoef(prestige.mod) -
               na.omit(lm.beta(prestige.mod)$standardized.coefficients))) < 1e-10)

## 4. Formula guards: computed/transformed terms should error clearly, not
##    silently mis-standardize.
prestige.mod2 <- lm(prestige ~ log(income) + education, data = Prestige)
res4 <- tryCatch({ stdmodel(prestige.mod2); FALSE },
                  error = function(e) { cat("expected error:", conditionMessage(e), "\n"); TRUE })
pass("guard: computed predictor term (log(income)) errors", res4)

prestige.mod3 <- lm(log(prestige) ~ income + education, data = Prestige)
res5 <- tryCatch({ stdmodel(prestige.mod3); FALSE },
                  error = function(e) { cat("expected error:", conditionMessage(e), "\n"); TRUE })
pass("guard: computed response term (log(prestige)) errors", res5)

## 5. Interaction model (Rohwer.mod2-style): base variables standardize
##    correctly, interaction terms rebuilt automatically by update().
mod2 <- lm(cbind(SAT, PPVT, Raven) ~ SES * (n + s + ns + na + ss), data = Rohwer)
res6 <- tryCatch({ stdmodel(mod2); TRUE },
                  error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); FALSE })
pass("Rohwer interaction model: stdmodel() runs without error", res6)

## 6. Interop with lmtest::coeftest() and broom::tidy.coeftest() -- Vis-MLM-book's
##    Rohwer-ex.R calls coeftest(Rohwer.mod1) directly on the (raw) mlm object, so
##    stdmodel()'s output -- itself just a refit "mlm" -- should work the same way.
if (requireNamespace("lmtest", quietly = TRUE) && requireNamespace("broom", quietly = TRUE)) {
  ct_std <- tryCatch(lmtest::coeftest(mod1.std <- stdmodel(mod1)), error = function(e) {
    cat("ERROR:", conditionMessage(e), "\n"); NULL
  })
  pass("coeftest() runs on stdmodel(mod1)", !is.null(ct_std))

  td_std <- tryCatch(broom::tidy(ct_std), error = function(e) {
    cat("ERROR:", conditionMessage(e), "\n"); NULL
  })
  pass("broom::tidy() runs on coeftest(stdmodel(mod1))", is.data.frame(td_std))

  pass("coeftest(stdmodel(mod1)) estimates match stdcoef(mod1)",
       isTRUE(all.equal(unname(ct_std["SAT:n", "Estimate"]), unname(stdcoef(mod1)["n", "SAT"]))))

  pass("coeftest() t/p-values unchanged by standardization (linear rescale)",
       isTRUE(all.equal(unname(lmtest::coeftest(mod1)["SAT:n", c("t value", "Pr(>|t|)")]),
                         unname(ct_std["SAT:n", c("t value", "Pr(>|t|)")]))))
} else {
  cat("SKIP -- lmtest/broom interop checks (one or both not installed)\n")
}
