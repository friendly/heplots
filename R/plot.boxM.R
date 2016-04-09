plot.boxM <- 
  function(x, gplabel = NULL,
           which = c("logDet", "product", "sum", "precision", "max"),
           log = which=="product",
           pch=c(16, 15), 
           cex=c(2, 2.5), 
           col=c("blue", "red"),
           xlim,
           conf=0.95, method=1, bias.adj=TRUE, lwd=2, ...) {
    
    which <- match.arg(which)
    if (which=="logDet") {
      measure <- x$logDet
      xlab <- "log determinant"
    }
    else {
      eigstats <- summary(x, quiet=TRUE)$eigstats
      measure <- eigstats[which,]
      if(log) measure <- log(measure)
      xlab <- paste(if(log) "log" else "", which, "of eigenvalues" )
      conf <- 0
    }
    
    
    ng <- length(measure)-1
    
    if (missing(xlim)) {
      xlim <- range(measure)
    }
    
    if (conf>0) {
      cov <- c(x$cov, list(pooled=x$pooled))
      n <- x$df + c(rep(1, ng), ng)
      CI <- logdetCI( cov, n=n, conf=conf, method=method, bias.adj=bias.adj )
      xlim[1] <- min(xlim[1], CI$lower)
      xlim[2] <- max(xlim[2], CI$upper)
    }
    
    dotchart(measure, xlab = xlab, xlim=xlim,  ...)
    if (conf>0) {
      arrows(CI$lower, 1:(ng+1), CI$upper, 1:(ng+1), lwd=lwd, angle=90, length=.075, code=3)
    }
    points(measure, 1:(ng+1),  
           cex=c(rep(cex[1], ng), cex[2]), 
           pch=c(rep(pch[1], ng), pch[2]),
           col=c(rep(col[1], ng), col[2]))
    
    if(!is.null(gplabel))
      text(par("usr")[1], ng + .5, gplabel, pos=4, cex=1.25)
    
  }


# TESTME <- FALSE
# if(TESTME) {
# 
# data(Skulls, package="heplots")
# # make shorter labels for epochs
# Skulls$epoch <- ordered(Skulls$epoch, labels=sub("c","",levels(Skulls$epoch)))
# skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data=Skulls)
# skulls.boxm <- boxM(skulls.mod)
# 
# plot(skulls.boxm, gplabel="Epoch")
# 
# op <- par(mfrow=c(2,2), mar=c(5,4,1,1))
# plot_eigstats(skulls.boxm, which="product", gplabel="Epoch", xlim=c(10,14))
# plot_eigstats(skulls.boxm, which="sum", gplabel="Epoch")
# plot_eigstats(skulls.boxm, which="precision", gplabel="Epoch")
# plot_eigstats(skulls.boxm, which="max", gplabel="Epoch")
# par(op)
# 
# }