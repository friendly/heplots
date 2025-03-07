# Tools for selective labeling of points in scatterplots

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

![]()

The basic plot, with data ellipses:
```
library(ggplot)
data(Guerry, package="Guerry")

ggplot(aes(x=Literacy, y=Crime_pers/1000), data=Guerry) +
  geom_point(size=2) +
  stat_ellipse(level=0.68, color="blue", size=1.2) +  
  stat_ellipse(level=0.95, color="gray", size=1, linetype=2) + 
  geom_smooth(method="lm", formula=y~x, fill="lightblue") +
  geom_smooth(method="loess", formula=y~x, color="red", se=FALSE) +
  theme_bw() + theme(text = element_text(size=18))

gplot <- last_plot()
```

Then, this is what I had to do to add the point labels:
From `qchisq(0.9, df=2) = 4.6` I had to create a separate dataset `gdf`, 
and then subset that using `gdf[gdf$dsq > 4.6,]`

```
#' ## Use Mahalanobis Dsq to label unusual points
gdf <- Guerry[, c("Literacy", "Crime_pers", "Department")]
gdf$dsq <- heplots::Mahalanobis(gdf[, 1:2])

library(ggrepel)
gplot + 
	   geom_label_repel(aes(label=Department), data = gdf[gdf$dsq > 4.6,])
```


