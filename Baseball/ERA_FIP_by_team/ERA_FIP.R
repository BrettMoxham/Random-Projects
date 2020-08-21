## libraries
library(tidyverse)
library(rvest)
library(teamcolors)
library(ggimage)


url <- "https://www.baseball-reference.com/leagues/MLB/2020.shtml"


##scraping  (can't get it to work, return to this. )

#read_html(url) %>% 
 # html_nodes("#all_teams_standard_pitching") %>% 
  #html_text()  

team_pitching <- read_csv("Baseball/ERA_FIP_by_team/team_standard_pitching_2020.csv")


## Basic Graph

team_pitching %>% 
  ggplot(aes(ERA, FIP, label =Tm))+
  geom_point()+
  geom_text(aes(label = Tm), force = )+
  scale_x_reverse()+
  scale_y_reverse()

mlb_colors <- teamcolors %>% ##generating mlb colors only, need team code to join to our data set to generate logos
  filter(league == "mlb") %>% 
  mutate( 
    team_code = substr(name, 1,3))

mlb_colors %>% 
  count(team_code, sort = T) ## We have 8 teams that are similar in code, we need to case when to adjust that. 


mlb_colors <- mlb_colors %>% 
  mutate(
    team_code = case_when(
      name == "Chicago Cubs" ~ "CHC",
      name == "Chicago White Sox" ~ "CHW",
      name == "Los Angeles Angels" ~ "LAA",
      name == "Los Angeles Dodgers" ~ "LAD",
      name == "New York Yankees" ~ "NYY",
      name == "New York Mets" ~ "NYM",
      name == "San Francisco Giants" ~ "SFG",
      name == "San Diego Padres" ~ "SDP",
      name == "Kansas City Royals" ~ "KCR",
      name == "St. Louis Cardinals" ~ "STL",
      name == "Tampa Bay Rays" ~ "TBR",
      name == "Washington Nationals" ~ "WSN",
      T ~ team_code),
    team_code = toupper(team_code)
    )

team_pitching_joined <- team_pitching %>% 
  left_join(mlb_colors, by = c("Tm" = "team_code")) %>% 
  filter(!is.na(Tm))

team_pitching_joined %>% 
  filter(is.na(logo))


plot <- team_pitching_joined %>% 
  ggplot(aes(ERA, FIP, label =Tm))+
  geom_image(aes(image = logo), size = 0.05)+
  scale_x_reverse()+
  scale_y_reverse()+
  labs(
    title = "2020 Team Pitching",
    subtitle = "F.I.P by E.R.A",
    x = "Earned Runs Against",
    y = "Fielding Independent Pitching",
    caption =  "@bmoxO9 | #100DaysofCode
Source: Baseball Reference (https://tinyurl.com/yy3y5y7u)"
  )+
  geom_hline(aes(yintercept = 4.46),lty = 2, col = "red", alpha = 0.5)+
  geom_vline(aes(xintercept = 4.45),lty = 2, col = "red", alpha = 0.5)+ 
  theme_minimal()


ggsave("Baseball/ERA_FIP_by_team/plot.png", plot)

  