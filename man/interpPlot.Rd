\name{interpPlot}
\alias{interpPlot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plot an Interpolation Between Two Related Data Sets
}
\description{
Plot an interpolation between two related data sets,
typically transformations of each other.
This function is designed to be used in animations.

Points are plotted via the linear interpolation,
\deqn{ XY = XY1 + \alpha (XY2 - XY1)}

The function allows plotting of the data ellipse, the
linear regresion line, and line segments showing the movement of
points.
}
\usage{
interpPlot(xy1, xy2, alpha, xlim, ylim, 
	ellipse = FALSE, ellipse.args = NULL, 
	abline = FALSE, col.lines = palette()[2], lwd = 2, 
	id.method = "mahal", labels = rownames(xy1), id.n = 0, id.cex = 1, id.col = palette()[1], 
	segments = FALSE, segment.col = "darkgray", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xy1}{
First data set, a 2-column matrix or data.frame
}
  \item{xy2}{
Second data set, a 2-column matrix or data.frame

}
  \item{alpha}{
The value of the interpolation fraction, \code{0 <= alpha <= 1)}
}
  \item{xlim, ylim}{
x, y limits for the plot.  If not specified, the function uses the
ranges of \code{rbind(xy1, xy2)}.
}
  \item{ellipse}{
logical. \code{TRUE} to plot a \code{dataEllipse}
}
  \item{ellipse.args}{
arguments to \code{dataEllipse}
}
  \item{abline}{
logical. \code{TRUE} to plot the linear regression line for \code{XY}
}
  \item{col.lines}{
line color
}
  \item{lwd}{
line width
}
  \item{id.method}{
How points are to be identified. See \code{\link[car]{showLabels}}.
}
  \item{labels}{
observation labels
}
  \item{id.n}{
Number of points to be identified. If set to zero, no points are identified. 
}
  \item{id.cex}{
Controls the size of the plotted labels. The default is 1
}
  \item{id.col}{
Controls the color of the plotted labels. 
}
  \item{segments}{
logical. \code{TRUE} to draw lines segments from \code{xy1} to \code{xy}
}
  \item{segment.col}{
line color for segments
}
  \item{\dots}{
other arguments passed to \code{plot()}
}
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
	None.
}
%\references{
%%% ~put references to the literature/web site here ~
%}
\author{
Michael Friendly
}
\note{
The examples here just use on-screen animations to the console graphics window.
The \code{animation} package provides facilities to save these in various formats.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[car]{dataEllipse}},
\code{\link[car]{showLabels}}
\code{\link[animation]{animation}}

}
\examples{
#################################################
# animate an AV plot from marginal to conditional
#################################################
data(Duncan, package="car")
duncmod <- lm(prestige ~ income + education, data=Duncan)
mod.mat <- model.matrix(duncmod)

# function to do an animation for one variable
dunc.anim <- function(variable, other, alpha=seq(0, 1, .1)) {
	var <- which(variable==colnames(mod.mat))
	duncdev <- scale(Duncan[,c(variable, "prestige")], scale=FALSE)
	duncav <- lsfit(mod.mat[, -var], cbind(mod.mat[, var], Duncan$prestige), 
	        intercept = FALSE)$residuals
	colnames(duncav) <- c(variable, "prestige")
	
	lims <- apply(rbind(duncdev, duncav),2,range)
	
	for (alp in alpha) {
		main <- if(alp==0) paste("Marginal plot:", variable)
			else paste(round(100*alp), "\% Added-variable plot:", variable)
		interpPlot(duncdev, duncav, alp, xlim=lims[,1], ylim=lims[,2], pch=16,
			main = main,
			xlab = paste(variable, "| ", alp, other),
			ylab = paste("prestige | ", alp, other),
			ellipse=TRUE, ellipse.args=(list(levels=0.68, fill=TRUE, fill.alpha=alp/2)), 
			abline=TRUE, id.n=3, id.cex=1.2, cex.lab=1.25)
		Sys.sleep(1)
	}
}

# show these in the R console
dunc.anim("income", "education")

dunc.anim("education", "income")

############################################
# correlated bivariate data with 2 outliers
# show rotation from data space to PCA space
############################################

set.seed(123345)
x <- c(rnorm(100), 2, -2)
y <- c(x[1:100] + rnorm(100), -2, 2)
XY <- cbind(x=x, y=y)
rownames(XY) <- seq_along(x)
XY <- scale(XY, center=TRUE, scale=FALSE)

# start, end plots

dataEllipse(XY, pch=16, levels=0.68, id.n=2)
mod <- lm(y~x, data=as.data.frame(XY))
abline(mod, col="red", lwd=2)

pca <- princomp(XY, cor=TRUE)
scores <- pca$scores
dataEllipse(scores, pch=16, levels=0.68, id.n=2)
abline(lm(Comp.2 ~ Comp.1, data=as.data.frame(scores)), lwd=2, col="red")

# show interpolation

alpha <- seq(0,1,.1)
for (alp in alpha) {
	main <- if(alp==0) "Original data"
		else if(alp==1) "PCA scores"
		else paste(round(100*alp,1), "\% interpolation")
		xlab <- if(alp==0) "X"
			else if(alp==1) "PCA.1"
			else paste("X +", alp, "(X - PCA.1)")
		ylab <- if(alp==0) "Y"
			else if(alp==1) "PCA.2"
			else paste("Y +", alp, "(Y - PCA.2)")
		interpPlot(XY, scores, alp, 
			pch=16,
			main = main,
			xlab = xlab,
			ylab = ylab,
			ellipse=TRUE, ellipse.args=(list(levels=0.68, fill=TRUE, fill.alpha=(1-alp)/2)), 
			abline=TRUE, id.n=2, id.cex=1.2, cex.lab=1.25, segments=TRUE)
		Sys.sleep(1)
	}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{hplot}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
