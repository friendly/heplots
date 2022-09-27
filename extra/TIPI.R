load("TIPI.RData")


# fit an mlm
tipi.mlm <- lm(cbind(Extraversion, Neuroticism, Conscientiousness, Agreeableness, Openness) 
               ~ engnat + gender + education, data = TIPI )
Anova(tipi.mlm)

heplot(tipi.mlm, fill=TRUE, fill.alpha=0.1)

pairs(tipi.mlm, fill=TRUE, fill.alpha=0.1)

# candisc works best for factors with >2 levels
tipi.can <- candisc(tipi.mlm, term="education")
tipi.can

plot(tipi.can, ellipse = TRUE)

heplot(tipi.can, fill=TRUE, fill.alpha=0.1, 
       var.col = "darkred", var.cex = 1.5, var.lwd = 3)

# do it for all terms
tipi.canL <- candiscList(tipi.mlm)
tipi.canL

op <- par(mfrow=c(2,2))
plot(tipi.canL, ask = FALSE)
par(op)

plot(tipi.canL$engnat)
plot(tipi.canL$gender)

