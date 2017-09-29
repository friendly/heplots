## Test environments
* local Windows 7 install, R 3.4.1
* win-builder R Under development (unstable) (2017-09-12 r73242), 3.4.1 (2017-06-30)
* R-Forge R version 3.4.1 Patched (2017-09-11 r73238)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.


## Comments
This is a minor release, adding a new data set and examples; released now in relation to a 
submitted paper that requires that data set. As well, the package has been migrated from
R-Forge to github.

## Version 1.3-4 (2017-09-14)

o Added Diabetes data, a nice example of heterogeneity of covariances


### Notes on building

The standard R Studio / devtools build does not compress vignettes. To avoid the warning

    'gs+qpdf' made some significant size reductions

it was necessary to build manually, using

    Sys.setenv(R_GSCMD="C:/Program Files/gs/gs9.21/bin/gswin64c.exe")
    devtools::build(args = c('--resave-data','--compact-vignettes="gs+qpdf"'))

(Had to upgrade to gs 9.21, 64 bit) This gives:

    * compacting vignettes and other PDF files
        compacted 'HE-examples.pdf' from 765Kb to 397Kb
        compacted 'repeated.pdf' from 582Kb to 340Kb   

The resulting source file `C:/R/projects/heplots_1.3-4.tar.gz` could then be submitted to
Win Builder and CRAN.  Downside: has to be done manually.  Or:

    args = c('--resave-data','--compact-vignettes="gs+qpdf"')
    devtools::build_win(args=args)
    devtools::submit_cran(args=args)
