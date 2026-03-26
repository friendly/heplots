# PCA results are reproducable

    Code
      data %>% add_factors(tidyselect::starts_with("cg_adoption"), k = 3) %>%
        factor_tab(starts_with("fct_cg_adoption"))
    Output
      
      
      |Expectations                             | Component 1| Component 2| Component 3| communality|
      |:----------------------------------------|-----------:|-----------:|-----------:|-----------:|
      |ChatGPT has clear advantages compared... |         0.1|         0.9|         0.0|         0.8|
      |Using ChatGPT brings financial benefits. |         0.5|         0.5|         0.3|         0.6|
      |Using ChatGPT is advantageous in many... |         0.2|         0.8|         0.0|         0.7|
      |Compared to other systems, using Chat... |         0.2|         0.8|         0.0|         0.7|
      |Much can go wrong when using ChatGPT.    |        -0.1|        -0.2|         0.8|         0.7|
      |There are legal issues with using Cha... |         0.2|         0.2|         0.6|         0.5|
      |The security of user data is not guar... |         0.1|         0.1|         0.7|         0.6|
      |Using ChatGPT could bring personal di... |         0.2|        -0.1|         0.7|         0.6|
      |In my environment, using ChatGPT is s... |         0.9|         0.2|         0.0|         0.8|
      |Almost everyone in my environment use... |         0.8|         0.2|         0.1|         0.7|
      |Not using ChatGPT is considered being... |         0.7|         0.0|         0.3|         0.6|
      |Using ChatGPT brings me recognition f... |         0.8|         0.2|         0.0|         0.6|
      
      4 missing case(s) omitted.
      
      
      
      |Component   | Eigenvalue| Proportion of variance| Cumulative proportion of va...|
      |:-----------|----------:|----------------------:|------------------------------:|
      |Component 1 |        3.0|                    0.3|                            0.3|
      |Component 2 |        2.5|                    0.2|                            0.5|
      |Component 3 |        2.2|                    0.2|                            0.6|
      
      
      |Test          |                Statistic|  value|
      |:-------------|------------------------:|------:|
      |KMO Test      |                    Cases|     97|
      |KMO Test      |                Variables|     12|
      |KMO Test      | Cases-to-Variables Ratio|   8.08|
      |KMO Test      |              Overall MSA|   0.74|
      |Bartlett Test |              Chi-squared| 463.54|
      |Bartlett Test |                       df|     66|
      |Bartlett Test |                        p|  0.000|
      |Bartlett Test |                    stars|    ***|

# Calculation with missings

    Code
      data %>% add_factors(tidyselect::starts_with("cg_adoption"), k = 3) %>%
        factor_tab(starts_with("fct_cg_adoption"))
    Output
      
      
      |Expectations                             | Component 1| Component 2| Component 3| communality|
      |:----------------------------------------|-----------:|-----------:|-----------:|-----------:|
      |ChatGPT has clear advantages compared... |         0.1|         0.9|         0.0|         0.8|
      |Using ChatGPT brings financial benefits. |         0.5|         0.5|         0.3|         0.6|
      |Using ChatGPT is advantageous in many... |         0.2|         0.8|         0.0|         0.7|
      |Compared to other systems, using Chat... |         0.2|         0.8|         0.0|         0.7|
      |Much can go wrong when using ChatGPT.    |        -0.2|        -0.2|         0.8|         0.7|
      |There are legal issues with using Cha... |         0.2|         0.2|         0.6|         0.5|
      |The security of user data is not guar... |         0.1|         0.1|         0.7|         0.6|
      |Using ChatGPT could bring personal di... |         0.2|        -0.1|         0.7|         0.5|
      |In my environment, using ChatGPT is s... |         0.9|         0.2|         0.0|         0.8|
      |Almost everyone in my environment use... |         0.8|         0.2|         0.1|         0.7|
      |Not using ChatGPT is considered being... |         0.7|         0.0|         0.3|         0.6|
      |Using ChatGPT brings me recognition f... |         0.8|         0.2|         0.0|         0.6|
      
      4 case(s) with missing values.
      
      
      
      |Component   | Eigenvalue| Proportion of variance| Cumulative proportion of va...|
      |:-----------|----------:|----------------------:|------------------------------:|
      |Component 1 |        3.0|                    0.3|                            0.3|
      |Component 2 |        2.5|                    0.2|                            0.5|
      |Component 3 |        2.2|                    0.2|                            0.6|
      
      
      |Test          |                Statistic|  value|
      |:-------------|------------------------:|------:|
      |KMO Test      |                    Cases|    101|
      |KMO Test      |                Variables|     12|
      |KMO Test      | Cases-to-Variables Ratio|   8.42|
      |KMO Test      |              Overall MSA|   0.74|
      |Bartlett Test |              Chi-squared| 469.63|
      |Bartlett Test |                       df|     66|
      |Bartlett Test |                        p|  0.000|
      |Bartlett Test |                    stars|    ***|

