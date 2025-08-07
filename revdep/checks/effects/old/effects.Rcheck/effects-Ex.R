pkgname <- "effects"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('effects')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("effCoef")
### * effCoef

flush(stderr()); flush(stdout())

### Name: effCoef
### Title: Function to get coefficient estimates from regression models for
###   use in the effects package.
### Aliases: effCoef effCoef.default
### Keywords: models

### ** Examples

m1 <- lm(prestige ~ type + income + education, Duncan)
effCoef(m1)



cleanEx()
nameEx("effect")
### * effect

flush(stderr()); flush(stdout())

### Name: effect
### Title: Functions For Constructing Effect Displays
### Aliases: effect effect.default Effect Effect.default Effect.lm
###   Effect.multinom Effect.merMod Effect.mlm Effect.poLCA Effect.polr
###   Effect.svyglm allEffects allEffects.default
### Keywords: hplot models

### ** Examples

mod.cowles <- glm(volunteer ~ sex + neuroticism*extraversion,
                  data=Cowles, family=binomial)
eff.cowles <- allEffects(mod.cowles, xlevels=list(extraversion=seq(0, 24, 6)),
                   fixed.predictors=list(given.values=c(sexmale=0.5)))
eff.cowles
as.data.frame(eff.cowles[[2]])


# a nested model:

mod <- lm(log(prestige) ~ income:type + education, data=Prestige)

plot(Effect(c("income", "type"), mod, transformation=list(link=log, inverse=exp)),
     axes=list(y=list(lab="prestige")))


if (require(nnet)){
    mod.beps <- multinom(vote ~ age + gender + economic.cond.national +
                             economic.cond.household + Blair + Hague + Kennedy +
                             Europe*political.knowledge, data=BEPS)

    plot(Effect(c("Europe", "political.knowledge"), mod.beps,
                xlevels=list(Europe=1:11, political.knowledge=0:3),
                fixed.predictors=list(given.values=c(gendermale=0.5))),
         lines=list(col=c("blue", "red", "orange")),
         axes=list(x=list(rug=FALSE), y=list(style="stacked")))

}

if (require(MASS)){
    mod.wvs <- polr(poverty ~ gender + religion + degree + country*poly(age,3),
                    data=WVS)

    plot(Effect(c("country", "age"), mod.wvs),
         axes=list(y=list(style="stacked")))

}


mod.pres <- lm(prestige ~ log(income, 10) + poly(education, 3) + poly(women, 2),
               data=Prestige)
eff.pres <- allEffects(mod.pres, xlevels=50)
plot(eff.pres)
plot(eff.pres[1],
     axes=list(x=list(income=list(
             transform=list(trans=log10, inverse=function(x) 10^x),
             ticks=list(at=c(1000, 2000, 5000, 10000, 20000))
    ))))

if (require(nlme)){ # for gls()
    mod.hart <- gls(fconvict ~ mconvict + tfr + partic + degrees, data=Hartnagel,
                    correlation=corARMA(p=2, q=0), method="ML")
    plot(allEffects(mod.hart))
    detach(package:nlme)
}

if (require(lme4)){
    data(cake, package="lme4")
    fm1 <- lmer(angle ~ recipe * temperature + (1|recipe:replicate), cake,
                REML = FALSE)
    plot(Effect(c("recipe", "temperature"), fm1))
    if (any(grepl("pbkrtest", search()))) detach(package:pbkrtest)
    detach(package:lme4)
}



# mlm example
if (require(heplots)) {
    data(NLSY, package="heplots")
    mod <- lm(cbind(read,math) ~ income+educ, data=NLSY)
    eff.inc <- Effect("income", mod)
    plot(eff.inc)
    eff.edu <- Effect("educ", mod)
    plot(eff.edu, axes=list(x=list(rug=FALSE), grid=TRUE))
    detach(package:heplots)
}

# svyglm() example (adapting an example from the survey package)


# component + residual plot examples


#  artificial data

set.seed(12345)
x1 <- runif(500, -75, 100)
x2 <- runif(500, -75, 100)
y <- 10 + 5*x1 + 5*x2 + x1^2 + x2^2 + x1*x2 + rnorm(500, 0, 1e3)
Data <- data.frame(y, x1, x2)
mod.1 <- lm(y ~ poly(x1, x2, degree=2, raw=TRUE), data=Data)
# raw=TRUE necessary for safe prediction
mod.2 <- lm(y ~ x1*x2, data=Data)
mod.3 <- lm(y ~ x1 + x2, data=Data)

plot(Effect(c("x1", "x2"), mod.1, residuals=TRUE)) # correct model
plot(Effect(c("x1", "x2"), mod.2, residuals=TRUE)) # wrong model
plot(Effect(c("x1", "x2"), mod.3, residuals=TRUE)) # wrong model



cleanEx()
nameEx("effectsHexsticker")
### * effectsHexsticker

flush(stderr()); flush(stdout())

### Name: effectsHexsticker
### Title: View the Official Hex Sticker for the effects Package
### Aliases: effectsHexsticker
### Keywords: misc

### ** Examples

## Not run: 
##D effectsHexsticker()
## End(Not run)



cleanEx()
nameEx("effectsTheme")
### * effectsTheme

flush(stderr()); flush(stdout())

### Name: effectsTheme
### Title: Set the lattice Theme for Effect Plots
### Aliases: effectsTheme
### Keywords: utilities device

### ** Examples

## Not run: 
##D lattice::trellis.par.set(effectsTheme())
## End(Not run)



cleanEx()
nameEx("plot.effect")
### * plot.effect

flush(stderr()); flush(stdout())

### Name: plot.effects
### Title: Plots of Effects and Predictor Effects
### Aliases: plot.effect plot.effects plot.predictoreff
###   plot.predictorefflist plot.eff plot.effpoly plot.efflist
###   plot.mlm.efflist [.efflist levels2dates levels2dates.eff
###   levels2dates.effpoly
### Keywords: hplot models

### ** Examples

# also see examples in ?effect

# plot predictorEffects
mod <- lm(prestige ~ education + log(income)*type + women, Prestige)
plot(predictorEffects(mod, ~ income), axes=list(grid=TRUE))
plot(predictorEffects(mod, ~ income), lines=list(multiline=TRUE),
                                                 axes=list(grid=TRUE))
plot(predictorEffects(mod, ~ type), lines=list(multiline=TRUE),
                                                 axes=list(grid=TRUE),
                                                 confint=list(style="bars"))

mod.cowles <- glm(volunteer ~ sex + neuroticism*extraversion,
                  data=Cowles, family=binomial)
eff.cowles <- allEffects(mod.cowles, xlevels=list(extraversion=seq(0, 24, 6)))
eff.cowles
as.data.frame(eff.cowles[[2]]) # neuroticism*extraversion interaction

plot(eff.cowles, 'sex', axes=list(grid=TRUE,
                                  y=list(lab="Prob(Volunteer)"),
                                  x=list(rotate=90)),
                        lines=list(lty=0))

plot(eff.cowles, 'neuroticism:extraversion',
     axes=list(y=list(lab="Prob(Volunteer)",
        ticks=list(at=c(.1,.25,.5,.75,.9)))))

plot(Effect(c("neuroticism", "extraversion"), mod.cowles,
            se=list(type="Scheffe"),
            xlevels=list(extraversion=seq(0, 24, 6))),
     axes=list(y=list(lab="Prob(Volunteer)",
        ticks=list(at=c(.1,.25,.5,.75,.9)))))


if (require(nnet)){
    mod.beps <- multinom(vote ~ age + gender + economic.cond.national +
                             economic.cond.household + Blair + Hague + Kennedy +
                             Europe*political.knowledge, data=BEPS)

    plot(effect("Europe*political.knowledge", mod.beps,
                xlevels=list(political.knowledge=0:3),
                fixed.predictors=list(given.values=c(gendermale=0.5))),
         axes=list(y=list(style="stacked"), x=list(rug=FALSE), grid=TRUE),
         lines=list(col=c("blue", "red", "orange")))
}

if (require(MASS)){
    mod.wvs <- polr(poverty ~ gender + religion + degree + country*poly(age,3),
                    data=WVS)
    plot(effect("country*poly(age, 3)", mod.wvs))

}

mod.pres <- lm(prestige ~ log(income, 10) + poly(education, 3) + poly(women, 2),
               data=Prestige)
eff.pres <- allEffects(mod.pres)
plot(eff.pres[1],
     axes=list(x=list(income=list(transform=list(
         trans=log10, inverse=function(x) 10^x),
         ticks=list(at=c(1000, 2000, 5000, 10000, 20000))))))
         
mod <- lm(log(prestige) ~ income:type + education, data=Prestige)
p1 <- predictorEffects(mod, ~ income)
# log-scale for response
plot(p1, lines=list(multiline=TRUE)) 
# log-scale, with arithmetic tick marks
plot(p1, lines=list(multiline=TRUE), 
     axes=list(y=list(transform=list(trans=log, inverse = exp), 
                      lab="prestige", type="rescale")))
# arithmetic scale and tick marks, with other arguments
plot(p1, lines=list(multiline=TRUE), grid=TRUE,
     lattice=list(key.args=list(space="right", border=TRUE)),
     axes=list(y=list(transform=exp, lab="prestige")))
     
# plotting an effect with a date variable

data("airquality", package="datasets")
airquality$Date <- with(airquality, as.Date(paste("1973", Month, Day, sep="-"),
                                            format="%Y-%m-%d"))
airquality$Date.num <- as.numeric(airquality$Date)
m1.date <- lm(Ozone ~ Date.num + Solar.R + Wind + Temp, data=airquality)
eff.date.1 <- Effect("Date.num", m1.date)
plot(eff.date.1, axes=list(x=list(Date.num=list(lab="Date", 
    ticks=list(at=levels2dates(eff.date.1, "Date.num", "1970-01-01"))), 
    rotate=45)), main="Date Effect")
plot(eff.date.1, axes=list(x=list(Date.num=list(lab="Date", 
    ticks=list(at=levels2dates(eff.date.1, "Date.num", "1970-01-01", n=4))))), 
    main="Date Effect")

eff.date.df <- as.data.frame(eff.date.1)
eff.date.df$Date <- as.Date(eff.date.df$Date.num, origin="1970-01-01")
eff.date.df

m2.date <- lm(Ozone ~ Date.num*Temp + Solar.R + Wind, data=airquality)
eff.date.2 <- Effect(c("Date.num", "Temp"), m2.date, xlevels=6)
plot(eff.date.2, axes=list(x=list(Date.num=list(lab="Date", 
  ticks=list(at=levels2dates(eff.date.2, "Date.num", "1970-01-01", n=3))), 
  rotate=45)), main="Date Effect by Temperature")




cleanEx()
nameEx("predictorEffects")
### * predictorEffects

flush(stderr()); flush(stdout())

### Name: predictorEffects
### Title: Functions For Computing Predictor Effects
### Aliases: predictorEffect predictorEffect.poLCA predictorEffect.svyglm
###   predictorEffect.default predictorEffects predictorEffects.poLCA
###   predictorEffects.default
### Keywords: hplot models

### ** Examples

mod <- lm(prestige ~ type*(education + income) + women, Prestige)
plot(predictorEffect("income", mod))
plot(predictorEffects(mod, ~ education + income + women))

mod.cowles <- glm(volunteer ~ sex + neuroticism*extraversion, data=Cowles, family=binomial)
plot(predictorEffects(mod.cowles, xlevels=4))
plot(predictorEffect("neuroticism", mod.cowles, xlevels=list(extraversion=seq(5, 20, by=5))),
     axes=list(grid=TRUE,
               x=list(rug=FALSE),
               y=list(lab="Probability of Vounteering")),
     lines=list(multiline=TRUE), 
     type="response")
predictorEffects(mod.cowles, focal.levels=4, xlevels=4)

# svyglm() example (adapting an example from the survey package)



cleanEx()
nameEx("summary.effect")
### * summary.effect

flush(stderr()); flush(stdout())

### Name: summary.eff
### Title: Summarizing and Printing Effects
### Aliases: print.eff print.effpoly print.efflatent print.efflist
###   print.mlm.efflist print.summary.eff summary.eff summary.effpoly
###   summary.efflatent summary.efflist summary.mlm.efflist
###   as.data.frame.eff as.data.frame.effpoly as.data.frame.efflatent
###   as.data.frame.efflist vcov.eff
### Keywords: hplot models

### ** Examples


mod.cowles <- glm(volunteer ~ sex + neuroticism*extraversion,
                  data=Cowles, family=binomial)
eff.cowles <- predictorEffects(mod.cowles)
print(eff.cowles)
print(eff.cowles[["neuroticism"]], type="link")
summary(eff.cowles[["neuroticism"]], type="link")
as.data.frame(eff.cowles)
# covariance matrix of fitted values in linear predictor scale
vcov(eff.cowles[[1]]) 



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
