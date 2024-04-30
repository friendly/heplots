#' Find version of a package on CRAN
cran_version <- function(package) {
  avail <- utils::available.packages(repos = "https://cran.r-project.org/")
  avail <- avail[, c("Package", "Version")]
  which <- avail[, "Package"] == package
  avail[which, "Version"]
}


if(FALSE){
packageVersion("heplots")
cran_version("heplots")
}

# what about:
package <- "heplots"
available.packages(repos = "https://cran.r-project.org/")[package, "Version"]

# or:

PACKAGES <- tempfile(fileext = "rds")

pkgversion <- function(package) {
  # Get list of packages from CRAN if
  #
  # - don't have local copy or
  # - local copy more than 5 minutes old.
  #
  if (
    !file.exists(PACKAGES) || 
    difftime(Sys.time(), file.mtime(PACKAGES), unit = "mins") > 5
  ) {
    download.file(
      "cran.r-project.org/src/contrib/PACKAGES.rds",
      PACKAGES,
      quiet = FALSE
    )
  }
  # Read and convert to data frame.
  packages <- readRDS("PACKAGES.rds") |> data.frame()
  # Filter for specified package and return version.
  packages[packages$Package == package,]$Version
}

pkgversion("dplyr")
