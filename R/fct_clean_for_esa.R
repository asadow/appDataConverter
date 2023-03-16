#' Prepare an ESA Online Logbook Entry
#'
#' `clean_for_esa()` cleans Megamation exports for upload to the
#' Electrical Safety Authority (ESA) Online website.
#' Requirements are stated in the LogbookEntryUploadForm.xls.
#'
#' @param .data A data frame.
#' @export

fct_clean_for_esa <- function(.data){

  .data |>
    add_site_number() |>
    mutate_for_esa() |>
    assert_esa_reqs() |>
    order_for_esa()
}

#' Attach building site numbers
#'
#' `add_site_number()` does preliminary cleaning and
#' joins site numbers to the Megamation
#' export "CP_ESA_WO_REPORT" of the WORK_ORDER_MASTER.
#'
#' @param .data A data frame.
#' @noRd

add_site_number <- function(.data) {
  .data |>
    janitor::clean_names() |>
    dplyr::filter(.data$add_to_electrical_safety_authority_reporting == "Yes") |>
    dplyr::rename(bldg_no = .data$building) |>
    dplyr::left_join(
      esaApp::sitenumber,
      by = "bldg_no",
      suffix = c("_mm", "_css")
      )
}

#' Mutate according to ESA formatting requirements
#'
#' In the requirements, 'OPTIONAL' does not mean column is optional
#' but rather that values can be missing.
#'
#' @param A data frame.
#' @noRd

mutate_for_esa <- function(.data) {
  .data |>
    dplyr::mutate(
      work_description = glue::glue("{.data$work_description} - {.data$closing_comments}"),
      date = format(lubridate::mdy(.data$date), "%d/%m/%Y"),
      ## type of performer
      performed_by = dplyr::case_when(
        !is.na(.data$contractor_name) ~ "Other",
        !is.na(.data$issue_to_name) ~ "Customer",
        .default = NA
      ),
      ## name of performer
      "Contractor/Employee" = dplyr::case_when(
        !is.na(.data$contractor_name) ~ .data$contractor_name,
        !is.na(.data$issue_to_name) ~ .data$issue_to_name,
        .default = NA
      ) |> stringr::str_to_title(),
      ## empty columns
      logbook_name = NA,
      site_identifier = NA,
      quantity = NA,
      unit = NA
    ) |>
    dplyr::rename(
      work_location = "site_name",
      work_date = "date",
      work_order = "w_o_number"
    )

}

#' Assert ESA `nchar()` requirements
#'
#' @param .data A data frame
#' @noRd

assert_esa_reqs <- function(.data) {
  .data  |>
    assertr::assert(function(x) nchar(x) <= 64, "work_location") |>
    assertr::assert(function(x) nchar(x) <= 7500, "work_description") |>
    assertr::assert(function(x) nchar(x) <= 10, "work_order")
}

#' Order columns and rows according to ESA requirements
#' @param .data A data frame.
#' @noRd

order_for_esa <- function(.data) {
  .data |>
    dplyr::select(
      "site_number",
      "site_identifier",
      "logbook_name",
      "work_location",
      "unit",
      "work_order",
      "work_description",
      "quantity",
      "work_date",
      "performed_by",
      "Contractor/Employee"
    ) |>
    dplyr::arrange(.data$work_date, .data$site_number) |>
    dplyr::rename_with(
      ~ stringr::str_to_title(stringr::str_replace_all(.x, "_", " "))
    )

}
