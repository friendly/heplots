pkgname <- "Guerry"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('Guerry')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("Angeville")
### * Angeville

flush(stderr()); flush(stdout())

### Name: Angeville
### Title: Data from d'Angeville (1836) on the population of France
### Aliases: Angeville
### Keywords: datasets

### ** Examples

library(Guerry)
library(sp)
library(RColorBrewer)

data(Guerry)
data(gfrance)
data(Angeville)

gf <- gfrance     # the SpatialPolygonsDataFrame

# Add some Angeville variables, transform them to ranks
gf$Mortality       <- rank(Angeville$Mortality)
gf$Marriages       <- rank(Angeville$Marriages)
gf$Legit_births    <- rank(Angeville$Legit_births)
gf$Illeg_births    <- rank(Angeville$Illeg_births)
gf$Farmers         <- rank(Angeville$Farmers)
gf$Schoolchildren  <- rank(Angeville$Schoolchildren)

# plot them on map of France
my.palette <- rev(brewer.pal(n = 9, name = "PuBu"))
spplot(gf, 
       c("Mortality", "Marriages", "Legit_births",  "Illeg_births", "Farmers", "Schoolchildren"),
       names.attr = c("Mortality", "Marriages", "Legit_births",  
                      "Illeg_births", "Farmers", "Schoolchildren"),
       layout=c(3,2), 
       as.table=TRUE, 
       col.regions = my.palette, 
       cuts = 8, # col = "transparent",
       main="Angeville variables")





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

library(car)
data(Guerry)

# Is there a relation between crime and literacy?

# Plot personal crime rate vs. literacy, using data ellipses. 
#    Identify the departments that stand out
set.seed(12315)
with(Guerry,{
	dataEllipse(Literacy, Crime_pers,
		levels = 0.68,
  	ylim = c(0,40000), xlim = c(0, 80),
  	ylab="Pop. per crime against persons",
  	xlab="Percent who can read & write",
  	pch = 16,
  	grid = FALSE,
  	id = list(method="mahal", n = 8, labels=Department, location="avoid", cex=1.2),
  	center.pch = 3, center.cex=5,
  	cex.lab=1.5)
  # add a 95% ellipse
	dataEllipse(Literacy, Crime_pers,
		levels = 0.95, add=TRUE,
  	ylim = c(0,40000), xlim = c(0, 80),
  	lwd=2, lty="longdash",
  	col="gray",
  	center.pch = FALSE
  	)
  
  # add the LS line and a loess smooth.
  abline( lm(Crime_pers ~ Literacy), lwd=2)	
  lines(loess.smooth(Literacy, Crime_pers), col="red", lwd=3)
  }
  	)

# A corrgram to show the relations among the main moral variables
# Re-arrange variables by PCA ordering.

library(corrgram)
corrgram(Guerry[,4:9], upper=panel.ellipse, order=TRUE)




cleanEx()
nameEx("gfrance")
### * gfrance

flush(stderr()); flush(stdout())

### Name: gfrance
### Title: Map of France in 1830 with the Guerry data
### Aliases: gfrance
### Keywords: datasets spatial

### ** Examples

library(sp)
data(gfrance)
names(gfrance)  ## list @data variables
plot(gfrance)   ## just show the map outline

# Show basic choropleth plots of some of the variables
spplot(gfrance, "Crime_pers")

# use something like Guerry's pallete, where dark = Worse
my.palette <- rev(RColorBrewer::brewer.pal(n = 9, name = "PuBu"))
spplot(gfrance, "Crime_pers", col.regions = my.palette, cuts = 8)


spplot(gfrance, "Crime_prop")

# Note that spplot assumes all variables are on the same scale for comparative plots
# transform variables to ranks (as Guerry did)
 
## Not run: 
##D local({
##D   gfrance$Crime_pers <- rank(gfrance$Crime_pers)
##D   gfrance$Crime_prop <- rank(gfrance$Crime_prop)
##D   gfrance$Literacy <- rank(gfrance$Literacy)
##D   gfrance$Donations <- rank(gfrance$Donations)
##D   gfrance$Infants <- rank(gfrance$Infants)
##D   gfrance$Suicides <- rank(gfrance$Suicides)
##D    	
##D   spplot(gfrance, c("Crime_pers", "Crime_prop", "Literacy", "Donations", "Infants", "Suicides"), 
##D     layout=c(3,2), as.table=TRUE, main="Guerry's main moral variables")
##D }) 
## End(Not run)



cleanEx()
nameEx("gfrance85")
### * gfrance85

flush(stderr()); flush(stdout())

### Name: gfrance85
### Title: Map of France in 1830 with the Guerry data, excluding Corsica
### Aliases: gfrance85
### Keywords: datasets spatial

### ** Examples

data(gfrance85)
require(sp)
plot(gfrance85)   # plot the empty outline map

# extract some useful components
df <- data.frame(gfrance85)[,7:12]       # main moral variables
xy <- coordinates(gfrance85)             # department centroids
dep.names <- data.frame(gfrance85)[,6]
region.names <- data.frame(gfrance85)[,5]
col.region <- colors()[c(149,254,468,552,26)]

if (require(spdep)) {
  lw <- nb2listw(poly2nb(gfrance85))       # neighbors list
}

# plot the map showing regions by color with department labels
op <-par(mar=rep(0.1,4))
plot(gfrance85,col=col.region[region.names])
text(xy, labels=dep.names, cex=0.4)
par(op)





graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("propensity")
### * propensity

flush(stderr()); flush(stdout())

### Name: propensity
### Title: Distribution of crimes against persons at different ages
### Aliases: propensity
### Keywords: datasets

### ** Examples

data(propensity)
## maybe str(propensity) ; plot(propensity) ...



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
