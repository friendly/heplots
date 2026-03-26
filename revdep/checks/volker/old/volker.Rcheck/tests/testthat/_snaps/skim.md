# skim_metrics

    Code
      data
    Output
      # A tibble: 101 x 22
          case use_private use_work cg_adoption_advantage_01 cg_adoption_advantage_02
         <dbl>       <dbl>    <dbl>                    <dbl>                    <dbl>
       1   170           4        4                        3                        4
       2   183           1        1                        4                        3
       3   195           2        4                        5                        5
       4   212           5        5                        4                        4
       5   222           2        3                        3                        2
       6   236           3        1                        3                        2
       7   255           3        1                        3                        1
       8   297           3        4                        4                        3
       9   309           3        3                        3                        4
      10   325           2        1                        4                        1
      # i 91 more rows
      # i 17 more variables: cg_adoption_advantage_03 <dbl>,
      #   cg_adoption_advantage_04 <dbl>, cg_adoption_fearofuse_01 <dbl>,
      #   cg_adoption_fearofuse_02 <dbl>, cg_adoption_fearofuse_03 <dbl>,
      #   cg_adoption_fearofuse_04 <dbl>, cg_adoption_social_01 <dbl>,
      #   cg_adoption_social_02 <dbl>, cg_adoption_social_03 <dbl>,
      #   cg_adoption_social_04 <dbl>, adopter <fct>, sd_age <dbl>, ...

# five-point-summary

    Code
      list(iqr_age = .iqr(data$sd_age), whisker_lower = .whisker_lower(data$sd_age),
      whisker_upper = .whisker_upper(data$sd_age), outliers = .outliers(data$sd_age))
    Output
      $iqr_age
      [1] 25
      
      $whisker_lower
      [1] 18
      
      $whisker_upper
      [1] 68
      
      $outliers
      $outliers[[1]]
      numeric(0)
      
      

