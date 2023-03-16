#' Load an Excel file
#'
#' @param path Path to the xls/xlsx file.
#' @param name Name of the file.
#' @param ... Arguments to pass on to `readxl::read_excel()`

utils_load_xl <- function(path, name, ...) {
  ext <- tools::file_ext(name)
  switch(ext,
         xlsx = readxl::read_excel(path, ...),
         validate("Invalid file; Please upload a .xlsx file.")
         )
}

#' Get date range from a Megamation export
#'
#' The date range in a Megamation export is contained in the first three lines.
#'
#' @param path Path to the xls/xlsx file.

utils_date_range <- function(path) {
  readxl::read_excel(path, n_max = 3) |>
    t() |>
    tibble::as_tibble(.name_repair = "unique") |>
    suppressMessages() |>
    janitor::row_to_names(1) |>
    janitor::clean_names() |>
    dplyr::filter(!is.na(.data$start_date))
}

#' Table-only `datatable()` that fills container and has variable rows.
#'
#' `fillContainer = TRUE` is needed for a scrollable container
#' in `card_body_fill()`
#'
#' @param .data A data frame.
#' @param rows Number of rows.

utils_DT <- function(.data, rows) {
  DT::datatable(
    head(.data, rows),
    fillContainer = TRUE,
    rownames = FALSE,
    options = list(dom = 't')
  )
}
