open3d()
famnum <- rep(1:3, 8)
family <- c("serif", "sans", "mono")[famnum]
font <- rep(rep(1:4, each = 3), 2)
cex <- rep(1:2, each = 12)
text3d(font, cex, famnum, texts = paste(family, font, cex), adj = 0.5, 
       color = "blue", family = family, font = font, cex = cex)
