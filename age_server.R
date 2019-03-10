library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")

source("age_analysis.R")

age_server <- function(input, output) {
  regs <- read.csv("data/raw_data.csv", stringsAsFactors = F)
  shootings <- read.csv("data/Mass Shootings Dataset Ver 5.csv", 
                        stringsAsFactors = F)
  
  output$reg_map <- renderPlot(
    get_reg_map(regs, input$year_input, input$reg_type_input)
  )
  
  output$shootings_map <- renderPlot(
    get_shootings_map(shootings, input$year_input)
  )
  
  
}
