sidebar = function() {
  tags$div(
    class = "ui sidebar inverted vertical visible menu",
    id = "sidebar",
    tags$div(
      class = "item",
      tags$p(
        class = "sidebar_header",
        "Title!"
      )
    ),
    tags$div(
      class = "item",
      ui_row(
        ui_col(
          width = 14
        ),
        ui_col(
          width = 2
        )
      )
    )
  )
}

body = function() {
  tags$div(
    style = "margin-left: 260px",
    tags$div(
      class = "ui container",
      tags$h1(class = "ui header", "Sampling distributions playground"),
      tags$div(
        d3Output("d3", width = "700px", height = "700px"),
        align = "center"
      )
    )
  )
}

ui = function() {
  shiny.semantic::semanticPage(
    tags$head(shiny::includeCSS("www/style.css")),
    shinyjs::useShinyjs(),
    sidebar(),
    body()
  )
}
