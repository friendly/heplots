# https://stackoverflow.com/questions/73859139/how-to-make-a-scatterplot-rectangular-matrix-y1-y2-x1-x2-in-r

data(Rohwer, package = "heplots")

library(tidyr)
library(dplyr)
library(ggplot2)

yvars <- c("SAT", "PPVT", "Raven" )
xvars <- c("n", "s", "ns", "na", "ss")
#xvars <- c("n", "s", "ns")  # smaller example
#gp <- "SES"

Rohwer_long <- Rohwer %>%
  pivot_longer(cols = all_of(xvars), names_to = "xvar", values_to = "x") |>
  pivot_longer(cols = all_of(yvars), names_to = "yvar", values_to = "y") |>
  mutate(xvar = factor(xvar, xvars), yvar = factor(yvar, yvars))

ggplot(Rohwer_long, aes(x, y, color = SES, shape = SES, fill = SES)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.1) +
  facet_grid(yvar ~ xvar, scales = "free") +
  labs(x = "predictor", y = "response") +
  theme_bw(base_size = 14)

