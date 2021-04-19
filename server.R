server = function(input, output, session) {
  data = RegressionData$new()
  output$d3 = renderD3({
    data$add_point(input$new_point)
    r2d3(
      data = data_to_json(data$get_data_list()),
      script = "d3.js",
      options = list(shake = FALSE)
    )
  })
}

# https://stackoverflow.com/questions/56770222/get-the-event-which-is-fired-in-shiny