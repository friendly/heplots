# idx_add is deprecated

    Code
      data %>% idx_add(tidyselect::starts_with("cg_adoption")) %>%
        tab_metrics_one_grouped(idx_cg_adoption, adopter)
    Condition
      Warning:
      `idx_add()` was deprecated in volker 3.0.0.
      i Please use `add_index()` instead.
    Output
      
      
      |Innovator type                           | min|  q1| median|  q3| max| mean|  sd|  n| items| alpha|
      |:----------------------------------------|---:|---:|------:|---:|---:|----:|---:|--:|-----:|-----:|
      |I try new offers immediately             | 1.5| 3.2|    3.3| 4.1| 5.0|  3.5| 0.9| 15|    12|  0.81|
      |I try new offers rather quickly          | 1.8| 2.5|    2.8| 3.1| 3.8|  2.8| 0.5| 61|    12|  0.81|
      |I wait until offers establish themselves | 1.0| 2.4|    2.7| 3.0| 3.8|  2.7| 0.6| 20|    12|  0.81|
      |I only use new offers when I have no ... | 2.4| 2.4|    2.4| 2.4| 2.4|  2.4|    |  1|    12|  0.81|
      |total                                    | 1.0| 2.4|    2.8| 3.2| 5.0|  2.9| 0.6| 97|    12|  0.81|
      
      n=97. 4 missing case(s) omitted.
      

# Index is calculated

    Code
      data %>% add_index(tidyselect::starts_with("cg_adoption")) %>%
        tab_metrics_one_grouped(idx_cg_adoption, adopter)
    Output
      
      
      |Innovator type                           | min|  q1| median|  q3| max| mean|  sd|  n| items| alpha|
      |:----------------------------------------|---:|---:|------:|---:|---:|----:|---:|--:|-----:|-----:|
      |I try new offers immediately             | 1.5| 3.2|    3.3| 4.1| 5.0|  3.5| 0.9| 15|    12|  0.81|
      |I try new offers rather quickly          | 1.8| 2.5|    2.8| 3.1| 3.8|  2.8| 0.5| 61|    12|  0.81|
      |I wait until offers establish themselves | 1.0| 2.4|    2.7| 3.0| 3.8|  2.7| 0.6| 20|    12|  0.81|
      |I only use new offers when I have no ... | 2.4| 2.4|    2.4| 2.4| 2.4|  2.4|    |  1|    12|  0.81|
      |total                                    | 1.0| 2.4|    2.8| 3.2| 5.0|  2.9| 0.6| 97|    12|  0.81|
      
      n=97. 4 missing case(s) omitted.
      

# Items are reversed

    Code
      dist_reversed
    Output
      
      
      |Index: cg_adoption_advantage_0 | value|
      |:------------------------------|-----:|
      |min                            |     1|
      |q1                             |     3|
      |median                         |   3.5|
      |q3                             |   3.8|
      |max                            |     5|
      |mean                           |   3.3|
      |sd                             |   0.8|
      |n                              |    99|
      |items                          |     4|
      |alpha                          |  0.79|
      
      n=99. 2 missing case(s) omitted.
      

---

    Code
      dist_unreversed
    Output
      
      
      |Index: cg_adoption_advantage_0 | value|
      |:------------------------------|-----:|
      |min                            |     1|
      |q1                             |   2.2|
      |median                         |   2.5|
      |q3                             |     3|
      |max                            |     5|
      |mean                           |   2.7|
      |sd                             |   0.8|
      |n                              |    99|
      |items                          |     4|
      |alpha                          |  0.79|
      
      n=99. 2 missing case(s) omitted.
      

# Missings are skipped

    Code
      data %>% add_index(tidyselect::starts_with("cg_adoption")) %>%
        tab_metrics_one_grouped(idx_cg_adoption, adopter)
    Output
      
      
      |Innovator type                           | min|  q1| median|  q3| max| mean|  sd|   n| items| alpha|
      |:----------------------------------------|---:|---:|------:|---:|---:|----:|---:|---:|-----:|-----:|
      |I try new offers immediately             | 1.5| 3.2|    3.3| 4.1| 5.0|  3.5| 0.9|  15|    12|  0.81|
      |I try new offers rather quickly          | 1.8| 2.5|    2.8| 3.1| 3.8|  2.8| 0.5|  63|    12|  0.81|
      |I wait until offers establish themselves | 1.0| 2.4|    2.8| 3.1| 3.8|  2.7| 0.6|  22|    12|  0.81|
      |I only use new offers when I have no ... | 2.4| 2.4|    2.4| 2.4| 2.4|  2.4|    |   1|    12|  0.81|
      |total                                    | 1.0| 2.5|    2.8| 3.2| 5.0|  2.9| 0.6| 101|    12|  0.81|
      
      n=101. 4 case(s) with missing values.
      

