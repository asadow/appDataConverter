#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  iv <- shinyvalidate::InputValidator$new()
  iv$add_rule("n", shinyvalidate::sv_required(test = is.numeric))
  iv$enable()

  .data <- reactive({
    req(input$upload)

    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           xlsx = readxl::read_excel(input$upload$datapath, skip = 7),
           csv = vroom::vroom(input$upload$datapath, delim = ",", skip = 7),
           validate("Invalid file; Please upload a .xlsx or .csv file")
    )
  })

  .clean <- reactive(.data() |> clean_for_esa())

  date_range <- reactive({
    req(input$upload)

    readxl::read_excel(input$upload$datapath, n_max = 3) |>
      t() |>
      tibble::as_tibble(.name_repair = "unique") |>
      suppressMessages() |>
      janitor::row_to_names(1) |>
      janitor::clean_names() |>
      dplyr::filter(!is.na(start_date))
  })

  output$preview1 <- renderTable({
    head(.data(), input$n)
  })

  output$preview2 <- renderTable({
    head(.clean(), input$n)
  })

  output$download <- downloadHandler(
    filename = function() {
      glue::glue("{date_range$start_date}_to_{date_range$end_date}.xls")
    },
    content = function(file) {
      writeWorksheetToFile(
        file,
        data = .clean(),
        sheet = "Data"
      )
    }
  )
  #   message <- glue("{range$start_date} ESA Online uploadable file saved in {ui_path(dir_esa)}")
  #   ui_done(message)

}
