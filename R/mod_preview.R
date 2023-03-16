#' preview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_preview_ui <- function(id){
  ns <- NS(id)

  preview_card <- function(name, inputId) {
    card(
      height = 300,
      card_header(card_title(name)),
      card_body_fill(DT::dataTableOutput(inputId)),
    )
  }

  raw_half <- sidebarLayout(
    sidebarPanel(
      fileInput(ns("upload"), "Upload CP_ESA_WO_REPORT"),
      numericInput(ns("n"), "Rows to Preview", value = 1, min = 1, step = 1),
    ),
    mainPanel(
      preview_card("Unclean Data", ns("raw"))
    )
  )

  logo <- img(src = "www/pr-logo.jpg", width = 400)

  clean_half <- fluidRow(
    column(4,
           wellPanel(downloadButton("download", "Download ESA-Ready Data")),
           br(), br(), br(), br(),
           logo
           ),
    column(8,
           preview_card("ESA-Ready Data", ns("clean"))
           )
  )

  tagList(
    raw_half,
    clean_half
  )
}

#' preview Server Functions
#'
#' @noRd
mod_preview_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Warn if input$n is not given or not numeric
    iv <- shinyvalidate::InputValidator$new()
    iv$add_rule("n", shinyvalidate::sv_required(test = is.numeric))
    iv$enable()

    .raw <- reactive({
      req(input$upload)
      utils_load_xl(input$upload$datapath, input$upload$name, skip = 7)
    })

    output$raw <- DT::renderDataTable(
      utils_DT(.raw() |> fct_skim_names(), input$n)
      )

    .clean <- reactive(.raw() |> fct_clean_for_esa())

    output$clean <- DT::renderDataTable(
      utils_DT(.clean(), input$n)
      )

    .range <- reactive({
      req(input$upload)
      utils_date_range(input$upload$datapath)
    })

    list(.range, .clean)

  })
}

## To be copied in the UI
# mod_preview_ui("preview_1")

## To be copied in the server
# mod_preview_server("preview_1")
