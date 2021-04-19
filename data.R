RegressionData = R6::R6Class(
  "RegressionData",
  public = list(
    grid = seq(0, 13, by = 0.5),
    data = reactiveValues(),
    initialize = function() {
      self$data[["scatter"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["line"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["rect"]] = data.frame(
        x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
      )
    },
    add_point = function(coords) {
      if (is.null(coords)) return(NULL)
      isolate({
        self$data[["scatter"]][nrow(self$data[["scatter"]]) + 1, ] = coords
        if (nrow(self$data[["scatter"]]) >= 2) {
          self$compute_line()
          self$compute_rects()
        }
      })
    },
    compute_line = function() {
      self$data[["line"]] = data.frame(
        x = self$grid,
        y = predict(
          lm(y ~ x, data = self$data[["scatter"]]), 
          data.frame(x = self$grid)
        )
      )
    },
    compute_rects = function() {
      pred = data.frame(
        x = self$data[["scatter"]]$x,
        y = predict(
          lm(y ~ x, data = self$data[["scatter"]]), 
          self$data[["scatter"]]
        )
      )
      self$data[["rect"]]  = data.frame(
        x = self$data[["scatter"]]$x,
        y = ifelse(pred$y >= self$data[["scatter"]]$y, pred$y, self$data[["scatter"]]$y),
        width = abs(pred$y -self$data[["scatter"]]$y),
        height = abs(pred$y -self$data[["scatter"]]$y)
      )
    },
    
    shake = function() {
      n = nrow(self$data[["scatter"]])
      isolate({
        self$data[["scatter"]]$x = self$data[["scatter"]]$x + rnorm(n, sd = 0.2)
        self$data[["scatter"]]$y = self$data[["scatter"]]$y + rnorm(n, sd = 0.2)
        self$compute_line()
        self$compute_rects()
      })
    },
    get_data_list = function() {
      reactiveValuesToList(self$data)
    }
  )
)
