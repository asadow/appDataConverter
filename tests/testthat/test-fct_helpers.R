test_that("assert_esa_req() catches cases", {
  long_string <- rep("x", 1000) |> glue::glue_collapse()
  df <- tibble::tibble(
    work_location = long_string,
    work_description = long_string,
    work_order = long_string
  )
  expect_error(assert_esa_reqs(df), "assertr stopped execution")
})
