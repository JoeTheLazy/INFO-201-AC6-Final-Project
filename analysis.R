library('tidyr')
library('dplyr')
library('ggplot2')
shooting <- read.csv(file = "Mass Shootings Dataset Ver 5.csv", stringsAsFactors = FALSE) %>%
  select(Date, Fatalities, Injured, Total.victims ,Policeman.Killed)
Years <- format(as.Date(shooting$Date, format="%m/%d/%Y"),"%Y")
shooting <- mutate(shooting, Years = Years) %>% 
  select(Fatalities, Injured, Total.victims ,Policeman.Killed, Years)%>% 
  group_by(Years) %>% 
  summarise(Fatalities = sum(Fatalities), Injured = sum(Injured), 
            Total_victims = sum(Total.victims), Policeman_killed = sum(Policeman.Killed))

shooting_df <- gather(shooting, kind, frequency, Fatalities : Policeman_killed) %>%
  filter(Years > 1989)

plot_shooting <- ggplot(data = shooting_df, aes(x = as.numeric(Years), y = as.numeric(frequency), group = kind, colour = kind)) + 
  geom_line(na.rm = TRUE) + 
  scale_x_continuous(breaks = c(1990, 1995, 2000, 2005, 2010, 2015, 2017)) + 
  ggtitle("Victims in Mass Shootings After 1990s") + xlab("Years") + ylab("Number of Victims") 

