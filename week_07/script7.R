##################################################
##Case Study 7, GEO 511
##Author: Betsy McCall
##Date: 10/19/2020
##Edited:
##################################################

library(tidyverse)
library(reprex)
library(sf)

library(spData)
data(world)

ggplot(world,aes(x=gdpPercap, y=continent, color=continent))+    geom_density(alpha=0.5)

reprex()

####################################################

graph <- ggplot(world,aes(x=gdpPercap, fill=continent))+geom_density(alpha=0.5, color=NA)
graph2 <- graph+theme(legend.position="bottom")+labs(x="GDP per Capita",y="Density")
x11()
print(graph2)
ggsave("case_study7_graph.png", width=15, units="cm")
