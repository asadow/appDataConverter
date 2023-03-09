#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny bslib
#' @noRd
#'
#'
ui_upload <- sidebarLayout(

  sidebarPanel(
    fileInput("upload", "Upload CP_ESA_WO_REPORT"),
    numericInput(
      "n",
      "Rows to Preview",
      value = 1,
      min = 1,
      step = 1
    ),
  ),
  mainPanel(
    card(
      height = 300,
      card_title("Unclean Data"),
      tableOutput("preview1"),
    ),
  )
)


ui_clean <- sidebarLayout(
  sidebarPanel(
    downloadButton("download1", "Download ESA-Ready Data")
  ),
  mainPanel(
    card(
      card_title("ESA-Ready Data"),
      tableOutput("preview2")
    )
  )
)

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    page_fill(
      theme = theme,
      img(
        src = "Physical Resources_Full Colour.jpg",
        width = 300
      ),
      h1(
        class = "lead text-center bg-black text-white bg-gradient my-0 p-3",
        tags$b("Data Converter", br(), span("Megamation to ESA")),
      ),
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
