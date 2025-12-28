# effect_counts_one

    Code
      volker::effect_counts(dplyr::filter(data, sd_gender != "diverse"), sd_gender)
    Output
      
      
      |Statistic        | Value|
      |:----------------|-----:|
      |Gini coefficient |  0.10|
      |n                |   100|
      |Chi-squared      |  4.00|
      |p                | 0.046|
      |stars            |     *|

# effect_counts_one_grouped

    Code
      volker::effect_counts(dplyr::mutate(dplyr::filter(data, sd_gender != "diverse"),
      sd_age_group = ifelse(sd_age > 40, "40+", "< 40")), sd_gender, sd_age_group)
    Output
      
      
      |sd_gender | sd_age_group|  n| p_x|  p_y| p_xy| ratio|   pmi|  npmi| fisher_p| fisher_stars|
      |:---------|------------:|--:|---:|----:|----:|-----:|-----:|-----:|--------:|------------:|
      |female    |          40+| 16| 0.4| 0.44| 0.16|  0.91| -0.14| -0.05|    0.543|             |
      |female    |         < 40| 24| 0.4| 0.56| 0.24|  1.07|  0.10|  0.05|    0.543|             |
      |male      |          40+| 28| 0.6| 0.44| 0.28|  1.06|  0.08|  0.05|    0.543|             |
      |male      |         < 40| 32| 0.6| 0.56| 0.32|  0.95| -0.07| -0.04|    0.543|             |
      
      Adjusted significance p values with fdr method.
      
      
      
      |Statistic   | Value|
      |:-----------|-----:|
      |Cramer's V  |  0.05|
      |Chi-squared |  0.20|
      |n           |   100|
      |df          |     1|
      |p           | 0.651|
      |stars       |      |

# effect_counts_items

    Code
      volker::effect_counts(data, starts_with("cg_adoption_advantage"))
    Output
      
      
      |Expectations                             | Gini coefficient|  n| Chi-squared|     p| stars|
      |:----------------------------------------|----------------:|--:|-----------:|-----:|-----:|
      |ChatGPT has clear advantages compared... |             0.36| 99|       43.47| 0.000|   ***|
      |Using ChatGPT brings financial benefits. |             0.19| 99|       14.28| 0.006|    **|
      |Using ChatGPT is advantageous in many... |             0.36| 99|       47.01| 0.000|   ***|
      |Compared to other systems, using Chat... |             0.40| 99|       53.68| 0.000|   ***|
      
      2 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_counts_items_grouped

    Code
      volker::effect_counts(data, starts_with("cg_adoption_advantage"), sd_gender)
    Output
      
      
      |Expectations: Correlation w...           | Cramer's V| Chi-squared|  n| df|     p| stars|
      |:----------------------------------------|----------:|-----------:|--:|--:|-----:|-----:|
      |ChatGPT has clear advantages compared... |       0.14|        3.76| 99|   | 0.852|      |
      |Using ChatGPT brings financial benefits. |       0.16|        4.99| 99|   | 0.852|      |
      |Using ChatGPT is advantageous in many... |       0.14|        3.78| 99|   | 0.852|      |
      |Compared to other systems, using Chat... |       0.13|        3.44| 99|   | 0.852|      |
      
      n=99. 2 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_counts_items_grouped_items

    Code
      volker::effect_counts(data, starts_with("cg_adoption_adv"), starts_with("use_"))
    Output
      
      
      |Expectations                             |                   Usage| Cramer's V| Chi-squared|  n| df|     p| stars|
      |:----------------------------------------|-----------------------:|----------:|-----------:|--:|--:|-----:|-----:|
      |ChatGPT has clear advantages compared... |      in private context|       0.32|       41.27| 99|   | 0.006|    **|
      |ChatGPT has clear advantages compared... | in professional context|       0.24|       23.46| 99|   | 0.139|      |
      |Using ChatGPT brings financial benefits. |      in private context|       0.24|       22.48| 99|   | 0.142|      |
      |Using ChatGPT brings financial benefits. | in professional context|       0.37|       53.99| 99|   | 0.004|    **|
      |Using ChatGPT is advantageous in many... |      in private context|       0.25|       24.15| 99|   | 0.139|      |
      |Using ChatGPT is advantageous in many... | in professional context|       0.30|       34.57| 99|   | 0.012|     *|
      |Compared to other systems, using Chat... |      in private context|       0.30|       34.62| 99|   | 0.024|     *|
      |Compared to other systems, using Chat... | in professional context|       0.20|       16.23| 99|   | 0.468|      |
      
      n=99. 2 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_metrics_one

    Code
      volker::effect_metrics(data, sd_age)
    Output
      
      
      |Age      | Value|
      |:--------|-----:|
      |skewness |  0.25|
      |kurtosis | -0.98|
      
      
      |Shapiro-Wilk normality test |      Value|
      |:---------------------------|----------:|
      |W                           |       0.96|
      |p                           |      0.002|
      |stars                       |         **|
      |normality                   | not normal|

# effect_metrics_one_grouped

    Code
      volker::effect_metrics(data, sd_age, adopter)
    Output
      
      
      |Term                                     | estimate| ci low| ci high|    se|     t|     p| stars|
      |:----------------------------------------|--------:|------:|-------:|-----:|-----:|-----:|-----:|
      |(Intercept)                              |    36.60|  29.55|   43.65|  3.55| 10.30| 0.000|   ***|
      |I try new offers immediately (Reference) |         |       |        |      |      |      |      |
      |I try new offers rather quickly          |     4.21|  -3.64|   12.06|  3.95|  1.06| 0.386|      |
      |I wait until offers establish themselves |     1.17|  -7.97|   10.32|  4.61|  0.25| 0.800|      |
      |I only use new offers when I have no ... |    19.40|  -8.81|   47.61| 14.21|  1.36| 0.351|      |
      
      Adjusted significance p values with fdr method.
      
      
      
      |Statistic          | Value|
      |:------------------|-----:|
      |Adjusted R-squared |  0.00|
      |F                  |  1.00|
      |df                 |     3|
      |residual df        |    97|
      |p                  | 0.396|
      |stars              |      |

# effect_metrics_one_grouped with t.test

    Code
      volker::effect_metrics(data, sd_age, sd_gender, method = "t.test")
    Output
      
      
      |Test                        |  Statistic|             Value|
      |:---------------------------|----------:|-----------------:|
      |Shapiro-Wilk normality test |          W|              0.96|
      |Shapiro-Wilk normality test |          p|             0.002|
      |Shapiro-Wilk normality test |      stars|                **|
      |Shapiro-Wilk normality test |  normality|        not normal|
      |Levene test                 |          F|              0.07|
      |Levene test                 |          p|             0.796|
      |Levene test                 |      stars|                  |
      |Levene test                 |  variances|             equal|
      |Cohen's d                   |          d|              -0.3|
      |Cohen's d                   |     ci low|              -0.7|
      |Cohen's d                   |    ci high|               0.1|
      |t-Test                      |     method| Two Sample t-test|
      |t-Test                      | difference|             -3.69|
      |t-Test                      |     ci low|             -9.27|
      |t-Test                      |    ci high|              1.88|
      |t-Test                      |         se|              2.81|
      |t-Test                      |         df|                98|
      |t-Test                      |          t|             -1.31|
      |t-Test                      |          p|             0.192|
      |t-Test                      |      stars|                  |

# effect_metrics_one_cor

    Code
      volker::effect_metrics(data, sd_age, use_private, metric = TRUE)
    Output
      
      
      |Statistic   | value|
      |:-----------|-----:|
      |Pearson's r | -0.19|
      |R-squared   |  0.03|
      |n           |   101|
      |ci low      | -0.37|
      |ci high     |  0.01|
      |df          |    99|
      |t           | -1.88|
      |p           | 0.063|
      |stars       |     .|

# effect_metrics_one_cor with pearson

    Code
      volker::effect_metrics(data, sd_age, use_private, metric = TRUE, method = "pearson")
    Output
      
      
      |Statistic   | value|
      |:-----------|-----:|
      |Pearson's r | -0.19|
      |R-squared   |  0.03|
      |n           |   101|
      |ci low      | -0.37|
      |ci high     |  0.01|
      |df          |    99|
      |t           | -1.88|
      |p           | 0.063|
      |stars       |     .|

# effect_metrics_one_cor with spearman

    Code
      volker::effect_metrics(data, sd_age, use_private, metric = TRUE, method = "spearman")
    Output
      
      
      |Statistic      |     value|
      |:--------------|---------:|
      |Spearman's rho |     -0.20|
      |R-squared      |      0.04|
      |n              |       101|
      |s              | 206410.07|
      |p              |     0.043|
      |stars          |         *|

# effect_metrics_items

    Code
      volker::effect_metrics(data, tidyselect::starts_with("use_"))
    Output
      
      
      |Usage                   | skewness| kurtosis|    W|     p| stars|  normality|
      |:-----------------------|--------:|--------:|----:|-----:|-----:|----------:|
      |in private context      |     0.41|    -0.39| 0.90| 0.000|   ***| not normal|
      |in professional context |     0.51|    -1.13| 0.84| 0.000|   ***| not normal|
      
      Adjusted significance p values with fdr method.
      

# effect_metrics_items_cor with one variable

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"), sd_age,
      metric = TRUE)
    Output
      
      
      |Expectations: Correlation w...           | Pearson's r| R-squared|  n| ci low| ci high| df|     t|     p| stars|
      |:----------------------------------------|-----------:|---------:|--:|------:|-------:|--:|-----:|-----:|-----:|
      |ChatGPT has clear advantages compared... |       -0.12|      0.02| 97|  -0.32|    0.08| 95| -1.22| 0.509|      |
      |Using ChatGPT brings financial benefits. |       -0.13|      0.02| 97|  -0.32|    0.07| 95| -1.29| 0.509|      |
      |Using ChatGPT is advantageous in many... |       -0.09|      0.01| 97|  -0.28|    0.11| 95| -0.86| 0.525|      |
      |Compared to other systems, using Chat... |       -0.12|      0.01| 97|  -0.31|    0.08| 95| -1.15| 0.509|      |
      |Much can go wrong when using ChatGPT.    |        0.18|      0.03| 97|  -0.02|    0.36| 95|  1.76| 0.348|      |
      |There are legal issues with using Cha... |        0.24|      0.06| 97|   0.05|    0.42| 95|  2.45| 0.194|      |
      |The security of user data is not guar... |       -0.10|      0.01| 97|  -0.29|    0.11| 95| -0.93| 0.525|      |
      |Using ChatGPT could bring personal di... |        0.02|      0.00| 97|  -0.18|    0.22| 95|  0.20| 0.846|      |
      |In my environment, using ChatGPT is s... |       -0.17|      0.03| 97|  -0.36|    0.03| 95| -1.73| 0.348|      |
      |Almost everyone in my environment use... |       -0.06|      0.00| 97|  -0.26|    0.14| 95| -0.59| 0.668|      |
      |Not using ChatGPT is considered being... |        0.09|      0.01| 97|  -0.11|    0.28| 95|  0.87| 0.525|      |
      |Using ChatGPT brings me recognition f... |       -0.02|      0.00| 97|  -0.22|    0.18| 95| -0.22| 0.846|      |
      
      n=97. 4 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_metrics_items_cor with one variable and spearman

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"), sd_age,
      metric = TRUE, method = "spearman")
    Output
      
      
      |Expectations: Correlation w...           | Spearman's rho| R-squared|  n|         s|     p| stars|
      |:----------------------------------------|--------------:|---------:|--:|---------:|-----:|-----:|
      |ChatGPT has clear advantages compared... |          -0.14|      0.02| 97| 172811.45| 0.334|      |
      |Using ChatGPT brings financial benefits. |          -0.14|      0.02| 97| 173694.29| 0.334|      |
      |Using ChatGPT is advantageous in many... |          -0.13|      0.02| 97| 171301.35| 0.334|      |
      |Compared to other systems, using Chat... |          -0.14|      0.02| 97| 172970.04| 0.334|      |
      |Much can go wrong when using ChatGPT.    |           0.17|      0.03| 97| 126186.26| 0.334|      |
      |There are legal issues with using Cha... |           0.26|      0.07| 97| 113310.65| 0.141|      |
      |The security of user data is not guar... |          -0.12|      0.01| 97| 170009.06| 0.334|      |
      |Using ChatGPT could bring personal di... |           0.01|      0.00| 97| 151122.65| 0.950|      |
      |In my environment, using ChatGPT is s... |          -0.16|      0.03| 97| 177123.13| 0.334|      |
      |Almost everyone in my environment use... |          -0.07|      0.00| 97| 162382.67| 0.612|      |
      |Not using ChatGPT is considered being... |           0.12|      0.01| 97| 133571.33| 0.334|      |
      |Using ChatGPT brings me recognition f... |          -0.01|      0.00| 97| 153072.54| 0.950|      |
      
      n=97. 4 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_metrics_items_cor with items

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("cg_adoption_"), metric = TRUE)
    Output
      
      
      |Item 1: Expectations                     |                     Item 2: Expectations| Pearson's r| R-squared|  n| ci low| ci high| df|     t|     p| stars|
      |:----------------------------------------|----------------------------------------:|-----------:|---------:|--:|------:|-------:|--:|-----:|-----:|-----:|
      |ChatGPT has clear advantages compared... | ChatGPT has clear advantages compared...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |ChatGPT has clear advantages compared... | Using ChatGPT brings financial benefits.|        0.37|      0.14| 97|   0.19|    0.53| 95|  3.91| 0.001|   ***|
      |ChatGPT has clear advantages compared... | Using ChatGPT is advantageous in many...|        0.64|      0.41| 97|   0.50|    0.74| 95|  8.04| 0.000|   ***|
      |ChatGPT has clear advantages compared... | Compared to other systems, using Chat...|        0.61|      0.37| 97|   0.47|    0.72| 95|  7.47| 0.000|   ***|
      |ChatGPT has clear advantages compared... |    Much can go wrong when using ChatGPT.|       -0.14|      0.02| 97|  -0.33|    0.06| 95| -1.40| 0.206|      |
      |ChatGPT has clear advantages compared... | There are legal issues with using Cha...|        0.19|      0.04| 97|  -0.01|    0.38| 95|  1.90| 0.084|     .|
      |ChatGPT has clear advantages compared... | The security of user data is not guar...|        0.07|      0.01| 97|  -0.13|    0.27| 95|  0.71| 0.520|      |
      |ChatGPT has clear advantages compared... | Using ChatGPT could bring personal di...|        0.01|      0.00| 97|  -0.19|    0.21| 95|  0.10| 0.924|      |
      |ChatGPT has clear advantages compared... | In my environment, using ChatGPT is s...|        0.21|      0.04| 97|   0.01|    0.39| 95|  2.07| 0.062|     .|
      |ChatGPT has clear advantages compared... | Almost everyone in my environment use...|        0.28|      0.08| 97|   0.08|    0.45| 95|  2.84| 0.010|     *|
      |ChatGPT has clear advantages compared... | Not using ChatGPT is considered being...|        0.16|      0.03| 97|  -0.04|    0.35| 95|  1.59| 0.147|      |
      |ChatGPT has clear advantages compared... | Using ChatGPT brings me recognition f...|        0.27|      0.07| 97|   0.07|    0.44| 95|  2.68| 0.016|     *|
      |Using ChatGPT brings financial benefits. | ChatGPT has clear advantages compared...|        0.37|      0.14| 97|   0.19|    0.53| 95|  3.91| 0.001|   ***|
      |Using ChatGPT brings financial benefits. | Using ChatGPT brings financial benefits.|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Using ChatGPT brings financial benefits. | Using ChatGPT is advantageous in many...|        0.46|      0.21| 97|   0.29|    0.61| 95|  5.07| 0.000|   ***|
      |Using ChatGPT brings financial benefits. | Compared to other systems, using Chat...|        0.42|      0.18| 97|   0.24|    0.57| 95|  4.55| 0.000|   ***|
      |Using ChatGPT brings financial benefits. |    Much can go wrong when using ChatGPT.|        0.02|      0.00| 97|  -0.18|    0.22| 95|  0.22| 0.842|      |
      |Using ChatGPT brings financial benefits. | There are legal issues with using Cha...|        0.34|      0.12| 97|   0.15|    0.50| 95|  3.52| 0.002|    **|
      |Using ChatGPT brings financial benefits. | The security of user data is not guar...|        0.34|      0.12| 97|   0.15|    0.51| 95|  3.56| 0.002|    **|
      |Using ChatGPT brings financial benefits. | Using ChatGPT could bring personal di...|        0.22|      0.05| 97|   0.02|    0.40| 95|  2.20| 0.048|     *|
      |Using ChatGPT brings financial benefits. | In my environment, using ChatGPT is s...|        0.54|      0.29| 97|   0.38|    0.67| 95|  6.24| 0.000|   ***|
      |Using ChatGPT brings financial benefits. | Almost everyone in my environment use...|        0.50|      0.25| 97|   0.34|    0.64| 95|  5.67| 0.000|   ***|
      |Using ChatGPT brings financial benefits. | Not using ChatGPT is considered being...|        0.36|      0.13| 97|   0.18|    0.53| 95|  3.81| 0.001|   ***|
      |Using ChatGPT brings financial benefits. | Using ChatGPT brings me recognition f...|        0.40|      0.16| 97|   0.22|    0.55| 95|  4.25| 0.000|   ***|
      |Using ChatGPT is advantageous in many... | ChatGPT has clear advantages compared...|        0.64|      0.41| 97|   0.50|    0.74| 95|  8.04| 0.000|   ***|
      |Using ChatGPT is advantageous in many... | Using ChatGPT brings financial benefits.|        0.46|      0.21| 97|   0.29|    0.61| 95|  5.07| 0.000|   ***|
      |Using ChatGPT is advantageous in many... | Using ChatGPT is advantageous in many...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Using ChatGPT is advantageous in many... | Compared to other systems, using Chat...|        0.47|      0.22| 97|   0.30|    0.61| 95|  5.18| 0.000|   ***|
      |Using ChatGPT is advantageous in many... |    Much can go wrong when using ChatGPT.|       -0.11|      0.01| 97|  -0.30|    0.09| 95| -1.10| 0.324|      |
      |Using ChatGPT is advantageous in many... | There are legal issues with using Cha...|        0.19|      0.04| 97|  -0.01|    0.38| 95|  1.93| 0.079|     .|
      |Using ChatGPT is advantageous in many... | The security of user data is not guar...|        0.06|      0.00| 97|  -0.14|    0.25| 95|  0.57| 0.598|      |
      |Using ChatGPT is advantageous in many... | Using ChatGPT could bring personal di...|        0.09|      0.01| 97|  -0.11|    0.28| 95|  0.87| 0.433|      |
      |Using ChatGPT is advantageous in many... | In my environment, using ChatGPT is s...|        0.33|      0.11| 97|   0.14|    0.50| 95|  3.46| 0.002|    **|
      |Using ChatGPT is advantageous in many... | Almost everyone in my environment use...|        0.34|      0.11| 97|   0.15|    0.50| 95|  3.51| 0.002|    **|
      |Using ChatGPT is advantageous in many... | Not using ChatGPT is considered being...|        0.13|      0.02| 97|  -0.07|    0.32| 95|  1.31| 0.234|      |
      |Using ChatGPT is advantageous in many... | Using ChatGPT brings me recognition f...|        0.31|      0.10| 97|   0.12|    0.48| 95|  3.18| 0.004|    **|
      |Compared to other systems, using Chat... | ChatGPT has clear advantages compared...|        0.61|      0.37| 97|   0.47|    0.72| 95|  7.47| 0.000|   ***|
      |Compared to other systems, using Chat... | Using ChatGPT brings financial benefits.|        0.42|      0.18| 97|   0.24|    0.57| 95|  4.55| 0.000|   ***|
      |Compared to other systems, using Chat... | Using ChatGPT is advantageous in many...|        0.47|      0.22| 97|   0.30|    0.61| 95|  5.18| 0.000|   ***|
      |Compared to other systems, using Chat... | Compared to other systems, using Chat...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Compared to other systems, using Chat... |    Much can go wrong when using ChatGPT.|       -0.19|      0.04| 97|  -0.38|    0.01| 95| -1.89| 0.084|     .|
      |Compared to other systems, using Chat... | There are legal issues with using Cha...|        0.17|      0.03| 97|  -0.03|    0.36| 95|  1.66| 0.131|      |
      |Compared to other systems, using Chat... | The security of user data is not guar...|        0.14|      0.02| 97|  -0.06|    0.33| 95|  1.40| 0.206|      |
      |Compared to other systems, using Chat... | Using ChatGPT could bring personal di...|       -0.07|      0.00| 97|  -0.26|    0.13| 95| -0.66| 0.552|      |
      |Compared to other systems, using Chat... | In my environment, using ChatGPT is s...|        0.33|      0.11| 97|   0.14|    0.50| 95|  3.40| 0.002|    **|
      |Compared to other systems, using Chat... | Almost everyone in my environment use...|        0.26|      0.07| 97|   0.06|    0.43| 95|  2.60| 0.019|     *|
      |Compared to other systems, using Chat... | Not using ChatGPT is considered being...|        0.20|      0.04| 97|   0.00|    0.38| 95|  1.94| 0.079|     .|
      |Compared to other systems, using Chat... | Using ChatGPT brings me recognition f...|        0.36|      0.13| 97|   0.17|    0.52| 95|  3.72| 0.001|   ***|
      |Much can go wrong when using ChatGPT.    | ChatGPT has clear advantages compared...|       -0.14|      0.02| 97|  -0.33|    0.06| 95| -1.40| 0.206|      |
      |Much can go wrong when using ChatGPT.    | Using ChatGPT brings financial benefits.|        0.02|      0.00| 97|  -0.18|    0.22| 95|  0.22| 0.842|      |
      |Much can go wrong when using ChatGPT.    | Using ChatGPT is advantageous in many...|       -0.11|      0.01| 97|  -0.30|    0.09| 95| -1.10| 0.324|      |
      |Much can go wrong when using ChatGPT.    | Compared to other systems, using Chat...|       -0.19|      0.04| 97|  -0.38|    0.01| 95| -1.89| 0.084|     .|
      |Much can go wrong when using ChatGPT.    |    Much can go wrong when using ChatGPT.|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Much can go wrong when using ChatGPT.    | There are legal issues with using Cha...|        0.29|      0.08| 97|   0.09|    0.46| 95|  2.92| 0.009|    **|
      |Much can go wrong when using ChatGPT.    | The security of user data is not guar...|        0.36|      0.13| 97|   0.17|    0.52| 95|  3.74| 0.001|   ***|
      |Much can go wrong when using ChatGPT.    | Using ChatGPT could bring personal di...|        0.48|      0.23| 97|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |Much can go wrong when using ChatGPT.    | In my environment, using ChatGPT is s...|       -0.19|      0.03| 97|  -0.37|    0.01| 95| -1.85| 0.091|     .|
      |Much can go wrong when using ChatGPT.    | Almost everyone in my environment use...|        0.04|      0.00| 97|  -0.16|    0.23| 95|  0.35| 0.746|      |
      |Much can go wrong when using ChatGPT.    | Not using ChatGPT is considered being...|        0.10|      0.01| 97|  -0.11|    0.29| 95|  0.94| 0.405|      |
      |Much can go wrong when using ChatGPT.    | Using ChatGPT brings me recognition f...|       -0.07|      0.01| 97|  -0.27|    0.13| 95| -0.73| 0.520|      |
      |There are legal issues with using Cha... | ChatGPT has clear advantages compared...|        0.19|      0.04| 97|  -0.01|    0.38| 95|  1.90| 0.084|     .|
      |There are legal issues with using Cha... | Using ChatGPT brings financial benefits.|        0.34|      0.12| 97|   0.15|    0.50| 95|  3.52| 0.002|    **|
      |There are legal issues with using Cha... | Using ChatGPT is advantageous in many...|        0.19|      0.04| 97|  -0.01|    0.38| 95|  1.93| 0.079|     .|
      |There are legal issues with using Cha... | Compared to other systems, using Chat...|        0.17|      0.03| 97|  -0.03|    0.36| 95|  1.66| 0.131|      |
      |There are legal issues with using Cha... |    Much can go wrong when using ChatGPT.|        0.29|      0.08| 97|   0.09|    0.46| 95|  2.92| 0.009|    **|
      |There are legal issues with using Cha... | There are legal issues with using Cha...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |There are legal issues with using Cha... | The security of user data is not guar...|        0.38|      0.15| 97|   0.20|    0.54| 95|  4.06| 0.000|   ***|
      |There are legal issues with using Cha... | Using ChatGPT could bring personal di...|        0.28|      0.08| 97|   0.08|    0.45| 95|  2.83| 0.010|     *|
      |There are legal issues with using Cha... | In my environment, using ChatGPT is s...|        0.23|      0.05| 97|   0.03|    0.41| 95|  2.28| 0.041|     *|
      |There are legal issues with using Cha... | Almost everyone in my environment use...|        0.22|      0.05| 97|   0.02|    0.40| 95|  2.18| 0.048|     *|
      |There are legal issues with using Cha... | Not using ChatGPT is considered being...|        0.33|      0.11| 97|   0.15|    0.50| 95|  3.46| 0.002|    **|
      |There are legal issues with using Cha... | Using ChatGPT brings me recognition f...|        0.30|      0.09| 97|   0.11|    0.47| 95|  3.08| 0.006|    **|
      |The security of user data is not guar... | ChatGPT has clear advantages compared...|        0.07|      0.01| 97|  -0.13|    0.27| 95|  0.71| 0.520|      |
      |The security of user data is not guar... | Using ChatGPT brings financial benefits.|        0.34|      0.12| 97|   0.15|    0.51| 95|  3.56| 0.002|    **|
      |The security of user data is not guar... | Using ChatGPT is advantageous in many...|        0.06|      0.00| 97|  -0.14|    0.25| 95|  0.57| 0.598|      |
      |The security of user data is not guar... | Compared to other systems, using Chat...|        0.14|      0.02| 97|  -0.06|    0.33| 95|  1.40| 0.206|      |
      |The security of user data is not guar... |    Much can go wrong when using ChatGPT.|        0.36|      0.13| 97|   0.17|    0.52| 95|  3.74| 0.001|   ***|
      |The security of user data is not guar... | There are legal issues with using Cha...|        0.38|      0.15| 97|   0.20|    0.54| 95|  4.06| 0.000|   ***|
      |The security of user data is not guar... | The security of user data is not guar...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |The security of user data is not guar... | Using ChatGPT could bring personal di...|        0.39|      0.15| 97|   0.21|    0.55| 95|  4.14| 0.000|   ***|
      |The security of user data is not guar... | In my environment, using ChatGPT is s...|        0.06|      0.00| 97|  -0.14|    0.26| 95|  0.61| 0.576|      |
      |The security of user data is not guar... | Almost everyone in my environment use...|        0.20|      0.04| 97|   0.00|    0.38| 95|  1.94| 0.079|     .|
      |The security of user data is not guar... | Not using ChatGPT is considered being...|        0.29|      0.08| 97|   0.09|    0.46| 95|  2.91| 0.009|    **|
      |The security of user data is not guar... | Using ChatGPT brings me recognition f...|        0.10|      0.01| 97|  -0.11|    0.29| 95|  0.93| 0.405|      |
      |Using ChatGPT could bring personal di... | ChatGPT has clear advantages compared...|        0.01|      0.00| 97|  -0.19|    0.21| 95|  0.10| 0.924|      |
      |Using ChatGPT could bring personal di... | Using ChatGPT brings financial benefits.|        0.22|      0.05| 97|   0.02|    0.40| 95|  2.20| 0.048|     *|
      |Using ChatGPT could bring personal di... | Using ChatGPT is advantageous in many...|        0.09|      0.01| 97|  -0.11|    0.28| 95|  0.87| 0.433|      |
      |Using ChatGPT could bring personal di... | Compared to other systems, using Chat...|       -0.07|      0.00| 97|  -0.26|    0.13| 95| -0.66| 0.552|      |
      |Using ChatGPT could bring personal di... |    Much can go wrong when using ChatGPT.|        0.48|      0.23| 97|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |Using ChatGPT could bring personal di... | There are legal issues with using Cha...|        0.28|      0.08| 97|   0.08|    0.45| 95|  2.83| 0.010|     *|
      |Using ChatGPT could bring personal di... | The security of user data is not guar...|        0.39|      0.15| 97|   0.21|    0.55| 95|  4.14| 0.000|   ***|
      |Using ChatGPT could bring personal di... | Using ChatGPT could bring personal di...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Using ChatGPT could bring personal di... | In my environment, using ChatGPT is s...|        0.25|      0.06| 97|   0.06|    0.43| 95|  2.54| 0.021|     *|
      |Using ChatGPT could bring personal di... | Almost everyone in my environment use...|        0.22|      0.05| 97|   0.02|    0.40| 95|  2.23| 0.045|     *|
      |Using ChatGPT could bring personal di... | Not using ChatGPT is considered being...|        0.25|      0.06| 97|   0.06|    0.43| 95|  2.56| 0.021|     *|
      |Using ChatGPT could bring personal di... | Using ChatGPT brings me recognition f...|        0.14|      0.02| 97|  -0.06|    0.33| 95|  1.37| 0.212|      |
      |In my environment, using ChatGPT is s... | ChatGPT has clear advantages compared...|        0.21|      0.04| 97|   0.01|    0.39| 95|  2.07| 0.062|     .|
      |In my environment, using ChatGPT is s... | Using ChatGPT brings financial benefits.|        0.54|      0.29| 97|   0.38|    0.67| 95|  6.24| 0.000|   ***|
      |In my environment, using ChatGPT is s... | Using ChatGPT is advantageous in many...|        0.33|      0.11| 97|   0.14|    0.50| 95|  3.46| 0.002|    **|
      |In my environment, using ChatGPT is s... | Compared to other systems, using Chat...|        0.33|      0.11| 97|   0.14|    0.50| 95|  3.40| 0.002|    **|
      |In my environment, using ChatGPT is s... |    Much can go wrong when using ChatGPT.|       -0.19|      0.03| 97|  -0.37|    0.01| 95| -1.85| 0.091|     .|
      |In my environment, using ChatGPT is s... | There are legal issues with using Cha...|        0.23|      0.05| 97|   0.03|    0.41| 95|  2.28| 0.041|     *|
      |In my environment, using ChatGPT is s... | The security of user data is not guar...|        0.06|      0.00| 97|  -0.14|    0.26| 95|  0.61| 0.576|      |
      |In my environment, using ChatGPT is s... | Using ChatGPT could bring personal di...|        0.25|      0.06| 97|   0.06|    0.43| 95|  2.54| 0.021|     *|
      |In my environment, using ChatGPT is s... | In my environment, using ChatGPT is s...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |In my environment, using ChatGPT is s... | Almost everyone in my environment use...|        0.73|      0.54| 97|   0.62|    0.81| 95| 10.47| 0.000|   ***|
      |In my environment, using ChatGPT is s... | Not using ChatGPT is considered being...|        0.48|      0.23| 97|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |In my environment, using ChatGPT is s... | Using ChatGPT brings me recognition f...|        0.57|      0.33| 97|   0.42|    0.69| 95|  6.85| 0.000|   ***|
      |Almost everyone in my environment use... | ChatGPT has clear advantages compared...|        0.28|      0.08| 97|   0.08|    0.45| 95|  2.84| 0.010|     *|
      |Almost everyone in my environment use... | Using ChatGPT brings financial benefits.|        0.50|      0.25| 97|   0.34|    0.64| 95|  5.67| 0.000|   ***|
      |Almost everyone in my environment use... | Using ChatGPT is advantageous in many...|        0.34|      0.11| 97|   0.15|    0.50| 95|  3.51| 0.002|    **|
      |Almost everyone in my environment use... | Compared to other systems, using Chat...|        0.26|      0.07| 97|   0.06|    0.43| 95|  2.60| 0.019|     *|
      |Almost everyone in my environment use... |    Much can go wrong when using ChatGPT.|        0.04|      0.00| 97|  -0.16|    0.23| 95|  0.35| 0.746|      |
      |Almost everyone in my environment use... | There are legal issues with using Cha...|        0.22|      0.05| 97|   0.02|    0.40| 95|  2.18| 0.048|     *|
      |Almost everyone in my environment use... | The security of user data is not guar...|        0.20|      0.04| 97|   0.00|    0.38| 95|  1.94| 0.079|     .|
      |Almost everyone in my environment use... | Using ChatGPT could bring personal di...|        0.22|      0.05| 97|   0.02|    0.40| 95|  2.23| 0.045|     *|
      |Almost everyone in my environment use... | In my environment, using ChatGPT is s...|        0.73|      0.54| 97|   0.62|    0.81| 95| 10.47| 0.000|   ***|
      |Almost everyone in my environment use... | Almost everyone in my environment use...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Almost everyone in my environment use... | Not using ChatGPT is considered being...|        0.58|      0.33| 97|   0.43|    0.70| 95|  6.88| 0.000|   ***|
      |Almost everyone in my environment use... | Using ChatGPT brings me recognition f...|        0.54|      0.29| 97|   0.38|    0.67| 95|  6.23| 0.000|   ***|
      |Not using ChatGPT is considered being... | ChatGPT has clear advantages compared...|        0.16|      0.03| 97|  -0.04|    0.35| 95|  1.59| 0.147|      |
      |Not using ChatGPT is considered being... | Using ChatGPT brings financial benefits.|        0.36|      0.13| 97|   0.18|    0.53| 95|  3.81| 0.001|   ***|
      |Not using ChatGPT is considered being... | Using ChatGPT is advantageous in many...|        0.13|      0.02| 97|  -0.07|    0.32| 95|  1.31| 0.234|      |
      |Not using ChatGPT is considered being... | Compared to other systems, using Chat...|        0.20|      0.04| 97|   0.00|    0.38| 95|  1.94| 0.079|     .|
      |Not using ChatGPT is considered being... |    Much can go wrong when using ChatGPT.|        0.10|      0.01| 97|  -0.11|    0.29| 95|  0.94| 0.405|      |
      |Not using ChatGPT is considered being... | There are legal issues with using Cha...|        0.33|      0.11| 97|   0.15|    0.50| 95|  3.46| 0.002|    **|
      |Not using ChatGPT is considered being... | The security of user data is not guar...|        0.29|      0.08| 97|   0.09|    0.46| 95|  2.91| 0.009|    **|
      |Not using ChatGPT is considered being... | Using ChatGPT could bring personal di...|        0.25|      0.06| 97|   0.06|    0.43| 95|  2.56| 0.021|     *|
      |Not using ChatGPT is considered being... | In my environment, using ChatGPT is s...|        0.48|      0.23| 97|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |Not using ChatGPT is considered being... | Almost everyone in my environment use...|        0.58|      0.33| 97|   0.43|    0.70| 95|  6.88| 0.000|   ***|
      |Not using ChatGPT is considered being... | Not using ChatGPT is considered being...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Not using ChatGPT is considered being... | Using ChatGPT brings me recognition f...|        0.56|      0.31| 97|   0.40|    0.68| 95|  6.53| 0.000|   ***|
      |Using ChatGPT brings me recognition f... | ChatGPT has clear advantages compared...|        0.27|      0.07| 97|   0.07|    0.44| 95|  2.68| 0.016|     *|
      |Using ChatGPT brings me recognition f... | Using ChatGPT brings financial benefits.|        0.40|      0.16| 97|   0.22|    0.55| 95|  4.25| 0.000|   ***|
      |Using ChatGPT brings me recognition f... | Using ChatGPT is advantageous in many...|        0.31|      0.10| 97|   0.12|    0.48| 95|  3.18| 0.004|    **|
      |Using ChatGPT brings me recognition f... | Compared to other systems, using Chat...|        0.36|      0.13| 97|   0.17|    0.52| 95|  3.72| 0.001|   ***|
      |Using ChatGPT brings me recognition f... |    Much can go wrong when using ChatGPT.|       -0.07|      0.01| 97|  -0.27|    0.13| 95| -0.73| 0.520|      |
      |Using ChatGPT brings me recognition f... | There are legal issues with using Cha...|        0.30|      0.09| 97|   0.11|    0.47| 95|  3.08| 0.006|    **|
      |Using ChatGPT brings me recognition f... | The security of user data is not guar...|        0.10|      0.01| 97|  -0.11|    0.29| 95|  0.93| 0.405|      |
      |Using ChatGPT brings me recognition f... | Using ChatGPT could bring personal di...|        0.14|      0.02| 97|  -0.06|    0.33| 95|  1.37| 0.212|      |
      |Using ChatGPT brings me recognition f... | In my environment, using ChatGPT is s...|        0.57|      0.33| 97|   0.42|    0.69| 95|  6.85| 0.000|   ***|
      |Using ChatGPT brings me recognition f... | Almost everyone in my environment use...|        0.54|      0.29| 97|   0.38|    0.67| 95|  6.23| 0.000|   ***|
      |Using ChatGPT brings me recognition f... | Not using ChatGPT is considered being...|        0.56|      0.31| 97|   0.40|    0.68| 95|  6.53| 0.000|   ***|
      |Using ChatGPT brings me recognition f... | Using ChatGPT brings me recognition f...|        1.00|      1.00| 97|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      
      n=97. 4 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_metrics_items_cor_items with two batteries

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"), metric = TRUE)
    Output
      
      
      |Expectations                             |                   Usage| Pearson's r| R-squared|  n| ci low| ci high| df|     t|     p| stars|
      |:----------------------------------------|-----------------------:|-----------:|---------:|--:|------:|-------:|--:|-----:|-----:|-----:|
      |ChatGPT has clear advantages compared... |      in private context|        0.50|      0.25| 97|   0.33|    0.63| 95|  5.60| 0.000|   ***|
      |ChatGPT has clear advantages compared... | in professional context|        0.28|      0.08| 97|   0.09|    0.46| 95|  2.86| 0.008|    **|
      |Using ChatGPT brings financial benefits. |      in private context|        0.21|      0.04| 97|   0.01|    0.39| 95|  2.04| 0.059|     .|
      |Using ChatGPT brings financial benefits. | in professional context|        0.54|      0.30| 97|   0.39|    0.67| 95|  6.31| 0.000|   ***|
      |Using ChatGPT is advantageous in many... |      in private context|        0.37|      0.13| 97|   0.18|    0.53| 95|  3.83| 0.000|   ***|
      |Using ChatGPT is advantageous in many... | in professional context|        0.37|      0.14| 97|   0.18|    0.53| 95|  3.86| 0.000|   ***|
      |Compared to other systems, using Chat... |      in private context|        0.47|      0.22| 97|   0.29|    0.61| 95|  5.13| 0.000|   ***|
      |Compared to other systems, using Chat... | in professional context|        0.29|      0.09| 97|   0.10|    0.47| 95|  2.99| 0.006|    **|
      |Much can go wrong when using ChatGPT.    |      in private context|       -0.24|      0.06| 97|  -0.42|   -0.04| 95| -2.41| 0.025|     *|
      |Much can go wrong when using ChatGPT.    | in professional context|       -0.09|      0.01| 97|  -0.28|    0.11| 95| -0.89| 0.417|      |
      |There are legal issues with using Cha... |      in private context|        0.08|      0.01| 97|  -0.12|    0.28| 95|  0.82| 0.431|      |
      |There are legal issues with using Cha... | in professional context|        0.31|      0.10| 97|   0.12|    0.48| 95|  3.17| 0.004|    **|
      |The security of user data is not guar... |      in private context|        0.02|      0.00| 97|  -0.18|    0.22| 95|  0.20| 0.844|      |
      |The security of user data is not guar... | in professional context|        0.20|      0.04| 97|   0.00|    0.39| 95|  2.01| 0.059|     .|
      |Using ChatGPT could bring personal di... |      in private context|       -0.09|      0.01| 97|  -0.28|    0.11| 95| -0.88| 0.417|      |
      |Using ChatGPT could bring personal di... | in professional context|        0.15|      0.02| 97|  -0.05|    0.34| 95|  1.49| 0.168|      |
      |In my environment, using ChatGPT is s... |      in private context|        0.40|      0.16| 97|   0.22|    0.55| 95|  4.24| 0.000|   ***|
      |In my environment, using ChatGPT is s... | in professional context|        0.58|      0.34| 97|   0.43|    0.70| 95|  6.96| 0.000|   ***|
      |Almost everyone in my environment use... |      in private context|        0.47|      0.23| 97|   0.30|    0.62| 95|  5.25| 0.000|   ***|
      |Almost everyone in my environment use... | in professional context|        0.55|      0.30| 97|   0.39|    0.67| 95|  6.37| 0.000|   ***|
      |Not using ChatGPT is considered being... |      in private context|        0.34|      0.11| 97|   0.15|    0.50| 95|  3.48| 0.001|    **|
      |Not using ChatGPT is considered being... | in professional context|        0.34|      0.12| 97|   0.15|    0.51| 95|  3.55| 0.001|    **|
      |Using ChatGPT brings me recognition f... |      in private context|        0.42|      0.18| 97|   0.24|    0.57| 95|  4.52| 0.000|   ***|
      |Using ChatGPT brings me recognition f... | in professional context|        0.46|      0.21| 97|   0.28|    0.60| 95|  4.99| 0.000|   ***|
      
      n=97. 4 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# effect_metrics_items_cor_items with spearman

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"), metric = TRUE, method = "spearman")
    Output
      
      
      |Expectations                             |                   Usage| Spearman's rho| R-squared|  n|         s|     p| stars|
      |:----------------------------------------|-----------------------:|--------------:|---------:|--:|---------:|-----:|-----:|
      |ChatGPT has clear advantages compared... |      in private context|           0.47|      0.22| 97|  80105.62| 0.000|   ***|
      |ChatGPT has clear advantages compared... | in professional context|           0.24|      0.06| 97| 114894.18| 0.024|     *|
      |Using ChatGPT brings financial benefits. |      in private context|           0.18|      0.03| 97| 125339.91| 0.107|      |
      |Using ChatGPT brings financial benefits. | in professional context|           0.53|      0.28| 97|  71997.69| 0.000|   ***|
      |Using ChatGPT is advantageous in many... |      in private context|           0.36|      0.13| 97|  97859.17| 0.001|   ***|
      |Using ChatGPT is advantageous in many... | in professional context|           0.33|      0.11| 97| 101547.31| 0.002|    **|
      |Compared to other systems, using Chat... |      in private context|           0.44|      0.19| 97|  85529.28| 0.000|   ***|
      |Compared to other systems, using Chat... | in professional context|           0.30|      0.09| 97| 105717.68| 0.005|    **|
      |Much can go wrong when using ChatGPT.    |      in private context|          -0.24|      0.06| 97| 188968.80| 0.024|     *|
      |Much can go wrong when using ChatGPT.    | in professional context|          -0.09|      0.01| 97| 165913.22| 0.410|      |
      |There are legal issues with using Cha... |      in private context|           0.04|      0.00| 97| 145699.50| 0.712|      |
      |There are legal issues with using Cha... | in professional context|           0.30|      0.09| 97| 106471.16| 0.005|    **|
      |The security of user data is not guar... |      in private context|           0.01|      0.00| 97| 150389.79| 0.913|      |
      |The security of user data is not guar... | in professional context|           0.19|      0.03| 97| 123831.76| 0.091|     .|
      |Using ChatGPT could bring personal di... |      in private context|          -0.16|      0.03| 97| 176795.22| 0.134|      |
      |Using ChatGPT could bring personal di... | in professional context|           0.13|      0.02| 97| 131790.50| 0.220|      |
      |In my environment, using ChatGPT is s... |      in private context|           0.34|      0.12| 97|  99693.66| 0.001|    **|
      |In my environment, using ChatGPT is s... | in professional context|           0.57|      0.33| 97|  65376.78| 0.000|   ***|
      |Almost everyone in my environment use... |      in private context|           0.42|      0.17| 97|  88556.31| 0.000|   ***|
      |Almost everyone in my environment use... | in professional context|           0.52|      0.27| 97|  72458.11| 0.000|   ***|
      |Not using ChatGPT is considered being... |      in private context|           0.26|      0.07| 97| 112179.86| 0.015|     *|
      |Not using ChatGPT is considered being... | in professional context|           0.30|      0.09| 97| 106146.02| 0.005|    **|
      |Using ChatGPT brings me recognition f... |      in private context|           0.36|      0.13| 97|  97537.93| 0.001|   ***|
      |Using ChatGPT brings me recognition f... | in professional context|           0.40|      0.16| 97|  90951.57| 0.000|   ***|
      
      n=97. 4 missing case(s) omitted. Adjusted significance p values with fdr method.
      

# Missing values are skipped in item batteries

    Code
      volker::effect_counts(data_with_missings, starts_with("f"))
    Output
      
      
      |Item | Gini coefficient|  n| Chi-squared|     p| stars|
      |:----|----------------:|--:|-----------:|-----:|-----:|
      |f1   |             0.00| 15|        0.00| 1.000|      |
      |f2   |             0.00| 15|        0.00| 1.000|      |
      |f3   |             0.00| 20|        0.00| 1.000|      |
      
      5 case(s) with missing values. Adjusted significance p values with fdr method.
      

---

    Code
      volker::effect_metrics(data_with_missings, starts_with("f"))
    Output
      
      
      |Item | skewness| kurtosis|    W|     p| stars|  normality|
      |:----|--------:|--------:|----:|-----:|-----:|----------:|
      |f1   |     0.00|    -1.69| 0.80| 0.006|    **| not normal|
      |f2   |     0.00|    -1.69| 0.80| 0.006|    **| not normal|
      |f3   |     0.00|    -1.52| 0.86| 0.009|    **| not normal|
      
      5 case(s) with missing values. Adjusted significance p values with fdr method.
      

# Missing values are skipped in single variables

    Code
      volker::effect_counts(data_with_missings, f1)
    Output
      
      
      |Statistic        | Value|
      |:----------------|-----:|
      |Gini coefficient |  0.00|
      |n                |    20|
      |Chi-squared      |  0.00|
      |p                | 1.000|
      |stars            |      |
      
      5 case(s) with missing values.
      

---

    Code
      volker::effect_metrics(data_with_missings, f1)
    Output
      
      
      |f1       | Value|
      |:--------|-----:|
      |skewness |  0.00|
      |kurtosis | -1.69|
      
      
      |Shapiro-Wilk normality test |      Value|
      |:---------------------------|----------:|
      |W                           |       0.80|
      |p                           |      0.004|
      |stars                       |         **|
      |normality                   | not normal|
      
      5 case(s) with missing values.
      

# Missing values are skipped in single variable comparisons

    Code
      suppressWarnings(volker::effect_counts(data_with_missings, f2, gr))
    Output
      
      
      |f2 | gr|  n| p_x| p_y| p_xy| ratio|  pmi| npmi| fisher_p| fisher_stars|
      |:--|--:|--:|---:|---:|----:|-----:|----:|----:|--------:|------------:|
      |2  |  B|  1| 0.2| 0.2|  0.2|  5.00| 2.32| 1.00|    0.500|             |
      |3  |  A|  1| 0.2| 0.6|  0.2|  1.67| 0.74| 0.32|    1.000|             |
      |4  |  A|  1| 0.2| 0.6|  0.2|  1.67| 0.74| 0.32|    1.000|             |
      |5  |   |  1| 0.2| 0.2|  0.2|  5.00| 2.32| 1.00|    0.500|             |
      |   |  A|  1| 0.2| 0.6|  0.2|  1.67| 0.74| 0.32|    1.000|             |
      
      Adjusted significance p values with fdr method.
      
      
      
      |Statistic   | Value|
      |:-----------|-----:|
      |Cramer's V  |      |
      |Chi-squared |   NaN|
      |n           |     3|
      |df          |     3|
      |p           |   NaN|
      |stars       |      |
      
      2 case(s) with missing values.
      

---

    Code
      volker::effect_metrics(data_with_missings, f2, gr)
    Output
      
      
      |Term          | estimate| ci low| ci high|   se|     t|     p| stars|
      |:-------------|--------:|------:|-------:|----:|-----:|-----:|-----:|
      |(Intercept)   |     3.50|  -2.85|    9.85| 0.50|  7.00| 0.181|      |
      |A (Reference) |         |       |        |     |      |      |      |
      |B             |    -1.50| -12.50|    9.50| 0.87| -1.73| 0.333|      |
      
      Adjusted significance p values with fdr method.
      
      
      
      |Statistic          | Value|
      |:------------------|-----:|
      |Adjusted R-squared |  0.50|
      |F                  |  3.00|
      |df                 |     1|
      |residual df        |     1|
      |p                  | 0.333|
      |stars              |      |
      
      2 case(s) with missing values.
      

# Missing values are skipped in single variable correlations

    Code
      volker::effect_metrics(data_with_missings, f1, f2, metric = TRUE)
    Output
      
      
      |Statistic   | value|
      |:-----------|-----:|
      |Pearson's r |  1.00|
      |R-squared   |  1.00|
      |n           |    18|
      |ci low      |  1.00|
      |ci high     |  1.00|
      |df          |    16|
      |t           |      |
      |p           | 0.000|
      |stars       |   ***|
      
      2 case(s) with missing values.
      

# Missing values are skipped in item correlations with another variable

    Code
      volker::effect_metrics(data_with_missings, starts_with("f"), gr, metric = TRUE)
    Output
      
      
      |item1 | Pearson's r| R-squared|  n| ci low| ci high| df|  t|     p| stars|
      |:-----|-----------:|---------:|--:|------:|-------:|--:|--:|-----:|-----:|
      |f1    |           1|         1|  5|      1|       1|  3|   | 0.000|   ***|
      |f2    |           1|         1|  4|      1|       1|  2|   | 0.000|   ***|
      |f3    |           1|         1|  3|       |        |  1|   | 0.000|   ***|
      
      n=6. 4 case(s) with missing values. Adjusted significance p values with fdr method.
      

# Missing values are skipped in item correlations with items

    Code
      volker::effect_metrics(data_with_missings, starts_with("f"), starts_with("g"),
      metric = TRUE)
    Output
      
      
      |item1 | item2| Pearson's r| R-squared|  n| ci low| ci high| df|  t|     p| stars|
      |:-----|-----:|-----------:|---------:|--:|------:|-------:|--:|--:|-----:|-----:|
      |f1    |    g1|           1|         1|  4|      1|       1|  2|   | 0.000|   ***|
      |f1    |    g2|           1|         1|  5|      1|       1|  3|   | 0.000|   ***|
      |f2    |    g1|           1|         1|  3|       |        |  1|   | 0.000|   ***|
      |f2    |    g2|           1|         1|  4|      1|       1|  2|   | 0.000|   ***|
      
      n=6. 4 case(s) with missing values. Adjusted significance p values with fdr method.
      

