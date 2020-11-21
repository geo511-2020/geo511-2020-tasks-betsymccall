########################################################
##Case Study #4 GEO 511
##Author: Betsy McCall
##Created: 09/23/2020
##Edited:
########################################################
# import libraries
library(tidyverse)
library(nycflights13)
# import data tables
data("flights")
data("weather")
data("planes")
data("airports")
data("airlines")

# glimpse(flights) # contains the distances
# glimpse(airports) # contains full names of airports

flights_sorted <- flights %>% 
  arrange(desc(distance))

# glimpse(flights_sorted)  # look at sorted to find maximum distance

flights_longest <- flights_sorted %>% 
  filter(distance==4983) # filter to contain only flights going longest distance

# glimpse(flights_longest) # look at database to determine what is the airport code

airports_filtered <- airports %>% 
  filter(faa=='HNL')
# glimpse(airports_filtered)  # find airport and filter

flights_hnl <- flights_longest %>% 
  filter(dest=='HNL') %>%
  mutate(faa = dest)

flights_joined <- flights_hnl %>% 
  left_join(airports, by="faa")

#now that tables are joined, we can extract the name of the airport

destination <- flights_joined %>% 
  select(distance,origin,faa, name) %>% 
  glimpse()

dest_name_only <- flights_joined %>% 
  select(name) %>% 
  glimpse()

## The airport furthest from New York domestically, is Honolulu International Airport

#####################################################
##Optional Extra stuff
#####################################################
airports %>%
  distinct(lon,lat) %>%
  ggplot(aes(lon, lat)) +
  borders("world") +
  geom_point(col="red") +
  coord_quickmap()

ggsave("world_airports.png", width=20, units="cm")


