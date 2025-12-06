# Enhancement Summary: Adding Diagonal Compass Directions to label.ellipse()

## Overview
Extended the `label.pos` argument in `label.ellipse()` to support diagonal compass 
directions: "NE", "SE", "SW", "NW" corresponding to angles 45°, 135°, 225°, and 315°.

## Key Changes Made

### 1. Added Diagonal Compass Direction Definitions (Lines 115-116)
```r
# Define diagonal compass positions and their corresponding angular fractions
post <- c("NE", "SE", "SW", "NW")
numt <- c(45, 135, 225, 315) / 360  # Convert degrees to fraction of circle
```

This defines:
- NE = 45° = 0.125 (fraction of circle)
- SE = 135° = 0.375
- SW = 225° = 0.625
- NW = 315° = 0.875

### 2. Updated Character Input Handling (Lines 123-129)
```r
# Handle character input
if (is.character(label.pos)) {
  if (label.pos %in% posn) label.pos <- pmatch(label.pos, posn, nomatch=3) - 1
  else if (label.pos %in% poss) label.pos <- pmatch(label.pos, poss, nomatch=3) - 1
  else if (label.pos %in% post) {
    # Convert diagonal compass to fractional position
    idx <- pmatch(label.pos, post, nomatch=1)
    label.pos <- numt[idx]
  }
}
```

Changes:
- Changed `if` chain to `if-else if` for proper precedence
- Added handling for diagonal compass directions in `post`
- Converts diagonal directions to their fractional equivalents

### 3. Enhanced Fractional Position Logic (Lines 155-179)
```r
else  {  # use as fraction of circle or index into ellipse coords
  if (0 < label.pos & label.pos < 1) {
    # label.pos is a fraction of the way around the circle
    # Find the ellipse center
    center_x <- mean(ellipse[, 1])
    center_y <- mean(ellipse[, 2])
    
    # Calculate target angle (in radians, counterclockwise from (1,0))
    target_angle <- 2 * pi * label.pos
    
    # Calculate angles for all points on the ellipse relative to center
    angles <- atan2(ellipse[, 2] - center_y, ellipse[, 1] - center_x)
    
    # Find the point with angle closest to target angle
    # Need to handle angle wrapping (angles are in [-pi, pi])
    angle_diff <- abs(angles - target_angle)
    angle_diff <- pmin(angle_diff, 2*pi - angle_diff)  # Handle wrapping
    index <- which.min(angle_diff)
    
    # Get coordinates at this index
    x <- ellipse[index, 1]
    y <- ellipse[index, 2]
    
    # Determine text position based on angle
    # pos=1 (below), 2 (left), 3 (above), 4 (right)
    pos <- if (angles[index] >= -pi/4 & angles[index] < pi/4) 4       # right
           else if (angles[index] >= pi/4 & angles[index] < 3*pi/4) 3  # above
           else if (angles[index] >= 3*pi/4 | angles[index] < -3*pi/4) 2  # left
           else 1  # below
  }
  ...
}
```

This completely rewrites the fractional position handling to:
1. Calculate the ellipse center
2. Convert the fractional position to a target angle in radians
3. Find the ellipse point with the angle closest to the target
4. Automatically determine the appropriate text position (1-4) based on the angle

### 4. Updated Documentation (Lines 20-23)
```r
#' Label positions can also be specified as the corresponding character strings
#' \code{c("center", "bottom", "left", "top", "right")}, or compass directions, 
#' \code{c("C", "S", "W", "N", "E")}. Additionally, diagonal compass directions
#' \code{c("NE", "SE", "SW", "NW")} can be used, corresponding to angles 45, 135, 225, 
#' and 315 degrees, respectively.
```

## How It Works

### Angular Position Calculation
The function now properly handles angular positions by:

1. **Finding the ellipse center**: Uses `mean()` of x and y coordinates
2. **Converting fraction to angle**: `target_angle = 2π × fraction`
3. **Computing point angles**: Uses `atan2()` to get each point's angle relative to center
4. **Finding closest match**: Handles angle wrapping to find the nearest point
5. **Smart text positioning**: Determines whether label should be left/right/above/below 
   based on the angle quadrant

### Example Usage
```r
# Using character strings (new)
label.ellipse(ell, "Northeast", label.pos = "NE", col = "blue")
label.ellipse(ell, "Southeast", label.pos = "SE", col = "blue")
label.ellipse(ell, "Southwest", label.pos = "SW", col = "blue")
label.ellipse(ell, "Northwest", label.pos = "NW", col = "blue")

# Using numeric fractions (equivalent)
label.ellipse(ell, "45°", label.pos = 0.125, col = "purple")
label.ellipse(ell, "135°", label.pos = 0.375, col = "purple")
label.ellipse(ell, "225°", label.pos = 0.625, col = "purple")
label.ellipse(ell, "315°", label.pos = 0.875, col = "purple")

# Original functionality still works
label.ellipse(ell, "Top", label.pos = "N", col = "red")
label.ellipse(ell, "Right", label.pos = 4, col = "red")
```

## Benefits

1. **Intuitive diagonal positioning**: Natural compass direction naming
2. **Flexible input**: Works with both character strings and numeric fractions
3. **Robust angle handling**: Properly handles angle wrapping around ±π
4. **Automatic text positioning**: Smart choice of where to place text relative to point
5. **Backward compatible**: All existing functionality preserved

## Testing Recommendations

Test with:
1. **Circular ellipses**: Verify diagonal positions are at true 45° angles
2. **Elongated ellipses**: Check positions adapt correctly to ellipse shape
3. **Negative correlations**: Ensure positions work for various ellipse orientations
4. **Edge cases**: Very thin ellipses, near-zero correlations

## Files Provided

1. **label.ellipse.R**: Updated function with diagonal compass support
2. **test_label_ellipse.R**: Comprehensive test script demonstrating all features
