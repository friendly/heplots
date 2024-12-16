# Bootstrapping eigenvalues of grouped covariance matrices
# https://stackoverflow.com/questions/45353073/bootstrapping-a-vector-of-results-by-group-in-r

library(boot)
library(tidyverse)

cov_stat_fun <- function(data, indices, 
                         stats=c("logdet", "prod", "sum", "precision", "max")
) {
  dat <- data[indices,]
  cov <- cov(dat, use="complete.obs")
  eigs <- eigen(cov)$values
  
  res <- c(
    "logdet" = log(det(cov)),
    "prod" = prod(eigs),
    "sum" = sum(eigs),
    "precision" = 1/ sum(1/eigs),
    "max" = max(eigs)
  )
}

boot_cov_stat <- function(data, R=500,  ...) {
  boot(data, cov_stat_fun, R=R,  ...)
}

# try this 
iris.boot <- boot_cov_stat(iris[,1:4])
iris.ci <- boot.ci(iris.boot)
iris.ci
str(iris.ci)

tidy(iris.boot, conf.int=TRUE)


# I also have written a function that calculates the separate covariance matrices for each group, 
# but I can't see how to use this in my bootstrap functions.

# calculate covariance matrices by group and pooled
covs <- function(Y, group) {
  Y <- as.matrix(Y)
  gname <- deparse(substitute(group))
  if (!is.factor(group)) group <- as.factor(as.character(group))
  
  valid <- complete.cases(Y, group)
  if (nrow(Y) > sum(valid)) 
    warning(paste(nrow(Y) - sum(valid)), " cases with missing data have been removed.")
  Y <- Y[valid,]
  group <- group[valid]
  nlev <- nlevels(group)
  lev <- levels(group)
  mats <- aux <- list()
  for(i in 1:nlev) {
    mats[[i]] <- cov(Y[group == lev[i], ])
  }
  names(mats) <- lev
  pooled <- cov(Y)
  c(mats, "pooled"=pooled)
}

# Pooled
iris.boot <- boot_cov_stat(iris[,1:4])
iris.ci <- boot.ci(iris.boot)

# By Species
boot.list = setNames(unique(iris$Species), unique(iris$Species)) |> 
  map(function(group) {
    iris.boot = boot_cov_stat(iris[iris$Species==group, 1:4])
    boot.ci(iris.boot)
  })

# Combine pooled and by-Species results
boot.list = c(boot.list, list(Pooled=iris.ci))

boot.list

# I think the best general answer will be an extension of what @eipi10 proposed, using some method to extract 
# the required confidence intervals from the bootci objects. This is lacking from the broom package.
# 
# As an instructive alternative, I tried using broom::tidy() on the results of the bootstrap directly. 
# Rather than the (typically asymmetric) confidence intervals, it gives the bootstrap estimate as statistic, 
# a bias and a std.error. However, from the results I get (see below), I have doubts about whether 
# broom::tidy() gives correct results in this case.

# try just using tidy on the bootstrap results

## pooled
iris.boot <- boot_cov_stat(heplots::colDevs(iris[,1:4], iris$Species))
iris.pooled <- tidy(iris.boot, conf.int = TRUE)

#Now, use the method described in the other answer to map this over groups, and combine:
  
## individual groups
boot.list2 = setNames(unique(iris$Species), unique(iris$Species)) |> 
  map(function(group) {
    iris.boot = boot_cov_stat(iris[iris$Species==group, 1:4])
    tidy(iris.boot, conf.int = TRUE)
  })

# Combine pooled and by-Species results
boot.list <- c(boot.list2, list(Pooled=iris.pooled))

#Transform to a data frame:
  
## transform this list to a data frame, with a group variable
result <- bind_rows(boot.list) |> 
  mutate(group = rep(c( levels(iris$Species), "Pooled"), 5)) |>
  arrange(term)

head(result)

# This gives something that can now be plotted, supposedly corresponding to the plot in the original question 
# shown without error bars:
  
result |> mutate(Pooled = group == "Pooled") |>
  filter (term != "logdet") |>
  ggplot(aes(y=statistic, x=group, color=Pooled)) +
    geom_point(size=4) +
    geom_errorbar(aes(ymin=conf.low, 
                      ymax=conf.high), 
                  width=0.4, linewidth = 1.2) +
    scale_x_discrete(limits=rev) +
    facet_wrap( ~ term, scales="free") +
    coord_flip() + 
    guides(color="none") +
    theme_bw()

# However, this "tidy plot" seems evidently WRONG. Theory says that the result for the Polled sample must 
# in every case be intermediate between those for the separate groups, because it is in some sense a 
# 'convex combination` over groups. Compare the plot below with that given in the original question. 
# (It is possible that I did something wrong here, but I can't see a flaw.)

# compare with plot.boxM


iris.boxm <- boxM(iris[, 1:4], iris[, "Species"])

plot(iris.boxm)

op <- par(mfrow=c(2,2), mar=c(5,4,1,1))
plot(iris.boxm, gplabel="Species", which="max")
plot(iris.boxm, gplabel="Species", which="precision")
plot(iris.boxm, gplabel="Species", which="product")
plot(iris.boxm, gplabel="Species", which="sum")
par(op)


