plot.robmlm <- 
	function(x, 
	         labels,
           id.weight = .7,
           id.pos = 4,
           pch=19, 
           col = palette()[1], 
           cex = par("cex"), 
           segments = FALSE,
           xlab="Case index",
           ylab="Weight in robust MANOVA",
           ...) {

	weights <- x$weights
	if (missing(labels)) labels <- rownames(residuals(x))
	
	plot(weights, pch=pch, col=col, cex=cex, 
		xlab = xlab, ylab = ylab,
		...)
	
	n <- length(weights)
	ind <- 1:n
	bad <- weights < id.weight
	text(ind[bad], weights[bad], labels[bad], pos = id.pos, xpd=TRUE)
	
	if(segments)
		segments(1:n, 1, 1:n, weights, col=col)

	names(weights) <- labels
	invisible(weights[bad])
}

if(FALSE) {
library(heplots)
data(SocialCog, package="heplots")

SC.mlm <-  lm(cbind(MgeEmotions,ToM, ExtBias, PersBias) ~ Dx,
               data=SocialCog)

SC.rlm1 <- robmlm(cbind( MgeEmotions, ToM, ExtBias, PersBias) ~ Dx,
               data=SocialCog,
               subset=rownames(SocialCog)!="15")
SC.rlm <- robmlm(cbind( MgeEmotions, ToM, ExtBias, PersBias) ~ Dx,
               data=SocialCog
#               subset=rownames(SocialCog)!="15"
               )
Dx <- SocialCog$Dx
bad <- SC.rlm$weights < .6
col <- c("red", "darkgreen", "blue")

plot(SC.rlm, 
	pch=(15:17)[Dx], col=col[Dx], ylim=c(0,1), cex = ifelse(bad, 1.4, .9)
	)

op <- par(mar=c(5,4,1,1)+.1)
plot(SC.rlm$weights, 
	xlab="Case index", ylab="Weight in robust MANOVA", pch=(15:17)[Dx],
	col=col[Dx], ylim=c(0,1), cex = ifelse(bad, 1.4, .9),
	cex.lab = 1.25)

breaks <-cumsum(table(SocialCog$Dx))
ctr <- c(0,breaks[1:2]) + diff(c(0, breaks))/2
abline(v=breaks[1:2]+.5, col="grey")

text(ctr, 0.05+c(0, -.04, 0), levels(Dx), cex=1.2)
# choose some points (arbitrarily) to label individually as "outliers"
text((1:nrow(SocialCog))[bad], SC.rlm$weights[bad], labels=rownames(SocialCog)[bad], pos=c(2,4,4))

segments(1:n, 1, 1:n, SC.rlm$weights, col=col[Dx])
par(op)






}