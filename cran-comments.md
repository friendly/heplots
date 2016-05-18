## Test environments
* local Windows 7 install, R 3.1.2
* win-builder (R development (unstable) (2016-05-17 r70629), 3.2.4 Revised (2016-03-16 r70336))

## R CMD check results
There were no ERRORs or WARNINGs.  One spurious NOTE (since I mention the candisc package in DESCRIPTION)
Possibly mis-spelled words in DESCRIPTION:
  candisc (19:77)

## Comments
This is a major release, with new functions for equality of covariance matrices, covariance ellipses and
chi-square QQ plots, classical and robustified.

# heplots 1.2-0

o covEllipses() extended to more than two variables, giving a scatterplot matrix plot
o plot.boxM() now can plot other measures of the eigenvalues of the covariance matrices,
  useful for understanding the properties of the test.
o added bartlettTests() for a collection of univariate Bartlett tests 
o added leveneTests() for a collection of univariate Levene tests 
o added NeuroCog data, a simple one-way MANOVA [Thx: Leah Hartman]
o label.ellipse() now uses a much more flexible `label.pos` argument for positioning the
  text labels used in heplot() and friends.
o in coefplot.mlm(), now pass `label.pos` to label.ellipse()
o added Mahalanobis() for classical and robust squared distances; handles missing data gracefully.
o added SocialCog data [Thx: Leah Hartman]
o added cqplot() as a plot method for an mlm and for multivariate data

