# keep rgl from popping up windows
Sys.setenv(RGL_USE_NULL = TRUE)

# Check URL are correct
# install.packages('urlchecker', repos = 'https://r-lib.r-universe.dev')
urlchecker::url_check()
urlchecker::url_update()

# revdep
#remotes::install_github("r-lib/revdepcheck")
#library(revdepcheck)
revdepcheck::revdep_reset()
revdepcheck::revdep_check(num_workers = 4, bioc=FALSE)

# get list of possibly misspelled words
wds <- spelling::spell_check_package() |> print()
cat(paste(wds[, "word"], collapse = "\n"))
# to add all words
spelling::update_wordlist()

library(devtools)

# prepare pkgdown site
devtools::build_readme()
pkgdown::build_site(lazy = TRUE)

devtools::build()
# to test vignettes, built them, but then have to remove `doc/` directory
devtools::build_vignettes()
# create the manual
devtools::build_manual()

devtools::check_win_devel()

# check reverse dependencies
devtools::revdep()
# [1] "candisc"      "effects"      "Guerry"       "HistData"     "ICSClust"     "latentnet"   
# [7] "MorphoTools2" "mvinfluence"  "ordr"

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
