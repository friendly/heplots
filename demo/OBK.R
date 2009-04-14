library(car)	# for OBrienKaiser data

## OBK.R	HE plots for repeated measures designs, OBrienKaiser data

# simplified analysis of OBrienKaiser data, collapsing over hour
OBK <- OBrienKaiser
OBK$pre <- rowMeans(OBK[,3:7])
OBK$post <- rowMeans(OBK[,8:12])
OBK$fup <- rowMeans(OBK[,13:17])
# remove separate hour scores
OBK <- OBK[,-(3:17)]


# MANOVA model
mod.OBK <- lm(cbind(pre, post, fup) ~  treatment*gender,  data=OBK)


# for linear and quadratic effects of 'Time'
phase <- ordered(c("pretest", "posttest", "followup"),
    levels=c("pretest", "posttest", "followup"))
# for profile contrasts
contrasts(phase) <- matrix(c(-1,  1, 0,
		                          0, -1, 1), ncol=2)

#contrasts(treatment) <- matrix(c(-2, 1, 1,  0, -1, 1), ncol=2)

idata <- data.frame(phase)

# Multivariate tests for repeated measures
aov.OBK <- Manova(mod.OBK, idata=idata, idesign=~phase, type="III")
aov.OBK

# Univariate tests for repeated measures
summary(aov.OBK, multivariate=FALSE)

# HE plots for Between-S effects
heplot(mod.OBK, hypotheses=c("treatment1", "treatment2"),
	col=c("red", "black", "blue", "brown", "gray", "gray"),
	hyp.labels=c("(A,B)-Control", "A-B"),
	main="Between-S effects"
	)
pairs(mod.OBK, col=c("red", "black", "blue", "brown"))

# Transform to profile contrasts for within-S effects
OBK$phase.1 <- OBK$post - OBK$pre
OBK$phase.2 <- OBK$fup - OBK$post

# HE plots for Within-S effects
  # why is (Intercept) missing?
mod1.OBK <- lm(cbind(phase.1, phase.2) ~ treatment*gender,  data=OBK)
heplot(mod1.OBK,
#	remove.intercept=FALSE,
	main="Within-S effects (profile contrasts): Phase * (Treat*Gender)",
	xlab="Post-Pre", ylab="Fup-Post",
	term.labels=c("phase*treatment", "phase*gender", "phase*treatment*gender"),
	col=c("red", "black", "blue", "brown"),
	xlim=c(-2,4), ylim=c(-2,3)
)
points(0,0, cex=2.5, col="green", pch=19)
text(0,0, expression(H[0]), col="green", pos=2)
abline(v=0, col="green")
abline(h=0, col="green")

# Main effect of phase tests H0: Intercept=0
mod2.OBK <- lm(cbind(phase.1, phase.2) ~ 1,  data=OBK)
heplot(mod2.OBK,
	terms="(Intercept)", col=c("red", "blue"), type="3",
#	remove.intercept=FALSE,
	main="Within-S effects (profile contrasts): Phase",
	xlab="Post-Pre", ylab="Fup-Post",
	term.labels="phase",
	xlim=c(-2,4), ylim=c(-2,3)
)
points(0,0, cex=2.5, col="green", pch=19)
text(0,0, expression(H[0]), col="green", pos=2)
abline(v=0, col="green")
abline(h=0, col="green")
