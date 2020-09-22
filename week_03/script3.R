##################################################
##Case Study #3 GEO 511
##Author: Betsy McCall
##Date: 09/21/2020
##Revised:
##################################################

library(gapminder) 
library(ggplot2)
library(dplyr) 

##remove Kuwait
gapdat1 <- gapminder %>%
  filter(country != 'Kuwait')

plot1 <- ggplot(data=gapdat1, aes(x=lifeExp, y=gdpPercap, color=continent, size=pop/100000))+
  geom_point()+theme_bw()+
  facet_wrap(~year,nrow=1) +
  scale_y_continuous(trans = "sqrt") + 
  labs(x="Life Expectancy", y="GDP per capita")
print(plot1)

ggsave("life_exp_v_GDP_per_Cap_by_pop_continent.png", width = 27, height = 15, units = "cm")

## start of plot 2
gapdat2 <- gapminder %>%
  group_by(continent, year) 

gapminder_continent <- gapdat2 %>%
  summarize(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop),pop = sum(as.numeric(pop)))
  

plot2 <- ggplot(gapdat1,aes(x=year)) + 
  geom_line(aes(y=gdpPercap, group=country, color=continent)) + 
  geom_point(aes(y=gdpPercap, color=continent, size=pop/100000, group=country)) + 
  facet_wrap(~continent,nrow=1) + 
  theme_bw()+
  labs(x="Year", y="GDP per capita")

print(plot2)

plot2_1 <- plot2 + geom_line(data=gapminder_continent,color="black",aes(x=year, y=gdpPercapweighted)) + 
  geom_point(data=gapminder_continent,color="black",aes(y=gdpPercapweighted, size=pop/100000)) 

print(plot2_1)
##Save image
ggsave("GDP_per_Cap_over_time_by_pop_continent.png", width = 15, height = 8, units = "in")

##assistance from Group 2 (Ting especially), to fix second plot error

