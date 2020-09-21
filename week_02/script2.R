##############################################
##Case Study #2: Climate Change
##Author: Betsy McCall
##Created: 09/13/2020
##Edited:
##############################################

library(tidyverse)

# define the link to the data - you can try this in your browser too
dataurl="https://raw.githubusercontent.com/AdamWilsonLab/SpatialDataScience/master/docs/02_assets/buffaloweather.csv"

temp=read_csv(dataurl,
              skip=1, #skip the first line which has column names
              na="999.90", # tell R that 999.90 means missing in this dataset
              col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                            "APR","MAY","JUN","JUL",  
                            "AUG","SEP","OCT","NOV",  
                            "DEC","DJF","MAM","JJA",  
                            "SON","metANN"))
# renaming is necessary because they used dashes ("-")
# in the column names and R doesn't like that.

#select a subset of the data to work with
summer_temp <- select(temp, YEAR, JJA)

plot_buffalo <- ggplot(summer_temp, aes(x=YEAR, y=JJA))+
  geom_line()+geom_smooth(color="red")+
  labs(x="Year", y="Mean Summer Temperatures (C)") + 
  ggtitle("Mean Summer Temperatures in Buffalo, NY (1880-2018)")

print(plot_buffalo)

ggsave("temp_buffalo.png", width = 17, height = 10, units = "cm")

##based on the graph, I'd have to tell my grandfather that 
##this looks like a pretty solid upward trend.

##Let's look at Juneau, Alaska, too

dataurl2="https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_USW00025309_14_0_1/station.csv"

temp2=read_csv(dataurl2,
              skip=1, #skip the first line which has column names
              na="999.90", # tell R that 999.90 means missing in this dataset
              col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                            "APR","MAY","JUN","JUL",  
                            "AUG","SEP","OCT","NOV",  
                            "DEC","DJF","MAM","JJA",  
                            "SON","metANN"))

summer_temp2 <- select(temp2, YEAR, JJA)

plot_juneau <- ggplot(summer_temp2, aes(x=YEAR, y=JJA))+
  geom_line()+geom_smooth(color="red")+
  labs(x="Year", y="Mean Summer Temperatures (C)") + 
  ggtitle("Mean Summer Temperatures in Juneau, AK (1899-2020)")

print(plot_juneau)

ggsave("temp_juneau.png", width = 17, height = 10, units = "cm")
