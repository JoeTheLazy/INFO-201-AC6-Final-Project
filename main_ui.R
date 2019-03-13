library("shiny")
library("dplyr")
library("ggplot2")

main_ui <- fluidPage(
  
  titlePanel("Comparing Firearm Regulations Data to Mass Shootings Data"),
  
  h3("By: (insert group member names here) "),
  
  hr(),
  
  p("Our app allows users to compare the ", strong("presence or absence of 
    firearm regulation laws"), " to data concerning ", 
    strong("mass shootings in the US.")),
  
  tabsetPanel(
    type = "tabs",
    
    tabPanel(
      title = "Section1",
      
      h3("Are mass shootings getting worse in more recent years?"),
      
      sidebarLayout(
        
        sidebarPanel(
          
          p("That's a great question to ask! So, we used the mass shooting data 
            and plot the trend and the change of numbers of victims during the 
            mass shootings from 1990 to 2017."),
          
          p("From that, we can see the number of the victims are getting higher 
            in the recent years comparing to 1990s. The number of fatalities 
            during the mass shooting reached the hightest in 2015, and the 
            numbers of injured people as well as victims kept going high until 
            2017.")
          
        ),
        
        # Contains data plot output.
        mainPanel(
          plotOutput(outputId = "sum_plot")  
        )
      ) 
        
    ),
    
    tabPanel(
      title = "Section2"
    ),
    
    tabPanel(
      title = "Section3"
    ),
    
    tabPanel(
      title = "Section4"
    )
  )
  
)
