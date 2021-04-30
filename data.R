RegressionData = R6::R6Class(
  "RegressionData",
  public = list(
    bgrid = seq(0, 10, length.out = 100), # base grid
    grid = seq(0, 10, length.out = 100),
    data = reactiveValues(),
    
    initialize = function() {
      self$data[["scatter"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["line"]] = data.frame(x = numeric(0), y = numeric(0))
      self$data[["rect"]] = data.frame(
        x = numeric(0), y = numeric(0), width = numeric(0), height = numeric(0)
      )
      self$data[["model"]] = list("coefficients" = c(0, 0))
    },
    
    add_point = function(coords) {
      if (is.null(coords)) return(NULL)
      isolate({
        self$data[["scatter"]][nrow(self$data[["scatter"]]) + 1, ] = coords
        if (nrow(self$data[["scatter"]]) >= 2) {
          self$compute_model()
          self$compute_line()
          self$compute_rects()
        }
      })
    },
    
    compute_model = function() {
      self$data[["model"]] = lm(y ~ x, data = self$data[["scatter"]])
    },
    
    compute_line = function() {
      # To avoid plotting below the axis, I need to compute the line twice
      intercept = self$get_intercept()
      slope = self$get_slope()
      y = intercept +  slope * self$bgrid
      
      range_bgrid = range(self$bgrid[y > 0 & y < 10])
      self$grid = seq(range_bgrid[1], range_bgrid[2], length.out = 100)
      
      self$data[["line"]] = data.frame(
        x = self$grid,
        y = intercept + slope * self$grid
      )
    },
    
    compute_rects = function() {
      pred = self$get_intercept() + self$get_slope() * self$data[["scatter"]]$x
      
      self$data[["rect"]]  = data.frame(
        x = self$data[["scatter"]]$x,
        y = ifelse(pred >= self$data[["scatter"]]$y, pred, self$data[["scatter"]]$y),
        width = abs(pred -self$data[["scatter"]]$y),
        height = abs(pred -self$data[["scatter"]]$y)
      )
    },
    
    add_random_points = function(n=5) {
      df_n = nrow(self$data[["scatter"]])
      x = runif(n, 2, 8)
      y = 5 + x * rnorm(1, 0, 0.3) + rnorm(n) # need to constrain
      isolate({
        self$data[["scatter"]] = rbind(
          self$data[["scatter"]], 
          data.frame(x = x, y = y)
        )
        self$compute_model()
        self$compute_line()
        self$compute_rects()
      })
    },
    
    shake = function() {
      n = nrow(self$data[["scatter"]])
      isolate({
        if (n >= 1) {
          self$data[["scatter"]]$x = shake(self$data[["scatter"]]$x, 0.2)
          self$data[["scatter"]]$y = shake(self$data[["scatter"]]$y, 0.4) 
          self$compute_model()
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
      data = reactiveValuesToList(self$data)
      data[names(data) != "model"]
    },
    
    get_intercept = function() {
      self$data[["model"]]$coefficients[[1]]
    },
    
    get_slope = function() {
      self$data[["model"]]$coefficients[[2]]
    },
    
    set_intercept = function(x) {
      self$data[["model"]]$coefficients[[1]] = x
      self$compute_line()
      self$compute_rects()
    },
    
    set_slope = function(x) {
      self$data[["model"]]$coefficients[[2]] = x
      self$compute_line()
      self$compute_rects()
    },
    
    set_ols_fit = function() {
      self$compute_model()
      self$compute_line()
      self$compute_rects()
    },
    
    get_error = function() {
      if (nrow(self$data[["rect"]]) > 0) {
        sum(self$data[["rect"]]$height ^ 2)
      } else {
        NULL
      }
    }
  )
)

shake = function(x, sd) {
  x = x + rnorm(length(x), sd = sd)
  x = ifelse(x > 10, 10, x)
  x = ifelse(x < 0, 0, x)
  x
}