# Build and publish the heplots cheatsheet
#
#   source("dev/cheatsheet/build.R")    # from the package root
#
# 1. regenerate thumbnails (dev/cheatsheet-figs.R), using the *source* version of heplots
# 2. render dev/cheatsheet/heplots-cheatsheet.qmd -> PDF (Quarto + Typst)
# 3. publish:
#    - pkgdown/assets/heplots-cheatsheet.pdf  -> https://friendly.github.io/heplots/heplots-cheatsheet.pdf
#    - man/figures/cheatsheet-thumbs.png      -> thumbnail of both pages, used in README
#
# Close the PDF in any viewer first: Windows locks open files and the render then fails.

# TODO: 🚩 Also offer it to rstudio/cheatsheets (contributed cheatsheets) once stable

devtools::load_all(here::here(), quiet = TRUE)

csdir <- here::here("dev", "cheatsheet")

# ---- 1. thumbnails --------------------------------------------------------
source(here::here("dev", "cheatsheet-figs.R"))

# ---- 2. render ------------------------------------------------------------
quarto::quarto_render(file.path(csdir, "heplots-cheatsheet.qmd"), quiet = TRUE)
pdf <- file.path(csdir, "heplots-cheatsheet.pdf")
stopifnot(file.exists(pdf))

# ---- 3a. publish the PDF via pkgdown assets (copied to the site root) ------
file.copy(pdf, here::here("pkgdown", "assets", "heplots-cheatsheet.pdf"), overwrite = TRUE)

# ---- 3b. README thumbnail: both pages side by side ------------------------
tmp <- tempfile("page-")
status <- system2("quarto",
                  c("typst", "compile", shQuote(file.path(csdir, "heplots-cheatsheet.typ")),
                    shQuote(paste0(tmp, "-{p}.png")), "--ppi", "45"))
if (status != 0) stop(glue::glue("typst PNG export failed with status {status}"))

pages <- lapply(paste0(tmp, "-", 1:2, ".png"), png::readPNG)
h <- dim(pages[[1]])[1]
w <- dim(pages[[1]])[2]
gap <- 12
png(here::here("man", "figures", "cheatsheet-thumbs.png"),
    width = 2 * w + gap, height = h)
op <- par(mar = c(0, 0, 0, 0))
plot.new()
plot.window(xlim = c(0, 2 * w + gap), ylim = c(0, h), xaxs = "i", yaxs = "i")
rasterImage(pages[[1]], 0, 0, w, h)
rasterImage(pages[[2]], w + gap, 0, 2 * w + gap, h)
rect(c(0, w + gap), 0, c(w, 2 * w + gap), h, border = "gray60")
par(op)
dev.off()

message(glue::glue("Published {basename(pdf)} and cheatsheet-thumbs.png ({2 * w + gap} x {h} px)"))
