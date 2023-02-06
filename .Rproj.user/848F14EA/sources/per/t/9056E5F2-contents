#### Tamarin data exploration ####
library(sf)
library(tidyr)
ba <- read.csv("data-raw/group_ba.csv")
ph <- read.csv("data-raw/group_ph.csv")
lc <- read.csv("data-raw/group_lc.csv")
# remove NA from lc data frame
lc <- lc %>% drop_na(LAT)
# convert to sf object 
ba_sf <- st_as_sf(ba, coords = c("LON", "LAT"))
ph_sf <- st_as_sf(ph, coords = c("LON", "LAT"))
lc_sf <- st_as_sf(lc, coords = c("LON", "LAT"))

utm_proj <- sf::st_crs("+proj=utm +zone=12 +datum=WGS84")

ba_utm <- st_transform(ba_sf, crs = utm_proj)
