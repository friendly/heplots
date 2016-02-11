plot.boxM <- 
		function(x, 
             pch=c(16, 15), 
             cex=c(2, 2.5), 
             col=c("blue", "red"), ...) {

dets <- x$logDet
ng <- length(dets)-1
dotchart(dets, xlab = "log determinant")
points(dets, 1:(ng+1),  
	cex=c(rep(cex[1], ng), cex[2]), 
	pch=c(rep(pch[1], ng), pch[2]),
	col=c(rep(col[1], ng), col[2]))

}

