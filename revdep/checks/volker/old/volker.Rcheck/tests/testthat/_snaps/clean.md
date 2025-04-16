# No values are recoded to missings

    Code
      prepared_data
    Output
      # A tibble: 4 x 2
         var1  var2
        <dbl> <dbl>
      1     1    -2
      2     2    -3
      3    -1    -3
      4     5    -9

# Residual values are recoded to missings

    Code
      prepared_data
    Output
      # A tibble: 1 x 2
         var1  var2
        <dbl> <dbl>
      1     2    -3

# Residual negative values are removed

    Code
      data_clean(tibble::tibble(var1 = c(1, 2, -1, -9, -50, -999)))
    Output
      # A tibble: 6 x 1
         var1
        <dbl>
      1     1
      2     2
      3    -1
      4    -9
      5   -50
      6  -999

# Residual negative values are removed from data in SPSS format

    Code
      data_clean(spss_data, remove.na.numbers = c(-999, -555))
    Output
      # A tibble: 4 x 1
         var1
        <dbl>
      1     1
      2     2
      3   -50
      4    NA

# All negatives are removed

    Code
      data_rm_negatives(tibble::tibble(var1 = c(1, 2, -1, -9)), var1)
    Output
      # A tibble: 2 x 1
         var1
        <dbl>
      1     1
      2     2

# Negatives are kept

    Code
      data_clean(tibble::tibble(var1 = c(1, 2, -9)))
    Output
      # A tibble: 3 x 1
         var1
        <dbl>
      1     1
      2     2
      3    -9

# NA levels are kept

    Code
      data_rm_na_levels(tibble::tibble(value1 = factor(c("A", "B", "[no answer]"))))
    Output
      # A tibble: 3 x 1
        value1     
        <fct>      
      1 A          
      2 B          
      3 [no answer]

# Baseline is extracted

    Code
      get_baseline(result)
    Output
      [1] "Frequencies based on values: agree, strongly agree. 4 missing case(s) omitted."

# Baseline for zeros

    Code
      get_baseline(result)
    Output
      [1] "3 zero case(s) omitted."

# Baseline for negatives

    Code
      get_baseline(result)
    Output
      [1] "2 negative case(s) omitted."

