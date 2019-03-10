library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")

age_ui <- fluidPage(
  titlePanel("Comparing Presense of Age-Related Firearm Provision Laws to # of Mass Shootings"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Allows users to select what firearm regulation to display.
      selectInput(
        inputId = "reg_type_input",
        label = "Select Firearm Provision Regulation:",
        choices = c("Illegal to Sell Long Guns to Ages <18" = "age18longgunsale",
                    "Illegal to Sell Long Guns to Ages <21" = "age21longgunsale",
                    "Illegal to Sell Hand Guns to Ages <21" = "age21handgunsale")
      ),
      
      hr(),
      
      # Lets users choose a year.
      selectInput(
        inputId = "year_input",
        label = "Select a Year:",
        choices = c(2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008,
                    2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 1998,
                    1997, 1996, 1995, 1994, 1993, 1992, 1991)
      )
      
    ),
    
    
    # Contains map plot output.
    mainPanel(
      plotOutput(outputId = "reg_map"),
      plotOutput(outputId = "shootings_map")
    )
    
  )
)