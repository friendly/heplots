# Claude Code Guidelines for R Package Development

This file provides guidelines for Claude Code when working on R packages, particularly focused on statistical visualization and multivariate analysis packages like heplots.

## Code Style Preferences

### String Formatting and Console Output

**PREFER** `glue::glue()` for string interpolation and console output:
```r
# Good
message(glue::glue("Processing {n} observations from {ngroups} groups"))
warning(glue::glue("Groups {paste(singular_groups, collapse = ', ')} have been excluded"))
cat(glue::glue("Chi-Sq statistic: {round(statistic, 4)}\n"))

# Avoid
message(sprintf("Processing %d observations from %d groups", n, ngroups))
message(paste("Processing", n, "observations from", ngroups, "groups"))
```

**Benefits**: More readable, cleaner syntax, explicit variable interpolation.

**Package Setup**: 
- Add `Suggests: glue` to DESCRIPTION file
- Add `@importFrom glue glue` in any R file (typically in a utils.R or package-doc.R file)

### Vectorization Over Loops

**ALWAYS** prefer vectorized solutions over explicit loops when possible:

```r
# Good - Vectorized
logdet_all <- rep(-Inf, nlev)
logdet_all[valid_idx] <- log(sapply(mats[valid_idx], det))

# Avoid - Explicit loop
logdet_all <- rep(-Inf, nlev)
for (i in which(valid_idx)) {
  logdet_all[i] <- log(det(mats[[i]]))
}

# Good - Using apply family
means <- lapply(groups, function(g) colMeans(data[data$group == g, ]))

# Good - Using Map/mapply for parallel iteration
results <- Map(function(x, y) x * y + offset, xvals, yvals)

# Avoid - Manual loop
results <- vector("list", length(xvals))
for (i in seq_along(xvals)) {
  results[[i]] <- xvals[i] * yvals[i] + offset
}
```

### Function Documentation

Follow roxygen2 conventions with clear, complete documentation. 

This should use markdown style (`text`) where possible
rather than the old Rd style (\code{text}) and similarly for the mention of linked functions (`heplot()`, `graphics::text()`)
rather than `code{\link{heplots}}` or `\code{\link[graphics]{text}}

```r
#' Label an Ellipse
#'
#' @description 
#' Draws a text label on an ellipse at its center or around the periphery.
#' Provides flexible positioning using numeric indices, compass directions,
#' or automatic placement based on the correlation structure.
#'
#' @param ellipse A 2-column matrix of (x,y) coordinates defining the ellipse
#' @param label Character string for the label text
#' @param col Color for the label text. Default: "black"
#' @param label.pos Position for label. Can be:
#'   * `NULL` (default): automatic based on correlation sign
#'   * Integer 0-4: center, bottom, left, top, right
#'   * Cardinal directions: "C", "N", "S", "E", "W"
#'   * Diagonal directions: "NE", "SE", "SW", "NW"
#'   * Numeric value 0-1: fractional position around ellipse
#' @param ... Additional arguments passed to \code{\link{text}}
#'
#' @return Invisibly returns the coordinates where the label was placed
#'
#' @examples
#' # Create an ellipse
#' library(car)
#' ell <- ellipse(c(0,0), shape=matrix(c(1, 0.5, 0.5, 1), 2, 2), radius=2)
#' 
#' # Label at different positions
#' plot(ell, type="l", asp=1)
#' label.ellipse(ell, "NE corner", label.pos="NE", col="blue")
#' label.ellipse(ell, "Center", label.pos="C", col="red")
#'
#' @export
```

### Error Handling and Validation

Provide clear, informative error messages:

```r
# Good
if (!is.matrix(Y)) {
  stop(glue::glue("Y must be a matrix, got {class(Y)[1]}"))
}

if (ncol(ellipse) != 2) {
  stop(glue::glue("ellipse must have 2 columns (x, y), got {ncol(ellipse)} columns"))
}

# Check for valid label.pos values
valid_positions <- c("C", "N", "S", "E", "W", "NE", "SE", "SW", "NW")
if (is.character(label.pos) && !label.pos %in% valid_positions) {
  stop(glue::glue("Invalid label.pos: '{label.pos}'. Must be one of: {paste(valid_positions, collapse = ', ')}"))
}
```

### Warnings with Context

Make warnings informative and actionable:

```r
# Good
singular <- dfs < p
if (any(singular)) {
  singular_groups <- names(dfs)[singular]
  warning(glue::glue(
    "Groups {paste(singular_groups, collapse = ', ')} have fewer observations ",
    "than variables (n <= p) and have been excluded from calculations."
  ))
}

# Avoid vague warnings
warning("Some groups have issues")
```

## Package Development Practices

### Backward Compatibility

When extending functionality, maintain backward compatibility:

```r
# Extend existing arguments rather than breaking them
# OLD: label.pos accepts 0:4 and "N", "S", "E", "W"
# NEW: Also accepts "NE", "SE", "SW", "NW"
# Ensure old code still works exactly as before

# Use match.arg() for character arguments
label.pos <- match.arg(label.pos, 
                       c("C", "N", "S", "E", "W", "NE", "SE", "SW", "NW"))
```

### Return Values

Be explicit about return values, even for side-effect functions:

```r
# Good
label.ellipse <- function(ellipse, label, ...) {
  # ... plotting code ...
  
  # Return coordinates for potential further use
  invisible(list(x = label_x, y = label_y))
}
```

### Code Organization

Structure functions logically:

```r
function_name <- function(args) {
  # 1. Input validation and preprocessing
  if (!is.matrix(X)) X <- as.matrix(X)
  
  # 2. Handle special cases
  if (is.null(label.pos)) {
    label.pos <- if (cor_xy >= 0) "N" else "S"
  }
  
  # 3. Main computation
  result <- compute_something(X)
  
  # 4. Post-processing
  result <- format_result(result)
  
  # 5. Return
  invisible(result)
}
```

## Graphics and Visualization

### Base Graphics Focus

This package uses base R graphics. Maintain consistency:

```r
# Good - Using base graphics functions
text(x, y, labels = label, col = col, ...)
lines(ellipse, col = line.col, lwd = lwd)

# When adding to existing plots
points(x, y, pch = 19, col = col)

# Respect user's par() settings
oldpar <- par(no.readonly = TRUE)
on.exit(par(oldpar))
par(mar = c(4, 4, 2, 2))
```

### Coordinate Calculations

For geometric calculations (ellipses, angles, positions):

```r
# Use clear variable names
target_angle <- switch(label.pos,
                       "NE" = pi/4,
                       "SE" = -pi/4,
                       "SW" = -3*pi/4,
                       "NW" = 3*pi/4)

# Ensure angle ranges are consistent
# atan2() returns [-pi, pi], so convert target angles to same range
target_angle <- ((target_angle + pi) %% (2*pi)) - pi

# Vectorize angle calculations
angles <- atan2(ellipse[, 2], ellipse[, 1])
angle_diffs <- abs(angles - target_angle)
closest_idx <- which.min(angle_diffs)
```

## Testing and Debugging

### Create Comprehensive Test Scripts

```r
# test_label_ellipse.R
library(heplots)
library(car)

# Test all label positions
positions <- c("C", "N", "S", "E", "W", "NE", "SE", "SW", "NW", 0:4)

# Create test ellipse
ell <- ellipse(c(0,0), shape = matrix(c(1, 0.5, 0.5, 1), 2, 2), radius = 2)

# Visual test
par(mfrow = c(2, 2))
for (pos in positions) {
  plot(ell, type = "l", asp = 1, main = glue::glue("label.pos = '{pos}'"))
  label.ellipse(ell, label = glue::glue("pos={pos}"), label.pos = pos, col = "blue")
}

# Programmatic tests
test_coords <- label.ellipse(ell, "test", label.pos = "NE")
stopifnot(is.list(test_coords))
stopifnot(all(c("x", "y") %in% names(test_coords)))
```

## Package-Specific Conventions

### For heplots package specifically:

1. **Ellipse matrices**: Always 2-column matrices with (x, y) coordinates
2. **Color arguments**: Use `col` for primary colors, `fill` for fill colors
3. **Size arguments**: Use `size` for relative sizing, `radius` for absolute
4. **Label positioning**: Flexible system accepting multiple input types
5. **S3 methods**: Provide `default`, `lm`, `mlm` methods where appropriate

### Dependencies

```r
# Prefer base R when possible
# Use these packages when needed:
# - car: for ellipse(), dataEllipse()
# - MASS: for canonical discriminant analysis
# - glue: for string formatting (preferred over sprintf)
#   Use glue::glue() notation (don't import entire package)

# In DESCRIPTION:
# Imports: car
# Suggests: MASS, glue, rgl (for 3D plotting)

# In R/utils.R or R/heplots-package.R:
#' @importFrom glue glue
NULL

# This allows glue::glue() to work throughout the package
# Alternative: put @importFrom glue glue in the roxygen docs of any function that uses it
```

## Common Patterns in This Package

### Handling Different Input Types

```r
# Pattern for flexible input handling
process_input <- function(obj, ...) {
  if (inherits(obj, "lm")) {
    # Extract data from lm object
    data <- model.frame(obj)
    terms <- terms(obj)
    # ... 
  } else if (is.matrix(obj)) {
    # Use matrix directly
    data <- obj
  } else {
    stop(glue::glue("Unsupported object type: {class(obj)[1]}"))
  }
  
  # Continue with unified processing
}
```

### Covariance Matrix Calculations

```r
# Check for singular matrices
singular <- dfs < p
if (any(singular)) {
  # Handle gracefully, warn user, exclude from calculations
}

# Vectorized covariance calculation
cov_mats <- lapply(split(data, groups), cov)
valid_mats <- cov_mats[!singular]
```

## File Organization

```
package/
├── R/
│   ├── boxM.R           # Box's M test
│   ├── heplot.R         # Main HE plot functions
│   ├── label-ellipse.R  # Ellipse labeling utilities
│   └── utils.R          # Helper functions
├── man/                 # Generated by roxygen2
├── tests/
│   └── testthat/        # Unit tests
├── dev/                 # Development scripts
│   ├── test_*.R         # Manual test scripts
│   └── scratch.R        # Experimental code
└── vignettes/           # Package documentation
```

## Git Commit Messages

Write clear, descriptive commit messages:

```
Good:
- "Add diagonal compass directions (NE, SE, SW, NW) to label.ellipse()"
- "Fix boxM() to handle singular covariance matrices"
- "Vectorize angle calculations in label.ellipse()"

Avoid:
- "Update function"
- "Fix bug"
- "Changes"
```

## Notes for Claude Code

- **Always check** for existing helper functions before creating new ones
- **Read the package** NAMESPACE and existing code structure first
- **Test thoroughly** with edge cases (singular matrices, small samples, etc.)
- **Document** all changes, including rationale for design decisions
- **Preserve** existing function signatures and return types
- **Use** consistent naming: snake_case for internal functions, camelCase for exported functions (follow existing package convention)
