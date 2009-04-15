# last modified 21 December 2006 by J. Fox
# last modified 15 April 2009 by M. Friendly 
#  -- Fixed numerous warnings resulting from axes=FALSE
#  -- prepare to generalize diagonal panel


`pairs.mlm` <-
function(x, variables,
    type=c("II", "III", "2", "3"),
    offset.axes=0.05, digits=getOption("digits") - 1, ...){
    manova <- Anova(x, type)
    Y <- model.response(model.frame(x))
    vars <- colnames(Y)
    if (!missing(variables)){
        if (is.numeric(variables)) {
            vars <- vars[variables]
            if (any(is.na(vars))) stop("Bad response variable selection.")
            }
        else {
            check <- !(variables %in% vars)
            if (any(check)) stop(paste("The following", 
                if (sum(check) > 1) "variables are" else "variable is",
                "not in the model:", paste(variables[check], collapse=", ")))
            vars <- variables
            }
        }
    n.resp <- length(vars)
    if (n.resp < 3) stop("Fewer than 3 response variables.")
    range <- apply(Y, 2, range)
    min <- - offset.axes
    max <- 1 + offset.axes
    old.par <- par(mfrow=c(n.resp, n.resp), mar=rep(0,4))
    on.exit(par(old.par))

	panel.label <- function(x, ...) {
		plot(c(min, max),c(min, max), type="n", axes=FALSE)
		text(0.5, 0.5, vars[i], cex=2)
		text(1, 0, signif(range[1, i], digits=digits), adj=c(1, 0))
		text(0, 1, signif(range[2, i], digits=digits), adj=c(0, 1)) 
		box()
	}	
	for (i in 1:n.resp){
        for (j in 1:n.resp){
            if (i == j){
				panel.label()
#                plot(c(min, max),c(min, max), type="n", axes=FALSE)
#                text(0.5, 0.5, vars[i], cex=2)
#                text(1, 0, signif(range[1, i], digits=digits), adj=c(1, 0))
#                text(0, 1, signif(range[2, i], digits=digits), adj=c(0, 1)) 
#                box()
                }
            else {
                heplot(x, variables=c(vars[j], vars[i]), manova=manova, axes=FALSE,
                    offset.axes=offset.axes, ...)
                box()
                }
            }
        }
    }

