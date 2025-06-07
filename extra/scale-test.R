# Standardized coefficients for a MLM using update to re-fit the model
# standardize numeric variables only
# see: https://stackoverflow.com/questions/62714796/standardize-variables-using-dplyr-r

# tidyverse doesn't play nicely with scale()!

library(dplyr)

mod1 <- lm(cbind(SAT,PPVT,Raven) ~ SES + n+s+ns+na+ss, data=Rohwer)
coef(mod1)

coefplot(mod1, fill=TRUE)

# can't use this b/c factor SES
mod1_std <- update(mod1, data = scale(Rohwer))
# -> Error in colMeans(x, na.rm = TRUE) : 'x' must be numeric

# need to std. numerics first, but scale() returns a 1-col matrix for each variable
Rohwer_std <- Rohwer |>
  as_tibble() |>
  mutate(across(where(is.numeric),  ~ drop(scale(.))))

mod1_std <- update(mod1, data = Rohwer_std)
coef(mod1_std)
coefplot(mod1_std, fill=TRUE)

# how to allow a vars arg here?
Scale <- function(x, vars, ...) {
  result <- as_tibble(x) |>
    mutate(across(where(is.numeric),  ~ scale(.)[,1]))
}
