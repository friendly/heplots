test_that("ICSClust class", {
  X <- iris[,-5]
  
  out <- ICSClust(X, nb_clusters = 3)
  expect_s3_class(out, "ICSClust")
  
  expect_named(out, c("ICS_out", "select", "clusters"))
  
  expect_s3_class(out$ICS_out, "ICS")
  
  expect_type(out$select, "character")
  
  expect_equal(length(out$clusters), nrow(X))
})

test_that("ICSClust error if missing argument", {
  X <- iris[,-5]
  expect_error(ICSClust(X), "You should specify the `nb_clusters` argument.")
})



test_that("ICSClust - number of selected component", {
  X <- iris[,-5]

  # if only 1 component
  out <- ICSClust(X, nb_select = 1, nb_clusters = 3,
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1"))
  
  # if no component
  expect_warning(ICSClust(X, nb_select = 0, nb_clusters = 3,
                          ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov)),
                 "No component has been selected.")
  
  
  # normal criterion: 2 components
  out <- ICSClust(X, nb_clusters = 3, criterion = "normal_crit",
                  ICS_crit_args = list(level = 0.7, test = "shapiro.test",
                                       max_select = NULL),
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1", "IC.2"))
  
  out <- ICSClust(X, nb_clusters = 3, 
                  criterion = "normal_crit",
                  ICS_crit_args = list(level = 0.7, test = "shapiro.test",
                                       max_select = 1),
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1"))
  
})


test_that("ICSClust - different criterion", {
  X <- iris[,-5]
  
  # med criterion
  out <- ICSClust(X, nb_clusters = 3, criterion = "med", nb_select = 1,
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1"))
  
  # var criterion
  out <- ICSClust(X, nb_clusters = 3, criterion = "var", nb_select = 1,
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1"))
  
  # normal criterion
  out <- ICSClust(X, nb_clusters = 3, criterion = "normal_crit",
                  ICS_crit_args = list(level = 0.1, test = "anscombe.test",
                                       max_select = NULL),
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1"))
  
  # discriminatory criterion
  expect_error(ICSClust(X, nb_clusters = 3, criterion = "discriminatory",
                        ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov)),
               "The 'clusters' argument is mandatory to compute the discriminatory 
            power of the reduced data frame.")
  
  
  # discriminatory criterion
  out <- ICSClust(X, nb_clusters = 3, criterion = "discriminatory",
                  clusters = iris[,5],
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1", "IC.2"))
  
  # discriminatory criterion
  out <- ICSClust(X, nb_clusters = 3, criterion = "discriminatory",
                  clusters = iris[,5], nb_select = 1,
                  ICS_args = list(S1 = ICS_tcov, S2 = ICS_cov))
  expect_equal(out$select, c("IC.1"))
  
})


