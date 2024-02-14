test_that("med criterion", {
  X <- iris[,-5]
  # ICS
  out_ICS <- ICS(X, S1 = ICS_tcov, S2 = ICS_cov)
  
  # select criterion
  out <- med_crit(out_ICS, nb_select = 1, select_only = FALSE)
  expect_s3_class(out, "ICS_crit")
  expect_type(out, "list")
  expect_named(out, c("crit", "nb_select", "gen_kurtosis",
                      "med_gen_kurtosis", "gen_kurtosis_diff_med",
                      "select"))
  
  out <- med_crit(out_ICS, nb_select = 1, select_only = TRUE)
  expect_type(out, "character")
  
  out <- med_crit(out_ICS, nb_select = 2, select_only = TRUE)
  expect_equal(out, c("IC.1", "IC.4"))
  
 
})


test_that("var criterion", {
  X <- iris[,-5]
  # ICS
  out_ICS <- ICS(X, S1 = ICS_tcov, S2 = ICS_cov)
  
  # select criterion
  out <- var_crit(out_ICS, nb_select = 1, select_only = FALSE)
  expect_s3_class(out, "ICS_crit")
  expect_type(out, "list")
  expect_named(out, c("crit", "nb_select", "gen_kurtosis",
                      "select", "RollVarX", "Order"))
  
  out <- var_crit(out_ICS, nb_select = 1, select_only = TRUE)
  expect_type(out, "character")
  
  out <- var_crit(out_ICS, nb_select = 2, select_only = TRUE)
  expect_equal(out, c("IC.1", "IC.2"))
  
})


test_that("normal criterion", {
  X <- iris[,-5]
  # ICS
  out_ICS <- ICS(X, S1 = ICS_tcov, S2 = ICS_cov)
  
  # select criterion
  out <- normal_crit(out_ICS, max_select = 1, select_only = FALSE)
  expect_s3_class(out, "ICS_crit")
  expect_type(out, "list")
  expect_named(out, c("crit", "level", "max_select", "test",
                      "pvalues", "adjusted_levels", "select",
                      "gen_kurtosis"))
  
  out <- normal_crit(out_ICS, max_select = 1, select_only = TRUE)
  expect_type(out, "character")
  
  out <- normal_crit(out_ICS, max_select = 0, select_only = TRUE)
  expect_equal(out, logical(0))
  
  
  out <- normal_crit(out_ICS, test = "bonett.test", level = 0.4)
  expect_equal(out$test, "bonett.test")
  expect_equal(out$level, 0.4)
  expect_equal(out$select, c("IC.1", "IC.2", "IC.3"))
})


test_that("discriminatory criterion", {
  X <- iris[,-5]
  # ICS
  out_ICS <- ICS(X, S1 = ICS_tcov, S2 = ICS_cov)
  
  # select criterion
  expect_error(discriminatory_crit(out_ICS, nb_select = 1,
                                   select_only = FALSE),
               'argument "clusters" is missing, with no default')
  
  out <- discriminatory_crit(out_ICS, nb_select = 1, clusters = iris[,5],
                             select_only = FALSE)
  expect_s3_class(out, "ICS_crit")
  expect_type(out, "list")
  expect_named(out, c("crit", "method", "nb_select", "select",
                      "power", "power_combinations", "gen_kurtosis"))
  
  out <- discriminatory_crit(out_ICS, clusters = iris[,5], 
                             select_only = TRUE)
  expect_type(out, "character")
  
  out <- discriminatory_crit(out_ICS,  clusters = iris[,5], 
                             nb_select = 2, select_only = TRUE)
  expect_equal(out, c("IC.1", "IC.2"))
  
})
