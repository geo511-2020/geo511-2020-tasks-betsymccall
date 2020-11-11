######################################################
##Satellite Remote Sensing, Case Study 10, GEO 511
##Author: Betsy McCall
##Created: 11/08/2020
##Edited:
######################################################

library(raster)
library(rasterVis)
library(rgdal)
library(ggmap)
library(tidyverse)
library(knitr)
library(ncdf4)
#library(rts) -- more time series

# Create afolder to hold the downloaded data
dir.create("data",showWarnings = F)

lulc_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MCD12Q1.051_aid0001.nc?raw=true"
lst_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MOD11A2.006_aid0001.nc?raw=true"

# download the files
download.file(lulc_url,destfile="data/MCD12Q1.051_aid0001.nc", mode="wb")
download.file(lst_url,destfile="data/MOD11A2.006_aid0001.nc", mode="wb")

##edit  .gitignore file (in tasks repository folder) to include *data* on one line. 

lulc=stack("data/MCD12Q1.051_aid0001.nc",varname="Land_Cover_Type_1")
lst=stack("data/MOD11A2.006_aid0001.nc",varname="LST_Day_1km")

#plot data
x11()
plot(lulc)

lulc1=lulc[[13]]
x11()
plot(lulc1)

#classes from MODIS
Land_Cover_Type_1 = c(
  Water = 0, 
  `Evergreen Needleleaf forest` = 1, 
  `Evergreen Broadleaf forest` = 2,
  `Deciduous Needleleaf forest` = 3, 
  `Deciduous Broadleaf forest` = 4,
  `Mixed forest` = 5, 
  `Closed shrublands` = 6,
  `Open shrublands` = 7,
  `Woody savannas` = 8, 
  Savannas = 9,
  Grasslands = 10,
  `Permanent wetlands` = 11, 
  Croplands = 12,
  `Urban & built-up` = 13,
  `Cropland/Natural vegetation mosaic` = 14, 
  `Snow & ice` = 15,
  `Barren/Sparsely vegetated` = 16, 
  Unclassified = 254,
  NoDataFill = 255)

lcd=data.frame(
  ID=Land_Cover_Type_1,
  landcover=names(Land_Cover_Type_1),
  col=c("#000080","#008000","#00FF00", "#99CC00","#99FF99", "#339966", "#993366", "#FFCC99", "#CCFFCC", "#FFCC00", "#FF9900", "#006699", "#FFFF00", "#FF0000", "#999966", "#FFFFFF", "#808080", "#000000", "#000000"),
  stringsAsFactors = F)
# colors from https://lpdaac.usgs.gov/about/news_archive/modisterra_land_cover_types_yearly_l3_global_005deg_cmg_mod12c1
kable(head(lcd))

# convert to raster
lulc2=as.factor(lulc1)

# update the RAT with a left join
levels(lulc2)=left_join(levels(lulc2)[[1]],lcd)

# plot 
x11()
gplot(lulc2)+
  geom_raster(aes(fill=as.factor(value)))+
  scale_fill_manual(values=levels(lulc2)[[1]]$col,
                    labels=levels(lulc2)[[1]]$landcover,
                    name="Landcover Type")+
  coord_equal()+
  theme(legend.position = "bottom")+
  guides(fill=guide_legend(ncol=1,byrow=TRUE))

x11()
plot(lst[[1:12]])

#convert from Kelvin
offs(lst)=-273.15
plot(lst[[1:10]])

names(lst)[1:5]
#convert to dates
tdates=names(lst)%>%
  sub(pattern="X",replacement="")%>%
  as.Date("%Y.%m.%d")

names(lst)=1:nlayers(lst)
lst=setZ(lst,tdates)
#part1
lw=SpatialPoints(data.frame(x= -78.791547,y=43.007211))

projection(lw)<- "+proj=longlat"
lwt<-spTransform(lw,"+proj=longlat")

lst_ex <- raster::extract(lst,lw,buffer=1000,fun=mean,na.rm=T)
lst_t<-t(lst_ex)

lstZ <- data.frame(getZ(lst))
df_comb <- bind_cols(lst_t,lstZ)

plot_part1 <- ggplot(df_comb,aes(y=...1,x=getZ.lst.))+geom_point()+geom_smooth(span=0.02)
x11()
plot_part1

#part2
tmonth <- as.numeric(format(getZ(lst),"%m"))
lst_month <- stackApply(lst,tmonth,fun=mean)
names(lst_month)=month.name
#make graph of each month
plot_part2 <- gplot(lst_month)+geom_raster(aes(fill=value))+facet_wrap(~variable)+scale_fill_gradient2(low="blue",mid="grey80",high="red",midpoint=12)+coord_equal()+theme(axis.text.x=element_blank(),axis.text.y=element_blank())
x11()
plot_part2
#make table
month_mean<-cellStats(lst_month,mean)
kable(month_mean,format="simple",col.names="Mean")

#part3
lulc_resamp <- resample(lulc,lst,method="ngb")
lcds1=cbind.data.frame(
  values(lst_month),
  ID=values(lulc_resamp[[1]]))%>%
  na.omit()

lulc3<-gather(lcds1, key='month',value='value',-ID)
lulc4<- lulc3 %>% mutate(ID=as.numeric(ID), month=factor(month,levels=month.name,ordered=T))
#left join with
left_lulc <- left_join(lulc4,lcd)

plot_part3 <- left_lulc %>% filter(landcover %in% c("Urban & built-up","Deciduous Broadleaf forest")) %>% ggplot(aes(y=value,x=month))+
  facet_wrap(~landcover)+
  geom_point(alpha=.5,position="jitter")+
  geom_smooth()+
  geom_boxplot(alpha=.5,col="red",scale = "width",position="dodge")+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  ylab("Monthly Mean Land Surface Temperature (C)")+
  xlab("Month")+
  ggtitle("Land Surface Temperature in Urban and Forest areas in Buffalo, NY")

x11()
plot_part3


##with help from Ting and Sandra