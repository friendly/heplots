# Clusters are added

    Code
      volker::cluster_tab(data, cls_item)
    Output
      
      
      |item |       total| Cluster 1|  Cluster 2|
      |:----|-----------:|---------:|----------:|
      |1    | 15.7 (10.5)| 5.5 (3.0)| 25.0 (3.3)|
      |2    | 15.7 (10.5)| 5.5 (3.0)| 25.0 (3.3)|
      |n    |          21|        10|         11|
      
      n=21.
      
      
      
      |Cluster   |  n|    p|
      |:---------|--:|----:|
      |Cluster 1 | 10|  48%|
      |Cluster 2 | 11|  52%|
      |total     | 21| 100%|
      
      n=21.
      
      
      
      |Statistic                      | Value|
      |:------------------------------|-----:|
      |Within-Cluster Sum of Squares  |  3.53|
      |Between-Cluster Sum of Squares | 36.47|
      
      Within-Cluster Sum of Squares for Scree Plot
      
      |Clusters k |  WSS|
      |:----------|----:|
      |1          | 40.0|
      |2          |  3.5|
      |3          |  2.4|
      |4          |  2.2|
      |5          |  1.6|
      |6          |  0.4|
      |7          |  0.3|
      |8          |  0.3|
      |9          |  0.2|
      |10         |  0.2|
      
      Automatically selected k=2 by the elbow criterion.
      

# Clusters with missings are added

    Code
      volker::cluster_tab(data_with_missings, cls_item)
    Output
      
      
      |item |      total| Cluster 1|  Cluster 2|
      |:----|----------:|---------:|----------:|
      |1    | 14.3 (9.9)| 5.5 (3.0)| 24.0 (2.7)|
      |2    | 14.3 (9.9)| 5.5 (3.0)| 24.0 (2.7)|
      |n    |         19|        10|          9|
      
      n=19. 2 missing case(s) omitted.
      
      
      
      |Cluster   |  n|    p|
      |:---------|--:|----:|
      |Cluster 1 | 10|  53%|
      |Cluster 2 |  9|  47%|
      |total     | 19| 100%|
      
      n=19.
      
      
      
      |Statistic                      | Value|
      |:------------------------------|-----:|
      |Within-Cluster Sum of Squares  |  2.91|
      |Between-Cluster Sum of Squares | 33.09|
      
      Within-Cluster Sum of Squares for Scree Plot
      
      |Clusters k |  WSS|
      |:----------|----:|
      |1          | 36.0|
      |2          |  2.9|
      |3          |  1.6|
      |4          |  1.4|
      |5          |  1.8|
      |6          |  0.3|
      |7          |  0.4|
      |8          |  0.2|
      |9          |  0.2|
      |10         |  0.1|
      
      Automatically selected k=2 by the elbow criterion.
      

