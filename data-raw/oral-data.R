

# folder <- "c:/sasuser/psy6140/examples/glm"
#  oral <- read.delim(file.path(folder, "oral.data"), row.names=NULL)
# oral$Group <- as.factor(ifelse(oral$grp==1, 'Exptl', 'Control'))

library(readr)
library(dplyr)
oral <- read_table("data-raw/oral.dat")
View(oral)

oral <- oral |>
  select(-subjno) |>
  mutate(group = as.factor(ifelse(grp == 1, 'Exptl', 'Control'))) |>
  relocate(group, .before = listen) |>
  select(-grp)

str(oral)

save(oral, file = "data-raw/oral.RData")

labels <- c("Group", "Listening test", "Speaking test", "Reading test", "Writing test")
use_data_doc(oral, "data-raw/oral.Rd", labels = labels)

# some examples

library(heplots)
library(candisc)
library(car)

oral.mod <- lm(cbind(listen, speak, read, write) ~ group, data=oral)
Anova(oral.mod)

op <- par(mar=c(4,5,1,1)+.2)
heplot(oral.mod, col=c("red", "black"), 
       fill=TRUE, fill.alpha=0.1, 
       cex.lab=1.5, cex=1.5)
par(op)


pairs(oral.mod, col=c("red", "black"), 
      fill=TRUE, fill.alpha=0.1, var.cex=3)


par(mfrow=c(1,4), cex.lab=1.5)
clr <- c("pink", "lightblue")
Boxplot(listen ~ group, data=oral, col = clr, cex.lab = 1.5)
Boxplot(speak ~  group, data=oral, col = clr, cex.lab = 1.5)
Boxplot(read ~   group, data=oral, col = clr, cex.lab = 1.5)
Boxplot(write ~  group, data=oral, col = clr, cex.lab = 1.5)
par(op)

Boxplot(oral[, 2:5], g = oral$group)

library(dplyr)
library(ggplot2)
library(tidyr)
oral |>
  pivot_longer(!group, names_to = "variable") |>
  ggplot(aes(x = group, y = value, color = group)) +
  geom_boxplot() +
  facet_wrap(~variable, scales="free")



oral.can <- candisc(oral.mod)
plot(oral.can, var.lwd=2)
