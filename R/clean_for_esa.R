#' Prepare an ESA Online Logbook Entry
#'
#' `clean_for_esa()` attaches building site numbers to the Megamation
#' export "CP_ESA_WO_REPORT" of the WORK_ORDER_MASTER.
#' Data is then cleaned for upload to the Electrical Safety Authority
#' (ESA) Online website.
#'
#' @export

clean_for_esa <- function(.df){

  ## Merge with sitenumbers: ----

  mm <- .df |>
    janitor::clean_names() |>
    dplyr::filter(add_to_electrical_safety_authority_reporting == "Yes") |>
    dplyr::rename(bldg_no = building)

  esa <- mm |>
    dplyr::left_join(sitenumber, by = "bldg_no", suffix = c("_mm", "_css"))

  ## Clean: ----
  ## Create and check formatting requirements
  ## according to guidelines in LogbookEntryUploadForm.xls
  ## NB in template, OPTIONAL does not mean column is optional
  ## OPTIONAL means values can be missing
  ## Columns must be in the listed order

  esa <- esa |>
    dplyr::mutate(
      date = format(lubridate::mdy(date), "%d/%m/%Y"),
      work_description = glue::glue("{work_description} - {closing_comments}"),
      ## First line in case_when() has priority
      performed_by = dplyr::case_when(
        !is.na(contractor_name) ~ "Other",
        !is.na(issue_to_name) ~ "Customer",
        .default = NA
      ),
      "Contractor/Employee" = dplyr::case_when(
        !is.na(contractor_name) ~ contractor_name,
        !is.na(issue_to_name) ~ issue_to_name,
        .default = NA
      ) |> stringr::str_to_title(),
      logbook_name = NA,
      site_identifier = NA,
      quantity = NA,
      unit = NA
    ) |>
    dplyr::rename(
      work_location = site_name,
      work_date = date,
      work_order = w_o_number
    ) |>
    assertr::assert(function(x) nchar(x) <= 64, work_location) |>
    assertr::assert(function(x) nchar(x) <= 7500, work_description) |>
    assertr::assert(function(x) nchar(x) <= 10, work_order)

  esa <- esa |>
    dplyr::select(
      site_number,
      site_identifier,
      logbook_name,
      work_location,
      unit,
      work_order,
      work_description,
      quantity,
      work_date,
      performed_by,
      "Contractor/Employee"
    ) |>
    dplyr::arrange(work_date, site_number) |>
    dplyr::rename_with(
      ~ stringr::str_to_title(stringr::str_replace_all(.x, "_", " "))
      )

}
