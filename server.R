server = function(input, output, session) {
  data = RegressionData$new()
  
  observe({
    error = data$get_error()
    if (is.null(error)) {
      error = ""
    } else {
      error = round(error, 3)
    }
    shinyjs::html("ss", error)
  })
  
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
  
  observeEvent(input$intercept, {
    data$set_intercept(input$intercept)
  }, ignoreInit = TRUE)
  
  observeEvent(input$slope, {
    data$set_slope(input$slope)
  }, ignoreInit = TRUE)
  
  observe({
    updateRangeInput("intercept", data$get_intercept())
  })
  
  observe({
    updateRangeInput("slope", data$get_slope())
  })
  
  observeEvent(input$set_ols, {
    data$set_ols_fit()
  })
  
  output$d3 = renderD3({
    r2d3(
      data = data_to_json(data$get_data_list()),
      script = "d3.js"
    )
  })
}