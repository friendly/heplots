pkgname <- "ordr"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('ordr')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("biplot-stats")
### * biplot-stats

flush(stderr()); flush(stdout())

### Name: biplot-stats
### Title: Convenience stats for row and column matrix factors
### Aliases: biplot-stats stat_rows_ellipse stat_cols_ellipse
###   stat_rows_center stat_cols_center stat_rows_star stat_cols_star
###   stat_rows_chull stat_cols_chull stat_rows_cone stat_cols_cone
###   stat_rows_scale stat_cols_scale stat_rows_spantree stat_cols_spantree

### ** Examples

# compute row-principal components of scaled iris measurements
iris[, -5] %>%
  prcomp(scale = TRUE) %>%
  as_tbl_ord() %>%
  mutate_rows(species = iris$Species) %>%
  print() -> iris_pca

# row-principal biplot with centroids and confidence elliptical disks
iris_pca %>%
  ggbiplot(aes(color = species)) +
  theme_bw() +
  geom_rows_point() +
  geom_polygon(
    aes(fill = species),
    color = NA, alpha = .25, stat = "rows_ellipse"
  ) +
  geom_cols_vector(color = "#444444") +
  scale_color_brewer(
    type = "qual", palette = 2,
    aesthetics = c("color", "fill")
  ) +
  ggtitle(
    "Row-principal PCA biplot of Anderson iris measurements",
    "Overlaid with 95% confidence disks"
  )



cleanEx()
nameEx("conference")
### * conference

flush(stderr()); flush(stdout())

### Name: conference
### Title: Confer inertia to factors of a 'tbl_ord' object
### Aliases: conference recover_conference recover_conference.default
###   get_conference revert_conference confer_inertia

### ** Examples

# illustrative ordination: correspendence analysis of hair & eye data
haireye_ca <- ordinate(
  as.data.frame(rowSums(HairEyeColor, dims = 2L)),
  cols = everything(), model = MASS::corresp
)
print(haireye_ca)

# check distribution of inertia
get_conference(haireye_ca)
# confer inertia to rows, then to columns
confer_inertia(haireye_ca, "rows")
confer_inertia(haireye_ca, "columns")
# confer inertia symmetrically
(haireye_ca <- confer_inertia(haireye_ca, "symmetric"))
# check redistributed inertia
get_conference(haireye_ca)
# restore default distribution of inertia
revert_conference(haireye_ca)



cleanEx()
nameEx("dplyr-verbs")
### * dplyr-verbs

flush(stderr()); flush(stdout())

### Name: dplyr-verbs
### Title: *dplyr* verbs for tbl_ord factors
### Aliases: dplyr-verbs pull_factor pull_rows pull_cols rename_rows
###   rename_cols select_rows select_cols mutate_rows mutate_cols
###   transmute_rows transmute_cols cbind_rows cbind_cols left_join_rows
###   left_join_cols

### ** Examples

# illustrative ordination: LDA of iris data
(iris_lda <- ordinate(iris, cols = 1:4, lda_ord, grouping = iris$Species))

# extract a coordinate or annotation
head(pull_rows(iris_lda, Species))
pull_cols(iris_lda, LD2)

# rename an annotation
rename_cols(iris_lda, species = name)

# select annotations
select_rows(iris_lda, species = name, .element)

# create, modify, and delete annotations
mutate_cols(iris_lda, vec.length = sqrt(LD1^2 + LD2^2))
transmute_cols(iris_lda, vec.length = sqrt(LD1^2 + LD2^2))

# bind data frames of annotations
iris_medians <-
  stats::aggregate(iris[, 1:4], median, by = iris[, 5, drop = FALSE])
iris_lda %>%
  # retain '.element' in order to match by `elements`
  select_rows(.element) %>%
  cbind_rows(iris_medians, elements = "active")



cleanEx()
nameEx("draw-key")
### * draw-key

flush(stderr()); flush(stdout())

### Name: draw-key
### Title: Biplot key drawing functions
### Aliases: draw-key draw_key_line draw_key_crosslines draw_key_crosspoint

### ** Examples

# scaled PCA of Anderson iris data with ranges and confidence intervals
iris[, -5] %>%
  prcomp(scale = TRUE) %>%
  as_tbl_ord() %>%
  confer_inertia(1) %>%
  augment_ord() %>%
  mutate_rows(species = iris$Species) %>%
  ggbiplot(aes(color = species)) +
  theme_bw() +
  scale_color_brewer(type = "qual", palette = 2) +
  geom_rows_lineranges(fun.data = mean_sdl, linewidth = .75) +
  geom_rows_point(alpha = .5) +
  geom_cols_vector(color = "#444444") +
  geom_cols_text_radiate(aes(label = name), color = "#444444", size = 3) +
  ggtitle(
    "Row-principal PCA biplot of Anderson iris data",
    "Ranges 2 sample standard deviations from centroids"
  )



cleanEx()
nameEx("geom_axis")
### * geom_axis

flush(stderr()); flush(stdout())

### Name: geom_axis
### Title: Axes through the origin
### Aliases: geom_axis

### ** Examples

# Reaven & Miller overt & chemical diabetes test data and group classification
head(heplots::Diabetes)

# default (standardized) linear discriminant analysis of groups on tests
diabetes_lda <- MASS::lda(group ~ ., heplots::Diabetes)
# bestow 'tbl_ord' class & augment observation, centroid, and variable fields
as_tbl_ord(diabetes_lda) %>%
  augment_ord() %>%
  mutate_rows(discriminant = ifelse(
    .element == "active",
    "centroid", "case"
  )) %>%
  print() -> diabetes_lda
# row-standard biplot
diabetes_lda %>%
  confer_inertia(1) %>%
  ggbiplot() +
  theme_bw() + theme_biplot() +
  geom_rows_point(aes(shape = grouping, size = discriminant), alpha = .5) +
  geom_cols_axis(aes(label = name), color = "#888888", num = 8L,
                 text_size = 2.5, label_dodge = .02) +
  ggtitle(
    "LDA of Reaven & Miller diabetes groups",
    "Row-standard biplot of standardized LDA"
  )

# contribution LDA of groups on tests
diabetes_lda <-
  lda_ord(group ~ ., heplots::Diabetes, axes.scale = "contribution")
# bestow 'tbl_ord' class & augment observation, centroid, and variable fields
as_tbl_ord(diabetes_lda) %>%
  augment_ord() %>%
  mutate_rows(discriminant = ifelse(
    .element == "active",
    "centroid", "case"
  )) %>%
  print() -> diabetes_lda
# symmetric biplot
diabetes_lda %>%
  confer_inertia(.5) %>%
  ggbiplot() +
  theme_bw() + theme_biplot() +
  geom_rows_point(aes(shape = grouping, alpha = discriminant)) +
  geom_cols_axis(color = "#888888", num = 8L,
                 text_size = 2.5, text_dodge = .025) +
  ggtitle(
    "LDA of Reaven & Miller diabetes groups",
    "Symmetric biplot of contribution LDA"
  )



cleanEx()
nameEx("geom_isoline")
### * geom_isoline

flush(stderr()); flush(stdout())

### Name: geom_isoline
### Title: Isolines (contour lines)
### Aliases: geom_isoline

### ** Examples

# Reaven & Miller overt & chemical diabetes test data and group classification
head(heplots::Diabetes)
# default (standardized) linear discriminant analysis of groups on tests
diabetes_lda <- MASS::lda(group ~ ., heplots::Diabetes)

# bestow 'tbl_ord' class & augment observation, centroid, and variable fields
as_tbl_ord(diabetes_lda) %>%
  augment_ord() %>%
  print() -> diabetes_lda

# row-standard biplot
diabetes_lda %>%
  confer_inertia(1) %>%
  ggbiplot(aes(label = name), elements = "active") +
  theme_bw() + theme_biplot() +
  geom_rows_text() +
  geom_cols_vector(subset = c(1, 3, 4)) +
  geom_cols_text_radiate(subset = c(1, 3, 4), size = 3) +
  geom_cols_isoline(subset = c(1, 3, 4), alpha = .25, num = 4L,
                    label_dodge = -.03, text_alpha = .5, text_size = 3) +
  ggtitle(
    "LDA of Reaven & Miller diabetes groups",
    "Row-standard biplot of standardized LDA"
  )



cleanEx()
nameEx("geom_lineranges")
### * geom_lineranges

flush(stderr()); flush(stdout())

### Name: geom_lineranges
### Title: Intervals depicting ranges, usually about center points
### Aliases: geom_lineranges geom_pointranges

### ** Examples

# compute log-ratio analysis of Freestone primary class composition measurements
glass %>%
  ordinate(cols = c(SiO2, Al2O3, CaO, FeO, MgO),
           model = lra, compositional = TRUE) %>%
  confer_inertia("rows") %>%
  print() -> glass_lra

# row-principal biplot with ordinate-wise standard deviations
glass_lra %>%
  ggbiplot(aes(color = Site), sec.axes = "cols", scale.factor = .05) +
  theme_biplot() +
  scale_color_brewer(type = "qual", palette = 6) +
  geom_cols_text(stat = "chull", aes(label = name), color = "#444444") +
  geom_rows_lineranges(fun.data = mean_sdl, linewidth = .75) +
  geom_rows_point(alpha = .5) +
  ggtitle(
    "Row-principal LRA biplot of Freestone glass measurements",
    "Ranges 2 sample standard deviations from centroids"
  )



cleanEx()
nameEx("geom_unit_circle")
### * geom_unit_circle

flush(stderr()); flush(stdout())

### Name: geom_unit_circle
### Title: Unit circle
### Aliases: geom_unit_circle

### ** Examples

# principal components analysis of overt & chemical diabetes test values
heplots::Diabetes[, seq(5L)] %>%
  princomp(cor = TRUE) %>%
  as_tbl_ord() %>%
  cbind_rows(group = heplots::Diabetes$group) %>%
  augment_ord() %>%
  print() -> diabetes_pca

# note that column standard coordinates are unit vectors
rowSums(get_cols(diabetes_pca)^2)

# plot column standard coordinates with a unit circle underlaid
diabetes_pca %>%
  ggbiplot(aes(label = name), sec.axes = "cols", scale.factor = 3) +
  geom_rows_point(aes(color = group), alpha = .25) +
  geom_unit_circle(alpha = .5, scale.factor = 3) +
  geom_cols_vector() +
  geom_cols_text_radiate()



cleanEx()
nameEx("geom_vector")
### * geom_vector

flush(stderr()); flush(stdout())

### Name: geom_vector
### Title: Vectors from the origin
### Aliases: geom_vector

### ** Examples

# compute unscaled row-principal components of scaled measurements
(iris_pca <- ordinate(iris, cols = 1:4, princomp))

# row-principal biplot with coordinate-wise standard deviations
iris_pca %>%
  ggbiplot(aes(color = Species)) +
  theme_bw() +
  scale_color_brewer(type = "qual", palette = 2) +
  geom_unit_circle() +
  geom_rows_point(alpha = .5) +
  geom_cols_vector(color = "#444444") +
  geom_cols_text_radiate(aes(label = name), color = "#444444") +
  ggtitle("Row-principal unscaled PCA biplot of Anderson iris measurements") +
  expand_limits(y = c(NA, 2))



cleanEx()
nameEx("ggbiplot")
### * ggbiplot

flush(stderr()); flush(stdout())

### Name: ggbiplot
### Title: Biplots following the grammar of graphics
### Aliases: ggbiplot ord_aes

### ** Examples

# compute PCA of Anderson iris measurements
iris[, -5] %>%
  princomp(cor = TRUE) %>%
  as_tbl_ord() %>%
  confer_inertia(1) %>%
  mutate_rows(species = iris$Species) %>%
  mutate_cols(measure = gsub("\\.", " ", tolower(names(iris)[-5]))) %>%
  print() -> iris_pca

# row-principal biplot with rescaled secondary axis
iris_pca %>%
  ggbiplot(aes(color = species), sec.axes = "cols", scale.factor = 2) +
  theme_bw() +
  scale_color_brewer(type = "qual", palette = 2) +
  geom_rows_point() +
  geom_cols_vector(color = "#444444") +
  geom_cols_text_radiate(aes(label = measure), color = "#444444") +
  ggtitle(
    "Row-principal PCA biplot of Anderson iris measurements",
    "Variable loadings scaled to secondary axes"
  ) +
  expand_limits(y = c(-1, 3.5))
# Performance measures can be regressed on the artificial coordinates of
# ordinated vehicle specs. Because the ordination of specs ignores performance,
# these coordinates will probably not be highly predictive. The gradient of each
# performance measure along the artificial axes is visualized by projecting the
# regression coefficients onto the ordination biplot.

# scaled principal components analysis of vehicle specs
mtcars_specs_pca <- ordinate(
  mtcars, cols = c(cyl, disp, hp, drat, wt, vs, carb),
  model = ~ princomp(., cor = TRUE)
)
# data frame of vehicle performance measures
mtcars %>%
  subset(select = c(mpg, qsec)) %>%
  as.matrix() %>%
  print() -> mtcars_perf
# regress performance measures on principal components
lm(mtcars_perf ~ get_rows(mtcars_specs_pca)) %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  print() -> mtcars_pca_lm
# regression biplot
ggbiplot(mtcars_specs_pca, aes(label = name),
         sec.axes = "rows", scale.factor = .5) +
  theme_minimal() +
  geom_rows_text(size = 3) +
  geom_cols_vector(data = mtcars_pca_lm) +
  geom_cols_text_radiate(data = mtcars_pca_lm) +
  expand_limits(x = c(-2.5, 2))

# multidimensional scaling based on a scaled cosine distance of vehicle specs
cosine_dist <- function(x) {
  x <- as.matrix(x)
  num <- x %*% t(x)
  denom_rt <- as.matrix(rowSums(x^2))
  denom <- sqrt(denom_rt %*% t(denom_rt))
  as.dist(1 - num / denom)
}
mtcars %>%
  subset(select = c(cyl, disp, hp, drat, wt, vs, carb)) %>%
  scale() %>%
  cosine_dist() %>%
  cmdscale() %>%
  as.data.frame() ->
  mtcars_specs_cmds
# names must be consistent with `cmdscale_ord()` below
names(mtcars_specs_cmds) <- c("PCo1", "PCo2")
# regress performance measures on principal coordinates
lm(mtcars_perf ~ as.matrix(mtcars_specs_cmds)) %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  print() -> mtcars_cmds_lm
# multidimensional scaling using `cmdscale_ord()`
mtcars %>%
  subset(select = c(cyl, disp, hp, drat, wt, vs, carb)) %>%
  scale() %>%
  cosine_dist() %>%
  cmdscale_ord() %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  print() -> mtcars_specs_cmds_ord
# regression biplot
ggbiplot(mtcars_specs_cmds_ord, aes(label = name),
         sec.axes = "rows", scale.factor = 3) +
  theme_minimal() +
  geom_rows_text(size = 3) +
  geom_cols_vector(data = mtcars_cmds_lm) +
  geom_cols_text_radiate(data = mtcars_cmds_lm) +
  expand_limits(x = c(-2.25, 1.25), y = c(-2, 1.5))
# PCA of iris data
iris_pca <- ordinate(iris, cols = 1:4, prcomp, scale = TRUE)

# row-principal predictive biplot
iris_pca %>%
  augment_ord() %>%
  ggbiplot(axis.type = "predictive") +
  theme_bw() +
  scale_color_brewer(type = "qual", palette = 2) +
  geom_cols_axis(aes(label = name, center = center, scale = scale)) +
  geom_rows_point(aes(color = Species), alpha = .5) +
  ggtitle("Predictive biplot of Anderson iris measurements")



cleanEx()
nameEx("glass")
### * glass

flush(stderr()); flush(stdout())

### Name: glass
### Title: Glass composition data
### Aliases: glass
### Keywords: datasets

### ** Examples

# subset glass data to one site and major components
head(glass)
glass_main <- subset(
  glass,
  Site == "Bet Eli'ezer",
  select = c("SiO2", "Na2O", "CaO", "Al2O3", "MgO", "K2O")
)
# format as a data frame with row names
glass_main <- as.data.frame(glass_main)
rownames(glass_main) <- subset(glass, Site == "Bet Eli'ezer")$Anal

# perform log-ratio analysis
glass_lra <- lra(glass_main, compositional = TRUE, weighted = FALSE)
# inspect LRA row and column coordinates
head(glass_lra$row.coords)
glass_lra$column.coords
# inspect singular values of LRA
glass_lra$sv

# plot samples and measurements in a biplot
biplot(
  x = glass_lra$row.coords %*% diag(glass_lra$sv),
  y = glass_lra$column.coords,
  xlab = "Sample (principal coord.)", ylab = ""
)
mtext("Component (standard coord.)", side = 4L, line = 3L)



cleanEx()
nameEx("lda-ord")
### * lda-ord

flush(stderr()); flush(stdout())

### Name: lda-ord
### Title: Augmented implementation of linear discriminant analysis
### Aliases: lda-ord lda_ord lda_ord.formula lda_ord.data.frame
###   lda_ord.matrix lda_ord.default predict.lda_ord

### ** Examples

# Anderson iris species data centroid
iris_centroid <- t(apply(iris[, 1:4], 2, mean))
# unstandardized discriminant coefficients: the discriminant axes are linear
# combinations of the centered variables
iris_lda <- lda_ord(iris[, 1:4], iris[, 5], axes.scale = "unstandardized")
# linear combinations of centered variables
print(sweep(iris_lda$means, 2, iris_centroid, "-") %*% get_cols(iris_lda))
# discriminant centroids
print(get_rows(iris_lda, elements = "active"))

# unstandardized coefficient LDA biplot
iris_lda %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  mutate_rows(
    species = grouping,
    discriminant = ifelse(.element == "active", "centroid", "case")
  ) %>%
  ggbiplot() +
  theme_bw() +
  geom_rows_point(aes(
    color = grouping,
    size = discriminant, alpha = discriminant
  )) +
  geom_cols_vector(color = "#888888") +
  geom_cols_text_radiate(aes(label = name), size = 3) +
  scale_color_brewer(type = "qual", palette = 2) +
  ggtitle("Unstandardized coefficient biplot of iris LDA") +
  expand_limits(y = c(-3, 5))

# standardized discriminant coefficients: permit comparisons across the
# variables
iris_lda <- lda_ord(iris[, 1:4], iris[, 5], axes.scale = "standardized")
# standardized variable contributions to discriminant axes
iris_lda %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  fortify(.matrix = "cols") %>%
  dplyr::mutate(variable = name) %>%
  tidyr::gather(discriminant, coefficient, LD1, LD2) %>%
  ggplot(aes(x = discriminant, y = coefficient, fill = variable)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(y = "Standardized coefficient", x = "Linear discriminant") +
  theme_bw() +
  coord_flip()
# standardized coefficient LDA biplot
iris_lda %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  mutate_rows(
    species = grouping,
    discriminant = ifelse(.element == "active", "centroid", "case")
  ) %>%
  ggbiplot() +
  theme_bw() +
  geom_rows_point(aes(
    color = grouping,
    size = discriminant, alpha = discriminant
  )) +
  geom_cols_vector(color = "#888888") +
  geom_cols_text_radiate(aes(label = name), size = 3) +
  scale_color_brewer(type = "qual", palette = 2) +
  ggtitle("Standardized coefficient biplot of iris LDA") +
  expand_limits(y = c(-2, 3))

# variable contributions (de-sphered discriminant coefficients): recover the
# inner product relationship with the centered class centroids
iris_lda <- lda_ord(iris[, 1:4], iris[, 5], axes.scale = "contribution")
# symmetric square root of within-class covariance
C_W_eig <- eigen(cov(iris[, 1:4] - iris_lda$means[iris[, 5], ]))
C_W_sqrtinv <-
  C_W_eig$vectors %*% diag(1/sqrt(C_W_eig$values)) %*% t(C_W_eig$vectors)
# product of matrix factors (scores and loadings)
print(get_rows(iris_lda, elements = "active") %*% t(get_cols(iris_lda)))
# "asymmetric" square roots of Mahalanobis distances between variables
print(sweep(iris_lda$means, 2, iris_centroid, "-") %*% C_W_sqrtinv)
# contribution LDA biplot
iris_lda %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  mutate_rows(
    species = grouping,
    discriminant = ifelse(.element == "active", "centroid", "case")
  ) %>%
  ggbiplot() +
  theme_bw() +
  geom_rows_point(aes(
    color = grouping,
    size = discriminant, alpha = discriminant
  )) +
  geom_cols_vector(color = "#888888") +
  geom_cols_text_radiate(aes(label = name), size = 3) +
  scale_color_brewer(type = "qual", palette = 2) +
  ggtitle("Contribution biplot of iris LDA") +
  expand_limits(y = c(-2, 3.5))



cleanEx()
nameEx("lra-ord")
### * lra-ord

flush(stderr()); flush(stdout())

### Name: lra-ord
### Title: Log-ratio analysis
### Aliases: lra-ord lra print.lra screeplot.lra biplot.lra plot.lra

### ** Examples

# U.S. 1973 violent crime arrests
head(USArrests)
# row and column subsets
state_examples <- c("Hawaii", "Mississippi", "North Dakota")
arrests <- c(1L, 2L, 4L)

# pairwise log-ratios of violent crime arrests for two states
arrest_pairs <- combn(arrests, 2L)
arrest_ratios <-
  USArrests[, arrest_pairs[1L, ]] / USArrests[, arrest_pairs[2L, ]]
colnames(arrest_ratios) <- paste(
  colnames(USArrests)[arrest_pairs[1L, ]], "/",
  colnames(USArrests)[arrest_pairs[2L, ]], sep = ""
)
arrest_logratios <- log(arrest_ratios)
arrest_logratios[state_examples, ]

# non-compositional log-ratio analysis
(arrests_lra <- lra(USArrests[, arrests]))
screeplot(arrests_lra)
biplot(arrests_lra, scale = c(1, 0))

# compositional log-ratio analysis
(arrests_lra <- lra(USArrests[, arrests], compositional = TRUE))
biplot(arrests_lra, scale = c(1, 0))



cleanEx()
nameEx("methods-cancor")
### * methods-cancor

flush(stderr()); flush(stdout())

### Name: methods-cancor
### Title: Functionality for canonical correlations
### Aliases: methods-cancor as_tbl_ord.cancor_ord recover_rows.cancor_ord
###   recover_cols.cancor_ord recover_inertia.cancor_ord
###   recover_coord.cancor_ord recover_conference.cancor_ord
###   recover_supp_rows.cancor_ord recover_supp_cols.cancor_ord
###   recover_aug_rows.cancor_ord recover_aug_cols.cancor_ord
###   recover_aug_coord.cancor_ord

### ** Examples

# data frame of life-cycle savings across countries
class(LifeCycleSavings)
head(LifeCycleSavings)
savings_pop <- LifeCycleSavings[, c("pop15", "pop75")]
savings_oec <- LifeCycleSavings[, c("sr", "dpi", "ddpi")]

# canonical correlation analysis with scores and correlations included
savings_cca <- cancor_ord(savings_pop, savings_oec, scores = TRUE)
savings_cca <- augment_ord(as_tbl_ord(savings_cca))
head(get_cols(savings_cca))
head(get_cols(savings_cca, elements = "score"))
get_rows(savings_cca, elements = "structure")
get_cols(savings_cca, elements = "structure")

# biplot of interset and intraset correlations with the population data
savings_cca %>%
  confer_inertia("cols") %>%
  ggbiplot(aes(label = name, color = .matrix)) +
  theme_bw() + theme_biplot() +
  geom_unit_circle() +
  geom_rows_vector(arrow = NULL, elements = "structure") +
  geom_cols_vector(arrow = NULL, elements = "structure", linetype = "dashed") +
  geom_rows_text(elements = "structure", hjust = "outward") +
  geom_cols_text(elements = "structure", hjust = "outward") +
  scale_color_brewer(limits = c("rows", "cols"), type = "qual") +
  expand_limits(x = c(-1, 1), y = c(-1, 1))

# biplot with scores as supplemental elements
savings_cca %>%
  confer_inertia("rows") %>%
  ggbiplot(aes(label = name), sec.axes = "cols", scale.factor = 5L) +
  theme_biplot() +
  geom_cols_vector(elements = "active") +
  geom_cols_text_radiate(elements = "active") +
  geom_rows_text(elements = "score", subset = seq(50L))



cleanEx()
nameEx("methods-cmds")
### * methods-cmds

flush(stderr()); flush(stdout())

### Name: methods-cmds
### Title: Functionality for classical multidimensional scaling objects
### Aliases: methods-cmds as_tbl_ord.cmds_ord recover_rows.cmds_ord
###   recover_cols.cmds_ord recover_inertia.cmds_ord recover_coord.cmds_ord
###   recover_conference.cmds_ord recover_aug_rows.cmds_ord
###   recover_aug_cols.cmds_ord recover_aug_coord.cmds_ord

### ** Examples

# 'dist' object (matrix of road distances) of large American cities
class(UScitiesD)
print(UScitiesD)

# use multidimensional scaling to infer artificial planar coordinates
UScitiesD %>%
  cmdscale_ord(k = 2) %>%
  as_tbl_ord() %>%
  print() -> usa_mds

# recover (equivalent) matrices of row and column artificial coordinates
get_rows(usa_mds)
get_cols(usa_mds)

# augment ordination with point names
(usa_mds <- augment_ord(usa_mds))

# reorient biplot to conventional compass
usa_mds %>%
  negate_ord(c(1, 2)) %>%
  ggbiplot() +
  geom_cols_text(aes(label = name), size = 3) +
  ggtitle("MDS biplot of distances between U.S. cities")



cleanEx()
nameEx("methods-correspondence")
### * methods-correspondence

flush(stderr()); flush(stdout())

### Name: methods-correspondence
### Title: Functionality for correspondence analysis ('correspondence')
###   objects
### Aliases: methods-correspondence as_tbl_ord.correspondence
###   recover_rows.correspondence recover_cols.correspondence
###   recover_inertia.correspondence recover_conference.correspondence
###   recover_coord.correspondence recover_aug_rows.correspondence
###   recover_aug_cols.correspondence recover_aug_coord.correspondence

### ** Examples

# table of hair and eye color data collapsed by sex
data(quine, package = "MASS")
class(quine)
head(quine)

# use correspondence analysis to construct row and column profiles
(quine_ca <- MASS::corresp(~ Age + Eth, data = quine))
(quine_ca <- as_tbl_ord(quine_ca))

# recover row and column profiles
get_rows(quine_ca)
get_cols(quine_ca)

# augment profiles with names, masses, distances, and inertias
(quine_ca <- augment_ord(quine_ca))



cleanEx()
nameEx("methods-eigen")
### * methods-eigen

flush(stderr()); flush(stdout())

### Name: methods-eigen
### Title: Functionality for eigen-decompositions
### Aliases: methods-eigen as_tbl_ord.eigen recover_rows.eigen
###   recover_cols.eigen recover_inertia.eigen recover_coord.eigen
###   recover_conference.eigen recover_aug_rows.eigen_ord
###   recover_aug_cols.eigen_ord recover_aug_coord.eigen
###   as_tbl_ord.eigen_ord recover_rows.eigen_ord recover_cols.eigen_ord
###   recover_inertia.eigen_ord recover_coord.eigen_ord
###   recover_conference.eigen_ord recover_aug_coord.eigen_ord

### ** Examples

# subset QS data to rank variables
qs_ranks <- subset(
  qswur_usa,
  complete.cases(qswur_usa),
  select = 8:13
)
head(qs_ranks)

# eigendecomposition of Kendall correlation matrix
qs_ranks %>%
  cor(method = "kendall") %>%
  eigen() %>%
  print() -> qs_eigen

# recover eigenvectors
get_rows(qs_eigen)
identical(get_cols(qs_eigen), get_rows(qs_eigen))

# wrap as a 'tbl_ord'
as_tbl_ord(qs_eigen)

# same eigendecomposition, preserving row names and adding column names
qs_ranks %>%
  cor(method = "kendall") %>%
  eigen_ord() %>%
  print() -> qs_eigen

# wrap as a 'tbl_ord' and augment with dimension names
augment_ord(as_tbl_ord(qs_eigen))

# decomposition returns pure eigenvectors
get_conference(qs_eigen)



cleanEx()
nameEx("methods-factanal")
### * methods-factanal

flush(stderr()); flush(stdout())

### Name: methods-factanal
### Title: Functionality for factor analysis ('factanal') objects
### Aliases: methods-factanal as_tbl_ord.factanal recover_rows.factanal
###   recover_cols.factanal recover_inertia.factanal recover_coord.factanal
###   recover_conference.factanal recover_supp_rows.factanal
###   recover_aug_rows.factanal recover_aug_cols.factanal
###   recover_aug_coord.factanal

### ** Examples

# data frame of Swiss fertility and socioeconomic indicators
class(swiss)
head(swiss)
# perform factor analysis
swiss_fa <- factanal(~ ., factors = 2L, data = swiss, scores = "regression")

# wrap as a 'tbl_ord' object
(swiss_fa <- as_tbl_ord(swiss_fa))

# recover loadings
get_rows(swiss_fa, elements = "active")
get_cols(swiss_fa)
# recover scores
head(get_rows(swiss_fa, elements = "score"))

# augment column loadings with uniquenesses
(swiss_fa <- augment_ord(swiss_fa))

# symmetric biplot
swiss_fa %>%
  ggbiplot() +
  theme_bw() +
  geom_cols_vector(aes(color = uniqueness)) +
  geom_cols_text_radiate(aes(label = name)) +
  expand_limits(x = c(-2, 2.5), y = c(-1.5, 2))



cleanEx()
nameEx("methods-kmeans")
### * methods-kmeans

flush(stderr()); flush(stdout())

### Name: methods-kmeans
### Title: Functionality for k-means clustering ('kmeans') objects
### Aliases: methods-kmeans as_tbl_ord.kmeans recover_rows.kmeans
###   recover_cols.kmeans recover_coord.kmeans recover_aug_rows.kmeans
###   recover_aug_cols.kmeans recover_aug_coord.kmeans

### ** Examples

# data frame of Anderson iris species measurements
class(iris)
head(iris)
# compute 3-means clustering on scaled iris measurements
set.seed(5601L)
iris %>%
  subset(select = -Species) %>%
  scale() %>%
  kmeans(centers = 3) %>%
  print() -> iris_km

# visualize clusters using PCA
iris %>%
  subset(select = -Species) %>%
  prcomp() %>%
  as_tbl_ord() %>%
  mutate_rows(cluster = iris_km$cluster) %>%
  ggbiplot() +
  geom_rows_point(aes(color = factor(as.character(as.integer(cluster)),
                                     levels = as.character(seq(3L))))) +
  scale_color_brewer(type = "qual", name = "cluster")

# wrap as a 'tbl_ord' object
(iris_km_ord <- as_tbl_ord(iris_km))

# augment everything with names, observations with cluster assignment
(iris_km_ord <- augment_ord(iris_km_ord))

# summarize clusters with standard deviation
iris_km_ord %>%
  tidy() %>%
  transform(sdev = sqrt(withinss / size))

# discriminate between clusters 2 and 3
iris_km_ord %>%
  ggbiplot(aes(x = `2`, y = `3`), color = factor(.cluster)) +
  geom_jitter(stat = "rows", aes(shape = cluster), width = .2, height = .2) +
  geom_cols_axis(aes(color = `1`, label = name),
                 text_size = 2, text_dodge = .1,
                 label_size = 3, label_alpha = .5) +
  scale_x_continuous(expand = expansion(mult = .8)) +
  scale_y_continuous(expand = expansion(mult = .5)) +
  ggtitle(
    "Measurement loadings onto clusters 2 and 3",
    "Color indicates loadings onto cluster 1"
  )



cleanEx()
nameEx("methods-lda")
### * methods-lda

flush(stderr()); flush(stdout())

### Name: methods-lda
### Title: Functionality for linear discriminant analysis ('lda') objects
### Aliases: methods-lda as_tbl_ord.lda as_tbl_ord.lda_ord recover_rows.lda
###   recover_rows.lda_ord recover_cols.lda recover_cols.lda_ord
###   recover_inertia.lda recover_inertia.lda_ord recover_coord.lda
###   recover_coord.lda_ord recover_conference.lda
###   recover_conference.lda_ord recover_aug_rows.lda
###   recover_aug_rows.lda_ord recover_aug_cols.lda
###   recover_aug_cols.lda_ord recover_aug_coord.lda
###   recover_aug_coord.lda_ord recover_supp_rows.lda
###   recover_supp_rows.lda_ord

### ** Examples

# data frame of Anderson iris species measurements
class(iris)
head(iris)

# default (unstandardized discriminant) coefficients
lda_ord(iris[, 1:4], iris[, 5]) %>%
  as_tbl_ord() %>%
  print() -> iris_lda

# recover centroid coordinates and measurement discriminant coefficients
get_rows(iris_lda, elements = "active")
head(get_rows(iris_lda, elements = "score"))
get_cols(iris_lda)

# augment ordination with centroid and measurement names
augment_ord(iris_lda)



cleanEx()
nameEx("methods-lm")
### * methods-lm

flush(stderr()); flush(stdout())

### Name: methods-lm
### Title: Functionality for linear model objects
### Aliases: methods-lm as_tbl_ord.lm recover_rows.lm recover_cols.lm
###   recover_coord.lm recover_aug_rows.lm recover_aug_cols.lm
###   recover_aug_coord.lm recover_aug_rows.glm recover_rows.mlm
###   recover_cols.mlm recover_coord.mlm recover_aug_rows.mlm
###   recover_aug_cols.mlm recover_aug_coord.mlm

### ** Examples

# Motor Trend design and performance data
head(mtcars)
# regression analysis of performance measures on design specifications
mtcars_centered <- scale(mtcars, scale = FALSE)
mtcars_centered %>%
  as.data.frame() %>%
  lm(formula = mpg ~ wt + cyl) %>%
  print() -> mtcars_lm

# wrap as a 'tbl_ord' object
(mtcars_lm_ord <- as_tbl_ord(mtcars_lm))
# augment everything with names, predictors with observation stats
augment_ord(mtcars_lm_ord)
# calculate influences as the squares of weighted residuals
mutate_rows(augment_ord(mtcars_lm_ord), influence = wt.res^2)

# regression biplot with performance isolines
mtcars_lm_ord %>%
  augment_ord() %>%
  mutate_cols(center = attr(mtcars_centered, "scaled:center")[name]) %>%
  mutate_rows(influence = wt.res^2) %T>% print() %>%
  ggbiplot(aes(x = wt, y = cyl, intercept = `(Intercept)`)) +
  #theme_biplot() +
  geom_origin(marker = "circle", radius = unit(0.02, "snpc")) +
  geom_rows_point(aes(color = influence)) +
  geom_cols_vector() +
  geom_cols_isoline(aes(center = center), by = .5, hjust = -.1) +
  ggtitle(
    "Weight isolines with data colored by importance",
    "Regressing gas mileage onto weight and number of cylinders"
  )



cleanEx()
nameEx("methods-lra")
### * methods-lra

flush(stderr()); flush(stdout())

### Name: methods-lra
### Title: Functionality for log-ratio analysis ('lra') objects
### Aliases: methods-lra as_tbl_ord.lra recover_rows.lra recover_cols.lra
###   recover_inertia.lra recover_coord.lra recover_conference.lra
###   recover_aug_rows.lra recover_aug_cols.lra recover_aug_coord.lra

### ** Examples

# data frame of violent crime arrests in the United States
class(USArrests)
head(USArrests)
# get state abbreviation data
state <- data.frame(
  name = state.name,
  abb = state.abb
)

# compute (non-compositional, unweighted) log-ratio analysis
USArrests %>%
  subset(select = -UrbanPop) %>%
  lra() %>%
  as_tbl_ord() %>%
  print() -> arrests_lra

# augment log-ratio profiles with names and join state abbreviations
arrests_lra %>%
  augment_ord() %>%
  left_join_rows(state, by = "name") %>%
  print() -> arrests_lra

# recover state and arrest profiles
head(get_rows(arrests_lra))
get_cols(arrests_lra)
# initially, inertia is conferred on neither factor
get_conference(arrests_lra)

# row-principal biplot
arrests_lra %>%
  confer_inertia("rows") %>%
  ggbiplot(aes(color = .matrix), sec.axes = "cols", scale.factor = 1/20) +
  scale_color_manual(values = c("tomato4", "turquoise4")) +
  theme_bw() +
  geom_rows_text(aes(label = abb), size = 3, alpha = .75) +
  geom_cols_polygon(fill = NA, linetype = "dashed") +
  geom_cols_text(aes(label = name, size = weight), fontface = "bold") +
  scale_size_area(guide = "none") +
  ggtitle(
    "Non-compositional LRA of violent crime arrest rates",
    "United States, 1973"
  ) +
  expand_limits(x = c(-.35)) +
  guides(color = "none")



cleanEx()
nameEx("methods-mca")
### * methods-mca

flush(stderr()); flush(stdout())

### Name: methods-mca
### Title: Functionality for multiple correspondence analysis ('mca')
###   objects
### Aliases: methods-mca as_tbl_ord.mca recover_rows.mca recover_cols.mca
###   recover_inertia.mca recover_conference.mca recover_coord.mca
###   recover_supp_rows.mca recover_aug_rows.mca recover_aug_cols.mca
###   recover_aug_coord.mca

### ** Examples

# table of admissions and rejections from UC Berkeley
class(UCBAdmissions)
ucb_admissions <- as.data.frame(UCBAdmissions)
ucb_admissions <-
  ucb_admissions[rep(seq(nrow(ucb_admissions)), ucb_admissions$Freq), -4L]
head(ucb_admissions)
# perform multiple correspondence analysis
ucb_admissions %>%
  MASS::mca() %>%
  as_tbl_ord() %>%
  # augment profiles with names, masses, distances, and inertias
  augment_ord() %>%
  print() -> admissions_mca

# recover row and column coordinates and row weights
head(get_rows(admissions_mca, elements = "score"))
get_cols(admissions_mca)
head(get_rows(admissions_mca))

# column-standard biplot of factor levels
admissions_mca %>%
  ggbiplot() +
  theme_bw() + theme_biplot() +
  geom_origin() +
  #geom_rows_point(stat = "unique") +
  geom_cols_point(aes(color = factor, shape = factor)) +
  geom_cols_text_repel(aes(label = level, color = factor),
                       show.legend = FALSE) +
  scale_color_brewer(palette = "Dark2") +
  scale_size_area(guide = "none") +
  labs(color = "Factor level", shape = "Factor level")



cleanEx()
nameEx("methods-prcomp")
### * methods-prcomp

flush(stderr()); flush(stdout())

### Name: methods-prcomp
### Title: Functionality for principal components analysis ('prcomp')
###   objects
### Aliases: methods-prcomp as_tbl_ord.prcomp recover_rows.prcomp
###   recover_cols.prcomp recover_inertia.prcomp recover_coord.prcomp
###   recover_conference.prcomp recover_aug_rows.prcomp
###   recover_aug_cols.prcomp recover_aug_coord.prcomp

### ** Examples

# data frame of Anderson iris species measurements
class(iris)
head(iris)

# compute scaled row-principal components of scaled measurements
iris[, -5] %>%
  prcomp(scale = TRUE) %>%
  as_tbl_ord() %>%
  print() -> iris_pca

# recover observation principal coordinates and measurement standard coordinates
head(get_rows(iris_pca))
get_cols(iris_pca)

# augment measurements with names and scaling parameters
(iris_pca <- augment_ord(iris_pca))



cleanEx()
nameEx("methods-princomp")
### * methods-princomp

flush(stderr()); flush(stdout())

### Name: methods-princomp
### Title: Functionality for principal components analysis ('princomp')
###   objects
### Aliases: methods-princomp as_tbl_ord.princomp recover_rows.princomp
###   recover_cols.princomp recover_inertia.princomp recover_coord.princomp
###   recover_conference.princomp recover_aug_rows.princomp
###   recover_aug_cols.princomp recover_aug_coord.princomp

### ** Examples

# data frame of Anderson iris species measurements
class(iris)
head(iris)

# compute unscaled row-principal components of scaled measurements
iris[, -5] %>%
  princomp() %>%
  as_tbl_ord() %>%
  print() -> iris_pca

# recover observation principal coordinates and measurement standard coordinates
head(get_rows(iris_pca))
get_cols(iris_pca)

# augment measurement coordinates with names and scaling parameters
(iris_pca <- augment_ord(iris_pca))



cleanEx()
nameEx("methods-svd")
### * methods-svd

flush(stderr()); flush(stdout())

### Name: methods-svd
### Title: Functionality for singular value decompositions
### Aliases: methods-svd as_tbl_ord.svd_ord recover_rows.svd_ord
###   recover_cols.svd_ord recover_inertia.svd_ord recover_coord.svd_ord
###   recover_conference.svd_ord recover_aug_rows.svd_ord
###   recover_aug_cols.svd_ord recover_aug_coord.svd_ord

### ** Examples

# matrix of U.S. personal expenditure data
class(USPersonalExpenditure)
print(USPersonalExpenditure)
# singular value decomposition into row and column coordinates
USPersonalExpenditure %>%
  svd_ord() %>%
  as_tbl_ord() %>%
  print() -> spend_svd

# recover matrices of row and column coordinates
get_rows(spend_svd)
get_cols(spend_svd)

# augment with row and column names
augment_ord(spend_svd)
# initial matrix decomposition confers no inertia to coordinates
get_conference(spend_svd)



cleanEx()
nameEx("negation")
### * negation

flush(stderr()); flush(stdout())

### Name: negation
### Title: Negation of ordination axes
### Aliases: negation get_negation revert_negation negate_ord
###   negate_to_first_orthant

### ** Examples

(pca <- ordinate(iris, cols = 1:4, prcomp))
ggbiplot(pca) + geom_rows_point() + geom_cols_vector()

# manually negate second coordinate
(pca_neg <- negate_ord(pca, 2))
ggbiplot(pca_neg) + geom_rows_point() + geom_cols_vector()

# NB: 'prcomp' method takes precedence; negations are part of the wrapper
biplot(pca)
biplot(pca_neg)

# negate to the first orthant
(pca_orth <- negate_to_first_orthant(pca, "v"))
get_negation(pca_orth)



cleanEx()
nameEx("ordinate")
### * ordinate

flush(stderr()); flush(stdout())

### Name: ordinate
### Title: Fit an ordination model to a data object
### Aliases: ordinate ordinate.default ordinate.array ordinate.table
###   ordinate.data.frame ordinate.dist

### ** Examples

# LRA of arrest data
ordinate(USArrests, cols = c(Murder, Rape, Assault), lra)

# CMDS of inter-city distance data
ordinate(UScitiesD, cmdscale_ord, k = 3L)

# PCA of iris data
ordinate(iris, princomp, cols = -Species, augment = c(Sepal.Width, Species))
ordinate(iris, cols = 1:4, ~ prcomp(., center = TRUE, scale. = TRUE))

# CA of hair & eye color data
haireye <- as.data.frame(rowSums(HairEyeColor, dims = 2L))
ordinate(haireye, MASS::corresp, cols = everything())

# FA of Swiss social data
ordinate(swiss, model = factanal, factors = 2L, scores = "Bartlett")

# LDA of iris data
ordinate(iris, ~ lda_ord(.[, 1:4], .[, 5], ret.x = TRUE))

# CCA of savings data
ordinate(
  LifeCycleSavings[, c("pop15", "pop75")],
  # second data set must be handled as an additional parameter to `model`
  y = LifeCycleSavings[, c("sr", "dpi", "ddpi")],
  model = cancor_ord, scores = TRUE
)



cleanEx()
nameEx("plot.tbl_ord")
### * plot.tbl_ord

flush(stderr()); flush(stdout())

### Name: plot.tbl_ord
### Title: Plot and biplot methods for 'tbl_ord' objects
### Aliases: plot.tbl_ord

### ** Examples

# note: behavior depends on installed packages with class-specific methods

# class 'prcomp'
iris_pca <- prcomp(iris[, -5L], scale = TRUE)
iris_pca_ord <- as_tbl_ord(iris_pca)
plot(iris_pca)
plot(iris_pca_ord)
screeplot(iris_pca)
screeplot(iris_pca_ord)
biplot(iris_pca)
biplot(iris_pca_ord)

# class 'correspondence'
haireye_ca <- MASS::corresp(rowSums(HairEyeColor, dims = 2L), nf = 2L)
haireye_ca_ord <- as_tbl_ord(haireye_ca)
plot(haireye_ca)
plot(haireye_ca_ord)
# no `screeplot()` method for class 'correspondence'
screeplot(haireye_ca_ord)
biplot(haireye_ca)
biplot(haireye_ca_ord)



cleanEx()
nameEx("qswur_usa")
### * qswur_usa

flush(stderr()); flush(stdout())

### Name: qswur_usa
### Title: U.S. university rankings
### Aliases: qswur_usa
### Keywords: datasets

### ** Examples

# subset QS data to rank variables
head(qswur_usa)
qs_ranks <- subset(
  qswur_usa,
  complete.cases(qswur_usa),
  select = 8:13
)
# calculate Kendall correlation matrix
qs_cor <- cor(qs_ranks, method = "kendall")

# calculate eigendecomposition
qs_eigen <- eigen_ord(qs_cor)
# view correlations as cosines of biplot vectors
biplot(x = qs_eigen$vectors, y = qs_eigen$vectors, col = c(NA, "black"))



cleanEx()
nameEx("recoverers")
### * recoverers

flush(stderr()); flush(stdout())

### Name: recoverers
### Title: Access factors, coordinates, and metadata from ordination
###   objects
### Aliases: recoverers recover_rows recover_cols recover_rows.default
###   recover_cols.default recover_rows.data.frame recover_cols.data.frame
###   get_rows get_cols as.matrix.tbl_ord recover_inertia
###   recover_inertia.default recover_coord recover_coord.default
###   recover_coord.data.frame get_coord get_inertia dim.tbl_ord

### ** Examples

# example ordination: LRA of U.S. arrests data
arrests_lra <- ordinate(USArrests, cols = c(Murder, Rape, Assault), lra)

# extract matrix factors
as.matrix(arrests_lra, .matrix = "rows")
as.matrix(arrests_lra, .matrix = "cols")
# special named functions
get_rows(arrests_lra)
get_cols(arrests_lra)
# get dimensions of underlying matrix factorization (not of original data)
dim(arrests_lra)

# get names of artificial / latent coordinates
get_coord(arrests_lra)
# get distribution of inertia
get_inertia(arrests_lra)



cleanEx()
nameEx("stat_center")
### * stat_center

flush(stderr()); flush(stdout())

### Name: stat_center
### Title: Compute geometric centers and spreads for ordination factors
### Aliases: stat_center stat_star

### ** Examples

# scaled PCA of Anderson iris measurements
iris[, -5] %>%
  princomp(cor = TRUE) %>%
  as_tbl_ord() %>%
  mutate_rows(species = iris$Species) %>%
  print() -> iris_pca

# row-principal biplot with centroid-based stars
iris_pca %>%
  ggbiplot(aes(color = species)) +
  theme_bw() +
  scale_color_brewer(type = "qual", palette = 2) +
  stat_rows_star(alpha = .5, fun.center = "mean") +
  geom_rows_point(alpha = .5) +
  stat_rows_center(fun.center = "mean", size = 4, shape = 1L) +
  ggtitle(
    "Row-principal PCA biplot of Anderson iris measurements",
    "Segments connect each observation to its within-species centroid"
  )



cleanEx()
nameEx("stat_chull")
### * stat_chull

flush(stderr()); flush(stdout())

### Name: stat_chull
### Title: Restrict geometric data to boundary points for its convex hull
### Aliases: stat_chull

### ** Examples

# correspondence analysis of combined female and male hair and eye color data
HairEyeColor %>%
  rowSums(dims = 2L) %>%
  MASS::corresp(nf = 2L) %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  print() -> hec_ca
# inertia across artificial coordinates (all singular values < 1)
get_inertia(hec_ca)

# in row-principal biplot, row coordinates are weighted averages of columns
hec_ca %>%
  confer_inertia("rows") %>%
  ggbiplot(aes(color = .matrix, fill = .matrix, shape = .matrix)) +
  theme_bw() +
  stat_cols_chull(alpha = .1) +
  geom_cols_point() +
  geom_rows_point() +
  ggtitle("Row-principal CA of hair & eye color")
# in column-principal biplot, column coordinates are weighted averages of rows
hec_ca %>%
  confer_inertia("cols") %>%
  ggbiplot(aes(color = .matrix, fill = .matrix, shape = .matrix)) +
  theme_bw() +
  stat_rows_chull(alpha = .1) +
  geom_rows_point() +
  geom_cols_point() +
  ggtitle("Column-principal CA of hair & eye color")



cleanEx()
nameEx("stat_cone")
### * stat_cone

flush(stderr()); flush(stdout())

### Name: stat_cone
### Title: Restrict geometric data to boundary points for its conical hull
### Aliases: stat_cone

### ** Examples

# centered principal components analysis of U.S. personal expenditure data
USPersonalExpenditure %>%
  prcomp() %>%
  as_tbl_ord() %>%
  augment_ord() %>%
  # allow radiating text to exceed plotting window
  ggbiplot(aes(label = name), clip = "off",
           sec.axes = "cols", scale.factor = 50) +
  geom_rows_label(size = 3) +
  geom_cols_vector() +
  # omit labels in the conical hull without the origin
  stat_cols_cone(linetype = "dotted") +
  geom_cols_text_radiate(stat = "cone") +
  ggtitle(
    "U.S. Personal Expenditure data, 1940-1960",
    "Row-principal biplot of centered PCA"
  )



cleanEx()
nameEx("stat_rows")
### * stat_rows

flush(stderr()); flush(stdout())

### Name: stat_rows
### Title: Render plot elements for one matrix of an ordination
### Aliases: stat_rows stat_cols

### ** Examples

# FA of Swiss social data
swiss_fa <-
  ordinate(swiss, model = factanal, factors = 2L, scores = "regression")
# active and supplementary elements
get_rows(swiss_fa, elements = "active")
head(get_rows(swiss_fa, elements = "score"))

# biplot using element filters and selection
# (note that filter precedes selection)
ggbiplot(swiss_fa) +
  geom_rows_point(elements = "score") +
  geom_rows_text(aes(label = name), elements = "score", subset = c(1, 4, 18)) +
  scale_alpha_manual(values = c(0, 1), guide = "none") +
  geom_cols_vector() +
  geom_cols_text_radiate(aes(label = name))



cleanEx()
nameEx("stat_spantree")
### * stat_spantree

flush(stderr()); flush(stdout())

### Name: stat_spantree
### Title: Calculate a minimum spanning tree among cases or variables
### Aliases: stat_spantree

### ** Examples

## Not run: 
##D # classical multidimensional scaling of road distances between European cities
##D euro_mds <- ordinate(eurodist, cmdscale_ord, k = 11)
##D 
##D # biplot with minimal spanning tree based on full-dimensional distances
##D # (as implemented in {mlpack})
##D euro_mds %>%
##D   negate_ord("PCo2") %>%
##D   ggbiplot() +
##D   stat_cols_spantree(
##D     ord_aes(euro_mds), engine = "mlpack",
##D     alpha = .5, linetype = "dotted"
##D   ) +
##D   geom_cols_text(aes(label = name), size = 3) +
##D   ggtitle(
##D     "MDS biplot of road distances between European cities",
##D     "Dotted segments constitute the minimal spanning tree"
##D   )
## End(Not run)



cleanEx()
nameEx("tbl_ord")
### * tbl_ord

flush(stderr()); flush(stdout())

### Name: tbl_ord
### Title: A unified ordination object class
### Aliases: tbl_ord as_tbl_ord as_tbl_ord.tbl_ord make_tbl_ord is_tbl_ord
###   is.tbl_ord valid_tbl_ord un_tbl_ord

### ** Examples

# illustrative ordination: FA of Swiss social data
swiss_fa <- factanal(swiss, factors = 3L, scores = "regression")
print(swiss_fa)

# add the 'tbl_ord' wrapper
swiss_fa_ord <- as_tbl_ord(swiss_fa)
# inspect wrapped model
is_tbl_ord(swiss_fa_ord)
print(swiss_fa_ord)
valid_tbl_ord(swiss_fa_ord)
# unwrap the model
un_tbl_ord(swiss_fa_ord)

# create a 'tbl_ord' directly from row and column factors
# (missing inertia & other attributes)
swiss_fa_ord2 <- make_tbl_ord(rows = swiss_fa$scores, cols = swiss_fa$loadings)
# inspect wrapped factors
is_tbl_ord(swiss_fa_ord2)
print(swiss_fa_ord2)
valid_tbl_ord(swiss_fa_ord2)
# unwrap factors
un_tbl_ord(swiss_fa_ord2)



cleanEx()
nameEx("tidiers")
### * tidiers

flush(stderr()); flush(stdout())

### Name: tidiers
### Title: Tidiers for 'tbl_ord' objects
### Aliases: tidiers tidy.tbl_ord glance.tbl_ord fortify.tbl_ord

### ** Examples

# illustrative ordination: PCA of iris data
iris_pca <- ordinate(iris, ~ prcomp(., center = TRUE, scale. = TRUE), seq(4L))

# use `tidy()` to summarize distribution of inertia
tidy(iris_pca)
# this facilitates scree plots
tidy(iris_pca) %>%
  ggplot(aes(x = name, y = prop_var)) +
  geom_col() +
  scale_y_continuous(labels = scales::percent) +
  labs(x = NULL, y = "Proportion of variance")

# use `fortify()` to prepare either matrix factor for `ggplot()`
fortify(iris_pca, .matrix = "V") %>%
  ggplot(aes(x = name, y = PC1)) +
  geom_col() +
  coord_flip() +
  labs(x = "Measurement")
iris_pca %>%
  fortify(.matrix = "U") %>%
  ggplot(aes(x = PC1, fill = Species)) +
  geom_histogram() +
  labs(y = NULL)
# ... or to prepare both for `ggbiplot()`
fortify(iris_pca)

# use `glance()` to summarize the model as an ordination
glance(iris_pca)
# this enables comparisons to other models
rbind(
  glance(ordinate(subset(iris, Species == "setosa"), prcomp, seq(4L))),
  glance(ordinate(subset(iris, Species == "versicolor"), prcomp, seq(4L))),
  glance(ordinate(subset(iris, Species == "virginica"), prcomp, seq(4L)))
)



cleanEx()
nameEx("wrap-ord")
### * wrap-ord

flush(stderr()); flush(stdout())

### Name: wrap-ord
### Title: Wrappers for lossy ordination methods
### Aliases: wrap-ord eigen_ord svd_ord cmdscale_ord cancor_ord

### ** Examples

# glass composition data from one furnace
glass_banias <- subset(
  glass,
  Context == "L.15;B.166",
  select = c("SiO2", "Na2O", "CaO", "Al2O3", "MgO", "K2O")
)
# eigendecomposition of a covariance matrix
(glass_cov <- cov(glass_banias))
eigen_ord(glass_cov)
# singular value decomposition of a data matrix
svd_ord(glass_banias)
# classical multidimensional scaling of a distance matrix
cmdscale_ord(dist(glass_banias))

# canonical correlation analysis with trace components
glass_banias_minor <- subset(
  glass,
  Context == "L.15;B.166",
  select = c("TiO2", "FeO", "MnO", "P2O5", "Cl", "SO3")
)
# impute half of detection threshold
glass_banias_minor$TiO2[[1L]] <- 0.5
cancor_ord(glass_banias, glass_banias_minor)

# calculate canonical scores and structure correlations
glass_cca <-
  cancor_ord(glass_banias[, 1:3], glass_banias_minor[, 1:3], scores = TRUE)
# scores
glass_cca$xscores
# intraset correlations
glass_cca$xstructure
# interset correlations
glass_cca$xstructure %*% diag(glass_cca$cor)



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
