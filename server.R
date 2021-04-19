server = function(input, output, session) {
  data = RegressionData$new()
  observe({
    data$add_point(input$new_point)
  })
  observeEvent(input$shake, {
    data$shake()
  })
  observeEvent(input$add_points, {
    data$add_random_points()
  })
  
  observeEvent(input$update, {
    updateRangeInput(
      "intercept", runif(1, -5, 5)
    )
  })
  
  output$d3 = renderD3({
    r2d3(
      data = data_to_json(data$get_data_list()),
      script = "d3.js"
    )
  })
}