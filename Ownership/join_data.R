# 0. Packages Required ----------------------------------------------------
library(dplyr)
library(readr)

# 1. Load Data ------------------------------------------------------------
razz_hitter <- read_csv("./Inputs/razzh.csv")
vegas_data <- read_csv("./Inputs/vegas.csv")
team_map <- read_csv("./Inputs/teammap.csv")

# 2. Combine datasets -----------------------------------------------------
player_data <-
  razz_hitter %>%
  left_join(team_map, by = c("Team" = "Shortname")) %>%
  left_join(vegas_data, by = c("Vegas Name" = "Team",
                               "Date" = "Date",
                               "GT" = "Time"))