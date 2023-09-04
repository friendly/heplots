pkgname <- "candisc"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('candisc')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("Grass")
### * Grass

flush(stderr()); flush(stdout())

### Name: Grass
### Title: Yields from Nitrogen nutrition of grass species
### Aliases: Grass
### Keywords: datasets

### ** Examples

str(Grass)
grass.mod <- lm(cbind(N1,N9,N27,N81,N243) ~ Block + Species, data=Grass)
Anova(grass.mod)

grass.canL <-candiscList(grass.mod)
names(grass.canL)
names(grass.canL$Species)




cleanEx()
nameEx("HSB")
### * HSB

flush(stderr()); flush(stdout())

### Name: HSB
### Title: High School and Beyond Data
### Aliases: HSB
### Keywords: datasets

### ** Examples

str(HSB)
# main effects model
hsb.mod <- lm( cbind(read, write, math, sci, ss) ~
		gender + race + ses + sch + prog, data=HSB)
Anova(hsb.mod)

# Add some interactions
hsb.mod1 <- update(hsb.mod, . ~ . + gender:race + ses:prog)
heplot(hsb.mod1, col=palette()[c(2,1,3:6)], variables=c("read","math"))

hsb.can1 <- candisc(hsb.mod1, term="race")
heplot(hsb.can1, col=c("red", "black"))

# show canonical results for all terms
## Not run: 
##D hsb.can <- candiscList(hsb.mod)
##D hsb.can
## End(Not run)




cleanEx()
nameEx("Wilks")
### * Wilks

flush(stderr()); flush(stdout())

### Name: Wilks
### Title: Wilks Lambda Tests for Canonical Correlations
### Aliases: Wilks Wilks.cancor Wilks.candisc
### Keywords: htest

### ** Examples

data(Rohwer, package="heplots")
X <- as.matrix(Rohwer[,6:10])  # the PA tests
Y <- as.matrix(Rohwer[,3:5])   # the aptitude/ability variables

cc <- cancor(X, Y, set.names=c("PA", "Ability"))
Wilks(cc)

iris.mod <- lm(cbind(Petal.Length, Sepal.Length, Petal.Width, Sepal.Width) ~ Species, data=iris)
iris.can <- candisc(iris.mod, data=iris)
Wilks(iris.can)




cleanEx()
nameEx("Wine")
### * Wine

flush(stderr()); flush(stdout())

### Name: Wine
### Title: Chemical composition of three cultivars of wine
### Aliases: Wine
### Keywords: datasets

### ** Examples

data(Wine)
str(Wine)
#summary(Wine)

Wine.mlm <- lm(as.matrix(Wine[, -1]) ~ Cultivar, data=Wine)
Wine.can <- candisc(Wine.mlm)
Wine.can


plot(Wine.can, ellipse=TRUE)
plot(Wine.can, which=1)





cleanEx()
nameEx("Wolves")
### * Wolves

flush(stderr()); flush(stdout())

### Name: Wolves
### Title: Wolf skulls
### Aliases: Wolves
### Keywords: datasets

### ** Examples

data(Wolves)

# using group
wolf.mod <-lm(cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9) ~ group, data=Wolves)
Anova(wolf.mod)

wolf.can <-candisc(wolf.mod)
plot(wolf.can)
heplot(wolf.can)

# using location, sex
wolf.mod2 <-lm(cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9) ~ location*sex, data=Wolves)
Anova(wolf.mod2)

wolf.can2 <-candiscList(wolf.mod2)
plot(wolf.can2)




cleanEx()
nameEx("can_lm")
### * can_lm

flush(stderr()); flush(stdout())

### Name: can_lm
### Title: Transform a Multivariate Linear model mlm to a Canonical
###   Representation
### Aliases: can_lm

### ** Examples

iris.mod <- lm(cbind(Petal.Length, Sepal.Length, Petal.Width, Sepal.Width) ~ Species, data=iris)
iris.can <- can_lm(iris.mod, "Species")
iris.can
Anova(iris.mod)
Anova(iris.can)



cleanEx()
nameEx("cancor")
### * cancor

flush(stderr()); flush(stdout())

### Name: cancor
### Title: Canonical Correlation Analysis
### Aliases: cancor cancor.default cancor.formula print.cancor
###   summary.cancor coef.cancor scores scores.cancor
### Keywords: multivariate

### ** Examples

data(Rohwer, package="heplots")
X <- as.matrix(Rohwer[,6:10])  # the PA tests
Y <- as.matrix(Rohwer[,3:5])   # the aptitude/ability variables

# visualize the correlation matrix using corrplot()
if (require(corrplot)) {
M <- cor(cbind(X,Y))
corrplot(M, method="ellipse", order="hclust", addrect=2, addCoef.col="black")
}


(cc <- cancor(X, Y, set.names=c("PA", "Ability")))

## Canonical correlation analysis of:
##       5   PA  variables:  n, s, ns, na, ss 
##   with        3   Ability  variables:  SAT, PPVT, Raven 
## 
##     CanR  CanRSQ   Eigen percent    cum                          scree
## 1 0.6703 0.44934 0.81599   77.30  77.30 ******************************
## 2 0.3837 0.14719 0.17260   16.35  93.65 ******                        
## 3 0.2506 0.06282 0.06704    6.35 100.00 **                            
## 
## Test of H0: The canonical correlations in the 
## current row and all that follow are zero
## 
##      CanR  WilksL      F df1   df2  p.value
## 1 0.67033 0.44011 3.8961  15 168.8 0.000006
## 2 0.38366 0.79923 1.8379   8 124.0 0.076076
## 3 0.25065 0.93718 1.4078   3  63.0 0.248814


# formula method
cc <- cancor(cbind(SAT, PPVT, Raven) ~  n + s + ns + na + ss, data=Rohwer, 
    set.names=c("PA", "Ability"))

# using observation weights
set.seed(12345)
wts <- sample(0:1, size=nrow(Rohwer), replace=TRUE, prob=c(.05, .95))
(ccw <- cancor(X, Y, set.names=c("PA", "Ability"), weights=wts) )

# show correlations of the canonical scores 
zapsmall(cor(scores(cc, type="x"), scores(cc, type="y")))

# standardized coefficients
coef(cc, type="both", standardize=TRUE)

plot(cc, smooth=TRUE)

##################
data(schooldata)
##################

#fit the MMreg model
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ 
education + occupation + visit + counseling + teacher, data=schooldata)
Anova(school.mod)
pairs(school.mod)

# canonical correlation analysis
school.cc <- cancor(cbind(reading, mathematics, selfesteem) ~ 
education + occupation + visit + counseling + teacher, data=schooldata)
school.cc
heplot(school.cc, xpd=TRUE, scale=0.3)




cleanEx()
nameEx("candisc")
### * candisc

flush(stderr()); flush(stdout())

### Name: candisc
### Title: Canonical discriminant analysis
### Aliases: candisc candisc.mlm coef.candisc plot.candisc print.candisc
###   summary.candisc
### Keywords: multivariate hplot

### ** Examples

grass.mod <- lm(cbind(N1,N9,N27,N81,N243) ~ Block + Species, data=Grass)
Anova(grass.mod, test="Wilks")

grass.can1 <-candisc(grass.mod, term="Species")
plot(grass.can1)

# library(heplots)
heplot(grass.can1, scale=6, fill=TRUE)

# iris data
iris.mod <- lm(cbind(Petal.Length, Sepal.Length, Petal.Width, Sepal.Width) ~ Species, data=iris)
iris.can <- candisc(iris.mod, data=iris)
#-- assign colors and symbols corresponding to species
col <- c("red", "brown", "green3")
pch <- 1:3
plot(iris.can, col=col, pch=pch)

heplot(iris.can)

# 1-dim plot
iris.can1 <- candisc(iris.mod, data=iris, ndim=1)
plot(iris.can1)




cleanEx()
nameEx("candiscList")
### * candiscList

flush(stderr()); flush(stdout())

### Name: candiscList
### Title: Canonical discriminant analyses
### Aliases: candiscList candiscList.mlm plot.candiscList print.candiscList
###   summary.candiscList
### Keywords: multivariate hplot

### ** Examples

grass.mod <- lm(cbind(N1,N9,N27,N81,N243) ~ Block + Species, data=Grass)

grass.canL <-candiscList(grass.mod)
names(grass.canL)
names(grass.canL$Species)

## Not run: 
##D print(grass.canL)
## End(Not run)
plot(grass.canL, type="n", ask=FALSE)
heplot(grass.canL$Species, scale=6)
heplot(grass.canL$Block, scale=2)




cleanEx()
nameEx("dataIndex")
### * dataIndex

flush(stderr()); flush(stdout())

### Name: dataIndex
### Title: Indices of observations in a model data frame
### Aliases: dataIndex
### Keywords: utilities manip

### ** Examples

factors <- expand.grid(A=factor(1:3),B=factor(1:2),C=factor(1:2))
n <- nrow(factors)
responses <-data.frame(Y1=10+round(10*rnorm(n)),Y2=10+round(10*rnorm(n)))

test <- data.frame(factors, responses)
mod <- lm(cbind(Y1,Y2) ~ A*B, data=test)

dataIndex(mod, "A")
dataIndex(mod, "A:B")




cleanEx()
nameEx("heplot.cancor")
### * heplot.cancor

flush(stderr()); flush(stdout())

### Name: heplot.cancor
### Title: Canonical Correlation HE plots
### Aliases: heplot.cancor heplot3d.cancor
### Keywords: hplot multivariate

### ** Examples

data(Rohwer, package="heplots")
X <- as.matrix(Rohwer[,6:10])
Y <- as.matrix(Rohwer[,3:5])
cc <- cancor(X, Y, set.names=c("PA", "Ability"))

# basic plot
heplot(cc)

# note relationship of joint hypothesis to individual ones
heplot(cc, scale=1.25, hypotheses=list("na+ns"=c("na", "ns")))

# more options
heplot(cc, hypotheses=list("All X"=colnames(X)),
	fill=c(TRUE,FALSE), fill.alpha=0.2,
	var.cex=1.5, var.col="red", var.lwd=3,
	prefix="Y canonical dimension"
	)

# 3D version
## Not run: 
##D heplot3d(cc, var.lwd=3, var.col="red")
## End(Not run)




cleanEx()
nameEx("heplot.candisc")
### * heplot.candisc

flush(stderr()); flush(stdout())

### Name: heplot.candisc
### Title: Canonical Discriminant HE plots
### Aliases: heplot.candisc heplot3d.candisc
### Keywords: multivariate hplot

### ** Examples

## Pottery data, from car package
pottery.mod <- lm(cbind(Al, Fe, Mg, Ca, Na) ~ Site, data=Pottery)
pottery.can <-candisc(pottery.mod)

heplot(pottery.can, var.lwd=3)
if(requireNamespace("rgl")){
heplot3d(pottery.can, var.lwd=3, scale=10, zlim=c(-3,3), wire=FALSE)
}


# reduce example for CRAN checks time

## Can't run this in example
# rgl::play3d(rgl::spin3d(axis = c(1, 0, 0), rpm = 5), duration=12)

# reduce example for CRAN checks time




cleanEx()
nameEx("plot.cancor")
### * plot.cancor

flush(stderr()); flush(stdout())

### Name: plot.cancor
### Title: Canonical Correlation Plots
### Aliases: plot.cancor
### Keywords: hplot

### ** Examples

data(Rohwer, package="heplots")
X <- as.matrix(Rohwer[,6:10])  # the PA tests
Y <- as.matrix(Rohwer[,3:5])   # the aptitude/ability variables

cc <- cancor(X, Y, set.names=c("PA", "Ability"))

plot(cc)
# exercise some options
plot(cc, smooth=TRUE, id.n=3, ellipse.args=list(fill=TRUE))
plot(cc, which=2, smooth=TRUE)
plot(cc, which=3, smooth=TRUE)


# plot vectors showing structure correlations of Xcan and Ycan with their own variables
plot(cc)
struc <- cc$structure
Xstruc <- struc$X.xscores[,1]
Ystruc <- struc$Y.yscores[,1]
scale <- 2

# place vectors in the margins of the plot
usr <- matrix(par("usr"), nrow=2, dimnames=list(c("min", "max"), c("x", "y")))
ypos <- usr[2,2] - (1:5)/10 
arrows(0, ypos, scale*Xstruc, ypos, angle=10, len=0.1, col="blue")
text(scale*Xstruc, ypos, names(Xstruc), pos=2, col="blue")

xpos <- usr[2,1] - ( 1 + 1:3)/10
arrows(xpos, 0, xpos, scale*Ystruc, angle=10, len=0.1, col="darkgreen")
text(xpos, scale*Ystruc, names(Ystruc), pos=1, col="darkgreen")




graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("redundancy")
### * redundancy

flush(stderr()); flush(stdout())

### Name: redundancy
### Title: Canonical Redundancy Analysis
### Aliases: redundancy print.cancor.redundancy
### Keywords: multivariate

### ** Examples

	data(Rohwer, package="heplots")
X <- as.matrix(Rohwer[,6:10])  # the PA tests
Y <- as.matrix(Rohwer[,3:5])   # the aptitude/ability variables

cc <- cancor(X, Y, set.names=c("PA", "Ability"))

redundancy(cc)
## 
## Redundancies for the PA variables & total X canonical redundancy
## 
##     Xcan1     Xcan2     Xcan3 total X|Y 
##   0.17342   0.04211   0.00797   0.22350 
## 
## Redundancies for the Ability variables & total Y canonical redundancy
## 
##     Ycan1     Ycan2     Ycan3 total Y|X 
##    0.2249    0.0369    0.0156    0.2774 




cleanEx()
nameEx("varOrder")
### * varOrder

flush(stderr()); flush(stdout())

### Name: varOrder
### Title: Order variables according to canonical structure or other
###   criteria
### Aliases: varOrder varOrder.mlm varOrder.data.frame
### Keywords: manip multivariate

### ** Examples

data(Wine, package="candisc")
Wine.mod <- lm(as.matrix(Wine[, -1]) ~ Cultivar, data=Wine)
Wine.can <- candisc(Wine.mod)
plot(Wine.can, ellipse=TRUE)

# pairs.mlm HE plot, variables in given order
pairs(Wine.mod, fill=TRUE, fill.alpha=.1, var.cex=1.5)

order <- varOrder(Wine.mod)
pairs(Wine.mod, variables=order, fill=TRUE, fill.alpha=.1, var.cex=1.5)




cleanEx()
nameEx("vecscale")
### * vecscale

flush(stderr()); flush(stdout())

### Name: vecscale
### Title: Scale vectors to fill the current plot
### Aliases: vecscale
### Keywords: manip

### ** Examples

bbox <- matrix(c(-3, 3, -2, 2), 2, 2)
colnames(bbox) <- c("x","y")
rownames(bbox) <- c("min", "max")
bbox

vecs <- matrix( runif(10, -1, 1), 5, 2)

plot(bbox)
arrows(0, 0, vecs[,1], vecs[,2], angle=10, col="red")
(s <- vecscale(vecs))
arrows(0, 0, s*vecs[,1], s*vecs[,2], angle=10)



cleanEx()
nameEx("vectors")
### * vectors

flush(stderr()); flush(stdout())

### Name: vectors
### Title: Draw Labeled Vectors in 2D or 3D
### Aliases: vectors vectors3d
### Keywords: aplot

### ** Examples

plot(c(-3, 3), c(-3,3), type="n")
X <- matrix(rnorm(10), ncol=2)
rownames(X) <- LETTERS[1:5]
vectors(X, scale=2, col=palette())




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
