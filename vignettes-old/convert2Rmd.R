# convert Rnw vignettes to Rmd

library(here)
# old *.Rnw -> *-knitr.Rnw
#knitr::Sweave2knitr(here("vignettes-old", "HE-examples.Rnw"))

source(here("vignettes-old", "latex2Rmd.R"))

latex2Rmd(input = here("vignettes-old", "HE-examples-knitr.Rnw"),
          output = here("vignettes-old", "HE-examples.Rmd"))

latex2Rmd(input = here("vignettes-old", "repeated.Rnw"),
          output = here("vignettes-old", "repeated.Rmd"))
