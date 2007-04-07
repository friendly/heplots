# last modified 23 January 2007 by J. Fox

`heplot3d.mlm` <-
function ( 
    mod,           # an mlm object
    terms,         # vector of terms to plot H ellipses
    hypotheses,    # list of linear hypotheses for which to plot H ellipses
    term.labels=TRUE,  # TRUE, FALSE or a list of term labels of length(terms)
    hyp.labels=TRUE,   # as above for term.labels
    variables=1:3,     # x,y variables for the plot [variable names or numbers]
    error.ellipsoid=!add,
    factor.means=!add,
    grand.mean=!add,
    remove.intercept=TRUE,
    type=c("II", "III", "2", "3"),
    manova,        # an optional Anova.mlm object
    size=c("evidence", "effect.size"),
    level=0.68,
    alpha=0.05,
    segments=40,   # line segments in each ellipse
    col=palette()[-1],  # colors for E matrix, H matrices
    lwd=c(1, 4),  # line width for drawing ellipsoids and 1d degenerate ellipsoids
    bg.col=c("white", "black"),  # background colour
    fogtype=c("none", "exp2", "linear", "exp"), # fog -- for depth cueing
    fov=30,   # field of view (for perspective)
    offset=0.01, # for ellipsoid labels
    xlab,
    ylab,
    zlab,
    add=FALSE,      # add to existing plot?
    verbose=FALSE,
    warn.rank=FALSE,  
    ...) {              
    ellipsoid <- function(center, shape, radius=1, label="", col, df=Inf){
        # adapted from the shapes3d demo in the rgl package and from the Rcmdr package
        degvec <- seq(0, 2*pi, length=segments)
        ecoord2 <- function(p) c(cos(p[1])*sin(p[2]), sin(p[1])*sin(p[2]), cos(p[2]))
        v <- t(apply(expand.grid(degvec,degvec), 1, ecoord2))
        if (!warn.rank){
          warn <- options(warn=-1)
          on.exit(options(warn))
          }
        Q <- chol(shape, pivot=TRUE)
        lwd <- if (df < 2) lwd[2] else lwd[1]
        order <- order(attr(Q, "pivot"))
        v <- center + radius * t(v %*% Q[, order])
        v <- rbind(v, rep(1,ncol(v))) 
        e <- expand.grid(1:(segments-1), 1:segments)
        i1 <- apply(e, 1, function(z) z[1] + segments*(z[2] - 1))
        i2 <- i1 + 1
        i3 <- (i1 + segments - 1) %% segments^2 + 1
        i4 <- (i2 + segments - 1) %% segments^2 + 1
        i <- rbind(i1, i2, i4, i3)
        x <- asEuclidean(t(v))
        ellips <- qmesh3d(v, i)
        shade3d(ellips, col=col, alpha=0.1, lit=FALSE)
        wire3d(ellips, col=col, size=lwd, lit=FALSE)
        ranges <- apply(matrix(par3d("bbox"), nrow=2), 2, diff)
        rgl.texts(x[which.max(x[,2]),] + offset*ranges, adj=0,
            text=label, color=col, lit=FALSE)
        }
    if (!require(car)) stop("car package is required.")
    if (!require(rgl)) stop("rgl package is required.")    
    type <- match.arg(type)
    size <- match.arg(size)
    fogtype <- match.arg(fogtype)
    bg.col <- match.arg(bg.col)    
    data <- model.frame(mod)
    if (missing(manova)) manova <- Anova(mod, type=type)    
    if (verbose) print(manova)    
    response.names <- rownames(manova$SSPE)
    if (!is.numeric(variables)) {
        vars <- variables
        variables <- match(vars, response.names)
        check <- is.na(variables)
        if (any(check)) stop(paste(vars[check], collapse=", "), 
           " not among response variables.") 
        }
    else {
        if (any (variables > length(response.names))) stop("There are only ", 
        length(response.names), " response variables.")
        vars <- response.names[variables]
        }
    if (length(variables) != 3) stop("You may only plot 3 response variables")
    if (missing(terms) || (is.logical(terms) && terms)) {
       terms <- manova$terms
       if (remove.intercept) terms <- terms[terms != "(Intercept)"]
       }
    n.terms <- if (!is.logical(terms)) length(terms) else 0 
                                   # note: if logical here, necessarily FALSE
    n.hyp <- if (missing(hypotheses)) 0 else length(hypotheses)
    n.ell <- n.terms + n.hyp
    if (n.ell == 0) stop("Nothing to plot.")
    E <- manova$SSPE
    p <- nrow(E)
    E <- E[variables, variables]
    Y <- model.response(data)[,vars]
    gmean <- if (missing(data))  c(0,0,0) 
        else colMeans(Y)
    if (missing(xlab)) xlab <- vars[1]
    if (missing(ylab)) ylab <- vars[2]
    if (missing(zlab)) zlab <- vars[3]
    dfe <- manova$error.df
    scale <- 1/dfe 
    E <- E * scale
    radius <- sqrt(3 * qf(level, 3, dfe))
    E.col <- col[1]
    if (length(col) >= 2) col <- col[-1]
    col <- rep(col, n.ell)[1:n.ell]
    if (!add){    
        rgl.clear()
        rgl.viewpoint(fov=fov)
        rgl.bg(col=bg.col, fogtype=fogtype)    
        } 
    if (error.ellipsoid) ellipsoid(gmean, E, radius, col=E.col, label="Error")       
    term.labels <- if (n.terms == 0) NULL
        else if (!is.logical(term.labels)) term.labels
        else if (term.labels) terms else rep("", n.terms)
    if (n.terms > 0) for (term in 1:n.terms){
          term.name <- terms[term] 
        H <- manova$SSP[[term.name]]
        H <- H[variables, variables]
        dfh <- manova$df[term.name]
        #          scale <- eval(parse(text=h.scale))
        factor <- if (size == "evidence") lambda.crit(alpha, p, dfh, dfe) else 1  
        H <- H * scale/factor
        if (verbose){
            cat(term.name, " H matrix (", dfh, " df):\n")
            print(H)
            }
        ellipsoid(gmean, H, radius, col=col[term], label=term.labels[term], 
            df=dfh)  
        }
    hyp.labels <- if (n.hyp == 0) NULL
        else if (!is.logical(hyp.labels)) hyp.labels
        else if (hyp.labels) names(hypotheses) else rep("", n.hyp)  
    if (n.hyp > 0) for (hyp in 1:n.hyp){
        lh <- linear.hypothesis(mod, hypotheses[[hyp]])
        H <- lh$SSPH[variables, variables]
        dfh <- lh$df
        factor <- if (size == "evidence") lambda.crit(alpha, p, dfh, dfe) else 1  
        H <- H * scale/factor
          if (verbose){
              cat("\n\n Linear hypothesis: ", names(hypotheses)[[hyp]], "\n") 
              print(lh)
              }
        ellipsoid(gmean, H, radius, col=col[n.terms + hyp], label=hyp.labels[hyp],
            df=dfh)
        }         
    ranges <- apply(matrix(par3d("bbox"), nrow=2), 2, diff)
    ellipsoid(gmean, diag((ranges/40)^2), col="black") # centre dot            
    if ((!is.logical(factor.means)) || factor.means){
        factors <- data[, sapply(data, is.factor), drop=FALSE]
        if (!is.logical(factor.means)){
            factor.names <- colnames(factors) 
            which <- match(factor.means, factor.names)
            check <- is.na(which)
            if (any(check)) stop(paste(factor.means[check], collapse=", "), 
               " not among factors.")
            factors <- factors[, which, drop=FALSE]
            }    
        for (fac in factors){
            means <- aggregate(Y, list(fac), mean)
            for (m in 1:nrow(means)) ellipsoid(unlist(means[m, 2:4]), 
                diag((ranges/100))^2, col="black")
            rgl.texts(means[,2:4] + matrix(offset*ranges, nrow(means), 3, byrow=TRUE), 
                text=as.character(means[,1]), col="black", adj=0)
            }
        }
    if (add) rgl.pop(id=.frame)
    frame <- axis3d("x-", col="black")
    frame <- c(frame, mtext3d(xlab, "x-", col="black", line=1.5))
    frame <- c(frame, axis3d("y-", col="black"))
    frame <- c(frame, mtext3d(ylab, "y-", col="black", line=1.5))
    frame <- c(frame, axis3d("z-", col="black"))
    frame <- c(frame, mtext3d(zlab, "z-", col="black", line=1.5))
    frame <- c(frame, box3d(col="black"))
    assign(".frame", frame, envir=.GlobalEnv)
    aspect3d(x=1, y=1, z=1)
    }

