#' @name Overdose
#' @alias Overdose
#' @doctype data
#' @title
#' Overdose of Amitriptyline
#'
#' @description
#' Data on overdoses of the drug amitriptyline.
#' Amitriptyline is a drug prescribed by physicians as an antidepressant. However, there are also 
#' conjectured side effects that seem to be related to the use of the drug: irregular heart beat,
#' abnormal blood pressure and irregular waves on the electrocardiogram (ECG).
#' This dataset (originally from Rudorfer, 1982) gives data on 17 patients admitted to hospital after an overdose 
#' of amitriptyline.
#' The two response variables are: \code{TCAD} and \code{AMI}. The other variables are predictors.
#'
#' @usage data("Overdose")
#' @format
#'  A data frame with 17 observations on the following 7 variables.
#'  \describe{
#'    \item{\code{TCAD}}{total TCAD plasma level, a numeric vector}
#'    \item{\code{AMI}}{amount of amitriptyline present in the TCAD plasma level, a numeric vector}
#'    \item{\code{Gender}}{a factor with levels \code{Male} \code{Female}}
#'    \item{\code{amount}}{amount of drug taken at time of overdose, a numeric vector}
#'    \item{\code{BP}}{diastolic blood pressure, a numeric vector}
#'    \item{\code{ECG_PR}}{ECG PR wave measurement, a numeric vector}
#'    \item{\code{ECG_QRS}}{ECG QRS wave measurement, a numeric vector}
#'  }
#'
#' %% @details 
#' %%  ~~ If necessary, more details than the __description__ above ~~
#' @source 
#' Johnson & Wichern (2005), \emph{Applied Multivariate Statistical Analysis},
#' Exercise 7.25, p. 426.
#' @references
#' Rudorfer,  M. V. Cardiovascular changes and plasma drug levels after amitriptyline overdose. (1982).
#' \emph{J. Toxicol. Clin. Toxicol.}. \bold{19}(1),67-78. 
#' \doi{10.3109/15563658208990367}, PMID: 7154142.
#' 
#' Getting started with Multivariate Multiple Regression,
#' \url{https://library.virginia.edu/data/articles/getting-started-with-multivariate-multiple-regression}.
#' 
#' ECG measurements:
#' \describe{
#'    \item{PR}{\url{https://en.wikipedia.org/wiki/PR_interval}}
#'    \item{QRS}{\url{https://en.wikipedia.org/wiki/QRS_complex}}
#' }
#' 
#'
#' @examples
#' data(Overdose)
#' str(Overdose)
#' pairs(Overdose) 
#' 
#' over.mlm <- lm(cbind(TCAD, AMI) ~ Gender + amount + BP + ECG_PR + ECG_QRS, data = Overdose)
#' coef(over.mlm)
#' 
#' # check for outliers
#' cqplot(over.mlm)
#' 
#' # HE plot shows that relations of responses to predictors are essentially one-dimensional
#' heplot(over.mlm)
#'
#' # canonical correlation analysis 
#' if(require(candisc)) {
#' cancor(cbind(TCAD, AMI) ~ as.numeric(Gender) + amount + BP + ECG_PR + ECG_QRS, data = Overdose)
#' }
#'
#' @keywords datasets
NULL
