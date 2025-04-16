# Labels are retrieved

    Code
      print(volker::codebook(data), n = Inf)
    Output
      # A tibble: 94 x 6
         item_name             item_group item_class item_label value_name value_label
         <chr>                 <chr>      <chr>      <chr>      <chr>      <chr>      
       1 case                  case       numeric    case       <NA>       <NA>       
       2 sd_age                sd         numeric    Age        <NA>       <NA>       
       3 cg_activities         cg         character  Activitie~ <NA>       <NA>       
       4 adopter               adopter    factor     Innovator~ I try new~ I try new ~
       5 adopter               adopter    factor     Innovator~ I try new~ I try new ~
       6 adopter               adopter    factor     Innovator~ I wait un~ I wait unt~
       7 adopter               adopter    factor     Innovator~ I only us~ I only use~
       8 adopter               adopter    factor     Innovator~ [no answe~ [no answer]
       9 sd_gender             sd         factor     Gender     female     female     
      10 sd_gender             sd         factor     Gender     male       male       
      11 sd_gender             sd         factor     Gender     diverse    diverse    
      12 sd_gender             sd         factor     Gender     [no answe~ [no answer]
      13 use_private           use        numeric    Usage: in~ 1          never      
      14 use_private           use        numeric    Usage: in~ 2          rarely     
      15 use_private           use        numeric    Usage: in~ 3          several ti~
      16 use_private           use        numeric    Usage: in~ 4          several ti~
      17 use_private           use        numeric    Usage: in~ 5          almost dai~
      18 use_work              use        numeric    Usage: in~ 1          never      
      19 use_work              use        numeric    Usage: in~ 2          rarely     
      20 use_work              use        numeric    Usage: in~ 3          several ti~
      21 use_work              use        numeric    Usage: in~ 4          several ti~
      22 use_work              use        numeric    Usage: in~ 5          almost dai~
      23 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      24 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      25 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      26 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      27 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      28 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      29 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      30 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      31 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      32 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      33 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      34 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      35 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      36 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      37 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      38 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      39 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      40 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      41 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      42 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      43 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      44 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      45 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      46 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      47 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      48 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      49 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      50 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      51 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      52 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      53 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      54 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      55 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      56 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      57 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      58 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      59 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      60 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      61 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      62 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      63 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      64 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      65 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      66 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      67 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      68 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      69 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      70 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      71 cg_adoption_social_01 cg         numeric    Expectati~ 1          strongly d~
      72 cg_adoption_social_01 cg         numeric    Expectati~ 2          disagree   
      73 cg_adoption_social_01 cg         numeric    Expectati~ 3          neutral    
      74 cg_adoption_social_01 cg         numeric    Expectati~ 4          agree      
      75 cg_adoption_social_01 cg         numeric    Expectati~ 5          strongly a~
      76 cg_adoption_social_01 cg         numeric    Expectati~ -9         [no answer]
      77 cg_adoption_social_02 cg         numeric    Expectati~ 1          strongly d~
      78 cg_adoption_social_02 cg         numeric    Expectati~ 2          disagree   
      79 cg_adoption_social_02 cg         numeric    Expectati~ 3          neutral    
      80 cg_adoption_social_02 cg         numeric    Expectati~ 4          agree      
      81 cg_adoption_social_02 cg         numeric    Expectati~ 5          strongly a~
      82 cg_adoption_social_02 cg         numeric    Expectati~ -9         [no answer]
      83 cg_adoption_social_03 cg         numeric    Expectati~ 1          strongly d~
      84 cg_adoption_social_03 cg         numeric    Expectati~ 2          disagree   
      85 cg_adoption_social_03 cg         numeric    Expectati~ 3          neutral    
      86 cg_adoption_social_03 cg         numeric    Expectati~ 4          agree      
      87 cg_adoption_social_03 cg         numeric    Expectati~ 5          strongly a~
      88 cg_adoption_social_03 cg         numeric    Expectati~ -9         [no answer]
      89 cg_adoption_social_04 cg         numeric    Expectati~ 1          strongly d~
      90 cg_adoption_social_04 cg         numeric    Expectati~ 2          disagree   
      91 cg_adoption_social_04 cg         numeric    Expectati~ 3          neutral    
      92 cg_adoption_social_04 cg         numeric    Expectati~ 4          agree      
      93 cg_adoption_social_04 cg         numeric    Expectati~ 5          strongly a~
      94 cg_adoption_social_04 cg         numeric    Expectati~ -9         [no answer]

# Missing labels make no trouble

    Code
      .
    Output
      # A tibble: 12 x 6
         item_name             item_group item_class item_label value_label value_name
         <chr>                 <chr>      <chr>      <chr>      <lgl>       <lgl>     
       1 cg_adoption_advantag~ cg         numeric    cg_adopti~ NA          NA        
       2 cg_adoption_advantag~ cg         numeric    cg_adopti~ NA          NA        
       3 cg_adoption_advantag~ cg         numeric    cg_adopti~ NA          NA        
       4 cg_adoption_advantag~ cg         numeric    cg_adopti~ NA          NA        
       5 cg_adoption_fearofus~ cg         numeric    cg_adopti~ NA          NA        
       6 cg_adoption_fearofus~ cg         numeric    cg_adopti~ NA          NA        
       7 cg_adoption_fearofus~ cg         numeric    cg_adopti~ NA          NA        
       8 cg_adoption_fearofus~ cg         numeric    cg_adopti~ NA          NA        
       9 cg_adoption_social_01 cg         numeric    cg_adopti~ NA          NA        
      10 cg_adoption_social_02 cg         numeric    cg_adopti~ NA          NA        
      11 cg_adoption_social_03 cg         numeric    cg_adopti~ NA          NA        
      12 cg_adoption_social_04 cg         numeric    cg_adopti~ NA          NA        

# Store and clear the codebook

    Code
      data %>% volker::labs_store() %>% volker::labs_clear() %>% codebook() %>% print(
        n = Inf)
    Output
      # A tibble: 26 x 6
         item_name             item_group item_class item_label value_name value_label
         <chr>                 <chr>      <chr>      <chr>      <chr>      <chr>      
       1 case                  case       numeric    case       <NA>       <NA>       
       2 use_private           use        numeric    use_priva~ <NA>       <NA>       
       3 use_work              use        numeric    use_work   <NA>       <NA>       
       4 cg_adoption_advantag~ cg         numeric    cg_adopti~ <NA>       <NA>       
       5 cg_adoption_advantag~ cg         numeric    cg_adopti~ <NA>       <NA>       
       6 cg_adoption_advantag~ cg         numeric    cg_adopti~ <NA>       <NA>       
       7 cg_adoption_advantag~ cg         numeric    cg_adopti~ <NA>       <NA>       
       8 cg_adoption_fearofus~ cg         numeric    cg_adopti~ <NA>       <NA>       
       9 cg_adoption_fearofus~ cg         numeric    cg_adopti~ <NA>       <NA>       
      10 cg_adoption_fearofus~ cg         numeric    cg_adopti~ <NA>       <NA>       
      11 cg_adoption_fearofus~ cg         numeric    cg_adopti~ <NA>       <NA>       
      12 cg_adoption_social_01 cg         numeric    cg_adopti~ <NA>       <NA>       
      13 cg_adoption_social_02 cg         numeric    cg_adopti~ <NA>       <NA>       
      14 cg_adoption_social_03 cg         numeric    cg_adopti~ <NA>       <NA>       
      15 cg_adoption_social_04 cg         numeric    cg_adopti~ <NA>       <NA>       
      16 sd_age                sd         numeric    sd_age     <NA>       <NA>       
      17 cg_activities         cg         character  cg_activi~ <NA>       <NA>       
      18 adopter               adopter    factor     adopter    I try new~ I try new ~
      19 adopter               adopter    factor     adopter    I try new~ I try new ~
      20 adopter               adopter    factor     adopter    I wait un~ I wait unt~
      21 adopter               adopter    factor     adopter    I only us~ I only use~
      22 adopter               adopter    factor     adopter    [no answe~ [no answer]
      23 sd_gender             sd         factor     sd_gender  female     female     
      24 sd_gender             sd         factor     sd_gender  male       male       
      25 sd_gender             sd         factor     sd_gender  diverse    diverse    
      26 sd_gender             sd         factor     sd_gender  [no answe~ [no answer]

# Store, clear and restore the codebook

    Code
      data %>% volker::labs_store() %>% volker::labs_clear() %>% volker::labs_restore() %>%
        codebook() %>% print(n = Inf)
    Output
      # A tibble: 94 x 6
         item_name             item_group item_class item_label value_name value_label
         <chr>                 <chr>      <chr>      <chr>      <chr>      <chr>      
       1 case                  case       numeric    case       <NA>       <NA>       
       2 sd_age                sd         numeric    Age        <NA>       <NA>       
       3 cg_activities         cg         character  Activitie~ <NA>       <NA>       
       4 adopter               adopter    factor     Innovator~ I try new~ I try new ~
       5 adopter               adopter    factor     Innovator~ I try new~ I try new ~
       6 adopter               adopter    factor     Innovator~ I wait un~ I wait unt~
       7 adopter               adopter    factor     Innovator~ I only us~ I only use~
       8 adopter               adopter    factor     Innovator~ [no answe~ [no answer]
       9 sd_gender             sd         factor     Gender     female     female     
      10 sd_gender             sd         factor     Gender     male       male       
      11 sd_gender             sd         factor     Gender     diverse    diverse    
      12 sd_gender             sd         factor     Gender     [no answe~ [no answer]
      13 use_private           use        numeric    Usage: in~ 1          never      
      14 use_private           use        numeric    Usage: in~ 2          rarely     
      15 use_private           use        numeric    Usage: in~ 3          several ti~
      16 use_private           use        numeric    Usage: in~ 4          several ti~
      17 use_private           use        numeric    Usage: in~ 5          almost dai~
      18 use_work              use        numeric    Usage: in~ 1          never      
      19 use_work              use        numeric    Usage: in~ 2          rarely     
      20 use_work              use        numeric    Usage: in~ 3          several ti~
      21 use_work              use        numeric    Usage: in~ 4          several ti~
      22 use_work              use        numeric    Usage: in~ 5          almost dai~
      23 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      24 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      25 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      26 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      27 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      28 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      29 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      30 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      31 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      32 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      33 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      34 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      35 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      36 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      37 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      38 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      39 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      40 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      41 cg_adoption_advantag~ cg         numeric    Expectati~ 1          strongly d~
      42 cg_adoption_advantag~ cg         numeric    Expectati~ 2          disagree   
      43 cg_adoption_advantag~ cg         numeric    Expectati~ 3          neutral    
      44 cg_adoption_advantag~ cg         numeric    Expectati~ 4          agree      
      45 cg_adoption_advantag~ cg         numeric    Expectati~ 5          strongly a~
      46 cg_adoption_advantag~ cg         numeric    Expectati~ -9         [no answer]
      47 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      48 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      49 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      50 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      51 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      52 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      53 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      54 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      55 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      56 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      57 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      58 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      59 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      60 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      61 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      62 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      63 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      64 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      65 cg_adoption_fearofus~ cg         numeric    Expectati~ 1          strongly d~
      66 cg_adoption_fearofus~ cg         numeric    Expectati~ 2          disagree   
      67 cg_adoption_fearofus~ cg         numeric    Expectati~ 3          neutral    
      68 cg_adoption_fearofus~ cg         numeric    Expectati~ 4          agree      
      69 cg_adoption_fearofus~ cg         numeric    Expectati~ 5          strongly a~
      70 cg_adoption_fearofus~ cg         numeric    Expectati~ -9         [no answer]
      71 cg_adoption_social_01 cg         numeric    Expectati~ 1          strongly d~
      72 cg_adoption_social_01 cg         numeric    Expectati~ 2          disagree   
      73 cg_adoption_social_01 cg         numeric    Expectati~ 3          neutral    
      74 cg_adoption_social_01 cg         numeric    Expectati~ 4          agree      
      75 cg_adoption_social_01 cg         numeric    Expectati~ 5          strongly a~
      76 cg_adoption_social_01 cg         numeric    Expectati~ -9         [no answer]
      77 cg_adoption_social_02 cg         numeric    Expectati~ 1          strongly d~
      78 cg_adoption_social_02 cg         numeric    Expectati~ 2          disagree   
      79 cg_adoption_social_02 cg         numeric    Expectati~ 3          neutral    
      80 cg_adoption_social_02 cg         numeric    Expectati~ 4          agree      
      81 cg_adoption_social_02 cg         numeric    Expectati~ 5          strongly a~
      82 cg_adoption_social_02 cg         numeric    Expectati~ -9         [no answer]
      83 cg_adoption_social_03 cg         numeric    Expectati~ 1          strongly d~
      84 cg_adoption_social_03 cg         numeric    Expectati~ 2          disagree   
      85 cg_adoption_social_03 cg         numeric    Expectati~ 3          neutral    
      86 cg_adoption_social_03 cg         numeric    Expectati~ 4          agree      
      87 cg_adoption_social_03 cg         numeric    Expectati~ 5          strongly a~
      88 cg_adoption_social_03 cg         numeric    Expectati~ -9         [no answer]
      89 cg_adoption_social_04 cg         numeric    Expectati~ 1          strongly d~
      90 cg_adoption_social_04 cg         numeric    Expectati~ 2          disagree   
      91 cg_adoption_social_04 cg         numeric    Expectati~ 3          neutral    
      92 cg_adoption_social_04 cg         numeric    Expectati~ 4          agree      
      93 cg_adoption_social_04 cg         numeric    Expectati~ 5          strongly a~
      94 cg_adoption_social_04 cg         numeric    Expectati~ -9         [no answer]

# Item values are replaced and keep their order

    Code
      levels(dplyr::pull(volker:::labs_replace(dplyr::select(data, adopter), adopter,
      volker::codebook(data, adopter)), adopter))
    Output
      [1] "I try new offers immediately"                     
      [2] "I try new offers rather quickly"                  
      [3] "I wait until offers establish themselves"         
      [4] "I only use new offers when I have no other choice"

---

    Code
      levels(dplyr::pull(volker:::labs_replace(dplyr::mutate(dplyr::select(data,
        adopter), adopter = as.character(adopter)), adopter, volker::codebook(data,
        adopter)), adopter))
    Output
      [1] "I try new offers immediately"                     
      [2] "I try new offers rather quickly"                  
      [3] "I wait until offers establish themselves"         
      [4] "I only use new offers when I have no other choice"

# Item values are kept even if they are not in the codebook

    Code
      dplyr::arrange(volker:::labs_replace(dplyr::mutate(dplyr::distinct(data, from = use_private),
      to = from), to, codes), to)
    Output
      # A tibble: 5 x 2
         from to          
        <dbl> <fct>       
      1     1 never       
      2     2 2           
      3     3 3           
      4     4 4           
      5     5 almost daily

# The column title is kept when values are replaced

    Code
      tab_counts(df, values)
    Output
      
      
      |VALS  |  n|    p|
      |:-----|--:|----:|
      |1     |  1|  33%|
      |2     |  1|  33%|
      |3     |  1|  33%|
      |total |  3| 100%|
      
      n=3.
      

# A common prefix is removed from labels

    Code
      get_prefix(dplyr::pull(codebook(dplyr::select(data, starts_with("use"))),
      item_label))
    Output
      [1] "Usage"

---

    Code
      trim_prefix(dplyr::pull(codebook(dplyr::select(data, starts_with("use"))),
      item_label))
    Output
       [1] "in private context"      "in private context"     
       [3] "in private context"      "in private context"     
       [5] "in private context"      "in professional context"
       [7] "in professional context" "in professional context"
       [9] "in professional context" "in professional context"

# Numeric values are relabeled

    Code
      data %>% labs_apply(cols = starts_with("cg_adoption_advantage"), values = list(
        `1` = "Stimme überhaupt nicht zu", `2` = "Stimme nicht zu", `3` = "Unentschieden",
        `4` = "Stimme zu", `5` = "Stimme voll und ganz zu")) %>% tab_counts(
        starts_with("cg_adoption_advantage"))
    Output
      
      
      |Expectations                                                | Stimme überhaupt nicht zu| Stimme nicht zu| Unentschieden| Stimme zu| Stimme voll und ganz zu|     total|
      |:-----------------------------------------------------------|-------------------------:|---------------:|-------------:|---------:|-----------------------:|---------:|
      |ChatGPT has clear advantages compared to similar offerings. |                    6% (6)|          8% (8)|      34% (34)|  37% (37)|                14% (14)| 100% (99)|
      |Using ChatGPT brings financial benefits.                    |                  22% (22)|        21% (21)|      29% (29)|  21% (21)|                  6% (6)| 100% (99)|
      |Using ChatGPT is advantageous in many tasks.                |                    6% (6)|        10% (10)|      21% (21)|  45% (45)|                17% (17)| 100% (99)|
      |Compared to other systems, using ChatGPT is more fun.       |                    6% (6)|          4% (4)|      35% (35)|  39% (39)|                15% (15)| 100% (99)|
      
      2 missing case(s) omitted.
      

# Factor values are relabeled

    Code
      tab_counts(data %>% labs_apply(cols = sd_gender, values = list(female = "Weiblich",
        male = "Männlich", diverse = "Divers")), sd_gender)
    Output
      
      
      |Gender   |   n|    p|
      |:--------|---:|----:|
      |Weiblich |  40|  40%|
      |Männlich |  60|  59%|
      |Divers   |   1|   1%|
      |total    | 101| 100%|
      
      n=101.
      

# Elliptical numeric values are relabeled

    Code
      codebook(testdata %>% labs_apply(cols = use_private, values = list(`1` = "never",
        `2` = "2", `3` = "3", `4` = "4", `5` = "almost daily")), use_private)
    Output
      # A tibble: 5 x 6
        item_name   item_group item_class item_label            value_name value_label
        <chr>       <chr>      <chr>      <chr>                 <chr>      <chr>      
      1 use_private use        numeric    Usage: in private co~ 1          never      
      2 use_private use        numeric    Usage: in private co~ 2          2          
      3 use_private use        numeric    Usage: in private co~ 3          3          
      4 use_private use        numeric    Usage: in private co~ 4          4          
      5 use_private use        numeric    Usage: in private co~ 5          almost dai~

# Labels are wrapped at whitespace and slashes

    "Super\nlong/\nshort\nlabel\\\ns"

