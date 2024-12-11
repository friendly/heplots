# Stepdown analysis / Choleski

library(heplots)
library(car)

data(schooldata)

school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ 
                   education + occupation + visit + counseling + teacher, data=schooldata)
Anova(school.mod)

heplot(school.mod,
       fill=TRUE, fill.alpha=0.1)

hyp <- rownames(coef(school.mod))[-1]
heplot(school.mod,
       hypotheses = list("B=0" = hyp),
       fill=TRUE, fill.alpha=0.1)



pairs(school.mod, fill=TRUE, fill.alpha=0.1)

# matrix algebra approach
Y <- schooldata[, c("reading", "mathematics", "selfesteem")] |> as.matrix()
X <- schooldata[, c("education", "occupation", "visit", "counseling", "teacher")] |> as.matrix()

S <- cov(Y)
L <- chol(S)
Linv <- solve(L)

YL <- Y %*% Linv
colnames(YL) <- c("reading", "math.read", "self.read_math")

school.mat.mod <- lm(Y ~ X)
Anova(school.mat.mod)

school.step.mod <- lm(YL ~ X[,1] + X[,2] + X[,3] + X[,4] + X[,5])
Anova(school.mat.mod)

heplot(school.step.mod)
pairs(school.step.mod)

# residual approach


schooldata$math.read <- lm(mathematics ~ reading, data=schooldata) |>
  residuals()
schooldata$self.read_math <- lm(selfesteem ~ reading + mathematics, data=schooldata) |>
  residuals()

cor(schooldata[,6:8])

cor(schooldata[,c(6, 9,10)]) |> zapsmall()

school.resmod <- lm(cbind(reading, math.read, self.read_math) ~ 
                   education + occupation + visit + counseling + teacher, data=schooldata)
Anova(school.resmod)

pairs(school.resmod, fill=TRUE, fill.alpha=0.1)
