## Test environments
* local Windows 7 install, R 3.6.3
* local Windows 10 install, R 4.0.2
* win-builder R version 4.1.1 (2021-08-10)

## R CMD check results
There were no ERRORs or WARNINGS or NOTES.

## Reverse dependencies checks

> devtools::revdep()
[1] "candisc"     "effects"     "HistData"    "latentnet"   "mvinfluence"

> revdep_check(num_workers = 4)
*Wow, no problems at all. :)*

## Comments
This is a minor release, fixing a potential problem with URL links to JSS articles, now converted to DOIs.




