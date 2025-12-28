# Bootstrap Confidence Intervals for Eigenvalue Statistics

## Overview

This implementation provides bootstrap confidence intervals for eigenvalue-based statistics in Box's M test, complementing the existing analytic `logdetCI()` function.

## Files

- **`eigstatCI.R`**: Core implementation of bootstrap CI functions
  - `eigstatCI()`: Main function for computing bootstrap CIs
  - `eigstatCI_boxM()`: Convenience wrapper for use with boxM objects

- **`test_eigstatCI.R`**: Comprehensive test script demonstrating usage

- **`boxM.R`**: Copy of `R/boxM.R` for testing modifications (DO NOT commit)

## Key Design Decisions

### 1. Standalone Function vs. Integration

The `eigstatCI()` function is **standalone** and requires passing the original data (`Y`) and grouping variable (`group`). This is necessary because:

- `boxM` objects don't store the original data (only covariance matrices)
- Bootstrap requires resampling the raw data, not just the covariance matrices
- Storing raw data in `boxM` objects would significantly increase memory usage

**Implication**: To use bootstrap CIs with `plot.boxM()`, we need to either:
1. Modify the `plot.boxM()` API to accept optional `Y` and `group` arguments
2. Create a wrapper function that users call separately
3. Store the data in the `boxM` object (not recommended)

### 2. Bootstrap Method: Percentile (Default)

The function defaults to `type = "perc"` (percentile method) because:

- **Distribution-free**: Makes no assumptions about the sampling distribution
- **Asymmetric intervals**: Appropriate for non-linear functions like eigenvalue statistics
- **Robust**: Works well even with moderate sample sizes
- **Simple**: Easy to understand and explain

Alternative methods available:
- `"bca"`: Bias-corrected and accelerated (more accurate but slower)
- `"norm"`: Normal approximation (faster but assumes normality)
- `"basic"`: Basic bootstrap (theoretical interest)

### 3. Bootstrap Replicates (R)

Default is `R = 1000`, which provides a good balance of:
- Accuracy: Sufficient for stable CI estimates
- Speed: Reasonable computation time (~few seconds for typical datasets)

For publication-quality results, consider `R = 5000` or `R = 10000`.

### 4. Handling Singular Covariance Matrices

The function checks if each group has `n > p` and skips bootstrap for groups that don't:

```r
if (nrow(group_data) <= p) {
  warning(...)
  # Return NA for this group
}
```

This is consistent with how `boxM()` handles singular matrices.

### 5. Parallel Processing

Optional parallel processing is supported via the `boot` package:

```r
eigstatCI(..., parallel = TRUE, ncpus = 4)
```

This can significantly speed up computation for:
- Large numbers of groups
- High bootstrap replicates (R > 1000)
- Large sample sizes

## Usage Examples

### Basic Usage

```r
library(boot)
source("dev/eigstatCI.R")

# Compute bootstrap CI for sum of eigenvalues
CI <- eigstatCI(Y = iris[,1:4],
                group = iris$Species,
                which = "sum",
                R = 1000,
                seed = 123)
print(CI)
```

### With a boxM Object

```r
# Fit Box's M test
boxm_result <- boxM(iris[,1:4], iris$Species)

# Get bootstrap CIs (must pass original data)
CI <- eigstatCI_boxM(boxm_result,
                     Y = iris[,1:4],
                     group = iris$Species,
                     which = "product",
                     R = 1000)
```

### All Statistics at Once

```r
stats <- c("product", "sum", "precision", "max")
CIs <- lapply(stats, function(stat) {
  eigstatCI(iris[,1:4], iris$Species, which = stat, R = 1000, seed = 123)
})
names(CIs) <- stats
```

## Integration with plot.boxM()

### Option 1: Modify plot.boxM() to Accept Data (Recommended)

Add `Y` and `group` as optional arguments to `plot.boxM()`:

```r
plot.boxM <- function(x, gplabel = NULL,
                      which = c("logDet", "product", "sum", "precision", "max"),
                      ...,
                      Y = NULL,        # NEW
                      group = NULL,    # NEW
                      boot.R = 1000,   # NEW
                      boot.type = "perc") {  # NEW

  if (which == "logDet") {
    # Use existing logdetCI() for analytic CI
    ...
  } else {
    # Use bootstrap CI if data provided
    if (!is.null(Y) && !is.null(group) && conf > 0) {
      CI <- eigstatCI(Y, group, which = which, R = boot.R,
                      conf = conf, type = boot.type)
      # Extract CI bounds and plot
      ...
    }
  }
}
```

**Usage:**
```r
plot(boxm_result, which = "sum",
     Y = iris[,1:4], group = iris$Species,
     gplabel = "Species")
```

### Option 2: Separate Plotting Function

Create a new function `plot_eigstat()` specifically for plotting with bootstrap CIs:

```r
plot_eigstat <- function(boxm, Y, group,
                         which = c("product", "sum", "precision", "max"),
                         R = 1000, ...) {
  CI <- eigstatCI(Y, group, which = which, R = R, ...)
  # Create plot similar to plot.boxM()
  ...
}
```

### Option 3: Two-Step Approach

Users compute CIs first, then plot:

```r
# Step 1: Compute CIs
CI <- eigstatCI(iris[,1:4], iris$Species, which = "sum", R = 1000)

# Step 2: Plot (using helper function)
plot_with_boot_ci(iris.boxm, CI, gplabel = "Species")
```

## Testing

Run the test script to verify functionality:

```r
source("dev/test_eigstatCI.R")
```

This tests:
1. Basic functionality with iris data
2. Skulls data (more groups)
3. Manual plotting with bootstrap CIs
4. Comparison of different CI methods
5. Verification of convexity property (pooled should be intermediate)

## Known Issues and Limitations

### 1. Computation Time

Bootstrap can be slow for:
- Large datasets (n > 1000)
- Many groups (k > 10)
- High bootstrap replicates (R > 5000)

**Solutions:**
- Use `parallel = TRUE` for multi-core processing
- Cache results for interactive use
- Use smaller R for exploratory analysis

### 2. Small Sample Sizes

Bootstrap may be unreliable when:
- Group sample sizes are very small (n < 20)
- Sample size is barely larger than p (n ≈ p + 5)

**Solutions:**
- Consider parametric bootstrap (not implemented)
- Use with caution and report R
- Increase sample size if possible

### 3. Data Storage

The biggest limitation is that `boxM` objects don't store raw data. This means:
- Users must keep track of original data
- Can't use `plot(boxm_obj, which = "sum")` directly with bootstrap CIs
- API change required for seamless integration

**Potential solutions:**
- Add `data` slot to boxM objects (increases size)
- Store data only if requested via argument
- Document clearly that users need to provide data

### 4. BCa Method May Fail

The bias-corrected and accelerated (BCa) method can fail with:
- Small sample sizes
- Extreme statistics
- Insufficient bootstrap replicates

**Solution:** Function automatically falls back to percentile method with a warning

## Performance Benchmarks

Rough estimates on a modern laptop (Intel i7):

| Dataset | Groups | n    | p | R    | Time    |
|---------|--------|------|---|------|---------|
| iris    | 3      | 150  | 4 | 1000 | ~2 sec  |
| iris    | 3      | 150  | 4 | 5000 | ~8 sec  |
| Skulls  | 5      | 150  | 4 | 1000 | ~3 sec  |

With `parallel = TRUE, ncpus = 4`:
- Speeds up by ~2-3x for multiple groups
- Less benefit for single group or very fast iterations

## Next Steps

### Short Term

1. **Test thoroughly** with various datasets:
   - Unbalanced designs
   - Small sample sizes
   - Many variables (large p)
   - Edge cases (singular groups, etc.)

2. **Decide on integration approach**:
   - Option 1 (modify plot.boxM) is cleanest but changes API
   - Option 2 (separate function) is safest but less convenient
   - Option 3 (two-step) gives most control but verbose

3. **Documentation**:
   - Add roxygen documentation (already done)
   - Create vignette section on bootstrap CIs
   - Add examples to plot.boxM docs

### Medium Term

1. **Optimize performance**:
   - Implement smart caching of bootstrap results
   - Consider using `future` package for better parallel support
   - Profile and optimize stat_fun()

2. **Extend functionality**:
   - Allow custom statistic functions
   - Support stratified bootstrap
   - Add parametric bootstrap option

3. **Validation**:
   - Compare with other bootstrap implementations
   - Verify coverage properties via simulation
   - Test on published datasets with known results

### Long Term

1. **Package integration**:
   - Merge into main package after testing
   - Update NEWS.md
   - Add to package tests

2. **Publication**:
   - Write up methodology
   - Create extended examples
   - Submit to journal or arXiv

## References

- Efron, B., & Tibshirani, R. J. (1994). *An Introduction to the Bootstrap*. CRC Press.
- Davison, A. C., & Hinkley, D. V. (1997). *Bootstrap Methods and Their Application*. Cambridge University Press.
- Friendly, M., & Sigal, M. (2018). Visualizing Tests for Equality of Covariance Matrices. *The American Statistician*, 72(4). https://doi.org/10.1080/00031305.2018.1497537

## Contact

Questions or issues? Check:
- Original StackOverflow question: https://stackoverflow.com/questions/45353073/
- Package issues: https://github.com/friendly/heplots/issues
