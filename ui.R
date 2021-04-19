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
          width = 16,
          actionButton("add_points", "Add random points", width = "100%")
        )
      ),
      ui_row(
        ui_col(
          width = 16,
          actionButton("shake", "Shake it!", width = "100%")
        )
      )
    ),
    tags$div(
      tags$br()
    ),
    tags$div(
      class = "item",
      ui_row(
        ui_col(
          style = "top: 20%",
          width = 2,
          katexR::katex("\\beta_0"),
        ),
        ui_col(
          width = 14,
          rangeInput("intercept", value = 0, min = -10, max = 10, step = 0.01)
        )
      ),
      ui_row(
        ui_col(
          style = "top: 20%",
          width = 2,
          katexR::katex("\\beta_1"),
        ),
        ui_col(
          width = 14,
          rangeInput("slope", value = 0, min = -10, max = 10, step = 0.01)
        )
      )
    ),
    
    tags$div(
      class = "item",
      ui_row(
        ui_col(
          width = 16,
          actionButton("update", "Update")
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
      tags$h1(class = "ui header", "Least squares regression"),
      tags$div(
        d3Output("d3", width = "700px", height = "700px"),
        align = "center"
      )
    )
  )
}

ui = function() {
  shiny.semantic::semanticPage(
    tags$head(
      shiny::includeCSS("www/style.css")
    ),
    shinyjs::useShinyjs(),
    sidebar(),
    body()
  )
}
