RegressionData = R6::R6Class(
  "RegressionData",
  public = list(
    scatter = NULL,
    pred = NULL,
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
      if (is.null(coords) | any(coords < 0) | any(coords > 12.75)) {
        return(NULL)
      } else {
        self$scatter[nrow(self$scatter) + 1, ] = coords
        if (nrow(self$scatter) >= 2) {
          x = seq(0, 13, by = 0.5)
          self$line = data.frame(
            x = x,
            y = unname(predict(lm(y ~ x, data = self$scatter), data.frame(x=x)))
          )
          self$pred = data.frame(
            x = self$scatter$x,
            y = unname(predict(lm(y ~ x, data = self$scatter), self$scatter))
          )
          self$rect = data.frame(
            x = self$scatter$x,
            y = ifelse(self$pred$y >= self$scatter$y, self$pred$y, self$scatter$y), 
            width = abs(self$pred$y - self$scatter$y),
            height = abs(self$pred$y - self$scatter$y)
          )
        }
      }
    },
    get_data_list = function() {
      list(scatter = self$scatter, line = self$line, rect = self$rect)
    }
  )
)