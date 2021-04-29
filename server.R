server = function(input, output, session) {
  data = RegressionData$new()
  
  observe({
    data$add_point(input$new_point)
  })
  
  observeEvent(input$clear, {
    data$clear()
  })
  
  observeEvent(input$shake, {
    data$shake()
  })
  
  observeEvent(input$add_points, {
    data$add_random_points()
  })
  
  observe({
    updateRangeInput("intercept", data$get_intercept())
  })
  
  observe({
    updateRangeInput("slope", data$get_slope())
  })
  
  output$d3 = renderD3({
    r2d3(
      data = data_to_json(data$get_data_list()),
      script = "d3.js"
    )
  })
}