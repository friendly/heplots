

#' Title
#'
#' @param ellipse 
#' @param label 
#' @param col 
#' @param label.pos 
#' @param xpd 
#' @param adj 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
label.ellipse3d <- function(ellipse, 
                            label, col="black", 
                            label.pos=NULL, 
                            xpd=TRUE, 
                            adj=0.5*c(strwidth("M"), strheight("M")), ...){
  
  posn <- c("center", "bottom", "left", "top", "right", "front", "back")
  poss <- c("C",      "S",      "W",    "N",   "E",     "F",     "B")
  if (is.character(label.pos)) {
    if (label.pos %in% posn) label.pos <- pmatch(label.pos, posn, nomatch=3) - 1
    if (label.pos %in% poss) label.pos <- pmatch(label.pos, poss, nomatch=3) - 1
  }
  pos <- label.pos
  
  bbox <- bbox3d(ellipse)
  adj <- rep(adj, out.length = length(poss))
  
  if (label.pos==1) {   # bottom
    x <- mean(bbox[, "x"])
    y <- bbox["min", "y"]  + adj[2]
    z <- mean(bbox[, "z"]) + adj[3]
  }
  else if (label.pos==2) {   # left
    x <- bbox["min", "x"]  + adj[1]
    y <- mean(bbox[, "y"]) + adj[2]
    z <- mean(bbox[, "z"]) + adj[3]
  }
  else if (label.pos==3) {   # top
    x <- mean(bbox[, "x"])
    y <- bbox["max", "y"]  + adj[2]
    z <- mean(bbox[, "z"]) + adj[3]
  }
  else if (label.pos==4) {   # right
    x <- bbox["max", "x"]  + adj[1]
    y <- mean(bbox[, "y"]) + adj[2]
    z <- mean(bbox[, "z"]) + adj[3]
  }
  else if (label.pos==5) {   # front
    x <- mean(bbox[, "x"])
    y <- mean(bbox[, "y"]) + adj[2]
    z <- bbox["min", "z"] + adj[1]
  }
  else if (label.pos==6) {   # back
    x <- mean(bbox[, "x"])
    y <- mean(bbox[, "y"]) + adj[2]
    z <- bbox["max", "z"] + adj[1]
  }
  else if (label.pos==0) {   # center
    x <- mean(bbox[, "x"])
    y <- mean(bbox[, "y"]) - adj[2]
    z <- mean(bbox[, "z"])
    pos <-3
  }
  
  rgl::text3d(x, y, z, label, pos=pos, col=col, ...)
  
}  
