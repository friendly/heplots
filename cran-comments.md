## Test environments
* local Windows 7 install, R 3.4.1
* win-builder R Under development (unstable) (2017-09-12 r73242), 
* R-Forge R version 3.4.1 Patched (2017-09-11 r73238)

## R CMD check results
There were no ERRORs or WARNINGS.

There was one NOTE, which I think is spurious, probably a bug in checking 'canonical' URLs

Found the following (possibly) invalid URLs:
  URL: http://journal.r-project.org/archive/2013-1/fox-friendly-weisberg.pdf
    From: man/heplot-package.Rd
          man/heplot.Rd
    Status: 200
    Message: OK
    R-project URL not in canonical form




## Comments
This is a minor release, adding a new data set and examples; released now in relation to a 
submitted paper that requires that data set. As well, the package has been migrated from
R-Forge to github.

## Version 1.3-4 (2017-09-14)

o Added Diabetes data, a nice example of heterogeneity of covariances


