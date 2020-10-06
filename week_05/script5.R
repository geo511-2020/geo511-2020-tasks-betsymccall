###################################################
##Case Study #5, GEO 511
##Author: Betsy McCall
##Date: 10/03/2020
##Revised: 
###################################################
library(spData)
library(sf)
library(tidyverse)
library(units)

data(world)
data(us_states)

#transform coordinates
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

worlda <- st_transform(world, crs=albers)
#filter to Canada only, and add buffer of 10km
worldac <- worlda %>% filter(name_long=="Canada")
worldacb <- st_buffer(worldac, dist = 10000)
#transform US map
us_statesa <- st_transform(us_states, crs=albers)
#filter to NY state only
us_statesany <- us_statesa %>% filter(NAME=="New York")

border_10km <- st_intersection(worldacb,us_statesany)
#plot 10km border of Canada in NY
map <- ggplot(data=us_statesany)+geom_sf()+geom_sf(data=border_10km,fill="red")
print(map)
#find area
border_area <- st_area(border_10km)
print(border_area)
#convert to kilometers-squared
#border_area_km2 <- border_area/10^6
#print(border_area_km2)
units(border_area) <- as_units("km^2")
print(border_area)

