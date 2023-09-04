pkgname <- "latentnet"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('latentnet')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("as.mcmc.list.ergmm")
### * as.mcmc.list.ergmm

flush(stderr()); flush(stdout())

### Name: as.mcmc.list.ergmm
### Title: Convert an ERGMM Object to an MCMC list object for Diagnostics.
### Aliases: as.mcmc.list.ergmm as.mcmc.ergmm
### Keywords: debugging graphs manip

### ** Examples





cleanEx()
nameEx("control.ergmm")
### * control.ergmm

flush(stderr()); flush(stdout())

### Name: control.ergmm
### Title: Auxiliary for Controlling ERGMM Fitting
### Aliases: control.ergmm ergmm.control
### Keywords: graphs misc

### ** Examples






cleanEx()
nameEx("davis")
### * davis

flush(stderr()); flush(stdout())

### Name: davis
### Title: Southern Women Data Set (Davis) as a bipartite "network" object
### Aliases: davis
### Keywords: data

### ** Examples






cleanEx()
nameEx("ergmm")
### * ergmm

flush(stderr()); flush(stdout())

### Name: ergmm
### Title: Fit a Latent Space Random Graph Model
### Aliases: ergmm latent latentcluster
### Keywords: graphs

### ** Examples





cleanEx()
nameEx("ergmm.drawpie")
### * ergmm.drawpie

flush(stderr()); flush(stdout())

### Name: ergmm.drawpie
### Title: Draw a pie chart at a specified location.
### Aliases: ergmm.drawpie
### Keywords: graphs

### ** Examples


plot(c(0,sum(1:11))*2,c(-10,10),type="n",asp=1)
for(i in 1:10) ergmm.drawpie(c(sum(1:i)*2,0), radius=i, probs=1:(i+1))




cleanEx()
nameEx("gof.ergmm")
### * gof.ergmm

flush(stderr()); flush(stdout())

### Name: gof.ergmm
### Title: Conduct Goodness-of-Fit Diagnostics on a Exponential Family
###   Random Graph Mixed Model Fit
### Aliases: gof.ergmm gof
### Keywords: models

### ** Examples





cleanEx()
nameEx("mcmc.diagnostics.ergmm")
### * mcmc.diagnostics.ergmm

flush(stderr()); flush(stdout())

### Name: mcmc.diagnostics.ergmm
### Title: Conduct MCMC diagnostics on an ERGMM fit
### Aliases: mcmc.diagnostics.ergmm mcmc.diagnostics
### Keywords: debugging graphs hplot

### ** Examples






cleanEx()
nameEx("merge.ergmm")
### * merge.ergmm

flush(stderr()); flush(stdout())

### Name: merge.ergmm
### Title: Merge two or more replications of ERGMM fits
### Aliases: merge.ergmm
### Keywords: graphs models

### ** Examples






cleanEx()
nameEx("plot.ergmm")
### * plot.ergmm

flush(stderr()); flush(stdout())

### Name: plot.ergmm
### Title: Plotting Method for class ERGMM
### Aliases: plot.ergmm plot3d.ergmm
### Keywords: graphs hplot

### ** Examples





cleanEx()
nameEx("predict.ergmm")
### * predict.ergmm

flush(stderr()); flush(stdout())

### Name: predict.ergmm
### Title: Predicted Dyad Values for an ERGMM.
### Aliases: predict.ergmm
### Keywords: distribution graphs models

### ** Examples






cleanEx()
nameEx("simulate.ergmm")
### * simulate.ergmm

flush(stderr()); flush(stdout())

### Name: simulate.ergmm
### Title: Draw from the distribution of an Exponential Random Graph Mixed
###   Model
### Aliases: simulate.ergmm simulate simulate.ergmm.model
### Keywords: cluster datagen graphs models nonlinear nonparametric

### ** Examples


#
# Fit a short MCMC run: just the MCMC.
#
data(sampson)
gest <- ergmm(samplike ~ euclidean(d=2,G=3),
              control=ergmm.control(burnin=100,interval=5,sample.size=100),tofit="mcmc")
#
# Draw from the posterior
#
g.sim <- simulate(gest)
plot(g.sim)
#
# Draw from the first draw from the posterior
#
g.sim <- with(gest,simulate(model,par=sample[[1]],prior=prior))
plot(g.sim)



cleanEx()
nameEx("summary.ergmm")
### * summary.ergmm

flush(stderr()); flush(stdout())

### Name: summary.ergmm
### Title: ERGMM Fit Summaries
### Aliases: summary.ergmm print.summary.ergmm summary.ergmm.object
###   bic.ergmm
### Keywords: graphs models print

### ** Examples






cleanEx()
nameEx("tribes")
### * tribes

flush(stderr()); flush(stdout())

### Name: tribes
### Title: Read Highland Tribes
### Aliases: tribes
### Keywords: cluster graphs multivariate

### ** Examples






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
