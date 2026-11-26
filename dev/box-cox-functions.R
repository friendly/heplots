# Prototype functions for multivariate Box-Cox transformations of an mlm (see dev/box-cox.md)
# Used by dev/box-cox-demo.R (Dystrophy) and dev/box-cox-diabetes.R (Diabetes).
# Built on car::powerTransform(); these add the plots, the refit, and a Box's M criterion.
#
# DONE: ✔️ bc_loglik() reproduces car's LR tests exactly 11/26/2026
# DONE: ✔️ bc_profile(): one function for 1-D and 2-D profiles, by length(variables) (MF) 11/26/2026
# DONE: ✔️ 2-D: nested, lightly filled LR regions; alpha builds up toward the MLE (MF) 11/26/2026
# DONE: ✔️ bc_refit() keeps the Box-Cox scaling; names CK_m0.5, Hpx_2, logPK (MF: OK) 11/26/2026
# DONE: ✔️ lambda in the axis labels of 1-D and 2-D plots (MF) 11/26/2026
# DONE: ✔️ extend_range = TRUE widens the grid to include lambda = 1 (no transformation),
#       marks it, and gives its LR test, to show how far it is from the MLE (MF) 11/26/2026
# DONE: ✔️ bc_boxM(): Box's M as a function of lambda, and the lambda that minimizes it (MF:
#       "a great idea") 11/26/2026
# TODO: 🚩 pairs() version: 2-D profiles below the diagonal, 1-D on the diagonal
# TODO: 🚩 Default type for 2-D: "profile" is slow (one optim() per grid point)

# Log-likelihood of lambda for a "powerTransform" object (bcPower family), conditional on
# the model matrix: -(n/2) log|S(lambda)| + sum_j (lambda_j - 1) sum_i log y_ij,
# with S the ML covariance matrix of the residuals of the transformed responses.
# Same as Rencher & Christensen (4.43), with residuals in place of deviations from the mean.
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
    if (anyNA(v)) stop(glue::glue("{paste(variables[is.na(v)], collapse = ', ')} ",
                                  "not among: {paste(vnames, collapse = ', ')}"))
    v
  } else variables
}

# Profile (or slice) log-likelihood for one or two of the lambdas.
#   variables:    one or two response names or numbers. One -> 1-D curve, two -> 2-D surface.
#   type:         "profile" maximizes over the other lambdas at each grid point;
#                 "slice" holds them at their MLEs (cheaper, and not a proper profile).
#   range:        +/- this many Wald SEs around each MLE.
#   extend_range: if TRUE, widen each axis so the grid also includes `ref` (default 1,
#                 no transformation), to show how far it is from the MLE.
#   ref:          the reference power(s), recycled to length(variables).
#   n:            grid points per dimension.
# Returns an object of class "bc_profile": the grid, the log-likelihood, the deviance
# 2 * (max - loglik) (compared with chi-square, df = length(variables)), and the deviance
# and p-value at `ref`.
bc_profile <- function(pt, variables = 1, type = c("profile", "slice"),
                       range = 3.5, extend_range = FALSE, ref = 1,
                       n = if (length(variables) == 1) 101 else 61) {
  type <- match.arg(type)
  if (!identical(pt$family, "bcPower"))
    stop(glue::glue("Only the bcPower family is supported, not {pt$family}"))
  v <- bc_index(pt, variables)
  k <- length(v)
  if (!k %in% 1:2) stop(glue::glue("`variables` must give 1 or 2 responses, got {k}"))
  ref <- rep_len(ref, k)

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

  # log-likelihood with lambda[v] fixed; for a profile, maximize over the other lambdas,
  # starting from the previous grid point's optimum (warm start)
  start <- lam[others]
  ll_at <- function(fixed, warm = TRUE) {
    full <- lam
    full[v] <- fixed
    if (type == "slice" || length(others) == 0) return(bc_loglik(full, pt))
    f <- function(free) { full[others] <- free; -bc_loglik(full, pt) }
    opt <- optim(if (warm) start else lam[others], f, method = "BFGS")
    if (warm) start <<- opt$par
    -opt$value
  }
  loglik <- apply(as.matrix(grid), 1, ll_at)

  llmax <- max(bc_loglik(lam, pt), loglik)
  ref_dev <- 2 * (llmax - ll_at(ref, warm = FALSE))
  structure(list(axes = axes, grid = grid, loglik = loglik,
                 deviance = 2 * (llmax - loglik),
                 variables = colnames(pt$y)[v], index = v, type = type,
                 lambda = lam[v], roundlam = pt$roundlam[v],
                 ref = list(lambda = ref, deviance = ref_dev,
                            p = pchisq(ref_dev, k, lower.tail = FALSE)),
                 # Wald covariance: marginal (invHess) for a profile, conditional for a slice
                 vcov = if (type == "profile") pt$invHess[v, v, drop = FALSE]
                        else solve(pt$hessian[v, v, drop = FALSE])),
            class = "bc_profile")
}

# axis label: lambda with the variable name as subscript
bc_lab <- function(name) bquote(lambda[.(name)])

# format a p-value for a plot annotation
bc_fmt_p <- function(p) if (p < 1e-4) "p < .0001" else paste("p =", formatC(p, format = "f", digits = 4))

# the corner of the plot region farthest from the points (x, y), for a legend
bc_corner <- function(x, y) {
  usr <- par("usr")
  px <- (x - usr[1]) / (usr[2] - usr[1])
  py <- (y - usr[3]) / (usr[4] - usr[3])
  corners <- list(topright = c(1, 1), topleft = c(0, 1), bottomright = c(1, 0), bottomleft = c(0, 0))
  dmin <- vapply(corners, function(cc) min(sqrt((px - cc[1])^2 + (py - cc[2])^2)), 0)
  names(which.max(dmin))
}

# Plot a "bc_profile": a 1-D curve or 2-D filled contours, depending on its dimension.
#   level:  confidence level for the LR interval / region and the Wald ellipse
#   nice:   "nice" powers drawn as reference lines
#   fill.levels, col, alpha: the 2-D regions are nested LR regions at these coverage
#           levels, each filled with a light `col`, so the fill builds up toward the MLE
#   ref.col: colour for the reference point (lambda = 1), drawn when it is in the plot;
#           in 2-D, gray contours of the deviance are added between the regions and it
plot.bc_profile <- function(x, level = 0.95,
                            nice = c(-1, -0.5, 0, 0.5, 1, 2, 3),
                            fill.levels = c(0.99, 0.95, 0.90, 0.75, 0.50, 0.25, 0.10),
                            col = "blue", alpha = 0.12, wald = TRUE, ref.col = "darkorange",
                            xlab, ylab, main, ...) {
  dim <- length(x$variables)
  if (missing(main)) main <- glue::glue("Box-Cox {x$type}: {paste(x$variables, collapse = ', ')}")
  ref_txt <- glue::glue("λ = ({paste(x$ref$lambda, collapse = ', ')}): ",
                        "χ²({dim}) = {round(x$ref$deviance, 1)}, {bc_fmt_p(x$ref$p)}")
  in_range <- function(val, g) val >= min(g) & val <= max(g)

  if (dim == 1) {
    lam <- x$axes[[1]]
    if (missing(xlab)) xlab <- bc_lab(x$variables)
    if (missing(ylab)) ylab <- "log-likelihood"
    plot(lam, x$loglik, type = "l", lwd = 2, col = col, xlab = xlab, ylab = ylab, ...)
    cut <- max(x$loglik) - qchisq(level, 1) / 2
    abline(h = cut, lty = 2, col = "gray50")
    inside <- range(lam[x$loglik >= cut])
    segments(inside, cut, inside, par("usr")[3], lty = 2, col = "gray50")
    abline(v = nice[in_range(nice, lam)], col = "gray80", lty = 3)
    abline(v = x$lambda, col = col)
    abline(v = x$roundlam, col = "red", lty = 2)
    sub <- glue::glue("MLE {round(x$lambda, 2)}, rounded {x$roundlam}, ",
                      "{100 * level}% LR interval ({round(inside[1], 2)}, {round(inside[2], 2)})")
    # annotation lines just above the plot, the title above them
    show_ref <- in_range(x$ref$lambda, lam)
    if (show_ref) {
      abline(v = x$ref$lambda, col = ref.col, lwd = 2)
      mtext(ref_txt, side = 3, line = 0.1, cex = 0.7, col = ref.col)
    }
    mtext(sub, side = 3, line = if (show_ref) 0.9 else 0.1, cex = 0.7)
    title(main = main, line = if (show_ref) 2.3 else 1.4)
    return(invisible(list(interval = inside)))
  }

  # 2-D
  xg <- x$axes[[1]]; yg <- x$axes[[2]]
  z <- matrix(x$deviance, length(xg), length(yg))
  if (missing(xlab)) xlab <- bc_lab(x$variables[1])
  if (missing(ylab)) ylab <- bc_lab(x$variables[2])
  plot(range(xg), range(yg), type = "n", xlab = xlab, ylab = ylab, main = main, ...)
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
                 col = "black", lty = 2, lwd = 1.5, center.pch = NULL, fill = FALSE)
  abline(v = nice[in_range(nice, xg)], col = "gray70", lty = 3)
  abline(h = nice[in_range(nice, yg)], col = "gray70", lty = 3)
  points(x$lambda[1], x$lambda[2], pch = 16, col = col)
  points(x$roundlam[1], x$roundlam[2], pch = 4, col = "red", cex = 1.5, lwd = 2)

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
  avoid_x <- c(x$lambda[1], x$roundlam[1], if (show_ref) x$ref$lambda[1])
  avoid_y <- c(x$lambda[2], x$roundlam[2], if (show_ref) x$ref$lambda[2])
  legend(bc_corner(avoid_x, avoid_y), bty = "n", cex = 0.75,
         legend = c("MLE", "rounded", glue::glue("{100 * level}% LR region"),
                    glue::glue("{100 * level}% Wald ellipse"),
                    if (show_ref) "no transformation"),
         pch = c(16, 4, NA, NA, if (show_ref) 15),
         col = c(col, "red", col, "black", if (show_ref) ref.col),
         lty = c(NA, NA, 1, 2, if (show_ref) NA), lwd = c(NA, 2, 2, 1.5, if (show_ref) NA))
  invisible(x)
}

# Refit an mlm with Box-Cox transformed responses (keeping the Box-Cox scaling,
# (y^lambda - 1) / lambda, so the direction of effects is preserved for lambda < 0).
# New response names are syntactic: lambda = 1 keeps the name, 0 gives logCK,
# others CK_m0.5, Hpx_2. The lambdas are kept in attr(, "lambda").
bc_names <- function(names, lambda) {
  pow <- gsub("-", "m", format(lambda, trim = TRUE, drop0trailing = TRUE))
  ifelse(lambda == 1, names,
         ifelse(lambda == 0, paste0("log", names), paste0(names, "_", pow)))
}

bc_refit <- function(mod, lambda) {
  Y <- model.response(model.frame(mod))
  if (length(lambda) != ncol(Y))
    stop(glue::glue("`lambda` has length {length(lambda)}, but there are {ncol(Y)} responses"))
  Z <- car::bcPower(Y, lambda)
  colnames(Z) <- bc_names(colnames(Y), lambda)
  data <- eval(mod$call$data, environment(formula(mod)))
  data[colnames(Z)] <- as.data.frame(Z)
  fml <- reformulate(deparse(formula(mod)[[3]]),
                     response = str2lang(glue::glue("cbind({paste(colnames(Z), collapse = ', ')})")))
  mod2 <- update(mod, formula. = fml, data = data)
  attr(mod2, "lambda") <- setNames(lambda, colnames(Y))
  mod2
}

# Box's M for the Box-Cox transformed responses, by group, and the lambda that minimizes it.
# Box's M is invariant to rescaling each variable, so no Jacobian term is needed.
#   Y: matrix of positive responses; group: factor; start: starting lambdas
bc_boxM <- function(Y, group, start = rep(1, ncol(Y))) {
  M_of <- function(lambda) unname(boxM(car::bcPower(Y, lambda), group)$statistic)
  opt <- optim(start, M_of, method = "Nelder-Mead", control = list(maxit = 2000))
  list(lambda = setNames(opt$par, colnames(Y)), M = opt$value,
       M_start = M_of(start), convergence = opt$convergence, M_of = M_of)
}
