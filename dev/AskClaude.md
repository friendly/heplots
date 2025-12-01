# Ask Claude

## predict.mlm

Goal: Extend the predict methods for linear models to multivariate ones. That is, the function `predict.lm()` 
provides fitted values and standard errors for observations in any univariate linear model fit by `lm()`.
`predict.glm()` is similar for generalized linear models. 

What I want is a function `predict.mlm()`
for multivariate models of the form: `lm( cbind(y1, y2) = x1 + x2 + x3)`
The current version, `stats::predict.lm()` does handle multiple outcome variables, but does not provide standard errors
as an `se.fit` component. That's because these become $p \times p$ matrices when there are $p > 1$ response variables.


# This function is an attempt to put together the ideas in 
#   http://users.stat.umn.edu/~helwig/notes/mvlr-Notes.pdf
# with the framework for stats::predict.lm


## boot_cov.R

--> dev.boot_cov.R

Help solve the problem described in
https://stackoverflow.com/questions/45353073/bootstrapping-a-vector-of-results-by-group-in-r

Bootstrapping eigenvalues of grouped covariance matrices, for use in plot.boxM

## update for MLMs

How to write an update() method for a MLM?

--> see also dev/add.R
  - add(), drop(), step() for MLMs

--> see how this is done in the R source: src/library/stats/R/update.R

“Extracting the call” in update() and similar functions uses getCall() which itself is a (S3) 
generic function with a default method that simply gets x$call.

Because of this, update() will often work (via its default method) on new model classes, 
either automatically, or by providing a simple getCall() method for that class.

m <- lm(mpg ~ hp, data=mtcars)
getCall(m)

## Write a vignette for robust multivariate linear models and visualization

In the `heplots` package I define a general function `robmlm()` for fitting robust multivariate linear models.
It uses simple iterative re-weighted least squares (IRLS) using weights proportional to  Mahalanobis squared distances 
of the current residuals from the origin, and a scaling (covariance) matrix calculated by `MASS::cov.trob()`.
It returns an `"robmlm"` object inheriting from c("mlm", "lm"). There is a `plot.robmlm()` method that
plots the final weights against case number.

I'd like you to help me develop a vignette for "robust multivariate linear models" for the package.
It should begin with a brief general description of the problem of robust estimation for such models, with
relevant citations, such as Rousseeuw, P. J., Van Aelst, S., Van Driessen, K., & Gulló, J. A. (2004). 
Robust Multivariate Regression. Technometrics, 46(3), 293–305. https://doi.org/10.1198/004017004000000329
Then give a brief description of how IRLS works.

Once this is done, I'd like you to create some examples using datasets from this and other packages.
But let's first work on the introduction and framework for the vignette.

Let's start on a simple example using the dataset `carData::Pottery`. This is a MANOVA design with 5 response variables
(Al, Fe, Mg, Ca, Na) recorded in samples at 4 sites, in the variable `Site`.
1. Fit the standard MANOVA model and also the `robmlm()` equivalent. Compare the output from `car::Anova()` for each
2. Plot the weights for the `robmlm()` version.
3. Construct an `heplot()` for the first two response variables (`Al` and `Fe`) for the classical MANOVA model.
4. Overlay this with the heplot for the robmlm model, using the argument `add=TRUE`
Discuss what we can understand from this example

Chat URL: https://claude.ai/chat/f445d123-621e-4591-b57c-dbcf12298e64




## Write a vignette for one or more datasets

* Robust methods-- robmlm()
  - skulls data
  - car::pottery data
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

## label.ellipse

A function, `label.ellipse()` in my {heplots} package is designed to draw labels on ellipses using base R graphics.
The package is on Github at https://github.com/friendly/heplots. The version of this function I want help with is
at: https://raw.githubusercontent.com/friendly/heplots/refs/heads/master/dev/label.ellipse.R
I want to generalize the `label.pos` argument that determines the position on the ellipse where the label
is placed. It currently accepts `0:4` and corresponding compass directions, "C" (center) "N", "S", "E", "W" values.
I'd like you to add code for another set of compass-like values, `NE`, `SE`, `SW`, `NW` to mean at circular angles 45, 135, 225, 315.