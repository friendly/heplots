plot.boxM <- 
		function(x, gplabel = NULL,
             pch=c(16, 15), 
             cex=c(2, 2.5), 
             col=c("blue", "red"), ...) {

dets <- x$logDet
ng <- length(dets)-1
#if (!is.null(gplabel)) gplabel <- factor(c(rep(gplabel, ng), ""))
dotchart(dets, xlab = "log determinant", ...)
points(dets, 1:(ng+1),  
	cex=c(rep(cex[1], ng), cex[2]), 
	pch=c(rep(pch[1], ng), pch[2]),
	col=c(rep(col[1], ng), col[2]))

if(!is.null(gplabel))
  text(par("usr")[1], ng + .5, gplabel, pos=4, cex=1.25)
}

