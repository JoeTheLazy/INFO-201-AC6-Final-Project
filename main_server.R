library("shiny")
library("dplyr")
library("ggplot2")

source("analysis.R")

main_server <- function(input, output) {
  
  output$sum_plot <- renderPlot({
    get_summary_plot()
  })
  
}
