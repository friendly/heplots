# taken from car::utility-functions.R; should be imported into heplots
# but not sure how to do this
# [perhaps need importFrom(car, car:::df.terms, car:::df.terms.default, car:::is.aliased) in NAMESPACE?]

#' Find degrees of freedom for model terms
#' 
#' @param model A model object, such as fit using \code{\link[stats]{lm}}.
#' @param term  One or more terms from the model
#' @param ...   Other arguments, ignored
#'
#' @export
df.terms <- function(model, term, ...){
	UseMethod("df.terms")
}

#' @rdname df.terms
#' @export
df.terms.default <- function(model, term, ...){
	if (is.aliased(model)) stop("Model has aliased term(s); df ambiguous.")
	if (!missing(term) && 1 == length(term)){
		assign <- attr(model.matrix(model), "assign")
		which.term <- which(term == labels(terms(model)))
		if (0 == length(which.term)) stop(paste(term, "is not in the model."))
		sum(assign == which.term)
	}
	else {
		terms <- if (missing(term)) labels(terms(model)) else term
		result <- numeric(0)
		for (term in terms) result <- c(result, Recall(model, term))
		names(result) <- terms
		result
	}
}

is.aliased <- function(model){
	!is.null(alias(model)$Complete)
}

# taken from car:::applyDefaults -- avoids a `car:::` call (R CMD check
# NOTE) for this one small, self-contained helper used by pvPlot() to
# merge its `id` argument with defaults, the same way car's own
# id-argument functions (e.g. dataEllipse()) do internally.
applyDefaults <- function(args, defaults, type = "") {
  if (isFALSE(args)) return(FALSE)
  names <- names(args)
  names <- names[names != ""]
  if (!isTRUE(args) && !is.null(args) && length(names) != length(args)) {
    warning("unnamed ", type, " arguments, will be ignored")
  }
  if (isTRUE(args) || is.null(names)) {
    defaults
  } else {
    defaults[names] <- args[names]
  }
  as.list(defaults)
}
