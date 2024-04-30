data("AddHealth", package = "heplots")

library(ggplot2)
library(dplyr, warn=FALSE)
library(car)
library(patchwork)


means <- AddHealth |>
  group_by(grade) |>
  summarise(
    n = n(),
    dep_se = sd(depression, na.rm = TRUE) / sqrt(n),
    anx_se = sd(anxiety, na.rm = TRUE) / sqrt(n),
    depression = mean(depression),
    anxiety = mean(anxiety) ) |> 
  relocate(depression, anxiety, .after = grade) |>
  print()

means <- AddHealth |>
  group_by(grade) |>
  summarise(
    n = n(),
    dep_sd = sd(depression, na.rm = TRUE),
    anx_sd = sd(anxiety, na.rm = TRUE),
    dep_se = dep_sd / sqrt(n),
    anx_se = anx_sd / sqrt(n),
    depression = mean(depression),
    anxiety = mean(anxiety) ) |> 
  relocate(depression, anxiety, .after = grade) |>
  print()


# plot means with error bars

p1 <-ggplot(data = means, aes(x = grade, y = anxiety)) +
  geom_point(size = 4) +
  geom_line(aes(group = 1), linewidth = 1.2) +
  geom_errorbar(aes(ymin = anxiety - anx_se, 
                   ymax = anxiety + anx_se),
                width = .2) +
  theme_bw(base_size = 15)

p2 <-ggplot(data = means, aes(x = grade, y = depression)) +
  geom_point(size = 4) +
  geom_line(aes(group = 1), linewidth = 1.2) +
  geom_errorbar(aes(ymin = depression - dep_se, 
                    ymax = depression + dep_se),
                width = .2) +
  theme_bw(base_size = 15)

p1 + p2


ggplot(data = means, aes(x = anxiety, y = depression, 
                         color = grade)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = anxiety - anx_se, 
                    xmax = anxiety + anx_se)) +
  geom_errorbar(aes(ymin = depression - dep_se, 
                    ymax = depression + dep_se)) +
  geom_line(aes(group = 1), linewidth = 1.5) +
  geom_label(aes(label = grade), 
             nudge_x = -0.015, nudge_y = 0.02) +
  scale_color_discrete(guide = "none") +
  theme_bw(base_size = 15)



op <- par(mar = c(5,4,1,1)+0.1)
covEllipses(AddHealth[, 3:2], group = AddHealth$grade,
            pooled = FALSE, level = 0.1,
            center.cex = 2.5, cex = 1.5, cex.lab = 1.5,
            fill = TRUE, fill.alpha = 0.05)
par(op)


# # formula method can't suppress points ???
# dataEllipse(anxiety ~ depression | grade, data=AddHealth,
#             levels = 0.33, plot.points = FALSE)
# 
# with(AddHealth,
#      {dataEllipse(anxiety ~ depression | grade,
#                   levels = 0.33, plot.points = FALSE)})


# fit separate linear models
AH.mod1 <- lm(anxiety ~ grade, data = AddHealth)
Anova(AH.mod1)
# test coefficients
lmtest::coeftest(AH.mod1)

# test for all non-linear trends together
linearHypothesis(AH.mod1, names(coef(AH.mod1)[3:5]))

AH.mod2 <- lm(depression ~ grade, data = AddHealth)
Anova(AH.mod2)
# test coefficients
lmtest::coeftest(AH.mod2)

# test for all non-linear trends together
linearHypothesis(AH.mod2, names(coef(AH.mod2)[3:5]))

# fit the mlm
AH.mlm <- lm(cbind(anxiety, depression) ~ grade, data = AddHealth)
# overall test of `grade`
Anova(AH.mlm)
# show separate multivariate tests
summary(Anova(AH.mlm)) |> print(SSP = FALSE)

lmtest::coeftest(AH.mlm)

# test for all non-linear trends together
# linearHypothesis(AH.mlm, rownames(coef(AH.mlm)[-(1:2)]))
linearHypothesis(AH.mlm, "grade.L")
linearHypothesis(AH.mlm, "grade.Q")

linearHypothesis(AH.mlm, rownames(coef(AH.mlm))[3:5])


#lmtest::coeftest(AH.mlm) |> broom::tidy()

op <- par(mar = c(4,4,1,1)+0.1)
heplot(AH.mlm, 
       hypotheses=c("grade.L", "grade.Q"), 
       hyp.labels = c("linear", "quad"),
       label.pos = c(4, 3, 1, 1),
       fill=c(TRUE, FALSE),
       level = 0.1,
       cex.lab = 1.5
       )
par(op)






