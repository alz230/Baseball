
wd <- getwd() 

razzh_file = paste(wd, "/Inputs/razzh.csv", sep = "")
razzp_file = paste(wd, "/Inputs/razzp.csv", sep = "")
vegas_file = paste(wd, "/Inputs/vegas.csv", sep = "")
teammap = paste(wd, "/Inputs/teammap.csv", sep = "")
playermap = paste(wd, "/Inputs/playermap.csv", sep = "") 

razzh = read.csv(razzh_file, header = TRUE)
razzp = read.csv(razzp_file, header = TRUE)
vegas = read.csv(vegas_file, header = TRUE)
teammap = read.csv(teammap, header = TRUE)
playermap = read.csv(playermap, header = TRUE)