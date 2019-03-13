library("shiny") 
library('dplyr')
library('tidyr')
library("ggplot2") 
source('my_ui.R')

# use values from `input` list# assign values to `output` list
my_server <- function(input, output) {

  #output plot with selected data
  output$plot <- renderPlot({
    shooting_with_spec_state <- filter(shooting_with_y_s,
                                       State == input$state)
   
    shooting_with_spec_state_grouped <- shooting_with_spec_state %>%
      group_by(year) %>%
      summarize(
        number_of_shootings = n()
      )
    law_year <- law_data[,c('state','year','lawtotal')]
    law_year_state <- filter(law_year,state == input$state)
    
    law_year_state_num <- left_join(
      law_year_state, 
      shooting_with_spec_state_grouped, 
      by = "year")
    
     law_year_state_num
     
      ggplot(data = law_year_state_num) +
       geom_point(
         mapping = aes(x = year, y = lawtotal,size = as.integer(number_of_shootings)),
         color = "RED"
       ) +
        scale_size_continuous(breaks = 1:5)
  })
}