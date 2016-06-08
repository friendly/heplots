## Test environments
* local Windows 7 install, R 3.1.2
* win-builder (R version 3.3.0 (2016-05-03), 3.2.4), R-Forge R version 3.3.0 Patched (2016-06-02 r70700)

## R CMD check results
There were no ERRORs or WARNINGs.  

## Comments
This is a major release, with several new functions and numerous enhancements

Version 1.3-0 (2016-06-03)

o In cqplot, pch, col, and cex can now be vectors
o Bump version, prepare for release

Version 1.2-1 (2016-05-19)

o in coefplot.mlm(), now pass `label.pos` to label.ellipse()
o added Mahalanobis() for classical and robust squared distances; handles missing data gracefully.
o added SocialCog data [Thx: Leah Hartman]
o added cqplot() as a plot method for an mlm and for multivariate data
