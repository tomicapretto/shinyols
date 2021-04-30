library(shiny)
library(shiny.semantic)

source("ui.R")
source("server.R")

shinyApp(ui, server)

# https://datatricks.co.uk/animated-d3-js-scatter-plot-in-r
# x, y is the top-left corner of the rect
# width: how much to go to the right
# height: how much to go to the bottom
