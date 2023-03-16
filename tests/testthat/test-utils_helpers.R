test_that("utils_load_xl() handles xlsx input and skips 7 rows", {
  # Create sample data
  df <- tibble::tibble(
    x = c(rep("", 6), "col1", "1"),
    y = c(rep("", 6), "col2", "2")
  )
  # Expected data
  exp_df <- tibble::tibble(col1 = "1", col2 = "2")
  path_xlsx <- paste0(tempfile(), ".xlsx")
  writexl::write_xlsx(df, path_xlsx)

  expect_equal(utils_load_xl(path_xlsx, "blah.xlsx", skip = 7), exp_df)
  expect_s3_class(utils_load_xl(path_xlsx, "blah.xlsx"), "data.frame")
  expect_error(utils_load_xl(path_xlsx, "blah.csv"), "Invalid file")
})

test_that("utils_date_range() retrieves ymd characters", {
  # Create sample data
  df <- tibble::tibble(
    x = c("", "Start Date", "End Date"),
    y = rep("", 3),
    z = c("", "2012-01-01", "2021-01-01")
  )
  # Expected data
  exp_date_range <- tibble::tibble(
    na = NA_character_,
    start_date = df$z[2],
    end_date = df$z[3]
    )
  path_xlsx <- paste0(tempfile(), ".xlsx")
  writexl::write_xlsx(df, path_xlsx)

  expect_equal(utils_date_range(path_xlsx), exp_date_range)
  expect_s3_class(utils_date_range(path_xlsx), "data.frame")
})

test_that("utils_DT() gives a data table", {
  # Create sample data
  df <- tibble::tibble(
    x = c(1:3),
    y = c(1:3)
  )

  expect_s3_class(utils_DT(df, 5), "datatables")
})
