# INFO 201 Group AC6
# Final Project
#
# Contains the ui for our app.

library("shiny")
library("dplyr")
library("ggplot2")

regs <- read.csv("data/raw_data.csv", stringsAsFactors = F)

main_ui <- fluidPage(
  
  titlePanel("Comparing Firearm Regulations Data to Mass Shootings Data"),

  h3("By: Xuejiao Li, Nikolai Frank Nilsen, Zixin Wang, Justin C Woo"),
  
  hr(),
  
  p("Our app allows users to compare the ", strong("presence or absence of 
    firearm regulation laws"), " to data concerning ", 
    strong("mass shootings in the US.")),
  
  # Contains each section related to our critical questions.
  tabsetPanel(
    type = "tabs",
    
    # Jimmy's Section.
    tabPanel(
      title = "Victims",
      
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
    
    # Frank's section.
    tabPanel(
      title = "Firearm Regulations",
      
      h3("Do Certain Firearm Regulations Affect # of Mass Shootings?"),
      
      sidebarLayout(
        
        sidebarPanel(
          
          # Allows users to select what firearm regulation to display.
          selectInput(
            inputId = "reg_type_input",
            label = "Select Firearm Provision Regulation:",
            choices = c("Illegal to Sell Long Guns to Ages <18" = 
                          "age18longgunsale",
                        "Illegal to Sell Hand Guns to Ages <21" = 
                          "age21handgunsale",
                        "Illegal for Felon to Possess Firearm" = "felony",
                        "Universal Background Check Required for Gun Purchase" =
                          "universal",
                        "Stand Your Ground Law Exists" = "nosyg",
                        "Assault Weapons Banned" = "assault",
                        "Illegal for People Treated for Alcoholism to Possess 
                          Firearms" = "alcoholism")
          ),
          
          hr(),
          
          # Lets users choose a year.
          selectInput(
            inputId = "year_input",
            label = "Select a Year:",
            choices = c(2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008,
                        2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 
                        1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991)
          ),
          
          hr(),
          
          p(strong("Blue"), " indicates a state with the selected firearm 
            provisions law, while ", strong("Red"), " indicates a state 
            without. Each ", strong("black dot"), " represents the location
            of a mass shooting. All data is shown for the ", 
            strong("selected year"))
        
        ),
        
        
        # Contains map plot output.
        mainPanel(
          plotOutput(outputId = "reg_map")
        )
        
      ),
      
      p("Overall, there ", strong("does not seem to be any strong correlation"),
        " between any specific firearm provisions law to the number of mass 
        shootings. However, ", strong("many south-eastern states"), " seem to 
        have more mass shootings in 2015 and 2016 compared to others, which 
        lack many of the selectable firearm provision laws."),
      
      p("Of note is that the presence of a ", strong("\"Stand Your Ground\""), 
        " law does not seem to be a deterrent for mass shootings")
    ),
    
    # Ayla's section.
    tabPanel(
      title = "Totals",
      
      h3("Number of mass shootings corresponding 
             to the number of gun regulations"),
      
      sidebarLayout( #set a side bar layout
        sidebarPanel(  
          # lables and contents for the side bar widget one
          em("Select the state that you are interested in"),
          selectInput(
            inputId = "state",
            label = "Pick a state",
            choices = regs[1:50,'state']
          )
        ),    
        
        # specify content for the "main" Panel
        mainPanel( 
          plotOutput("plot")
        )
      )
      
    ),
    
    # Justin's section.
    tabPanel(
      title = "Mental Health",
      
      sidebarLayout(
        sidebarPanel(
          radioButtons("variable", "Display data of shootings in states:",
                       c("With Mental Health Restrictions" = "with_mental", "Without Mental Health Restrictions" = "without_mental"))),
        
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel(("Graph"), plotOutput("graph"), p(textOutput("text1")), p(textOutput("text2")))
                      
                      
                      
          )
        )
      )
    )
  )
  
)
