#' Shorten two column names in raw Megamation data
#' to improve table display in a 300-height card
#' @param .data A data frame.
#' @noRd

fct_skim_names <- function(.data) {
  .data |>
    dplyr::rename_with(
      ~ stringr::str_replace(
        .x,
        "Add to Electrical Safety Authority Reporting",
        "For ESA"
      )
    ) |>
    dplyr::rename("Issue Name" = "Issue To Name")
}

