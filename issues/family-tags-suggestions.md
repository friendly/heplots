# @family Tag Suggestions for heplots Package

**Date:** 2025-12-05
**Package:** heplots v1.8.1

Based on analysis of the 44 R source files in the package, here are suggested `@family` tags to improve cross-referencing in the documentation.

---

## Recommended Family Groupings

### 1. HE Plot Functions

**Family tag:** `@family HE plot functions`

**Functions:**
- `heplot()` - 2D HE plots
- `heplot3d()` - 3D HE plots
- `heplot1d()` - 1D HE plots
- `pairs.mlm()` - Pairs plot for mlm objects

**Rationale:** These are the core visualization functions for hypothesis-error plots in different dimensions.

---

### 2. Covariance Ellipse Functions

**Family tag:** `@family covariance ellipses`

**Functions:**
- `covEllipses()` - Plot covariance ellipses
- `ellipse.axes()` - Draw axes for an ellipse
- `ellipse.box()` - Draw a box around an ellipse
- `ellipse3d.axes()` - Draw axes for a 3D ellipsoid

**Rationale:** Related functions for working with covariance ellipses and their visualization.

---

### 3. Homogeneity Tests

**Family tag:** `@family homogeneity tests`

**Functions:**
- `boxM()` - Box's M-test for homogeneity of covariance matrices
- `bartlettTests()` - Bartlett's tests for homogeneity of variance
- `leveneTests()` - Levene's tests for homogeneity of variance

**Rationale:** All test homogeneity assumptions for multivariate data.

---

### 4. Ellipse/Ellipsoid Utilities

**Family tag:** `@family ellipsoid geometry`

**Functions:**
- `Ellipsoid()` - Create ellipsoid objects
- `label.ellipse()` - Label an ellipse
- `mark.H0()` - Mark a hypothesis point on a plot

**Rationale:** Utility functions for working with ellipsoid geometry.

---

### 5. 3D Graphics Utilities

**Family tag:** `@family 3D plotting`

**Functions:**
- `heplot3d()` - 3D HE plots (also in HE plot functions)
- `arrow3d()` - Draw 3D arrows
- `cross3d()` - Draw 3D crosses
- `bbox3d()` - Create 3D bounding boxes
- `ellipse3d.axes()` - 3D ellipsoid axes (also in covariance ellipses)

**Rationale:** Functions specifically for 3D visualization using rgl.

---

### 6. MLM Methods / Model Information

**Family tag:** `@family multivariate linear models`

**Functions:**
- `coefplot.mlm()` - Coefficient plots for mlm
- `glance.mlm()` - Tidy model summaries (broom compatibility)
- `pairs.mlm()` - Pairs plots for mlm (also in HE plot functions)
- `termInfo()` - Extract term information
- `termMeans()` - Calculate term means

**Rationale:** Functions for extracting information from and summarizing mlm objects.

---

### 7. Effect Size and Statistics

**Family tag:** `@family effect sizes`

**Functions:**
- `etasq()` - Eta-squared effect sizes
- `uniStats()` - Univariate statistics

**Rationale:** Functions for calculating effect size measures.

---

### 8. Robust Methods

**Family tag:** `@family robust methods`

**Functions:**
- `robmlm()` - Robust multivariate linear models
- `plot.robmlm()` - Plot method for robmlm
- `Mahalanobis()` - Mahalanobis distances (can handle robust estimates)

**Rationale:** Functions for robust estimation and diagnostics.

---

### 9. Utility Functions

**Family tag:** `@family utility functions`

**Functions:**
- `trans.colors()` - Make colors transparent
- `colDevs()` - Column deviations
- `gsorth()` - Gram-Schmidt orthogonalization
- `statList()` - Create lists of statistics
- `rel_diff()` - Relative differences
- `text_usr()` - Text in user coordinates

**Rationale:** Helper functions used across the package.

---

### 10. Diagnostic Plots

**Family tag:** `@family diagnostic plots`

**Functions:**
- `cqplot()` - Chi-square Q-Q plots
- `distancePlot()` - Distance plots
- `interpPlot()` - Interpolation plots
- `plot.boxM()` - Plot method for Box's M test

**Rationale:** Specialized diagnostic visualization functions.

---

### 11. Confidence Intervals and Inference

**Family tag:** `@family inference`

**Functions:**
- `logdetCI()` - Confidence intervals for log determinants
- `boxM()` - Box's M-test (also in homogeneity tests)

**Rationale:** Functions related to statistical inference.

---

## Implementation Priority

### High Priority (Most User-Facing)

1. **HE plot functions** - Core functionality, users most likely to look up related functions
2. **Homogeneity tests** - Conceptually related, users often compare these tests
3. **Covariance ellipses** - Related visualization tools

### Medium Priority

4. **MLM methods** - Helpful for users working with mlm objects
5. **Effect sizes** - Users often need multiple effect size measures
6. **Diagnostic plots** - Related plotting tools

### Lower Priority

7. **3D plotting** - More specialized
8. **Ellipsoid geometry** - Mostly internal utilities
9. **Robust methods** - Smaller subset of users
10. **Utility functions** - Mostly internal
11. **Inference** - Small group

---

## Multi-Family Assignments

Some functions logically belong to multiple families. Use multiple `@family` tags for these:

### heplot3d()
```r
#' @family HE plot functions
#' @family 3D plotting
```

### pairs.mlm()
```r
#' @family HE plot functions
#' @family multivariate linear models
```

### ellipse3d.axes()
```r
#' @family covariance ellipses
#' @family 3D plotting
```

### boxM()
```r
#' @family homogeneity tests
#' @family inference
```

---

## Example Implementation

Here's how to add these to an existing function (using `heplot.R` as example):

```r
#' Two-Dimensional HE Plots
#'
#' This function plots ellipses representing the hypothesis and error
#' sums-of-squares-and-products matrices for terms and linear hypotheses in a
#' multivariate linear model.
#'
#' @param mod a model object of class `"mlm"`.
#' @param terms a logical value or character vector of terms...
#' ... [other parameters]
#'
#' @return An invisible list with components...
#'
#' @family HE plot functions
#'
#' @examples
#' # Example code here
#'
#' @export
heplot <- function(mod, ...) {
  # function body
}
```

For `heplot3d.R`:

```r
#' Three-Dimensional HE Plots
#'
#' This function plots ellipsoids in 3D representing the hypothesis and error
#' sums-of-squares-and-products matrices for terms and linear hypotheses in a
#' multivariate linear model.
#'
#' @param mod a model object of class `"mlm"`.
#' ... [other parameters]
#'
#' @return An invisible list with components...
#'
#' @family HE plot functions
#' @family 3D plotting
#'
#' @examples
#' # Example code here
#'
#' @export
heplot3d <- function(mod, ...) {
  # function body
}
```

---

## Benefits for heplots

1. **Discoverability**: Users who find `heplot()` will see `heplot3d()` and `heplot1d()` in the "See also" section
2. **Learning curve**: New users can discover related functions more easily
3. **Function relationships**: Shows which functions work together (e.g., all the ellipse labeling functions)
4. **Better help navigation**: Particularly useful for the many visualization functions in this package

---

## Complete Function List by File

For reference, here's the complete list of R files to review:

```
arrow3d.R           - 3D plotting
bartlettTests.R     - homogeneity tests
bbox3d.R            - 3D plotting
boxM.R              - homogeneity tests, inference
coefplot.mlm.R      - multivariate linear models
colDevs.R           - utility functions
covEllipses.R       - covariance ellipses
cqplot.R            - diagnostic plots
cross3d.R           - 3D plotting
datasets.R          - (data documentation, no @family needed)
distancePlot.R      - diagnostic plots
ellipse.axes.R      - covariance ellipses
ellipse.box.R       - covariance ellipses
ellipse3d.axes.R    - covariance ellipses, 3D plotting
Ellipsoid.R         - ellipsoid geometry
etasq.R             - effect sizes
glance.mlm.R        - multivariate linear models
gsorth.R            - utility functions
heplot.R            - HE plot functions
heplot1d.R          - HE plot functions
heplot3d.R          - HE plot functions, 3D plotting
heplots-internal.R  - (internal, no @family needed)
heplots-package.R   - (package doc, no @family needed)
interpPlot.R        - diagnostic plots
label.ellipse.R     - ellipsoid geometry
leveneTests.R       - homogeneity tests
logdetCI.R          - inference
Mahalanobis.R       - robust methods
mark.H0.R           - ellipsoid geometry
noteworthy.R        - (utility or internal)
pairs.mlm.R         - HE plot functions, multivariate linear models
plot.boxM.R         - diagnostic plots
plot.robmlm.R       - robust methods
rel_diff.R          - utility functions
robmlm.R            - robust methods
schoolsites.R       - (likely data or example)
statList.R          - utility functions
termInfo.R          - multivariate linear models
termMeans.R         - multivariate linear models
text_usr.R          - utility functions
trans.colors.R      - utility functions
uniStats.R          - effect sizes
utility-car.R       - utility functions
zzz.R               - (package hooks, no @family needed)
```

---

## Implementation Steps

1. **Start with high-priority families** (HE plot functions, homogeneity tests, covariance ellipses)
2. **Add @family tags** to the roxygen2 documentation blocks
3. **Run `devtools::document()`** to regenerate .Rd files
4. **Check the results** by looking at `?heplot` and similar help pages
5. **Iterate** through medium and lower priority families

---

## Notes

- Follow the existing documentation style in heplots (uses markdown format already)
- Multiple `@family` tags are allowed and encouraged when appropriate
- This will not break existing documentation, only enhance it
- The "See also" section will be automatically generated
- Family names should be descriptive and consistent
