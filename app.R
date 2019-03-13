# INFO 201 Group AC6
# Final Project
#
# Contains the code for actually running the app.

library("shiny")
library("dplyr")
library("ggplot2")


source("main_ui.R")
source("main_server.R")

shinyApp(ui = main_ui, server = main_server)