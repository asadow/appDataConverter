test_that("add_site_number() gives back a bigger data.frame", {
  # Create sample data
  df <- tibble::tibble(
    add_to_electrical_safety_authority_reporting = c("Maybe..", "Yes"),
    building = c(1:2)
  )
  expect_true(nrow(add_site_number(df)) <= nrow(df))
  expect_true(ncol(add_site_number(df)) >= ncol(df))
})

test_that("mutate_for_esa() gives back a bigger data.frame", {
  # Create sample data
  df <- tibble::tibble(
    contractor_name = "adam sadowski",
    issue_to_name = "The Crossed-Skis-Factor",
    work_description = "It was hard work...",
    closing_comments = "and that's it, folks!",
    date = "01-01-2023",
    site_name = "Hill",
    w_o_number = 1
  )
  expect_true(ncol(mutate_for_esa(df)) >= ncol(df))
  expect_true(
    length(mutate_for_esa(df)$work_description) >=
      length(df$work_description)
  )
  expect(mutate_for_esa(df)$performed_by == "Other", "Wrong performer")

})

test_that("assert_esa_req() catches cases", {
  # Create sample data
  long_string <- rep("x", 1000) |> glue::glue_collapse()
  df <- tibble::tibble(
    work_location = long_string,
    work_description = long_string,
    work_order = long_string
  )
  expect_error(assert_esa_reqs(df), "assertr stopped execution")
})

test_that("order_for_esa() orders names", {
  # Create sample data
  df <- tibble::tibble(
    work_date = "2023-01-01",
    site_number = 5
  )
  exp_df <- tibble::tibble(
    # Reversed order of columns and title case names
    "Site Number" = 5,
    "Work Date" = "2023-01-01"
  )
  expect_equal(order_for_esa(df), exp_df)

})
