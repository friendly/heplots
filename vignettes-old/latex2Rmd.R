#' Latex to R markdown converter
#' 
#' @description Does 7- percent of the job, the rest is manual edits.
#' 
#' @param input Character Filename of input file
#' @param output character Filename of output file
#' 
#' @details Doesn't insert figures from external sources.
#' 
#' @author Loic Dutrieux, Michael Friendly
#' 
#' @import stringr
#' 

library(stringr)

latex2Rmd <- function(input, output) {
    text <- readChar(input, file.info(input)$size)
    
    text <- str_replace_all(string = text, pattern = '<<(.*?)>>=(.*?)@', replacement = '```{r, \\1}\\2```')
    
    # Order these in likelihood of nestedness
    text <- str_replace_all(string = text, pattern = '\\\\href\\{(.*?)\\}\\{(.*?)\\}', replacement = '[\\2](\\1)')
    text <- str_replace_all(string = text, pattern = '\\\\url\\{(.*?)\\}', replacement = '[\\1]')
    text <- str_replace_all(string = text, pattern = '\\\\code\\{(.*?)\\}', replacement = '`\\1`')
    text <- str_replace_all(string = text, pattern = '\\\\func\\{(.*?)\\}', replacement = '`\\1()`')
    text <- str_replace_all(string = text, pattern = '\\\\texttt\\{(.*?)\\}', replacement = '`\\1`')
    text <- str_replace_all(string = text, pattern = '\\\\emph\\{(.*?)\\}', replacement = '*\\1*')
    text <- str_replace_all(string = text, pattern = '\\\\textit\\{(.*?)\\}', replacement = '*\\1*')
    
    text <- str_replace_all(string = text, pattern = '\\\\section\\*?\\{(.*?)\\}', replacement = '# \\1')
    text <- str_replace_all(string = text, pattern = '\\\\subsection\\*?\\{(.*?)\\}', replacement = '## \\1')
    text <- str_replace_all(string = text, pattern = '\\\\subsubsection\\*?\\{(.*?)\\}', replacement = '### \\1')
    
    
    text <- str_replace_all(string = text, pattern = '\\\\begin\\{(.*?)\\}', replacement = '')
    text <- str_replace_all(string = text, pattern = '\\\\end\\{(.*?)\\}', replacement = '')
#    text <- str_replace_all(string = text, pattern = '\\\\item', replacement = '*')
    
    text <- str_replace_all(string = text, pattern = '\\\r', replacement = '')
    
# additions from rnw2rmd
    pat <- list(
      c(from = "<<(.*?)>>=",                   to = "```{r, \\1}"),
      c(from = "@",                            to = "```"),         # danger
      c(from = "\\\\maketitle",                to = ""),
      c(from = "\\\\texttt{(.+?)}",            to = "`\\1`"),
      c(from = "\\\\textit{(.+?)}",            to = "*\\1*"),
      c(from = "\\\\textbf{(.+?)}",            to = "**\\1**"),
      c(from = "\\\\emph{(.+?)}",              to = "*\\1*"),
      c(from = "\\\\Sexpr{(.+?)}",             to = "`r \\1`"),
      
      c(from = "\\\\cite{(.+?)}",              to = "[\\@\\1]"),
      c(from = "\\\\citep{(.+?)}",             to = "[\\@\\1]"),
      c(from = "\\\\cite<(.+?)>{(.+?)}",       to = "[\\1 \\@\\2]"),
      c(from = "\\\\citet{(.+?)}",             to = "\\@\\1"),
      c(from = "\\\\citeNP{(.+?)}",            to = "\\@\\1"),
      c(from = "\\\\citeNP<(.+?)>{(.+?)}",     to = "\\1 \\@\\2"),

      c(from = "\\\\ref{(.+?)}",               to = "\\\\@ref(\\1)"),
      c(from = "\\\\secref{(.+?)}",            to = "\\\\@ref(\\1)"),
      c(from = "\\\\url{(.+?)}",               to = "<\\1>"),
      c(from = "\\\\href{(.+?)}{(.+?)}",       to = "[\\2](\\1)"),

      c(from = "\\\\%",                        to = "%"),
      c(from = "\\\\ldots",                    to = "\\.\\.\\."),
      c(from = "\\\\label{(.+?)}",             to = " {#\\1}"), # only for sections
      c(from = "\\\\bibliography{(.+?)}",      to = "# References"),
      c(from = "\\\\bibliographystyle{(.+?)}", to = ""),
      
      c(from = "\\s*\\\\section{(.+?)}",       to = "# \\1"),
      c(from = "\\s*\\\\subsection{(.+?)}",    to = "## \\1"),
      c(from = "\\s*\\\\subsubsection{(.+?)}", to = "### \\1"),
      c(from = "\\s*\\\\paragraph{(.+?)}",     to = "#### \\1"),
      # handle \section[]{}
      c(from = "\\\\section(\\[.*\\])?\\*?\\{(.*?)\\}",         to = "# \\2"),
      c(from = "\\\\subsection(\\[.*\\])?\\*?\\{(.*?)\\}",      to = "## \\2"),
      c(from = "\\\\subsubsection(\\[.*\\])?\\*?\\{(.*?)\\}",   to = "## \\2"),

      c(from = "\\\\item[(.*)]",                to= '* **\\1**'),
      c(from = "\\\\item\\s*",                  to= '* '),

      # my latex definitions      
      c(from = "\\\\code{(.+?)}",               to = "`\\1`"),
      c(from = "\\\\data{(.+?)}",               to = "`\\1`"),
      c(from = "\\\\pkg{(.+?)}",                to = "`\\1`"),
      c(from = "\\\\verb\\|(.+?)\\|",           to = "`\\1`"),
      c(from = "\\\\codefun{(.+?)}",            to = "`\\1()`"),
      c(from = "\\\\class{(.+?)}",              to = "*\\1*"),
      c(from = "\\\\proglang{(.+?)}",           to = "\\1"),

      c(from = "\\\\given",                     to = "\\; | \\;"),
      c(from = "\\\\mat{(.+?)}",                to = "$\\\\mathbf{\\1}$"),
      
      # footnotes can be multiline; need non-greedy regex
      c(from = "\\\\footnote{(.+?)}",           to = "^[\\1]")
      
    )

    for (thisPat in pat){
      text <- gsub(thisPat[["from"]], thisPat[["to"]], text, perl=TRUE)
    }
    

    writeLines(text, output, sep = '')
}