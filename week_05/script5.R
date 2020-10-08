###################################################
##Case Study #5, GEO 511
##Author: Betsy McCall
##Date: 10/03/2020
##Revised: 10/07/2020
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

##what if we wanted to plot the US Border Zone inside the US, including coastlines?
worldaUS <- worlda %>% filter(name_long=="United States")
worldaUSb <- st_buffer(worldaUS, dist = -160934)
mapUS1 <- ggplot(data=worldaUSb)+geom_sf()
print(mapUS1)

#a buffer done with negative units removes borders, so will overlay with unbuffered country map to display border
mapUS2 <- ggplot(data=worldaUS)+geom_sf(fill="red")+geom_sf(data=worldaUSb)
print(mapUS2)

border_area2 <- st_area(worldaUS)-st_area(worldaUSb)
print(border_area2)
units(border_area2) <- as_units("km^2")
print(border_area2)

border_100mi <- st_difference(worldaUS,worldaUSb)
border_area3 <- st_area(border_100mi)
print(border_area3)
units(border_area3) <- as_units("km^2")
print(border_area3)

USmap_border <- ggplot(data=border_100mi)+geom_sf(fill="red")
print(USmap_border)
