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