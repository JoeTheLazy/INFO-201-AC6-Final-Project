# INFO 201 AC6
# Final Project
#
# Contains functions for use in the map plots of app.

library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")

get_age_map <- function(shootings_frame, reg_frame, input_year, reg_type) {
  new_shootings <- add_states_and_years_to_shootings(shootings_frame) %>% 
    filter(Year == input_year) %>% 
    drop_na(State) %>%
    drop_na(Latitude)
  
  new_regulations <- reg_frame %>% 
    filter(year == input_year) %>% 
    mutate(state = tolower(state))
  
  if (reg_type == "age18longgunsale") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (age18longgunsale == 1)
    )
  } else if (reg_type == "age21longgunsale") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (age21longgunsale == 1)
    )
  } else if (reg_type == "felony") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (felony == 1)
    )
  } else if (reg_type == "universal") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (universal == 1)
    )
  } else if (reg_type == "nosyg") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (nosyg == 0)
    )
  } else if (reg_type == "assault") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (assault == 1)
    )
  } else {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (alcoholism == 1)
    )
  }
  
  state_shape <- map_data("state")
  
  state_regs <- left_join(state_shape, new_regulations, 
                          by = c("region" = "state")) %>% 
    drop_na(law_exists)
  
  blank_theme <- theme_bw() +
    theme(
      axis.line = element_blank(),        # remove axis lines
      axis.text = element_blank(),        # remove axis labels
      axis.ticks = element_blank(),       # remove axis ticks
      axis.title = element_blank(),       # remove axis titles
      panel.grid.major = element_blank(), # remove major grid lines
      panel.grid.minor = element_blank()  # remove minor grid lines
    )
  
  ggplot(state_regs) +
    geom_polygon(
      mapping = aes(x = long, y = lat, group = group, fill = law_exists),
      color = "white",
      size = .1
    ) + coord_map() + blank_theme + scale_fill_brewer(palette = "Set1") +
    geom_point(
      data = new_shootings,
      mapping = aes(x = Longitude, y = Latitude),
      color = "black"
    ) +
    labs(
      title = 
        paste0("Comparing Firearm Provisions Law Presence by State to # of 
               Mass Shootings in ", input_year)
    )
}

# Takes in a data frame representing mass shootings, and a year, and returns
# a map plot of the number of mass shootings by state in the given year.
get_shootings_map <- function(shootings_frame, input_year) {
  new_shootings <- add_states_and_years_to_shootings(shootings_frame) %>% 
    filter(Year == input_year) %>% 
    drop_na(State) %>%
    mutate(State = tolower(State)) %>% 
    group_by(State) %>% 
    summarize(num_shootings = length(Year))
  
  state_shape <- map_data("state")
  
  state_shootings <- left_join(state_shape, new_shootings, 
                               by = c("region" = "State"))
  
  blank_theme <- theme_bw() +
    theme(
      axis.line = element_blank(),        # remove axis lines
      axis.text = element_blank(),        # remove axis labels
      axis.ticks = element_blank(),       # remove axis ticks
      axis.title = element_blank(),       # remove axis titles
      panel.grid.major = element_blank(), # remove major grid lines
      panel.grid.minor = element_blank()  # remove minor grid lines
    )
  
  ggplot(state_shootings) +
    geom_polygon(
      mapping = aes(x = long, y = lat, group = group, fill = num_shootings),
      color = "white",
      size = .1
    ) + coord_map() + blank_theme + 
    scale_fill_distiller(palette = "YlOrRd", direction = 1) + 
    labs(
      title = paste0("Number of Mass Shootings by State in ", input_year)
    )
}

# Takes in a data frame representing firearm provision regulations, a year,
# and a specific firearm provision law, and returns a map plot showing whether
# each state has the given specific firearm provision law or not in the given 
# year.
get_reg_map <- function(reg_frame, input_year, reg_type) {
  new_regulations <- reg_frame %>% 
    filter(year == input_year) %>% 
    mutate(state = tolower(state))
  
  if (reg_type == "age18longgunsale") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (age18longgunsale == 1)
    )
  } else if (reg_type == "age21longgunsale") {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (age21longgunsale == 1)
    )
  } else {
    new_regulations <- mutate(
      new_regulations,
      law_exists = (age21handgunsale == 1)
    )
  }
  
  state_shape <- map_data("state")
  
  state_regs <- left_join(state_shape, new_regulations, 
                          by = c("region" = "state")) %>% 
    drop_na(law_exists)
  
  blank_theme <- theme_bw() +
    theme(
      axis.line = element_blank(),        # remove axis lines
      axis.text = element_blank(),        # remove axis labels
      axis.ticks = element_blank(),       # remove axis ticks
      axis.title = element_blank(),       # remove axis titles
      panel.grid.major = element_blank(), # remove major grid lines
      panel.grid.minor = element_blank()  # remove minor grid lines
    )
  
  ggplot(state_regs) +
    geom_polygon(
      mapping = aes(x = long, y = lat, group = group, fill = law_exists),
      color = "white",
      size = .1
    ) + coord_map() + blank_theme + scale_fill_brewer(palette = "Set1") +
    labs(
      title = 
        paste0("Presense or absence of Firearms Provision Law by State in ", 
               input_year)
    )
}

# Takes in a data frame representing our data on mass shootings,
# and returns a new data frame that has a "State" and "Year"
# column added to the given data frame.
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
  
  mutate(shootings_frame, "State" = states_vector, "Year" = years_vector)
}