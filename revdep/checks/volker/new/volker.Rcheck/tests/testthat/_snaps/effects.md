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
      
      
      |Statistic   | Value|
      |:-----------|-----:|
      |Cramer's V  |  0.05|
      |n           |   100|
      |Chi-squared |  0.20|
      |df          |     1|
      |p           | 0.651|
      |stars       |      |

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
      
      
      |Term                                              | estimate| ci low| ci high|    se|     t|     p| stars|
      |:-------------------------------------------------|--------:|------:|-------:|-----:|-----:|-----:|-----:|
      |(Intercept)                                       |    36.60|  29.55|   43.65|  3.55| 10.30| 0.000|   ***|
      |I try new offers immediately (Reference)          |         |       |        |      |      |      |      |
      |I try new offers rather quickly                   |     4.21|  -3.64|   12.06|  3.95|  1.06| 0.290|      |
      |I wait until offers establish themselves          |     1.17|  -7.97|   10.32|  4.61|  0.25| 0.800|      |
      |I only use new offers when I have no other choice |    19.40|  -8.81|   47.61| 14.21|  1.36| 0.175|      |
      
      
      |Statistic          | Value|
      |:------------------|-----:|
      |Adjusted R-squared |     0|
      |F                  |     1|
      |df                 |     3|
      |residual df        |    97|
      |p                  |   0.4|
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
      |R-squared   |  0.03|
      |n           |   101|
      |Pearson's r | -0.19|
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
      |R-squared   |  0.03|
      |n           |   101|
      |Pearson's r | -0.19|
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
      |R-squared      |      0.04|
      |n              |       101|
      |Spearman's rho |      -0.2|
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

# effect_metrics_items_cor with one variable

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"), sd_age,
      metric = TRUE)
    Output
      
      
      |Expectations: Correlation with Age                          | R-squared|  n| Pearson's r| ci low| ci high| df|     t|     p| stars|
      |:-----------------------------------------------------------|---------:|--:|-----------:|------:|-------:|--:|-----:|-----:|-----:|
      |ChatGPT has clear advantages compared to similar offerings. |      0.02| 97|       -0.12|  -0.32|    0.08| 95| -1.22| 0.227|      |
      |Using ChatGPT brings financial benefits.                    |      0.02| 97|       -0.13|  -0.32|    0.07| 95| -1.29| 0.200|      |
      |Using ChatGPT is advantageous in many tasks.                |      0.01| 97|       -0.09|  -0.28|    0.11| 95| -0.86| 0.393|      |
      |Compared to other systems, using ChatGPT is more fun.       |      0.01| 97|       -0.12|  -0.31|    0.08| 95| -1.15| 0.254|      |
      |Much can go wrong when using ChatGPT.                       |      0.03| 97|        0.18|  -0.02|    0.36| 95|  1.76| 0.082|     .|
      |There are legal issues with using ChatGPT.                  |      0.06| 97|        0.24|   0.05|    0.42| 95|  2.45| 0.016|     *|
      |The security of user data is not guaranteed with ChatGPT.   |      0.01| 97|       -0.10|  -0.29|    0.11| 95| -0.93| 0.354|      |
      |Using ChatGPT could bring personal disadvantages.           |      0.00| 97|        0.02|  -0.18|    0.22| 95|  0.20| 0.846|      |
      |In my environment, using ChatGPT is standard.               |      0.03| 97|       -0.17|  -0.36|    0.03| 95| -1.73| 0.087|     .|
      |Almost everyone in my environment uses ChatGPT.             |      0.00| 97|       -0.06|  -0.26|    0.14| 95| -0.59| 0.557|      |
      |Not using ChatGPT is considered being an outsider.          |      0.01| 97|        0.09|  -0.11|    0.28| 95|  0.87| 0.387|      |
      |Using ChatGPT brings me recognition from my environment.    |      0.00| 97|       -0.02|  -0.22|    0.18| 95| -0.22| 0.823|      |
      
      4 missing case(s) omitted.
      

# effect_metrics_items_cor with one variable and spearman

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"), sd_age,
      metric = TRUE, method = "spearman")
    Output
      
      
      |Expectations: Correlation with Age                          | R-squared|  n| Spearman's rho|         s|     p| stars|
      |:-----------------------------------------------------------|---------:|--:|--------------:|---------:|-----:|-----:|
      |ChatGPT has clear advantages compared to similar offerings. |      0.02| 97|          -0.14| 172811.45| 0.183|      |
      |Using ChatGPT brings financial benefits.                    |      0.02| 97|          -0.14| 173694.29| 0.165|      |
      |Using ChatGPT is advantageous in many tasks.                |      0.02| 97|          -0.13| 171301.35| 0.218|      |
      |Compared to other systems, using ChatGPT is more fun.       |      0.02| 97|          -0.14| 172970.04| 0.180|      |
      |Much can go wrong when using ChatGPT.                       |      0.03| 97|           0.17| 126186.26| 0.095|     .|
      |There are legal issues with using ChatGPT.                  |      0.07| 97|           0.26| 113310.65| 0.012|     *|
      |The security of user data is not guaranteed with ChatGPT.   |      0.01| 97|          -0.12| 170009.06| 0.251|      |
      |Using ChatGPT could bring personal disadvantages.           |      0.00| 97|           0.01| 151122.65| 0.950|      |
      |In my environment, using ChatGPT is standard.               |      0.03| 97|          -0.16| 177123.13| 0.107|      |
      |Almost everyone in my environment uses ChatGPT.             |      0.00| 97|          -0.07| 162382.67| 0.510|      |
      |Not using ChatGPT is considered being an outsider.          |      0.01| 97|           0.12| 133571.33| 0.235|      |
      |Using ChatGPT brings me recognition from my environment.    |      0.00| 97|          -0.01| 153072.54| 0.950|      |
      
      4 missing case(s) omitted.
      

# effect_metrics_items_cor with items

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("cg_adoption_"), metric = TRUE)
    Output
      
      
      |Item 1: Expectations                                        |                                        Item 2: Expectations| R-squared|  n| Pearson's r| ci low| ci high| df|     t|     p| stars|
      |:-----------------------------------------------------------|-----------------------------------------------------------:|---------:|--:|-----------:|------:|-------:|--:|-----:|-----:|-----:|
      |ChatGPT has clear advantages compared to similar offerings. | ChatGPT has clear advantages compared to similar offerings.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |ChatGPT has clear advantages compared to similar offerings. |                    Using ChatGPT brings financial benefits.|      0.14| 97|        0.37|   0.19|    0.53| 95|  3.91| 0.000|   ***|
      |ChatGPT has clear advantages compared to similar offerings. |                Using ChatGPT is advantageous in many tasks.|      0.41| 97|        0.64|   0.50|    0.74| 95|  8.04| 0.000|   ***|
      |ChatGPT has clear advantages compared to similar offerings. |       Compared to other systems, using ChatGPT is more fun.|      0.37| 97|        0.61|   0.47|    0.72| 95|  7.47| 0.000|   ***|
      |ChatGPT has clear advantages compared to similar offerings. |                       Much can go wrong when using ChatGPT.|      0.02| 97|       -0.14|  -0.33|    0.06| 95| -1.40| 0.166|      |
      |ChatGPT has clear advantages compared to similar offerings. |                  There are legal issues with using ChatGPT.|      0.04| 97|        0.19|  -0.01|    0.38| 95|  1.90| 0.061|     .|
      |ChatGPT has clear advantages compared to similar offerings. |   The security of user data is not guaranteed with ChatGPT.|      0.01| 97|        0.07|  -0.13|    0.27| 95|  0.71| 0.477|      |
      |ChatGPT has clear advantages compared to similar offerings. |           Using ChatGPT could bring personal disadvantages.|      0.00| 97|        0.01|  -0.19|    0.21| 95|  0.10| 0.924|      |
      |ChatGPT has clear advantages compared to similar offerings. |               In my environment, using ChatGPT is standard.|      0.04| 97|        0.21|   0.01|    0.39| 95|  2.07| 0.041|     *|
      |ChatGPT has clear advantages compared to similar offerings. |             Almost everyone in my environment uses ChatGPT.|      0.08| 97|        0.28|   0.08|    0.45| 95|  2.84| 0.006|    **|
      |ChatGPT has clear advantages compared to similar offerings. |          Not using ChatGPT is considered being an outsider.|      0.03| 97|        0.16|  -0.04|    0.35| 95|  1.59| 0.115|      |
      |ChatGPT has clear advantages compared to similar offerings. |    Using ChatGPT brings me recognition from my environment.|      0.07| 97|        0.27|   0.07|    0.44| 95|  2.68| 0.009|    **|
      |Using ChatGPT brings financial benefits.                    | ChatGPT has clear advantages compared to similar offerings.|      0.14| 97|        0.37|   0.19|    0.53| 95|  3.91| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |                    Using ChatGPT brings financial benefits.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |                Using ChatGPT is advantageous in many tasks.|      0.21| 97|        0.46|   0.29|    0.61| 95|  5.07| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |       Compared to other systems, using ChatGPT is more fun.|      0.18| 97|        0.42|   0.24|    0.57| 95|  4.55| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |                       Much can go wrong when using ChatGPT.|      0.00| 97|        0.02|  -0.18|    0.22| 95|  0.22| 0.830|      |
      |Using ChatGPT brings financial benefits.                    |                  There are legal issues with using ChatGPT.|      0.12| 97|        0.34|   0.15|    0.50| 95|  3.52| 0.001|   ***|
      |Using ChatGPT brings financial benefits.                    |   The security of user data is not guaranteed with ChatGPT.|      0.12| 97|        0.34|   0.15|    0.51| 95|  3.56| 0.001|   ***|
      |Using ChatGPT brings financial benefits.                    |           Using ChatGPT could bring personal disadvantages.|      0.05| 97|        0.22|   0.02|    0.40| 95|  2.20| 0.030|     *|
      |Using ChatGPT brings financial benefits.                    |               In my environment, using ChatGPT is standard.|      0.29| 97|        0.54|   0.38|    0.67| 95|  6.24| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |             Almost everyone in my environment uses ChatGPT.|      0.25| 97|        0.50|   0.34|    0.64| 95|  5.67| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |          Not using ChatGPT is considered being an outsider.|      0.13| 97|        0.36|   0.18|    0.53| 95|  3.81| 0.000|   ***|
      |Using ChatGPT brings financial benefits.                    |    Using ChatGPT brings me recognition from my environment.|      0.16| 97|        0.40|   0.22|    0.55| 95|  4.25| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                | ChatGPT has clear advantages compared to similar offerings.|      0.41| 97|        0.64|   0.50|    0.74| 95|  8.04| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                |                    Using ChatGPT brings financial benefits.|      0.21| 97|        0.46|   0.29|    0.61| 95|  5.07| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                |                Using ChatGPT is advantageous in many tasks.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                |       Compared to other systems, using ChatGPT is more fun.|      0.22| 97|        0.47|   0.30|    0.61| 95|  5.18| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                |                       Much can go wrong when using ChatGPT.|      0.01| 97|       -0.11|  -0.30|    0.09| 95| -1.10| 0.274|      |
      |Using ChatGPT is advantageous in many tasks.                |                  There are legal issues with using ChatGPT.|      0.04| 97|        0.19|  -0.01|    0.38| 95|  1.93| 0.056|     .|
      |Using ChatGPT is advantageous in many tasks.                |   The security of user data is not guaranteed with ChatGPT.|      0.00| 97|        0.06|  -0.14|    0.25| 95|  0.57| 0.573|      |
      |Using ChatGPT is advantageous in many tasks.                |           Using ChatGPT could bring personal disadvantages.|      0.01| 97|        0.09|  -0.11|    0.28| 95|  0.87| 0.385|      |
      |Using ChatGPT is advantageous in many tasks.                |               In my environment, using ChatGPT is standard.|      0.11| 97|        0.33|   0.14|    0.50| 95|  3.46| 0.001|   ***|
      |Using ChatGPT is advantageous in many tasks.                |             Almost everyone in my environment uses ChatGPT.|      0.11| 97|        0.34|   0.15|    0.50| 95|  3.51| 0.001|   ***|
      |Using ChatGPT is advantageous in many tasks.                |          Not using ChatGPT is considered being an outsider.|      0.02| 97|        0.13|  -0.07|    0.32| 95|  1.31| 0.195|      |
      |Using ChatGPT is advantageous in many tasks.                |    Using ChatGPT brings me recognition from my environment.|      0.10| 97|        0.31|   0.12|    0.48| 95|  3.18| 0.002|    **|
      |Compared to other systems, using ChatGPT is more fun.       | ChatGPT has clear advantages compared to similar offerings.|      0.37| 97|        0.61|   0.47|    0.72| 95|  7.47| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |                    Using ChatGPT brings financial benefits.|      0.18| 97|        0.42|   0.24|    0.57| 95|  4.55| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |                Using ChatGPT is advantageous in many tasks.|      0.22| 97|        0.47|   0.30|    0.61| 95|  5.18| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |       Compared to other systems, using ChatGPT is more fun.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |                       Much can go wrong when using ChatGPT.|      0.04| 97|       -0.19|  -0.38|    0.01| 95| -1.89| 0.062|     .|
      |Compared to other systems, using ChatGPT is more fun.       |                  There are legal issues with using ChatGPT.|      0.03| 97|        0.17|  -0.03|    0.36| 95|  1.66| 0.100|      |
      |Compared to other systems, using ChatGPT is more fun.       |   The security of user data is not guaranteed with ChatGPT.|      0.02| 97|        0.14|  -0.06|    0.33| 95|  1.40| 0.164|      |
      |Compared to other systems, using ChatGPT is more fun.       |           Using ChatGPT could bring personal disadvantages.|      0.00| 97|       -0.07|  -0.26|    0.13| 95| -0.66| 0.513|      |
      |Compared to other systems, using ChatGPT is more fun.       |               In my environment, using ChatGPT is standard.|      0.11| 97|        0.33|   0.14|    0.50| 95|  3.40| 0.001|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |             Almost everyone in my environment uses ChatGPT.|      0.07| 97|        0.26|   0.06|    0.43| 95|  2.60| 0.011|     *|
      |Compared to other systems, using ChatGPT is more fun.       |          Not using ChatGPT is considered being an outsider.|      0.04| 97|        0.20|   0.00|    0.38| 95|  1.94| 0.055|     .|
      |Compared to other systems, using ChatGPT is more fun.       |    Using ChatGPT brings me recognition from my environment.|      0.13| 97|        0.36|   0.17|    0.52| 95|  3.72| 0.000|   ***|
      |Much can go wrong when using ChatGPT.                       | ChatGPT has clear advantages compared to similar offerings.|      0.02| 97|       -0.14|  -0.33|    0.06| 95| -1.40| 0.166|      |
      |Much can go wrong when using ChatGPT.                       |                    Using ChatGPT brings financial benefits.|      0.00| 97|        0.02|  -0.18|    0.22| 95|  0.22| 0.830|      |
      |Much can go wrong when using ChatGPT.                       |                Using ChatGPT is advantageous in many tasks.|      0.01| 97|       -0.11|  -0.30|    0.09| 95| -1.10| 0.274|      |
      |Much can go wrong when using ChatGPT.                       |       Compared to other systems, using ChatGPT is more fun.|      0.04| 97|       -0.19|  -0.38|    0.01| 95| -1.89| 0.062|     .|
      |Much can go wrong when using ChatGPT.                       |                       Much can go wrong when using ChatGPT.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Much can go wrong when using ChatGPT.                       |                  There are legal issues with using ChatGPT.|      0.08| 97|        0.29|   0.09|    0.46| 95|  2.92| 0.004|    **|
      |Much can go wrong when using ChatGPT.                       |   The security of user data is not guaranteed with ChatGPT.|      0.13| 97|        0.36|   0.17|    0.52| 95|  3.74| 0.000|   ***|
      |Much can go wrong when using ChatGPT.                       |           Using ChatGPT could bring personal disadvantages.|      0.23| 97|        0.48|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |Much can go wrong when using ChatGPT.                       |               In my environment, using ChatGPT is standard.|      0.03| 97|       -0.19|  -0.37|    0.01| 95| -1.85| 0.068|     .|
      |Much can go wrong when using ChatGPT.                       |             Almost everyone in my environment uses ChatGPT.|      0.00| 97|        0.04|  -0.16|    0.23| 95|  0.35| 0.725|      |
      |Much can go wrong when using ChatGPT.                       |          Not using ChatGPT is considered being an outsider.|      0.01| 97|        0.10|  -0.11|    0.29| 95|  0.94| 0.350|      |
      |Much can go wrong when using ChatGPT.                       |    Using ChatGPT brings me recognition from my environment.|      0.01| 97|       -0.07|  -0.27|    0.13| 95| -0.73| 0.470|      |
      |There are legal issues with using ChatGPT.                  | ChatGPT has clear advantages compared to similar offerings.|      0.04| 97|        0.19|  -0.01|    0.38| 95|  1.90| 0.061|     .|
      |There are legal issues with using ChatGPT.                  |                    Using ChatGPT brings financial benefits.|      0.12| 97|        0.34|   0.15|    0.50| 95|  3.52| 0.001|   ***|
      |There are legal issues with using ChatGPT.                  |                Using ChatGPT is advantageous in many tasks.|      0.04| 97|        0.19|  -0.01|    0.38| 95|  1.93| 0.056|     .|
      |There are legal issues with using ChatGPT.                  |       Compared to other systems, using ChatGPT is more fun.|      0.03| 97|        0.17|  -0.03|    0.36| 95|  1.66| 0.100|      |
      |There are legal issues with using ChatGPT.                  |                       Much can go wrong when using ChatGPT.|      0.08| 97|        0.29|   0.09|    0.46| 95|  2.92| 0.004|    **|
      |There are legal issues with using ChatGPT.                  |                  There are legal issues with using ChatGPT.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |There are legal issues with using ChatGPT.                  |   The security of user data is not guaranteed with ChatGPT.|      0.15| 97|        0.38|   0.20|    0.54| 95|  4.06| 0.000|   ***|
      |There are legal issues with using ChatGPT.                  |           Using ChatGPT could bring personal disadvantages.|      0.08| 97|        0.28|   0.08|    0.45| 95|  2.83| 0.006|    **|
      |There are legal issues with using ChatGPT.                  |               In my environment, using ChatGPT is standard.|      0.05| 97|        0.23|   0.03|    0.41| 95|  2.28| 0.025|     *|
      |There are legal issues with using ChatGPT.                  |             Almost everyone in my environment uses ChatGPT.|      0.05| 97|        0.22|   0.02|    0.40| 95|  2.18| 0.031|     *|
      |There are legal issues with using ChatGPT.                  |          Not using ChatGPT is considered being an outsider.|      0.11| 97|        0.33|   0.15|    0.50| 95|  3.46| 0.001|   ***|
      |There are legal issues with using ChatGPT.                  |    Using ChatGPT brings me recognition from my environment.|      0.09| 97|        0.30|   0.11|    0.47| 95|  3.08| 0.003|    **|
      |The security of user data is not guaranteed with ChatGPT.   | ChatGPT has clear advantages compared to similar offerings.|      0.01| 97|        0.07|  -0.13|    0.27| 95|  0.71| 0.477|      |
      |The security of user data is not guaranteed with ChatGPT.   |                    Using ChatGPT brings financial benefits.|      0.12| 97|        0.34|   0.15|    0.51| 95|  3.56| 0.001|   ***|
      |The security of user data is not guaranteed with ChatGPT.   |                Using ChatGPT is advantageous in many tasks.|      0.00| 97|        0.06|  -0.14|    0.25| 95|  0.57| 0.573|      |
      |The security of user data is not guaranteed with ChatGPT.   |       Compared to other systems, using ChatGPT is more fun.|      0.02| 97|        0.14|  -0.06|    0.33| 95|  1.40| 0.164|      |
      |The security of user data is not guaranteed with ChatGPT.   |                       Much can go wrong when using ChatGPT.|      0.13| 97|        0.36|   0.17|    0.52| 95|  3.74| 0.000|   ***|
      |The security of user data is not guaranteed with ChatGPT.   |                  There are legal issues with using ChatGPT.|      0.15| 97|        0.38|   0.20|    0.54| 95|  4.06| 0.000|   ***|
      |The security of user data is not guaranteed with ChatGPT.   |   The security of user data is not guaranteed with ChatGPT.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |The security of user data is not guaranteed with ChatGPT.   |           Using ChatGPT could bring personal disadvantages.|      0.15| 97|        0.39|   0.21|    0.55| 95|  4.14| 0.000|   ***|
      |The security of user data is not guaranteed with ChatGPT.   |               In my environment, using ChatGPT is standard.|      0.00| 97|        0.06|  -0.14|    0.26| 95|  0.61| 0.544|      |
      |The security of user data is not guaranteed with ChatGPT.   |             Almost everyone in my environment uses ChatGPT.|      0.04| 97|        0.20|   0.00|    0.38| 95|  1.94| 0.055|     .|
      |The security of user data is not guaranteed with ChatGPT.   |          Not using ChatGPT is considered being an outsider.|      0.08| 97|        0.29|   0.09|    0.46| 95|  2.91| 0.005|    **|
      |The security of user data is not guaranteed with ChatGPT.   |    Using ChatGPT brings me recognition from my environment.|      0.01| 97|        0.10|  -0.11|    0.29| 95|  0.93| 0.354|      |
      |Using ChatGPT could bring personal disadvantages.           | ChatGPT has clear advantages compared to similar offerings.|      0.00| 97|        0.01|  -0.19|    0.21| 95|  0.10| 0.924|      |
      |Using ChatGPT could bring personal disadvantages.           |                    Using ChatGPT brings financial benefits.|      0.05| 97|        0.22|   0.02|    0.40| 95|  2.20| 0.030|     *|
      |Using ChatGPT could bring personal disadvantages.           |                Using ChatGPT is advantageous in many tasks.|      0.01| 97|        0.09|  -0.11|    0.28| 95|  0.87| 0.385|      |
      |Using ChatGPT could bring personal disadvantages.           |       Compared to other systems, using ChatGPT is more fun.|      0.00| 97|       -0.07|  -0.26|    0.13| 95| -0.66| 0.513|      |
      |Using ChatGPT could bring personal disadvantages.           |                       Much can go wrong when using ChatGPT.|      0.23| 97|        0.48|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |Using ChatGPT could bring personal disadvantages.           |                  There are legal issues with using ChatGPT.|      0.08| 97|        0.28|   0.08|    0.45| 95|  2.83| 0.006|    **|
      |Using ChatGPT could bring personal disadvantages.           |   The security of user data is not guaranteed with ChatGPT.|      0.15| 97|        0.39|   0.21|    0.55| 95|  4.14| 0.000|   ***|
      |Using ChatGPT could bring personal disadvantages.           |           Using ChatGPT could bring personal disadvantages.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Using ChatGPT could bring personal disadvantages.           |               In my environment, using ChatGPT is standard.|      0.06| 97|        0.25|   0.06|    0.43| 95|  2.54| 0.013|     *|
      |Using ChatGPT could bring personal disadvantages.           |             Almost everyone in my environment uses ChatGPT.|      0.05| 97|        0.22|   0.02|    0.40| 95|  2.23| 0.028|     *|
      |Using ChatGPT could bring personal disadvantages.           |          Not using ChatGPT is considered being an outsider.|      0.06| 97|        0.25|   0.06|    0.43| 95|  2.56| 0.012|     *|
      |Using ChatGPT could bring personal disadvantages.           |    Using ChatGPT brings me recognition from my environment.|      0.02| 97|        0.14|  -0.06|    0.33| 95|  1.37| 0.174|      |
      |In my environment, using ChatGPT is standard.               | ChatGPT has clear advantages compared to similar offerings.|      0.04| 97|        0.21|   0.01|    0.39| 95|  2.07| 0.041|     *|
      |In my environment, using ChatGPT is standard.               |                    Using ChatGPT brings financial benefits.|      0.29| 97|        0.54|   0.38|    0.67| 95|  6.24| 0.000|   ***|
      |In my environment, using ChatGPT is standard.               |                Using ChatGPT is advantageous in many tasks.|      0.11| 97|        0.33|   0.14|    0.50| 95|  3.46| 0.001|   ***|
      |In my environment, using ChatGPT is standard.               |       Compared to other systems, using ChatGPT is more fun.|      0.11| 97|        0.33|   0.14|    0.50| 95|  3.40| 0.001|   ***|
      |In my environment, using ChatGPT is standard.               |                       Much can go wrong when using ChatGPT.|      0.03| 97|       -0.19|  -0.37|    0.01| 95| -1.85| 0.068|     .|
      |In my environment, using ChatGPT is standard.               |                  There are legal issues with using ChatGPT.|      0.05| 97|        0.23|   0.03|    0.41| 95|  2.28| 0.025|     *|
      |In my environment, using ChatGPT is standard.               |   The security of user data is not guaranteed with ChatGPT.|      0.00| 97|        0.06|  -0.14|    0.26| 95|  0.61| 0.544|      |
      |In my environment, using ChatGPT is standard.               |           Using ChatGPT could bring personal disadvantages.|      0.06| 97|        0.25|   0.06|    0.43| 95|  2.54| 0.013|     *|
      |In my environment, using ChatGPT is standard.               |               In my environment, using ChatGPT is standard.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |In my environment, using ChatGPT is standard.               |             Almost everyone in my environment uses ChatGPT.|      0.54| 97|        0.73|   0.62|    0.81| 95| 10.47| 0.000|   ***|
      |In my environment, using ChatGPT is standard.               |          Not using ChatGPT is considered being an outsider.|      0.23| 97|        0.48|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |In my environment, using ChatGPT is standard.               |    Using ChatGPT brings me recognition from my environment.|      0.33| 97|        0.57|   0.42|    0.69| 95|  6.85| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             | ChatGPT has clear advantages compared to similar offerings.|      0.08| 97|        0.28|   0.08|    0.45| 95|  2.84| 0.006|    **|
      |Almost everyone in my environment uses ChatGPT.             |                    Using ChatGPT brings financial benefits.|      0.25| 97|        0.50|   0.34|    0.64| 95|  5.67| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             |                Using ChatGPT is advantageous in many tasks.|      0.11| 97|        0.34|   0.15|    0.50| 95|  3.51| 0.001|   ***|
      |Almost everyone in my environment uses ChatGPT.             |       Compared to other systems, using ChatGPT is more fun.|      0.07| 97|        0.26|   0.06|    0.43| 95|  2.60| 0.011|     *|
      |Almost everyone in my environment uses ChatGPT.             |                       Much can go wrong when using ChatGPT.|      0.00| 97|        0.04|  -0.16|    0.23| 95|  0.35| 0.725|      |
      |Almost everyone in my environment uses ChatGPT.             |                  There are legal issues with using ChatGPT.|      0.05| 97|        0.22|   0.02|    0.40| 95|  2.18| 0.031|     *|
      |Almost everyone in my environment uses ChatGPT.             |   The security of user data is not guaranteed with ChatGPT.|      0.04| 97|        0.20|   0.00|    0.38| 95|  1.94| 0.055|     .|
      |Almost everyone in my environment uses ChatGPT.             |           Using ChatGPT could bring personal disadvantages.|      0.05| 97|        0.22|   0.02|    0.40| 95|  2.23| 0.028|     *|
      |Almost everyone in my environment uses ChatGPT.             |               In my environment, using ChatGPT is standard.|      0.54| 97|        0.73|   0.62|    0.81| 95| 10.47| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             |             Almost everyone in my environment uses ChatGPT.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             |          Not using ChatGPT is considered being an outsider.|      0.33| 97|        0.58|   0.43|    0.70| 95|  6.88| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             |    Using ChatGPT brings me recognition from my environment.|      0.29| 97|        0.54|   0.38|    0.67| 95|  6.23| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          | ChatGPT has clear advantages compared to similar offerings.|      0.03| 97|        0.16|  -0.04|    0.35| 95|  1.59| 0.115|      |
      |Not using ChatGPT is considered being an outsider.          |                    Using ChatGPT brings financial benefits.|      0.13| 97|        0.36|   0.18|    0.53| 95|  3.81| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          |                Using ChatGPT is advantageous in many tasks.|      0.02| 97|        0.13|  -0.07|    0.32| 95|  1.31| 0.195|      |
      |Not using ChatGPT is considered being an outsider.          |       Compared to other systems, using ChatGPT is more fun.|      0.04| 97|        0.20|   0.00|    0.38| 95|  1.94| 0.055|     .|
      |Not using ChatGPT is considered being an outsider.          |                       Much can go wrong when using ChatGPT.|      0.01| 97|        0.10|  -0.11|    0.29| 95|  0.94| 0.350|      |
      |Not using ChatGPT is considered being an outsider.          |                  There are legal issues with using ChatGPT.|      0.11| 97|        0.33|   0.15|    0.50| 95|  3.46| 0.001|   ***|
      |Not using ChatGPT is considered being an outsider.          |   The security of user data is not guaranteed with ChatGPT.|      0.08| 97|        0.29|   0.09|    0.46| 95|  2.91| 0.005|    **|
      |Not using ChatGPT is considered being an outsider.          |           Using ChatGPT could bring personal disadvantages.|      0.06| 97|        0.25|   0.06|    0.43| 95|  2.56| 0.012|     *|
      |Not using ChatGPT is considered being an outsider.          |               In my environment, using ChatGPT is standard.|      0.23| 97|        0.48|   0.31|    0.62| 95|  5.34| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          |             Almost everyone in my environment uses ChatGPT.|      0.33| 97|        0.58|   0.43|    0.70| 95|  6.88| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          |          Not using ChatGPT is considered being an outsider.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          |    Using ChatGPT brings me recognition from my environment.|      0.31| 97|        0.56|   0.40|    0.68| 95|  6.53| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    | ChatGPT has clear advantages compared to similar offerings.|      0.07| 97|        0.27|   0.07|    0.44| 95|  2.68| 0.009|    **|
      |Using ChatGPT brings me recognition from my environment.    |                    Using ChatGPT brings financial benefits.|      0.16| 97|        0.40|   0.22|    0.55| 95|  4.25| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    |                Using ChatGPT is advantageous in many tasks.|      0.10| 97|        0.31|   0.12|    0.48| 95|  3.18| 0.002|    **|
      |Using ChatGPT brings me recognition from my environment.    |       Compared to other systems, using ChatGPT is more fun.|      0.13| 97|        0.36|   0.17|    0.52| 95|  3.72| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    |                       Much can go wrong when using ChatGPT.|      0.01| 97|       -0.07|  -0.27|    0.13| 95| -0.73| 0.470|      |
      |Using ChatGPT brings me recognition from my environment.    |                  There are legal issues with using ChatGPT.|      0.09| 97|        0.30|   0.11|    0.47| 95|  3.08| 0.003|    **|
      |Using ChatGPT brings me recognition from my environment.    |   The security of user data is not guaranteed with ChatGPT.|      0.01| 97|        0.10|  -0.11|    0.29| 95|  0.93| 0.354|      |
      |Using ChatGPT brings me recognition from my environment.    |           Using ChatGPT could bring personal disadvantages.|      0.02| 97|        0.14|  -0.06|    0.33| 95|  1.37| 0.174|      |
      |Using ChatGPT brings me recognition from my environment.    |               In my environment, using ChatGPT is standard.|      0.33| 97|        0.57|   0.42|    0.69| 95|  6.85| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    |             Almost everyone in my environment uses ChatGPT.|      0.29| 97|        0.54|   0.38|    0.67| 95|  6.23| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    |          Not using ChatGPT is considered being an outsider.|      0.31| 97|        0.56|   0.40|    0.68| 95|  6.53| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    |    Using ChatGPT brings me recognition from my environment.|      1.00| 97|        1.00|   1.00|    1.00| 95|   Inf| 0.000|   ***|
      
      4 missing case(s) omitted.
      

# effect_metrics_items_cor_items with two batteries

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"), metric = TRUE)
    Output
      
      
      |Expectations                                                |                   Usage| R-squared|  n| Pearson's r| ci low| ci high| df|     t|     p| stars|
      |:-----------------------------------------------------------|-----------------------:|---------:|--:|-----------:|------:|-------:|--:|-----:|-----:|-----:|
      |ChatGPT has clear advantages compared to similar offerings. |      in private context|      0.25| 97|        0.50|   0.33|    0.63| 95|  5.60| 0.000|   ***|
      |ChatGPT has clear advantages compared to similar offerings. | in professional context|      0.08| 97|        0.28|   0.09|    0.46| 95|  2.86| 0.005|    **|
      |Using ChatGPT brings financial benefits.                    |      in private context|      0.04| 97|        0.21|   0.01|    0.39| 95|  2.04| 0.044|     *|
      |Using ChatGPT brings financial benefits.                    | in professional context|      0.30| 97|        0.54|   0.39|    0.67| 95|  6.31| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                |      in private context|      0.13| 97|        0.37|   0.18|    0.53| 95|  3.83| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                | in professional context|      0.14| 97|        0.37|   0.18|    0.53| 95|  3.86| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |      in private context|      0.22| 97|        0.47|   0.29|    0.61| 95|  5.13| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       | in professional context|      0.09| 97|        0.29|   0.10|    0.47| 95|  2.99| 0.004|    **|
      |Much can go wrong when using ChatGPT.                       |      in private context|      0.06| 97|       -0.24|  -0.42|   -0.04| 95| -2.41| 0.018|     *|
      |Much can go wrong when using ChatGPT.                       | in professional context|      0.01| 97|       -0.09|  -0.28|    0.11| 95| -0.89| 0.378|      |
      |There are legal issues with using ChatGPT.                  |      in private context|      0.01| 97|        0.08|  -0.12|    0.28| 95|  0.82| 0.413|      |
      |There are legal issues with using ChatGPT.                  | in professional context|      0.10| 97|        0.31|   0.12|    0.48| 95|  3.17| 0.002|    **|
      |The security of user data is not guaranteed with ChatGPT.   |      in private context|      0.00| 97|        0.02|  -0.18|    0.22| 95|  0.20| 0.844|      |
      |The security of user data is not guaranteed with ChatGPT.   | in professional context|      0.04| 97|        0.20|   0.00|    0.39| 95|  2.01| 0.047|     *|
      |Using ChatGPT could bring personal disadvantages.           |      in private context|      0.01| 97|       -0.09|  -0.28|    0.11| 95| -0.88| 0.382|      |
      |Using ChatGPT could bring personal disadvantages.           | in professional context|      0.02| 97|        0.15|  -0.05|    0.34| 95|  1.49| 0.140|      |
      |In my environment, using ChatGPT is standard.               |      in private context|      0.16| 97|        0.40|   0.22|    0.55| 95|  4.24| 0.000|   ***|
      |In my environment, using ChatGPT is standard.               | in professional context|      0.34| 97|        0.58|   0.43|    0.70| 95|  6.96| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             |      in private context|      0.23| 97|        0.47|   0.30|    0.62| 95|  5.25| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             | in professional context|      0.30| 97|        0.55|   0.39|    0.67| 95|  6.37| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          |      in private context|      0.11| 97|        0.34|   0.15|    0.50| 95|  3.48| 0.001|   ***|
      |Not using ChatGPT is considered being an outsider.          | in professional context|      0.12| 97|        0.34|   0.15|    0.51| 95|  3.55| 0.001|   ***|
      |Using ChatGPT brings me recognition from my environment.    |      in private context|      0.18| 97|        0.42|   0.24|    0.57| 95|  4.52| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    | in professional context|      0.21| 97|        0.46|   0.28|    0.60| 95|  4.99| 0.000|   ***|
      
      4 missing case(s) omitted.
      

# effect_metrics_items_cor_items with spearman

    Code
      volker::effect_metrics(data, tidyselect::starts_with("cg_adoption_"),
      tidyselect::starts_with("use_"), metric = TRUE, method = "spearman")
    Output
      
      
      |Expectations                                                |                   Usage| R-squared|  n| Spearman's rho|         s|     p| stars|
      |:-----------------------------------------------------------|-----------------------:|---------:|--:|--------------:|---------:|-----:|-----:|
      |ChatGPT has clear advantages compared to similar offerings. |      in private context|      0.22| 97|           0.47|  80105.62| 0.000|   ***|
      |ChatGPT has clear advantages compared to similar offerings. | in professional context|      0.06| 97|           0.24| 114894.18| 0.016|     *|
      |Using ChatGPT brings financial benefits.                    |      in private context|      0.03| 97|           0.18| 125339.91| 0.085|     .|
      |Using ChatGPT brings financial benefits.                    | in professional context|      0.28| 97|           0.53|  71997.69| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                |      in private context|      0.13| 97|           0.36|  97859.17| 0.000|   ***|
      |Using ChatGPT is advantageous in many tasks.                | in professional context|      0.11| 97|           0.33| 101547.31| 0.001|   ***|
      |Compared to other systems, using ChatGPT is more fun.       |      in private context|      0.19| 97|           0.44|  85529.28| 0.000|   ***|
      |Compared to other systems, using ChatGPT is more fun.       | in professional context|      0.09| 97|           0.30| 105717.68| 0.002|    **|
      |Much can go wrong when using ChatGPT.                       |      in private context|      0.06| 97|          -0.24| 188968.80| 0.017|     *|
      |Much can go wrong when using ChatGPT.                       | in professional context|      0.01| 97|          -0.09| 165913.22| 0.376|      |
      |There are legal issues with using ChatGPT.                  |      in private context|      0.00| 97|           0.04| 145699.50| 0.683|      |
      |There are legal issues with using ChatGPT.                  | in professional context|      0.09| 97|           0.30| 106471.16| 0.003|    **|
      |The security of user data is not guaranteed with ChatGPT.   |      in private context|      0.00| 97|           0.01| 150389.79| 0.913|      |
      |The security of user data is not guaranteed with ChatGPT.   | in professional context|      0.03| 97|           0.19| 123831.76| 0.068|     .|
      |Using ChatGPT could bring personal disadvantages.           |      in private context|      0.03| 97|          -0.16| 176795.22| 0.112|      |
      |Using ChatGPT could bring personal disadvantages.           | in professional context|      0.02| 97|           0.13| 131790.50| 0.192|      |
      |In my environment, using ChatGPT is standard.               |      in private context|      0.12| 97|           0.34|  99693.66| 0.001|   ***|
      |In my environment, using ChatGPT is standard.               | in professional context|      0.33| 97|           0.57|  65376.78| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             |      in private context|      0.17| 97|           0.42|  88556.31| 0.000|   ***|
      |Almost everyone in my environment uses ChatGPT.             | in professional context|      0.27| 97|           0.52|  72458.11| 0.000|   ***|
      |Not using ChatGPT is considered being an outsider.          |      in private context|      0.07| 97|           0.26| 112179.86| 0.009|    **|
      |Not using ChatGPT is considered being an outsider.          | in professional context|      0.09| 97|           0.30| 106146.02| 0.003|    **|
      |Using ChatGPT brings me recognition from my environment.    |      in private context|      0.13| 97|           0.36|  97537.93| 0.000|   ***|
      |Using ChatGPT brings me recognition from my environment.    | in professional context|      0.16| 97|           0.40|  90951.57| 0.000|   ***|
      
      4 missing case(s) omitted.
      

