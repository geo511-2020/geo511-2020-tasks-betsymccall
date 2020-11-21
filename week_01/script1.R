###################################################
##Script for Case Study #1, GEO 511
##Author: Betsy McCall
##Created: 09/08/2020
##Edited:
###################################################

data(iris)

petal_length <- iris$Petal.Length
petal_length_mean <- mean(petal_length)

hist(petal_length,main="Petal Length of Irises", xlab="petal length",col="dark magenta")
##hist(petal_length,main="Petal Length of Irises", xlab="petal length",col="dark magenta", freq=FALSE)

##ggplot version
library(ggplot2)

plot2 <- ggplot(iris, 
                aes(x=petal_length))+
  geom_histogram(binwidth=0.5,color="black", 
                 fill="dark magenta")+
  labs(title="Histogram of Iris Petal Lengths")
print(plot2)

############################################
##end
############################################
