test_that("select plot on ICS object",{
  
  X <- iris[,-5]
  out <- ICS(X)
  p <- select_plot(out)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  
  # check y label is 'Generalized Kurtosis'
  expect_identical(p$labels$y, "Generalized Kurtosis")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 1) 
  
  
  ## plot 
  p <- select_plot(out, type = "lines")
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 2) 
  
})


test_that("select plot on a vector",{
  
  a <- 1:5
  expect_error(select_plot(a), 
               "You can apply 'select_plot' only to an object of class 'ICS' or 'ICS_crit'.")
})


test_that("select plot on ICS_crit object - var criterion ",{
  
  X <- iris[,-5]
  out <- ICS(X)
  
  # var criterion
  out_var <- var_crit(out, nb_select = 2, select_only = TRUE)
  expect_error(select_plot(out_var, type = "lines"), 
               "You can apply 'select_plot' only to an object of class 'ICS' or 'ICS_crit'.")
  
  
  out_var <- var_crit(out, nb_select = 2, select_only = FALSE)
  expect_error(select_plot(out_var, screeplot = FALSE), 
               "The non screeplot option is only available for 'med' ")
  
  p <- select_plot(out_var)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  
  # check y label is 'Generalized Kurtosis'
  expect_identical(p$labels$y, "Generalized Kurtosis")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 2) 
  
  
  ## plot 
  p <- select_plot(out_var, type = "lines")
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 3) 
  
  
})


test_that("select plot on ICS_crit object - normal criterion ",{
  
  X <- iris[,-5]
  out <- ICS(X)
  
  # normal criterion)
  out_normal <- normal_crit(out, level = 0.5, select_only = TRUE)
  expect_error(select_plot(out_normal, type = "lines"), 
               "You can apply 'select_plot' only to an object of class 'ICS' or 'ICS_crit'.")
  
  
  out_normal <- normal_crit(out, level = 0.5, select_only = FALSE)
  expect_error(select_plot(out_normal, screeplot = FALSE), 
               "The non screeplot option is only available for 'med' ")
  
  p <- select_plot(out_normal)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  
  # check y label is 'Generalized Kurtosis'
  expect_identical(p$labels$y, "Generalized Kurtosis")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 2) 
  
  
  ## plot 
  p <- select_plot(out_normal, type = "lines")
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 3) 
  
  
})


test_that("select plot on ICS_crit object - med criterion ",{
  
  X <- iris[,-5]
  out <- ICS(X)
  
  # median criterion
  out_med <- med_crit(out, nb_select = 1, select_only = TRUE)
  expect_error(select_plot(out_med, type = "lines"), 
               "You can apply 'select_plot' only to an object of class 'ICS' or 'ICS_crit'.")
  
  out_med <- med_crit(out, nb_select = 1, select_only = FALSE)

  p <- select_plot(out_med)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  
  p <- select_plot(out_med, screeplot = FALSE)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  expect_no_error(p, message = NULL, class = NULL)
  
  # check y label is '|Generalized kurtosis - median|'
  expect_identical(p$labels$y, "|Generalized kurtosis - median|")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 2) 
  
  
  ## plot 
  p <- select_plot(out_med, screeplot = FALSE, type = "lines", 
                   color = "lightblue")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 3) 
  
})


test_that("select plot on ICS_crit object - discriminatory criterion ",{
  
  X <- iris[,-5]
  out <- ICS(X)
  
  # discriminatory criterion
  out_disc <- discriminatory_crit(out, clusters = iris[,5], select_only = TRUE)
  expect_error(select_plot(out_disc, type = "lines"), 
               "You can apply 'select_plot' only to an object of class 'ICS' or 'ICS_crit'.")
  
  out_disc <- discriminatory_crit(out, clusters = iris[,5], select_only = FALSE)
  
  p <- select_plot(out_disc)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  
  p <- select_plot(out_disc, screeplot = FALSE)
  # check if it is a ggplot object
  expect_true(is.ggplot(p))
  expect_no_error(p, message = NULL, class = NULL)
  
  # check y label is 'Discriminatory Power'
  expect_identical(p$labels$y, "Discriminatory Power")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # check for no geom_line
  expect_length(p$layers, 2) 
  
})


test_that("component plot on ICS object with select from ICSç",{
  
  X <- iris[,-5]
  out <- ICS(X)
  p <- component_plot(out)
  # check if it is a ggmatrix object
  expect_s3_class(p, "ggmatrix")
  
  # expect no error and no warnings
  expect_no_error(p, message = NULL, class = NULL)
  
  # expect number of observations the same as initially
  expect_equal(nrow(p$data), nrow(X))
  
  # expect number of variables the same as initially
  expect_equal(ncol(p$data), ncol(X)+1)
  
  
  # when we select some variables
  p <- component_plot(out, select = c(1,4))
  
  # expect number of variables the same as initially
  expect_equal(ncol(p$data), 3)
  
  # expect names of variables
  expect_equal(colnames(p$data), c("IC.1.", "IC.4.", "clusters"))
  
})


test_that("component plot on a vector",{
  
  a <- 1:5
  expect_error(component_plot(a), 
               "You can apply 'component_plot' only to an object of class 'ICS' or a data.frame.")
})

