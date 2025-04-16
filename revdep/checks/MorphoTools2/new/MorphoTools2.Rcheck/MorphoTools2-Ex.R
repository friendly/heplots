pkgname <- "MorphoTools2"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('MorphoTools2')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("boxMTest")
### * boxMTest

flush(stderr()); flush(stdout())

### Name: boxMTest
### Title: Box's M-test for Homogeneity of Covariance Matrices
### Aliases: boxMTest

### ** Examples

data(centaurea)

# remove NAs and linearly dependent characters (characters with unique contributions
#                  can be identified by stepwise discriminant analysis.)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))
centaurea = keepCharacter(centaurea, c("MLW", "ML", "IW", "LS", "IV", "MW", "MF",
                                    "AP", "IS", "LBA", "LW", "AL", "ILW", "LBS",
                                    "SFT", "CG", "IL", "LM", "ALW", "AW", "SF") )
# add a small constant to characters witch are invariant within taxa
centaurea$data[ centaurea$Taxon == "hybr", "LM" ][1] =
             centaurea$data[ centaurea$Taxon == "hybr", "LM" ][1] + 0.000001
centaurea$data[ centaurea$Taxon == "ph", "IV" ][1] =
             centaurea$data[ centaurea$Taxon == "ph", "IV" ][1] + 0.000001
centaurea$data[ centaurea$Taxon == "st", "LBS"][1] =
             centaurea$data[ centaurea$Taxon == "st", "LBS"][1] + 0.000001

boxMTest(centaurea)



cleanEx()
nameEx("boxplotCharacter")
### * boxplotCharacter

flush(stderr()); flush(stdout())

### Name: boxplotCharacter
### Title: Box Plots
### Aliases: boxplotCharacter boxplotAll

### ** Examples

data(centaurea)

boxplotCharacter(centaurea, character = "ST", col = "orange", border = "red")

boxplotCharacter(centaurea, character = "ST", outliers = FALSE,
          lowerWhisker = 0.1, upperWhisker = 0.9)

boxplotCharacter(centaurea, "ST", varwidth = TRUE, notch = TRUE,
          boxwex = 0.4, staplewex = 1.3, horizontal = TRUE)

boxplotCharacter(centaurea, "ST", boxlty = 1, medlwd = 5,
          whisklty = 2, whiskcol = "red", staplecol = "red",
          outcol = "grey30", pch = "-")




cleanEx()
nameEx("cda.calc")
### * cda.calc

flush(stderr()); flush(stdout())

### Name: cda.calc
### Title: Canonical Discriminant Analysis
### Aliases: cda.calc

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

cdaRes = cda.calc(centaurea)

summary(cdaRes)

plotPoints(cdaRes, col = c("red", "green", "blue", "red"),
  pch = c(20, 17, 8, 21), pt.bg = "orange", legend = TRUE)



cleanEx()
nameEx("characters")
### * characters

flush(stderr()); flush(stdout())

### Name: characters
### Title: List Morphological Characters
### Aliases: characters

### ** Examples

data(centaurea)

characters(centaurea)



cleanEx()
nameEx("classif.lda")
### * classif.lda

flush(stderr()); flush(stdout())

### Name: classif.lda
### Title: Classificatory Discriminant Analysis
### Aliases: classif.lda classif.qda classif.knn

### ** Examples

data(centaurea)

# remove NAs and linearly dependent characters (characters with unique contributions
#                  can be identified by stepwise discriminant analysis.)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))
centaurea = keepCharacter(centaurea, c("MLW", "ML", "IW", "LS", "IV", "MW", "MF",
                                    "AP", "IS", "LBA", "LW", "AL", "ILW", "LBS",
                                    "SFT", "CG", "IL", "LM", "ALW", "AW", "SF") )
# add a small constant to characters witch are invariant within taxa
centaurea$data[ centaurea$Taxon == "hybr", "LM" ][1] =
             centaurea$data[ centaurea$Taxon == "hybr", "LM" ][1] + 0.000001
centaurea$data[ centaurea$Taxon == "ph", "IV" ][1] =
             centaurea$data[ centaurea$Taxon == "ph", "IV" ][1] + 0.000001
centaurea$data[ centaurea$Taxon == "st", "LBS"][1] =
             centaurea$data[ centaurea$Taxon == "st", "LBS"][1] + 0.000001



# classification by linear discriminant function
classifRes.lda = classif.lda(centaurea, crossval = "indiv")

# classification by quadratic discriminant function
classifRes.qda = classif.qda(centaurea, crossval = "indiv")

# classification by nonparametric k-nearest neighbour method
# use knn.select to find the optimal K.
classifRes.knn = classif.knn(centaurea, k = 12, crossval = "pop")

# exporting results
classif.matrix(classifRes.lda, level = "taxon")
classif.matrix(classifRes.qda, level = "taxon")
classif.matrix(classifRes.knn, level = "taxon")




cleanEx()
nameEx("classif.matrix")
### * classif.matrix

flush(stderr()); flush(stdout())

### Name: classif.matrix
### Title: Format the Classifdata to Summary Table
### Aliases: classif.matrix

### ** Examples

data(centaurea)

centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

# classification by linear discriminant function
classifRes.lda = classif.lda(centaurea, crossval = "indiv")

# exporting results
classif.matrix(classifRes.lda, level = "taxon")
classif.matrix(classifRes.lda, level = "pop")



cleanEx()
nameEx("classifSample.lda")
### * classifSample.lda

flush(stderr()); flush(stdout())

### Name: classifSample.lda
### Title: Classificatory Discriminant Analysis
### Aliases: classifSample.knn classifSample.lda classifSample.qda

### ** Examples

data(centaurea)

# remove NAs and linearly dependent characters (characters with unique contributions
#                  can be identified by stepwise discriminant analysis.)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))
centaurea = keepCharacter(centaurea, c("MLW", "ML", "IW", "LS", "IV", "MW", "MF",
                                    "AP", "IS", "LBA", "LW", "AL", "ILW", "LBS",
                                    "SFT", "CG", "IL", "LM", "ALW", "AW", "SF") )
# add a small constant to characters witch are invariant within taxa
centaurea$data[ centaurea$Taxon == "hybr", "LM" ][1] =
             centaurea$data[ centaurea$Taxon == "hybr", "LM" ][1] + 0.000001
centaurea$data[ centaurea$Taxon == "ph", "IV" ][1] =
             centaurea$data[ centaurea$Taxon == "ph", "IV" ][1] + 0.000001
centaurea$data[ centaurea$Taxon == "st", "LBS"][1] =
             centaurea$data[ centaurea$Taxon == "st", "LBS"][1] + 0.000001


trainingSet = removePopulation(centaurea, populationName = "LES")
LES = keepPopulation(centaurea, populationName = "LES")


# classification by linear discriminant function
classifSample.lda(LES, trainingSet)

# classification by quadratic discriminant function
classifSample.qda(LES, trainingSet)

# classification by nonparametric k-nearest neighbour method
# use knn.select to find the optimal K.
classifSample.knn(LES, trainingSet, k = 12)



cleanEx()
nameEx("clust")
### * clust

flush(stderr()); flush(stdout())

### Name: clust
### Title: Hierarchical Clustering
### Aliases: clust

### ** Examples

data(centaurea)

clustering.UPGMA = clust(centaurea)

plot(clustering.UPGMA, cex = 0.6, frame.plot = TRUE, hang = -1,
        main = "", sub = "", xlab = "", ylab = "distance")


# using Gower's method
data = list(
    ID = as.factor(c("id1","id2","id3","id4","id5","id6")),
    Population = as.factor(c("Pop1", "Pop1", "Pop2", "Pop2", "Pop3", "Pop3")),
    Taxon = as.factor(c("TaxA", "TaxA", "TaxA", "TaxB", "TaxB", "TaxB")),
    data = data.frame(
     stemBranching = c(1, 1, 1, 0, 0, 0),  # binaryChs
     petalColour = c(1, 1, 2, 3, 3, 3),  # nominalChs; 1=white, 2=red, 3=blue
     leaves = c(1,1,1,2,2,3), # nominalChs; 1=simple, 2=palmately compound, 3=pinnately compound
     taste = c(2, 2, 2, 3, 1, 1),   # ordinal; 1=hot, 2=hotter, 3=hottest
     stemHeight = c(10, 11, 14, 22, 23, 21),         # quantitative
     leafLength = c(8, 7.1, 9.4, 1.2, 2.3, 2.1)  )   # quantitative
)
attr(data, "class") = "morphodata"

clustering.GOWER = clust(data, distMethod = "Gower", clustMethod = "UPGMA",
                               binaryChs = c("stemBranching"),
                               nominalChs = c("petalColour", "leaves"),
                               ordinalChs = c("taste"))

plot(clustering.GOWER, cex = 0.6, frame.plot = TRUE, hang = -1,
        main = "", sub = "", xlab = "", ylab = "distance")




cleanEx()
nameEx("cormat")
### * cormat

flush(stderr()); flush(stdout())

### Name: cormat
### Title: Correlations of Characters
### Aliases: cormat cormatSignifTest

### ** Examples

data(centaurea)

correlations.p = cormat(centaurea, method = "Pearson")
correlations.s = cormat(centaurea, method = "Spearman")


correlations.p = cormatSignifTest(centaurea, method = "Pearson")



cleanEx()
nameEx("descrTaxon")
### * descrTaxon

flush(stderr()); flush(stdout())

### Name: descrTaxon
### Title: Descriptive Statistics
### Aliases: descrTaxon descrPopulation descrAll

### ** Examples

data(centaurea, decimalPlaces = 3)

descrTaxon(centaurea)

descrTaxon(centaurea, format = "($MEAN ± $SD)")

descrPopulation(centaurea, format = "$MEAN ($MIN - $MAX)")

descrAll(centaurea, format = "$MEAN ± $SD ($5% - $95%)")



cleanEx()
nameEx("exportRes")
### * exportRes

flush(stderr()); flush(stdout())

### Name: exportRes
### Title: Export Data
### Aliases: exportRes

### ** Examples

data(centaurea)

descr = descrTaxon(centaurea, format = "($MEAN ± $SD)")



cleanEx()
nameEx("head.morphodata")
### * head.morphodata

flush(stderr()); flush(stdout())

### Name: head.morphodata
### Title: Return the First or Last Parts of an Object
### Aliases: head.classifdata tail.classifdata head.morphodata
###   tail.morphodata

### ** Examples

data(centaurea)

head(centaurea)
tail(centaurea)



cleanEx()
nameEx("histCharacter")
### * histCharacter

flush(stderr()); flush(stdout())

### Name: histCharacter
### Title: Histograms of Characters
### Aliases: histCharacter histAll

### ** Examples

data(centaurea)

histCharacter(centaurea, character = "IW", breaks = seq(0.5, 2.5, 0.1))




cleanEx()
nameEx("keepTaxon")
### * keepTaxon

flush(stderr()); flush(stdout())

### Name: keepTaxon
### Title: Keep Items (Taxa, Populations, Samples, Morphological
###   Characters) in an Morphodata Object (and Remove Others)
### Aliases: keepTaxon keepPopulation keepCharacter keepSample

### ** Examples

data(centaurea)

centaurea.hybr = keepTaxon(centaurea, "hybr")
centaurea.PhHybr = keepTaxon(centaurea, c("ph", "hybr"))

centaurea.PREL = keepPopulation(centaurea, "PREL")

centaurea.NA_0.1 = keepSample(centaurea, missingPercentage = 0.1)

centaurea.stem = keepCharacter(centaurea, c("SN", "SF", "ST"))



cleanEx()
nameEx("knn.select")
### * knn.select

flush(stderr()); flush(stdout())

### Name: knn.select
### Title: Search for the Optimal K-nearest Neighbours
### Aliases: knn.select

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

# classification by nonparametric k-nearest neighbour method
classifRes.knn = classif.knn(centaurea, k = 12, crossval = "indiv")



cleanEx()
nameEx("missingCharactersTable")
### * missingCharactersTable

flush(stderr()); flush(stdout())

### Name: missingCharactersTable
### Title: Summarize Missing Data
### Aliases: missingCharactersTable

### ** Examples

data(centaurea)

missingCharactersTable(centaurea, level = "pop")



cleanEx()
nameEx("missingSamplesTable")
### * missingSamplesTable

flush(stderr()); flush(stdout())

### Name: missingSamplesTable
### Title: Summarize Missing Data
### Aliases: missingSamplesTable

### ** Examples

data(centaurea)

missingSamplesTable(centaurea, level = "pop")



cleanEx()
nameEx("naMeanSubst")
### * naMeanSubst

flush(stderr()); flush(stdout())

### Name: naMeanSubst
### Title: Replace Missing Data by Population Average
### Aliases: naMeanSubst

### ** Examples

data(centaurea)

centaurea = naMeanSubst(centaurea)



cleanEx()
nameEx("nmds.calc")
### * nmds.calc

flush(stderr()); flush(stdout())

### Name: nmds.calc
### Title: Non-metric Multidimensional Scaling (NMDS)
### Aliases: nmds.calc

### ** Examples

data(centaurea)

nmdsRes = nmds.calc(centaurea, distMethod = "Euclidean", k = 3)

summary(nmdsRes)

plotPoints(nmdsRes, axes = c(1,2), col = c("red", "green", "blue", "black"),
  pch = c(20,17,8,21), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")

# using Gower's method
data = list(
    ID = as.factor(c("id1","id2","id3","id4","id5","id6")),
    Population = as.factor(c("Pop1", "Pop1", "Pop2", "Pop2", "Pop3", "Pop3")),
    Taxon = as.factor(c("TaxA", "TaxA", "TaxA", "TaxB", "TaxB", "TaxB")),
    data = data.frame(
     stemBranching = c(1, 1, 1, 0, 0, 0),  # binaryChs
     petalColour = c(1, 1, 2, 3, 3, 3),  # nominalChs; 1=white, 2=red, 3=blue
     leaves = c(1,1,1,2,2,3), # nominalChs; 1=simple, 2=palmately compound, 3=pinnately compound
     taste = c(2, 2, 2, 3, 1, 1),   # ordinal; 1=hot, 2=hotter, 3=hottest
     stemHeight = c(10, 11, 14, 22, 23, 21),         # quantitative
     leafLength = c(8, 7.1, 9.4, 1.2, 2.3, 2.1)  )   # quantitative
)
attr(data, "class") = "morphodata"

nmdsGower = nmds.calc(data, distMethod = "Gower", k = 2, binaryChs = c("stemBranching"),
                      nominalChs = c("petalColour", "leaves"), ordinalChs = c("taste"))

plotPoints(nmdsGower, axes = c(1,2), col = c("red","green"),
           pch = c(20,17), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")



cleanEx()
nameEx("pca.calc")
### * pca.calc

flush(stderr()); flush(stdout())

### Name: pca.calc
### Title: Principal Component Analysis
### Aliases: pca.calc

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

summary(pcaRes)

plotPoints(pcaRes, axes = c(1,2), col = c("red", "green", "blue", "black"),
  pch = c(20,17,8,21), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")



cleanEx()
nameEx("pcoa.calc")
### * pcoa.calc

flush(stderr()); flush(stdout())

### Name: pcoa.calc
### Title: Principal Coordinates Analysis (PCoA)
### Aliases: pcoa.calc

### ** Examples

data(centaurea)

pcoRes = pcoa.calc(centaurea, distMethod = "Manhattan")

summary(pcoRes)

plotPoints(pcoRes, axes = c(1,2), col = c("red", "green", "blue", "black"),
  pch = c(20,17,8,21), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")

# using Gower's method
data = list(
    ID = as.factor(c("id1","id2","id3","id4","id5","id6")),
    Population = as.factor(c("Pop1", "Pop1", "Pop2", "Pop2", "Pop3", "Pop3")),
    Taxon = as.factor(c("TaxA", "TaxA", "TaxA", "TaxB", "TaxB", "TaxB")),
    data = data.frame(
     stemBranching = c(1, 1, 1, 0, 0, 0),  # binaryChs
     petalColour = c(1, 1, 2, 3, 3, 3),  # nominalChs; 1=white, 2=red, 3=blue
     leaves = c(1,1,1,2,2,3), # nominalChs; 1=simple, 2=palmately compound, 3=pinnately compound
     taste = c(2, 2, 2, 3, 1, 1),   # ordinal; 1=hot, 2=hotter, 3=hottest
     stemHeight = c(10, 11, 14, 22, 23, 21),         # quantitative
     leafLength = c(8, 7.1, 9.4, 1.2, 2.3, 2.1)  )   # quantitative
)
attr(data, "class") = "morphodata"

pcoaGower = pcoa.calc(data, distMethod = "Gower", binaryChs = c("stemBranching"),
                      nominalChs = c("petalColour", "leaves"), ordinalChs = c("taste"))

plotPoints(pcoaGower, axes = c(1,2), col = c("red","green"),
           pch = c(20,17), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")



cleanEx()
nameEx("plot3Dpoints")
### * plot3Dpoints

flush(stderr()); flush(stdout())

### Name: plot3Dpoints
### Title: The Default Scatterplot 3D Function
### Aliases: plot3Dpoints

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plot3Dpoints(pcaRes, col = c("red", "green", "blue", "black"), pch = c(20,17,8,21),
                 pt.bg = "orange")



cleanEx()
nameEx("plotAddEllipses")
### * plotAddEllipses

flush(stderr()); flush(stdout())

### Name: plotAddEllipses
### Title: Add Prediction Ellipses to a Plot
### Aliases: plotAddEllipses

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plotPoints(pcaRes, col = c(rgb(255, 0, 0, max = 255, alpha = 150), # red
                           rgb(0, 255, 0, max = 255, alpha = 150), # green
                           rgb(0, 0, 255, max = 255, alpha = 150), # blue
                           rgb(0, 0, 0, max = 255, alpha = 150)), # black
            legend = FALSE, xlim = c(-5, 7.5), ylim = c(-5, 5.5))

plotAddLegend(pcaRes, col = c("red", "green", "blue", "black"), ncol = 2)

plotAddEllipses(pcaRes, col = c("red", "green", "blue", "black"), lwd = 3)



cleanEx()
nameEx("plotAddLabels.characters")
### * plotAddLabels.characters

flush(stderr()); flush(stdout())

### Name: plotAddLabels.characters
### Title: Add Labels to a Plot
### Aliases: plotAddLabels.characters

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))


pcaRes = pca.calc(centaurea)

plotCharacters(pcaRes, labels = FALSE)
plotAddLabels.characters(pcaRes, labels = c("MW", "IW", "SFT", "SF", "LW"), pos = 2, cex = 1)
plotAddLabels.characters(pcaRes, labels = c("LLW", "ILW", "LBA"), pos = 4, cex = 1)
plotAddLabels.characters(pcaRes, labels = c("ML", "IV", "MLW"), pos = 1, cex = 1)



cleanEx()
nameEx("plotAddLabels.points")
### * plotAddLabels.points

flush(stderr()); flush(stdout())

### Name: plotAddLabels.points
### Title: Add Labels to a Plot
### Aliases: plotAddLabels.points

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))
pops = populOTU(centaurea)


pcaRes = pca.calc(pops)
plotPoints(pcaRes, col = c("red", "green", "blue", "red"),
            pch = c(20, 17, 8, 21), pt.bg = "orange", legend = FALSE)

plotAddLabels.points(pcaRes, labels = c("LES", "BUK", "VOL", "OLE1"), include = TRUE)

plotPoints(pcaRes, col = c("red", "green", "blue", "red"),
            pch = c(20, 17, 8, 21), pt.bg = "orange", legend = FALSE)

plotAddLabels.points(pcaRes, labels = c("LES", "BUK", "VOL", "OLE1"), include = FALSE)



cleanEx()
nameEx("plotAddLegend")
### * plotAddLegend

flush(stderr()); flush(stdout())

### Name: plotAddLegend
### Title: Add Legend to a Plot
### Aliases: plotAddLegend

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plotPoints(pcaRes, col = c("red", "green", "blue", "red"),
            pch = c(20, 17, 8, 21), pt.bg = "orange", legend = FALSE)

plotAddLegend(pcaRes, x = "bottomright", col = c("red", "green", "blue", "red"),
               pch = c(20, 17, 8, 21), pt.bg = "orange", ncol = 2)



cleanEx()
nameEx("plotAddSpiders")
### * plotAddSpiders

flush(stderr()); flush(stdout())

### Name: plotAddSpiders
### Title: Add Spiders to a Plot
### Aliases: plotAddSpiders

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plotPoints(pcaRes, col = c(rgb(255, 0, 0, max = 255, alpha = 150), # red
                           rgb(0, 255, 0, max = 255, alpha = 150), # green
                           rgb(0, 0, 255, max = 255, alpha = 150), # blue
                           rgb(0, 0, 0, max = 255, alpha = 150)), # black
            legend = FALSE, xlim = c(-5, 7.5), ylim = c(-5, 5.5))

plotAddLegend(pcaRes, col = c("red", "green", "blue", "black"), ncol = 2)

plotAddSpiders(pcaRes, col = c("red", "green", "blue", "black"))


plotPoints(pcaRes, col = c("red", "green", "blue","black"), legend = TRUE, cex = 0.4)

plotAddSpiders(pcaRes, col = c(rgb(255, 0, 0, max = 255, alpha = 150), # red
                               rgb(0, 255, 0, max = 255, alpha = 150), # green
                               rgb(0, 0, 255, max = 255, alpha = 150), # blue
                               rgb(0, 0, 0, max = 255, alpha = 150))) # black



cleanEx()
nameEx("plotBiplot")
### * plotBiplot

flush(stderr()); flush(stdout())

### Name: plotBiplot
### Title: The Default Biplot Function
### Aliases: plotBiplot

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plotBiplot(pcaRes, axes = c(1,2), col = c("red", "green", "blue", "red"),
  pch = c(20, 17, 8, 21), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")

plotBiplot(pcaRes, main = "My PCA plot", cex = 0.8)

cdaRes = cda.calc(centaurea)

plotBiplot(cdaRes, col = c("red", "green", "blue", "red"),
  pch = c(20, 17, 8, 21), pt.bg = "orange", legend = TRUE)



cleanEx()
nameEx("plotCharacters")
### * plotCharacters

flush(stderr()); flush(stdout())

### Name: plotCharacters
### Title: Draws Character's Contribution as Arrows
### Aliases: plotCharacters

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plotCharacters(pcaRes)



cleanEx()
nameEx("plotPoints")
### * plotPoints

flush(stderr()); flush(stdout())

### Name: plotPoints
### Title: The Default Scatterplot Function
### Aliases: plotPoints

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

pcaRes = pca.calc(centaurea)

plotPoints(pcaRes, axes = c(1,2), col = c("red", "green", "blue", "red"),
  pch = c(20, 17, 8, 21), pt.bg = "orange", legend = TRUE, legend.pos = "bottomright")

plotPoints(pcaRes, main = "My PCA plot", cex = 0.8)

cdaRes = cda.calc(centaurea)

plotPoints(cdaRes, col = c("red", "green", "blue", "red"),
  pch = c(20, 17, 8, 21), pt.bg = "orange", legend = TRUE)



cleanEx()
nameEx("populOTU")
### * populOTU

flush(stderr()); flush(stdout())

### Name: populOTU
### Title: Population Means
### Aliases: populOTU

### ** Examples

data(centaurea)

pops = populOTU(centaurea)



cleanEx()
nameEx("qqnormCharacter")
### * qqnormCharacter

flush(stderr()); flush(stdout())

### Name: qqnormCharacter
### Title: Quantile-Quantile Plots
### Aliases: qqnormCharacter qqnormAll

### ** Examples

data(centaurea)

qqnormCharacter(centaurea, character = "SF")




cleanEx()
nameEx("read.morphodata")
### * read.morphodata

flush(stderr()); flush(stdout())

### Name: read.morphodata
### Title: Data Input and Description
### Aliases: read.morphodata samples populations taxa

### ** Examples

data = read.morphodata(file = system.file("extdata", "centaurea.txt",
    package = "MorphoTools2"), dec = ".", sep = "\t")



summary(data)
samples(data)
populations(data)
taxa(data)



cleanEx()
nameEx("removeTaxon")
### * removeTaxon

flush(stderr()); flush(stdout())

### Name: removeTaxon
### Title: Remove Items (Taxa, Populations, Morphological Characters) from
###   Morphodata Object
### Aliases: removeTaxon removePopulation removeSample removeCharacter

### ** Examples

data(centaurea)

centaurea.3tax = removeTaxon(centaurea, "hybr")
centaurea.PsSt = removeTaxon(centaurea, c("ph", "hybr"))

centaurea.short = removePopulation(centaurea, c("LIP", "PREL"))

centaurea.NA_0.1 = removeSample(centaurea, missingPercentage = 0.1)

centaurea.short = removeCharacter(centaurea, "LL")



cleanEx()
nameEx("shapiroWilkTest")
### * shapiroWilkTest

flush(stderr()); flush(stdout())

### Name: shapiroWilkTest
### Title: Shapiro-Wilk Normality Test
### Aliases: shapiroWilkTest

### ** Examples

data(centaurea)

sW = shapiroWilkTest(centaurea)


sW = shapiroWilkTest(centaurea, p.value = NA)




cleanEx()
nameEx("stepdisc.calc")
### * stepdisc.calc

flush(stderr()); flush(stdout())

### Name: stepdisc.calc
### Title: Stepwise Discriminant Analysis
### Aliases: stepdisc.calc

### ** Examples

data(centaurea)
centaurea = naMeanSubst(centaurea)
centaurea = removePopulation(centaurea, populationName = c("LIP", "PREL"))

stepdisc.calc(centaurea)



cleanEx()
nameEx("transformCharacter")
### * transformCharacter

flush(stderr()); flush(stdout())

### Name: transformCharacter
### Title: Transformation of Character
### Aliases: transformCharacter

### ** Examples

data(centaurea)

# For a right-skewed (positive) distribution can be used:
# Logarithmic transformation
cTransf = transformCharacter(centaurea, character = "SF", FUN = function(x) log(x+1))
cTransf = transformCharacter(centaurea, character = "SF", FUN = function(x) log10(x+1))
# Square root transformation
cTransf = transformCharacter(centaurea, character = "SF", FUN = function(x) sqrt(x))
# Cube root transformation
cTransf = transformCharacter(centaurea, character = "SF", FUN = function(x) x^(1/3))
# Arcsine transformation
cTransf = transformCharacter(centaurea, character = "SF", FUN = function(x) asin(sqrt(x)))

# For a left-skewed (negative) distribution can be used:
# Logarithmic transformation
cTransf = transformCharacter(centaurea, character="SF", FUN=function(x) log((max(x)+1)-x))
cTransf = transformCharacter(centaurea, character="SF", FUN=function(x) log10((max(x)+1)-x))
# Square root transformation
cTransf = transformCharacter(centaurea, character="SF", FUN=function(x) sqrt((max(x)+1)-x))
# Cube root transformation
cTransf = transformCharacter(centaurea, character="SF", FUN=function(x) ((max(x)+1)-x)^(1/3))
# Arcsine transformation
cTransf = transformCharacter(centaurea, character="SF", FUN=function(x) asin(sqrt((max(x))-x)))





cleanEx()
nameEx("viewMorphodata")
### * viewMorphodata

flush(stderr()); flush(stdout())

### Name: viewMorphodata
### Title: Invoke a Data Viewer
### Aliases: viewMorphodata

### ** Examples

data(centaurea)




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
