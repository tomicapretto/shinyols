RegressionData = R6::R6Class(
  "RegressionData",
  public = list(
    grid = seq(0, 13, by = 0.5),
    scatter = NULL,
    line = NULL,
    rect = NULL,
    initialize = function() {
     self$scatter = data.frame(x = numeric(0), y = numeric(0))
     self$line = data.frame(x = numeric(0), y = numeric(0))
     self$rect = data.frame(
        x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
      )
    },
    
    add_point = function(coords) {
      if (is.null(coords)) return(NULL)
      self$scatter[nrow(self$scatter) + 1, ] = coords
      if (nrow(self$scatter) >= 2) {
        self$line = data.frame(
          x = self$grid,
          y = predict(lm(y ~ x, data =self$scatter), data.frame(x=self$grid))
        )
        pred = data.frame(
          x = self$scatter$x,
          y = predict(lm(y ~ x, data =self$scatter), self$scatter)
        )
        self$rect = data.frame(
          x = self$scatter$x,
          y = ifelse(pred$y >=self$scatter$y, pred$y, self$scatter$y),
          width = abs(pred$y -self$scatter$y),
          height = abs(pred$y -self$scatter$y)
        )
      }

    },
    get_data_list = function() {
      list(scatter = self$scatter, line = self$line, rect = self$rect)
    }
  )
)

# RegressionData = R6::R6Class(
#   "RegressionData",
#   public = list(
#     grid = seq(0, 13, by = 0.5),
#     data = reactiveValues(),
#     initialize = function() {
#       self$data[["scatter"]] = data.frame(x = numeric(0), y = numeric(0))
#       self$data[["line"]] = data.frame(x = numeric(0), y = numeric(0))
#       self$data[["rect"]] = data.frame(
#         x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
#       )
#     },
#     add_point = function(coords) {
#       if (is.null(coords)) return(NULL)
#       self$data[["scatter"]][nrow(self$data[["scatter"]]) + 1, ] = coords
#       print(self$data[["scatter"]])
#       if (nrow(self$data[["scatter"]]) >= 2) {
#         self$data[["line"]] = data.frame(
#           x = self$grid,
#           y = predict(lm(y ~ x, data = self$data[["scatter"]]), data.frame(x = self$grid))
#         )
#         pred = data.frame(
#           x = self$data[["scatter"]]$x,
#           y = predict(lm(y ~ x, data = self$data[["scatter"]]), self$data[["scatter"]])
#         )
#         self$data[["rect"]]  = data.frame(
#           x = self$data[["scatter"]]$x,
#           y = ifelse(pred$y >= self$data[["scatter"]]$y, pred$y, self$data[["scatter"]]$y), 
#           width = abs(pred$y -self$data[["scatter"]]$y),
#           height = abs(pred$y -self$data[["scatter"]]$y)
#         )
#       }
#       
#     },
#     get_data_list = function() {
#       #list(scatter = self$scatter, line = self$line, rect = self$rect)
#       reactiveValuesToList(self$data)
#     }
#   )
# )
