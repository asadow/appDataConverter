#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny bslib
#' @noRd
#'
#'
theme <- bslib::bs_theme(
  version = 5,
  bg = "#FFFFFF",
  fg = "#000000",
  primary = "#A30808",
  secondary = "#F8D505"
)

app_ui <- function(request) {

  ui_upload <- sidebarLayout(
    sidebarPanel(
      fileInput("upload", "Upload CP_ESA_WO_REPORT"),
      numericInput("n", "Rows to Preview", value = 1, min = 1, step = 1),
    ),
    mainPanel(
      card(
        height = 300,
        card_header(card_title("Unclean Data")),
        card_body_fill(tableOutput("preview1")),
      ),
    )
  )

  ui_clean <- sidebarLayout(
    sidebarPanel(
      downloadButton("download1", "Download ESA-Ready Data")
    ),
    mainPanel(
      card(
        height = 300,
        card_header(card_title("ESA-Ready Data")),
        card_body_fill(tableOutput("preview2"))
      )
    )
  )

  logo <- img(src = "www/Physical Resources_Full Colour.jpg", width = 300)

  header <- h1(
    class = "lead text-center bg-black text-white bg-gradient my-0 p-3",
    tags$b("Data Converter", br(), span("Megamation to ESA")),
  )

  tagList(
    golem_add_external_resources(),
    page_fill(
      theme = theme,
      logo,
      header,
      ui_upload,
      ui_clean,
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd

golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "esaApp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
