test_that("fct_skim_names() reduces name length", {
  # Create sample data
  df <- tibble::tibble(
    "Add to Electrical Safety Authority Reporting" = 1,
    "Issue To Name" = 2
  )
  expect_s3_class(fct_skim_names(df), "data.frame")
  mean_nchr <- function(x) {mean(nchar(names(x)))}
  expect_true(mean_nchr(fct_skim_names(df)) < mean_nchr(df))
})
