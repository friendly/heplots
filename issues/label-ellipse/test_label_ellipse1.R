# Test script for updated label.ellipse() with diagonal compass directions
# This demonstrates the new NE, SE, SW, NW positions

# Source the updated function
source(here::here("dev/label-ellipse/label.ellipse.R"))

# Helper function to create a circle
circle <- function(center=c(0,0), radius=1, segments=60) {
  angles <- (0:segments)*2*pi/segments
  circle <- radius * cbind( cos(angles), sin(angles))
  t( c(center) + t( circle ))
}

# Create a circular ellipse
circ <- circle(radius=1.5)

# Test 1: Show all cardinal and diagonal compass directions on a circle
png(here::here("dev/label-ellipse/test_compass_circle.png"), width=600, height=600)
plot(-2:2, -2:2, type="n", asp=1, 
     main="Compass Directions on Circle\n(Cardinal + Diagonal)")
lines(circ, col="gray", lwd=2)
points(0, 0, pch="+", cex=2)

# Cardinal directions (existing)
cardinal <- c("N", "E", "S", "W")
for (pos in cardinal) {
  label.ellipse(circ, label=pos, label.pos=pos, col="red", cex=1.2, font=2)
}

# Diagonal directions (new)
diagonal <- c("NE", "SE", "SW", "NW")
for (pos in diagonal) {
  label.ellipse(circ, label=pos, label.pos=pos, col="blue", cex=1.2, font=2)
}

# Center
label.ellipse(circ, label="C", label.pos="C", col="darkgreen", cex=1.2, font=2)

legend("bottomleft", legend=c("Cardinal (N,E,S,W)", "Diagonal (NE,SE,SW,NW)", "Center"),
       col=c("red", "blue", "darkgreen"), lwd=2, bty="n")
dev.off()

# Test 2: Show on an actual ellipse (correlated data)
r <- 0.6
ell <- circ %*% chol(matrix(c(1, r, r, 1), 2, 2))

png(here::here("dev/label-ellipse/test_compass_ellipse.png"), width=600, height=600)
plot(-3:3, -3:3, type="n", asp=1, 
     main=paste0("Compass Directions on Ellipse (r = ",  r, ")"))
lines(ell, col="gray", lwd=2)
points(0, 0, pch="+", cex=2)

# Cardinal directions
cardinal <- c("N", "E", "S", "W")
for (pos in cardinal) {
  label.ellipse(ell, label=pos, label.pos=pos, col="red", cex=1.2, font=2)
}

# Diagonal directions
diagonal <- c("NE", "SE", "SW", "NW")
for (pos in diagonal) {
  label.ellipse(ell, label=pos, label.pos=pos, col="blue", cex=1.2, font=2)
}

legend("bottomleft", legend=c("Cardinal", "Diagonal"),
       col=c("red", "blue"), lwd=2, bty="n")
dev.off()

# Test 3: Verify numeric fractional values work for diagonal positions
png(here::here("dev/label-ellipse/test_fractional.png"), width=600, height=600)
plot(-2:2, -2:2, type="n", asp=1, 
     main="Fractional Positions\n(45°, 135°, 225°, 315°)")
lines(circ, col="gray", lwd=2)
points(0, 0, pch="+", cex=2)

# Using fractional values that correspond to the diagonal compass directions
angles <- c(45, 135, 225, 315)
for (angle in angles) {
  frac <- angle / 360
  label.ellipse(circ, label=paste0(angle, "° (", round(frac, 3), ")"), 
                label.pos=frac, col="purple", cex=1)
}

# Add reference lines to show the angles
abline(h=0, v=0, col="lightgray", lty=2)
abline(a=0, b=1, col="lightgray", lty=2)   # 45° line
abline(a=0, b=-1, col="lightgray", lty=2)  # -45° line
dev.off()

cat("Test plots created successfully!\n")
cat("- test_compass_circle.png: Cardinal and diagonal directions on a circle\n")
cat("- test_compass_ellipse.png: All directions on a correlated ellipse\n")
cat("- test_fractional.png: Fractional values corresponding to diagonal positions\n")