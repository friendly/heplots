# Rencher & Christensen (2012), Example 4.6.2: multivariate outliers in the ramus bone data.
# Reproduces Table 4.1 and Figure 4.10, compares beta vs chi-square references with cqplot(),
# and checks by simulation that q_ii/(1 - h_ii) ~ Beta(p/2, (n-r-p)/2) for mlm residuals.
# Notes: dev/outliers-Rencher.md. Writes rencher-1.png, rencher-2.png to the working directory.

suppressMessages({library(heplots)})
if (!requireNamespace("rencher", quietly=TRUE)) stop("rencher not installed")
data(table3.7, package="rencher"); ramus <- table3.7
print(head(ramus, 3)); Y <- as.matrix(ramus[, sapply(ramus, is.numeric)])
if (ncol(Y) == 5) Y <- Y[, -1]          # drop an id column if present
n <- nrow(Y); p <- ncol(Y); cat("n =", n, " p =", p, "\n")
D2 <- mahalanobis(Y, colMeans(Y), cov(Y))
cat("Table 4.1 check (D2):\n"); print(round(D2, 4))
# Rencher (4.28)-(4.31)
u <- n * D2 / (n-1)^2
a <- p/2; b <- (n-p-1)/2
alpha <- (p-2)/(2*p); beta <- (n-p-3)/(2*(n-p-1))
i <- 1:n
v <- qbeta((i - alpha)/(n - alpha - beta + 1), a, b)
cat("max u =", max(u), " max v =", max(v), "\n")
# Wilks / Yang-Lee
w <- 1 - n*max(D2)/(n-1)^2
Fi <- (n-p-1)/p * (1/(1 - n*D2/(n-1)^2) - 1)
pmax <- 1 - pf(max(Fi), p, n-p-1)^n
cat(sprintf("Wilks w = %.4f; max F = %.3f (obs %d); P(max F > f) = %.4f\n", w, max(Fi), which.max(Fi), pmax))
cat("Fi p-values (unadjusted), top 4:\n"); print(round(sort(pf(Fi, p, n-p-1, lower.tail=FALSE))[1:4], 4))
# Mardia
S0 <- cov(Y)*(n-1)/n; Z <- scale(Y, scale=FALSE); G <- Z %*% solve(S0) %*% t(Z)
cat(sprintf("Mardia b1p = %.3f, b2p = %.3f (book: 11.338, 28.884)\n", sum(G^3)/n^2, sum(diag(G)^2)/n))

png("rencher-%d.png", width=1000, height=500); op <- par(mfrow=c(1,2))
# Fig 4.10 reproduction
plot(sort(u), v, xlim=c(0,1), ylim=c(0,1), xlab="u", ylab="v", main="Rencher Fig 4.10: (u(i), v(i))")
abline(0,1,col="gray")
# same thing on D2 scale vs chi-square quantiles
qb <- (n-1)^2/n * v; qc <- qchisq(ppoints(n), p)
plot(qc, sort(D2), pch=19, xlab="theoretical quantile", ylab="D2 (sorted)",
     main="Beta (blue) vs chi-square (red) reference", xlim=range(qc, qb))
points(qb, sort(D2), pch=1, col="blue", cex=1.3); abline(0,1)
par(op); cqplot(Y, id.n=3, main="cqplot(ramus)"); dev.off()
cat("chi2 vs beta quantiles (top 4):\n"); print(round(cbind(chisq=tail(qc,4), beta=tail(qb,4), D2=tail(sort(D2),4)),3))
cat("beta upper bound (n-1)^2/n =", (n-1)^2/n, "\n")

# mlm residuals: is e_i'(E'E)^-1 e_i / (1 - h_ii) ~ Beta(p/2, (n-r-p)/2)?  (r = # coefs)
set.seed(1); n2 <- 30; r <- 3; p2 <- 3; X <- cbind(1, matrix(rnorm(n2*(r-1)), n2))
h <- diag(X %*% solve(crossprod(X)) %*% t(X)); sim <- replicate(2000, {
  E <- qr.resid(qr(X), matrix(rnorm(n2*p2), n2))
  q <- rowSums((E %*% solve(crossprod(E))) * E); c(q[1]/(1-h[1]), q[n2]/(1-h[n2]))})
cat("sim mean vs Beta mean", (p2/2)/((p2/2)+(n2-r-p2)/2), ":", round(rowMeans(sim),4), "\n")
cat("KS p-values vs Beta(p/2,(n-r-p)/2):", round(c(ks.test(sim[1,], "pbeta", p2/2, (n2-r-p2)/2)$p.value,
    ks.test(sim[2,], "pbeta", p2/2, (n2-r-p2)/2)$p.value),3), "\n")
