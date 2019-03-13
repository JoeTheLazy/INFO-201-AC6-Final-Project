# INFO 201 Group AC6
# Final Project
#
# Contains the server for our app.

library("shiny")
library("dplyr")
library("ggplot2")
library("stringr") 
library("tidyr")
library("scales")
library("lubridate")

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
  
  substrfromN <- function(x, n){
    substr(x, nchar(x)-n+1, nchar(x))
  }
  
  mass_shootings <- read.csv("data/Mass Shootings Dataset Ver 5.csv", stringsAsFactors = FALSE)
  mass_shootings <- mutate(mass_shootings, year = as.numeric(substrfromN(mass_shootings$Date, 4)), state = gsub(".*, ","", mass_shootings$Location)) 
  
  with_mental_restrict <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE) %>%
    select(state, year, mentalhealth, invcommitment, invoutpatient, danger) %>% 
    mutate(men_restrict = mentalhealth + invcommitment + invoutpatient + danger) %>% 
    filter(men_restrict > 0) %>% inner_join(mass_shootings, by = c("state", "year")) %>%
    count(year)
  
  without_mental_restrict <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE) %>%
    select(state, year, mentalhealth, invcommitment, invoutpatient, danger) %>% 
    mutate(men_restrict = mentalhealth + invcommitment + invoutpatient + danger)  %>% 
    filter(men_restrict == 0) %>% inner_join(mass_shootings, by = c("state", "year")) %>%
    count(year)
  
  df <- full_join(without_mental_restrict, with_mental_restrict, by = "year")
  
  colnames(df)[2:3] <- c("with_mental", "without_mental")
  
  output$graph <- renderPlot({
    if(input$variable == "with_mental") {
      mental_table <- select(df, year, with_mental)
      ggplot(data = df) + geom_bar(mapping =aes(x = year, y = with_mental), stat = "identity") +
        labs(x="Years", y="# f Shootings", title="# of Shootings in States With Mental Health Restrictions")
    } else {
      mental_table <- select(df, year, without_mental)
      ggplot(data = df) + geom_bar(mapping =aes(x = year, y = without_mental), stat = "identity") +
        labs(x="Years", y="# f Shootings", title="# of Shootings in States Without Mental Health Restrictions")
    }
    
  })
  
  output$text1 <- renderText({
    if(input$variable == "with_mental"){
      paste0("This bar graph shows the number of mass shootings per year in states with mental health restrictions on gun purchases.")
    } else {
      paste0("This bar graph shows the number of mass shootings per year in states without mental health restrictions on gun purchases.")
    }
  })
  
  
  output$text2 <- renderText({
    paste0("The impact mental health background checks and restrictions have on decreasing the number of mass shootings based off our data seems to show only a slight decrease in shootings. What may help the restrictions be more effective is pinpointing mental health issues in people amongst the population to stop those that carry out shootings with issues that go unnoticed prior to acts of violence.")
    
  })
  
  output$text3 <- renderText({
    paste0('This graph shows the relationship between number of mass shootings and the number of laws of ',input$state, ' for each year. The size of the red circle on the graph refers to the number of mass shootings.')
  })
  
  output$plot <- renderPlot({
    shooting_with_y_s <- add_states_and_years_to_shootings(shootings)
    
    shooting_with_spec_state <- filter(shooting_with_y_s,
                                       State == input$state)
    
    shooting_with_spec_state_grouped <- shooting_with_spec_state %>%
      group_by(year) %>%
      summarize(
        number_of_shootings = n()
      )
    law_year <- regs[,c('state','year','lawtotal')]
    law_year_state <- filter(law_year,state == input$state)
    
    law_year_state_num <- left_join(
      law_year_state, 
      shooting_with_spec_state_grouped, 
      by = "year")
    
    ggplot(data = law_year_state_num) +
      geom_point(
        mapping = aes(x = year, y = lawtotal,size = as.integer(number_of_shootings)),
        color = "RED"
      ) +
      scale_size_continuous(breaks = 1:5)+
      labs(x="Years", y="# of laws", 
           title="# of laws and number of mass shootings for a given state each year",
           size = "# of mass shootings")
  })
}
