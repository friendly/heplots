# Multivariate Box-Cox transformations for an mlm: profile likelihood plots, a refit, and
# a Box's M criterion. Built on car::powerTransform(), which does the estimation.
# Prototypes, design notes and examples: dev/box-cox.md, dev/box-cox-functions.R,
# dev/box-cox-demo.R, dev/box-cox-diabetes.R, dev/box-cox-tradeoff.R
#
# DONE: ✔️ Moved from dev/box-cox-functions.R to R/: bcProfile(), plot and print methods,
#       bcRefit(), bcBoxM() 11/26/2026
# DONE: ✔️ Colours are arguments; lambda = 1 is red in 1-D, darkorange in the busier 2-D plot;
#       cex.lab = 1.3 by default 11/26/2026
# DONE: ✔️ All documented on one page, `?bcProfile` (MF); seealso relates them to car's
#       univariate tools, the homogeneity tests, cqplot() and robmlm() 11/26/2026
# TODO: 🚩 pairs() method: 2-D profiles below the diagonal, 1-D on the diagonal
# TODO: 🚩 summary table per variable: normality MLE and interval, Box's M minimum, agree?
# TODO: 🚩 Other families (bcnPower for zeros / negative values, yjPower); bcPower only now

#' Multivariate Box-Cox Transformations for Multivariate Linear Models
#'
#' @description
#' [car::powerTransform()] estimates Box-Cox powers \eqn{\lambda = (\lambda_1, \dots,
#' \lambda_p)}{lambda = (lambda_1, ..., lambda_p)} that make the residuals of a
#' multivariate linear model as close to multivariate normal as possible. These
#' functions add the graphics and the workflow around it:
#'
#' * `bcProfile()` computes the profile log-likelihood for one or two of the
#'   \eqn{\lambda}{lambda}s on a grid, and its `plot()` method draws it: a curve
#'   for one variable, nested likelihood regions with the Wald confidence ellipse
#'   for two. Optionally, Box's M statistic for the homogeneity of the group
#'   covariance matrices ([boxM()]) is computed at the same points, so the plot
#'   shows whether the powers that make the residuals most normal also make the
#'   covariance matrices most alike.
#' * `bcRefit()` refits the model with Box-Cox transformed responses, so it can
#'   be compared with the original using [car::Anova()], [heplot()], [cqplot()],
#'   [boxM()] and so on.
#' * `bcBoxM()` finds the powers for which the covariance matrices of the
#'   transformed responses are most alike across groups, by minimizing Box's M.
#'   For a MANOVA, homogeneity of the covariance matrices is often a more
#'   important assumption than normality.
#'
#' @details
#' **The log-likelihood.** For multivariate normality (Andrews, Gnanadesikan &
#' Warner, 1971) it is
#' \deqn{\ell(\lambda) = -\frac{n}{2} \log |\hat\Sigma_\lambda| +
#'   \sum_j (\lambda_j - 1) \sum_i \log y_{ij}}{l(lambda) = -(n/2) log |S(lambda)| +
#'   sum_j (lambda_j - 1) sum_i log y_ij}
#' where \eqn{\hat\Sigma_\lambda}{S(lambda)} is the ML covariance matrix of the
#' residuals of the model fitted to the transformed responses. Its maximum is the
#' estimate from [car::powerTransform()], and differences in it reproduce the
#' likelihood ratio tests of [car::testTransform()].
#'
#' **Profile or slice.** With `type = "profile"`, at each grid point the
#' log-likelihood is maximized over the other \eqn{\lambda}{lambda}s, giving a
#' true profile, so that \eqn{2(\ell_{max} - \ell)}{2 (lmax - l)} can be referred
#' to a \eqn{\chi^2}{chi-square} distribution with 1 or 2 df for a confidence
#' interval or region. With `type = "slice"`, the other \eqn{\lambda}{lambda}s are
#' held at their estimates. This is much faster, and close to the profile when the
#' estimates are nearly uncorrelated (see `cov2cor(object$invHess)`), but it is
#' not a proper profile, and can mislead when they are correlated.
#'
#' **Box's M.** It is invariant to rescaling each variable, so no Jacobian term
#' is needed when it is computed for transformed responses. In `bcProfile()` it is
#' computed at the same full \eqn{\lambda}{lambda} vector as the log-likelihood at
#' each grid point. `bcBoxM()` minimizes it with [stats::optim()] (Nelder-Mead).
#' Use that with care: when M changes little with one of the powers, the optimizer
#' can wander to extreme values of it. Plotting M against each power, with
#' `bcProfile(..., group = )`, shows where this happens. This is a multivariate
#' analogue of choosing a transformation from a spread-level plot
#' ([car::spreadLevelPlot()]).
#'
#' **Refitting.** `bcRefit()` keeps the Box-Cox scaling
#' \eqn{(y^\lambda - 1)/\lambda}{(y^lambda - 1) / lambda} ([car::bcPower()]), so
#' the direction of an effect is preserved when \eqn{\lambda < 0}{lambda < 0}. The
#' transformed responses get syntactic names: a power of 1 keeps the name, 0 gives
#' `logCK`, and others `CK_m0.5` (for -0.5) or `Hpx_2`. The model is refitted with
#' [stats::update()] using the data frame named in the original call, with these
#' new columns added, so the call must have a `data` argument.
#'
#' Only the `"bcPower"` family is supported, so the responses must be positive.
#'
#' @param object A `"powerTransform"` object from [car::powerTransform()] with
#'        `family = "bcPower"`, or an `"mlm"` object, for which
#'        `car::powerTransform(object)` is called first
#' @param variables One or two responses, by name or number. One gives a 1-D
#'        profile, two a 2-D profile
#' @param type `"profile"` (default) maximizes over the other powers at each
#'        grid point; `"slice"` holds them at their estimates
#' @param range Half-width of the grid around each estimate, in Wald standard
#'        errors
#' @param extend_range If `TRUE`, widen the grid so it also includes `ref`, to
#'        show how far "no transformation" is from the estimate
#' @param ref Reference powers, recycled to `length(variables)`. The default, 1,
#'        is no transformation. Its likelihood ratio test is computed, and it is
#'        drawn when it is inside the grid
#' @param n Number of grid points in each dimension. The default is 101 for a
#'        1-D profile and 61 for a 2-D profile. A 2-D profile needs one
#'        optimization per grid point, so it can take several seconds
#' @param group A factor giving the groups. For `bcProfile()` it is optional: if
#'        given, Box's M statistic for the transformed responses by `group` is
#'        also computed at each grid point
#' @param ... Arguments passed to the `"powerTransform"` method (for the
#'        `"mlm"` method), or to [plot()]
#'
#' @return
#' `bcProfile()` returns an object of class `"bcProfile"`, a list with components
#'   * `axes`: the grid values for each variable
#'   * `grid`: a data frame of all grid points
#'   * `loglik`, `deviance`: the log-likelihood at each grid point, and
#'     \eqn{2(\ell_{max} - \ell)}{2 (lmax - l)}
#'   * `full_lambda`: the full vector of powers at which each log-likelihood
#'     was attained
#'   * `M`: Box's M at each grid point, or `NULL`
#'   * `variables`, `type`, `lambda` (estimates), `roundlam` (rounded powers)
#'   * `ref`: a list with the reference powers, their deviance and p-value
#'   * `vcov`: the Wald covariance matrix for these powers: marginal
#'     (`invHess`) for a profile, conditional for a slice
#'
#' The `plot()` method invisibly returns a list with the likelihood ratio
#' `interval` (1-D) and `M_min`, the grid point where Box's M is smallest.
#'
#' `bcRefit()` returns the refitted `"mlm"`, with the powers in attribute
#' `"lambda"`.
#'
#' `bcBoxM()` returns a list with components `lambda` (the powers that minimize
#' M), `M` (the minimum), `M_start` (M at `start`), `convergence` (from
#' [stats::optim()]), and `M_of`, a function giving M for any vector of powers.
#'
#' @references
#' Andrews, D. F., Gnanadesikan, R., & Warner, J. L. (1971). Transformations of
#' multivariate data. *Biometrics*, 27, 825--840.
#'
#' Box, G. E. P., & Cox, D. R. (1964). An analysis of transformations.
#' *Journal of the Royal Statistical Society, Series B*, 26, 211--252.
#'
#' Rencher, A. C., & Christensen, W. F. (2012). *Methods of Multivariate
#' Analysis*, 3rd ed. Hoboken, NJ: Wiley. Section 4.5.
#'
#' @seealso
#' Estimation and tests: [car::powerTransform()], [car::testTransform()];
#' the transformation itself: [car::bcPower()].
#'
#' Univariate versions: [car::boxCox()], [MASS::boxcox()] (profile likelihood for
#' one response); [car::symbox()]; [car::spreadLevelPlot()] (choosing a power to
#' stabilize spread).
#'
#' Checking the assumptions before and after: [cqplot()] (multivariate normality
#' of residuals), [boxM()], [plot.boxM()], [covEllipses()] (homogeneity of
#' covariance matrices), [bartlettTests()], [leveneTests()] (univariate
#' homogeneity of variance).
#'
#' An alternative for heavy tails and outliers, rather than skewness:
#' [robmlm()].
#'
#' Seeing the effects in the refitted model: [heplot()], [pairs.mlm()].
#'
#' @concept transformations
#'
#' @examples
#' data(Dystrophy)
#' dmd.mod <- lm(cbind(CK, Hpx, PK, LD) ~ group + age + month, data = Dystrophy)
#' dmd.pt <- car::powerTransform(dmd.mod)
#' summary(dmd.pt)
#'
#' # 1-D profiles, extended to show lambda = 1, with Box's M on the right axis
#' op <- par(mfrow = c(2, 2), mar = c(4, 4, 4, 4))
#' for (v in c("CK", "Hpx", "PK", "LD")) {
#'   prof <- bcProfile(dmd.pt, v, extend_range = TRUE, group = Dystrophy$group)
#'   plot(prof, main = v)
#' }
#' par(op)
#' prof
#'
#' \donttest{
#' # 2-D profile for a pair: likelihood regions and the Wald ellipse
#' prof2 <- bcProfile(dmd.pt, c("CK", "Hpx"))
#' plot(prof2)
#'
#' # extended to (1, 1), with contours of Box's M
#' prof2x <- bcProfile(dmd.pt, c("CK", "Hpx"), extend_range = TRUE, n = 81,
#'                     group = Dystrophy$group)
#' plot(prof2x)
#' }
#'
#' # Refit with the rounded powers (-0.5, 2, 0, 0)
#' dmd.bc <- bcRefit(dmd.mod, dmd.pt)
#' colnames(coef(dmd.bc))
#'
#' # residuals before and after
#' op <- par(mfrow = c(1, 2))
#' cqplot(dmd.mod, main = "Raw")
#' cqplot(dmd.bc, main = "Box-Cox")
#' par(op)
#'
#' # the transformation also makes the covariance matrices more alike
#' boxM(model.response(model.frame(dmd.mod)), Dystrophy$group)
#' boxM(model.response(model.frame(dmd.bc)), Dystrophy$group)
#'
#' # Powers that minimize Box's M, vs those for multivariate normality
#' data(Diabetes)
#' Y <- Diabetes[, c("glufast", "glutest", "instest", "sspg")]
#' bm <- bcBoxM(Y, Diabetes$group)
#' round(bm$lambda, 2)
#' c(M_untransformed = bm$M_start, M_min = bm$M)
#' round(car::powerTransform(lm(as.matrix(Y) ~ group, data = Diabetes))$lambda, 2)
#' @export
bcProfile <- function(object, ...) UseMethod("bcProfile")

#' @rdname bcProfile
#' @exportS3Method bcProfile mlm
bcProfile.mlm <- function(object, ...) {
  bcProfile(car::powerTransform(object, family = "bcPower"), ...)
}

#' @rdname bcProfile
#' @exportS3Method bcProfile powerTransform
#' @importFrom stats optim pchisq
bcProfile.powerTransform <- function(object,
                                     variables = 1,
                                     type = c("profile", "slice"),
                                     range = 3.5,
                                     extend_range = FALSE,
                                     ref = 1,
                                     n = if (length(variables) == 1) 101 else 61,
                                     group = NULL,
                                     ...) {
  # 1. Input validation
  type <- match.arg(type)
  pt <- object
  if (!identical(pt$family, "bcPower"))
    stop(glue::glue("Only the bcPower family is supported, not {pt$family}"))
  if (!is.null(pt$weights) && any(pt$weights != 1))
    warning("Case weights in the powerTransform object are ignored")
  v <- bc_index(pt, variables)
  k <- length(v)
  if (!k %in% 1:2) stop(glue::glue("`variables` must give 1 or 2 responses, got {k}"))
  ref <- rep_len(ref, k)

  # 2. The grid
  lam <- pt$lambda
  se <- sqrt(diag(pt$invHess))
  axes <- Map(function(j, r) {
    lim <- lam[j] + c(-1, 1) * range * se[j]
    if (extend_range) {
      lim <- range(lim, r)
      lim <- lim + c(-1, 1) * 0.05 * diff(lim)      # a little room beyond `ref`
    }
    seq(lim[1], lim[2], length.out = n)
  }, v, ref)
  names(axes) <- colnames(pt$y)[v]
  grid <- expand.grid(axes, KEEP.OUT.ATTRS = FALSE)
  others <- setdiff(seq_along(lam), v)

  # 3. Log-likelihood with lambda[v] fixed; for a profile, maximize over the other
  #    lambdas, starting from the previous grid point's optimum (warm start). Returns
  #    the log-likelihood and the full lambda vector at which it was attained.
  start <- lam[others]
  ll_at <- function(fixed, warm = TRUE) {
    full <- lam
    full[v] <- fixed
    if (type == "slice" || length(others) == 0) return(c(bc_loglik(full, pt), full))
    f <- function(free) { full[others] <- free; -bc_loglik(full, pt) }
    opt <- optim(if (warm) start else lam[others], f, method = "BFGS")
    if (warm) start <<- opt$par
    full[others] <- opt$par
    c(-opt$value, full)
  }
  res <- t(apply(as.matrix(grid), 1, ll_at))
  loglik <- res[, 1]
  full_lambda <- res[, -1, drop = FALSE]
  colnames(full_lambda) <- names(lam)

  M <- NULL
  if (!is.null(group)) {
    if (length(group) != nrow(pt$y))
      stop(glue::glue("`group` has length {length(group)}, but there are {nrow(pt$y)} cases"))
    M_of <- bc_M_fun(pt$y, group)
    M <- apply(full_lambda, 1, M_of)
  }

  # 4. Return
  llmax <- max(bc_loglik(lam, pt), loglik)
  ref_dev <- 2 * (llmax - ll_at(ref, warm = FALSE)[1])
  structure(list(axes = axes, grid = grid, loglik = loglik,
                 deviance = 2 * (llmax - loglik),
                 full_lambda = full_lambda, M = M,
                 variables = colnames(pt$y)[v], index = v, type = type,
                 lambda = lam[v], roundlam = pt$roundlam[v],
                 ref = list(lambda = ref, deviance = ref_dev,
                            p = pchisq(ref_dev, k, lower.tail = FALSE)),
                 vcov = if (type == "profile") pt$invHess[v, v, drop = FALSE]
                        else solve(pt$hessian[v, v, drop = FALSE])),
            class = "bcProfile")
}

#' @rdname bcProfile
#' @param x A `"bcProfile"` object
#' @param level Confidence level for the likelihood ratio interval or region,
#'        and the Wald ellipse
#' @param nice "Nice" powers, drawn as reference lines
#' @param fill.levels In 2-D, coverage levels of the nested likelihood ratio
#'        regions. Each is filled with a light `col`, so the fill builds up
#'        toward the maximum
#' @param col Colour for the log-likelihood curve or regions, and the estimate
#' @param alpha Transparency of each filled region
#' @param wald If `TRUE`, draw the Wald confidence ellipse in a 2-D plot
#' @param ref.col Colour for the reference powers. The default, `NULL`, uses
#'        `"red"` in a 1-D plot and `"darkorange"` in the busier 2-D plot
#' @param round.col Colour for the rounded powers
#' @param wald.col Colour for the Wald ellipse
#' @param M.col Colour for Box's M: in 1-D, a second curve with its own axis
#'        on the right (leave room with `par(mar = c(., ., ., 4))`); in 2-D,
#'        dashed contours. Its minimum on the grid is marked
#' @param cex.lab Size of the axis labels
#' @param xlab,ylab,main Axis labels and title. The axis labels default to
#'        \eqn{\lambda}{lambda} with the variable name as subscript
#' @importFrom graphics contour legend mtext segments title
#' @importFrom grDevices contourLines
#' @exportS3Method plot bcProfile
plot.bcProfile <- function(x,
                           level = 0.95,
                           nice = c(-1, -0.5, 0, 0.5, 1, 2, 3),
                           fill.levels = c(0.99, 0.95, 0.90, 0.75, 0.50, 0.25, 0.10),
                           col = "blue",
                           alpha = 0.12,
                           wald = TRUE,
                           ref.col = NULL,
                           round.col = "purple",
                           wald.col = "black",
                           M.col = "darkgreen",
                           cex.lab = 1.3,
                           xlab, ylab, main,
                           ...) {
  dim <- length(x$variables)
  if (is.null(ref.col)) ref.col <- if (dim == 1) "red" else "darkorange"
  if (missing(main))
    main <- glue::glue("Box-Cox {x$type}: {paste(x$variables, collapse = ', ')}")
  # plotmath, not Unicode, so it works on all devices (e.g. pdf())
  ref_lam <- paste0("(", paste(x$ref$lambda, collapse = ", "), ")")
  ref_dev <- round(x$ref$deviance, 1)
  ref_p <- bc_fmt_p(x$ref$p)
  ref_txt <- bquote(lambda == .(ref_lam) * ":  " * chi^2 * (.(dim)) * " = " * .(ref_dev) * ",  " * .(ref_p))
  in_range <- function(val, g) val >= min(g) & val <= max(g)

  if (dim == 1) {
    lam <- x$axes[[1]]
    if (missing(xlab)) xlab <- bc_lab(x$variables)
    if (missing(ylab)) ylab <- "log-likelihood"
    plot(lam, x$loglik, type = "l", lwd = 2, col = col, xlab = xlab, ylab = ylab,
         cex.lab = cex.lab, ...)
    cut <- max(x$loglik) - qchisq(level, 1) / 2
    abline(h = cut, lty = 2, col = "gray50")
    inside <- range(lam[x$loglik >= cut])
    segments(inside, cut, inside, par("usr")[3], lty = 2, col = "gray50")
    abline(v = nice[in_range(nice, lam)], col = "gray80", lty = 3)
    abline(v = x$lambda, col = col, lwd = 2)
    abline(v = x$roundlam, col = round.col, lty = 2, lwd = 1.5)
    sub <- glue::glue("MLE {round(x$lambda, 2)}, rounded {x$roundlam}, ",
                      "{100 * level}% LR interval ({round(inside[1], 2)}, {round(inside[2], 2)})")
    # annotation lines just above the plot, the title above them
    show_ref <- in_range(x$ref$lambda, lam)
    if (show_ref) {
      abline(v = x$ref$lambda, col = ref.col, lwd = 2)
      mtext(ref_txt, side = 3, line = 0.1, cex = 0.7, col = ref.col)
    }
    mtext(sub, side = 3, line = if (show_ref) 1.1 else 0.1, cex = 0.7)
    title(main = main, line = if (show_ref) 2.5 else 1.4)

    M_min <- NULL
    if (!is.null(x$M)) {
      # Box's M on its own (right) axis, with its minimum on the grid
      i_min <- which.min(x$M)
      M_min <- lam[i_min]
      at_edge <- i_min %in% c(1, length(lam))
      op <- par(new = TRUE)
      on.exit(par(op))
      plot(lam, x$M, type = "l", lwd = 2, lty = 4, col = M.col, axes = FALSE,
           xlab = "", ylab = "")
      axis(4, col = M.col, col.axis = M.col)
      mtext("Box's M", side = 4, line = 2.5, col = M.col, cex = 0.8 * cex.lab)
      abline(v = M_min, col = M.col, lty = 3, lwd = 1.5)
      legend(bc_corner(c(x$lambda, M_min), c(max(x$M), min(x$M))), bty = "n", cex = 0.75,
             legend = c(glue::glue("log-likelihood ({x$type})"),
                        if (at_edge) glue::glue("Box's M, still falling at {round(M_min, 2)}")
                        else glue::glue("Box's M, min at {round(M_min, 2)}")),
             col = c(col, M.col), lty = c(1, 4), lwd = 2)
    }
    return(invisible(list(interval = inside, M_min = M_min)))
  }

  # 2-D
  xg <- x$axes[[1]]
  yg <- x$axes[[2]]
  z <- matrix(x$deviance, length(xg), length(yg))
  if (missing(xlab)) xlab <- bc_lab(x$variables[1])
  if (missing(ylab)) ylab <- bc_lab(x$variables[2])
  plot(range(xg), range(yg), type = "n", xlab = xlab, ylab = ylab, main = main,
       cex.lab = cex.lab, ...)
  # nested filled regions, largest first; light fills add up toward the maximum
  fill <- trans.colors(col, alpha)
  for (p in sort(fill.levels, decreasing = TRUE)) {
    for (piece in contourLines(xg, yg, z, levels = qchisq(p, 2)))
      polygon(piece$x, piece$y, col = fill, border = NA)
  }
  for (piece in contourLines(xg, yg, z, levels = qchisq(level, 2)))
    lines(piece$x, piece$y, col = col, lwd = 2)
  if (wald)
    car::ellipse(x$lambda, x$vcov, radius = sqrt(qchisq(level, 2)), add = TRUE,
                 col = wald.col, lty = 2, lwd = 1.5, center.pch = NULL, fill = FALSE)
  abline(v = nice[in_range(nice, xg)], col = "gray70", lty = 3)
  abline(h = nice[in_range(nice, yg)], col = "gray70", lty = 3)
  points(x$lambda[1], x$lambda[2], pch = 16, col = col)
  points(x$roundlam[1], x$roundlam[2], pch = 4, col = round.col, cex = 1.5, lwd = 2)

  show_ref <- in_range(x$ref$lambda[1], xg) && in_range(x$ref$lambda[2], yg)
  if (show_ref) {
    # gray deviance contours between the filled regions and the reference point
    far <- pretty(c(qchisq(max(fill.levels), 2), x$ref$deviance), n = 6)
    far <- far[far > qchisq(max(fill.levels), 2)]
    contour(xg, yg, z, levels = far, add = TRUE, col = "gray60", labcex = 0.6, lty = 1)
    abline(v = x$ref$lambda[1], h = x$ref$lambda[2], col = ref.col, lwd = 1.5)
    points(x$ref$lambda[1], x$ref$lambda[2], pch = 15, col = ref.col, cex = 1.3)
    mtext(ref_txt, side = 3, line = 0.1, cex = 0.7, col = ref.col)
  }

  show_M <- !is.null(x$M)
  M_min <- NULL
  at_edge <- FALSE
  if (show_M) {
    # Box's M as dashed contours, and its minimum on the grid
    zM <- matrix(x$M, length(xg), length(yg))
    contour(xg, yg, zM, nlevels = 8, add = TRUE, col = M.col, lty = 2, labcex = 0.6)
    M_min <- unlist(x$grid[which.min(x$M), ])
    at_edge <- any(M_min[1] %in% range(xg), M_min[2] %in% range(yg))
    points(M_min[1], M_min[2], pch = if (at_edge) 2 else 17, col = M.col, cex = 1.3)
  }
  avoid_x <- c(x$lambda[1], x$roundlam[1], if (show_ref) x$ref$lambda[1], M_min[1])
  avoid_y <- c(x$lambda[2], x$roundlam[2], if (show_ref) x$ref$lambda[2], M_min[2])
  legend(bc_corner(avoid_x, avoid_y), bty = "n", cex = 0.75,
         legend = c("MLE", "rounded", glue::glue("{100 * level}% LR region"),
                    glue::glue("{100 * level}% Wald ellipse"),
                    if (show_ref) "no transformation",
                    if (show_M) c("Box's M",
                                  if (at_edge) "min Box's M (edge of grid)" else "min Box's M")),
         pch = c(16, 4, NA, NA, if (show_ref) 15, if (show_M) c(NA, if (at_edge) 2 else 17)),
         col = c(col, round.col, col, wald.col, if (show_ref) ref.col, if (show_M) rep(M.col, 2)),
         lty = c(NA, NA, 1, 2, if (show_ref) NA, if (show_M) c(2, NA)),
         lwd = c(NA, 2, 2, 1.5, if (show_ref) NA, if (show_M) c(1, NA)))
  invisible(list(M_min = M_min))
}

#' @rdname bcProfile
#' @exportS3Method print bcProfile
print.bcProfile <- function(x, ...) {
  dim <- length(x$variables)
  cat(glue::glue("Box-Cox {x$type} log-likelihood for {paste(x$variables, collapse = ', ')}",
                 " ({paste(lengths(x$axes), collapse = ' x ')} grid)"), "\n")
  cat("  MLE:    ", paste(round(x$lambda, 3), collapse = ", "), "\n")
  cat("  Rounded:", paste(x$roundlam, collapse = ", "), "\n")
  if (dim == 1) {
    inside <- range(x$axes[[1]][x$deviance <= qchisq(0.95, 1)])
    cat("  95% LR interval:", paste(round(inside, 3), collapse = ", "), "\n")
  }
  cat(glue::glue("  LR test of lambda = ({paste(x$ref$lambda, collapse = ', ')}): ",
                 "chi-square({dim}) = {round(x$ref$deviance, 2)}, {bc_fmt_p(x$ref$p)}"), "\n")
  if (!is.null(x$M)) {
    i <- which.min(x$M)
    cat(glue::glue("  Box's M: min {round(x$M[i], 2)} at ",
                   "({paste(round(unlist(x$grid[i, ]), 3), collapse = ', ')}) on the grid"), "\n")
  }
  invisible(x)
}


#' @rdname bcProfile
#' @param mod An `"mlm"` object fitted with a `data` argument
#' @param lambda A vector of powers, one per response, or a `"powerTransform"`
#'        object, whose rounded powers (`coef(lambda, round = TRUE)`) are used
#' @export
bcRefit <- function(mod, lambda) {
  if (!inherits(mod, "mlm")) stop(glue::glue("`mod` must be an mlm, not {class(mod)[1]}"))
  if (inherits(lambda, "powerTransform")) lambda <- coef(lambda, round = TRUE)
  Y <- model.response(model.frame(mod))
  if (length(lambda) != ncol(Y))
    stop(glue::glue("`lambda` has length {length(lambda)}, but there are {ncol(Y)} responses"))
  if (is.null(mod$call$data))
    stop("`mod` must have been fitted with a `data` argument, so it can be refitted")

  Z <- car::bcPower(Y, lambda)
  colnames(Z) <- bc_names(colnames(Y), lambda)
  data <- eval(mod$call$data, environment(formula(mod)))
  data[colnames(Z)] <- as.data.frame(Z)
  fml <- stats::reformulate(
    deparse(formula(mod)[[3]]),
    response = str2lang(glue::glue("cbind({paste(colnames(Z), collapse = ', ')})")))
  mod2 <- update(mod, formula. = fml, data = data)
  attr(mod2, "lambda") <- stats::setNames(unname(lambda), colnames(Y))
  mod2
}


#' @rdname bcProfile
#' @param Y A matrix or data frame of positive responses, or an `"mlm"`, whose
#'        responses are used
#' @param start Starting powers; default, all 1
#' @export
bcBoxM <- function(Y, group, start = rep(1, ncol(Y))) {
  if (inherits(Y, "mlm")) Y <- model.response(model.frame(Y))
  Y <- as.matrix(Y)
  if (any(Y <= 0, na.rm = TRUE)) stop("All responses must be positive for Box-Cox powers")
  M_of <- bc_M_fun(Y, group)
  opt <- optim(start, M_of, method = "Nelder-Mead", control = list(maxit = 2000))
  list(lambda = stats::setNames(opt$par, colnames(Y)), M = opt$value,
       M_start = M_of(start), convergence = opt$convergence, M_of = M_of)
}


# ------------------------------------------------------------------------------------------
# internal helpers
# ------------------------------------------------------------------------------------------

# Log-likelihood of lambda for a "powerTransform" object (bcPower family), conditional on
# the model matrix: -(n/2) log|S(lambda)| + sum_j (lambda_j - 1) sum_i log y_ij,
# with S the ML covariance matrix of the residuals of the transformed responses.
bc_loglik <- function(lambda, pt) {
  Y <- pt$y
  n <- nrow(Y)
  Z <- car::bcPower(Y, lambda)
  R <- qr.resid(pt$xqr, Z)
  S <- crossprod(R) / n
  -(n / 2) * as.numeric(determinant(S)$modulus) + sum((lambda - 1) * colSums(log(Y)))
}

# resolve response names or numbers to column indices of pt$y
bc_index <- function(pt, variables) {
  vnames <- colnames(pt$y)
  if (is.character(variables)) {
    v <- match(variables, vnames)
    if (anyNA(v))
      stop(glue::glue("{paste(variables[is.na(v)], collapse = ', ')} ",
                      "not among the responses: {paste(vnames, collapse = ', ')}"))
    return(v)
  }
  if (any(variables < 1 | variables > length(vnames)))
    stop(glue::glue("`variables` must be in 1:{length(vnames)}"))
  variables
}

# A fast Box's M function of lambda for fixed Y and group: the same chi-square statistic as
# boxM(), without its checks and extra output, for evaluating on a grid.
bc_M_fun <- function(Y, group) {
  group <- droplevels(as.factor(group))
  idx <- split(seq_len(nrow(Y)), group)
  p <- ncol(Y)
  g <- length(idx)
  dfs <- lengths(idx) - 1
  if (any(dfs < p))
    stop(glue::glue("Groups {paste(names(idx)[dfs < p], collapse = ', ')} ",
                    "have too few cases for {p} variables"))
  Co <- ((2 * p^2 + 3 * p - 1) / (6 * (p + 1) * (g - 1))) * (sum(1 / dfs) - 1 / sum(dfs))
  function(lambda) {
    Z <- car::bcPower(Y, lambda)
    SSP <- lapply(idx, function(i) crossprod(scale(Z[i, , drop = FALSE], scale = FALSE)))
    logdets <- vapply(seq_len(g), function(k)
      as.numeric(determinant(SSP[[k]] / dfs[k])$modulus), 0)
    pooled <- Reduce(`+`, SSP) / sum(dfs)
    (sum(dfs) * as.numeric(determinant(pooled)$modulus) - sum(dfs * logdets)) * (1 - Co)
  }
}

# syntactic names for transformed responses: 1 keeps the name, 0 gives logCK,
# others CK_m0.5, Hpx_2
bc_names <- function(names, lambda) {
  pow <- gsub("-", "m", format(lambda, trim = TRUE, drop0trailing = TRUE))
  ifelse(lambda == 1, names,
         ifelse(lambda == 0, paste0("log", names), paste0(names, "_", pow)))
}

# axis label: lambda with the variable name as subscript
bc_lab <- function(name) bquote(lambda[.(name)])

# format a p-value for a plot annotation
bc_fmt_p <- function(p) {
  if (p < 1e-4) "p < .0001" else paste("p =", formatC(p, format = "f", digits = 4))
}

# the corner of the plot region farthest from the points (x, y), for a legend
bc_corner <- function(x, y) {
  usr <- par("usr")
  px <- (x - usr[1]) / (usr[2] - usr[1])
  py <- (y - usr[3]) / (usr[4] - usr[3])
  corners <- list(topright = c(1, 1), topleft = c(0, 1),
                  bottomright = c(1, 0), bottomleft = c(0, 0))
  dmin <- vapply(corners, function(cc) min(sqrt((px - cc[1])^2 + (py - cc[2])^2)), 0)
  names(which.max(dmin))
}
