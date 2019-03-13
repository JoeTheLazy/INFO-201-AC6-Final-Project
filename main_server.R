# INFO 201 Group AC6
# Final Project
#
# Contains the server for our app.

library("shiny")
library("dplyr")
library("ggplot2")

source("analysis.R")
source("age_analysis.R")

main_server <- function(input, output) {
  
  regs <- read.csv("data/raw_data.csv", stringsAsFactors = F)
  shootings <- read.csv("data/Mass Shootings Dataset Ver 5.csv", 
                        stringsAsFactors = F)
  
  output$sum_plot <- renderPlot({
    get_summary_plot()
  })
  
  output$reg_map <- renderPlot({
    get_reg_map(shootings, regs, input$year_input, input$reg_type_input)
  })
}
