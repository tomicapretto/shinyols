data_to_json = function(data) {
  jsonlite::toJSON(
    data, dataframe = "rows", auto_unbox = FALSE, rownames = TRUE
  )
} 

ui_row = function(...) {
  tags$div(
    class = "ui grid",
    tags$div(
      class = "row",
      ...
    )
  )
}

ui_col = function(width, ...) {
  opts = c("one", "two", "three", "four", "five", "six", "seven", "eight",
           "nine", "ten", "eleven", "twelve", "thirtheen", "fourteen",
           "fifteen", "sixteen")
  width = opts[width]
  tags$div(
    class = paste(width, "wide column"),
    ...
  )
}

rangeInput = function(inputId, value = 20, min = 0, max = 100, step = 1) {
  form = tags$div(
    class = "range-input",
    id = inputId,
    tags$div(
      tags$div(
        class = "range-input-controls",
        tags$div(class = "range-value"),
        tags$input(type = "range", min = min, max = max, value = value, step = step)
      )
    )
  )
  deps = htmltools::htmlDependency(
    name = "rangeInput",
    version = "1.0.0",
    src = "www/range-input",
    script = "binding.js",
    stylesheet = "styles.css"
  )
  htmltools::attachDependencies(form, deps)
}

updateRangeInput = function(id, value, session = shiny::getDefaultReactiveDomain()) {
  message = list(value = round(value, 2))
  session$sendInputMessage(id, message)
}