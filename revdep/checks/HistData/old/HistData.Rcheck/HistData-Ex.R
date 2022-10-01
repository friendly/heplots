pkgname <- "HistData"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('HistData')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("Arbuthnot")
### * Arbuthnot

flush(stderr()); flush(stdout())

### Name: Arbuthnot
### Title: Arbuthnot's data on male and female birth ratios in London from
###   1629-1710.
### Aliases: Arbuthnot
### Keywords: datasets

### ** Examples

data(Arbuthnot)
# plot the sex ratios
with(Arbuthnot, plot(Year,Ratio, type='b', ylim=c(1, 1.20), ylab="Sex Ratio (M/F)"))
abline(h=1, col="red")
#  add loess smooth
Arb.smooth <- with(Arbuthnot, loess.smooth(Year,Ratio))
lines(Arb.smooth$x, Arb.smooth$y, col="blue", lwd=2)

# plot the total christenings to observe the anomalie in 1704
with(Arbuthnot, plot(Year,Total, type='b', ylab="Total Christenings"))



cleanEx()
nameEx("Armada")
### * Armada

flush(stderr()); flush(stdout())

### Name: Armada
### Title: La Felicisima Armada
### Aliases: Armada
### Keywords: datasets

### ** Examples

data(Armada)
# delete character and redundant variable
armada <- Armada[,-c(1,6)]

armada.pca <- prcomp(armada, scale.=TRUE)
summary(armada.pca)

plot(armada.pca, type="lines", pch=16, cex=2)
biplot(armada.pca)



cleanEx()
nameEx("Bowley")
### * Bowley

flush(stderr()); flush(stdout())

### Name: Bowley
### Title: Bowley's data on values of British and Irish trade, 1855-1899
### Aliases: Bowley
### Keywords: datasets

### ** Examples

data(Bowley)

# plot the data 
with(Bowley,plot(Year, Value, type='b', lwd=2, 
	ylab="Value of British and Irish Exports",
	main="Bowley's example of the method of smoothing curves"))

# find moving averages-- use center alignment (requires width=ODD)
#require(gtools, warn.conflicts=FALSE)
# simpler version using stats::filter
running <- function(x, width = 5){as.vector(stats::filter(x, rep(1 / width, width), sides = 2))}

mav3<-running(Bowley$Value, width=3)
mav5<-running(Bowley$Value, width=5)
mav9<-running(Bowley$Value, width=9)
lines(Bowley$Year, mav3, col='blue', lty=2)
lines(Bowley$Year, mav5, col='green3', lty=3)
lines(Bowley$Year, mav9, col='brown', lty=4)

# add lowess smooth
lines(lowess(Bowley), col='red', lwd=2)

if(require("ggplot2", quietly=TRUE)) {
  ggplot(aes(x=Year, y=Value), data=Bowley) +
    geom_point() +
    geom_smooth(method="loess", formula=y~x)
  }



cleanEx()
nameEx("Cavendish")
### * Cavendish

flush(stderr()); flush(stdout())

### Name: Cavendish
### Title: Cavendish's Determinations of the Density of the Earth
### Aliases: Cavendish
### Keywords: datasets

### ** Examples

data(Cavendish)
summary(Cavendish)
boxplot(Cavendish, ylab='Density', xlab='Data set')
abline(h=5.517, col="red", lwd=2)

# trimmed means
sapply(Cavendish, mean, trim=.1, na.rm=TRUE)

# express in terms of G
G <- function(D, g=9.806, R=6371) 3*g / (4 * pi * R * D)
 
boxplot(10^5 * G(Cavendish), ylab='~ Gravitational constant (G)', xlab='Data set')
abline(h=10^5 * G(5.517), col="red", lwd=2)




cleanEx()
nameEx("ChestSizes")
### * ChestSizes

flush(stderr()); flush(stdout())

### Name: ChestSizes
### Title: Chest measurements of Scottish Militiamen
### Aliases: ChestSizes ChestStigler
### Keywords: datasets

### ** Examples

data(ChestSizes)

# frequency polygon
plot(ChestSizes, type='b')
# barplot
barplot(ChestSizes[,2], ylab="Frequency", xlab="Chest size")

# calculate expected frequencies under normality, chest ~ N(xbar, std)
n_obs <- sum(ChestSizes$count)
xbar  <- with(ChestSizes, weighted.mean(chest, count))
std   <- with(ChestSizes, sd(rep(chest, count)))

expected <- 
with(ChestSizes, diff(pnorm(c(32, chest) + .5, xbar, std)) * sum(count))





cleanEx()
nameEx("Cholera")
### * Cholera

flush(stderr()); flush(stdout())

### Name: Cholera
### Title: William Farr's Data on Cholera in London, 1849
### Aliases: Cholera
### Keywords: datasets

### ** Examples

data(Cholera)

# plot cholera deaths vs. elevation
plot(cholera_drate ~ elevation, data=Cholera, 
	pch=16, cex.lab=1.2, cex=1.2,
	xlab="Elevation above high water mark (ft)",
	ylab="Deaths from cholera in 1849 per 10,000")

# Farr's mortality ~ 1/ elevation law
elev <- c(0, 10, 30, 50, 70, 90, 100, 350)
mort <- c(174, 99, 53, 34, 27, 22, 20, 6)
lines(mort ~ elev, lwd=2, col="blue")

# better plots, using car::scatterplot

if(require("car", quietly=TRUE)) {
# show separate regression lines for each water supply
  scatterplot(cholera_drate ~ elevation | water, data=Cholera, 
              smooth=FALSE, pch=15:17,
              id=list(n=2, labels=sub(",.*", "", Cholera$district)),
              col=c("red", "darkgreen", "blue"),
              legend=list(coords="topleft", title="Water supply"),
              xlab="Elevation above high water mark (ft)",
              ylab="Deaths from cholera in 1849 per 10,000")
  
  scatterplot(cholera_drate ~ poor_rate | water, data=Cholera, 
              smooth=FALSE, pch=15:17,
              id=list(n=2, labels=sub(",.*", "", Cholera$district)),
              col=c("red", "darkgreen", "blue"),
              legend=list(coords="topleft", title="Water supply"),
              xlab="Poor rate per pound of house value",
              ylab="Deaths from cholera in 1849 per 10,000")
  }

# fit a logistic regression model a la Bingham etal.
fit <- glm( cbind(cholera_deaths, popn) ~ 
            water + elevation + poor_rate + annual_deaths +
            pop_dens + persons_house,
            data=Cholera, family=binomial)
summary(fit)

# odds ratios
cbind( OR = exp(coef(fit))[-1], exp(confint(fit))[-1,] )

if (require(effects)) {
  eff <- allEffects(fit)
  plot(eff)
}




cleanEx()
nameEx("CushnyPeebles")
### * CushnyPeebles

flush(stderr()); flush(stdout())

### Name: CushnyPeebles
### Title: Cushny-Peebles Data: Soporific Effects of Scopolamine
###   Derivatives
### Aliases: CushnyPeebles CushnyPeeblesN
### Keywords: datasets

### ** Examples

data(CushnyPeebles)
# quick looks at the data
plot(CushnyPeebles)
boxplot(CushnyPeebles, ylab="Hours of Sleep", xlab="Treatment")

##########################
# Repeated measures MANOVA

CPmod <- lm(cbind(Control, L_hyoscyamine, L_hyoscine, DL_hyoscine) ~ 1, data=CushnyPeebles)

# Assign within-S factor and contrasts
Treatment <- factor(colnames(CushnyPeebles), levels=colnames(CushnyPeebles))
contrasts(Treatment) <- matrix(
	c(-3, 1, 1, 1,
	   0,-2, 1, 1,
	   0, 0,-1, 1), ncol=3)
colnames(contrasts(Treatment)) <- c("Control.Drug", "L.DL", "L_hy.DL_hy")

Treats <- data.frame(Treatment)
if (require(car)) {
(CPaov <- Anova(CPmod, idata=Treats, idesign= ~Treatment))
}
summary(CPaov, univariate=FALSE)

if (require(heplots)) {
  heplot(CPmod, idata=Treats, idesign= ~Treatment, iterm="Treatment", 
	xlab="Control vs Drugs", ylab="L vs DL drug")
  pairs(CPmod, idata=Treats, idesign= ~Treatment, iterm="Treatment")
}

################################
# reshape to long format, add Ns

CPlong <- stack(CushnyPeebles)[,2:1]
colnames(CPlong) <- c("treatment", "sleep")
CPN <- stack(CushnyPeeblesN)
CPlong <- data.frame(patient=rep(1:11,4), CPlong, n=CPN$values)
str(CPlong)




cleanEx()
nameEx("Dactyl")
### * Dactyl

flush(stderr()); flush(stdout())

### Name: Dactyl
### Title: Edgeworth's counts of dactyls in Virgil's Aeneid
### Aliases: Dactyl
### Keywords: datasets

### ** Examples

data(Dactyl)

# display the basic table
xtabs(count ~ Foot+Lines, data=Dactyl)

# simple two-way anova
anova(dact.lm <- lm(count ~ Foot+Lines, data=Dactyl))

# plot the lm-quartet
op <- par(mfrow=c(2,2))
plot(dact.lm)
par(op)

# show table as a simple mosaicplot
mosaicplot(xtabs(count ~ Foot+Lines, data=Dactyl), shade=TRUE)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("DrinksWages")
### * DrinksWages

flush(stderr()); flush(stdout())

### Name: DrinksWages
### Title: Elderton and Pearson's (1910) data on drinking and wages
### Aliases: DrinksWages
### Keywords: datasets

### ** Examples

data(DrinksWages)
plot(DrinksWages) 

# plot proportion sober vs. wage | class
with(DrinksWages, plot(wage, sober/n, col=c("blue","red","green")[class]))

# fit logistic regression model of sober on wage
mod.sober <- glm(cbind(sober, n) ~ wage, family=binomial, data=DrinksWages)
summary(mod.sober)
op <- par(mfrow=c(2,2))
plot(mod.sober)
par(op)

# TODO: plot fitted model



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("EdgeworthDeaths")
### * EdgeworthDeaths

flush(stderr()); flush(stdout())

### Name: EdgeworthDeaths
### Title: Edgeworth's Data on Death Rates in British Counties
### Aliases: EdgeworthDeaths
### Keywords: datasets

### ** Examples

data(EdgeworthDeaths)

# fit the additive ANOVA model
library(car)  # for Anova()
EDmod <- lm(Freq ~ County + year, data=EdgeworthDeaths)
Anova(EDmod)

# now, consider as a two-way table of frequencies

library(vcd)
library(MASS)
structable( ~ County + year, data=EdgeworthDeaths)
loglm( Freq ~ County + year, data=EdgeworthDeaths)

mosaic( ~ County + year, data=EdgeworthDeaths, 
	shade=TRUE, legend=FALSE, labeling=labeling_values, 
	gp=shading_Friendly)





cleanEx()
nameEx("Fingerprints")
### * Fingerprints

flush(stderr()); flush(stdout())

### Name: Fingerprints
### Title: Waite's data on Patterns in Fingerprints
### Aliases: Fingerprints
### Keywords: datasets

### ** Examples

data(Fingerprints)
xtabs(count ~ Whorls + Loops, data=Fingerprints)



cleanEx()
nameEx("Galton")
### * Galton

flush(stderr()); flush(stdout())

### Name: Galton
### Title: Galton's data on the heights of parents and their children
### Aliases: Galton
### Keywords: datasets

### ** Examples

## Don't show: 
	# allow to work with car 1
	if (packageDescription("car")[["Version"]] < 2) {
		dataEllipse <- data.ellipse
	}
## End(Don't show)
data(Galton)

###########################################################################
# sunflower plot with regression line and data ellipses and lowess smooth
###########################################################################

with(Galton, 
	{
	sunflowerplot(parent,child, xlim=c(62,74), ylim=c(62,74))
	reg <- lm(child ~ parent)
	abline(reg)
	lines(lowess(parent, child), col="blue", lwd=2)
	if(require(car)) {
	dataEllipse(parent,child, xlim=c(62,74), ylim=c(62,74), plot.points=FALSE)
		}
  })




cleanEx()
nameEx("GaltonFamilies")
### * GaltonFamilies

flush(stderr()); flush(stdout())

### Name: GaltonFamilies
### Title: Galton's data on the heights of parents and their children, by
###   child
### Aliases: GaltonFamilies
### Keywords: datasets

### ** Examples

data(GaltonFamilies)
str(GaltonFamilies)

## reproduce Fig 2 in Hanley (2004)
library(car)
scatterplot(childHeight ~ midparentHeight | gender, data=GaltonFamilies, 
    ellipse=TRUE, levels=0.68, legend.coords=list(x=64, y=78))

# multiply daughters' heights by 1.08
GF1 <- within(GaltonFamilies, 
              {childHeight <- ifelse (gender=="female", 1.08*childHeight, childHeight)} )
scatterplot(childHeight ~ midparentHeight | gender, data=GF1, 
    ellipse=TRUE, levels=0.68, legend.coords=list(x=64, y=78))

# add 5.2 to daughters' heights 
GF2 <- within(GaltonFamilies, 
              {childHeight <- ifelse (gender=="female", childHeight+5.2, childHeight)} )
scatterplot(childHeight ~ midparentHeight | gender, data=GF2, 
    ellipse=TRUE, levels=0.68, legend.coords=list(x=64, y=78))

#########################################
# relationship between heights of parents
#########################################

Parents <- subset(GaltonFamilies, !duplicated(GaltonFamilies$family))

with(Parents, {
  sunflowerplot(mother, father, rotate=TRUE, pch=16, 
     xlab="Mother height", ylab="Father height")
	dataEllipse(mother, father, add=TRUE, plot.points=FALSE, 
     center.pch=NULL, levels=0.68)
	abline(lm(father ~ mother), col="red", lwd=2)
	}
	)




cleanEx()
nameEx("Guerry")
### * Guerry

flush(stderr()); flush(stdout())

### Name: Guerry
### Title: Data from A.-M. Guerry, "Essay on the Moral Statistics of
###   France"
### Aliases: Guerry
### Keywords: datasets

### ** Examples

data(Guerry)
## maybe str(Guerry) ; plot(Guerry) ...



cleanEx()
nameEx("HalleyLifeTable")
### * HalleyLifeTable

flush(stderr()); flush(stdout())

### Name: HalleyLifeTable
### Title: Halley's Life Table
### Aliases: HalleyLifeTable
### Keywords: datasets

### ** Examples

data(HalleyLifeTable)
# what was the estimated population of Breslau?
sum(HalleyLifeTable$number)

# plot survival vs. age
plot(number ~ age, data=HalleyLifeTable, type="h", ylab="Number surviving")

# population pyramid is transpose of this
plot(age ~ number, data=HalleyLifeTable, type="l", xlab="Number surviving")
with(HalleyLifeTable, segments(0, age, number, age, lwd=2))

# conditional probability of survival, one more year
plot(ratio ~ age, data=HalleyLifeTable, ylab="Probability survive one more year")





cleanEx()
nameEx("HistData-package")
### * HistData-package

flush(stderr()); flush(stdout())

### Name: HistData-package
### Title: Data sets from the History of Statistics and Data Visualization
### Aliases: HistData-package HistData
### Keywords: package

### ** Examples

# see examples for the separate data sets



cleanEx()
nameEx("Jevons")
### * Jevons

flush(stderr()); flush(stdout())

### Name: Jevons
### Title: W. Stanley Jevons' data on numerical discrimination
### Aliases: Jevons
### Keywords: datasets

### ** Examples

data(Jevons)
# show as tables
xtabs(frequency ~ estimated+actual, data=Jevons)
xtabs(frequency ~ error+actual, data=Jevons)

# show as sunflowerplot with regression line
with(Jevons, sunflowerplot(actual, estimated, frequency, 
  main="Jevons data on numerical estimation"))
Jmod <-lm(estimated ~ actual, data=Jevons, weights=frequency)
abline(Jmod)

# show as balloonplots
if (require(gplots)) {

with(Jevons, balloonplot(actual, estimated, frequency, xlab="actual", ylab="estimated", 
  main="Jevons data on numerical estimation\nBubble area proportional to frequency",
  text.size=0.8))

with(Jevons, balloonplot(actual, error, frequency, xlab="actual", ylab="error", 
  main="Jevons data on numerical estimation: Errors\nBubble area proportional to frequency", 
  text.size=0.8))
}

# plot average error
if(require(reshape)) {
unJevons <- untable(Jevons, Jevons$frequency)
str(unJevons)

require(plyr)
mean_error <- function(df) mean(df$error, na.rm=TRUE)
Jmean <- ddply(unJevons, .(actual), mean_error)
with(Jmean, plot(actual, V1, ylab='Mean error', xlab='Actual number', type='b', main='Jevons data'))
abline(h=0)
}




cleanEx()
nameEx("Langren")
### * Langren

flush(stderr()); flush(stdout())

### Name: Langren
### Title: van Langren's Data on Longitude Distance between Toledo and Rome
### Aliases: Langren Langren1644 Langren.all
### Keywords: datasets spatial

### ** Examples

data(Langren1644)

####################################################
# reproductions of Langren's graph overlaid on a map
####################################################

if (require(jpeg, quietly=TRUE)) {

  gimage <- readJPEG(system.file("images", "google-toledo-rome3.jpg", package="HistData"))
  # NB: dimensions from readJPEG are y, x, colors

  gdim <- dim(gimage)[1:2]
  ylim <- c(1,gdim[1])
  xlim <- c(1,gdim[2])
  op <- par(bty="n", xaxt="n", yaxt="n", mar=c(2, 1, 1, 1) + 0.1)
  # NB: necessary to scale the plot to the pixel coordinates, and use asp=1
  plot(xlim, ylim, xlim=xlim, ylim=ylim, type="n", ann=FALSE, asp=1 )
  rasterImage(gimage, 1, 1, gdim[2], gdim[1])

  # pixel coordinates of Toledo and Rome in the image, measured from the bottom left corner
  toledo.map <- c(131, 59)
  rome.map <- c(506, 119)
  
  # confirm locations of Toledo and Rome
  points(rbind(toledo.map, rome.map), cex=2)
  text(131, 95, "Toledo", cex=1.5)
  text(506, 104, "Roma", cex=1.5)

  # set a scale for translation of lat,long to pixel x,y
  scale <- data.frame(x=c(131, 856), y=c(52,52))
  rownames(scale)=c(0,30)

  # translate from degrees longitude to pixels
  xlate <- function(x) {
    131+x*726/30	
  }

  # draw an axis
  lines(scale)
  ticks <- xlate(seq(0,30,5))
  segments(ticks, 52, ticks, 45)
  text(ticks, 40, seq(0,30,5))
  text(xlate(8), 17, "Grados de la Longitud", cex=1.7)

  # label the observations with the names
  points(x=xlate(Langren1644$Longitude), y=rep(57, nrow(Langren1644)), 
         pch=25, col="blue", bg="blue")
  text(x=xlate(Langren1644$Longitude), y=rep(57, nrow(Langren1644)), 
       labels=Langren1644$Name, srt=90, adj=c(-.1, .5), cex=0.8)
  par(op)
}

### Original implementation using ReadImages, now deprecated & shortly to be removed
## Not run: 
##D if (require(ReadImages)) {
##D   gimage <- read.jpeg(system.file("images", "google-toledo-rome3.jpg", package="HistData"))
##D   plot(gimage)
##D   
##D   # pixel coordinates of Toledo and Rome in the image, measured from the bottom left corner
##D   toledo.map <- c(130, 59)
##D   rome.map <- c(505, 119)
##D   
##D   # confirm locations of Toledo and Rome
##D   points(rbind(toledo.map, rome.map), cex=2)
##D   
##D   # set a scale for translation of lat,long to pixel x,y
##D   scale <- data.frame(x=c(130, 856), y=c(52,52))
##D   rownames(scale)=c(0,30)
##D   lines(scale)
##D   
##D   xlate <- function(x) {
##D     130+x*726/30	
##D   }
##D   points(x=xlate(Langren1644$Longitude), y=rep(57, nrow(Langren1644)), 
##D          pch=25, col="blue")
##D   text(x=xlate(Langren1644$Longitude), y=rep(57, nrow(Langren1644)), 
##D          labels=Langren1644$Name, srt=90, adj=c(0, 0.5), cex=0.8)
##D }
## End(Not run)

### First attempt using ggplot2; temporarily abandonned.
## Not run: 
##D require(maps)
##D require(ggplot2)
##D require(reshape)
##D require(plyr)
##D require(scales)
##D 
##D # set latitude to that of Toledo
##D Langren1644$Latitude <- 39.68
##D 
##D #          x/long   y/lat
##D bbox <- c( 38.186, -9.184,
##D            43.692, 28.674 )
##D bbox <- matrix(bbox, 2, 2, byrow=TRUE)
##D 
##D borders <- as.data.frame(map("world", plot = FALSE,
##D   xlim = expand_range(bbox[,2], 0.2),
##D   ylim = expand_range(bbox[,1], 0.2))[c("x", "y")])
##D 
##D data(world.cities)
##D # get actual locations of Toledo & Rome
##D cities <- subset(world.cities,
##D   name %in% c("Rome", "Toledo") & country.etc %in% c("Spain", "Italy"))
##D colnames(cities)[4:5]<-c("Latitude", "Longitude")
##D 
##D mplot <- ggplot(Langren1644, aes(Longitude, Latitude) ) +
##D   geom_path(aes(x, y), borders, colour = "grey60") +
##D   geom_point(y = 40) +
##D   geom_text(aes(label = Name), y = 40.1, angle = 90, hjust = 0, size = 3)
##D mplot <- mplot +
##D 	geom_segment(aes(x=-4.03, y=40, xend=30, yend=40))
##D 
##D mplot <- mplot +
##D   geom_point(data = cities, colour = "red", size = 2) +
##D   geom_text(data=cities, aes(label=name), color="red", size=3, vjust=-0.5) +
##D   coord_cartesian(xlim=bbox[,2], ylim=bbox[,1])
##D 
##D # make the plot have approximately aspect ratio = 1
##D windows(width=10, height=2)
##D mplot
## End(Not run)


###########################################
# show variation in estimates across graphs
###########################################

library(lattice)
graph <- paste(Langren.all$Author, Langren.all$Year)
dotplot(Name ~ Longitude, data=Langren.all)

dotplot( as.factor(Year) ~ Longitude, data=Langren.all, groups=Name, type="o")

dotplot(Name ~ Longitude|graph, data=Langren.all, groups=graph)

# why the gap?
gap.mod <- glm(Gap ~ Year + Source + Latitude, family=binomial, data=Langren1644)
anova(gap.mod, test="Chisq")





graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("Macdonell")
### * Macdonell

flush(stderr()); flush(stdout())

### Name: Macdonell
### Title: Macdonell's Data on Height and Finger Length of Criminals, used
###   by Gosset (1908)
### Aliases: Macdonell MacdonellDF
### Keywords: datasets

### ** Examples

data(Macdonell)

# display the frequency table
xtabs(frequency ~ finger+round(height,3), data=Macdonell)

## Some examples by james.hanley@mcgill.ca    October 16, 2011
## http://www.biostat.mcgill.ca/hanley/
## See:  http://www.biostat.mcgill.ca/hanley/Student/

###############################################
##  naive contour plots of height and finger ##
###############################################
 
# make a 22 x 42 table
attach(Macdonell)
ht <- unique(height) 
fi <- unique(finger)
fr <- t(matrix(frequency, nrow=42))
detach(Macdonell)


dev.new(width=10, height=5)  # make plot double wide
op <- par(mfrow=c(1,2),mar=c(0.5,0.5,0.5,0.5),oma=c(2,2,0,0))

dx <- 0.5/12
dy <- 0.5/12

plot(ht,ht,xlim=c(min(ht)-dx,max(ht)+dx),
           ylim=c(min(fi)-dy,max(fi)+dy), xlab="", ylab="", type="n" )

# unpack  3000 heights while looping though the frequencies 
heights <- c()
for(i in 1:22) {
	for (j in 1:42) {
	 f  <-  fr[i,j]
	 if(f>0) heights <- c(heights,rep(ht[i],f))
	 if(f>0) text(ht[i], fi[j], toString(f), cex=0.4, col="grey40" ) 
	}
}
text(4.65,13.5, "Finger length (cm)",adj=c(0,1), col="black") ;
text(5.75,9.5, "Height (feet)", adj=c(0,1), col="black") ;
text(6.1,11, "Observed bin\nfrequencies", adj=c(0.5,1), col="grey40",cex=0.85) ;
# crude countour plot
contour(ht, fi, fr, add=TRUE, drawlabels=FALSE, col="grey60")


# smoother contour plot (Galton smoothed 2-D frequencies this way)
# [Galton had experience with plotting isobars for meteorological data]
# it was the smoothed plot that made him remember his 'conic sections'
# and ask a mathematician to work out for him the iso-density
# contours of a bivariate Gaussian distribution... 

dx <- 0.5/12; dy <- 0.05  ; # shifts caused by averaging

plot(ht,ht,xlim=c(min(ht),max(ht)),ylim=c(min(fi),max(fi)), xlab="", ylab="", type="n"  )
 
sm.fr <- matrix(rep(0,21*41),nrow <- 21)
for(i in 1:21) {
	for (j in 1:41) {
	   smooth.freq  <-  (1/4) * sum( fr[i:(i+1), j:(j+1)] ) 
	   sm.fr[i,j]  <-  smooth.freq
	   if(smooth.freq > 0 )
	   text(ht[i]+dx, fi[j]+dy, sub("^0.", ".",toString(smooth.freq)), cex=0.4, col="grey40" )
	   }
	}
 
contour(ht[1:21]+dx, fi[1:41]+dy, sm.fr, add=TRUE, drawlabels=FALSE, col="grey60")
text(6.05,11, "Smoothed bin\nfrequencies", adj=c(0.5,1), col="grey40", cex=0.85) ;
par(op)
dev.new()    # new default device

#######################################
## bivariate kernel density estimate
#######################################

if(require(KernSmooth)) {
MDest <- bkde2D(MacdonellDF, bandwidth=c(1/8, 1/8))
contour(x=MDest$x1, y=MDest$x2, z=MDest$fhat,
	xlab="Height (feet)", ylab="Finger length (cm)", col="red", lwd=2)
with(MacdonellDF, points(jitter(height), jitter(finger), cex=0.5))
}

#############################################################
## sunflower plot of height and finger with data ellipses  ##
#############################################################

with(MacdonellDF, 
	{
	sunflowerplot(height, finger, size=1/12, seg.col="green3",
		xlab="Height (feet)", ylab="Finger length (cm)")
	reg <- lm(finger ~ height)
	abline(reg, lwd=2)
	if(require(car)) {
	dataEllipse(height, finger, plot.points=FALSE, levels=c(.40, .68, .95))
		}
  })


############################################################
## Sampling distributions of sample sd (s) and z=(ybar-mu)/s
############################################################

# note that Gosset used a divisor of n (not n-1) to get the sd.
# He also used Sheppard's correction for the 'binning' or grouping.
# with concatenated height measurements...

mu <- mean(heights) ; sigma <- sqrt( 3000 * var(heights)/2999 )
c(mu,sigma)

# 750 samples of size n=4 (as Gosset did)

# see Student's z, t, and s: What if Gosset had R? 
# [Hanley J, Julien M, and Moodie E. The American Statistician, February 2008] 

# see also the photographs from Student's notebook ('Original small sample data and notes")
# under the link "Gosset' 750 samples of size n=4" 
# on website http://www.biostat.mcgill.ca/hanley/Student/
# and while there, look at the cover of the Notebook containing his yeast-cell counts
# http://www.medicine.mcgill.ca/epidemiology/hanley/Student/750samplesOf4/Covers.JPG
# (Biometrika 1907) and decide for yourself why Gosset, when forced to write under a 
# pen-name, might have taken the name he did!

# PS: Can you figure out what the 750 pairs of numbers signify?
# hint: look again at the numbers of rows and columns in Macdonell's (frequency) Table III.


n <- 4
Nsamples <- 750

y.bar.values <- s.over.sigma.values <- z.values <- c()
for (samp in 1:Nsamples) {
	y <- sample(heights,n)
	y.bar <- mean(y)
	s  <-  sqrt( (n/(n-1))*var(y) ) 
	z <- (y.bar-mu)/s
	y.bar.values <- c(y.bar.values,y.bar) 
	s.over.sigma.values <- c(s.over.sigma.values,s/sigma)
	z.values <- c(z.values,z)
	}

	
op <- par(mfrow=c(2,2),mar=c(2.5,2.5,2.5,2.5),oma=c(2,2,0,0))
# sampling distributions
hist(heights,breaks=seq(4.5,6.5,1/12), main="Histogram of heights (N=3000)")
hist(y.bar.values, main=paste("Histogram of y.bar (n=",n,")",sep=""))

hist(s.over.sigma.values,breaks=seq(0,4,0.1),
	main=paste("Histogram of s/sigma (n=",n,")",sep="")); 
z=seq(-5,5,0.25)+0.125
hist(z.values,breaks=z-0.125, main="Histogram of z=(ybar-mu)/s")
# theoretical
lines(z, 750*0.25*sqrt(n-1)*dt(sqrt(n-1)*z,3), col="red", lwd=1)
par(op)

#####################################################
## Chisquare probability plot for bivariate normality
#####################################################

mu <- colMeans(MacdonellDF)
sigma <- var(MacdonellDF)
Dsq <- mahalanobis(MacdonellDF, mu, sigma)

Q <- qchisq(1:3000/3000, 2)
plot(Q, sort(Dsq), xlab="Chisquare (2) quantile", ylab="Squared distance")
abline(a=0, b=1, col="red", lwd=2)






graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("Michelson")
### * Michelson

flush(stderr()); flush(stdout())

### Name: Michelson
### Title: Michelson's Determinations of the Velocity of Light
### Aliases: Michelson MichelsonSets
### Keywords: datasets

### ** Examples

data(Michelson)

# density plot (default bandwidth & 0.6 * bw)
plot(density(Michelson$velocity), xlab="Speed of light - 299000 (km/s)",
	main="Density plots of Michelson data")
lines(density(Michelson$velocity, adjust=0.6), lty=2)
rug(jitter(Michelson$velocity))
abline(v=mean(Michelson$velocity), col="blue")
abline(v=734.5, col="red", lwd=2)
text(mean(Michelson$velocity), .004, "mean", srt=90, pos=2)
text(734.5, .004, "true", srt=90, pos=2)

# index / time series plot
plot(Michelson$velocity, type="b")
abline(h=734.5, col="red", lwd=2)
lines(lowess(Michelson$velocity), col="blue", lwd=2)

# examine lag=1 differences
plot(diff(Michelson$velocity), type="b")
lines(lowess(diff(Michelson$velocity)), col="blue", lwd=2)

# examine different data sets
boxplot(MichelsonSets, ylab="Velocity of light - 299000 (km/s)", xlab="Data set")
abline(h=734.5, col="red", lwd=2)

# means and trimmed means
(mn <-apply(MichelsonSets, 2, mean))
(tm <- apply(MichelsonSets, 2, mean, trim=.1))
points(1:5, mn)
points(1:5+.05, tm, pch=16, col="blue")




cleanEx()
nameEx("Minard")
### * Minard

flush(stderr()); flush(stdout())

### Name: Minard
### Title: Data from Minard's famous graphic map of Napoleon's march on
###   Moscow
### Aliases: Minard Minard.cities Minard.troops Minard.temp
### Keywords: datasets spatial

### ** Examples

data(Minard.troops)
data(Minard.cities)
data(Minard.temp)

## Not run: 
##D #' ## Load required packages
##D require(ggplot2)
##D require(scales)
##D require(gridExtra)
##D 
##D #' ## plot path of troops, and another layer for city names
##D  plot_troops <- ggplot(Minard.troops, aes(long, lat)) +
##D 		geom_path(aes(size = survivors, colour = direction, group = group),
##D                  lineend = "round", linejoin = "round")
##D  plot_cities <- geom_text(aes(label = city), size = 4, data = Minard.cities)
##D  
##D #' ## Combine these, and add scale information, labels, etc.
##D #' Set the x-axis limits for longitude explicitly, to coincide with those for temperature
##D 
##D breaks <- c(1, 2, 3) * 10^5 
##D plot_minard <- plot_troops + plot_cities +
##D  	scale_size("Survivors", range = c(1, 10), 
##D  	            breaks = breaks, labels = scales::comma(breaks)) +
##D   scale_color_manual("Direction", 
##D                      values = c("grey50", "red"), 
##D                      labels=c("Advance", "Retreat")) +
##D   coord_cartesian(xlim = c(24, 38)) +
##D   xlab(NULL) + 
##D   ylab("Latitude") + 
##D   ggtitle("Napoleon's March on Moscow") +
##D   theme_bw() +
##D   theme(legend.position=c(.8, .2), legend.box="horizontal")
##D  
##D #' ## plot temperature vs. longitude, with labels for dates
##D plot_temp <- ggplot(Minard.temp, aes(long, temp)) +
##D 	geom_path(color="grey", size=1.5) +
##D 	geom_point(size=2) +
##D 	geom_text(aes(label=date)) +
##D 	xlab("Longitude") + ylab("Temperature") +
##D 	coord_cartesian(xlim = c(24, 38)) + 
##D 	theme_bw()
##D 	
##D 
##D #' The plot works best if we  re-scale the plot window to an aspect ratio of ~ 2 x 1
##D # windows(width=10, height=5)
##D 
##D #' Combine the two plots into one
##D grid.arrange(plot_minard, plot_temp, nrow=2, heights=c(3,1))
##D 
## End(Not run)



cleanEx()
nameEx("Nightingale")
### * Nightingale

flush(stderr()); flush(stdout())

### Name: Nightingale
### Title: Florence Nightingale's data on deaths from various causes in the
###   Crimean War
### Aliases: Nightingale
### Keywords: datasets

### ** Examples

data(Nightingale)

# For some graphs, it is more convenient to reshape death rates to long format
#  keep only Date and death rates
require(reshape)
Night<- Nightingale[,c(1,8:10)]
melted <- melt(Night, "Date")
names(melted) <- c("Date", "Cause", "Deaths")
melted$Cause <- sub("\\.rate", "", melted$Cause)
melted$Regime <- ordered( rep(c(rep('Before', 12), rep('After', 12)), 3), 
                          levels=c('Before', 'After'))
Night <- melted

# subsets, to facilitate separate plotting
Night1 <- subset(Night, Date < as.Date("1855-04-01"))
Night2 <- subset(Night, Date >= as.Date("1855-04-01"))

# sort according to Deaths in decreasing order, so counts are not obscured [thx: Monique Graf]
Night1 <- Night1[order(Night1$Deaths, decreasing=TRUE),]
Night2 <- Night2[order(Night2$Deaths, decreasing=TRUE),]

# merge the two sorted files
Night <- rbind(Night1, Night2)


require(ggplot2)
# Before plot
cxc1 <- ggplot(Night1, aes(x = factor(Date), y=Deaths, fill = Cause)) +
		# do it as a stacked bar chart first
   geom_bar(width = 1, position="identity", stat="identity", color="black") +
		# set scale so area ~ Deaths	
   scale_y_sqrt() 
		# A coxcomb plot = bar chart + polar coordinates
cxc1 + coord_polar(start=3*pi/2) + 
	ggtitle("Causes of Mortality in the Army in the East") + 
	xlab("")

# After plot
cxc2 <- ggplot(Night2, aes(x = factor(Date), y=Deaths, fill = Cause)) +
   geom_bar(width = 1, position="identity", stat="identity", color="black") +
   scale_y_sqrt()
cxc2 + coord_polar(start=3*pi/2) +
	ggtitle("Causes of Mortality in the Army in the East") + 
	xlab("")

## Not run: 
##D # do both together, with faceting
##D cxc <- ggplot(Night, aes(x = factor(Date), y=Deaths, fill = Cause)) +
##D  geom_bar(width = 1, position="identity", stat="identity", color="black") + 
##D  scale_y_sqrt() +
##D  facet_grid(. ~ Regime, scales="free", labeller=label_both)
##D cxc + coord_polar(start=3*pi/2) +
##D 	ggtitle("Causes of Mortality in the Army in the East") + 
##D 	xlab("")
## End(Not run)

## What if she had made a set of line graphs?

# these plots are best viewed with width ~ 2 * height 
colors <- c("blue", "red", "black")
with(Nightingale, {
	plot(Date, Disease.rate, type="n", cex.lab=1.25, 
		ylab="Annual Death Rate", xlab="Date", xaxt="n",
		main="Causes of Mortality of the British Army in the East");
	# background, to separate before, after
	rect(as.Date("1854/4/1"), -10, as.Date("1855/3/1"), 
		1.02*max(Disease.rate), col=gray(.90), border="transparent");
	text( as.Date("1854/4/1"), .98*max(Disease.rate), "Before Sanitary\nCommission", pos=4);
	text( as.Date("1855/4/1"), .98*max(Disease.rate), "After Sanitary\nCommission", pos=4);
	# plot the data
	points(Date, Disease.rate, type="b", col=colors[1], lwd=3);
	points(Date, Wounds.rate, type="b", col=colors[2], lwd=2);
	points(Date, Other.rate, type="b", col=colors[3], lwd=2)
	}
)
# add custom Date axis and legend
axis.Date(1, at=seq(as.Date("1854/4/1"), as.Date("1856/3/1"), "3 months"), format="%b %Y")
legend(as.Date("1855/10/20"), 700, c("Preventable disease", "Wounds and injuries", "Other"),
	col=colors, fill=colors, title="Cause", cex=1.25)

# Alternatively, show each cause of death as percent of total
Nightingale <- within(Nightingale, {
	Total <- Disease + Wounds + Other
	Disease.pct <- 100*Disease/Total
	Wounds.pct <- 100*Wounds/Total
	Other.pct <- 100*Other/Total
	})

colors <- c("blue", "red", "black")
with(Nightingale, {
	plot(Date, Disease.pct, type="n",  ylim=c(0,100), cex.lab=1.25,
		ylab="Percent deaths", xlab="Date", xaxt="n",
		main="Percentage of Deaths by Cause");
	# background, to separate before, after
	rect(as.Date("1854/4/1"), -10, as.Date("1855/3/1"), 
		1.02*max(Disease.rate), col=gray(.90), border="transparent");
	text( as.Date("1854/4/1"), .98*max(Disease.pct), "Before Sanitary\nCommission", pos=4);
	text( as.Date("1855/4/1"), .98*max(Disease.pct), "After Sanitary\nCommission", pos=4);
	# plot the data
	points(Date, Disease.pct, type="b", col=colors[1], lwd=3);
	points(Date, Wounds.pct, type="b", col=colors[2], lwd=2);
	points(Date, Other.pct, type="b", col=colors[3], lwd=2)
	}
)
# add custom Date axis and legend
axis.Date(1, at=seq(as.Date("1854/4/1"), as.Date("1856/3/1"), "3 months"), format="%b %Y")
legend(as.Date("1854/8/20"), 60, c("Preventable disease", "Wounds and injuries", "Other"),
	col=colors, fill=colors, title="Cause", cex=1.25)




cleanEx()
nameEx("OldMaps")
### * OldMaps

flush(stderr()); flush(stdout())

### Name: OldMaps
### Title: Latitudes and Longitudes of 39 Points in 11 Old Maps
### Aliases: OldMaps
### Keywords: datasets spatial

### ** Examples

data(OldMaps)
## maybe str(OldMaps) ; plot(OldMaps) ...

with(OldMaps, plot(abs(long),abs(lat), pch=col, col=colors()[point]))



cleanEx()
nameEx("PearsonLee")
### * PearsonLee

flush(stderr()); flush(stdout())

### Name: PearsonLee
### Title: Pearson and Lee's data on the heights of parents and children
###   classified by gender
### Aliases: PearsonLee
### Keywords: datasets

### ** Examples

data(PearsonLee)
str(PearsonLee)

with(PearsonLee, 
    {
    lim <- c(55,80)
    xv <- seq(55,80, .5)
    sunflowerplot(parent,child, number=frequency, xlim=lim, ylim=lim, seg.col="gray", size=.1)
    abline(lm(child ~ parent, weights=frequency), col="blue", lwd=2)
    lines(xv, predict(loess(child ~ parent, weights=frequency), data.frame(parent=xv)), 
          col="blue", lwd=2)
    # NB: dataEllipse doesn't take frequency into account
    if(require(car)) {
    dataEllipse(parent,child, xlim=lim, ylim=lim, plot.points=FALSE)
        }
  })

## separate plots for combinations of (chl, par)

# this doesn't quite work, because xyplot can't handle weights
require(lattice)
xyplot(child ~ parent|par+chl, data=PearsonLee, type=c("p", "r", "smooth"), col.line="red")

# Using ggplot [thx: Dennis Murphy]
require(ggplot2)
ggplot(PearsonLee, aes(x = parent, y = child, weight=frequency)) +
   geom_point(size = 1.5, position = position_jitter(width = 0.2)) +
   geom_smooth(method = lm, aes(weight = PearsonLee$frequency,
               colour = 'Linear'), se = FALSE, size = 1.5) +
   geom_smooth(aes(weight = PearsonLee$frequency,
               colour = 'Loess'), se = FALSE, size = 1.5) +
   facet_grid(chl ~ par) +
   scale_colour_manual(breaks = c('Linear', 'Loess'),
                       values = c('green', 'red')) +
   theme(legend.position = c(0.14, 0.885),
        legend.background = element_rect(fill = 'white'))

# inverse regression, as in Wachmuth et al. (2003)

ggplot(PearsonLee, aes(x = child, y = parent, weight=frequency)) +
   geom_point(size = 1.5, position = position_jitter(width = 0.2)) +
   geom_smooth(method = lm, aes(weight = PearsonLee$frequency,
               colour = 'Linear'), se = FALSE, size = 1.5) +
   geom_smooth(aes(weight = PearsonLee$frequency,
               colour = 'Loess'), se = FALSE, size = 1.5) +
   facet_grid(chl ~ par) +
   scale_colour_manual(breaks = c('Linear', 'Loess'),
                       values = c('green', 'red')) +
   theme(legend.position = c(0.14, 0.885),
        legend.background = element_rect(fill = 'white'))




cleanEx()
nameEx("PolioTrials")
### * PolioTrials

flush(stderr()); flush(stdout())

### Name: PolioTrials
### Title: Polio Field Trials Data
### Aliases: PolioTrials
### Keywords: datasets

### ** Examples

data(PolioTrials)
## maybe str(PolioTrials) ; plot(PolioTrials) ...



cleanEx()
nameEx("Prostitutes")
### * Prostitutes

flush(stderr()); flush(stdout())

### Name: Prostitutes
### Title: Parent-Duchatelet's time-series data on the number of
###   prostitutes in Paris
### Aliases: Prostitutes
### Keywords: datasets

### ** Examples

data(Prostitutes)
## maybe str(Prostitutes) ; plot(Prostitutes) ...



cleanEx()
nameEx("Pyx")
### * Pyx

flush(stderr()); flush(stdout())

### Name: Pyx
### Title: Trial of the Pyx
### Aliases: Pyx
### Keywords: datasets

### ** Examples

data(Pyx)
# display as table
xtabs(count ~ Bags+Deviation, data=Pyx)



cleanEx()
nameEx("Quarrels")
### * Quarrels

flush(stderr()); flush(stdout())

### Name: Quarrels
### Title: Statistics of Deadly Quarrels
### Aliases: Quarrels
### Keywords: datasets

### ** Examples

data(Quarrels)
str(Quarrels)



cleanEx()
nameEx("Snow")
### * Snow

flush(stderr()); flush(stdout())

### Name: Snow
### Title: John Snow's Map and Data on the 1854 London Cholera Outbreak
### Aliases: Snow Snow.deaths Snow.deaths2 Snow.pumps Snow.streets
###   Snow.polygons Snow.dates
### Keywords: datasets spatial

### ** Examples

data(Snow.deaths)
data(Snow.pumps)
data(Snow.streets)
data(Snow.polygons)
data(Snow.deaths)

## Plot deaths over time
require(lubridate)
clr <- ifelse(Snow.dates$date < mdy("09/08/1854"), "red", "darkgreen")
plot(deaths ~ date, data=Snow.dates, type="h", lwd=2, col=clr)
points(deaths ~ date, data=Snow.dates, cex=0.5, pch=16, col=clr)
text( mdy("09/08/1854"), 40, "Pump handle\nremoved Sept. 8", pos=4)


## draw Snow's map and data

SnowMap()

# add polygons
SnowMap(polygons=TRUE, main="Snow's Cholera Map with Pump Polygons")

# zoom in a bit, and show density estimate
SnowMap(xlim=c(7.5,16.5), ylim=c(7,16), polygons=TRUE, density=TRUE,
        main="Snow's Cholera Map, Annotated")


## re-do this the sp way... [thx: Stephane Dray]
library(sp)

# streets
slist <- split(Snow.streets[,c("x","y")],as.factor(Snow.streets[,"street"]))
Ll1 <- lapply(slist,Line)
Lsl1 <- Lines(Ll1,"Street")
Snow.streets.sp <- SpatialLines(list(Lsl1))
plot(Snow.streets.sp, col="gray")
title(main="Snow's Cholera Map of London (sp)")

# deaths
Snow.deaths.sp = SpatialPoints(Snow.deaths[,c("x","y")])
plot(Snow.deaths.sp, add=TRUE, col ='red', pch=15, cex=0.6)

# pumps
spp <- SpatialPoints(Snow.pumps[,c("x","y")])
Snow.pumps.sp <- SpatialPointsDataFrame(spp,Snow.pumps[,c("x","y")])
plot(Snow.pumps.sp, add=TRUE, col='blue', pch=17, cex=1.5)
text(Snow.pumps[,c("x","y")], labels=Snow.pumps$label, pos=1, cex=0.8)



cleanEx()
nameEx("SnowMap")
### * SnowMap

flush(stderr()); flush(stdout())

### Name: SnowMap
### Title: Draw John Snow's Map of Cholera in London
### Aliases: SnowMap Splot Sdeaths Spumps Sstreets Sscale Spolygons
###   Sdensity
### Keywords: hplot

### ** Examples

SnowMap()
SnowMap(axis.labels=TRUE)
SnowMap(deaths.args=list(col="darkgreen"))

SnowMap(polygons=TRUE, main="Snow's Cholera Map with Pump Polygons")

SnowMap(density=TRUE)




cleanEx()
nameEx("Virginis")
### * Virginis

flush(stderr()); flush(stdout())

### Name: Virginis
### Title: John F. W. Herschel's Data on the Orbit of the Twin Stars gamma
###   _Virginis_
### Aliases: Virginis Virginis.interp
### Keywords: datasets

### ** Examples

data(Virginis)
data(Virginis.interp)

# Herschel's interpolated curve
plot(posangle ~ year, data=Virginis.interp, 
	pch=15, type="b", col="red", cex=0.8, lwd=2,
	xlim=c(1710,1840), ylim=c(80, 170),
	ylab="Position angle (deg.)", xlab="Year",
	cex.lab=1.5)

# The data points, and indication of their uncertainty
points(posangle ~ year, data=Virginis, pch=16)
points(posangle ~ year, data=Virginis, cex=weight/2)




cleanEx()
nameEx("Wheat")
### * Wheat

flush(stderr()); flush(stdout())

### Name: Wheat
### Title: Playfair's Data on Wages and the Price of Wheat
### Aliases: Wheat Wheat.monarchs
### Keywords: datasets

### ** Examples

data(Wheat)

data(Wheat)

# ------------------------------------
# Playfair's graph, largely reproduced
# ------------------------------------

# convenience function to fill area under a curve down to a minimum value
fillpoly <- function(x,y, low=min(y),  ...) {
    n <- length(x)
    polygon( c(x, x[n], x[1]), c(y, low, low), ...)
}

# For best results, this graph should be viewed with width ~ 2 * height
# Note use of type='s' to plot a step function for Wheat
#   and panel.first to provide a background grid()
#     The curve for Wages is plotted after the polygon below it is filled
with(Wheat, {
    plot(Year, Wheat, type="s", ylim=c(0,105), 
        ylab="Price of the Quarter of Wheat (shillings)", 
        panel.first=grid(col=gray(.9), lty=1))
    fillpoly(Year, Wages, low=0, col="lightskyblue", border=NA)
    lines(Year, Wages, lwd=3, col="red")
    })


# add some annotations
text(1625,10, "Weekly wages of a good mechanic", cex=0.8, srt=3, col="red")

# cartouche
text(1650, 85, "Chart", cex=2, font=2)
text(1650, 70, 
	paste("Shewing at One View", 
        "The Price of the Quarter of Wheat", 
        "& Wages of Labor by the Week", 
        "from the Year 1565 to 1821",
        "by William Playfair",
        sep="\n"), font=3)

# add the time series bars to show reigning monarchs
# distinguish Cromwell visually, as Playfair did
with(Wheat.monarchs, {
	y <- ifelse( !commonwealth & (!seq_along(start) %% 2), 102, 104)
	segments(start, y, end, y, col="black", lwd=7, lend=1)
	segments(start, y, end, y, col=ifelse(commonwealth, "white", NA), lwd=4, lend=1)
	text((start+end)/2, y-2, name, cex=0.5)
	})

# -----------------------------------------
# plot the labor cost of a quarter of wheat
# -----------------------------------------
Wheat1 <- within(na.omit(Wheat), {Labor=Wheat/Wages})
with(Wheat1, {
	plot(Year, Labor, type='b', pch=16, cex=1.5, lwd=1.5, 
	     ylab="Labor cost of a Quarter of Wheat (weeks)",
	     ylim=c(1,12.5));
	lines(lowess(Year, Labor), col="red", lwd=2)
	})
	
# cartouche
text(1740, 10, "Chart", cex=2, font=2)
text(1740, 8.5, 
	paste("Shewing at One View", 
        "The Work Required to Purchase", 
        "One Quarter of Wheat", 
        sep="\n"), cex=1.5, font=3)

with(Wheat.monarchs, {
	y <- ifelse( !commonwealth & (!seq_along(start) %% 2), 12.3, 12.5)
	segments(start, y, end, y, col="black", lwd=7, lend=1)
	segments(start, y, end, y, col=ifelse(commonwealth, "white", NA), lwd=4, lend=1)
	text((start+end)/2, y-0.2, name, cex=0.5)
	})



cleanEx()
nameEx("Yeast")
### * Yeast

flush(stderr()); flush(stdout())

### Name: Yeast
### Title: Student's (1906) Yeast Cell Counts
### Aliases: Yeast YeastD.mat
### Keywords: datasets

### ** Examples

data(Yeast)

require(lattice)
# basic bar charts 
# TODO: frequencies should start at 0, not 1.
barchart(count~freq|sample, data=Yeast, ylab="Number of Cells", xlab="Frequency")
barchart(freq~count|sample, data=Yeast, xlab="Number of Cells", ylab="Frequency",
	horizontal=FALSE, origin=0)

# same, using xyplot
xyplot(freq~count|sample, data=Yeast, xlab="Number of Cells", ylab="Frequency",
	horizontal=FALSE, origin=0, type="h", lwd=10)



cleanEx()
nameEx("ZeaMays")
### * ZeaMays

flush(stderr()); flush(stdout())

### Name: ZeaMays
### Title: Darwin's Heights of Cross- and Self-fertilized Zea May Pairs
### Aliases: ZeaMays
### Keywords: datasets nonparametric

### ** Examples

data(ZeaMays)

##################################
## Some preliminary exploration ##
##################################
boxplot(ZeaMays[,c("cross", "self")], ylab="Height (in)", xlab="Fertilization")

# examine large individual diff/ces
largediff <- subset(ZeaMays, abs(diff) > 2*sd(abs(diff)))
with(largediff, segments(1, cross, 2, self, col="red"))

# plot cross vs. self.  NB: unusual trend and some unusual points
with(ZeaMays, plot(self, cross, pch=16, cex=1.5))
abline(lm(cross ~ self, data=ZeaMays), col="red", lwd=2)

# pot effects ?
 anova(lm(diff ~ pot, data=ZeaMays))

##############################
## Tests of mean difference ##
##############################
# Wilcoxon signed rank test
# signed ranks:
with(ZeaMays, sign(diff) * rank(abs(diff)))
wilcox.test(ZeaMays$cross, ZeaMays$self, conf.int=TRUE, exact=FALSE)

# t-tests
with(ZeaMays, t.test(cross, self))
with(ZeaMays, t.test(diff))

mean(ZeaMays$diff)
# complete permutation distribution of diff, for all 2^15 ways of assigning
# one value to cross and the other to self (thx: Bert Gunter)
N <- nrow(ZeaMays)
allmeans <- as.matrix(expand.grid(as.data.frame(
                         matrix(rep(c(-1,1),N), nr =2))))  %*% abs(ZeaMays$diff) / N

# upper-tail p-value
sum(allmeans > mean(ZeaMays$diff)) / 2^N
# two-tailed p-value
sum(abs(allmeans) > mean(ZeaMays$diff)) / 2^N

hist(allmeans, breaks=64, xlab="Mean difference, cross-self",
	main="Histogram of all mean differences")
abline(v=c(1, -1)*mean(ZeaMays$diff), col="red", lwd=2, lty=1:2)

plot(density(allmeans), xlab="Mean difference, cross-self",
	main="Density plot of all mean differences")
abline(v=c(1, -1)*mean(ZeaMays$diff), col="red", lwd=2, lty=1:2)





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
