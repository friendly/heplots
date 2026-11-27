# Tests for cqplot(dist = "beta") and the cqplot() bug fixes (v1.9.0 devel), 2026-11-27
# Run from the package root. Compares the development version (loaded with pkgload)
# to the installed heplots (CRAN 1.8.7). Writes plots to dev/test_cqplot_beta.pdf

old_cqplot <- heplots::cqplot          # installed version, before loading dev
pkgload::load_all(".", quiet = TRUE)

pdf("dev/test_cqplot_beta.pdf", width = 10, height = 5)
op <- par(mfrow = c(1, 2))

# 1. Rencher & Christensen, Example 4.6.2: beta quantiles on the D^2 scale, top four
#    (dev/outliers-Rencher.md: 5.92, 6.55, 7.42, 8.94)
if (requireNamespace("rencher", quietly = TRUE)) {
  data(table3.7, package = "rencher")
  Y <- as.matrix(table3.7[, -1])
  r_chi  <- cqplot(Y, id.n = 4, main = "ramus: chi-square")
  r_beta <- cqplot(Y, id.n = 4, dist = "beta", main = "ramus: beta")
  print(r_beta)
  # exact, with ppoints(n) plotting positions
  n <- nrow(Y); p <- ncol(Y)
  qb <- (n - 1)^2 / n * qbeta(ppoints(n), p/2, (n - p - 1)/2)
  stopifnot(isTRUE(all.equal(sort(r_beta$quantile), tail(qb, 4))))
  # Rencher's plotting positions, (i - alpha)/(n - alpha - beta + 1), give
  # 5.92, 6.55, 7.42, 8.94; ppoints() gives 5.93, 6.57, 7.46, 9.09
  print(round(rbind(ppoints = tail(qb, 4), Rencher = c(5.92, 6.55, 7.42, 8.94)), 2))
  stopifnot(max(abs(tail(qb, 4) - c(5.92, 6.55, 7.42, 8.94))) < 0.2)
  stopifnot(identical(sort(rownames(r_beta)), sort(rownames(r_chi))))
} else message("rencher not installed: skipping Example 4.6.2")

# 2. Default dist = "chisq": the plotted DSQ and quantiles are the same as 1.8.7;
#    only `p` changes (it is now the p-value of DSQ)
new <- cqplot(stackloss[, 1:3], id.n = 4)
old <- old_cqplot(stackloss[, 1:3], id.n = 4)
stopifnot(all.equal(new[, c("DSQ", "quantile")], old[, c("DSQ", "quantile")]))
stopifnot(all.equal(new$p, pchisq(new$DSQ, 3, lower.tail = FALSE)))
print(cbind(new, p_old = old$p))

# 3. The beta quantiles never exceed the bound (n-1)^2/n; D^2 never does either
n <- nrow(stackloss)
b <- cqplot(stackloss[, 1:3], id.n = n, dist = "beta")
stopifnot(all(b$quantile < (n - 1)^2 / n), all(b$DSQ <= (n - 1)^2 / n))

# 4. Converges to chi-square for large n
set.seed(42)
Z <- matrix(rnorm(5000 * 3), ncol = 3)
z_chi  <- cqplot(Z, id.n = 3)
z_beta <- cqplot(Z, id.n = 3, dist = "beta")
stopifnot(max(abs(z_chi$quantile - z_beta$quantile)) < 0.1)

# 5. Missing values: warning now fires, and the plot works (ylim was NA before)
sl <- stackloss[, 1:3]
sl[c(3, 10), 2] <- NA
res <- withCallingHandlers(
  cqplot(sl, id.n = 2, dist = "beta", main = "NAs"),
  warning = function(w) { message("warning (expected): ", conditionMessage(w))
                          invokeRestart("muffleWarning") })
stopifnot(nrow(res) == 2)

# 6. Robust methods fall back to chi-square, with a warning
w <- tryCatch(cqplot(stackloss[, 1:3], method = "mcd", dist = "beta"),
              warning = function(w) conditionMessage(w))
stopifnot(is.character(w), grepl("classical", w))

# 7. n <= p + 1 is an error for beta
e <- tryCatch(cqplot(stackloss[1:4, 1:3], dist = "beta"), error = function(e) conditionMessage(e))
stopifnot(is.character(e), grepl("n > p \\+ 1", e))

# 8. Detrended, and an mlm, with vector colours
cqplot(stackloss[, 1:3], id.n = 4, dist = "beta", detrend = TRUE)
cqplot(stackloss[, 1:3], id.n = 4, detrend = TRUE)
Sake.mod <- lm(cbind(taste, smell) ~ ., data = Sake)
cqplot(Sake.mod, dist = "beta", id.n = 2, col = rep(c("blue", "red"), length.out = nrow(Sake)))
cqplot(Sake.mod, id.n = 2)

par(op)
dev.off()
cat("All cqplot beta tests passed\n")
