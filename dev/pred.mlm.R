#Multivariate Linear Regression Inference and Prediction
#R Function for Multivariate Regression CIs and PIs

# Goal: Extend the predict methods for linear models to multivariate ones.
# This function is an attempt to put together the ideas in 
#   http://users.stat.umn.edu/~helwig/notes/mvlr-Notes.pdf
# with the framework for stats::predict.lm

# Function from Nathaniel Helwig, slide 82

pred.mlm0 <- function(object, newdata,
                      se.fit = TRUE,
                      level=0.95,
                     interval = c("confidence", "prediction")){
  
  if (missing(newdata)) {
    newdata <- as.data.frame(model.matrix(object))
    X <- newdata
    offset <- object$offset
  }
  form <- as.formula(paste("~", as.character(formula(object))[3]))
  xnew <- model.matrix(form, newdata)
  fit <- predict(object, newdata)
  Y <- model.frame(object)[,1]
  X <- model.matrix(object)
  n <- nrow(Y)
  m <- ncol(Y)
  p <- ncol(X) - 1
  sigmas <- colSums((Y - object$fitted.values)^2) / (n - p - 1)
  fit.var <- diag(xnew %*% tcrossprod(solve(crossprod(X)), xnew))
  if(interval[1]=="prediction") fit.var <- fit.var + 1
  const <- qf(level, df1=m, df2=n-p-m) * m * (n - p - 1) / (n - p - m)
  vmat <- (n/(n-p-1)) * outer(fit.var, sigmas)
  lwr <- fit - sqrt(const) * sqrt(vmat)
  upr <- fit + sqrt(const) * sqrt(vmat)
  if(nrow(xnew)==1L){
    ci <- rbind(fit, lwr, upr)
    rownames(ci) <- c("fit", "lwr", "upr")
  } else {
    ci <- array(0, dim=c(nrow(xnew), m, 3))
    dimnames(ci) <- list(1:nrow(xnew), colnames(Y), c("fit", "lwr", "upr") )
    ci[,,1] <- fit
    ci[,,2] <- lwr
    ci[,,3] <- upr
  }
  ci
}

pred.mlm <- function(object, 
                     newdata, 
                     se.fit = FALSE, 
                     na.action = na.pass,
                     ...
                     # interval = c("confidence", "prediction"),
                     # level=0.95,
                     # type = c("response", "terms")
                     ){

  
  if (missing(newdata)) {
    newdata <- model.matrix(object)
    X <- newdata
    offset <- object$offset
  }
  else {
    tt <- terms(object)
    Terms <- delete.response(tt)
    m <- model.frame(Terms, newdata, na.action = na.action, 
                     xlev = object$xlevels)
    if (!is.null(cl <- attr(Terms, "dataClasses"))) 
      .checkMFClasses(cl, m)
    X <- model.matrix(Terms, m, contrasts.arg = object$contrasts)
    offset <- if (!is.null(off.num <- attr(tt, "offset"))) 
      eval(attr(tt, "variables")[[off.num + 1]], newdata)
    else if (!is.null(object$offset)) 
      eval(object$call$offset, newdata)
  }
  
  form <- as.formula(paste("~",as.character(formula(object))[3]))
  xnew <- model.matrix(form, newdata)
  fit <- predict(object, newdata)
  Y <- model.frame(object)[,1]
#  X <- model.matrix(object)
  n <- nrow(Y)
  m <- ncol(Y)
  p <- ncol(X) - 1
  
  sigmas <- colSums((Y - object$fitted.values)^2) / (n - p - 1)
  fit.var <- diag(xnew %*% tcrossprod(solve(crossprod(X)), xnew))
#  if(interval[1]=="prediction") fit.var <- fit.var + 1
#  const <- qf(level, df1=m, df2=n-p-m) * m * (n - p - 1) / (n - p - m)
  vmat <- (n/(n-p-1)) * outer(fit.var, sigmas)
  se <- sqrt(vmat)
  colnames(se) <- paste0("se_", colnames(Y))

  if (!is.null(offset)) 
    fit <- fit + offset
  
  if (se.fit) {
    fit <- cbind(fit, se)
  }
  
  return(fit)
  
  # browser()
  # lwr <- fit - sqrt(const) * sqrt(vmat)
  # upr <- fit + sqrt(const) * sqrt(vmat)
  
  # if(nrow(xnew)==1L){
  # 	ci <- rbind(fit, lwr, upr)
  # 	rownames(ci) <- c("fit", "lwr", "upr")
  # } else {
  # 	ci <- array(0, dim=c(nrow(xnew), m, 3))
  # 	dimnames(ci) <- list(1:nrow(xnew), colnames(Y), c("fit", "lwr", "upr") )
  # 	ci[,,1] <- fit
  # 	ci[,,2] <- lwr
  # 	ci[,,3] <- upr
  # }
  # ci
}

if(FALSE){
# For comparison, here is
# stats:::predict.mlm
predict.mlm <-
function (object, newdata, se.fit = FALSE, na.action = na.pass, 
    ...) 
{
    if (missing(newdata)) 
        return(object$fitted.values)
    if (se.fit) 
        stop("the 'se.fit' argument is not yet implemented for \"mlm\" objects")
    if (missing(newdata)) {
        X <- model.matrix(object)
        offset <- object$offset
    }
    else {
        tt <- terms(object)
        Terms <- delete.response(tt)
        m <- model.frame(Terms, newdata, na.action = na.action, 
            xlev = object$xlevels)
        if (!is.null(cl <- attr(Terms, "dataClasses"))) 
            .checkMFClasses(cl, m)
        X <- model.matrix(Terms, m, contrasts.arg = object$contrasts)
        offset <- if (!is.null(off.num <- attr(tt, "offset"))) 
            eval(attr(tt, "variables")[[off.num + 1]], newdata)
        else if (!is.null(object$offset)) 
            eval(object$call$offset, newdata)
    }
    piv <- qr.lm(object)$pivot[seq(object$rank)]
    pred <- X[, piv, drop = FALSE] %*% object$coefficients[piv, 
        ]
    if (!is.null(offset)) 
        pred <- pred + offset
    if (inherits(object, "mlm")) 
        pred
    else pred[, 1L]
}
}

if (FALSE) {

  library(dplyr)
  library(car)
  
  data(mathscore, package = "heplots")
  math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
  predict(math.mod)
  
  pred.mlm(math.mod)
  
  pred.mlm0(math.mod)
  
  

  # univariate model
  cars.mod1 <- lm(mpg ~  cyl + am + carb, data=mtcars)
  newdata <- data.frame(cyl=6, am=1, carb=4)
  predict(cars.mod1, newdata = newdata, interval = "confidence")

  # multivariate model
  Y <- as.matrix(mtcars[,c("mpg","disp","hp","wt")])
  mvmod <- lm(cbind(mpg, disp, hp, wt) ~ cyl + am + carb, data=mtcars)
  coef(mvmod)


  # Extract univariate summaries from the mlm
mvsum <- summary(mvmod)
# mpg ~
mvsum[[1]]
# hp ~
mvsum[[3]]


predict(mvmod) |> head()

# confidence interval
predict(mvmod, newdata = newdata)

predict(mvmod, newdata)

pred.mlm(mvmod, newdata)
pred.mlm(mvmod, newdata, se.fit = TRUE)
# prediction interval
pred.mlm(mvmod, newdata, interval="prediction")

# confidence interval (multiple new observations)
new2 <- data.frame(cyl=c(4,6,8), am=c(0,1,1), carb=c(2,4,6))
pred.mlm(mvmod, new2)
pred.mlm(mvmod, new2, se.fit = TRUE)

# original function
pred.mlm0(mvmod, newdata)
# prediction interval
pred.mlm0(mvmod, newdata, interval="prediction")

pred.mlm0(mvmod, new2, se.fit = TRUE)



}
