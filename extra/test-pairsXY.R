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


# answer from SO: https://stackoverflow.com/questions/73859139/how-to-make-a-scatterplot-rectangular-matrix-y1-y2-x1-x2-in-r
library(tidyr)
;ibrary(dplyr)
library(ggplot2)

Rohwer_long <- Rohwer %>%
  dplyr::select(-na, -ss) |>
  pivot_longer(cols = all_of(xvars), 
               names_to = "xvar", values_to = "x") |>
  pivot_longer(cols = all_of(yvars), 
               names_to = "yvar", values_to = "y")

ggplot(Rohwer_long, aes(x, y, color = SES, shape = SES)) +
  geom_jitter(size=1.5) +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x, size=1.5) +
  facet_grid(yvar ~ xvar, scales = "free") +
  theme_bw(base_size = 16) +
  theme(legend.position = "bottom")

