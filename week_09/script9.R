####################################################
##Tracking Hurricanes, Case Study #9, GEO 511
##Author: Betsy McCall
##Date: 10/31/2020
##Edited:
####################################################

library(sf)
library(tidyverse)
library(ggmap)
library(rnoaa)
library(spData)
data(world)
data(us_states)
library(kableExtra)
library(raster)
library(ggplot2)
library(forcats)

#storms <- storm_shp(basin = "NA")
#storm_data <- read_sf(storms$path)

dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
unzip(file.path(tdir,"temp.zip"),exdir = tdir)
#list.files(tdir)

storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))

#filter and make decades
storm_data_mod <- storm_data %>% filter(SEASON>=1950) %>% mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x))
storm_mod_dec <- storm_data_mod %>% mutate(decade=(floor(year/10)*10))

#storm_mod_dec <- st_transform(storm_mod_dec,crs(world))
us_states_match <- us_states %>% st_transform(crs(storm_mod_dec)) %>% rename(state=NAME)

#find bounding box
region <- st_bbox(storm_mod_dec)
xlims <- c(region[1],region[3])
ylims <- c(region[2],region[4])

#join data
#world_states <- st_join(us_states_match, world)
working <- st_join(storm_mod_dec, us_states_match, join=st_intersects, left=FALSE)

#make plot with help from Sandra and Ting
plot1 <- ggplot(data = world) +geom_sf(color = "gray40", fill = "honeydew2") +
  stat_bin2d(data=storm_mod_dec, aes(y=st_coordinates(storm_mod_dec)[,2],x=st_coordinates(storm_mod_dec)[,1]),bins=100) + 
  coord_sf(xlim=xlims, ylim=ylims, expand = FALSE) + scale_fill_distiller(palette="YlOrRd",trans="log",direction=-1, breaks=c(1,10,100,1000))
#plot1

plot2 <- plot1 + facet_wrap(~decade) + theme(axis.title.x=element_blank(),axis.title.y=element_blank())
x11()
plot2

#make table
working %>% group_by(state) %>% summarize(storms=length(unique(NAME))) %>% 
  arrange(desc(storms)) %>% slice(1:5) %>% st_set_geometry(NULL) %>% knitr::kable(format="simple")

working_year <- working %>% group_by(state,year) %>% summarize(storms=length(unique(NAME))) %>% arrange(storms)# %>% ggplot(aes(y=state,x=year,fill=storms))+geom_tile()+scale_fill_viridis_c(name="# of Storms")+ylab("State")
#working_year$state = with(working_year, reorder(state, storms, ))

#plot3 <- ggplot(working_year, aes(y=state,x=year,fill=storms))+geom_tile()+scale_fill_viridis_c(name="# of Storms")+ylab("State")
x11()
plot3
#this put Florida on top, but left everything else alphabetized

working_year %>% group_by(state) %>% summarize(storms=length(unique(NAME))) %>% 
  arrange(desc(storms)) %>%  st_set_geometry(NULL) %>% knitr::kable(format="simple")

#working_sort <- working_year %>% mutate(state = fct_relevel(state, 
#                          "Florida", "North Carolina", "Georgia", 
#                          "Texas", "Louisiana", "South Carolina", 
#                          "Alabama", "Mississippi", "Virginia","Tennessee",
#                          "Arkansas", "Kentucky","New York", "Pennsylvania",
#                          "Maine", "Missouri", "West Virginia", "Maryland",
#                          "Massachusetts","Illinois", "Ohio", "Oklahoma",
#                          "New Jersey", "Indiana", "New Hampshire", "Connecticut",
#                          "Michigan", "Delaware", "Kansas", "New Mexico",
#                          "Rhode Island", "Vermont", "Iowa", "Nebraska", "Wisconsin"))

#plot4 <- ggplot(working_sort, aes(y=state,x=year,fill=storms))+geom_tile()+scale_fill_viridis_c(name="# of Storms")+ylab("State")
#x11()
#plot4