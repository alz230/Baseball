library(rvest)

##Initialize database##
combined <- data.frame()






##Set the date##

today <- Sys.Date() - 1

start <- as.Date("2015-06-22")
end <- as.Date("2015-06-26")
#end <- today  ##use this if want complete database

count <- as.numeric(end - start) + 1


for (i in 1:count){

  
##Generate the link for the lineups##
date = start + i - 1
  
link <- paste("http://www.baseballpress.com/lineups/", date, sep = "")
order <- html(link)


##Download list of players##
players <- data.frame(
  order %>% 
  html_nodes(".players .player-link") %>%
  html_text()
  )
colnames(players) <- c("name")


##Download team names##
team <- data.frame(
  order %>%
    html_nodes(".team-name") %>%
    html_text()
)
colnames(team) <- c("team")




##Download gametimes##
gt <- data.frame(
  order %>%
    html_nodes(".game-time") %>%
    html_text()
)
colnames(gt) <- c("gt")


##Converting##
conv <- function(x) {
  if(gregexpr(pattern = ":", x) == 3)
    substr(x, 1, 2)
  else
    substr(x, 1, 1)
}


##Summarize data##
summary <- data.frame(
  date,
  sapply(rep(gt$gt, each = 18), conv),
  rep(1:9),
  players$name,
  rep(team$team, each = 9)
  )
colnames(summary) <- c("date", "gt", "order", "name", "team" )

##Append to list##
combined <- rbind(combined, summary)

}

