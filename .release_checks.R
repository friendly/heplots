# CRAN release checklist for heplots, organized as discrete, re-runnable
# steps instead of one long linear script (see .build-steps.R for the
# original). Source this file to define the functions below, then either
# call release_run_all() for the full automatable sequence, or run
# individual release_*() functions to retry just the step that failed /
# needs re-checking.
#
# DONE: 2026-08-11 reorganized from .build-steps.R's unstructured script of
#       ad hoc commands into named steps; dropped dead commented-out code
#       (old --resave-data/--compact-vignettes args, marked "no longer
#       need this"); added release_check() (local `R CMD check` via
#       devtools::check()) -- this was previously missing entirely, even
#       though check_win_devel() and revdep checks were both present
# TODO: 🚩 cran-comments.md content and the DESCRIPTION Version/Date bump
#       are still manual -- release_run_all() just reminds you at the end
# TODO: 🚩 devtools::release() is deliberately never called automatically
#       -- it's interactive (a series of y/n prompts) and is the actual
#       point of submission to CRAN

library(devtools)

# keep rgl from popping up windows during examples/vignettes
Sys.setenv(RGL_USE_NULL = TRUE)

# ---- 1. Pre-flight: versions & NEWS ----------------------------------------

#' Cross-check DESCRIPTION's Version/Date against NEWS.md and CRAN
release_preflight <- function() {
  desc <- read.dcf("DESCRIPTION", fields = c("Version", "Date"))
  version <- desc[1, "Version"]
  date <- desc[1, "Date"]
  news_top <- readLines("NEWS.md", n = 1)

  cat(glue::glue("DESCRIPTION: Version {version}, Date {date}\n"))
  cat(glue::glue("NEWS.md top line: {news_top}\n"))

  if (!grepl(version, news_top, fixed = TRUE)) {
    warning(glue::glue(
      "NEWS.md's first line doesn't mention version {version} -- did you ",
      "forget to add a NEWS entry, or to bump Version/Date in DESCRIPTION?"
    ))
  }

  cran_version <- tryCatch({
    avail <- utils::available.packages(repos = "https://cran.r-project.org/")
    unname(avail["heplots", "Version"])
  }, error = function(e) NA)
  cat(glue::glue("Version currently on CRAN: {cran_version}\n"))

  invisible(list(version = version, date = date, cran_version = cran_version))
}

# ---- 2. Documentation & spelling -------------------------------------------

release_document <- function() {
  devtools::document()
}

#' @param update Replace inst/WORDLIST wholesale via
#'        spelling::update_wordlist()? Default FALSE, and deliberately
#'        hard to trigger by accident -- see the warning below.
#'
#' Careful: spelling::update_wordlist() doesn't add *selected* words, it
#' replaces the ENTIRE wordlist with whatever spell_check_package() finds
#' at that moment. Its confirmation prompt only fires when interactive();
#' in a non-interactive Rscript run (e.g. release_run_all() in the
#' background) that check is silently skipped, so it would accept every
#' flagged word -- real typos included -- with no confirmation at all.
#' Use release_spelling_add() instead to add specific words you've
#' actually reviewed.
release_spelling <- function(update = FALSE) {
  wds <- spelling::spell_check_package()
  print(wds)
  if (update) {
    if (!interactive()) {
      stop(glue::glue(
        "release_spelling(update = TRUE) calls spelling::update_wordlist(), ",
        "which replaces the whole wordlist non-interactively -- refusing ",
        "outside an interactive session. Use release_spelling_add() to add ",
        "specific words instead."
      ))
    }
    spelling::update_wordlist()
  }
  invisible(wds)
}

#' Add specific words to inst/WORDLIST -- selective and additive, unlike
#' spelling::update_wordlist() (see release_spelling() above). Existing
#' entries are kept; `words` is merged in, deduplicated, and re-sorted.
#'
#' @param words Character vector of words to accept, e.g. copied from
#'        release_spelling()'s printed output after reviewing which
#'        flagged words are genuine false positives (proper nouns,
#'        technical terms) rather than actual typos.
release_spelling_add <- function(words) {
  wordfile <- "inst/WORDLIST"
  old_words <- readLines(wordfile)
  new_words <- sort(union(old_words, words), method = "radix")
  added <- setdiff(new_words, old_words)

  if (length(added) == 0) {
    cat("No new words to add -- already in the wordlist.\n")
    return(invisible(old_words))
  }

  writeLines(enc2utf8(new_words), wordfile, useBytes = TRUE)
  cat(glue::glue(
    "Added {length(added)} word(s) to {wordfile}: {paste(added, collapse = ', ')}\n"
  ))
  invisible(new_words)
}

#' @param update Rewrite URLs found to have moved? Default FALSE, same
#'        reasoning as release_spelling().
release_urls <- function(update = FALSE) {
  urlchecker::url_check()
  if (update) urlchecker::url_update()
}
# one-time setup if urlchecker isn't installed:
# install.packages('urlchecker', repos = 'https://r-lib.r-universe.dev')

# ---- 3. Site & README -------------------------------------------------------

release_site <- function() {
  devtools::build_readme()
  pkgdown::build_site(lazy = TRUE)
}

# ---- 4. Build & local check -------------------------------------------------

release_build <- function() {
  devtools::build()
  # to test vignettes, this builds them into doc/ -- remove that directory
  # afterwards if you don't want it left around
  devtools::build_vignettes()
  devtools::build_manual()
}

#' The actual `R CMD check --as-cran` run, locally
release_check <- function() {
  devtools::check()
}

# ---- 5. Remote checks --------------------------------------------------------

release_check_win <- function() {
  devtools::check_win_devel()
}

# ---- 6. Reverse dependencies -------------------------------------------------

release_revdep <- function(num_workers = 4) {
  revdepcheck::revdep_reset()
  revdepcheck::revdep_check(num_workers = num_workers, bioc = FALSE)
  print(devtools::revdep())
}
# one-time setup if revdepcheck isn't installed:
# remotes::install_github("r-lib/revdepcheck")

# ---- 7. Orchestration ---------------------------------------------------------

#' Run one release step, catching (not swallowing) any error so the rest
#' of the sequence still runs; failures are collected and reported at the
#' end by release_run_all() instead of halting things partway through.
run_step <- function(name, step) {
  cat(glue::glue("\n=== {name} ===\n"))
  tryCatch({
    step()
    NULL
  }, error = function(e) {
    msg <- conditionMessage(e)
    cat(glue::glue("✖ {name} failed: {msg}\n"))
    glue::glue("{name}: {msg}")
  })
}

#' Run every automatable release-check step in sequence
#'
#' Does not call release_check_win() or release_revdep() by default --
#' both are slow (win-builder is an external upload; revdep checks every
#' reverse dependency twice) and worth running deliberately rather than as
#' part of a routine re-run. Set `full = TRUE` to include them.
#'
#' Each step runs even if an earlier one fails (e.g. release_urls()
#' finding a dead link) -- failures are collected and reported together
#' at the end instead of halting the sequence.
release_run_all <- function(full = FALSE, num_workers = 4) {
  steps <- list(
    release_preflight = release_preflight,
    release_document  = release_document,
    release_spelling  = release_spelling,
    release_urls      = release_urls,
    release_site      = release_site,
    release_build     = release_build,
    release_check     = release_check
  )
  if (full) {
    steps$release_check_win <- release_check_win
    steps$release_revdep <- function() release_revdep(num_workers = num_workers)
  }

  failures <- Map(run_step, names(steps), steps)
  failures <- Filter(Negate(is.null), failures)

  cat("\nAutomated steps done.\n")
  if (length(failures) > 0) {
    cat(glue::glue("\n{length(failures)} step(s) failed:\n"))
    cat(paste(" -", unlist(failures)), sep = "\n")
  } else {
    cat("All steps completed without error.\n")
  }

  cat("\nRemaining manual steps:\n")
  cat("  1. Review spelling/URL/check output above; fix anything flagged\n")
  if (!full) {
    cat("  2. release_check_win() and release_revdep() (slow; not run by default)\n")
  }
  cat("  3. Update cran-comments.md with the check/revdep summary\n")
  cat("  4. Confirm Version/Date in DESCRIPTION and NEWS.md entry are correct\n")
  cat("  5. devtools::release()\n")

  invisible(failures)
}
