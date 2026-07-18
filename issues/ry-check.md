# ry static check results

Run with [`ry`](https://github.com/sims1253/ry) v0.5.0 against `R/` on 2026-07-15.

```
ry check R/ --color never
```

**Summary:** checked 46 file(s), 1 error, 4 warnings.

## Findings

### 1. `R/covEllipses.R:186` — error `[RY040]` cannot apply arithmetic op to `list` and `double`

```r
dfs <- tapply(group, group, length) - 1
```

`tapply()` with a scalar-returning `FUN` (here `length`) returns an atomic
vector/array under R's default `simplify = TRUE`, not a `list`. This looks
like a **false positive** — ry's type inference is likely defaulting to the
worst case (`simplify = FALSE` → list) for `tapply()` without accounting for
`simplify`'s effect on the return type. Worth flagging upstream to the `ry`
project; no action needed in `heplots`.

### 2–5. `R/distancePlot.R:192-195` — warnings `[RY010]` variable `NLSY.mlm` is not bound in this scope

```r
if (FALSE){
  # data(NLSY, package = "heplots")
  # NLSY.mlm <- lm(cbind(math, read) ~ income + educ + antisoc + hyperact,
  #                data = NLSY)
  # ...

  insight::get_data(NLSY.mlm) |> str()
  insight::get_response(NLSY.mlm) |> str()
  insight::find_response(NLSY.mlm)
  insight::find_formula(NLSY.mlm)
}
```

This block is dead code guarded by `if (FALSE)` — leftover dev/scratch code
where the lines that actually define `NLSY.mlm` were commented out but the
lines using it were not. It's unreachable at runtime, so it's harmless as
shipped, but `ry`'s diagnostic is technically correct: `NLSY.mlm` really is
unbound in that scope. **Real cleanup opportunity**: either uncomment the
setup lines to make this a working example, or delete the dead block
entirely (`if (FALSE)` blocks like this are typically excluded from R CMD
check anyway, but they add noise).

## Raw output

```
R/covEllipses.R:186:9: error: [RY040] cannot apply arithmetic op to `list` and `double`
   dfs <- tapply(group, group, length) - 1
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
R/distancePlot.R:192:21: warning: [RY010] variable `NLSY.mlm` is not bound in this scope
    insight::get_data(NLSY.mlm) |> str()
                      ^~~~~~~~
R/distancePlot.R:193:25: warning: [RY010] variable `NLSY.mlm` is not bound in this scope
    insight::get_response(NLSY.mlm) |> str()
                          ^~~~~~~~
R/distancePlot.R:194:26: warning: [RY010] variable `NLSY.mlm` is not bound in this scope
    insight::find_response(NLSY.mlm)
                           ^~~~~~~~
R/distancePlot.R:195:25: warning: [RY010] variable `NLSY.mlm` is not bound in this scope
    insight::find_formula(NLSY.mlm) 
                          ^~~~~~~~
ry: checked 46 file(s), 1 error(s), 4 warning(s)
```
