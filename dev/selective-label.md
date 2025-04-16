# ggplot2: Labeling noteworthy points in scatterplots (`geom_noteworthy`)

An important feature of graphical methods for datavis is automatic labeling of unusual or "noteworthy" points
in scatterplots. This is handled automatically in base R for `plot(model)`, and much more generally in the
`car` package, where an `id = list(n, method, ...)` argument to many functions provides for most use cases
via a function `car::showLabels()`. 

I use this extensively in my packages, e.g, `heplots::cqplot()`, which produces chisquare QQ plots for a multivariate
linear model,

```
library(heplots)
iris.mod <- lm(as.matrix(iris[,1:4]) ~ Species, data=iris)
cqplot(iris.mod, id.n=3)
```

Correct me if I'm wrong, but I do not find any similar facility for labeling points selectively in statistical
applications of `ggplot`.

For a simple ggplot example, I want to plot `Crime_pers` against `Literacy` in the `Guerry` data, and label those
departments which are extreme in terms of Mahalanobis distance

![](guerry-crime.png)

The basic plot, with data ellipses:

```
library(ggplot2)
data(Guerry, package="Guerry")

ggplot(aes(x=Literacy, y=Crime_pers/1000), data=Guerry) +
  geom_point(size=2) +
  stat_ellipse(level=0.68, color="blue", linewidth=1.2) +  
  stat_ellipse(level=0.95, color="gray", linewidth=1, linetype=2) + 
  geom_smooth(method="lm", formula=y~x, fill="lightblue") +
  geom_smooth(method="loess", formula=y~x, color="red", se=FALSE) +
  theme_bw() + theme(text = element_text(size=18))

gp <- last_plot()
```

Then, this is what I had to do to add the point labels:
From `qchisq(0.9, df=2) = 4.6` I had to create a separate dataset `gdf`, 
and then subset that using `gdf[gdf$dsq > 4.6,]`

```
#' ## Use Mahalanobis Dsq to label unusual points
gdf <- Guerry[, c("Literacy", "Crime_pers", "Department")]
gdf$dsq <- heplots::Mahalanobis(gdf[, 1:2])

library(ggrepel)
gp + 
	   geom_label_repel(data = gdf[gdf$dsq > 4.6,], aes(label=Department))
```

What I'm looking for is something like a `geom_noteworthy()` function. It provides similar methods to select points to be
identified in a plot, and a `geom` argument that controls how the identified points are labeled in a plot.

```r
geom_noteworthy(method = c("dsq", "mahal", "x", "y", "r"),
                n =            # number of points to label,
                geom =         # e.g.,   "text", "label", "repel",
                ...)
```

To this end, I've written a `compute` function, `heplots::noteworthy(x, y, n, method, ...)` that tries to be very general,
https://github.com/friendly/heplots/blob/master/R/noteworthy.R


