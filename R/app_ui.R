#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny bslib htmltools
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

  header <- h1(
    class = "lead text-center bg-black text-white bg-gradient my-0 p-3",
    tags$b("Data Converter", br(), span("Megamation to ESA")),
  )

  tagList(
    golem_add_external_resources(),
    page_fixed(
      theme = theme,
      header,
      mod_preview_ui("esa")
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
