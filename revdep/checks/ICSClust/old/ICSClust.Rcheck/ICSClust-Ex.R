pkgname <- "ICSClust"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('ICSClust')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("ICSClust")
### * ICSClust

flush(stderr()); flush(stdout())

### Name: ICSClust
### Title: Tandem clustering with ICS
### Aliases: ICSClust

### ** Examples

X <- iris[,1:4]

# indicating the number of components to retain for the dimension reduction
# step as well as the number of clusters searched for.
out <- ICSClust(X, nb_select = 2, nb_clusters = 3)
summary(out)
plot(out)

# changing the scatter pair to consider in ICS
out <- ICSClust(X, nb_select = 1, nb_clusters = 3,
ICS_args = list(S1 = ICS_mcd_raw, S2 = ICS_cov,S1_args = list(alpha = 0.5)))
summary(out)
plot(out)
 
# changing the criterion for choosing the invariant coordinates
out <- ICSClust(X, nb_clusters = 3, criterion = "normal_crit",
ICS_crit_args = list(level = 0.1, test = "anscombe.test", max_select = NULL))
summary(out)
plot(out)

# changing the clustering method
out <- ICSClust(X, nb_clusters = 3, method  = "tkmeans_clust", 
clustering_args = list(alpha = 0.1))
summary(out)
plot(out)



cleanEx()
nameEx("component_plot")
### * component_plot

flush(stderr()); flush(stdout())

### Name: component_plot
### Title: Scatterplot Matrix with densities on the diagonal
### Aliases: component_plot

### ** Examples

X <- iris[,1:4]
component_plot(X)
out <- ICS(X)
component_plot(out, select = c(1,4))




cleanEx()
nameEx("discriminatory_crit")
### * discriminatory_crit

flush(stderr()); flush(stdout())

### Name: discriminatory_crit
### Title: Selection of ICS components based on discriminatory power
### Aliases: discriminatory_crit discriminatory_crit.ICS
###   discriminatory_crit.default

### ** Examples

X <- iris[,-5]
out <- ICS(X)
discriminatory_crit(out, clusters = iris[,5], select_only = FALSE)



cleanEx()
nameEx("kmeans_clust")
### * kmeans_clust

flush(stderr()); flush(stdout())

### Name: kmeans_clust
### Title: _k_-means clustering
### Aliases: kmeans_clust

### ** Examples

kmeans_clust(iris[,1:4], k = 3, clusters_only = TRUE)




cleanEx()
nameEx("mclust_clust")
### * mclust_clust

flush(stderr()); flush(stdout())

### Name: mclust_clust
### Title: Model-Based Clustering
### Aliases: mclust_clust rmclust_clust

### ** Examples

mclust_clust(iris[,1:4], k = 3, clusters_only = TRUE)



cleanEx()
nameEx("med_crit")
### * med_crit

flush(stderr()); flush(stdout())

### Name: med_crit
### Title: Selection of Invariant components using the med criterion
### Aliases: med_crit med_crit.ICS med_crit.default

### ** Examples

X <- iris[,-5]
out <- ICS(X)
med_crit(out, nb_select = 2, select_only = FALSE)



cleanEx()
nameEx("mixture_sim")
### * mixture_sim

flush(stderr()); flush(stdout())

### Name: mixture_sim
### Title: Simulation of a mixture of Gaussian distributions
### Aliases: mixture_sim

### ** Examples

X <- mixture_sim()
summary(X)



cleanEx()
nameEx("normal_crit")
### * normal_crit

flush(stderr()); flush(stdout())

### Name: normal_crit
### Title: Selection of Non-normal Invariant Components Using Marginal
###   Normality Tests
### Aliases: normal_crit normal_crit.ICS normal_crit.default

### ** Examples

X <- iris[,-5]
out <- ICS(X)
normal_crit(out, level = 0.1, select_only = FALSE)




cleanEx()
nameEx("pam_clust")
### * pam_clust

flush(stderr()); flush(stdout())

### Name: pam_clust
### Title: Partitioning Around Medoids clustering
### Aliases: pam_clust

### ** Examples

pam_clust(iris[,1:4], k = 3, clusters_only = TRUE)
 



cleanEx()
nameEx("rimle_clust")
### * rimle_clust

flush(stderr()); flush(stdout())

### Name: rimle_clust
### Title: Robust Improper Maximum Likelihood Clustering
### Aliases: rimle_clust

### ** Examples

rimle_clust(iris[,1:4], k = 3, clusters_only = TRUE)



cleanEx()
nameEx("runif_outside_range")
### * runif_outside_range

flush(stderr()); flush(stdout())

### Name: runif_outside_range
### Title: Uniform distribution outside a given range
### Aliases: runif_outside_range

### ** Examples

## illustrations for argument 'mult'

# draw observations with argument 'mult = 2'
xy2 <- runif_outside_range(1000, min = rep(-1, 2), max = rep(1, 2), 
                           mult = 2)
# each side of the larger hyperrectangle is twice as long as 
# the corresponding side of the smaller rectanglar cut-out
df2 <- data.frame(x = xy2[, 1], y = xy2[, 2])
ggplot(data = df2, mapping = aes(x = x, y = y)) + 
  geom_point()

# draw observations with argument 'mult = 4'
xy4 <- runif_outside_range(1000, min = rep(-1, 2), max = rep(1, 2), 
                           mult = 4)
# each side of the larger hyperrectangle is four times as long 
# as the corresponding side of the smaller rectanglar cut-out
df4 <- data.frame(x = xy4[, 1], y = xy4[, 2])
ggplot(data = df4, mapping = aes(x = x, y = y)) + 
  geom_point()




cleanEx()
nameEx("select_plot")
### * select_plot

flush(stderr()); flush(stdout())

### Name: select_plot
### Title: Plot of the Generalized Kurtosis Values of the ICS
###   Transformation
### Aliases: select_plot select_plot.default select_plot.data.frame
###   select_plot.ICS_crit

### ** Examples

X <- iris[,-5]
out <- ICS(X)

# on an ICS object
select_plot(out)
select_plot(out, type = "lines")

# on an ICS_crit object 
# median criterion
out_med <- med_crit(out, nb_select = 1, select_only = FALSE)
select_plot(out_med, type = "lines")
select_plot(out_med, screeplot = FALSE, type = "lines", 
color = "lightblue")

# discriminatory criterion
out_disc <- discriminatory_crit(out, clusters = iris[,5], 
 select_only = FALSE)
select_plot(out_disc)





cleanEx()
nameEx("tkmeans_clust")
### * tkmeans_clust

flush(stderr()); flush(stdout())

### Name: tkmeans_clust
### Title: Trimmed k-means clustering
### Aliases: tkmeans_clust

### ** Examples

tkmeans_clust(iris[,1:4], k = 3, alpha = 0.1, clusters_only = TRUE)



cleanEx()
nameEx("var_crit")
### * var_crit

flush(stderr()); flush(stdout())

### Name: var_crit
### Title: Selection of Invariant components using the var criterion
### Aliases: var_crit var_crit.ICS var_crit.default

### ** Examples

X <- iris[,-5]
out <- ICS(X)
var_crit(out, nb_select = 2, select_only = FALSE)




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
