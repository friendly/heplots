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

The main use for this is in plots of coefficients of linear and multivariate linear models, to put the predictor and
response variables on standardized scales.

Some examples of standardizing coefficients in  `dev/standardize.R`

But what I want is something that will give a new "lm" or "mlm" object where all numeric variables
have been replaced with their standardized (`scale()`) equivalents.

The function should be called `lm.std()` and take exactly the same set of arguments that `lm()` allows.

```
update(mod, data = scale(data))
```

## label.ellipse [DONE]

A function, `label.ellipse()` in my {heplots} package is designed to draw labels on ellipses using base R graphics.
The package is on Github at https://github.com/friendly/heplots. The version of this function I want help with is
at: https://raw.githubusercontent.com/friendly/heplots/refs/heads/master/dev/label.ellipse.R
I want to generalize the `label.pos` argument that determines the position on the ellipse where the label
is placed. It currently accepts `0:4` and corresponding compass directions, "C" (center) "N", "S", "E", "W" values.
I'd like you to add code for another set of compass-like values, `NE`, `SE`, `SW`, `NW` to mean at circular angles 45, 135, 225, 315.

## Fix `boxM`

The function `boxM()` in this package calculates Box's M test for equality of covariance matrices in a MANOVA model.
There is a problem, in that it gives `NaN` values if any one or more groups has a singular covariance matrix.
The computation assumes that the covariance matrix for each group
is non-singular, so that $\log det(S_i)$ can be calculated for each group. This requires that $n_i > p$ for each group.

The source code is at: https://raw.githubusercontent.com/friendly/heplots/refs/heads/master/R/boxM.R
Please read that and then I'll tell you what to do.

The relevant code is inside the function `boxM.default` in lines 155-175. I think the way to fix this is to change the computation
at lines 168-170 so that `logdet`, `minus2logM` and `sum1` are calculated only over those groups for which `dfs[i] > p`

```
   logdet <- log(unlist(lapply(mats, det)))
   minus2logM <- sum(dfs) * log(det(pooled)) - sum(logdet * dfs)
   sum1 <- sum(1 / dfs) 
```

The warning message on lines 159-160 should also be changed to say additionally that "groups ... have been excluded from the calculations"

Here is a test case, where there are two groups with only `n = 4`.
```
data(painters, package = "MASS")
school <- c("Renaissance", "Mannerist", "Sciento", "Venetian",
		"Lombard", "16th C", "17th C", "French")
levels(painters$School) <- school
table(painters$School)

painters.mod <- lm(cbind(Composition, Drawing, Colour, Expression) ~ School, data=painters)
painters.boxM <- boxM(painters.mod) |> 
  print()
summary(painters.boxM)
```

There is still a problem with the `plot.boxM()` when any groups have singular covariance matrices.
For the `painters` data, there is an error and a warning. Can you correct this?


```
> plot(painters.boxM)
Error in plot.window(xlim = xlim, ylim = ylim, log = log) : 
  need finite 'xlim' values
In addition: Warning messages:
1: In x$df + c(rep(1, ng), ng) :
  longer object length is not a multiple of shorter object length
2: In log(det(x)) : NaNs produced
```

This is a continuation of the discussion regarding the `boxM` function in my `heplots