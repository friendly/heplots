data("AddHealth")

library(ggplot2)
library(dplyr)
library(car)

# why does this give NAs?
std.error <- function(x, na.rm = TRUE) {
  sd(x, na.rm = na.rm) / sqrt(length(x))
}

means <- AddHealth |>
  group_by(grade) |>
  summarise(depression = mean(depression),
            anxiety = mean(anxiety),
            n = n(),
            se.dep = std.error(depression),
            se.anx = sd(anxiety, na.rm = TRUE) / sqrt(n)) |> print()



means <- AddHealth |>
  group_by(grade) |>
  summarise(across(.cols = everything(), list(mean = mean, se = std.error))) |>
  rename(depression = depression_mean,
         anxiety = anxiety_mean) |> print()



ggplot(data = AddHealth, aes(x = depression, y = anxiety, color = grade)) +
#  geom_jitter(alpha = 0.2) +
#  stat_ellipse(level = 0.10) + 
  geom_point(data = means, size = 3) +
  geom_errorbar(data = means, aes(ymin = anxiety - anxiety_se, ymax = anxiety + anxiety_se)) +
  geom_errorbarh(data = means, aes(xmin = depression - depression_se, xmax = depression + depression_se)) +
  geom_line(data = means, aes(group = 1), linewidth = 1.5)


# formula method can't suppress points ???
dataEllipse(anxiety ~ depression | grade, data=AddHealth,
            levels = 0.33, plot.points = FALSE)

with(AddHealth,
     {dataEllipse(anxiety ~ depression | grade,
                  levels = 0.33, plot.points = FALSE)})

