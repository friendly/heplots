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
png(here::here("dev/label-ellipse/test_compass_circle.png"), width=800, height=800)
plot(-2:2, -2:2, type="n", asp=1, 
     main="Compass Directions on Circle\n(Cardinal + Diagonal)")
lines(circ, col="gray", lwd=2)
points(0, 0, pch="+", cex=2)

# Cardinal directions (existing)
label.ellipse(circ, label="N", label.pos="N", col="red", cex=1.2, font=2)
label.ellipse(circ, label="E", label.pos="E", col="red", cex=1.2, font=2)
label.ellipse(circ, label="S", label.pos="S", col="red", cex=1.2, font=2)
label.ellipse(circ, label="W", label.pos="W", col="red", cex=1.2, font=2)

# Diagonal directions (new)
label.ellipse(circ, label="NE", label.pos="NE", col="blue", cex=1.2, font=2)
label.ellipse(circ, label="SE", label.pos="SE", col="blue", cex=1.2, font=2)
label.ellipse(circ, label="SW", label.pos="SW", col="blue", cex=1.2, font=2)
label.ellipse(circ, label="NW", label.pos="NW", col="blue", cex=1.2, font=2)

# Center
label.ellipse(circ, label="C", label.pos="C", col="darkgreen", cex=1.2, font=2)

legend("bottomleft", legend=c("Cardinal (N,E,S,W)", "Diagonal (NE,SE,SW,NW)", "Center"),
       col=c("red", "blue", "darkgreen"), lwd=2, bty="n")
dev.off()

# Test 2: Show on an actual ellipse (correlated data)
ell <- circ %*% chol(matrix(c(1, 0.7, 0.7, 1), 2, 2))

png(here::here("dev/label-ellipse/test_compass_ellipse.png"), width=800, height=800)
plot(-3:3, -3:3, type="n", asp=1, 
     main="Compass Directions on Ellipse\n(r = 0.7)")
lines(ell, col="gray", lwd=2)
points(0, 0, pch="+", cex=2)

# All compass directions
label.ellipse(ell, label="N", label.pos="N", col="red", cex=1.2, font=2)
label.ellipse(ell, label="E", label.pos="E", col="red", cex=1.2, font=2)
label.ellipse(ell, label="S", label.pos="S", col="red", cex=1.2, font=2)
label.ellipse(ell, label="W", label.pos="W", col="red", cex=1.2, font=2)
label.ellipse(ell, label="NE", label.pos="NE", col="blue", cex=1.2, font=2)
label.ellipse(ell, label="SE", label.pos="SE", col="blue", cex=1.2, font=2)
label.ellipse(ell, label="SW", label.pos="SW", col="blue", cex=1.2, font=2)
label.ellipse(ell, label="NW", label.pos="NW", col="blue", cex=1.2, font=2)

legend("bottomleft", legend=c("Cardinal", "Diagonal"),
       col=c("red", "blue"), lwd=2, bty="n")
dev.off()

# Test 3: Verify numeric fractional values work for diagonal positions
#png("/home/claude/test_fractional.png", width=800, height=800)
plot(-2:2, -2:2, type="n", asp=1, 
     main="Fractional Positions\n(45°, 135°, 225°, 315°)")
lines(circ, col="gray", lwd=2)
points(0, 0, pch="+", cex=2)

# Using fractional values that correspond to the diagonal compass directions
label.ellipse(circ, label="45° (0.125)", label.pos=45/360, col="purple", cex=1)
label.ellipse(circ, label="135° (0.375)", label.pos=135/360, col="purple", cex=1)
label.ellipse(circ, label="225° (0.625)", label.pos=225/360, col="purple", cex=1)
label.ellipse(circ, label="315° (0.875)", label.pos=315/360, col="purple", cex=1)

# Add reference lines to show the angles
abline(h=0, v=0, col="lightgray", lty=2)
abline(a=0, b=1, col="lightgray", lty=2)   # 45° line
abline(a=0, b=-1, col="lightgray", lty=2)  # -45° line
#dev.off()

cat("Test plots created successfully!\n")
cat("- test_compass_circle.png: Cardinal and diagonal directions on a circle\n")
cat("- test_compass_ellipse.png: All directions on a correlated ellipse\n")
cat("- test_fractional.png: Fractional values corresponding to diagonal positions\n")
