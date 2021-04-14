server = function(input, output, session) {
  reg_data = RegressionData$new()
  output$d3 = renderD3({
    reg_data$add_point(input$new_point)
    r2d3(
      data = data_to_json(reg_data$get_data_list()),
      script = "d3.js"
    )
  })
}
