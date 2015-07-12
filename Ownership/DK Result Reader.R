# 0. Packages -----------------------------------------------------------------
library(dplyr)
library(readr)
library(stringr)

# 1. Load Data ----------------------------------------------------------------
# Read in data for <???>
filename <- "0626157moonshot.csv"
filelocation <- paste("./Inputs/DraftKing Results/", filename, sep = "")
tbl <- read_csv(filelocation)

# Read in data razz hitter data
razzh <- read_csv("./Inputs/razzh.csv")
# Read in Vegas data
vegas_data <- read_csv("./Inputs/vegas.csv")
# Data mapping for teaminfo
team_map <- read_csv("./Inputs/teammap.csv")

# 2. Data Munging -------------------------------------------------------------

# 2.1 Set date and game time based on name of the file ------------------------

# Function that takes in the name of the file and returns a list with 
# the game date and game time
set_date_game_time <- function(file_name) {
  # Set date
  date <- as.Date(substr(file_name, 1,6), "%m%d%y")
  date <- format(date, format = "%d-%b")  
  
  # Set game time
  gt <- substr(file_name, 7,7)
  
  if(gt == 7) {
    gt = c(7:10) 
  }  else if (gt == 1) {
    gt = c(1:6, 11:12) 
  }  else if (gt == 3){
    gt = c(3:6)
  } else { 
    gt = c(1:12)
  }
  
  # Combine the 2 and return a list with Date and Game Time
  date_game_time <- list("Date" = date, "Game_Time" = gt)
  date_game_time
}

date_game_time <- set_date_game_time(filename)

# 2.2 Razzh data set ---------------------------------------------------------
razzh_filtered <-
  razzh %>%
  left_join(team_map, by = c("Team" = "Shortname")) %>%
  left_join(vegas_data, by = c("Vegas Name" = "Team",
                               "Date" = "Date",
                               "GT" = "Time")) %>%
  # Filter out razzh for only matching date and game time
  filter(Date == date_game_time$Date & GT %in% date_game_time$Game_Time) %>%
  # Select the columns we want to keep from razzh
  select(Name, Team, Pos, `UP PTS`)

# 3. Ownership Analysis -------------------------------------------------------

entrants <- c("waterboyalz", "maxdalury", "BeepImaJeep", "CSURAM88")
  
lineup_data <-
  tbl %>%
  # Clean up the entry names and Lineup
  mutate(EntryName = gsub(" \\((.*)\\)","", EntryName)) %>%
  mutate(Lineup = gsub("\\((.*)\\) ","", Lineup)) %>%
  mutate(Lineup = gsub(" $","", Lineup))
  
ownership_data <-
  razzh_filtered %>%
  full_join(lineup_data, by = c("Name" = "Lineup")) %>%
  arrange(Name) %>%
  filter(is.na(Rank))
  mutate(test = )
  mutate(Ownership = )


# Helper functions
ownership <- function(x, y) {
  round(mean(grepl(x, y$Lineup)), digits = 4)
}

player_lineup <- function(x) {
  subset(tbl, grepl(x,tbl$EntryName), drop=TRUE)
}

#subsets for certain players
myentries = player_lineup("waterboyalz")
maxdalury = player_lineup("maxdalury")
beepimajeep = player_lineup("BeepImaJeep")
csuram88 = player_lineup("CSURAM88")

#ownership analysis
own = data.frame(df$Name, 
                df$Team, 
                df$Pos,
                df$X..UP.PTS,
                sapply(df$Name, ownership, y = tbl),
                sapply(df$Name, ownership, y = myentries),
                sapply(df$Name, ownership, y = maxdalury)
)
own = own[order(-own[,5]),]
colnames(own) <- c("Name", "Team", "Position", "Value", "Ownership", "mine", "max")

#my summary
mine = subset(own, mine > 0);  mine = mine[order(-mine[,6]),]
max = subset(own, max > 0); max = max[order(-max[,7]),]


##STACK ANALYSIS##
y <- data.frame(str_split(as.character(tbl$Lineup), " ,")
                , stringsAsFactors = FALSE)
z <- length(y)
colnames(y) <- c(1:z)
y <- t(y)
y <- substring(y, as.numeric(gregexpr(") ", y)) + 2)
#y <- data.frame(c(1:z), y)
#colnames(y) <- c("Count", "V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10")

tbl2 <- data.frame(tbl,
                   y)

a <- data.frame(razzh$Name,
                razzh$Team,
                stringsAsFactors = FALSE
                )

z <- merge(y, a, by.y = "razzh.Name", by.x = "V1")


