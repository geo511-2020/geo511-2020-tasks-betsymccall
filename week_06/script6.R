#################################################
##Case Study #6 GEO 511
##Author: Betsy McCall
##Date: 10/10/2020
##Revised:
#################################################

library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)

##data
data(world)
tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)
#use one or the other, not both -- the above code produced a retrieval error -- got it to work on the 9millionth try...
#install package
#library(ncdf4)
#download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc")
#tmean=raster("crudata.nc")
#this last line generated an error also

#remove Antarctica and convert data type
world_no_sp <- world %>% filter(continent != "Antarctica")
world_no_sp_sp <- as(world_no_sp, Class="Spatial")

x11()
plot(tmax_monthly)

#rescale units
gain(tmax_monthly) <- 0.1

#obtain annual maximum
yrtmax <- max(tmax_monthly)
names(yrtmax)<- "tmax"

#find max per country
nat_tmax <-raster::extract(yrtmax,world_no_sp_sp,fun=max,na.rm=TRUE,small=TRUE,sp=TRUE)
nat_tmax_sf <- st_as_sf(nat_tmax)

#plot results
map <-ggplot(nat_tmax_sf)+geom_sf(aes(fill=tmax))+scale_fill_viridis_c(name="Yearly Maximum Temperature (C)")+theme(legend.position="bottom",axis.text=element_text(size=12),legend.title=element_text(size=16),legend.text=element_text(size=14))
x11()
print(map)

ggsave(filename="yearly_temp_max.png",device="png")

#print list of hottest nations by country
hottest_nats <- nat_tmax_sf %>% st_set_geometry(NULL)%>% group_by(continent)%>%top_n(1,tmax) %>% arrange(desc(tmax)) %>% dplyr::select(name_long,continent,tmax)
head(hottest_nats)


