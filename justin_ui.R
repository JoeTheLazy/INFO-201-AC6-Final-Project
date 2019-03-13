library(shiny)
library(dplyr)
library(ggplot2)
library(stringr) 
library(tidyr)
library(scales)

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


shinyServer(fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("variable", "Display data of shootings in states:",
                   c("With Mental Health Restrictions" = "with_mental", "Without Mental Health Restrictions" = "without_mental"))),
   
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel(("Graph"), plotOutput("graph"), textOutput("text1"), textOutput("text2"))
                  
                
                  
      )
    )
  )
))


