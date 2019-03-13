library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")

age_ui <- fluidPage(
  titlePanel("Comparing Presense of Firearm Provision Laws to # of Mass Shootings"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Allows users to select what firearm regulation to display.
      selectInput(
        inputId = "reg_type_input",
        label = "Select Firearm Provision Regulation:",
        choices = c("Illegal to Sell Long Guns to Ages <18" = "age18longgunsale",
                    "Illegal to Sell Hand Guns to Ages <21" = "age21handgunsale",
                    "Illegal for Felon to Possess Firearm" = "felony",
                    "Universal Background Check Required for Gun Purchase" = "universal",
                    "Stand Your Ground Law Exists" = "nosyg",
                    "Assault Weapons Banned" = "assault",
                    "Illegal for People Treated for Alcoholism to Possess Firearms" = "alcoholism")
      ),
      
      hr(),
      
      # Lets users choose a year.
      selectInput(
        inputId = "year_input",
        label = "Select a Year:",
        choices = c(2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008,
                    2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 1998,
                    1997, 1996, 1995, 1994, 1993, 1992, 1991)
      )
      
    ),
    
    
    # Contains map plot output.
    mainPanel(
      plotOutput(outputId = "age_map")
    )
    
  )
)