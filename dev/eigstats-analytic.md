# Analytic Solutions for Confidence Intervals on Eigenvalue Statistics

## Overview

This document summarizes the search for analytic (asymptotic) solutions to construct
confidence intervals for eigenvalue-based statistics of sample covariance matrices,
as alternatives or complements to the bootstrap approach implemented in `eigstatCI()`.

The motivation is to extend the analytic confidence interval approach used for
log-determinant (based on Cai et al. 2015) to other eigenvalue-based measures:
- **Product** of eigenvalues (= determinant)
- **Sum** of eigenvalues (= trace)
- **Precision** (harmonic mean of eigenvalues)
- **Max** (largest eigenvalue)

## Summary Table

| Statistic | Analytic Theory | Implementation | Priority | Notes |
|-----------|----------------|----------------|----------|-------|
| **log(Product)** = logDet | ✅ Available | ✅ Implemented | - | Cai et al. (2015) |
| **Sum** (trace) | ✅ Available | ⏳ Recommended | **HIGH** | Bai-Silverstein CLT |
| **Max** eigenvalue | ✅ Available | ⏳ Consider | MEDIUM | Tracy-Widom distribution |
| **Product** (non-log) | ⚠️ Derivable | ❌ Not recommended | LOW | Use log scale instead |
| **Precision** (harmonic) | ❌ Not found | ❌ Use bootstrap | LOW | No specific theory |

Legend: ✅ = Yes, ❌ = No, ⚠️ = Possible but complex, ⏳ = To do

---

## Detailed Findings

### 1. Log Determinant (Sum of Log Eigenvalues) ✅

**Status:** Already implemented via `logdetCI()`

**Theory:** Cai, T. T., Liang, T., & Zhou, H. H. (2015). Law of log determinant of
sample covariance matrix and optimal estimation of differential entropy for
high-dimensional Gaussian distributions. *Journal of Multivariate Analysis*, 137, 161–172.
doi:[10.1016/j.jmva.2015.02.003](https://doi.org/10.1016/j.jmva.2015.02.003)

**Key results:**
- Establishes CLT for log determinant of sample covariance matrix in high-dimensional
  setting where dimension p can grow with sample size n
- Provides explicit variance formula allowing construction of confidence intervals
- Optimal rate of convergence achieved
- Asymptotically sharp minimax when p/n → 0

**Resources:**
- [ArXiv preprint](https://arxiv.org/abs/1309.0482)
- [Full PDF](http://www.stat.yale.edu/~hz68/Covariance-Determinant.pdf)
- [Author's page](https://tyliang.github.io/Tengyuan.Liang/publication/01-log-determinant-cov/)

**Implementation:** Already in `R/logdetCI.R`

---

### 2. Sum of Eigenvalues (Trace) ✅ **HIGH PRIORITY**

**Status:** Analytic solution available via linear spectral statistics theory

**Theory:** Bai, Z. D., & Silverstein, J. W. (2004). CLT for linear spectral statistics
of large-dimensional sample covariance matrices. *Annals of Probability*, 32(1A), 553-605.
doi:[10.1214/aop/1078415845](https://doi.org/10.1214/aop/1078415845)

**Key results:**
- Establishes CLT for linear spectral statistics (weighted sums of eigenvalues)
- Trace = sum of eigenvalues is a special case (all weights = 1)
- Under moment conditions, linear spectral statistics converge to Gaussian limits
- Rate of convergence: 1/n with explicit variance formulas
- Applies when both p and n → ∞ with p/n → γ ∈ (0, ∞)

**Asymptotic variance:**
The variance of the trace can be computed from the general linear spectral statistics
framework. For i.i.d. components, there are explicit formulas.

**Simplified approach (approximate):**
For individual eigenvalues λᵢ, an asymptotic confidence interval is:
```
λᵢ ± z* sqrt(2 λᵢ² / n)
```
where z* is the standard normal quantile.

For the trace (sum), under independence assumption:
```
Var(trace) ≈ sum of Var(λᵢ) = 2/n * sum(λᵢ²)
```

**References:**
- [Bai & Silverstein (2004) - Project Euclid](https://projecteuclid.org/journals/annals-of-probability/volume-32/issue-1A/CLT-for-linear-spectral-statistics-of-large-dimensional-sample-covariance/10.1214/aop/1078415845.full)
- [SAS Blog - Confidence Intervals for Eigenvalues](https://blogs.sas.com/content/iml/2020/10/26/confidence-interval-eigenvalues.html)
- [Wikipedia - Estimation of covariance matrices](https://en.wikipedia.org/wiki/Estimation_of_covariance_matrices)

**Recent extensions:**
- [Central limit theorem for linear spectral statistics of general separable sample
  covariance matrices (2020)](https://www.sciencedirect.com/science/article/abs/pii/S0378375820300720)
- [Applications with diverging spectrum (2022)](https://www.sciencedirect.com/science/article/abs/pii/S0167947322001979)

**Implementation recommendation:**
- Start with simplified formula: `trace ± z* sqrt(2/n * sum(λᵢ²))`
- For more accuracy, implement full Bai-Silverstein variance calculation
- Compare with bootstrap to validate finite-sample performance

---

### 3. Maximum Eigenvalue ✅ **MEDIUM PRIORITY**

**Status:** Analytic solution available via Tracy-Widom distribution

**Theory:** In random matrix theory, the largest eigenvalue of sample covariance
matrices (after proper centering and scaling) converges to the Tracy-Widom distribution.

**Key papers:**

1. **El Karoui (2007):** Tracy-Widom limit for the largest eigenvalue of a large class
   of complex sample covariance matrices. *Annals of Probability*, 35(2), 663-714.
   doi:[10.1214/009117906000000917](https://doi.org/10.1214/009117906000000917)

2. **Lee et al. (2014):** Tracy-Widom Distribution for the Largest Eigenvalue of Real
   Sample Covariance Matrices with General Population.
   [ArXiv:1409.4979](https://arxiv.org/abs/1409.4979)

3. **Convergence rates:** Near N^(-1/3) convergence to Tracy-Widom limit.
   [ArXiv:2108.02728](https://arxiv.org/abs/2108.02728)

**Key results:**
- After appropriate centering and scaling, the largest eigenvalue λ_max converges to
  the Tracy-Widom distribution (TW₁ for real matrices, TW₂ for complex)
- The centering and scaling depend on the regime (p/n ratio)
- Different behavior for "spiked" models (signal present) vs null (no signal)

**Tracy-Widom distribution:**
- Not a simple closed-form distribution
- Defined via Painlevé II differential equation
- Quantiles available in R package `RMTstat`

**Centering and scaling (approximate, for p/n → γ):**
```
(λ_max - μ_n) / σ_n →_d TW₁

where:
  μ_n = (1 + sqrt(γ))²
  σ_n = (1 + sqrt(γ)) * (1/sqrt(n) + 1/sqrt(p))^(1/3)
```

**Implementation challenges:**
- Requires numerical computation of Tracy-Widom quantiles
- Centering/scaling formulas depend on asymptotic regime
- More complex than normal-based CIs
- Different formulas for spiked vs non-spiked cases

**Implementation recommendation:**
- Use R package `RMTstat` for Tracy-Widom quantiles
- Implement for non-spiked case first (simpler)
- Validate against bootstrap
- Consider as enhancement after basic trace CI implemented

**References:**
- [Tracy-Widom distribution - Wikipedia](https://en.wikipedia.org/wiki/Tracy–Widom_distribution)
- [El Karoui (2007) - Project Euclid](https://projecteuclid.org/journals/annals-of-probability/volume-35/issue-2/TracyWidom-limit-for-the-largest-eigenvalue-of-a-large-class/10.1214/009117906000000917.full)

**R packages:**
- `RMTstat`: Tracy-Widom distributions and quantiles
- `LSD`: Linear Spectral Statistics Diagnostics

---

### 4. Product of Eigenvalues (Determinant, non-log) ⚠️

**Status:** Derivable from log-determinant theory, but not recommended

**Theory:** Since we have CLT for log(det) from Cai et al. (2015), we could apply
the delta method to get asymptotic distribution of det = exp(log(det)).

**Issues:**
- The determinant can be extremely small for large p (product of many eigenvalues < 1)
- Numerical instability in non-log scale
- Asymptotic distribution would be highly skewed (log-normal-like)
- CIs would be asymmetric and potentially very wide

**Recommendation:**
- **Always use log scale** (already implemented)
- If absolute scale needed, exponentiate the log-scale CIs:
  ```
  [exp(lower_logdet), exp(upper_logdet)]
  ```
- Do NOT attempt to develop separate theory for non-log determinant

---

### 5. Precision (Harmonic Mean of Eigenvalues) ❌

**Status:** No specific analytic theory found

**Definition:**
```
precision = p / sum(1/λᵢ) = p / trace(Σ⁻¹)
```

This is the harmonic mean of eigenvalues, or equivalently, p divided by the trace
of the precision matrix.

**Literature search:**
- No papers found specifically addressing asymptotic distribution of harmonic mean
  of eigenvalues
- No results for "harmonic mean eigenvalues" with "covariance matrix" and
  "asymptotic" or "confidence interval"
- This appears to be an understudied statistic in random matrix theory literature

**Potential approaches (not found in literature):**
1. **Delta method:** If we had CLT for trace(Σ⁻¹), could apply delta method
2. **Inverse Wishart theory:** Related but not directly applicable
3. **Simulation-based:** Characterize empirically

**Recommendation:**
- **Bootstrap remains the best approach** for this statistic
- Could investigate empirically whether asymptotic normality holds
- Not a priority for analytic implementation given lack of theory

---

### 6. Joint Distributions and Advanced Topics

**Joint behavior of statistics:**

Li, Han, & Yao (2020) study "Asymptotic joint distribution of extreme eigenvalues
and trace of large sample covariance matrix in a generalized spiked population model."
[ArXiv:1906.09639](https://arxiv.org/abs/1906.09639)

**Key result:** Joint convergence of:
- Largest eigenvalue
- Trace of sample covariance matrix
- Ratio of largest eigenvalue to trace

This could be useful for constructing simultaneous confidence regions for multiple
statistics.

**Other relevant work:**
- [Functional CLT for sample covariance matrices (2010)](https://projecteuclid.org/journals/bernoulli/volume-16/issue-4/Functional-CLT-for-sample-covariance-matrices/10.3150/10-BEJ250.pdf)
- [On confidence intervals for precision matrices (2022)](https://arxiv.org/abs/2208.11977)

---

## Implementation Recommendations

### Phase 1: High Priority (Recommended for Implementation)

**1. Implement analytic CI for trace (sum of eigenvalues)**

**Function:** `traceCI()` - analogous to existing `logdetCI()`

**Approach:**
- Start with simplified asymptotic variance: `Var(trace) = 2/n * sum(λᵢ²)`
- Normal-based CI: `trace ± z* * sqrt(Var(trace))`
- Input: List of covariance matrices (same as `logdetCI`)
- Output: Data frame with trace, lower, upper (same format)

**Benefits:**
- Clean theory (Bai-Silverstein 2004)
- Straightforward implementation
- Complements existing `logdetCI()`
- Fast (no bootstrap needed)

**Testing:**
- Compare with bootstrap CIs
- Test on iris, Skulls, other datasets
- Check coverage in simulation study

**Code location:**
- Create `R/traceCI.R` following pattern of `R/logdetCI.R`
- Update `plot.boxM()` to use analytic CI when `which = "sum"`

---

### Phase 2: Medium Priority (Consider for Future)

**2. Implement analytic CI for maximum eigenvalue**

**Function:** `maxeigCI()` using Tracy-Widom distribution

**Approach:**
- Use `RMTstat::qtw()` for Tracy-Widom quantiles
- Implement centering/scaling formulas for p/n regime
- Start with non-spiked (null) case

**Benefits:**
- Useful for outlier detection
- Well-established theory
- Available numerical tools

**Challenges:**
- More complex than trace
- Requires external package dependency
- Multiple cases to handle (spiked/non-spiked)

**Timeline:** After `traceCI()` is implemented and tested

---

### Phase 3: Low Priority (Keep Bootstrap)

**3. Precision (harmonic mean) - Continue using bootstrap**

**Rationale:**
- No analytic theory available
- Bootstrap works well
- Not worth developing ad-hoc approximations

**4. Product (non-log) - Not recommended**

**Rationale:**
- Numerical instability
- Log scale is preferable
- Can exponentiate log-based CIs if needed

---

## Comparison: Analytic vs Bootstrap

### Analytic (Asymptotic) Methods

**Advantages:**
- Fast computation (no resampling)
- Theoretically justified (CLT)
- Smooth, well-behaved CIs
- No Monte Carlo error

**Disadvantages:**
- Require large samples (asymptotic)
- May not perform well for small n or large p/n
- Assume specific distributional properties
- Limited to statistics with known theory

**When to use:**
- Large sample sizes (n > 100, preferably n >> p)
- Quick exploratory analysis
- Computational constraints

---

### Bootstrap Methods

**Advantages:**
- Minimal assumptions
- Works for any statistic
- Better finite-sample performance
- Handles complex designs

**Disadvantages:**
- Computationally intensive
- Monte Carlo variability
- Requires careful implementation
- May fail for small samples

**When to use:**
- Small to moderate samples
- Statistics without analytic theory (e.g., precision)
- When accuracy is more important than speed
- For validation of analytic CIs

---

## Validation Strategy

When implementing analytic CIs, validate against bootstrap:

1. **Simulation study:**
   - Generate data from known covariance structure
   - Compare coverage rates (should be near nominal, e.g., 95%)
   - Vary n, p, and p/n ratio
   - Test with different covariance structures (identity, Toeplitz, etc.)

2. **Real data examples:**
   - Iris (n=150, p=4, balanced)
   - Skulls (n=150, p=4, 5 groups)
   - Other heplots datasets

3. **Comparison metrics:**
   - Coverage rate (most important)
   - Interval width (shorter is better if coverage maintained)
   - Computation time
   - Stability across different random seeds (for bootstrap)

4. **Edge cases:**
   - Small n (n barely > p)
   - Large p/n ratio
   - Unbalanced designs
   - Singular or near-singular covariance matrices

---

## References

### Primary Sources

1. **Cai, T. T., Liang, T., & Zhou, H. H. (2015).** Law of log determinant of sample
   covariance matrix and optimal estimation of differential entropy for high-dimensional
   Gaussian distributions. *Journal of Multivariate Analysis*, 137, 161–172.
   https://doi.org/10.1016/j.jmva.2015.02.003

2. **Bai, Z. D., & Silverstein, J. W. (2004).** CLT for linear spectral statistics of
   large-dimensional sample covariance matrices. *Annals of Probability*, 32(1A), 553-605.
   https://doi.org/10.1214/aop/1078415845

3. **El Karoui, N. (2007).** Tracy-Widom limit for the largest eigenvalue of a large
   class of complex sample covariance matrices. *Annals of Probability*, 35(2), 663-714.
   https://doi.org/10.1214/009117906000000917

### Reviews and Tutorials

4. **SAS Blog:** Confidence intervals for eigenvalues of a correlation matrix.
   https://blogs.sas.com/content/iml/2020/10/26/confidence-interval-eigenvalues.html

5. **Wikipedia:** Estimation of covariance matrices.
   https://en.wikipedia.org/wiki/Estimation_of_covariance_matrices

6. **Wikipedia:** Tracy-Widom distribution.
   https://en.wikipedia.org/wiki/Tracy–Widom_distribution

### Extensions and Recent Work

7. **Li, Han, & Yao (2020).** Asymptotic joint distribution of extreme eigenvalues
   and trace of large sample covariance matrix in a generalized spiked population model.
   *Annals of Statistics*, 48(6).
   https://arxiv.org/abs/1906.09639

8. **Lee et al. (2014).** Tracy-Widom Distribution for the Largest Eigenvalue of Real
   Sample Covariance Matrices with General Population.
   https://arxiv.org/abs/1409.4979

9. **Recent CLT extensions (2020).** Central limit theorem for linear spectral
   statistics of general separable sample covariance matrices.
   https://www.sciencedirect.com/science/article/abs/pii/S0378375820300720

### Books

10. **Bai, Z., & Silverstein, J. W. (2010).** *Spectral Analysis of Large Dimensional
    Random Matrices* (2nd ed.). Springer.

---

## Technical Notes

### Asymptotic Regimes

Different papers use different asymptotic regimes:

1. **Classical:** p fixed, n → ∞
   - Standard multivariate asymptotics
   - Not applicable for modern high-dimensional problems

2. **Marčenko-Pastur:** p, n → ∞ with p/n → γ ∈ (0, 1)
   - Most common in random matrix theory
   - Applicable when p grows with n but slower

3. **High-dimensional:** p, n → ∞ with p/n → γ ∈ (0, ∞)
   - Allows p > n (ultra-high-dimensional)
   - Used in Cai et al. (2015)

4. **Very high-dimensional:** p → ∞, n → ∞ with p/n → ∞
   - Most challenging regime
   - Requires special techniques

**For Box's M test context:**
- Typically have p small (< 10 variables)
- n moderate to large (> 50 per group)
- Classical regime (p fixed) most relevant
- But modern theory provides better finite-sample approximations

### Moment Conditions

Most CLTs require moment conditions on the data:

- **Finite fourth moments:** Standard requirement for CLT
- **Sub-Gaussian:** Stronger condition, lighter tails
- **Heavy-tailed:** Some theory exists but more complex

For **Box's M test**, usually assume normality (finite moments of all orders),
so standard CLT theory applies.

---

## Next Steps

1. **Immediate:** Implement `traceCI()` function
   - Copy structure from `logdetCI()`
   - Use simplified variance formula
   - Test on existing examples

2. **Short-term:** Integrate with `plot.boxM()`
   - Modify to use `traceCI()` when `which = "sum"`
   - Update documentation
   - Add examples to vignette

3. **Medium-term:** Consider `maxeigCI()` implementation
   - Investigate `RMTstat` package
   - Prototype centering/scaling
   - Test against bootstrap

4. **Long-term:** Validation study
   - Simulation comparing analytic vs bootstrap
   - Write up methodology
   - Publish as vignette or paper supplement

---

## Conclusion

Analytic (asymptotic) confidence intervals are available for:
- **Log determinant** (already implemented)
- **Trace/sum** (recommended for implementation - HIGH PRIORITY)
- **Maximum eigenvalue** (possible but more complex - MEDIUM PRIORITY)

Bootstrap remains the best approach for:
- **Precision** (harmonic mean) - no theory available
- **Small sample sizes** - bootstrap may outperform asymptotics

The recommended next step is to implement `traceCI()` following the Bai-Silverstein
CLT for linear spectral statistics, as this provides the best balance of theoretical
rigor, implementation simplicity, and practical utility.

---

*Document created: 2024-12-28*
*Author: Claude (with Michael Friendly)*
*Status: Literature review complete, ready for implementation*
