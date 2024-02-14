# keep rgl from popping up windows
Sys.setenv(RGL_USE_NULL = TRUE)


# revdep
#remotes::install_github("r-lib/revdepcheck")
#library(revdepcheck)
revdepcheck::revdep_check(num_workers = 4)

# get list of possibly misspelled words
wds <- spelling::spell_check_package()
cat(paste(wds[, "word"], collapse = "\n"))
# to add all words
update_wordlist()

library(devtools)

# prepare pkgdown site
build_readme()
pkgdown::build_site()

devtools::build()
devtools::build_vignettes()

devtools::check_win_devel()

# check reverse dependencies
devtools::revdep()
# [1] "candisc"      "effects"      "Guerry"       "HistData"     "ICSClust"     "latentnet"    "MorphoTools2" "mvinfluence"  "ordr"       

library(revdepcheck)
revdep_reset()
revdep_check()

# -> Results to cran-comments.md

# submit to cran
devtools::release()


# no longer need this
# devtools::build(args = c('--resave-data','--compact-vignettes=both'))
# 
# #devtools::build(args = c('--compact-vignettes=both'))
# 
# # then, test with win builder
# args = c('--resave-data','--compact-vignettes=both')
# devtools::check_win_devel(args=args)

# # submit to cran
# args = c('--resave-data','--compact-vignettes=both')
# #devtools::submit_cran(args=args)
# devtools::release(args=args)

# 
# # NB: building vignettes, then compacting
# devtools::build_vignettes()
# 
# tools::compactPDF("doc/HE-examples.pdf", gs_quality="ebook")
# # compacted ‘HE-examples.pdf’ from 765Kb to 415Kb
