# scatterplot rectangular matrix: (y1, y2, y3) ~ (x1, x2, ...)

data(Rohwer, package = "heplots")
str(Rohwer)

yvars <- c("SAT", "PPVT", "Raven" )
xvars <- c("n", "s", "ns", "na", "ss")
xvars <- c("n", "s", "ns")  # smaller example
gp <- "SES"

# try with base R
op <- par(mfrow = c(length(yvars), length(xvars)),
          mar = c(4, 4, 1, 1)+.1)
for(y in yvars) {
  for (x in xvars) {
    plot(Rohwer[, x], Rohwer[, y],
         xlab=x, ylab=y)
    abline(lm(Rohwer[, y] ~ Rohwer[, x]))
  }
}
par(op)

# try with car::scatterplot
library(car)
op <- par(mfrow = c(length(yvars), length(xvars)),
          mar = c(4, 4, 1, 1)+.1)

for(i in 1:length(yvars)) {
  y <- Rohwer[, yvars[i]]
  ylab <- if(i==1) yvars[i] else ""
  for (j in 1:length(xvars)) {
    x <- Rohwer[, xvars[j]]
    xlab <- if(j==length(xvars)) xvars[j] else ""
    scatterplot(x, y, groups=Rohwer[, gp],
                ylab = ylab,
                xlab = xlab,
                smooth = FALSE,
                legend = FALSE,
                reset.par = FALSE
    )
  }
}
par(op)
