#' @name oral
#' @aliases oral
#' @docType data
#' @title
#' Effect of Delay in Oral Practice in Second Language Learning
#'
#' @description
#' Postovsky (1970) investigatged the effect of delay in oral practice at the beginning of second language learning.
#' A control condition began oral practice with no delay, while an experimental group had a four-week delay before
#' starting oral practice. The data consists of scores on language skills at the end of six weeks of study.
#' 
#' Students in this study were matched on age, education, former language training, intelligence and language aptitude.
#'
#' @usage data("oral")
#' @format
#'  A data frame with 56 observations on the following 5 variables.
#'  \describe{
#'    \item{\code{group}}{Group, a factor with levels \code{Control} \code{Exptl}}
#'    \item{\code{listen}}{Listening test, a numeric vector}
#'    \item{\code{speak}}{Speaking test, a numeric vector}
#'    \item{\code{read}}{Reading test, a numeric vector}
#'    \item{\code{write}}{Writing test, a numeric vector}
#'  }
#'
#' @details 
#' %%  ~~ If necessary, more details than the __description__ above ~~
#' @source 
#' Timm, N. H. (1975). \emph{Multivariate Analysis with Applications in Education and Psychology}. Wadsworth (Brooks/Cole),
#'     Exercise 3.12, p. 279.
#' @references
#' Postovsky, V. A. (1970). Effects of delay in oral practice at the start of second language training. Unpublished doctoral dissertation, University of California, Berleley.
#'
#' @concept MANOVA
#' @examples
#' data(oral)
#' ## maybe str(oral) ; plot(oral) ...
#'
#' @keywords datasets
NULL
