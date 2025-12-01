# standardized regression coefficients

# from QuantPsyc::lm.beta
stdcoef <- function (MOD)  {
b <- summary(MOD)$coef[-1, 1]  
sx <- sd(MOD$model[-1])
sy <- sd(MOD$model[1])   
beta <- b * sx/sy    
return(beta) 
}

# 
# SY <- diag(1 / sy)
# SX <- diag(sx)
# #sx <- cbind(c(1, -means)), SX)
# 
# Beta <- SY %*% B %*% SX

# this is from lm.beta::lm.beta
# which also has print, summary, coef methods
lm.beta <- function (object, complete.standardization = FALSE) 
{
    if (!("lm" %in% attr(object, "class"))) 
        stop("'object' has to inherit class 'lm'")
    if (complete.standardization) {
        i <- 1
    }
    else {
        i <- attr(attr(object$model, "terms"), "intercept")
    }
    n <- nrow(object$model)
    if (exists("weights", object)) {
        w <- object$weights
    }
    else {
        w <- rep(1, n)
    }
    nw <- sum(w != 0, na.rm = T)
    y <- as.matrix(model.frame(object)[, 1])
    sy <- sqrt(apply(y, 2, function(a) {
      sum(w * (a - weighted.mean(a, w, na.rm = T) * i)^2, na.rm = T)
    }) / ((nw - 1) / nw * sum(w, na.rm = T)))
    x <- as.matrix(model.matrix(object))
    sx <- sqrt(apply(x, 2, function(a) {
      sum(w * (a - weighted.mean(a, w, na.rm = T) * i)^2, na.rm = T)
    }) / ((nw - 1) / nw * sum(w, na.rm = T)))
    object$standardized.coefficients <- coef(object) * sx / sy
    if (attr(attr(object$model, "terms"), "intercept") == 1)
      object$standardized.coefficients[1] <- NA
    attr(object, "class") <- c("lm.beta", class(object))
    return(object)
}

if(FALSE) {
  data(Prestige, package = "carData")
  mod <- lm(prestige ~ income + education, data=Prestige)
  coef(mod)
  stdcoef(mod)
  
  mod.std <- lm.beta(mod) 
  coef(mod.std)
  
  library(QuantPsyc)
  QuantPsyc::lm.beta(mod)
  
  library(lm.beta)
  lm.beta::lm.beta(mod)
  
  # update method?
  update(mod, 
         data = Prestige |>
           dplyr::mutate(across(where(is.numeric), scale)))

  # does this work for an MLM? Only standardize the predictors?
  data(dogfood, package = "heplots")
  dogfood.mod <- lm(cbind(start, amount) ~ formula, data=dogfood)
  dogfood.mod

  heplot(dogfood.mod, 
         fill = TRUE, fill.alpha = 0.1)
  
  # try label.pos
  heplot(dogfood.mod, 
         fill = TRUE, fill.alpha = 0.1,
         label.pos = c("NE", "SW"), cex = 1.4)
  
  #
  
  dogfood.std <- update(dogfood.mod,
                        data = dogfood |>
                          dplyr::mutate(across(where(is.numeric), scale)))
  dogfood.std

  # Problem: predictors aren't named  
# Coefficients:
#               [,1]     [,2]   
# (Intercept)   -0.7726   1.0770
# formulaNew     0.6506  -0.8058
# formulaMajor   1.3012  -1.5187
# formulaAlps    1.1386  -1.9836

  heplot(dogfood.std)
  
# gives error:
# Error in Y[, vars] : subscript out of bounds  
    

  
}
