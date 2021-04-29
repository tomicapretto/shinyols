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
      self$data[["fit"]] = list("intercept" = 0, "slope" = 0)
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
      
      model = lm(y ~ x, data = self$data[["scatter"]])
      pred = data.frame(
        x = self$data[["scatter"]]$x,
        y = predict(model, self$data[["scatter"]])
      )
      
      self$data[["fit"]][["intercept"]] = model$coefficients[[1]]
      self$data[["fit"]][["slope"]] = model$coefficients[[2]]
      
      self$data[["rect"]]  = data.frame(
        x = self$data[["scatter"]]$x,
        y = ifelse(pred$y >= self$data[["scatter"]]$y, pred$y, self$data[["scatter"]]$y),
        width = abs(pred$y -self$data[["scatter"]]$y),
        height = abs(pred$y -self$data[["scatter"]]$y)
      )
    },
    
    add_random_points = function(n=5) {
      df_n = nrow(self$data[["scatter"]])
      x = runif(n, 2, 8)
      y = 5 + x * rnorm(1, 0, 0.3) + rnorm(n)
      isolate({
        self$data[["scatter"]] = rbind(
          self$data[["scatter"]], 
          data.frame(x = x, y = y)
        )
        self$compute_line()
        self$compute_rects()
      })
    },
    
    shake = function() {
      n = nrow(self$data[["scatter"]])
      isolate({
        if (n >= 1) {
          self$data[["scatter"]]$x = self$data[["scatter"]]$x + rnorm(n, sd = 0.2)
          self$data[["scatter"]]$y = self$data[["scatter"]]$y + rnorm(n, sd = 0.4)
          self$compute_line()
          self$compute_rects()
        }
      })
    },
    
    clear = function() {
      self$data[["scatter"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["line"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["rect"]] = data.frame(
        x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
      )
      self$data[["fit"]] = list("intercept" = 0, "slope" = 0)
    },
    
    get_data_list = function() {
      reactiveValuesToList(self$data)
    },
    
    get_intercept = function() {
      self$data[["fit"]][["intercept"]]
    },
    
    get_slope = function() {
      self$data[["fit"]][["slope"]]
    }
  )
)
