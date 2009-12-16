mark.H0 <- function(x=0, y=0, cex=2, pch=19, col="green3", lty=2, pos=2) {
	points(x,y, cex=cex, col=col, pch=pch)
	text(x,y, expression(H[0]), col=col, pos=pos)
	if (lty>0) abline(h=y, col=col, lty=lty)
	if (lty>0) abline(v=x, col=col, lty=lty)
}
