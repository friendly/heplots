#' @name dogfood
#' @aliases dogfood
#' @docType data
#' @title
#' %%  Dogfood Preferences
#'
#' @description
#' A tiny hypothetical dataset to illustrate one-way MANOVA.
#' 
#' A dogfood manufacturer wanted to study preference for different dogfood formulas, two of their own
#' ("Old", "New") and two from other manufacturers ("Major", "Alps"). In a between-dog design, 4 dogs
#' were presented with a bowl of one \code{formula} and the time to \code{start} eating and \code{amount} eaten were recorded.
#'
#'
#' @usage data("dogfood")
#' @format
#'  A data frame with 16 observations on the following 3 variables.
#'  \describe{
#'    \item{\code{formula}}{factor, a factor with levels \code{Old} \code{New} \code{Major} \code{Alps}}
#'    \item{\code{start}}{numeric, time to start eating}
#'    \item{\code{amount}}{numeric, amount eaten}
#'  }
#'
#' @details 
#' %%  ~~ If necessary, more details than the __description__ above ~~
#' @source 
#' Used in my Psych 6140 lecture notes
#'
#' @concept MANOVA
#' @concept contrasts
#' @concept candisc
#' @keywords datasets
#' @examples
#' data(dogfood)
#' library(car)
#' dog.mod <- lm(cbind(start, amount) ~ formula, data=dogfood)
#' Anova(dog.mod)
#'
#' # data ellipses
#' covEllipses(cbind(start, amount) ~ formula)
NULL
