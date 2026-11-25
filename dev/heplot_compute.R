# heplot_compute(): first-pass prototype (dev only, not in R/)
# See issues/ggHEplot.md, "The `ellipses` slot: symbolic, not points".
#
# DONE: ✔️ Separate the computation in heplot.mlm() from the drawing. Ellipses are stored
#       symbolically (center + full p x p scaled shape + df/factor/rank), not as boundary
#       points; points are produced by as.data.frame() for any pair of variables 11/25/2026
# TODO: 🚩 Decide: store shapes pre-scaled (now) or raw SSP + `scale`/`factor` separately
# TODO: 🚩 Decide: for repeated-measures designs, hypotheses are transformed by P[[iterm]] here;
#       heplot.mlm() does not do this (see dev/heplot_compute-test.R)
# TODO: 🚩 print()/summary() methods; ellipse.axes()/ellipse.box() methods for these objects
# TODO: 🚩 rank-1 shapes: return segment endpoints from as.data.frame()?

#' Compute (but do not draw) the ellipses for an HE plot
#'
#' @description
#' Does the computation part of [heplot()]: fits the MANOVA tests, and scales the
#' H and E matrices for the chosen `size`, but keeps them as full `p x p` shape
#' matrices for all the response variables. Points on the ellipses for any two
#' responses are made with `as.data.frame()`.
#'
#' @param mod An `mlm` object
#' @param terms,hypotheses,remove.intercept,type,idata,idesign,icontrasts,imatrix,iterm,manova,size,alpha
#'        As in [heplot()]
#' @param level Default coverage level, used when points are made; can be
#'        changed then without recomputing
#' @return An object of class `"heplot_compute"`: a list with components
#'   * `ellipses`: named list, one per H term / hypothesis, then `Error`; each
#'     a list with `shape` (scaled `p x p`), `type` ("H"/"E"), `source`
#'     ("term", "hypothesis", "error"), `df`, `factor` (size scaling divided
#'     out; 1 for `size = "effect"`), `rank` (in the full response space)
#'   * `center`: grand mean on all `p` responses
#'   * `means`: data frame of factor-level means on all `p` responses
#'   * `response.names`, `p`, `dfe`, `size`, `level`, `alpha`, `iterm`

heplot_compute <- function(mod, ...) UseMethod("heplot_compute")

heplot_compute.mlm <- function(
    mod,
    terms,
    hypotheses,
    remove.intercept = TRUE,
    type = c("II", "III", "2", "3"),
    idata = NULL,
    idesign = NULL,
    icontrasts = c("contr.sum", "contr.poly"),
    imatrix = NULL,
    iterm = NULL,
    manova,
    size = c("evidence", "effect.size", "significance"),
    level = 0.68,
    alpha = 0.05,
    ...) {

  # 1. MANOVA tests; same logic as heplot.mlm()
  type <- match.arg(type)
  size <- match.arg(size)
  data <- model.frame(mod)
  repeated <- !(is.null(idata) && is.null(imatrix))

  if (missing(manova)) {
    manova <- if (is.null(imatrix))
      car::Anova(mod, type = type, idata = idata, idesign = idesign, icontrasts = icontrasts)
    else
      car::Anova(mod, type = type, idata = idata, idesign = idesign, icontrasts = icontrasts,
                 imatrix = imatrix)
  }

  if (!repeated) {
    Y <- model.response(data)
    SSPE <- manova$SSPE
    P <- NULL
  } else {
    if (is.null(iterm)) stop("Must specify a within-S `iterm` for repeated measures designs")
    if (is.null(names(manova$P))) names(manova$P) <- names(manova$SSPE)
    P <- manova$P[[iterm]]
    Y <- model.response(data) %*% P
    SSPE <- manova$SSPE[[iterm]]
  }
  response.names <- if (!is.null(rownames(SSPE))) rownames(SSPE) else paste0("V.", seq_len(nrow(SSPE)))
  colnames(Y) <- response.names
  p <- length(response.names)

  # 2. Which terms
  if (missing(terms) || (is.logical(terms) && terms)) {
    terms <- manova$terms
    if (!is.null(iterm)) terms <- terms[grep(iterm, terms)]
    if (remove.intercept) terms <- terms[terms != "(Intercept)"]
  }
  if (is.logical(terms)) terms <- character(0)     # terms = FALSE
  if (missing(hypotheses)) hypotheses <- list()
  if (length(terms) + length(hypotheses) == 0) stop("Nothing to plot: no terms or hypotheses.")

  # 3. Scaled shape matrices, all p responses
  dfe <- manova$error.df
  scale <- 1 / dfe
  size_factor <- function(dfh) {
    if (size %in% c("evidence", "significance")) lambda.crit(alpha, p, dfh, dfe) else 1
  }
  make_ell <- function(SSP, df, type, source) {
    fac <- if (type == "H") size_factor(df) else 1
    shape <- SSP * scale / fac
    dimnames(shape) <- list(response.names, response.names)
    list(shape = shape, type = type, source = source, df = unname(df),
         factor = unname(fac), rank = qr(shape)$rank)
  }

  ok <- vapply(terms, function(t) nrow(manova$SSP[[t]]) == p, logical(1))
  if (any(!ok)) {
    warning(glue::glue("Skipping H term(s) {paste(terms[!ok], collapse = ', ')}: ",
                       "SSP matrix is not {p} x {p}"))
    terms <- terms[ok]
  }
  H_terms <- Map(function(t) make_ell(manova$SSP[[t]], manova$df[t], "H", "term"), terms)
  names(H_terms) <- terms

  hyp_names <- names(hypotheses)
  if (is.null(hyp_names)) hyp_names <- rep("", length(hypotheses))
  hyp_names <- ifelse(hyp_names == "",
                      vapply(hypotheses, paste, character(1), collapse = ", "),
                      hyp_names)
  H_hyps <- lapply(hypotheses, function(h) {
    lh <- if (is.null(P)) car::linearHypothesis(mod, h)
          else car::linearHypothesis(mod, h, P = P)
    make_ell(lh$SSPH, lh$df, "H", "hypothesis")
  })
  names(H_hyps) <- hyp_names

  E <- list(Error = make_ell(SSPE, dfe, "E", "error"))

  # 4. Center and factor-level means
  center <- colMeans(Y)
  factors <- data[, vapply(data, is.factor, logical(1)), drop = FALSE]
  means <- if (ncol(factors) == 0) NULL else
    do.call(rbind, Map(function(fac, name) {
      m <- aggregate(Y, list(level = fac), mean)
      data.frame(factor = name, m)
    }, factors, names(factors)))
  rownames(means) <- NULL

  # 5. Return
  structure(list(ellipses = c(H_terms, H_hyps, E),
                 center = center,
                 means = means,
                 response.names = response.names,
                 p = p, dfe = dfe, size = size, level = level, alpha = alpha,
                 iterm = iterm),
            class = "heplot_compute")
}

# points on an ellipse; same algorithm as ell() in heplot.mlm()
ellipse_points <- function(center, shape, radius, segments = 60) {
  angles <- (0:segments) * 2 * pi / segments
  circle <- radius * cbind(cos(angles), sin(angles))
  Q <- suppressWarnings(chol(shape, pivot = TRUE))
  ord <- order(attr(Q, "pivot"))
  t(c(center) + t(circle %*% Q[, ord]))
}

# resolve `variables` (names or numbers) to indices
he_variables <- function(x, variables) {
  if (is.character(variables)) {
    idx <- match(variables, x$response.names)
    if (anyNA(idx)) stop(glue::glue(
      "{paste(variables[is.na(idx)], collapse = ', ')} not among response variables: ",
      "{paste(x$response.names, collapse = ', ')}"))
    variables <- idx
  }
  if (any(variables > x$p)) stop(glue::glue("There are only {x$p} response variables."))
  variables
}

#' Points on the ellipses of a `"heplot_compute"` object for two responses
#' @param variables two responses, by name or number
#' @param segments number of line segments for each ellipse
#' @param level coverage level; default, the one saved in `x`
#' @return long data frame: `ellipse`, `type`, `source`, `rank` (in this 2-D view),
#'         `x`, `y`; the responses used are in attribute `"variables"`
as.data.frame.heplot_compute <- function(x, row.names = NULL, optional = FALSE,
                                         variables = 1:2, segments = 60,
                                         level = x$level, ...) {
  v <- he_variables(x, variables)
  if (length(v) != 2) stop(glue::glue("`variables` must give 2 responses, got {length(v)}"))
  radius <- sqrt(2 * qf(level, 2, x$dfe))
  center <- x$center[v]
  pieces <- Map(function(e, name) {
    S <- e$shape[v, v]
    pts <- ellipse_points(center, S, radius, segments)
    data.frame(ellipse = name, type = e$type, source = e$source,
               rank = qr(S)$rank, x = pts[, 1], y = pts[, 2])
  }, x$ellipses, names(x$ellipses))
  res <- do.call(rbind, unname(pieces))
  attr(res, "variables") <- x$response.names[v]
  res
}

print.heplot_compute <- function(x, ...) {
  cat(glue::glue("HE plot computation: {x$p} responses ({paste(x$response.names, collapse = ', ')}), ",
                 "dfe = {x$dfe}, size = \"{x$size}\""), "\n")
  info <- data.frame(
    type   = vapply(x$ellipses, `[[`, "", "type"),
    source = vapply(x$ellipses, `[[`, "", "source"),
    df     = vapply(x$ellipses, `[[`, 0, "df"),
    factor = round(vapply(x$ellipses, `[[`, 0, "factor"), 3),
    rank   = vapply(x$ellipses, `[[`, 0, "rank"))
  print(info)
  invisible(x)
}
