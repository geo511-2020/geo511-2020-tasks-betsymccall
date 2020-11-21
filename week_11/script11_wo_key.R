####################################################
##Case Study #11, GEO 511
##Author: Betsy McCall
##Date: 11/14/2020
##Edited: 11/17/2020
####################################################

library(tidyverse)
library(spData)
library(sf)

## New Packages #install
library(mapview) # new package that makes easy leaflet maps
library(foreach)
library(doParallel)
registerDoParallel(4)
getDoParWorkers() # check registered cores

# go to  http://api.census.gov/data/key_signup.html and get a key, then run the line below with your key.  Don't push your key to github!
library(tidycensus)
census_api_key(KEYGOESHERE)
##remove key from final draft

racevars <- c(White = "P005003", 
              Black = "P005004", 
              Asian = "P005006", 
              Hispanic = "P004003")

options(tigris_use_cache = TRUE)
erie <- get_decennial(geography = "block", variables = racevars, 
                      state = "NY", county = "Erie County", geometry = TRUE,
                      summary_var = "P001001", cache_table=T) 

boundary <- c(xmin=-78.9,xmax=-78.85,ymin=42.888,ymax=42.92)
buffalo_crop <- st_crop(erie,boundary)

buffalo_crop$variable <- as.factor(buffalo_crop$variable)
#with assist from Ting
buffalo_par <- foreach(i=1:4, .combine='rbind',.packages=c("tidyverse","sf")) %dopar% {
  race<-levels(buffalo_crop$variable)[i]
  
  buffalo_crop %>% filter(variable==race) %>% st_sample(size=.$value) %>% st_as_sf() %>% mutate(variable=race)
}


mapview(buffalo_par,zco="variable",cex=1,lwd=0)
