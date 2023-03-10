##### Database building ----
# Author: Brynn Harshbarger
# Date: 2023-03-09
# In this script, I read in csv files of each tamarin group and rbind them into 
# one data frame. I rename columns and create a serial autoincrement unique 
# identifier. I then establish a connection with SQlite and create my 
# database with a table called tamarin. 

library(DBI)
library(dplyr)

group_lc <- read.csv("data-raw/group_lc_habitat.csv") # read in csv files
group_ph <- read.csv("data-raw/group_ph_habitat.csv")
group_ba <- read.csv("data-raw/group_ba_habitat.csv")

groups <- rbind(group_lc, group_ph, group_ba) # combine into 1 data frame

groups_1 <- na.omit(groups)

groups_1 <- groups_1 %>% # merge date time columns
  mutate(date_time = as.POSIXct(paste(Date, Time), 
         format = "%m/%d/%Y %H:%M"))

groups_1 <- groups_1[c(-2, -3)] # remove date and time columns

groups_1 <- rename(groups_1, group_id = Group, waypoint = Waypoint, lat = LAT,
                   lon = LON, habitat = Habitat, boundary_1 = Boundary, 
                   boundary_2 = Boundary.2, height = Height.Verbatim,
                   height_code = Height.Code, canopy_level = Canopy.Level...Verbatim,
                   canopy_level_code = Canopy.Level.Code)

groups_1$unique_id <- 1:nrow(groups_1)

my_db <- dbConnect(RSQLite::SQLite(), "my_db.db") # establish database connection

dbExecute(my_db, "DROP TABLE tamarin;")

dbExecute(my_db, "CREATE TABLE tamarin(
          unique_id VARCHAR(5) NOT NULL,
          group_id VARCHAR(2) NOT NULL,
          waypoint VARCHAR(4) NOT NULL,
          lat CHAR(7) NOT NULL,
          lon CHAR(7) NOT NULL,
          habitat VARCHAR(10),
          boundary_1 VARCHAR(10),
          boundary_2 VARCHAR(10),
          height VARCHAR(10),
          height_code VARCHAR(10),
          canopy_level VARCHAR(10),
          canopy_level_code VARCHAR(5),
          date_time VARCHAR(20),
          PRIMARY KEY (unique_id)
          );"
          )

dbGetQuery(my_db, "SELECT * FROM tamarin LIMIT 10;")

dbWriteTable(my_db, "tamarin", groups_1, append = TRUE)

dbGetQuery(my_db, "SELECT * FROM tamarin LIMIT 10;")
