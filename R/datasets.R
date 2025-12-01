

#' Adolescent Mental Health Data
#' 
#' This data was taken from the National Longitudinal Study of Adolescent
#' Health.  It is a cross-sectional sample of participants from grades 7--12,
#' described and analyzed by Warne (2014).
#' 
#' `depression` is the response to the question "In the last month, how
#' often did you feel depressed or blue?"
#' 
#' `anxiety` is the response to the question "In the last month, how often
#' did you have trouble relaxing?"
#' 
#' The responses for `depression` and `anxiety` were recorded on a
#' 5-point Likert scale, with categories `0="Never", 1="Rarely",
#' 2="Occasionally", 3="Often", 4="Every day"`
#' 
#' @name AddHealth
#' @docType data
#' @format A data frame with 4344 observations on the following 3 variables.
#' \describe{ 
#'   \item{`grade`}{an ordered factor with levels `7` <
#'       `8` < `9` < `10` < `11` < `12`}
#'   \item{`depression`}{a numeric vector} 
#'   \item{`anxiety`}{a numeric vector} 
#'   }
#' @source 
#' Warne, R. T. (2014). A primer on Multivariate Analysis of Variance
#' (MANOVA) for Behavioral Scientists.  
#' *Practical Assessment, Research & Evaluation*, 19 (1).
#' @keywords datasets
#' @concept MANOVA
#' @concept ordered
#' @examples
#' 
#' data(AddHealth)
#' 
#' if(require(dplyr) & require(ggplot2)) {
#' # find means & std.errors by grade
#' means <- AddHealth |>
#' group_by(grade) |>
#'   summarise(
#'     n = n(),
#'     dep_se = sd(depression, na.rm = TRUE) / sqrt(n),
#'     anx_se = sd(anxiety, na.rm = TRUE) / sqrt(n),
#'     depression = mean(depression),
#'     anxiety = mean(anxiety) ) |> 
#'   relocate(depression, anxiety, .after = grade) |>
#'   print()
#'   
#' # plot means with std.error bars
#' ggplot(data = means, aes(x = anxiety, y = depression, 
#' color = grade)) +
#'   geom_point(size = 3) +
#'   geom_errorbarh(aes(xmin = anxiety - anx_se, 
#'                      xmax = anxiety + anx_se)) +
#'   geom_errorbar(aes(ymin = depression - dep_se, 
#'                     ymax = depression + dep_se)) +
#'   geom_line(aes(group = 1), linewidth = 1.5) +
#'   geom_label(aes(label = grade), 
#'              nudge_x = -0.015, nudge_y = 0.02) +
#'   scale_color_discrete(guide = "none") +
#'   theme_bw(base_size = 15)
#' }
#' 
#' # fit mlm
#' AH.mod <- lm(cbind(anxiety, depression) ~ grade, data=AddHealth)
#' 
#' car::Anova(AH.mod)
#' summary(car::Anova(AH.mod))
#' 
#' heplot(AH.mod, hypotheses="grade.L", 
#'        fill=c(TRUE, FALSE),
#'        level = 0.4)
#' 
NULL



#' Adopted Children
#' 
#' Data are a subset from an observational, longitudinal, study on adopted
#' children.  Is child's intelligence related to intelligence of the biological
#' mother and the intelligence of the adoptive mother?
#' 
#' The child's intelligence was measured at age 2, 4, 8, and 13 for this
#' sample.  How does intelligence change over time, and how are these changes
#' related to intelligence of the birth and adoptive mother?
#' 
#' 
#' @name Adopted
#' @docType data
#' @format A data frame with 62 observations on the following 6 variables.
#' \describe{ 
#'   \item{`AMED`}{adoptive mother's years of education (proxy
#' for her IQ)} 
#'   \item{`BMIQ`}{biological mother's score on IQ test}
#'   \item{`Age2IQ`}{IQ of child at age 2} 
#'   \item{`Age4IQ`}{IQ of child at age 4} 
#'   \item{`Age8IQ`}{IQ of child at age 8}
#'   \item{`Age13IQ`}{IQ of child at age 13} 
#' }
#' @seealso \code{\link[Sleuth2]{ex1605}}
#' @references 
#' Friendly, M.  (2010). HE Plots for Repeated Measures Designs.
#' *Journal of Statistical Software*, 37(4), 1-40.
#' \doi{10.18637/jss.v037.i04}.
#' 
#' Skodak, M. and Skeels, H.M. (1949). A Final Follow-up Study of One Hundred
#' Adopted Children, 
#' *Journal of Genetic Psychology* **75**: 85--125.
#' 
#' @source 
#' Ramsey, F.L. and Schafer, D.W. (2002). *The Statistical Sleuth:
#' A Course in Methods of Data Analysis (2nd ed)*, Duxbury.
#' 
#' This data set is identical to \code{\link[Sleuth2]{ex1605}} in the
#' `Sleuth2` package.
#' @keywords datasets
#' @concept MMRA
#' @concept repeated
#' @examples
#' 
#' # Treat as multivariate regression problem
#' Adopted.mod <- lm(cbind(Age2IQ, Age4IQ, Age8IQ, Age13IQ) ~ AMED + BMIQ, 
#'                   data=Adopted)
#' Adopted.mod
#' 
#' 
#' require(car)
#' # test overall multivariate regression
#' print(linearHypothesis(Adopted.mod, c("AMED","BMIQ")), SSP=FALSE)
#' 
#' # show separate linear regressions
#' op <- par(mfcol=c(2,4), mar=c(4,4,1,1)+.1)
#' for (i in 3:6) {
#' 	dataEllipse(as.matrix(Adopted[,c(1,i)]),
#' 	            col="black", levels=0.68, ylim=c(70,140))
#' 	abline(lm(Adopted[,i] ~ Adopted[,1]), col="red", lwd=2)
#' 
#' 	dataEllipse(as.matrix(Adopted[,c(2,i)]),
#' 	            col="black", levels=0.68, ylim=c(70,140))
#' 	abline(lm(Adopted[,i] ~ Adopted[,2]), col="red", lwd=2)
#' 	abline(a=0,b=1, lty=1, col="blue")
#' }
#' par(op)
#' 
#' # between-S (MMReg) plots
#' heplot(Adopted.mod, hypotheses=list("Reg"=c("AMED", "BMIQ")),
#' 	main="IQ scores of adopted children: MMReg")
#' 
#' pairs(Adopted.mod, hypotheses=list("Reg"=c("AMED", "BMIQ")))
#' 
#' if(requireNamespace("rgl")){
#' heplot3d(Adopted.mod, hypotheses=list("Reg"=c("AMED", "BMIQ")),
#' 	col = c("red", "blue", "black", "gray"), wire=FALSE)
#' }
#' 
#' # Treat IQ at different ages as a repeated measure factor
#' # within-S models & plots
#' Age <- data.frame(Age=ordered(c(2,4,8,13)))
#' car::Anova(Adopted.mod, idata=Age, idesign=~Age, test="Roy")
#' 
#' # within-S plots
#' heplot(Adopted.mod, idata=Age, idesign=~Age, iterm="Age",
#' 	cex=1.25, cex.lab=1.4, fill=c(FALSE, TRUE),
#' 	hypotheses=list("Reg"=c("AMED", "BMIQ"))
#' 	)
#' 
#' 
NULL





#' Captive and maltreated bees
#' 
#' Pabalan, Davey and Packe (2000) studied the effects of captivity and
#' maltreatment on reproductive capabilities of queen and worker bees in a
#' complex factorial design.
#' 
#' Bees were placed in a small tube and either held captive (CAP) or shaken
#' periodically (MAL) for one of 5, 7.5, 10, 12.5 or 15 minutes, after which
#' they were sacrificed and two measures: ovarian development (`Iz`) and
#' ovarian reabsorption (`Iy`), were taken. A single control group was
#' measured with no such treatment, i.e., at time 0; there are n=10 per group.
#' 
#' The design is thus nearly a three-way factorial, with factors `caste`
#' (Queen, Worker), `treat` (CAP, MAL) and `time`, except that there
#' are only 11 combinations of Treatment and Time; we call these `trtime`
#' below.
#' 
#' Models for the three-way factorial design, using the formula
#' `cbind(Iz,Iy) ~ caste*treat*time` ignore the control condition at
#' `time==0`, where `treat==NA`.
#' 
#' To handle the additional control group at `time==0`, while separating
#' the effects of Treatment and Time, 10 contrasts can be defined for the
#' `trtime` factor in the model `cbind(Iz,Iy) ~ caste*trtime` See
#' `demo(bees.contrasts)` for details.
#' 
#' In the `heplot` examples below, the default `size="evidence"`
#' displays are too crowded to interpret, because some effects are so highly
#' significant.  The alternative effect-size scaling, `size="effect"`,
#' makes the relations clearer.
#' 
#' @name Bees
#' @docType data
#' @format A data frame with 246 observations on the following 6 variables.
#' \describe{ 
#'   \item{`caste`}{a factor with levels `Queen` `Worker`} 
#'   \item{`treat`}{a factor with levels `""` `CAP` `MAL`} 
#'   \item{`time`}{an ordered factor: time of treatment} 
#'   \item{`Iz`}{an index of ovarian development}
#'   \item{`Iy`}{an index of ovarian reabsorption} 
#'   \item{`trtime`}{a factor with levels `0` `CAP05` `CAP07` `CAP10`
#'       `CAP12` `CAP15` `MAL05` `MAL07` `MAL10`
#'       `MAL12` `MAL15`} 
#' }
#' @references 
#' Friendly, M. (2006). Data Ellipses, HE Plots and Reduced-Rank
#' Displays for Multivariate Linear Models: SAS Software and Examples
#' *Journal of Statistical Software*, **17**, 1-42.
#' 
#' @source 
#' Pabalan, N., Davey, K. G. & Packe, L. (2000). Escalation of
#' Aggressive Interactions During Staged Encounters in Halictus ligatus Say
#' (Hymenoptera: Halictidae), with a Comparison of Circle Tube Behaviors with
#' Other Halictine Species *Journal of Insect Behavior*, **13**,
#' 627-650.
#' @keywords datasets
#' @concept MANOVA
#' @examples
#' 
#' data(Bees)
#' require(car)
#' 
#' # 3-way factorial, ignoring 0 group
#' bees.mod <- lm(cbind(Iz,Iy) ~ caste*treat*time, data=Bees)
#' car::Anova(bees.mod)
#' 
#' op<-palette(c(palette()[1:4],"brown","magenta", "olivedrab","darkgray"))
#' heplot(bees.mod, 
#'     xlab="Iz: Ovarian development", 
#'     ylab="Iz: Ovarian reabsorption",
#' 		main="Bees: ~caste*treat*time")
#' 
#' heplot(bees.mod, size="effect",
#'     xlab="Iz: Ovarian development", 
#'     ylab="Iz: Ovarian reabsorption",
#'     main="Bees: ~caste*treat*time", 
#'     )
#' 
#' # two-way design, using trtime
#' bees.mod1 <- lm(cbind(Iz,Iy) ~ caste*trtime, data=Bees)
#' Anova(bees.mod1)
#' 
#' # HE plots for this model, with both significance and effect size scaling
#' 
#' heplot(bees.mod1, 
#'     xlab="Iz: Ovarian development", 
#'     ylab="Iz: Ovarian reabsorption",
#' 		main="Bees: ~caste*trtime")
#' heplot(bees.mod1, 
#'     xlab="Iz: Ovarian development", 
#'     ylab="Iz: Ovarian reabsorption",
#'     main="Bees: ~caste*trtime",
#'     size="effect")
#' palette(op)
#' 
#' # effect plots for separate responses
#' if(require(effects)) {
#' 	bees.lm1 <-lm(Iy ~ treat*caste*time, data=Bees)
#' 	bees.lm2 <-lm(Iz ~ treat*caste*time, data=Bees)
#' 	
#' 	bees.eff1 <- allEffects(bees.lm1)
#' 	plot(bees.eff1,multiline=TRUE,ask=FALSE)
#' 	
#' 	bees.eff2 <- allEffects(bees.lm2)
#' 	plot(bees.eff2,multiline=TRUE,ask=FALSE)
#' }
#' 
#' 
NULL





#' Diabetes Dataset
#' 
#' Reaven and Miller (1979) examined the relationship among blood chemistry
#' measures of glucose tolerance and insulin in 145 nonobese adults. They used
#' the PRIM9 system at the Stanford Linear Accelerator Center to visualize the
#' data in 3D, and discovered a peculiar pattern that looked like a large blob
#' with two wings in different directions.
#' 
#' After further analysis, the subjects were classified as subclinical
#' (chemical) diabetics, overt diabetics and normals.  This study was
#' influential in defining the stages of development of Type 2 diabetes. Overt
#' diabetes is the most advanced stage, characterized by elevated fasting blood
#' glucose concentration and classical symptoms. Preceding overt diabetes is
#' the latent or chemical diabetic stage, with no symptoms of diabetes but
#' demonstrable abnormality of oral or intravenous glucose tolerance.
#' 
#' `glutest` was defined as the "area under the plasma glucose curve for
#' the three hour oral glucose tolerance test."  Reaven & Miller refer to this
#' variable as "Glucose area".
#' 
#' `instest` was defined as the "area under the plasma insulin curve", and
#' is referred to in the paper as "Insulin area".
#' 
#' This study was influential in defining the stages of development of Type 2
#' diabetes. Overt diabetes is the most advanced stage, characterized by
#' elevated fasting blood glucose concentration and classical symptoms.
#' Preceding overt diabetes is the latent or chemical diabetic stage, with no
#' symptoms of diabetes but demonstrable abnormality of oral or intravenous
#' glucose tolerance.
#' 
#' @name Diabetes
#' @docType data
#' @format A data frame with 145 observations on the following 6 variables.
#' \describe{ 
#'   \item{`relwt`}{relative weight, expressed as the ratio of actual weight to expected weight, given the person's height, a numeric vector} 
#'   \item{`glufast`}{fasting plasma glucose level, a numeric vector} 
#'   \item{`glutest`}{test plasma glucose level, a measure of glucose intolerance, a numeric vector} 
#'   \item{`instest`}{plasma insulin during test, a measure of insulin response to oral glucose, a numeric vector} 
#'   \item{`sspg`}{steady state plasma glucose, a measure of insulin resistance, a numeric vector} 
#'   \item{`group`}{diagnostic group, a factor with levels `Normal` `Chemical_Diabetic`
#'       `Overt_Diabetic`} 
#' }
#' @references 
#' Reaven, G. M. and Miller, R. G. (1979).  An attempt to define
#' the nature of chemical diabetes using a multidimensional analysis.
#' *Diabetologia*, 16, 17-24.
#' @source 
#' Andrews, D. F. & Herzberg, A. M. (1985).  
#' *Data: A Collection
#' of Problems from Many Fields for the Student and Research Worker*,
#' Springer-Verlag, Ch. 36.
#' 
#' Friendly, M. (1991). *SAS System for Statistical Graphics*, Cary, NC:
#' SAS Institute.
#' @keywords datasets
#' @concept MANOVA
#' @examples
#' 
#' data(Diabetes)
#' col <- c("blue", "red", "darkgreen")[Diabetes$group]
#' pch <- c(16,15,17)[Diabetes$group]
#' 
#' # a perplexing plot, similar to Fig 2, but with a loess smooth 
#' plot(instest ~ glutest, data=Diabetes, pch=16,
#' 	cex.lab=1.25,
#' 	xlab="Glucose area (glutest)",
#' 	ylab="Insulin area (instest)")
#' lines( loess.smooth(Diabetes$glutest, Diabetes$instest), col="blue", lwd=2) 
#' 
#' # scatterplot matrix, colored by group
#' plot(Diabetes[,1:5], col=col, pch=pch)
#' 
#' # covariance ellipses
#' covEllipses(Diabetes[,2:5], Diabetes$group, fill=TRUE, pooled=FALSE, 
#' 	col=col)
#' 
#' covEllipses(Diabetes[,2:5], Diabetes$group, fill=TRUE, pooled=FALSE, 
#' 	col=col, variables=1:4)
#' 
#' # Box's M test
#' diab.boxm <- boxM(Diabetes[,2:5], Diabetes$group)
#' diab.boxm
#' plot(diab.boxm)
#' 
#' # heplots
#' diab.mlm <- lm(cbind(glufast, glutest, instest, sspg) ~ group, data=Diabetes)
#' 
#' heplot(diab.mlm)
#' pairs(diab.mlm, fill=TRUE, fill.alpha=0.1)
#' 
#' 
#' 
NULL





#' Head measurements of football players
#' 
#' Data collected as part of a preliminary study examining the relation between
#' football helmet design and neck injuries. There are 30 subjects in each of
#' three groups: High school football players, college players and non-football
#' players.
#' 
#' 
#' @name FootHead
#' @docType data
#' @format A data frame with 90 observations on the following 7 variables.
#' \describe{ 
#'   \item{`group`}{a factor with levels `High school` `College` `Non-football`} 
#'   \item{`width`}{a numeric vector: head width at widest dimension} 
#'   \item{`circum`}{a numeric vector: head circumference} 
#'   \item{`front.back`}{a numeric vector: front to back distance at eye level} 
#'   \item{`eye.top`}{a numeric vector: eye to top of head} 
#'   \item{`ear.top`}{a numeric vector:ear to top of head}
#'   \item{`jaw`}{a numeric vector: jaw width} 
#' }
#' @source 
#' Rencher, A. C. (1995), *Methods of Multivariate Analysis*, New
#' York: Wiley, Table 8.3.
#' @keywords datasets
#' @concept MMRA
#' @concept contrasts
#' @examples
#' 
#' data(FootHead)
#' str(FootHead)
#' require(car)
#' 
#' # use Helmert contrasts for group
#' contrasts(FootHead$group) <- contr.helmert
#' contrasts(FootHead$group)
#' 
#' foot.mod <- lm(cbind(width, circum,front.back,eye.top,ear.top,jaw) ~ group, 
#'                data=FootHead)
#' Manova(foot.mod)
#' 
#' # show the HE plot for the first two variables
#' heplot(foot.mod, main="HE plot for width and circumference", fill=TRUE,
#' 	col=c("red", "blue"))
#' 
#' # show it with tests of Helmert contrasts
#' heplot(foot.mod, hypotheses=list("group.1"="group1","group.2"="group2"),
#' 	col=c("red", "blue", "green3", "green3" ),
#' 	main="HE plot with orthogonal Helmert contrasts")
#' 
#' # show all pairwise HE plots
#' pairs(foot.mod)
#' 
#' # ... with tests of Helmert contrasts
#' pairs(foot.mod, hypotheses=list("group.1"="group1","group.2"="group2"),
#' 	col=c("red", "blue", "green3", "green3"), hyp.labels=FALSE)
#' 
#' # see that the hypothesis for groups really is 2D
#' if(requireNamespace("rgl")){
#' heplot3d(foot.mod, variables=c(1,2,6),
#' 	hypotheses=list("group.1"="group1","group.2"="group2"),
#' 	col=c("red", "blue", "green3", "green3" ), wire=FALSE)
#' }
#' 
NULL





#' Treatment of Headache Sufferers for Sensitivity to Noise
#' 
#' A study was conducted investigating the effectiveness of different kinds of
#' psychological treatment on the sensitivity of headache sufferers to noise,
#' described in Hand and Taylor (1987), Study E.
#' 
#' In a pre-post design, 98 patients were first assessed for the volume of
#' noise which they found uncomfortable (U) and definitely uncomfortable (DU).
#' They were then given relaxation training, where they listened to the noise
#' at the DU level and given instruction breathing techniques and the use of
#' visual imagery to distract them from discomfort.  One of four treatments was
#' then applied, and all patients were reassessed for the noise volume they
#' considered uncomfortable (U) and definitely uncomfortable (DU).
#' 
#' The treatments are described as follows: 
#' \describe{
#'   \item{`T1`}{Listened again to the tone at their initial DU level, for
#'          the same amount of time they were able to tolerate it before.}
#'   \item{`T2`}{Same as T1, with one additional minute exposure}
#'   \item{`T3`}{Same as T2, but were explicitly instructed to use the
#'         relaxation techniques} 
#'   \item{`Control`}{These subject experienced no
#'         further exposure to the noise tone until the final sensitivity measures were taken} 
#' }
#' 
#' Hand and Taylor described several substantive hypotheses related to the
#' differences among treatments. In the `Headache` data frame, these have
#' been included as `contrasts(Headache$treatment)`
#' 
#' @name Headache
#' @docType data
#' @format A data frame with 98 observations on the following 6 variables.
#' \describe{ 
#'   \item{`type`}{Type of headache, a factor with levels `Migrane` `Tension`} 
#'   \item{`treatment`}{Treatment group, a factor with levels `T1` `T2` `T3` 
#'       `Control`.  See Details} 
#'   \item{`u1`}{Noise level rated as Uncomfortable, initial measure} 
#'   \item{`du1`}{Noise level rated as Definitely Uncomfortable, initial measure} 
#'   \item{`u2`}{Noise level rated as Uncomfortable, final measure} 
#'   \item{`du2`}{Noise level rated as Definitely Uncomfortable, final measure} 
#' }
#' @source 
#' D. J. Hand and C. C. Taylor (1987). *Multivariate analysis of
#' variance and repeated measures: a practical approach for behavioural
#' scientists* London: Chapman and Hall. ISBN: 0412258005. Table E.1.
#' 
#' @keywords datasets
#' @concept MANOVA
#' @concept repeated
#' @examples
#' 
#' library(car)
#' data(Headache)
#' str(Headache)
#' 
#' # basic MLM, specifying between-S effects
#' headache.mod <- lm(cbind(u1, du1, u2, du2) ~ type * treatment, data=Headache)
#' 
#' ##############################
#' ## between-S tests
#' ##############################
#' Anova(headache.mod, test="Roy")
#' 
#' # test each contrast separately
#' print(linearHypothesis(headache.mod, hypothesis="treatment1", test="Roy"), SSP=FALSE)
#' print(linearHypothesis(headache.mod, hypothesis="treatment2", test="Roy"), SSP=FALSE)
#' print(linearHypothesis(headache.mod, hypothesis="treatment3", test="Roy"), SSP=FALSE)
#' 
#' 
#' heplot(headache.mod, variables=c(1,3),
#' 	hypotheses=paste("treatment", 1:3, sep=""),
#' 	hyp.labels=c("extra.exp", "no.inst", "explicit.inst"),
#' 	xlab="u1: Initial sensitivity", ylab="u2: Final sensitivity",
#' 	main="Headache data: Unpleasant levels")
#' abline(0, 1, lty=5, col="gray")
#' 
#' heplot(headache.mod, variables=c(2,4),
#' 	hypotheses=paste("treatment", 1:3, sep=""),
#' 	xlab="du1: Initial sensitivity", ylab="du2: Final sensitivity",
#' 	main="Headache data: Definitely Unpleasant levels")
#' abline(0, 1, lty=5, col="gray")
#' 
#' pairs(headache.mod)
#' 
#' ##############################
#' # between-S and within-S tests
#' ##############################
#' idata = expand.grid(level=factor(c("U", "DU")), phase=factor(1:2))
#' Anova(headache.mod, idata=idata, idesign=~level*phase)
#' 
#' 
NULL




#' Recovery from Elective Herniorrhaphy
#' 
#' A data set on measures of post-operative recovery of 32 patients undergoing
#' an elective herniorrhaphy operation, in relation to pre-operative measures.
#' 
#' `leave`, `nurse` and `los` are outcome measures; the
#' remaining variables are potential predictors of recovery status.
#' 
#' The variable `nurse` is recorded as 1-4, with remaining (20) entries
#' entered as "-" in both sources.  It is not clear whether this means "none"
#' or NA.  The former interpretation was used in constructing the R data frame,
#' so `nurse==5` for these observations. Using
#' `Hernior$nurse[Hernior$nurse==5] <- NA` would change to the other
#' interpretation, but render `nurse` useless in a multivariate analysis.
#' 
#' The ordinal predictors could instead be treated as factors, and there are
#' also potential interactions to be explored.
#' 
#' @name Hernior
#' @docType data
#' @format A data frame with 32 observations on the following 9 variables.
#' \describe{ 
#'   \item{`age`}{patient age} 
#'   \item{`sex`}{patient sex, a factor with levels `f` `m`} 
#'   \item{`pstat`}{physical status (ignoring that associated with the operation). 
#'       A 1-5 scale, with 1=perfect health, 5=very poor health.} 
#'   \item{`build`}{body build, a 1-5 scale, with 1=emaciated, 2=thin, 3=average, 4=fat, 5=obese.}
#'   \item{`cardiac`}{preoperative complications with heart, 1-4 scale, with 1=none, 2=mild, 3=moderate, 4=severe.} 
#'   \item{`resp`}{preoperative complications with respiration, 1-4 scale, with 1=none, 2=mild, 
#'       3=moderate, 4=severe.} 
#'   \item{`leave`}{condition upon leaving the recovery room, a 1-4 scale, with 1=routine recovery, 2=intensive care for observation
#'       overnight, 3=intensive care, with moderate care required, 4=intensive care,
#'       with moderate care required.  } 
#'   \item{`los`}{length of stay in hospital after operation (days)}
#'   \item{`nurse`}{level of nursing required one week after operation, a
#'       1-5 scale, with 1=intense, 2=heavy, 3=moderate, 4=light, 5=none (?); see Details}
#' }
#' 
#' @references 
#' Hand, D. J., Daly, F., Lunn, A. D., McConway, K. J. and
#' Ostrowski, E. (1994), *A Handbook of Small Data Sets*, Number 484,
#' 390-391.
#' 
#' @source 
#' Mosteller, F. and Tukey, J. W. (1977), *Data analysis and
#' regression*, Reading, MA: Addison-Wesley. Data Exhibit 8, 567-568. Their
#' source: A study by B. McPeek and J. P. Gilbert of the Harvard Anesthesia
#' Center.
#' @keywords datasets
#' @concept MMRA
#' @concept candisc
#' @examples
#' 
#' library(car)
#' data(Hernior)
#' str(Hernior)
#' Hern.mod <- lm(cbind(leave, nurse, los) ~ 
#'                age + sex +  pstat +  build + cardiac + resp, data=Hernior)
#' car::Anova(Hern.mod, test="Roy") # actually, all tests are identical
#' 
#' # test overall regression
#' print(linearHypothesis(Hern.mod, c("age", "sexm", "pstat", "build", "cardiac", "resp")), SSP=FALSE)
#' 
#' # joint test of age, sex & caridac
#' print(linearHypothesis(Hern.mod, c("age", "sexm", "cardiac")), SSP=FALSE)
#' 
#' # HE plots
#' clr <- c("red", "darkgray", "blue", "darkgreen", "magenta", "brown", "black")
#' heplot(Hern.mod, col=clr)
#' pairs(Hern.mod, col=clr)
#' 
#' ## Enhancing the pairs plot ...
#' # create better variable labels
#' vlab <- c("LeaveCondition\n(leave)", 
#'           "NursingCare\n(nurse)", 
#'           "LengthOfStay\n(los)")
#' # Add ellipse to test all 5 regressors simultaneously
#' hyp <- list("Regr" = c("age", "sexm", "pstat", "build", "cardiac", "resp"))
#' pairs(Hern.mod, hypotheses=hyp, col=clr, var.labels=vlab)
#' 
#' ## Views in canonical space for the various predictors
#' if (require(candisc)) {
#' 	Hern.canL <- candiscList(Hern.mod)
#' 	plot(Hern.canL, term="age")
#' 	plot(Hern.canL, term="sex")
#' 	plot(Hern.canL, term="pstat")  # physical status
#' }
#' 
#' 
NULL





#' Personality Traits of Cultural Groups
#' 
#' This dataset, from Grice & Iwasaki (2007), gives scores on the five
#' personality scales of the NEO PI-r (Costa & McCrae, 1992), called the "Big
#' Five" personality traits: Neuroticism, Extraversion, Openness-to-Experience,
#' Agreeableness, and Conscientiousness.
#' 
#' The groups are: 
#' \describe{ 
#'   \item{Eur}{European Americans (Caucasians living in the United States their entire lives)} 
#'   \item{Asian_Amer}{Asian Americans (Asians living in the United States since before the age of 6 years)}
#'   \item{Asian_Intl}{Asian Internationals (Asians who moved to the United States after their 6th birthday)} 
#' }
#' 
#' The factor `Group` is set up to compare E vs. Asian and the two Asian
#' groups
#' 
#' @name Iwasaki_Big_Five
#' @docType data
#' @format A data frame with 203 observations on the following 7 variables.
#' \describe{ 
#'   \item{`ID`}{ID number} 
#'   \item{`Group`}{a factor with
#'         levels `Eur` `Asian_Amer` `Asian_Intl`}
#'   \item{`N`}{Neuroticism score} 
#'   \item{`E`}{Extraversion score}
#'   \item{`O`}{Openness score} 
#'   \item{`A`}{Agreeableness score}
#'   \item{`C`}{Conscientiousness score} 
#' }
#' @references 
#' Costa Jr, P. T., & McCrae, R. R. (1992).  *Revised NEO
#' Personality Inventory (NEO PI-R) and NEO Five-Factor Inventory (NEOFFI)
#' professional manual*.  Psychological Assessment Resources.
#' 
#' @source 
#' Grice, J., & Iwasaki, M. (2007). A truly multivariate approach to
#' MANOVA.  *Applied Multivariate Research*, **12**, 199-226.
#' https://doi.org/10.22329/amr.v12i3.660.
#' @keywords datasets
#' @concept MANOVA
#' @examples
#' 
#' data(Iwasaki_Big_Five)
#' # use Helmert contrasts for groups
#' contrasts(Iwasaki_Big_Five$Group) <- 
#'    matrix(c(2, -1, -1,
#'             0, -1,  1), ncol=2)
#'
#' str(Iwasaki_Big_Five)
#' 
#' Big5.mod <- lm(cbind(N, E, O, A, C) ~ Group, data=Iwasaki_Big_Five)
#' coef(Big5.mod)
#' 
#' car::Anova(Big5.mod)
#' 
#' # test contrasts
#' car::linearHypothesis(Big5.mod, "Group1", title = "Eur vs Asian")
#' car::linearHypothesis(Big5.mod, "Group2", title = "Asian: Amer vs Inter")
#' 
#' # heplots
#' labs <- c("Neuroticism", "Extraversion", "Openness", "Agreeableness", "Conscientiousness" )
#' 
#' heplot(Big5.mod,
#'        fill = TRUE, fill.alpha = 0.2, 
#'        cex.lab = 1.5,
#'        xlab = labs[1], ylab = labs[2])
#' 
#' heplot(Big5.mod, variables = c(2,5),
#'        fill = TRUE, fill.alpha = 0.2,
#'        cex.lab = 1.5,
#'        xlab = labs[2], ylab = labs[5])
#' 
#' pairs(Big5.mod, 
#'       fill = TRUE, fill.alpha = 0.2, var.labels = labs)
#' 
#'
#' # canonical discriminant analysis
#' if (require(candisc)) { 
#' library(candisc)
#' Big5.can <- candisc(Big5.mod)
#' Big5.can
#' heplot(Big5.can, fill = TRUE, fill.alpha = 0.1)
#' }

NULL





#' Math scores for basic math and word problems
#' 
#' Scores for two groups of school children taught by different math teachers
#' and tested for both basic math (BM) problems and solving word problems (WP).
#' 
#' 
#' @name mathscore
#' @docType data
#' @format A data frame with 12 observations on the following 3 variables.
#' 
#' \describe{ 
#'   \item{`group`}{a factor with levels `1` `2`}
#'   \item{`BM`}{Basic Math score, a numeric vector} 
#'   \item{`WP`}{Word Problems score, a numeric vector} 
#'   }
#' @source Fictitious data
#' @keywords datasets
#' @concept MANOVA
#' @examples
#' 
#' data(mathscore)
#' str(mathscore)
#' 
#' math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
#' car::Anova(math.mod)
#' 
#' # scatterplot with data ellipses
#' car::scatterplot(WP ~ BM | group, data=mathscore, 
#' 	ellipse=list(levels=0.68), smooth=FALSE, pch=c(15,16), 
#' 	legend=list(coords = "topright"))
#' 
#' # HE plot
#' heplot(math.mod, fill=TRUE, 
#'   cex=2, cex.lab=1.8,
#' 	xlab="Basic math", ylab="Word problems")
#' 
#' 
#' 
#' 
NULL




#' Effects Of Physical Attractiveness Upon Mock Jury Decisions
#' 
#' Male participants were shown a picture of one of three young women.  Pilot
#' work had indicated that the one woman was beautiful, another of average
#' physical attractiveness, and the third unattractive.  Participants rated the
#' woman they saw on each of twelve attributes.  These measures were used to
#' check on the manipulation by the photo.
#' 
#' Then the participants were told that the person in the photo had committed a
#' Crime, and asked to rate the seriousness of the crime and recommend a prison
#' sentence, in Years.
#' 
#' Does attractiveness of the "defendant" influence the sentence or perceived
#' seriousness of the crime?  Does attractiveness interact with the nature of
#' the crime?
#' 
#' 
#' @name MockJury
#' @docType data
#' @format A data frame with 114 observations on the following 17 variables.
#' \describe{ 
#'   \item{`Attr`}{Attractiveness of the photo, a factor with levels `Beautiful` `Average` `Unattractive`}
#'   \item{`Crime`}{Type of crime, a factor with levels `Burglary` (theft of items from victim's room) `Swindle` (conned a male victim)}
#'   \item{`Years`}{length of sentence given the defendant by the mock juror subject} 
#'   \item{`Serious`}{a rating of how serious the subject thought the defendant's crime was} 
#'   \item{`exciting`}{rating of the photo for 'exciting'} 
#'   \item{`calm`}{rating of the photo for 'calm'}
#'   \item{`independent`}{rating of the photo for 'independent'}
#'   \item{`sincere`}{rating of the photo for 'sincere'}
#'   \item{`warm`}{rating of the photo for 'warm'}
#'   \item{`phyattr`}{rating of the photo for 'physical attractiveness'}
#'   \item{`sociable`}{rating of the photo for 'exciting'}
#'   \item{`kind`}{rating of the photo for 'kind'}
#'   \item{`intelligent`}{rating of the photo for 'intelligent'}
#'   \item{`strong`}{rating of the photo for 'strong'}
#'   \item{`sophisticated`}{rating of the photo for 'sophisticated'}
#'   \item{`happy`}{rating of the photo for 'happy'}
#'   \item{`ownPA`}{self-rating of the subject for 'physical attractiveness'} 
#' }
#' @references 
#' Data from the thesis by Plaster, M. E. (1989). *Inmates as
#' mock jurors: The effects of physical attractiveness upon juridic decisions.*
#' M.A. thesis, Greenville, NC: East Carolina University.
#' 
#' 
#' @source 
#' Originally obtained from Dr. Wuensch's StatData page at East Carolina University. No longer exists.
#' % was: https://core.ecu.edu/wuenschk/StatData/PLASTER.dat
#' @keywords datasets
#' @concept MANOVA
#' @concept candisc
#' @examples
#' 
#' # manipulation check:  test ratings of the photos classified by Attractiveness
#' jury.mod1 <- lm( cbind(phyattr, happy, independent, sophisticated) ~ Attr, data=MockJury)
#' car::Anova(jury.mod1, test="Roy")
#' 
#' heplot(jury.mod1, main="HE plot for manipulation check")
#' pairs(jury.mod1)
#' 
#' if (require(candisc)) {
#' 	jury.can <- candisc(jury.mod1)
#' 	jury.can
#' 	heplot(jury.can, main="Canonical HE plot")
#' }
#' 
#' # influence of Attr of photo and nature of crime on Serious and Years
#' jury.mod2 <- lm( cbind(Serious, Years) ~ Attr * Crime, data=MockJury)
#' car::Anova(jury.mod2, test="Roy")
#' heplot(jury.mod2)
#' 
#' # stepdown test (ANCOVA), controlling for Serious
#' jury.mod3 <- lm( Years ~ Serious + Attr * Crime, data=MockJury)
#' car::Anova(jury.mod3)
#' 
#' # need to consider heterogeneous slopes?
#' jury.mod4 <- lm( Years ~ Serious * Attr * Crime, data=MockJury)
#' car::Anova(jury.mod3, jury.mod4)
#' 
#' 
NULL





#' Neurocognitive Measures in Psychiatric Groups
#' 
#' The primary purpose of the study (Hartman, 2016, Heinrichs et al. (2015))
#' was to evaluate patterns and levels of performance on neurocognitive
#' measures among individuals with schizophrenia and schizoaffective disorder
#' using a well-validated, comprehensive neurocognitive battery specifically
#' designed for individuals with psychosis (Heinrichs et al. (2008))
#' 
#' The main interest was in determining how well these measures distinguished
#' among all groups and whether there were variables that distinguished between
#' the schizophrenia and schizoaffective groups.
#' 
#' Neurocognitive function was assessed using the MATRICS Consensus Cognitive
#' Battery (MCCB; Nuechterlein et al., 2008). The MCCB consists of 10
#' individually administered tests that measure cognitive performance in seven
#' domains: speed of processing, attention/vigilance, working memory, verbal
#' learning, visual learning, reasoning and problem solving, and social
#' cognition.
#' 
#' The clinical sample comprised 116 male and female patients who met the
#' following criteria: 1) a diagnosis of schizophrenia (n = 70) or
#' schizoaffective disorder (n = 46) confirmed by the Structured Clinical
#' Interview for DSM-IV-TR Axis I Disorders; 2) outpatient status; 3) a history
#' free of developmental or learning disability; 4) age 18-65; 5) a history
#' free of neurological or endocrine disorder; and 6) no concurrent DSM-IV-TR
#' diagnosis of substance use disorder.
#' 
#' Non-psychiatric control participants (n = 146) were screened for medical and
#' psychiatric illness and history of substance abuse. Patients were recruited
#' from three outpatient clinics in Hamilton, Ontario, Canada. Control
#' participants were recruited through local newspaper and online classified
#' advertisements for paid research participation.
#' 
#' @name NeuroCog
#' @docType data
#' @format A data frame with 242 observations on the following 10 variables.
#' \describe{ 
#'   \item{`Dx`}{Diagnostic group, a factor with levels `Schizophrenia` `Schizoaffective` `Control`}
#'   \item{`Speed`}{Speed of processing domain T score, a numeric vector}
#'   \item{`Attention`}{Attention/Vigilance Domain T score, a numeric vector} 
#'   \item{`Memory`}{Working memory a numeric vector}
#'   \item{`Verbal`}{Verbal Learning Domain T score, a numeric vector}
#'   \item{`Visual`}{Visual Learning Domain T score, a numeric vector}
#'   \item{`ProbSolv`}{Reasoning/Problem Solving Domain T score, a numeric vector} 
#'   \item{`SocialCog`}{Social Cognition Domain T score, a numeric vector} 
#'   \item{`Age`}{Subject age, a numeric vector}
#'   \item{`Sex`}{Subject gender, a factor with levels `Female` `Male`} 
#' }
#' @references 
#' Heinrichs, R. W., Ammari, N., McDermid Vaz, S. & Miles, A.
#' (2008). Are schizophrenia and schizoaffective disorder neuropsychologically
#' distinguishable?  *Schizophrenia Research*, **99**, 149-154.
#' 
#' Nuechterlein K.H., Green M.F., Kern R.S., Baade L.E., Barch D., Cohen J.,
#' Essock S., Fenton W.S., Frese F.J., Gold J.M., Goldberg T., Heaton R., Keefe
#' R.S.E., Kraemer H., Mesholam-Gately R., Seidman L.J., Stover E., Weinberger
#' D.R., Young A.S., Zalcman S., Marder S.R. (2008) The MATRICS Consensus
#' Cognitive Battery, Part 1: Test selection, reliability, and validity.
#' *American Journal of Psychiatry*, **165** (2), 203-213.
#' <https://pubmed.ncbi.nlm.nih.gov/18172019/>.
#' 
#' @source 
#' Hartman, L. I. (2016). Schizophrenia and Schizoaffective Disorder:
#' One Condition or Two? Unpublished PhD dissertation, York University.
#' 
#' Heinrichs, R.W., Pinnock, F., Muharib, E., Hartman, L.I., Goldberg, J.O., &
#' McDermid Vaz, S. (2015).  Neurocognitive normality in schizophrenia
#' revisited.  
#' *Schizophrenia Research: Cognition*, **2** (4), 227-232.
#' `doi: 10.1016/j.scog.2015.09.001`
#' @keywords datasets
#' @concept MANOVA
#' @concept contrast
#' @concept candisc
#' @examples
#' 
#' library(car)
#' data(NeuroCog)
#' NC.mlm <- lm(cbind( Speed, Attention, Memory, Verbal, Visual, ProbSolv) ~ Dx,
#'                data=NeuroCog)
#' Anova(NC.mlm)
#' 
#' # test contrasts
#' contrasts(NeuroCog$Dx)
#' print(linearHypothesis(NC.mlm, "Dx1"), SSP=FALSE)
#' print(linearHypothesis(NC.mlm, "Dx2"), SSP=FALSE)
#' 
#' # pairwise HE plots
#' pairs(NC.mlm, var.cex=1.5)
#' 
#' # canonical discriminant analysis
#' if (require(candisc)) {
#'   NC.can <- candisc(NC.mlm)
#'   NC.can
#'   
#'   plot(NC.can, ellipse=TRUE, rev.axes=c(TRUE,FALSE), pch=c(7,9,10))
#' }
#' 
#' 
NULL





#' National Longitudinal Survey of Youth Data
#' 
#' The dataset `NLSY` comes from a small part of the National Longitudinal Survey of
#' Youth, which is a series of annual surveys conducted by the 
#' U.S. Department of Labor to examine the transition of young people into the labor force.
#' This particular subset gives measures of 243 children on mathematics and reading achievement and also
#' measures of behavioral problems (antisocial, hyperactivity). Also available are the yearly income
#' and education of the child's father.
#' 
#' @details
#' 
#' For the examples using this dataset, `math` and `read` scores are taken at the outcome
#' variables. Among the remaining predictors, `income` and `educ`
#' might be considered as background variables necessary to control for.
#' Interest might then be focused on whether the behavioral variables
#' `antisoc` and `hyperact` contribute beyond that.
#' 
#' The distribution of father's income is very highly skewed in the positive direction.
#' Linear model analysis should probably use `log(income)`, but this is omitted for simplicity.
#' 
#' The dataset also contains a few unusual observations for you to discover.
#' 
#' @name NLSY
#' @docType data
#' @format A data frame with 243 observations on the following 6 variables.
#' \describe{ 
#'   \item{`math`}{Math achievement test score}
#'   \item{`read`}{Reading achievement test score}
#'   \item{`antisoc`}{score on a measure of child's antisocial behavior, `0:6`} 
#'   \item{`hyperact`}{score on a measure of child's
#'         hyperactive behavior, `0:5`} \item{`income`}{yearly income of child's father} 
#'   \item{`educ`}{years of education of child's father} 
#' }
#' @source 
#' This dataset was derived from a larger one used by Patrick Curran at
#' the 1997 meeting of the Society for Research on Child Development (SRCD). A
#' description now only exists on the WayBack Machine,
#' <http://web.archive.org/web/20050404145001/http://www.unc.edu/~curran/example.html>.
#' 
#' More details are available at
#' <http://web.archive.org/web/20060830061414/http://www.unc.edu/~curran/srcd-docs/srcdmeth.pdf>.
#' @keywords datasets
#' @concept MMRA
#' @concept robust
#' @examples
#' 
#' library(car)
#' data(NLSY)
#' 
#' #examine the data
#' scatterplotMatrix(NLSY, smooth=FALSE)
#' 
#' # test control variables by themselves
#' # -------------------------------------
#' NLSY.mod1 <- lm(cbind(read, math) ~ income + educ, data=NLSY)
#' Anova(NLSY.mod1)
#' heplot(NLSY.mod1, fill=TRUE)
#' 
#' # test of overall regression
#' coefs <- rownames(coef(NLSY.mod1))[-1]
#' linearHypothesis(NLSY.mod1, coefs)
#' heplot(NLSY.mod1, fill=TRUE, hypotheses=list("Overall"=coefs))
#' 
#' # coefficient plot
#' coefplot(NLSY.mod1, fill = TRUE,
#'          col = c("darkgreen", "brown"),
#'          lwd = 2,
#'          ylim = c(-0.5, 3),
#'          main = "Bivariate coefficient plot for reading and math\nwith 95% confidence ellipses")
#' 
#'  
#' # additional contribution of antisoc + hyperact over income + educ
#' # ----------------------------------------------------------------
#' NLSY.mod2 <- lm(cbind(read,math) ~ antisoc + hyperact + income + educ, data=NLSY)
#' Anova(NLSY.mod2)
#' 
#' coefs <- rownames(coef(NLSY.mod2))[-1]
#' heplot(NLSY.mod2, fill=TRUE, hypotheses=list("Overall"=coefs, "mod2|mod1"=coefs[1:2]))
#' linearHypothesis(NLSY.mod2, coefs[1:2])
#' 
#' heplot(NLSY.mod2, fill=TRUE, hypotheses=list("mod2|mod1"=coefs[1:2]))
#' 
#' # check for outliers
#' idx <- cqplot(NLSY.mod2, id.n = 5)
#' idx
NULL




#' Oslo Transect Subset Data
#' 
#' The Oslo data set contains chemical concentrations of 332 samples of
#' different plant species collected along a 120 km transect running through
#' the city of Oslo, Norway. It is a subset of the
#' \code{\link[rrcov]{OsloTransect}} data provided by the `rrcov` package.
#' 
#' The \code{\link[rrcov]{OsloTransect}} contains 360 observations, with 9
#' observations per site. Only 7 chemical elements were retained from the 25
#' contained in the \code{\link[rrcov]{OsloTransect}} data, and these were all
#' log-transformed, following Todorov and Filzmoser (2009).
#' 
#' Only complete cases on these variables were retained, and two lithological
#' types of low frequency were removed, leaving 332 observations.
#' 
#' @name Oslo
#' @docType data
#' @format A data frame with 332 observations on the following 14 variables.
#' \describe{ 
#'   \item{`site`}{transect site ID, a factor with levels
#'      `102` `103` `104` `105` `106` `107` `108`
#'      `109` `111` `112` `113` `114` `115` `116`
#'      `117` `118` `119` `121` `122` `123` `124`
#'      `125` `126` `127` `128` `129` `131` `132`
#'      `133` `134` `135` `136` `138` `139` `141`
#'      `142` `143` `144`} 
#'   \item{`XC`}{X coordinate, a numeric vector} 
#'   \item{`YC`}{Y coordinate, a numeric vector}
#'   \item{`forest`}{forest type, a factor with levels `birspr`
#'       `mixdec` `pine` `sprbir` `sprpin` `spruce`}
#'   \item{`weather`}{weather type, a factor with levels `cloud`
#'       `moist` `nice` `rain`} \item{`litho`}{lithological
#'       type, a factor with levels `camsed` (Cambro-Silurian sedimentary),
#'      `gneis_o` (Precambrian gneisses - Oslo), `gneis_r` (- Randsfjord),
#'      `magm` (Magmatic rocks)} 
#'   \item{`altitude`}{altitude, a numeric vector} 
#'   \item{`Cu`}{Copper, a numeric vector} 
#'   \item{`Fe`}{Iron, a numeric vector} 
#'   \item{`K`}{Potassium, a numeric vector}
#'   \item{`Mg`}{Magnesium, a numeric vector} 
#'   \item{`Mn`}{Manganese, a numeric vector} 
#'   \item{`P`}{Lead, a numeric vector}
#'   \item{`Zn`}{Zinc, a numeric vector} 
#' }
#' @references 
#' Todorov V. and Filzmoser P. (2009) Robust statistic for the
#' one-way MANOVA, submitted to the *Journal of Environmetrics*.
#' 
#' @source 
#' Reimann, C., Arnoldussen, A., Boyd, R., Finne, T.E., Koller, F.,
#' Nordgulen, Oe., And Englmaier, P. (2007) Element contents in leaves of four
#' plant species (birch, mountain ash, fern and spruce) along anthropogenic and
#' geogenic concentration gradients, *The Science of the Total
#' Environment*, 377, 416-433.
#' @keywords datasets
#' @concept MANOVA
#' @concept candisc
#' @examples
#' 
#' data(Oslo)
#' table(Oslo$litho)
#' 
#' Oslo.mod <- lm(cbind(Cu, K, Mg, Mn, P, Zn) ~ litho, data=Oslo)
#' car::Anova(Oslo.mod)
#' 
#' heplot(Oslo.mod, var=c("Cu", "Mn"))
#' pairs(Oslo.mod)
#' 
#' \dontrun{
#' if(require(candisc)) {
#'   Oslo.can <- candisc(Oslo.mod)
#'   Oslo.can
#'   heplot(Oslo.can)
#'   if(requireNamespace("rgl")){
#'     heplot3d(Oslo.can, shade=TRUE, wire=FALSE, alpha=0.5, var.col="red")
#'   }
#' }
#' }
#' 
#' 
NULL


#' @name Overdose
#' @aliases Overdose
#' @docType data
#' @title
#' Overdose of Amitriptyline
#'
#' @description
#' Data on overdoses of the drug amitriptyline.
#' Amitriptyline is a drug prescribed by physicians as an antidepressant. However, there are also 
#' conjectured side effects that seem to be related to the use of the drug: irregular heart beat,
#' abnormal blood pressure and irregular waves on the electrocardiogram (ECG).
#' This dataset (originally from Rudorfer, 1982) gives data on 17 patients admitted to hospital after an overdose 
#' of amitriptyline.
#' The two response variables are: `TCAD` and `AMI`. The other variables are predictors.
#'
#' @usage data("Overdose")
#' @format
#'  A data frame with 17 observations on the following 7 variables.
#'  \describe{
#'    \item{`TCAD`}{total TCAD plasma level, a numeric vector}
#'    \item{`AMI`}{amount of amitriptyline present in the TCAD plasma level, a numeric vector}
#'    \item{`Gender`}{a factor with levels `Male` `Female`}
#'    \item{`amount`}{amount of drug taken at time of overdose, a numeric vector}
#'    \item{`BP`}{diastolic blood pressure, a numeric vector}
#'    \item{`ECG_PR`}{ECG PR wave measurement, a numeric vector}
#'    \item{`ECG_QRS`}{ECG QRS wave measurement, a numeric vector}
#'  }
#'
#' %% @details 
#' %%  ~~ If necessary, more details than the __description__ above ~~
#' @source 
#' Johnson & Wichern (2005), *Applied Multivariate Statistical Analysis*,
#' Exercise 7.25, p. 426.
#' @references
#' Rudorfer,  M. V. Cardiovascular changes and plasma drug levels after amitriptyline overdose. (1982).
#' *J. Toxicology - Clinical Toxicology*. **19**(1),67-78. 
#' \doi{10.3109/15563658208990367}, PMID: 7154142.
#' 
#' Clay Ford, "Getting started with Multivariate Multiple Regression",
#' <https://library.virginia.edu/data/articles/getting-started-with-multivariate-multiple-regression>.
#' 
#' ECG measurements:
#' \describe{
#'    \item{PR}{<https://en.wikipedia.org/wiki/PR_interval>}
#'    \item{QRS}{<https://en.wikipedia.org/wiki/QRS_complex>}
#' }
#' @concept MMRA
#' @concept cancor
#' 
#'
#' @examples
#' data(Overdose)
#' str(Overdose)
#' pairs(Overdose) 
#' 
#' over.mlm <- lm(cbind(TCAD, AMI) ~ Gender + amount + BP + ECG_PR + ECG_QRS, data = Overdose)
#' coef(over.mlm)
#' 
#' # check for outliers
#' cqplot(over.mlm)
#' 
#' # HE plot shows that relations of responses to predictors are essentially one-dimensional
#' heplot(over.mlm)
#'
#' # canonical correlation analysis 
#' if(require(candisc)) {
#' cancor(cbind(TCAD, AMI) ~ as.numeric(Gender) + amount + BP + ECG_PR + ECG_QRS, data = Overdose)
#' }
#'
#' @keywords datasets
NULL



#' Father Parenting Competence
#' 
#' The data, from an exercise given by Meyers et al. (2006) relates to 60
#' fathers assessed on three subscales of a Perceived Parenting Competence
#' Scale. The fathers were selected from three groups: (a) fathers of a child
#' with no disabilities; (b) fathers with a physically disabled child; (c)
#' fathers with a mentally disabled child.
#' 
#' The scores on the response variables are discrete.
#' 
#' @name Parenting
#' @docType data
#' @format A data frame with 60 observations on the following 4 variables.
#' \describe{ 
#'   \item{`group`}{a factor with levels `Normal`
#'       `Physical Disability` `Mental Disability`}
#'   \item{`caring`}{caretaking responsibilities, a numeric vector}
#'   \item{`emotion`}{emotional support provided to the child, a numeric vector} 
#'   \item{`play`}{recreational time spent with the child, a numeric vector} 
#' }
#' @source 
#' Meyers, L. S., Gamst, G, & Guarino, A. J. (2006). *Applied
#' Multivariate Research: Design and Interpretation*, Thousand Oaks, CA: Sage
#' Publications, <https://study.sagepub.com/meyers3e>, Exercises 10B.
#' @keywords datasets
#' @concept MANOVA
#' @examples
#' 
#' data(Parenting)
#' require(car)
#' 
#' # fit the MLM
#' parenting.mod <- lm(cbind(caring, emotion, play) ~ group, data=Parenting)
#' car::Anova(parenting.mod)
#' 
#' # Box's M test
#' boxM(parenting.mod)
#' plot(boxM(parenting.mod))
#' 
#' parenting.mod <- lm(cbind(caring, emotion, play) ~ group, data=Parenting)
#' car::Anova(parenting.mod)
#' # test contrasts
#' print(linearHypothesis(parenting.mod, "group1"), SSP=FALSE)
#' print(linearHypothesis(parenting.mod, "group2"), SSP=FALSE)
#' 
#' 
#' heplot(parenting.mod)
#' # display tests of contrasts
#' hyp <- list("N:MP" = "group1", "M:P" = "group2")
#' heplot(parenting.mod, hypotheses=hyp)
#' 
#' # make a prettier plot
#' heplot(parenting.mod, hypotheses=hyp, asp=1,
#'        fill=TRUE, fill.alpha=c(0.3,0.1), 
#'        col=c("red", "blue"), 
#'        lty=c(0,0,1,1), label.pos=c(1,1,3,2),
#'        cex=1.4, cex.lab=1.4, lwd=3)
#' 
#' pairs(parenting.mod, fill=TRUE, fill.alpha=c(0.3, 0.1))
#' 
#' \dontrun{
#' heplot3d(parenting.mod, wire=FALSE)
#' }
#' 
#' 
#' 
NULL





#' Plastic Film Data
#' 
#' An experiment was conducted to determine the optimal conditions for
#' extruding plastic film.  Three responses were measured in relation to two
#' factors, change in rate of extrusion and amount of an additive, both with two levels and \eqn{n=5} observations per cell.
#' 
#' 
#' @name Plastic
#' @docType data
#' @format A data frame with 20 observations on the following 5 variables.
#' \describe{ 
#'   \item{`tear`}{a numeric vector: tear resistance}
#'   \item{`gloss`}{a numeric vector: film gloss} 
#'   \item{`opacity`}{a numeric vector: film opacity} 
#'   \item{`rate`}{a factor representing change in the rate of extrusion with levels `Low` (-10%), `High` (10%)} 
#'   \item{`additive`}{a factor with levels `Low` (1.0%), `High` (1.5%)} 
#' }
#' @references 
#' Krzanowski, W. J. (1988). *Principles of Multivariate
#' Analysis. A User's Perspective*. Oxford.  (p. 381)
#' 
#' @source 
#' Johnson, R.A. & Wichern, D.W. (1992). *Applied Multivariate
#' Statistical Analysis*, 3rd ed., Prentice-Hall. Example 6.12 (p. 266).
#' @keywords datasets
#' @concept MANOVA
#' @examples
#' 
#' str(Plastic)
#' plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
#' car::Anova(plastic.mod)
#' 
#' pairs(plastic.mod)
#' 
NULL



#' Chemical Analysis of Romano-British Pottery
#' 
#' Results of chemical analyses of 48 specimens of Romano-British pottery
#' published by Tubb et al. (1980).  The numbers are the percentage of various
#' metal oxides found in each sample for elements of concentrations greater
#' than 0.01\%. This is the original data set from Tubb et al. (1980), in
#' contrast to \code{\link[carData]{Pottery}}.
#' 
#' The specimens are identified by their `rownames` in the data frame.
#' `Kiln` indicates at which kiln site the pottery was found; `Site`
#' gives the location names of those sites. The kiln sites come from three
#' `Region`s, `("Gl"=1, "Wales"=(2, 3), "NF"=(4, 5))`, where the full
#' names are "Gloucester", "Wales", and "New Forrest".
#' 
#' The variable `Kiln` comes pre-supplied with contrasts to test
#' interesting hypotheses related to `Site` and `Region`.
#' 
#' @name Pottery2
#' @docType data
#' @format A data frame with 48 observations on the following 12 variables.
#' \describe{ 
#'   \item{`Region`}{a factor with levels `Gl` `NF`
#'      `Wales`} 
#'   \item{`Site`}{a factor with levels `AshleyRails`
#'      `Caldicot` `Gloucester` `IsleThorns` `Llanedryn`}
#'   \item{`Kiln`}{a factor with levels `1` `2` `3` `4`
#'      `5`} 
#'   \item{`Al`}{amount of aluminum oxide, \eqn{Al_2O_3}}
#'   \item{`Fe`}{amount of iron oxide, \eqn{Fe_2O_3}}
#'   \item{`Mg`}{amount of magnesium oxide, MgO} 
#'   \item{`Ca`}{amount of calcium oxide, CaO} 
#'   \item{`Na`}{amount of sodium oxide, \eqn{Na_2O}} 
#'   \item{`K`}{amount of potassium oxide, \eqn{K_2O}}
#'   \item{`Ti`}{amount of titanium oxide, \eqn{TiO_2} }
#'   \item{`Mn`}{amount of manganese oxide, MnO} 
#'   \item{`Ba`}{amount of BaO} 
#' }
#' @seealso \code{\link[carData]{Pottery}} for the related (subset) data set;
#'     \code{\link[archdata]{RBPottery}} for a newer version with more variables.
#' 
#' @references Baxter, M. J. 2003. *Statistics in Archaeology*. Arnold,
#' London.
#' 
#' Carlson, David L. 2017. *Quantitative Methods in Archaeology Using R*.
#' Cambridge University Press, pp 247-255, 335-342.
#' 
#' Tubb, A., A. J. Parker, and G. Nickless. 1980.  The Analysis of
#' Romano-British Pottery by Atomic Absorption Spectrophotometry.
#' *Archaeometry*, **22**, 153-171.
#' 
#' @source Originally slightly modified from files by David Carlson, now at
#' \code{\link[archdata]{RBPottery}}. %
#' % <http://people.tamu.edu/~dcarlson/quant/data/RBPottery.html>
#' @keywords datasets
#' @concept MANOVA
#' @concept candisc
#' @examples
#' 
#' library(car)
#' data(Pottery2)
#' # contrasts for Kiln correspond to between Region [,1:2] and within Region [,3:4]
#' contrasts(Pottery2$Kiln)
#' 
#' pmod <-lm(cbind(Al,Fe,Mg,Ca,Na,K,Ti,Mn,Ba)~Kiln, data=Pottery2)
#' car::Anova(pmod)
#' 
#' # extract coefficient names for linearHypotheses
#' coefs <- rownames(coef(pmod))[-1]
#' 
#' # test differences among regions
#' linearHypothesis(pmod, coefs[1:2])
#' # test differences within regions B, C
#' linearHypothesis(pmod, coefs[3:4])
#' 
#' heplot(pmod, fill=c(TRUE,FALSE), hypotheses=list("Region" =coefs[1:2], "WithinBC"=coefs[3:4]))
#' 
#' # all pairwise views;  note that Ba shows no effect
#' pairs(pmod, fill=c(TRUE,FALSE))
#' 
#' # canonical view, via candisc::heplot
#' 
#' if (require(candisc)) {
#' 
#' # canonical analysis: how many dimensions?
#' (pcan <- candisc(pmod))
#' 
#' heplot(pcan, scale=18, fill=c(TRUE,FALSE), var.col="darkgreen", var.lwd=2, var.cex=1.5)
#' 
#' \dontrun{
#' heplot3d(pcan, scale=8)
#' }
#' }
#' 
#' 
NULL





#' Response Speed in a Probe Experiment
#' 
#' Data from a probe experiment testing whether immediate memory for sentences
#' is influenced by the phrase structure of the sentence.  The data sets come
#' from Timm (1975), Ex. 3.14 and Ex. 3.16 (p.244)
#' 
#' Procedure: Subjects listened to tape-recorded sentences.  Each sentence was
#' followed by a "probe word" from one of 5 positions within the sentence.  The
#' subject had to respond with the word which immediately followed the probe
#' word in the sentence.  The dependent measure is response speed =
#' k(1/reaction time).
#' 
#' Sample sentence: 
#' \preformatted{
#' *       The tall man met the young girl who got the new hat.
#' Pos'ns:      1    2            3    4    5
#' Function:   ADJ1 SUBJ        ADJ2  OBJ  REL.PN
#' }
#' 
#' In `Probe2`, there are two groups of subjects, pre-selected on a test
#' of short term memory.
#' 
#' These data sets (fictitious) are used as examples of single-sample and
#' two-sample profile analysis or simple repeated measure designs with
#' structured contrasts.
#' 
#' @name Probe
#' @aliases Probe Probe1 Probe2
#' @docType data
#' @format `Probe1`: A data frame with 11 observations on the following 5 variables.  
#' \describe{ 
#'   \item{`p1`}{speed at position 1}
#'   \item{`p2`}{speed at position 2} 
#'   \item{`p3`}{speed at position 3} 
#'   \item{`p4`}{speed at position 4} 
#'   \item{`p5`}{speed at position 5} 
#' }
#' 
#' `Probe2`: A data frame with 20 observations on the following 6 variables.  
#' \describe{ 
#'   \item{`stm`}{Short term memory capacity: a factor with levels `High` `Low`} 
#'   \item{`p1`}{speed at position 1} 
#'   \item{`p2`}{speed at position 2} 
#'   \item{`p3`}{speed at position 3} 
#'   \item{`p4`}{speed at position 4}
#'   \item{`p5`}{speed at position 5} 
#' }
#' @source Timm, N. (1975) *Multivariate analysis, with applications in
#' education and psychology* Brooks/Cole.
#' @keywords datasets
#' @concept MANOVA
#' @concept repeated
#' @concept contrasts
#' @examples
#' 
#' data(Probe1)
#' boxplot(Probe1)
#' 
#' pmod1 <- lm(cbind(p1,p2,p3,p4,p5) ~ 1, data=Probe1)
#' idata <- data.frame(position=factor(1:5))
#' 
#' library(car)
#' (pmod1.aov <- car::Anova(pmod1, idata=idata, idesign=~position))
#' 
#' # using default contrasts (p5 as reference level)
#' heplot(pmod1, manova=pmod1.aov, 
#'        iterm="position", 
#'        type="III", 
#'        idata=idata, idesign=~position)
#' pairs(pmod1, manova=pmod1.aov, 
#'        iterm="position", 
#'        type="III", 
#'        idata=idata, idesign=~position)
#' 
#' # contrasts for substantative hypotheses regarding
#' # sentence position effects
#' C <- matrix(c(
#' 	1, 1, -1, -1, 0,
#' 	1, -1, 1, -1, 0,
#' 	1, -1, -1, 1, 0,
#' 	1, 1, 1, 1, -4), 5, 4)
#' rownames(C) <- paste("p", 1:5, sep="")
#' colnames(C) <- c("SubPred", "AdjNoun", "SPxAN", "RelPN")
#' 
#' contrasts(idata$position)<- C
#' (pmod1.aov <- car::Anova(pmod1, idata=idata, idesign=~position))
#' 
#' heplot(pmod1, manova=pmod1.aov, 
#'        iterm="position", type="III", idata=idata, idesign=~position)
#' pairs(pmod1, manova=pmod1.aov, 
#'        iterm="position", type="III", idata=idata, idesign=~position)
#' 
#' 
NULL





#' Weight Gain in Rats Exposed to Thiouracil and Thyroxin
#' 
#' The data are from a study of weight gain, where investigators randomly
#' assigned 30 rats to three treatment groups: treatment 1 was a control (no
#' additive); treatments 2 and 3 consisted of two different additives
#' (thiouracil and thyroxin respectively) to the rats drinking water. Weight
#' was measured at baseline (week 0) and at weeks 1, 2, 3, and 4. Due to an
#' accident at the beginning of the study, data on 3 rats from the thyroxin
#' group are unavailable.
#' 
#' The `trt` factor comes supplied with contrasts comparing `Control`
#' to each of `Thiouracil` and `Thyroxin`.
#' 
#' @name RatWeight
#' @docType data
#' @format A data frame with 27 observations on the following 6 variables.
#' \describe{ 
#'   \item{`trt`}{a factor with levels `Control` `Thiouracil` `Thyroxin`} 
#'   \item{`wt0`}{Weight at Week 0 (baseline weight)} 
#'   \item{`wt1`}{Weight at Week 1}
#'   \item{`wt2`}{Weight at Week 2} 
#'   \item{`wt3`}{Weight at Week 3}
#'   \item{`wt4`}{Weight at Week 4} 
#' }
#' @references 
#' Box, G.E.P. (1950). Problems in the analysis of growth and wear
#' curves.  *Biometrics*, 6, 362-389.
#' 
#' Friendly, Michael (2010). HE Plots for Repeated Measures Designs.
#' *Journal of Statistical Software*, 37(4), 1-40. 
#' \doi{10.18637/jss.v037.i04}.
#' 
#' @source 
#' Originally from Box (1950), Table D (page 389), where the values for
#' weeks 1-4 were recorded as the gain in weight for that week.
#' 
#' Fitzmaurice, G. M. and Laird, N. M. and Ware, J. H (2004). *Applied
#' Longitudinal Analysis*, New York, NY: Wiley-Interscience.
#' <https://rdrr.io/rforge/ALA/>.
#' @keywords datasets
#' @concept MANOVA
#' @concept repeated
#' @examples
#' 
#' data(RatWeight)
#' contrasts(RatWeight$trt)
#' 
#' rat.mod <- lm(cbind(wt0, wt1, wt2, wt3, wt4) ~ trt, data=RatWeight)
#' rat.mod
#' 
#' idata <- data.frame(week = ordered(0:4))
#' car::Anova(rat.mod, idata=idata, idesign=~week, test="Roy")
#' 
#' # quick look at between group effects
#' pairs(rat.mod)
#' 
#' # between-S, baseline & week 4
#' heplot(rat.mod, col=c("red", "blue", "green3", "green3"),
#' 	variables=c(1,5),
#' 	hypotheses=c("trt1", "trt2"),
#' 	main="Rat weight data, Between-S effects") 
#' 
#' # within-S
#' heplot(rat.mod, idata=idata, idesign=~week, iterm="week",
#' 	col=c("red", "blue", "green3"),
#' #	hypotheses=c("trt1", "trt2"),
#' 	main="Rat weight data, Within-S effects")
#' 
#' 
NULL



#' Reaction Time Data
#' 
#' Data from Maxwell and Delaney (1990, p. 497) representing the reaction times
#' of 10 subjects in some task where visual stimuli are tilted at 0, 4, and 8
#' degrees; with noise absent or present.  Each subject responded to 3 tilt x 2
#' noise = 6 conditions.  The data thus comprise a repeated measure design with
#' two within-S factors.
#' 
#' 
#' @name ReactTime
#' @docType data
#' @format A data frame with 10 observations giving the reaction time for the 6
#' conditions.  
#' \describe{ 
#'   \item{`deg0NA`}{a numeric vector}
#'   \item{`deg4NA`}{a numeric vector} 
#'   \item{`deg8NA`}{a numeric vector} 
#'   \item{`deg0NP`}{a numeric vector} 
#'   \item{`deg4NP`}{a numeric vector} 
#'   \item{`deg8NP`}{a numeric vector} 
#' }
#' @references 
#' Michael Friendly (2010). HE Plots for Repeated Measures Designs.
#' *Journal of Statistical Software*, 37(4), 1-40. 
#' \doi{10.18637/jss.v037.i04}.
#' 
#' Maxwell, S. E. & Delaney, H. D. (1990).  *Designing Experiments and
#' Analyzing Data: A model comparison perspective*. Pacific Grove, CA:
#' Brooks/Cole.
#' 
#' @source Baron, J. and Li, Y. (2003).  *Notes on the use of R for
#' psychology experiments and questionnaires*,
#' <https://cran.r-project.org/doc/contrib/Baron-rpsych.pdf>
#' @keywords datasets
#' @concept repeated
#' @examples
#' 
#' data(ReactTime)
#' (RT.mod <- lm(as.matrix(ReactTime)~1))
#' 
#' # within-S factors
#' within <- expand.grid(tilt=ordered(c(0,4,8)), noise=c("NA", "NP"))
#' car::Anova(RT.mod, idata=within, idesign=~tilt * noise)
#' 
#' heplot(RT.mod, idata=within, idesign=~tilt * noise, iterm="tilt")
#' 
#' # plotting means and std errors directly
#' 
#' levels <- expand.grid(Tilt=c(0,4,8), noise=c("NA", "NP"))
#' (means.df <- data.frame(levels, mean=colMeans(ReactTime), se=sqrt(diag(var(ReactTime)))/9))
#' 
#' with(means.df, {
#' 	plot(Tilt, mean, type="n", main="Reaction Time data", xlab="Tilt", ylab="Reaction time")
#' 	colors <- rep(c("red", "blue"), each=3)
#' 	pts <- rep(c(15, 16), each=3)
#' 
#' 	lines(Tilt[1:3], mean[1:3], col="red", lwd=2)
#' 	lines(Tilt[4:6], mean[4:6], col="blue", lwd=2)
#' 	points(Tilt, mean, pch=pts, col=colors, cex=1.2)
#' 	arrows(Tilt, mean-se, Tilt, mean+se, angle=90, code=3, 
#' 			col=colors, len=.05, lwd=2)
#' 	# labels at last point, in lieu of legend
#' 	text(Tilt[3], mean[3]-10, labels="NA", col="red", pos=1)
#' 	text(Tilt[6], mean[6]-10, labels="NP", col="blue", pos=1)
#' 	}
#' 	)
#' 
NULL




#' Rohwer Data Set
#' 
#' Data from an experiment by William D. Rohwer on kindergarten children
#' designed to examine how well performance on a set of paired-associate (PA)
#' tasks can predict performance on some measures of aptitude and achievement.
#' 
#' The variables `SAT`, `PPVT` and `Raven` are responses to be
#' potentially explained by performance on the paired-associate (PA) learning
#' tasks, `n`, `s`, `ns`, `na`, and `ss`,
#' which differed in the syntactic and semantic relationship between the stimulus and response words in each pair.
#' 
#' @details
#' Timm (1975) does not give a source, but the most relevant studies are Rowher & Ammons (1968) and Rohwer & Levin (1971).
#' The paired-associate tasks are described as:
#' \describe{
#'    \item{`n`}{(named): Simple paired-associate task where participants learn pairs of nouns with no additional context}
#'    \item{`s`}{(sentence): Participants learn pairs embedded within a sentence}
#'    \item{`ns`}{(named sentence): A combination where participants learn noun pairs with sentence context}
#'    \item{`na`}{(named action): Pairs are learned with an action relationship between them}
#'    \item{`ss`}{(sentence still): Similar to the sentence condition but with static presentation}
#' }
#' 
#' @name Rohwer
#' @docType data
#' @format A data frame with 69 observations on the following 10 variables.
#' \describe{ 
#'   \item{`group`}{a numeric vector, corresponding to SES}
#'   \item{`SES`}{Socioeconomic status, a factor with levels `Hi` `Lo`} 
#'   \item{`SAT`}{a numeric vector: score on a Student Achievement Test} 
#'   \item{`PPVT`}{a numeric vector: score on the Peabody Picture Vocabulary Test} 
#'   \item{`Raven`}{a numeric vector: score on the Raven Progressive Matrices Test} 
#'   \item{`n`}{a numeric vector: performance on a 'named' PA task} 
#'   \item{`s`}{a numeric vector: performance on a 'still' PA task} 
#'   \item{`ns`}{a numeric vector: performance on a 'named still' PA task} 
#'   \item{`na`}{a numeric vector: performance on a 'named action' PA task} 
#'   \item{`ss`}{a numeric vector: performance on a 'sentence still' PA task} 
#' }
#' @references 
#' Friendly, M. (2007).  HE plots for Multivariate General Linear
#' Models.  *Journal of Computational and Graphical Statistics*,
#' **16**(2) 421--444.  <http://datavis.ca/papers/jcgs-heplots.pdf>
#' 
#' Rohwer, W.D., Jr., & Levin, J.R. (1968). Action, meaning and stimulus selection
#' in paired-associate learning. *Journal of Verbal Learning and Verbal Behavior*, **7**: 137-141.
#' 
#' Rohwer, W. D., Jr., & Ammons, M. S. (1971). Elaboration training and paired-associate learning efficiency in children. 
#' *Journal of Educational Psychology*, **62**(5), 376-383.

#' 
#' @source 
#' Timm, N.H. 1975).  *Multivariate Analysis with Applications in
#' Education and Psychology*.  Wadsworth (Brooks/Cole), Examples 4.3 (p. 281),
#' 4.7 (p. 313), 4.13 (p. 344).
#' @keywords datasets
#' @concept MMRA
#' @concept MANCOVA
#' @examples
#' 
#' str(Rohwer)
#' 
#' # Plot responses against each predictor
#' library(tidyr)
#' library(dplyr)
#' library(ggplot2)
#' 
#' yvars <- c("SAT", "PPVT", "Raven" )
#' xvars <- c("n", "s", "ns", "na", "ss")
#' Rohwer_long <- Rohwer %>%
#'   pivot_longer(cols = all_of(xvars), names_to = "xvar", values_to = "x") |>
#'   pivot_longer(cols = all_of(yvars), names_to = "yvar", values_to = "y") |>
#'   mutate(xvar = factor(xvar, xvars), yvar = factor(yvar, yvars))
#' 
#' ggplot(Rohwer_long, aes(x, y, color = SES, shape = SES, fill = SES)) +
#'   geom_point() +
#'   geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
#'   stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.1) +
#'   facet_grid(yvar ~ xvar, scales = "free") +
#'   labs(x = "predictor", y = "response") +
#'   theme_bw(base_size = 14)
#' 
#' 
#' ## ANCOVA, assuming equal slopes
#' rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, data=Rohwer)
#' car::Anova(rohwer.mod)
#' 
#' # Visualize the ANCOVA model
#' heplot(rohwer.mod)
#' # Add ellipse to test all 5 regressors
#' heplot(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
#' # View all pairs
#' pairs(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")))
#' 
#' # or 3D plot
#' \dontrun{
#' col <- c("red", "green3", "blue", "cyan", "magenta", "brown", "gray")
#' heplot3d(rohwer.mod, hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss")), 
#'                      col=col, wire=FALSE)
#' }
#' 
#' ## fit separate, independent models for Lo/Hi SES
#' rohwer.ses1 <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer, subset=SES=="Hi")
#' rohwer.ses2 <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, data=Rohwer, subset=SES=="Lo")
#' 
#' # overlay the separate HE plots
#' heplot(rohwer.ses1, ylim=c(40,110),col=c("red", "black"))
#' heplot(rohwer.ses2, add=TRUE, col=c("blue", "black"), grand.mean=TRUE, error.ellipse=TRUE)
#' 
#' 
NULL



#' Growth of Apple Trees from Different Root Stocks
#' 
#' In a classic experiment carried out from 1918 to 1934, growth of apple trees
#' of six different rootstocks were compared on four measures of size.
#' How do the measures of size vary with the type of rootstock?
#' 
#' This is a balanced, one-way MANOVA design, with n=8 trees for each
#' rootstock.
#' 
#' @name RootStock
#' @docType data
#' @format A data frame with 48 observations on the following 5 variables.
#' \describe{ 
#'   \item{`rootstock`}{a factor with levels `1` `2` `3` `4` `5` `6`} 
#'   \item{`girth4`}{a numeric vector: trunk girth at 4 years (mm x 100)} 
#'   \item{`ext4`}{a numeric vector: extension growth at 4 years (m)} 
#'   \item{`girth15`}{a numeric vector: trunk girth at 15 years (mm x 100)} 
#'   \item{`weight15`}{a numeric vector: weight of tree above ground at 15 years (lb x 1000)} 
#' }
#' @references 
#' Rencher, A. C. (1995). *Methods of Multivariate Analysis*.
#' New York: Wiley, Table 6.2
#' @source 
#' Andrews, D. and Herzberg, A. (1985). *Data: A Collection of
#' Problems from Many Fields for the Student and Research Worker*
#' Springer-Verlag, pp. 357--360.
#' @keywords datasets
#' @concept MANOVA
#' @concept contrasts
#' @examples
#' 
#' library(car)
#' data(RootStock)
#' str(RootStock)
#' 
#' root.mod <- lm(cbind(girth4, ext4, girth15, weight15) ~ rootstock, data=RootStock)
#' car::Anova(root.mod)
#' 
#' pairs(root.mod)
#' 
#' # test two orthogonal contrasts among the rootstocks
#' hyp <- matrix(c(2,-1,-1,-1,-1,2,  
#'                 1, 0,0,0,0,-1), 2, 6, byrow=TRUE)
#' car::linearHypothesis(root.mod, hyp)
#' heplot(root.mod, hypotheses=list(Contrasts=hyp, C1=hyp[1,], C2=hyp[2,]))
#' 
#' heplot1d(root.mod, hypotheses=list(Contrasts=hyp, C1=hyp[1,], C2=hyp[2,]))
#' 
#' 
NULL





#' Taste Ratings of Japanese Rice Wine (Sake)
#' 
#' Siotani et al. (1985) describe a study of Japanese rice wine (sake) used to
#' investigate the relationship between two subjective ratings (`taste`
#' and `smell`) and a number of physical measurements on 30 brands of
#' sake.
#' 
#' These data provide one example of a case where a multivariate regression
#' doesn't benefit from having multiple outcome measures, using the standard
#' tests.  Barrett (2003) uses this data to illustrate influence measures for
#' multivariate regression models.
#' 
#' The `taste` and `smell` values are the mean ratings of 10 experts
#' on some unknown scale.
#' 
#' @name Sake
#' @docType data
#' @format A data frame with 30 observations on the following 10 variables.
#' \describe{ 
#'   \item{`taste`}{mean taste rating} 
#'   \item{`smell`}{mean smell rating} 
#'   \item{`pH`}{pH measurement} 
#'   \item{`acidity1`}{one measure of acidity} 
#'   \item{`acidity2`}{another measure of acidity}
#'   \item{`sake`}{Sake-meter score} 
#'   \item{`rsugar`}{direct reducing sugar content} 
#'   \item{`tsugar`}{total sugar content}
#'   \item{`alcohol`}{alcohol content}
#'   \item{`nitrogen`}{formol-nitrogen content} 
#' }
#' @references 
#' Barrett, B. E. (2003). Understanding Influence in Multivariate
#' Regression. *Communications in Statistics - Theory and Methods* 32 (3),
#' 667-680.
#' 
#' @source Siotani, M. Hayakawa, T. & Fujikoshi, Y. (1985). *Modern
#' Multivariate Statistical Analysis: A Graduate Course and Handbook*. American
#' Sciences Press, p. 217.
#' @keywords datasets
#' @concept MMRA
#' @examples
#' 
#' data(Sake)
#' # quick look at the data
#' boxplot(scale(Sake))
#' 
#' Sake.mod <- lm(cbind(taste,smell) ~ ., data=Sake)
#' 
#' library(car)
#' car::Anova(Sake.mod)
#' 
#' predictors <- colnames(Sake)[-(1:2)]                 
#' # overall multivariate regression test
#' linearHypothesis(Sake.mod, predictors)
#' 
#' heplot(Sake.mod, hypotheses=list("Regr" = predictors))
#' 
NULL





#' School Data
#' 
#' School Data, from Charnes et al. (1981), a large scale social experiment in public school education.
#' It was conceived in the late 1960's as a federally sponsored program charged with providing remedial
#' assistance to educationally disadvantaged early primary school students.
#' One aim is to explain scores on 3
#' different tests, `reading`, `mathematics` and `selfesteem`
#' from 70 school sites by means of 5 explanatory variables related to parents
#' and teachers.
#' 
#' A number of observations are unusual, a fact only revealed by
#' plotting.
#' 
#' @details
#' The study was designed to compare schools using Program Follow Through (PFT)
#' management methods of taking actions to achieve goals with those of
#' Non Follow Through (NFT). Observations `1:49` came from PFT sites
#' and `50:70` from NFT sites.
#' This and other descriptors are contained in the dataset \code{\link{schoolsites}}.
#' 
#' 
#' @name schooldata
#' @docType data
#' @format A data frame with 70 observations on the following 8 variables.
#' 
#' \describe{ 
#'   \item{`education`}{Education level of mother as measured by the percentage of high school graduates among female parents}
#'   \item{`occupation`}{Highest occupation of a family member according
#'       to a pre-arranged rating scale} 
#'   \item{`visit`}{ Parental visits index,
#'      representing the number of visits to the school site}
#'   \item{`counseling`}{Parent counseling index, calculated from data on
#'       time spent with child on school-related topics such as reading together, etc.} 
#'   \item{`teacher`}{Number of teachers at the given site}
#'   \item{`reading`}{ Reading score as measured by the Metropolitan Achievement Test} 
#'   \item{`mathematics`}{Mathematics score as measured by the Metropolitan Achievement Test} 
#'   \item{`selfesteem`}{Coopersmith Self-Esteem Inventory, intended as a measure of self-esteem} 
#' }
#' @source 
#' This dataset was came originally from the (now-defunct) `FRB` package.
#' @references 
#' A. Charnes, W.W. Cooper and E. Rhodes (1981). Evaluating Program and
#' Managerial Efficiency: An Application of Data Envelopment Analysis to
#' Program Follow Through. *Management Science*, **27**, 668-697.
#' @keywords datasets
#' @seealso \code{\link{schoolsites}}
#' @concept MMRA
#' @concept robust
#' @examples
#' 
#' data(schooldata)
#' # initial screening
#' plot(schooldata)
#' 
#' # better plot
#' library(corrgram)
#' corrgram(schooldata, 
#'          lower.panel=panel.ellipse, 
#'          upper.panel=panel.pts)
#'
#' # check for multivariate outliers
#' res <- cqplot(schooldata, id.n = 5)
#' res
#' 
#' #fit the MMreg model
#' school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ 
#' 		             education + occupation + visit + counseling + teacher, data=schooldata)
#' 
#' # shorthand: fit all others
#' school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
#' car::Anova(school.mod)
#' 
#' # HE plots
#' heplot(school.mod, fill=TRUE, fill.alpha=0.1)
#' pairs(school.mod, fill=TRUE, fill.alpha=0.1)
#' 
#' # robust model, using robmlm()
#' school.rmod <- robmlm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
#' # note that counseling is now significant
#' car::Anova(school.rmod)
#' 
#' # Index plot of the weights
#' wts <- school.rmod$weights
#' notable <- which(wts < 0.8)
#' plot(wts, type = "h", col="gray", ylab = "Observation weight")
#' points(seq_along(wts), wts, 
#'        pch=16,
#'        col = ifelse(wts < 0.8, "red", "black"))
#' 
#' text(notable, wts[notable],
#'      labels = notable,
#'      pos = 3,
#'      col = "red")
#' 
#' 
#' 
#' # compare classical HE plot with that based on the robust model
#' heplot(school.mod, cex=1.4, lty=1, fill=TRUE, fill.alpha=0.1)
#' heplot(school.rmod, 
#'        add=TRUE, 
#'        error.ellipse=TRUE, 
#'        lwd=c(2,2), lty=c(2,2), 
#' 	     term.labels=FALSE, err.label="", 
#' 	     fill=TRUE)
#' 
#' 
NULL





#' Egyptian Skulls
#' 
#' 
#' Measurements made on Egyptian skulls from five epochs.
#' 
#' 
#' The epochs correspond to the following periods of Egyptian history:
#' \enumerate{ 
#'   \item the early predynastic period (circa 4000 BC); 
#'   \item the late predynastic period (circa 3300 BC); 
#'   \item the 12th and 13th dynasties (circa 1850 BC); 
#'   \item the Ptolemiac period (circa 200 BC); 
#'   \item the Roman period (circa 150 AD). 
#' }
#' 
#' The question is whether the measurements change over time.  Non-constant
#' measurements of the skulls over time would indicate interbreeding with
#' immigrant populations.
#' 
#' Note that using polynomial contrasts for `epoch` essentially treats the
#' time points as equally spaced.
#' 
#' @name Skulls
#' @docType data
#' @format A data frame with 150 observations on the following 5 variables.
#' \describe{ 
#'   \item{`epoch`}{the epoch the skull as assigned to, an
#'       ordered factor with levels `c4000BC` `c3300BC`, `c1850BC`,
#'       `c200BC`, and `cAD150`, where the years are only given approximately, of course.} 
#'   \item{`mb`}{maximal breadth of the skull.}
#'   \item{`bh`}{basibregmatic height of the skull.}
#'   \item{`bl`}{basialiveolar length of the skull.}
#'   \item{`nh`}{nasal height of the skull.} 
#' }
#' @references 
#' Thomson, A. and Randall-Maciver, R. (1905) *Ancient Races
#' of the Thebaid*, Oxford: Oxford University Press.
#' 
#' Hand, D. J., F. Daly, A. D. Lunn, K. J. McConway and E. Ostrowski (1994).
#' *A Handbook of Small Datasets*, Chapman and Hall/CRC, London.
#' 
#' @source
#' D. J. Hand, F. Daly, A. D. Lunn, K. J. McConway and E. Ostrowski (1994).
#' *A Handbook of Small Datasets*, Chapman and Hall/CRC, London.
#' @keywords datasets
#' @concept MANOVA
#' @concept contrasts
#' @examples
#' 
#' data(Skulls)
#' library(car)    # for Anova
#' 
#' # make shorter labels for epochs
#' Skulls$epoch <- factor(Skulls$epoch, labels=sub("c","",levels(Skulls$epoch)))
#' 
#' # longer variable labels
#' vlab <- c("maxBreadth", "basibHeight", "basialLength", "nasalHeight")
#' 
#' # fit manova model
#' sk.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
#' 
#' Anova(sk.mod)
#' summary(Anova(sk.mod))
#' 
#' # test trends over epochs
#' print(linearHypothesis(sk.mod, "epoch.L"), SSP=FALSE) # linear component
#' print(linearHypothesis(sk.mod, "epoch.Q"), SSP=FALSE) # quadratic component
#' 
#' # typical scatterplots are not very informative
#' scatterplot(mb ~ bh|epoch, data=Skulls, 
#'             ellipse = list(levels=0.68), 
#'             smooth=FALSE, 
#'             legend = list(coords="topright"),
#'             xlab=vlab[2], ylab=vlab[1])
#' 
#' scatterplot(mb ~ bl|epoch, data=Skulls, 
#'             ellipse = list(levels=0.68), 
#'             smooth=FALSE, 
#'             legend = list(coords="topright"),
#'             xlab=vlab[3], ylab=vlab[1])
#' 
#' # HE plots
#' 
#' heplot(sk.mod, 
#'        hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), 
#'        xlab=vlab[1], ylab=vlab[2])
#' 
#' pairs(sk.mod, 
#'       hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), 
#'       var.labels=vlab)
#' 
#' # 3D plot shows that nearly all of hypothesis variation is linear!
#' \dontrun{
#' heplot3d(sk.mod, hypotheses=list(Lin="epoch.L", Quad="epoch.Q"), col=c("pink", "blue"))
#' 
#' # view in canonical space
#' if (require(candisc)) {
#' 	sk.can <- candisc(sk.mod)
#' 	sk.can
#' 	heplot(sk.can)
#' 	heplot3d(sk.can)
#' }
#' }
#' 
#' 
NULL



#' Grades in a Sociology Course
#' 
#' The data set `SocGrades` contains four outcome measures on student
#' performance in an introductory sociology course together with six potential
#' predictors. These data were used by Marascuilo and Levin (1983) for an
#' example of canonical correlation analysis, but are also suitable as examples
#' of multivariate multiple regression, MANOVA, MANCOVA and step-down analysis
#' in multivariate linear models.
#' 
#' `midterm1`, `midterm2`, `final`, and possibly `eval` are
#' the response variables. All other variables are potential predictors.
#' 
#' The factors `class`, `sex`, and `hssoc` can be used with
#' `as.numeric` in correlational analyses.
#' 
#' @name SocGrades
#' @docType data
#' @format A data frame with 40 observations on the following 10 variables.
#' \describe{ 
#'   \item{`class`}{Social class, an ordered factor with levels
#'       `1` > `2` > `3`} 
#'   \item{`sex`}{sex, a factor with levels `F` `M`} 
#'   \item{`gpa`}{grade point average}
#'   \item{`boards`}{College Board test scores}
#'   \item{`hssoc`}{previous high school unit in sociology, a factor with 2 `no`, `yes`} 
#'   \item{`pretest`}{score on course pretest}
#'   \item{`midterm1`}{score on first midterm exam}
#'   \item{`midterm2`}{score on second midterm exam}
#'   \item{`final`}{score on final exam} 
#'   \item{`eval`}{course evaluation} }
#' @source 
#' Marascuilo, L. A. and Levin, J. R. (1983). *Multivariate
#' Statistics in the Social Sciences* Monterey, CA: Brooks/Cole, Table 5-1, p.
#' 192.
#' @keywords datasets
#' @concept MANOVA
#' @concept candisc
#' @examples
#' 
#' data(SocGrades)
#' # basic MLM
#' grades.mod <- lm(cbind(midterm1, midterm2, final, eval) ~ 
#' 	class + sex + gpa + boards + hssoc + pretest, data=SocGrades)
#' 	
#' car::Anova(grades.mod, test="Roy")
#' 
#' clr <- c("red", "blue", "darkgreen", "magenta", "brown", "black", "darkgray")
#' heplot(grades.mod, col=clr)
#' pairs(grades.mod, col=clr)
#' 
#' \dontrun{
#' heplot3d(grades.mod, col=clr, wire=FALSE)
#' }
#' 
#' if (require(candisc)) {
#' 	# calculate canonical results for all terms
#' 	grades.can <- candiscList(grades.mod)
#' 	# extract canonical R^2s
#' 	unlist(lapply(grades.can, function(x) x$canrsq))
#' 	# plot class effect in canonical space
#' 	heplot(grades.can, term="class", scale=4)	
#' 
#' 	# 1 df terms: show canonical scores and weights for responses
#' 	plot(grades.can, term="sex")
#' 	plot(grades.can, term="gpa")
#' 	plot(grades.can, term="boards")
#' 	}
#' 
#' 
NULL





#' Social Cognitive Measures in Psychiatric Groups
#' 
#' The general purpose of the study (Hartman, 2016, Heinrichs et al. (2015))
#' was to evaluate patterns and levels of performance on neurocognitive
#' measures among individuals with schizophrenia and schizoaffective disorder
#' using a well-validated, comprehensive neurocognitive battery specifically
#' designed for individuals with psychosis (Heinrichs et al. (2008))
#' 
#' The data here are for a subset of the observations in \code{\link{NeuroCog}}
#' for which measures on various scales of social cognition were also
#' available. Interest here is on whether the schizophrenia group can be
#' distinguished from the schizoaffective group on these measures.
#' 
#' The Social Cognitive measures were designed to tap various aspects of the
#' perception and cognitive procession of emotions of others.  Emotion
#' perception was assessed using a Managing Emotions (`MgeEmotions`) score
#' from the MCCB.  A "theory of mind" (`ToM`) score assessed ability to
#' read the emotions of others from photographs of the eye region of male and
#' female faces. Two other measures, externalizing bias (`ExtBias`) and
#' personalizing bias (`PersBias`) were calculated from a scale measuring
#' the degree to which individuals attribute internal, personal or situational
#' causal attributions to positive and negative social events.
#' 
#' See \code{\link{NeuroCog}} for a description of the sample. Only those with
#' complete data on all the social cognitive measures are included in this data
#' set.
#' 
#' There is one extreme outlier in the schizophrenia group and other possible
#' outliers in the control group, left in here for tutorial purposes.
#' 
#' @name SocialCog
#' @docType data
#' @format A data frame with 139 observations on the following 5 variables.
#' \describe{ 
#'   \item{`Dx`}{Diagnostic group, a factor with levels
#'       `Schizophrenia`, `Schizoaffective`, `Control`}
#'   \item{`MgeEmotions`}{Score on the Managing emotions test, a numeric vector} 
#'   \item{`ToM`}{Score on the The Reading the Mind in the Eyes test (theory of mind), a numeric vector}
#'   \item{`ExtBias`}{Externalizing Bias score, a numeric vector}
#'   \item{`PersBias`}{Personal Bias score, a numeric vector} 
#' }
#' @source 
#' Hartman, L. I. (2016). Schizophrenia and Schizoaffective Disorder:
#' One Condition or Two? Unpublished PhD dissertation, York University.
#' 
#' Heinrichs, R.W., Pinnock, F., Muharib, E., Hartman, L.I., Goldberg, J.O., &
#' McDermid Vaz, S. (2015).  Neurocognitive normality in schizophrenia
#' revisited.  *Schizophrenia Research: Cognition*, **2** (4), 227-232.
#' doi: 10.1016/j.scog.2015.09.001
#' @keywords datasets
#' @concept MANOVA
#' @concept candisc
#' @examples
#' 
#' library(car)
#' data(SocialCog)
#' SC.mod <- lm(cbind(MgeEmotions, ToM, ExtBias, PersBias) ~ Dx, data=SocialCog)
#' SC.mod
#' car::Anova(SC.mod)
#' 
#' # test hypotheses of interest in terms of contrasts
#' print(linearHypothesis(SC.mod, "Dx1"), SSP=FALSE)
#' print(linearHypothesis(SC.mod, "Dx2"), SSP=FALSE)
#' 
#' #' ## HE plots
#' 
#' heplot(SC.mod, hypotheses=list("Dx1"="Dx1", "Dx2"="Dx2"),
#' 	fill=TRUE, fill.alpha=.1)
#' 	
#' pairs(SC.mod, fill=c(TRUE,FALSE), fill.alpha=.1) 
#' 
#' 
NULL





#' Data on the Ten Item Personality Inventory
#' 
#' The Ten Item Personality Inventory (Gosling et al. 2003) is a brief
#' inventory of the Big Five personality domains (Extraversion, Neuroticism,
#' Conscientiousness, Agreeableness, and Openness to experience). This dataset,
#' originally from the Open Source Psychometrics Project
#' (https://openpsychometrics.org/), was used by Jones et al. (2020), from
#' which we obtained this version.
#' 
#' In addition to scores on the Big Five scales, the dataset contains 11
#' demographic variables on the participants, potentially useful in
#' multivariate analyses.
#' 
#' Scores on each personality domain were calculated by averaging items
#' assigned to each domain (after reverse scoring specific items). In this
#' version, total scores for each scale were calculated by averaging the
#' positively and negatively coded items, for example, `TIPI$Extraversion
#' <- (TIPI$E + (8-TIPI$E_r))/2`.
#' 
#' Then, for the present purposes, some tidying was done: \itemize{ \item 100
#' cases with `gender=="Other" were deleted; \item codes for levels of
#' `education`, `engnat` and `race` were abbreviated for ease of use in
#' graphics. }
#' 
#' @name TIPI
#' @docType data
#' @format A data frame with 1799 observations on the following 16 variables.
#' \describe{ 
#'   \item{`Extraversion`}{a numeric vector}
#'   \item{`Neuroticism`}{a numeric vector}
#'   \item{`Conscientiousness`}{a numeric vector}
#'   \item{`Agreeableness`}{a numeric vector} 
#'   \item{`Openness`}{a numeric vector} 
#'   \item{`education`}{an ordered factor with levels
#'       `<HS` < `HS` < `Univ` < `Grad`} 
#'   \item{`urban`}{an ordered factor with levels `Rural` < `Suburban` < `Urban`}
#'   \item{`gender`}{a factor with levels `M` `F`}
#'   \item{`engnat`}{a factor with levels `Native` `Non-native`}
#'   \item{`age`}{a numeric vector} 
#'   \item{`religion`}{a factor with levels `Agnostic` `Atheist` `Buddhist` `Christian
#'       (Catholic)` `Christian (Mormon)` `Christian (Protestant)`
#'       `Christian (Other)` `Hindu` `Jewish` `Muslim`
#'       `Sikh` `Other`} 
#'   \item{`orientation`}{a factor with levels `Heterosexual` `Bisexual` `Homosexual` 
#'       `Asexual` `Other`} 
#'   \item{`race`}{a factor with levels `Asian`
#'       `Arab` `Black` `Indig-White` `Other`}
#'   \item{`voted`}{a factor with levels `Yes` `No`}
#'   \item{`married`}{a factor with levels `Never married`
#'       `Currently married` `Previously married`}
#'   \item{`familysize`}{a numeric vector} 
#' }
#' @references Gosling, S. D., Rentfrow, P. J., & Swann, W. B, Jr. (2003). A
#' very brief measure of the Big-Five personality domains. *Journal of
#' Research in Personality*, **37**, 504?528.
#' @source Jones, P.J., Mair, P., Simon, T. et al. (2020). Network Trees: A
#' Method for Recursively Partitioning Covariance Structures.
#' *Psychometrika*, **85**, 926?945.
#' https://doi.org/10.1007/s11336-020-09731-4
#' @keywords datasets
#' @concept MANOVA
#' @concept candisc
#' @examples
#' 
#' data(TIPI)
#' # fit an mlm
#' tipi.mlm <- lm(cbind(Extraversion, Neuroticism, Conscientiousness, Agreeableness, Openness) 
#'                ~ engnat + gender + education, data = TIPI )
#' car::Anova(tipi.mlm)
#' 
#' heplot(tipi.mlm, fill=TRUE, fill.alpha=0.1)
#' 
#' pairs(tipi.mlm, fill=TRUE, fill.alpha=0.1)
#' 
#' # candisc works best for factors with >2 levels
#' library(candisc)
#' tipi.can <- candisc(tipi.mlm, term="education")
#' tipi.can
#' 
#' heplot(tipi.can, fill=TRUE, fill.alpha=0.1, 
#'        var.col = "darkred", var.cex = 1.5, var.lwd = 3)
#' 
NULL





#' Vocabulary growth data
#' 
#' Data from the Laboratory School of the University of Chicago.  They consist
#' of scores from a cohort of pupils in grades 8-11 on the vocabulary section
#' of the Cooperative Reading Test.  The scores are scaled to a common, but
#' arbitrary origin and unit of measurement, so as to be comparable over the
#' four grades.
#' 
#' Since these data cover an age range in which physical growth is beginning to
#' decelerate, it is of interest whether a similar effect occurs in the
#' acquisition of new vocabulary.
#' 
#' @name VocabGrowth
#' @docType data
#' @format A data frame with 64 observations on the following 4 variables.
#' \describe{ 
#'   \item{`grade8`}{Grade 8 vocabulary score}
#'   \item{`grade9`}{Grade 9 vocabulary score} 
#'   \item{`grade10`}{Grade 10 vocabulary score} 
#'   \item{`grade11`}{Grade 11 vocabulary score} 
#' }
#' @references 
#' Friendly, Michael (2010). HE Plots for Repeated Measures
#' Designs. *Journal of Statistical Software*, 37(4), 1-40.
#' \doi{10.18637/jss.v037.i04}.
#' 
#' Keesling, J.W., Bock, R.D. et al, "The Laboratory School study of vocabulary
#' growth", University of Chicago, 1975.
#' 
#' @source R.D.  
#' Bock, *Multivariate statistical methods in behavioral research*, McGraw-Hill, New York, 1975, pp453.
#' @keywords datasets
#' @concept repeated
#' @concept contrasts
#' @examples
#' 
#' library(car)
#' data(VocabGrowth)
#' 
#' # Standard Multivariate & Univariate repeated measures analysis
#' Vocab.mod <- lm(cbind(grade8,grade9,grade10,grade11) ~ 1, data=VocabGrowth)
#' idata <-data.frame(grade=ordered(8:11))
#' car::Anova(Vocab.mod, idata=idata, idesign=~grade, type="III")
#' 
#' ##Type III Repeated Measures MANOVA Tests: Pillai test statistic
#' ##            Df test stat approx F num Df den Df    Pr(>F)    
#' ##(Intercept)  1     0.653  118.498      1     63 4.115e-16 ***
#' ##grade        1     0.826   96.376      3     61 < 2.2e-16 ***
#' 
#' 
#' heplot(Vocab.mod, type="III", idata=idata, idesign=~grade, iterm="grade",
#' 	main="HE plot for Grade effect")
#' 
#' ### doing this 'manually' by explicitly transforming Y -> Y M
#' # calculate Y M, using polynomial contrasts
#' trends <- as.matrix(VocabGrowth) %*% poly(8:11, degree=3)
#' colnames(trends)<- c("Linear", "Quad", "Cubic")
#' 
#' # test all trend means = 0 == Grade effect
#' within.mod <- lm(trends ~ 1)
#' 
#' Manova(within.mod)
#' heplot(within.mod, terms="(Intercept)", col=c("red", "blue"), type="3",
#'   term.labels="Grade",
#'   main="HE plot for Grade effect")
#' mark.H0()
#' 
NULL





#' Weight Loss Data
#' 
#' Contrived data on weight loss and self esteem over three months, for three
#' groups of individuals: Control, Diet and Diet + Exercise. The data
#' constitute a double-multivariate design.
#' 
#' Helmert contrasts are assigned to `group`, comparing `Control` vs.
#' (`Diet` `DietEx`) and `Diet` vs. `DietEx`.
#' 
#' @name WeightLoss
#' @docType data
#' @format A data frame with 34 observations on the following 7 variables.
#' \describe{ 
#'   \item{`group`}{a factor with levels `Control`
#'       `Diet` `DietEx`.} \item{`wl1`}{Weight loss at 1 month}
#'   \item{`wl2`}{Weight loss at 2 months} 
#'   \item{`wl3`}{Weight loss at 3 months} 
#'   \item{`se1`}{Self esteem at 1 month}
#'   \item{`se2`}{Self esteem at 2 months} 
#'   \item{`se3`}{Self esteem at 3 months} 
#' }
#' @references Friendly, Michael (2010). HE Plots for Repeated Measures
#' Designs. *Journal of Statistical Software*, 37(4), 1-40.
#' \doi{10.18637/jss.v037.i04}. 
#' @source 
#' Originally taken from
#' <http://www.csun.edu/~ata20315/psy524/main.htm>, but modified slightly
#' @keywords datasets
#' @examples
#' 
#' data(WeightLoss)
#' str(WeightLoss)
#' table(WeightLoss$group)
#' 
#' contrasts(WeightLoss$group) <- matrix(c(-2,1,1, 0, -1, 1),ncol=2)
#' (wl.mod<-lm(cbind(wl1,wl2,wl3,se1,se2,se3)~group, data=WeightLoss))
#' 
#' heplot(wl.mod, hypotheses=c("group1", "group2"))
#' pairs(wl.mod, variables=1:3)
#' pairs(wl.mod, variables=4:6)
#' 
#' # within-S variables
#' within <- data.frame(measure=rep(c("Weight loss", "Self esteem"),each=3), month=rep(ordered(1:3),2))
#' 
#' # doubly-multivariate analysis: requires car 2.0+
#' \dontrun{
#' imatrix <- matrix(c(
#' 	1,0,-1, 1, 0, 0,
#' 	1,0, 0,-2, 0, 0,
#' 	1,0, 1, 1, 0, 0,
#' 	0,1, 0, 0,-1, 1,
#' 	0,1, 0, 0, 0,-2,
#' 	0,1, 0, 0, 1, 1), 6, 6, byrow=TRUE)
#' 
#' # NB: for heplots the columns of imatrix should have names
#' colnames(imatrix) <- c("WL", "SE", "WL.L", "WL.Q", "SE.L", "SE.Q")
#' rownames(imatrix) <- colnames(WeightLoss)[-1]
#' (imatrix <- list(measure=imatrix[,1:2], month=imatrix[,3:6]))
#' contrasts(WeightLoss$group) <- matrix(c(-2,1,1, 
#'                                         0,-1,1), ncol=2) 
#' 
#' (wl.mod<-lm(cbind(wl1, wl2, wl3, se1, se2, se3)~group, data=WeightLoss))
#' (wl.aov <- car::Anova(wl.mod, imatrix=imatrix, test="Roy"))
#' 
#' heplot(wl.mod, imatrix=imatrix, iterm="group:measure")
#' }
#' 
#' # do the correct analysis 'manually'
#' unit <- function(n, prefix="") {
#' 	J <-matrix(rep(1, n), ncol=1)
#' 	rownames(J) <- paste(prefix, 1:n, sep="")
#' 	J
#' }                
#' 
#' measure <- kronecker(diag(2), unit(3, 'M')/3, make.dimnames=TRUE)
#' colnames(measure)<- c('WL', 'SE')
#' 
#' between <- as.matrix(WeightLoss[,-1]) %*% measure
#' 
#' between.mod <- lm(between ~ group, data=WeightLoss)
#' car::Anova(between.mod)
#' 
#' heplot(between.mod, hypotheses=c("group1", "group2"), 
#' 	xlab="Weight Loss", ylab="Self Esteem",
#' 	col=c("red", "blue", "brown"),
#' 	main="Weight Loss & Self Esteem: Group Effect")
#' 
#' month <- kronecker(diag(2), poly(1:3), make.dimnames=TRUE)
#' colnames(month)<- c('WL', 'SE')
#' trends <- as.matrix(WeightLoss[,-1]) %*% month
#' within.mod <- lm(trends ~ group, data=WeightLoss)
#' car::Anova(within.mod)
#' 
#' heplot(within.mod)
#' heplot(within.mod, hypotheses=c("group1", "group2"), 
#' 	xlab="Weight Loss", ylab="Self Esteem",
#' 	type="III", remove.intercept=FALSE,
#' 	term.labels=c("month", "group:month"),
#' 	main="Weight Loss & Self Esteem: Within-S Effects")
#' mark.H0()
#' 
NULL

#' Size measurements for penguins near Palmer Station, Antarctica
#'
#' Data originally from [`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/). Includes
#' measurements for penguin species, island in Palmer Archipelago,
#' size (flipper length, body mass, bill dimensions), and sex.
#' 
#' In this version, variable names have been shortened (removing units) and observations with
#' missing data have been removed.
#'
#' @format A tibble with 333 rows and 8 variables:
#' \describe{
#'   \item{species}{a factor denoting penguin species (`"Adélie", "Chinstrap" or "Gentoo"`)}
#'   \item{island}{a factor denoting island in Palmer Archipelago, Antarctica (`"Biscoe", "Dream" or "Torgersen"`)}
#'   \item{bill_length}{a number denoting bill length (millimeters)}
#'   \item{bill_depth}{a number denoting bill depth (millimeters)}
#'   \item{flipper_length}{an integer denoting flipper length (millimeters)}
#'   \item{body_mass}{an integer denoting body mass (grams)}
#'   \item{sex}{a factor denoting penguin sex (`"f", "m"`)}
#'   \item{year}{an integer denoting the study year (2007, 2008, or 2009)}
#' }
#' @source {Adélie penguins: Palmer Station Antarctica LTER and K. Gorman. 2020. 
#'   Structural size measurements and isotopic signatures of foraging among 
#'   adult male and female Adélie penguins (Pygoscelis adeliae) nesting along 
#'   the Palmer Archipelago near Palmer Station, 2007-2009 ver 5. Environmental 
#'   Data Initiative} \doi{10.6073/pasta/98b16d7d563f265cb52372c8ca99e60f}
#' @source {Gentoo penguins: Palmer Station Antarctica LTER and K. Gorman. 2020. 
#'   Structural size measurements and isotopic signatures of foraging among 
#'   adult male and female Gentoo penguin (Pygoscelis papua) nesting along the 
#'   Palmer Archipelago near Palmer Station, 2007-2009 ver 5. Environmental 
#'   Data Initiative} \doi{10.6073/pasta/7fca67fb28d56ee2ffa3d9370ebda689}
#' @source {Chinstrap penguins: Palmer Station Antarctica LTER and K. Gorman. 
#'   2020. Structural size measurements and isotopic signatures of foraging 
#'   among adult male and female Chinstrap penguin (Pygoscelis antarcticus) 
#'   nesting along the Palmer Archipelago near Palmer Station, 2007-2009 ver 6. 
#'   Environmental Data Initiative} \doi{10.6073/pasta/c14dfcfada8ea13a17536e73eb6fbe9e}
#' @source {Originally published in: Gorman K.B., Williams T.D., Fraser W.R. (2014) 
#'   Ecological Sexual Dimorphism and Environmental Variability within a 
#'   Community of Antarctic Penguins (Genus Pygoscelis). PLoS ONE 9(3): e90081.} 
#'   \doi{10.1371/journal.pone.0090081}
#' @keywords datasets
#' @examples
#' data(peng)
#' # Covariance ellipses, centered, first two variables
#' covEllipses(cbind(bill_length, bill_depth) ~ species, data=peng,
#'      center=TRUE, 
#'      fill=c(rep(FALSE,3), TRUE), 
#'      fill.alpha=.1, label.pos=c(1:3,0))
#'
#' # All pairs when more than two variables are specified. They look pretty similar
#' covEllipses(peng[,3:6], peng$species, 
#'             variables=1:4, 
#'             fill=c(rep(FALSE,3), TRUE), 
#'             fill.alpha=.1)
#'             
#' # Box's M test 	
#' peng.boxm <- boxM(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data=peng)
#' peng.boxm
#' plot(peng.boxm, gplabel="Species")
#'
#' # Fit MANOVA model, predicting species 
#' peng.mod0 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
#'                species, data=peng)
#' car::Anova(peng.mod0)
#' 
#' # HE plot
#' heplot(peng.mod0, fill=TRUE, fill.alpha=0.1, 
#'        size="effect",
#'        xlim=c(35,52), ylim=c(14,20))
#' 
"peng"

#' @name dogfood
#' @aliases dogfood
#' @docType data
#' @title
#' Dogfood Preferences
#'
#' @description
#' A tiny hypothetical dataset to illustrate one-way MANOVA.
#' 
#' A dogfood manufacturer wanted to study preference for different dogfood formulas, two of their own
#' ("Old", "New") and two from other manufacturers ("Major", "Alps"). In a between-dog design, 4 dogs
#' were presented with a bowl of one `formula` and the time to `start` eating and `amount` eaten were recorded.
#'
#' @details
#' In addition to testing the overall effects of `formula`,
#' three useful (and orthogonal) contrasts can specified for this 3-df factor:
#' \itemize{
#'   \item `Ours` vs. `Theirs`, with weights `c(1, 1, -1, -1)`
#'   \item `Major` vs. `Alps`, with weights `c(0, 0,  1, -1)`
#'   \item `Old` vs. `New`, with weights `c(1, -1, 0, 0)`
#'   }
#' Because these are orthogonal contrasts, they fully decompose the main effect of `formula`,
#' in that their sum of squares add to the overall sum of squares.
#'
#' @usage data("dogfood")
#' @format
#'  A data frame with 16 observations on the following 3 variables.
#'  \describe{
#'    \item{`formula`}{factor, a factor with levels `Old`, `New`, `Major`, `Alps`}
#'    \item{`start`}{numeric, time to start eating}
#'    \item{`amount`}{numeric, amount eaten}
#'  }
#'
#' @source 
#' Used in my Psych 6140 lecture notes, <http://friendly.apps01.yorku.ca/psy6140/>
#'
#' @concept MANOVA
#' @concept contrasts
#' @concept candisc
#' @keywords datasets
#' @examples
#' data(dogfood)
#' library(car)
#' library(candisc)
#' 
#' # make some boxplots
#' op <- par(mfrow = c(1,2))
#' boxplot(start ~ formula, data = dogfood)
#' points(start ~ formula, data = dogfood, pch=16, cex = 1.2)
#' 
#' boxplot(amount ~ formula, data = dogfood)
#' points(amount ~ formula, data = dogfood, pch=16, cex = 1.2)
#' par(op)
#' 
#' # setup contrasts to test interesting comparisons
#' C <- matrix(
#'        c( 1,  1, -1, -1,         #Ours vs. Theirs
#'           0,  0,  1, -1,           #Major vs. Alps
#'           1, -1,  0,  0),             #New vs. Old
#'        nrow=4, ncol=3)
#' # assign these to the formula factor
#' contrasts(dogfood$formula) <- C
#' # re-fit the model
#' dogfood.mod <- lm(cbind(start, amount) ~ formula, data=dogfood)
#' 
#' dogfood.mod <- lm(cbind(start, amount) ~ formula, data=dogfood)
#' Anova(dogfood.mod)
#'
#' # data ellipses
#' covEllipses(cbind(start, amount) ~ formula, data=dogfood,
#'   fill = TRUE, fill.alpha = 0.1)
#' 
#' # test these contrasts with multivariate tests 
#' linearHypothesis(dogfood.mod, "formula1", title="Ours vs. Theirs")
#' linearHypothesis(dogfood.mod, "formula2", title="Old vs. New")
#' linearHypothesis(dogfood.mod, "formula3", title="Alps vs. Major")
#' 
#' heplot(dogfood.mod, fill = TRUE, fill.alpha = 0.1)
#'
#' # display contrasts in the heplot 
#' hyp <- list("Ours/Theirs" = "formula1",
#'             "Old/New" = "formula2")
#' heplot(dogfood.mod, hypotheses = hyp,
#'        fill = TRUE, fill.alpha = 0.1)
#' 
#' dogfood.can <- candisc(dogfood.mod, data=dogfood)
#' heplot(dogfood.can, 
#'        fill = TRUE, fill.alpha = 0.1, 
#'        lwd = 2, var.lwd = 2, var.cex = 2)

NULL

#' @name oral
#' @aliases oral
#' @docType data
#' @title
#' Effect of Delay in Oral Practice in Second Language Learning
#'
#' @description
#' Postovsky (1970) investigated the effect of delay in oral practice at the beginning of second language learning.
#' A control condition began oral practice with no delay, while an experimental group had a four-week delay before
#' starting oral practice. The data consists of scores on language skills at the end of six weeks of study.
#' 
#' Students in this study were matched on age, education, former language training, intelligence and language aptitude.
#'
#' @usage data("oral")
#' @format
#'  A data frame with 56 observations on the following 5 variables.
#'  \describe{
#'    \item{`group`}{Group, a factor with levels `Control` `Exptl`}
#'    \item{`listen`}{Listening test, a numeric vector}
#'    \item{`speak`}{Speaking test, a numeric vector}
#'    \item{`read`}{Reading test, a numeric vector}
#'    \item{`write`}{Writing test, a numeric vector}
#'  }
#'
#' @source 
#' Timm, N. H. (1975). *Multivariate Analysis with Applications in Education and Psychology*. Wadsworth (Brooks/Cole),
#'     Exercise 3.12, p. 279.
#' @references
#' Postovsky, V. A. (1970). Effects of delay in oral practice at the start of second language training. Unpublished doctoral dissertation, 
#' University of California, Berkeley.
#'
#' @concept MANOVA
#' @examples
#' library(car)
#' library(candisc)
#' data(oral)
#' 
#' # make some boxplots
#' op <- par(mfrow=c(1,4), cex.lab=1.5)
#' clr <- c("pink", "lightblue")
#' Boxplot(listen ~ group, data=oral, col = clr, cex.lab = 1.5)
#' Boxplot(speak ~  group, data=oral, col = clr, cex.lab = 1.5)
#' Boxplot(read ~   group, data=oral, col = clr, cex.lab = 1.5)
#' Boxplot(write ~  group, data=oral, col = clr, cex.lab = 1.5)
#' par(op)
#'
#' # view the data ellipses
#' covEllipses(cbind(listen, speak, read, write) ~ group, data=oral,
#'     variables = 1:4,
#'     level = 0.40,
#'     pooled = FALSE,
#'     fill = TRUE, fill.alpha = 0.05)
#' 
#' oral.mod <- lm(cbind(listen, speak, read, write) ~ group, data=oral)
#' Anova(oral.mod)
#' 
#' # canonical view
#' oral.can <- candisc(oral.mod) |> print()
#' summary(oral.can)
#' 
#' # reflect the structure & scores to make them positive
#' oral.can$structure[, "Can1"] <- -1 * oral.can$structure[, "Can1"]
#' oral.can$scores[, "Can1"]    <- -1 * oral.can$scores[, "Can1"]
#' 
#' plot(oral.can, var.lwd=2)
#'
#'
#' @keywords datasets
NULL
