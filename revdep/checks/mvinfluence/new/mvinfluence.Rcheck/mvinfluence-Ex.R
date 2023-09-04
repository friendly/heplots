pkgname <- "mvinfluence"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('mvinfluence')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("Fertilizer")
### * Fertilizer

flush(stderr()); flush(stdout())

### Name: Fertilizer
### Title: Fertilizer Data
### Aliases: Fertilizer
### Keywords: datasets

### ** Examples


data(Fertilizer)

# simple plots
plot(Fertilizer, col=c('red', rep("blue",7)), 
     cex=c(2,rep(1.2,7)), 
     pch=as.character(1:8))

# A biplot shows the data in 2D. It gives another view of how case 1 stands out in data space
biplot(prcomp(Fertilizer))

# fit the mlm
mod <- lm(cbind(grain, straw) ~ fertilizer, data=Fertilizer)
Anova(mod)

# influence plots (m=1)
influencePlot(mod)
influencePlot(mod, type='LR')
influencePlot(mod, type='stres')





cleanEx()
nameEx("as.data.frame.inflmlm")
### * as.data.frame.inflmlm

flush(stderr()); flush(stdout())

### Name: as.data.frame.inflmlm
### Title: Convert an inflmlm object to a data frame
### Aliases: as.data.frame.inflmlm

### ** Examples

# none




cleanEx()
nameEx("cooks.distance.mlm")
### * cooks.distance.mlm

flush(stderr()); flush(stdout())

### Name: cooks.distance.mlm
### Title: Cook's distance for a MLM
### Aliases: cooks.distance.mlm
### Keywords: models regression

### ** Examples


data(Rohwer, package="heplots")
Rohwer2 <- subset(Rohwer, subset=group==2)
rownames(Rohwer2)<- 1:nrow(Rohwer2)
Rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n+s+ns+na+ss, data=Rohwer2)

hatvalues(Rohwer.mod)
cooks.distance(Rohwer.mod)




cleanEx()
nameEx("hatvalues.mlm")
### * hatvalues.mlm

flush(stderr()); flush(stdout())

### Name: hatvalues.mlm
### Title: Hatvalues for a MLM
### Aliases: hatvalues.mlm
### Keywords: models regression

### ** Examples


data(Rohwer, package="heplots")
Rohwer2 <- subset(Rohwer, subset=group==2)
rownames(Rohwer2)<- 1:nrow(Rohwer2)
Rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n+s+ns+na+ss, data=Rohwer2)

options(digits=3)
hatvalues(Rohwer.mod)
cooks.distance(Rohwer.mod)



cleanEx()
nameEx("infIndexPlot.mlm")
### * infIndexPlot.mlm

flush(stderr()); flush(stdout())

### Name: infIndexPlot.mlm
### Title: Influence Index Plots for Multivariate Linear Models
### Aliases: infIndexPlot.mlm influenceIndexPlot
### Keywords: hplot

### ** Examples


# iris data
data(iris)
iris.mod <- lm(as.matrix(iris[,1:4]) ~ Species, data=iris)
infIndexPlot(iris.mod, col=iris$Species, id.n=3)

# Sake data
data(Sake, package="heplots")
Sake.mod <- lm(cbind(taste,smell) ~ ., data=Sake)
infIndexPlot(Sake.mod, id.n=3)

# Rohwer data
data(Rohwer, package="heplots")
Rohwer2 <- subset(Rohwer, subset=group==2)
rownames(Rohwer2)<- 1:nrow(Rohwer2)
rohwer.mlm <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer2)
infIndexPlot(rohwer.mlm, id.n=3)





cleanEx()
nameEx("influence.mlm")
### * influence.mlm

flush(stderr()); flush(stdout())

### Name: influence.mlm
### Title: Regression Deletion Diagnostics for Multivariate Linear Models
### Aliases: influence.mlm
### Keywords: models regression

### ** Examples


# Rohwer data
data(Rohwer, package="heplots")
Rohwer2 <- subset(Rohwer, subset=group==2)
rownames(Rohwer2)<- 1:nrow(Rohwer2)
Rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n+s+ns+na+ss, data=Rohwer2)

# m=1 diagnostics
influence(Rohwer.mod) |> head()

# try an m=2 case
## res2 <- influence.mlm(Rohwer.mod, m=2, do.coef=FALSE)
## res2.df <- as.data.frame(res2)
## head(res2.df)
## scatterplotMatrix(log(res2.df))


influencePlot(Rohwer.mod, id.n=4, type="cookd")


# Sake data
data(Sake, package="heplots")
Sake.mod <- lm(cbind(taste,smell) ~ ., data=Sake)
influence(Sake.mod)
influencePlot(Sake.mod, id.n=3, type="cookd")





cleanEx()
nameEx("influencePlot.mlm")
### * influencePlot.mlm

flush(stderr()); flush(stdout())

### Name: influencePlot.mlm
### Title: Influence Plots for Multivariate Linear Models
### Aliases: influencePlot.mlm
### Keywords: models multivariate regression

### ** Examples


data(Rohwer, package="heplots")
Rohwer2 <- subset(Rohwer, subset=group==2)
Rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n+s+ns+na+ss, data=Rohwer2)

influencePlot(Rohwer.mod, id.n=4, type="stres")
influencePlot(Rohwer.mod, id.n=4, type="LR")
influencePlot(Rohwer.mod, id.n=4, type="cookd")

# Sake data
data(Sake, package="heplots")
	Sake.mod <- lm(cbind(taste,smell) ~ ., data=Sake)
	influencePlot(Sake.mod, id.n=3, type="stres")
	influencePlot(Sake.mod, id.n=3, type="LR")
	influencePlot(Sake.mod, id.n=3, type="cookd")

# Adopted data	
data(Adopted, package="heplots")
Adopted.mod <- lm(cbind(Age2IQ, Age4IQ, Age8IQ, Age13IQ) ~ AMED + BMIQ, data=Adopted)
influencePlot(Adopted.mod, id.n=3)
influencePlot(Adopted.mod, id.n=3, type="LR", ylim=c(-4,-1.5))





cleanEx()
nameEx("lrPlot")
### * lrPlot

flush(stderr()); flush(stdout())

### Name: lrPlot
### Title: Regression LR Influence Plot
### Aliases: lrPlot lrPlot.lm
### Keywords: regression

### ** Examples


# artificial example from Lawrence (1995)
x <- c( 0, 0, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 18, 18 )
y <- c( 0, 6, 6, 7, 6, 7, 6, 7, 6,  7,  6,  7,  7,  18 )
DF <- data.frame(x,y, row.names=LETTERS[1:length(x)])
DF

with(DF, {
	plot(x,y, pch=16, cex=1.3)
	abline(lm(y~x), col="red", lwd=2)
	NB <- c(1,2,13,14)
	text(x[NB],y[NB], LETTERS[NB], pos=c(4,4,2,2))
	}
)

mod <- lm(y~x, data=DF)
# standard influence plot from car
influencePlot(mod, id.n=4)

# lrPlot version
lrPlot(mod, id.n=4)


library(car)
dmod <- lm(prestige ~ income + education, data = Duncan)
influencePlot(dmod, id.n=3)
lrPlot(dmod, id.n=3)




cleanEx()
nameEx("mlm.influence")
### * mlm.influence

flush(stderr()); flush(stdout())

### Name: mlm.influence
### Title: Calculate Regression Deletion Diagnostics for Multivariate
###   Linear Models
### Aliases: mlm.influence
### Keywords: models multivariate regression

### ** Examples


Rohwer2 <- subset(Rohwer, subset=group==2)
rownames(Rohwer2)<- 1:nrow(Rohwer2)
Rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ n+s+ns+na+ss, data=Rohwer2)
Rohwer.mod
influence(Rohwer.mod)

# extract the most influential cases
influence(Rohwer.mod) |> 
    as.data.frame() |> 
    dplyr::arrange(dplyr::desc(CookD)) |> 
    head()

# Sake data
Sake.mod <- lm(cbind(taste,smell) ~ ., data=Sake)
influence(Sake.mod) |>
    as.data.frame() |> 
    dplyr::arrange(dplyr::desc(CookD)) |> head()





cleanEx()
nameEx("mpower")
### * mpower

flush(stderr()); flush(stdout())

### Name: mpower
### Title: General Matrix Power
### Aliases: mpower %^%
### Keywords: array

### ** Examples


M <- matrix(sample(1:9), 3,3)
mpower(M,2)
mpower(M,4)

# make a symmetric matrix
MM <- crossprod(M)
mpower(MM, -1)
Mhalf <- mpower(MM, 1/2)
all.equal(MM, Mhalf %*% Mhalf)





cleanEx()
nameEx("print.inflmlm")
### * print.inflmlm

flush(stderr()); flush(stdout())

### Name: print.inflmlm
### Title: Print an inflmlm object
### Aliases: print.inflmlm

### ** Examples

# none




cleanEx()
nameEx("tr")
### * tr

flush(stderr()); flush(stdout())

### Name: tr
### Title: Matrix trace
### Aliases: tr
### Keywords: array

### ** Examples


M <- matrix(sample(1:9), 3,3)
tr(M)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
