library("shiny") 
library('dplyr')
library('tidyr')

#input the targeted data
shootings_data <- read.csv("data/Mass Shootings Dataset Ver 5.csv", 
                       stringsAsFactors = FALSE)

law_data <- read.csv("data/raw_data.csv", 
                           stringsAsFactors = FALSE)

# to extract the state and year information for each mass shooting 
#and add them to the data frame
add_states_and_years_to_shootings <- function(shootings_frame) {
  # From the "Location" column, create a vector containing the states.
  locations <- shootings_frame$Location
  states <- strsplit(locations, ",")
  states_list <- lapply(lapply(states, tail, n = 1), trimws)
  states_vector <- unlist(states_list, use.names = F)
  
  # From the "Date" column, create a vector containing the years.
  dates <- shootings_frame$Date
  years <- lapply(strsplit(dates, "/"), as.numeric)
  years_list <- lapply(lapply(years, tail, n = 1), trimws)
  years_vector <- unlist(years_list, use.names = F)
  years_vector <- as.numeric(years_vector)
  
  mutate(shootings_frame, "State" = states_vector, "year" = years_vector)
}

shooting_with_y_s <- add_states_and_years_to_shootings(shootings_data)

#create a user interface
my_ui <- fluidPage(   
  titlePanel("Number of mass shootings corresponding 
             to the number of gun regulations"), #make a title 
  
  sidebarLayout( #set a side bar layout
    sidebarPanel(  
      # lables and contents for the side bar widget one
      em("Select the state that you are interested in"),
      selectInput(
        inputId = "state",
        label = "Pick a state",
        choices = law_data[1:50,'state']
      )
    ),    
    
    # specify content for the "main" Panel
    mainPanel( 
      plotOutput("plot")
    )
  )
)