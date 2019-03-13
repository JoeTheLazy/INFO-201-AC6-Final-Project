library("shiny")
library("dplyr")
library("ggplot2")

source("age_ui.R")
source("age_server.R")

shinyApp(ui = age_ui, server = age_server)