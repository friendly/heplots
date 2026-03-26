# Integration Plan: Adding traceCI() to plot.boxM()

## Overview

This document outlines how to integrate the analytic `traceCI()` function into `plot.boxM()` to provide confidence intervals when `which = "sum"`, following the existing pattern for `which = "logDet"`.

## Current State

### Existing plot.boxM() Behavior

**For `which = "logDet"`:**
- Uses analytic CI via `logdetCI()`
- Controlled by `conf` parameter (default 0.95)
- Uses `method` and `bias.adj` parameters
- No additional data required

**For other `which` values (product, sum, precision, max):**
- No confidence intervals displayed
- Just plots the point estimates
- Sets `conf <- 0` internally

### Code Pattern (from R/plot.boxM.R)

```r
plot.boxM <- function(x, gplabel = NULL,
                      which = c("logDet", "product", "sum", "precision", "max"),
                      log = which == "product",
                      pch = c(16, 15),
                      cex = c(2, 2.5),
                      col = c("blue", "red"),
                      rev = FALSE,
                      xlim,
                      conf = 0.95,
                      method = 1,
                      bias.adj = TRUE,
                      lwd = 2,
                      ...) {

  which <- match.arg(which)

  if (which == "logDet") {
    # Filter out singular groups
    valid_idx <- is.finite(x$logDet)
    measure <- x$logDet[valid_idx]
    xlab <- "log determinant"
    valid_groups <- head(valid_idx, -1)
  } else {
    eigstats <- summary(x, quiet = TRUE)$eigstats
    measure <- eigstats[which, ]
    if (log) measure <- log(measure)
    xlab <- paste(if (log) "log" else "", which, "of eigenvalues")
    conf <- 0  # <-- Currently disables CIs for eigenvalue stats
    valid_groups <- rep(TRUE, length(x$logDet))
  }

  ng <- length(measure) - 1

  if (missing(xlim)) {
    xlim <- range(measure[is.finite(measure)])
  }

  if (conf > 0) {
    # Only executed for logDet currently
    cov_valid <- x$cov[valid_groups]
    cov <- c(cov_valid, list(pooled = x$pooled))
    df_valid <- x$df[c(valid_groups, TRUE)]
    n <- df_valid + 1
    CI <- logdetCI(cov, n = n, conf = conf, method = method, bias.adj = bias.adj)
    xlim[1] <- min(xlim[1], CI$lower)
    xlim[2] <- max(xlim[2], CI$upper)
  }

  # ... plotting code ...

  if (conf > 0) {
    arrows(CI$lower, yorder, CI$upper, yorder,
           lwd = lwd, angle = 90, length = .075, code = 3)
  }

  # ... rest of plotting ...
}
```

---

## Proposed Changes

### Option 1: Simple Addition (Recommended)

**Minimal changes to existing code:**

1. Remove the line `conf <- 0` in the `else` block
2. Add a new CI computation block for `which = "sum"`
3. Keep existing structure and parameters

**Modified code:**

```r
plot.boxM <- function(x, gplabel = NULL,
                      which = c("logDet", "product", "sum", "precision", "max"),
                      log = which == "product",
                      pch = c(16, 15),
                      cex = c(2, 2.5),
                      col = c("blue", "red"),
                      rev = FALSE,
                      xlim,
                      conf = 0.95,      # Now applies to both logDet and sum
                      method = 1,       # Only used for logDet
                      bias.adj = TRUE,  # Only used for logDet
                      lwd = 2,
                      ...) {

  which <- match.arg(which)

  if (which == "logDet") {
    valid_idx <- is.finite(x$logDet)
    measure <- x$logDet[valid_idx]
    xlab <- "log determinant"
    valid_groups <- head(valid_idx, -1)
  } else {
    eigstats <- summary(x, quiet = TRUE)$eigstats
    measure <- eigstats[which, ]
    if (log) measure <- log(measure)
    xlab <- paste(if (log) "log" else "", which, "of eigenvalues")
    valid_groups <- rep(TRUE, length(x$logDet))

    # For stats other than sum, disable CIs (no analytic theory)
    if (which %in% c("product", "precision", "max")) {
      conf <- 0
    }
  }

  ng <- length(measure) - 1

  if (missing(xlim)) {
    xlim <- range(measure[is.finite(measure)])
  }

  # Compute confidence intervals
  if (conf > 0) {
    cov_valid <- x$cov[valid_groups]
    cov <- c(cov_valid, list(pooled = x$pooled))
    df_valid <- x$df[c(valid_groups, TRUE)]
    n <- df_valid + 1

    if (which == "logDet") {
      # Analytic CI for log determinant
      CI <- logdetCI(cov, n = n, conf = conf,
                     method = method, bias.adj = bias.adj)
    } else if (which == "sum") {
      # Analytic CI for trace (sum of eigenvalues)
      CI <- traceCI(cov, n = n, conf = conf)

      # If log scale is used for sum, convert CIs
      if (log) {
        CI$trace <- log(CI$trace)
        CI$lower <- log(CI$lower)
        CI$upper <- log(CI$upper)
      }
    }

    xlim[1] <- min(xlim[1], CI$lower)
    xlim[2] <- max(xlim[2], CI$upper)
  }

  # ... rest of plotting code unchanged ...
}
```

**Pros:**
- Minimal code changes
- Maintains backward compatibility
- Uses existing parameter `conf`
- Natural extension of current pattern

**Cons:**
- `method` and `bias.adj` parameters don't apply to trace
- Slightly asymmetric (logDet has more options)

---

### Option 2: Explicit CI Method Parameter

**Add explicit control over CI method:**

```r
plot.boxM <- function(x, gplabel = NULL,
                      which = c("logDet", "product", "sum", "precision", "max"),
                      log = which == "product",
                      pch = c(16, 15),
                      cex = c(2, 2.5),
                      col = c("blue", "red"),
                      rev = FALSE,
                      xlim,
                      conf = 0.95,
                      ci.method = c("analytic", "none"),  # NEW parameter
                      method = 1,       # logDet specific
                      bias.adj = TRUE,  # logDet specific
                      lwd = 2,
                      ...) {

  ci.method <- match.arg(ci.method)

  # ... setup code ...

  # Compute CIs only if requested
  if (conf > 0 && ci.method == "analytic") {
    if (which == "logDet") {
      CI <- logdetCI(cov, n = n, conf = conf, method = method, bias.adj = bias.adj)
    } else if (which == "sum") {
      CI <- traceCI(cov, n = n, conf = conf)
    } else {
      # No analytic CI available for product, precision, max
      ci.method <- "none"
      message(paste("Analytic CI not available for which =", which))
    }
  }

  # ... plotting ...
}
```

**Pros:**
- Explicit control
- Clear when CIs are/aren't available
- Room for future "bootstrap" option

**Cons:**
- More complex API
- Breaks backward compatibility slightly (new parameter)
- May be overkill for current needs

---

### Option 3: Automatic Detection (Simple & Clean)

**Auto-detect which CI method to use:**

```r
plot.boxM <- function(x, gplabel = NULL,
                      which = c("logDet", "product", "sum", "precision", "max"),
                      log = which == "product",
                      pch = c(16, 15),
                      cex = c(2, 2.5),
                      col = c("blue", "red"),
                      rev = FALSE,
                      xlim,
                      conf = 0.95,
                      method = 1,       # logDet specific
                      bias.adj = TRUE,  # logDet specific
                      lwd = 2,
                      ...) {

  which <- match.arg(which)

  # ... setup code ...

  # Auto-select CI method based on which statistic
  has_analytic_ci <- which %in% c("logDet", "sum")

  if (conf > 0 && has_analytic_ci) {
    cov_valid <- x$cov[valid_groups]
    cov <- c(cov_valid, list(pooled = x$pooled))
    df_valid <- x$df[c(valid_groups, TRUE)]
    n <- df_valid + 1

    CI <- switch(which,
      "logDet" = logdetCI(cov, n = n, conf = conf,
                          method = method, bias.adj = bias.adj),
      "sum" = {
        ci <- traceCI(cov, n = n, conf = conf)
        if (log) {
          ci$trace <- log(ci$trace)
          ci$lower <- log(ci$lower)
          ci$upper <- log(ci$upper)
        }
        ci
      }
    )

    xlim[1] <- min(xlim[1], CI$lower)
    xlim[2] <- max(xlim[2], CI$upper)
  }

  # ... plotting ...
}
```

**Pros:**
- Clean, simple code
- No new parameters
- Automatically uses best available method
- Easy to extend later

**Cons:**
- Less explicit control
- User can't disable CI for sum if they want

---

## Recommendation: **Option 1** (Simple Addition)

I recommend **Option 1** because:

1. **Minimal changes** - Just modify the existing `if (conf > 0)` block
2. **Backward compatible** - Existing code works exactly the same
3. **Consistent with current design** - Mirrors logDet approach
4. **Easy to understand** - Clear conditional logic
5. **Room to grow** - Can add Option 2's `ci.method` parameter later if needed

---

## Implementation Steps

### Step 1: Modify R/plot.boxM.R

**Lines to change:**

1. **Line ~116:** Remove `conf <- 0` from else block
2. **Line ~128-137:** Expand CI computation block
3. **Documentation:** Update `@param conf` description

**Specific changes:**

```r
# BEFORE (line ~111-119):
  else {
    eigstats <- summary(x, quiet=TRUE)$eigstats
    measure <- eigstats[which,]
    if(log) measure <- log(measure)
    xlab <- paste(if(log) "log" else "", which, "of eigenvalues" )
    conf <- 0  # <-- REMOVE THIS LINE
    valid_groups <- rep(TRUE, length(x$logDet))
  }

# AFTER:
  else {
    eigstats <- summary(x, quiet=TRUE)$eigstats
    measure <- eigstats[which,]
    if(log) measure <- log(measure)
    xlab <- paste(if(log) "log" else "", which, "of eigenvalues" )
    valid_groups <- rep(TRUE, length(x$logDet))

    # Disable CIs for stats without analytic theory
    if (which %in% c("product", "precision", "max")) {
      conf <- 0
    }
  }
```

```r
# BEFORE (line ~128-137):
  if (conf>0) {
    cov_valid <- x$cov[valid_groups]
    cov <- c(cov_valid, list(pooled=x$pooled))
    df_valid <- x$df[c(valid_groups, TRUE)]
    n <- df_valid + 1
    CI <- logdetCI( cov, n=n, conf=conf, method=method, bias.adj=bias.adj )
    xlim[1] <- min(xlim[1], CI$lower)
    xlim[2] <- max(xlim[2], CI$upper)
  }

# AFTER:
  if (conf > 0) {
    # Use only valid (non-singular) groups for confidence intervals
    cov_valid <- x$cov[valid_groups]
    cov <- c(cov_valid, list(pooled = x$pooled))
    df_valid <- x$df[c(valid_groups, TRUE)]
    n <- df_valid + 1

    # Select CI method based on statistic
    if (which == "logDet") {
      CI <- logdetCI(cov, n = n, conf = conf,
                     method = method, bias.adj = bias.adj)
    } else if (which == "sum") {
      CI <- traceCI(cov, n = n, conf = conf)
      # Adjust for log scale if needed
      if (log) {
        CI$trace <- log(CI$trace)
        CI$lower <- log(CI$lower)
        CI$upper <- log(CI$upper)
      }
    }

    # Update xlim to include CIs
    xlim[1] <- min(xlim[1], CI$lower)
    xlim[2] <- max(xlim[2], CI$upper)
  }
```

### Step 2: Update Documentation

**@param conf:**
```r
#' @param conf coverage for approximate confidence intervals, `0 <= conf <
#'   1`; use `conf=0` to suppress these. Confidence intervals are available
#'   for `which = "logDet"` (using `logdetCI()`) and `which = "sum"`
#'   (using `traceCI()`).
```

**@seealso:**
```r
#' @seealso \code{\link{boxM}}, \code{\link{logdetCI}}, \code{\link{traceCI}}
```

**@examples:** Add example with trace CI
```r
#' # Trace with analytic CI
#' plot(skulls.boxm, which = "sum", gplabel = "Epoch",
#'      main = "Sum of eigenvalues with CI")
```

### Step 3: Update NAMESPACE

Add import for traceCI:
```r
export(traceCI)
```

### Step 4: Move traceCI.R to R/

```bash
# Copy from dev to R
cp dev/traceCI.R R/traceCI.R
```

### Step 5: Update DESCRIPTION

If glue is used in traceCI warnings/errors:
```
Suggests: ..., glue
```

### Step 6: Test Integration

**Test script:**

```r
library(heplots)

# Test 1: Iris data
iris.boxm <- boxM(iris[, 1:4], iris$Species)

# Should show CI (analytic)
plot(iris.boxm, which = "sum", gplabel = "Species",
     main = "Sum with analytic CI")

# Should show no CI (no theory)
plot(iris.boxm, which = "precision", gplabel = "Species",
     main = "Precision (no CI)")

# Suppress CI explicitly
plot(iris.boxm, which = "sum", conf = 0, gplabel = "Species",
     main = "Sum without CI")

# Test 2: Skulls data
data(Skulls)
skulls.mod <- lm(cbind(mb, bh, bl, nh) ~ epoch, data = Skulls)
skulls.boxm <- boxM(skulls.mod)

plot(skulls.boxm, which = "sum", gplabel = "Epoch",
     main = "Skulls: Sum with CI")
```

---

## Testing Checklist

- [ ] logDet CI still works (backward compatibility)
- [ ] sum CI works with new traceCI()
- [ ] product, precision, max have no CI (conf <- 0)
- [ ] conf = 0 suppresses CIs
- [ ] Different confidence levels work (0.90, 0.95, 0.99)
- [ ] Log scale for sum works correctly
- [ ] Singular groups handled properly
- [ ] xlim expansion works with CIs
- [ ] Documentation is clear
- [ ] Examples run without error
- [ ] No warnings for normal use

---

## Future Extensions

### Phase 2: Bootstrap Option

After initial integration, could add:

```r
plot.boxM <- function(...,
                      ci.method = c("analytic", "bootstrap", "none"),
                      boot.R = 1000,
                      boot.seed = NULL,
                      ...) {

  ci.method <- match.arg(ci.method)

  if (ci.method == "bootstrap") {
    # Require Y and group (not in boxM object)
    if (missing(Y) || missing(group)) {
      stop("Bootstrap CIs require Y and group arguments")
    }
    CI <- eigstatCI(Y, group, which = which, R = boot.R, seed = boot.seed)
  } else if (ci.method == "analytic") {
    # Use existing analytic methods
    ...
  }
}
```

But this requires API changes (adding Y, group parameters) which is more complex.

### Phase 3: Maximum Eigenvalue

When `maxeigCI()` is implemented (Tracy-Widom):

```r
if (which == "max") {
  CI <- maxeigCI(cov, n = n, conf = conf)
}
```

---

## Summary

**Recommended approach:** Option 1 - Simple Addition

**Changes needed:**
1. Remove `conf <- 0` from else block (1 line)
2. Add conditional for which == "sum" (5 lines)
3. Update documentation (3 locations)
4. Move traceCI.R from dev/ to R/
5. Test thoroughly

**Result:**
- Users can now do `plot(boxm, which = "sum")` and get CIs automatically
- Maintains full backward compatibility
- Clear, simple code
- Easy to test and verify

---

*Document created: 2024-12-28*
*Author: Claude (with Michael Friendly)*
*Status: Ready for implementation*
