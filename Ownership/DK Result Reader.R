# 0. Packages -----------------------------------------------------------------
library(dplyr)
library(readr)
library(stringr)

# 1. Load Data ----------------------------------------------------------------
filename <- "0626157moonshot.csv"
filelocation <- paste("./Inputs/DraftKing Results/", filename, sep = "")
tbl <- read_csv(filelocation)


#set date
date = as.Date(substr(filename, 1,6), "%m%d%y")
date = format(date, format = "%d-%b")

#filter game times
gt = substr(filename, 7,7)
if(gt == 7) {
  gt = c(7:10) 
}  else if (gt == 1) {
  gt = c(1:6, 11:12) 
}  else if (gt == 3){
  gt = c(3:6)
} else { 
  gt = c(1:12)
}

#pull subset of razzball database
df = data.frame()
df <- subset(razzh, Date == date & GT %in% gt)


#functions
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


