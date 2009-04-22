termMeans <- function(mod, term, label.factors=TRUE){
    data <- model.frame(mod)
    Y <- model.response(data)
    factors <- data[, sapply(data, is.factor), drop=FALSE]
    term.factors <- unlist(strsplit(term, ":"))
    if (any(which <- !term.factors %in% colnames(factors))) 
        stop(paste(term.factors[which], collapse=", "), " not in the model")
    n.factors <- length(term.factors)
    factor.values <- factors[,term.factors, drop=FALSE]
    rows <- nrow(levs <- unique(factor.values))
    means <-matrix(0, nrow=rows, ncol=ncol(Y))
    for (j in 1:ncol(Y)) {
        mn <- tapply(Y[,j], factor.values, mean)
        means[,j] <- as.vector(mn)
    }
    colnames(means) <- colnames(Y)
    nms <- colnames(levs)
    if (label.factors)
    	for (j in 1:ncol(levs)) levs[,j] <- paste(nms[j], levs[,j], sep="")
    levs <- apply(levs, 1, paste, collapse=":")
    rownames(means) <- levs
    means
}

