## Test environments
* local Windows 7 install, R 3.1.2
* win-builder (R-devel 3.3.0 alpha (2016-03-23 r70368), 3.2.4 Revised (2016-03-16 r70336))

## R CMD check results
There were no ERRORs or WARNINGs.  One spurious NOTE (since I mention the candisc package in DESCRIPTION)
Possibly mis-spelled words in DESCRIPTION:
  candisc (19:77)

## Comments
This is a major release, with new functions for equality of covariance matrices

# heplots 1.1-0

o Added boXM from biotools
o Fleshed out boxM() with formula, lm, plot and summary methods
o added plot.boxM() method
o Added covEllipses() methods for plotting (possibly robust) covariance ellipses
o Added colDevs() as a utility and for use in other multivariate tests.
o Added data(AddHealth), a simple example of a one-way MANOVA with nice views [thx: Russell Warne]
o summary.boxM() now returns the calculated statistics and can be used to construct other kinds of plots.
o plot.boxM() gets a gplabel argument to provide a label for the group factor
o pairs.mlm() gets a var.cex argument to control size of variable labels
o Added logdetCI() for confidence intervals on log determinants of covariance matrices (experimental)
o Now use logdetCI() in plot.boxM()

