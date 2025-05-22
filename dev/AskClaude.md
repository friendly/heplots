# Ask Claude

## predict.mlm

Goal: Extend the predict methods for linear models to multivariate ones. That is, the function `predict.lm()` 
provides fitted values and standard errors for observations in any linear model fit by `lm()`.
`predict.glm()` is similar for generalized linear models. What I want is a function `predict.mlm()`
for multivariate models of the form: `lm( cbind(y1, y2) = x1 + x2 + x3)`

# This function is an attempt to put together the ideas in 
#   http://users.stat.umn.edu/~helwig/notes/mvlr-Notes.pdf
# with the framework for stats::predict.lm


## boot_cov.R

--> dev.boot_cov.R

Bootstrapping eigenvalues of grouped covariance matrices, for use in plot.boxM

## update for MLMs

How to write an update() method for a MLM?

--> see also dev/add.R
  - add(), drop(), step() for MLMs

“Extracting the call” in update() and similar functions uses getCall() which itself is a (S3) 
generic function with a default method that simply gets x$call.

Because of this, update() will often work (via its default method) on new model classes, 
either automatically, or by providing a simple getCall() method for that class.

m <- lm(mpg ~ hp, data=mtcars)
getCall(m)

## Write a vignette for one or more datasets

* Robust methods-- roblm()
  - schooldata, NLSY
  - pulpfiber example
  
* Candisc examples? -- but what is in that package; or, how to refer to that package here?
  - Hernior, Big5, MockJury, SocGrades, SocialCog, ...


## Transform a LM/MLM to use standardized variables.

--> dev/scale-test.R

Would be similar to

```
update(mod, data = scale(data))
```
