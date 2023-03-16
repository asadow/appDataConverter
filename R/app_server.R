#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  c(.range, .clean) %<-% mod_preview_server("esa")

  output$download <- downloadHandler(
    filename = function() {
      glue::glue("{.range()$start_date}_to_{.range()$end_date}.xls")
    },
    content = function(file) {
      writexl::write_xlsx(.clean(), file)
    }
  )
}
