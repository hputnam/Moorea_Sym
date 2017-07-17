library(plyr)
library(dplyr)
library(lubridate)
library(moments)
library(diptest)
library(ggplot2)
hyperskewness <- function(x) moment(na.omit(x), order=5, central=T) / sd(na.omit(x))^5
hyperflatness <- function(x) moment(na.omit(x), order=6, central=T) / sd(na.omit(x))^6

# Import temperature data
#temp <- read.csv("RAnalysis/Data/Moorea_Temp_Data.csv")
tile1.1 <- read.csv("RAnalysis/Data/Tiles1_1_905379_Jan06_Sept06.csv")
tile1.1 <- tile1.1[,c(1:2)]
tile1.1$Date.Time <- as.POSIXct(tile1.1$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile1.1$Date.Time[1] + days(1)
endday <- max(tile1.1$Date.Time) - days(1)
tile1.1 <- subset(tile1.1, tile1.1$Date.Time >= startday & tile1.1$Date.Time <= endday)

tile1.2 <- read.csv("RAnalysis/Data/Tiles1_2_905385_Sept06_Jan07.csv")
tile1.2 <- tile1.2[,c(1:2)]
tile1.2$Date.Time <- as.POSIXct(tile1.2$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile1.2$Date.Time[1] + days(1)
endday <- max(tile1.2$Date.Time) - days(1)
tile1.2 <- subset(tile1.2, tile1.2$Date.Time >= startday & tile1.2$Date.Time <= endday)

tile1.3 <- read.csv("RAnalysis/Data/Tiles1_3_905383_Jan07_Sept07.csv")
tile1.3 <- tile1.3[,c(1:2)]
tile1.3$Date.Time <- as.POSIXct(tile1.3$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile1.3$Date.Time[1] + days(1)
endday <- max(tile1.3$Date.Time) - days(1)
tile1.3 <- subset(tile1.3, tile1.3$Date.Time >= startday & tile1.3$Date.Time <= endday)

tile1.4 <- read.csv("RAnalysis/Data/Tiles1_4_905377_Sept07_Feb08.csv")
tile1.4 <- tile1.4[,c(1:2)]
tile1.4$Date.Time <- as.POSIXct(tile1.4$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile1.4$Date.Time[1] + days(3)
endday <- max(tile1.4$Date.Time) - days(2)
tile1.4 <- subset(tile1.4, tile1.4$Date.Time >= startday & tile1.4$Date.Time <= endday)
Site.1 <- join_all(list(tile1.1,tile1.2,tile1.3,tile1.4),by='Date.Time',type='full')
colnames(Site.1)[2] <- "Site.1"
# plot(Site.1$Date.Time,Site.1$Site.1)

tile2 <- read.csv("RAnalysis/Data/MCR_LTER01_BottomMountThermistors_20150818.csv")
tile2 <- subset(tile2 , reef_type_code=="BAK")
colnames(tile2)[2] <- "Date.Time"
tile2$Date.Time <- as.POSIXct(tile2$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
startday <- as.POSIXct("2006-01-29 00:00:00") + days(1)
endday <- as.POSIXct("2009-02-20 00:00:00") - days(1)
Site.2 <- subset(tile2, tile2$Date.Time > startday & tile2$Date.Time < endday)
Site.2 <- Site.2 [,c(2,7)]
colnames(Site.2)[2] <- "Site.2"
plot(Site.2$Date.Time,Site.2$Site.2)

tile3.1 <- read.csv("RAnalysis/Data/Tiles3_1_905385_Jan06_Sept06.csv")
tile3.1 <- tile3.1[,c(1:2)]
tile3.1$Date.Time <- as.POSIXct(tile3.1$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile3.1$Date.Time[1] + days(1)
endday <- max(tile3.1$Date.Time) - days(1)
tile3.1 <- subset(tile3.1, tile3.1$Date.Time >= startday & tile3.1$Date.Time <= endday)

tile3.2 <- read.csv("RAnalysis/Data/Tiles3_2_905382_Sept06_Jan07.csv")
tile3.2 <- tile3.2[,c(1:2)]
tile3.2$Date.Time <- as.POSIXct(tile3.2$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile3.2$Date.Time[1] + days(1)
endday <- max(tile3.2$Date.Time) - days(1)
tile3.2 <- subset(tile3.2, tile3.2$Date.Time >= startday & tile3.2$Date.Time <= endday)

tile3.3 <- read.csv("RAnalysis/Data/Tiles3_3_905381_Jan07_Sept07.csv")
tile3.3 <- tile3.3[,c(1:2)]
tile3.3$Date.Time <- as.POSIXct(tile3.3$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile3.3$Date.Time[1] + days(1)
endday <- max(tile3.3$Date.Time) - days(1)
tile3.3 <- subset(tile3.3, tile3.3$Date.Time >= startday & tile3.3$Date.Time <= endday)

tile3.4 <- read.csv("RAnalysis/Data/Tiles3_4_905379_Sept07_Feb08.csv")
tile3.4 <- tile3.4[,c(1:2)]
tile3.4$Date.Time <- as.POSIXct(tile3.4$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile3.4$Date.Time[1] + days(1)
endday <- max(tile3.4$Date.Time) - days(2)
tile3.4 <- subset(tile3.4, tile3.4$Date.Time >= startday & tile3.4$Date.Time <= endday)
Site.3 <- join_all(list(tile3.1,tile3.2,tile3.3,tile3.4),by='Date.Time',type='full')
colnames(Site.3)[2] <- "Site.3"
# plot(Site.3$Date.Time,Site.3$Site.3)

tile7.1 <- read.csv("RAnalysis/Data/Tiles7_1_905376_Jan06_Sept06.csv")
tile7.1 <- tile7.1[,c(1:2)]
tile7.1$Date.Time <- as.POSIXct(tile7.1$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile7.1$Date.Time[1] + days(1)
endday <- max(tile7.1$Date.Time) - days(1)
tile7.1 <- subset(tile7.1, tile7.1$Date.Time >= startday & tile7.1$Date.Time <= endday)

tile7.2 <- read.csv("RAnalysis/Data/Tiles7_2_905383_Sept06_Jan07.csv")
tile7.2 <- tile7.2[,c(1:2)]
tile7.2$Date.Time <- as.POSIXct(tile7.2$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile7.2$Date.Time[1] + days(1)
endday <- max(tile7.2$Date.Time) - days(1)
tile7.2 <- subset(tile7.2, tile7.2$Date.Time >= startday & tile7.2$Date.Time <= endday)

tile7.3 <- read.csv("RAnalysis/Data/Tiles7_3_905377_Jan07_Sept07.csv")
tile7.3 <- tile7.3[,c(1:2)]
tile7.3$Date.Time <- as.POSIXct(tile7.3$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile7.3$Date.Time[1] + days(1)
endday <- max(tile7.3$Date.Time) - days(1)
tile7.3 <- subset(tile7.3, tile7.3$Date.Time >= startday & tile7.3$Date.Time <= endday)

tile7.4 <- read.csv("RAnalysis/Data/Tiles7_4_905376_Sept07_Feb08.csv")
tile7.4 <- tile7.4[,c(1:2)]
tile7.4$Date.Time <- as.POSIXct(tile7.4$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile7.4$Date.Time[1] + days(1)
endday <- max(tile7.4$Date.Time) - days(3)
tile7.4 <- subset(tile7.4, tile7.4$Date.Time >= startday & tile7.4$Date.Time <= endday)
Site.7 <- join_all(list(tile7.1,tile7.2,tile7.3,tile7.4),by='Date.Time',type='full')
colnames(Site.7)[2] <- "Site.7"
# plot(Site.7$Date.Time,Site.7$Site.7)

tile8.1 <- read.csv("RAnalysis/Data/Tiles8_1_905383_Jan06_Sept06.csv")
tile8.1 <- tile8.1[,c(1:2)]
tile8.1$Date.Time <- as.POSIXct(tile8.1$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile8.1$Date.Time[1] + days(1)
endday <- max(tile8.1$Date.Time) - days(1)
tile8.1 <- subset(tile8.1, tile8.1$Date.Time >= startday & tile8.1$Date.Time <= endday)

tile8.2 <- read.csv("RAnalysis/Data/Tiles8_2_905379_Sept06_Jan07.csv")
tile8.2 <- tile8.2[,c(1:2)]
tile8.2$Date.Time <- as.POSIXct(tile8.2$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile8.2$Date.Time[1] + days(1)
endday <- max(tile8.2$Date.Time) - days(1)
tile8.2 <- subset(tile8.2, tile8.2$Date.Time >= startday & tile8.2$Date.Time <= endday)

tile8.3 <- read.csv("RAnalysis/Data/Tiles8_3_905385_Sept07_Feb08.csv")
tile8.3 <- tile8.3[,c(1:2)]
tile8.3$Date.Time <- as.POSIXct(tile8.3$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile8.3$Date.Time[1] + days(1)
endday <- max(tile8.3$Date.Time) - days(3)
tile8.3 <- subset(tile8.3, tile8.3$Date.Time >= startday & tile8.3$Date.Time <= endday)
Site.8 <- join_all(list(tile8.1,tile8.2,tile8.3),by='Date.Time',type='full')
colnames(Site.8)[2] <- "Site.8"
# plot(Site.8$Date.Time,Site.8$Site.8)

tile9.1 <- read.csv("RAnalysis/Data/Tiles9_1_905384_Jan06_Sept06.csv")
tile9.1 <- tile9.1[,c(1:2)]
tile9.1$Date.Time <- as.POSIXct(tile9.1$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile9.1$Date.Time[1] + days(1)
endday <- max(tile9.1$Date.Time) - days(1)
tile9.1 <- subset(tile9.1, tile9.1$Date.Time >= startday & tile9.1$Date.Time <= endday)

tile9.2 <- read.csv("RAnalysis/Data/Tiles9_2_905381_Sept06_Jan07.csv")
tile9.2 <- tile9.2[,c(1:2)]
tile9.2$Date.Time <- as.POSIXct(tile9.2$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile9.2$Date.Time[1] + days(1)
endday <- max(tile9.2$Date.Time) - days(1)
tile9.2 <- subset(tile9.2, tile9.2$Date.Time >= startday & tile9.2$Date.Time <= endday)

tile9.3 <- read.csv("RAnalysis/Data/Tiles9_3_818724_Jan07_Sept07.csv")
tile9.3 <- tile9.3[,c(1:2)]
tile9.3$Date.Time <- as.POSIXct(tile9.3$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile9.3$Date.Time[1] + days(1)
endday <- max(tile9.3$Date.Time) - days(1)
tile9.3 <- subset(tile9.3, tile9.3$Date.Time >= startday & tile9.3$Date.Time <= endday)

tile9.4 <- read.csv("RAnalysis/Data/Tiles9_4_905378_Sept07_Feb08.csv")
tile9.4 <- tile9.4[,c(1:2)]
tile9.4$Date.Time <- as.POSIXct(tile9.4$Date.Time, format="%m/%d/%y %T", tz="Pacific/Tahiti")
startday <- tile9.4$Date.Time[1] + days(1)
endday <- max(tile9.4$Date.Time) - days(3)
tile9.4 <- subset(tile9.4, tile9.4$Date.Time >= startday & tile9.4$Date.Time <= endday)
Site.9 <- join_all(list(tile9.1,tile9.2,tile9.3,tile9.4),by='Date.Time',type='full')
colnames(Site.9)[2] <- "Site.9"
# plot(Site.9$Date.Time,Site.9$Site.9)

# MCR.1 <- read.csv("RAnalysis/Data/MCR_LTER01_BottomMountThermistors_20150818.csv")
# MCR.1 <- subset(MCR.1, reef_type_code=="BAK")
# colnames(MCR.1)[2] <- "Date.Time"
# MCR.1$Date.Time <- as.POSIXct(MCR.1$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
# startday <- as.POSIXct("2006-01-29 00:00:00") + days(1)
# endday <- as.POSIXct("2009-02-20 00:00:00") - days(1)
# MCR.1 <- subset(MCR.1, MCR.1$Date.Time > startday & MCR.1$Date.Time < endday)
# MCR.1 <- MCR.1[,c(2,7)]
# colnames(MCR.1)[2] <- "MCR1"
# # plot(MCR.1$Date.Time,MCR.1$MCR1)

MCR.6 <- read.csv("RAnalysis/Data/MCR_LTER06_BottomMountThermistors_20150818.csv")
MCR.6 <- subset(MCR.6, reef_type_code=="BAK")
colnames(MCR.6)[2] <- "Date.Time"
MCR.6$Date.Time <- as.POSIXct(MCR.6$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
startday <- as.POSIXct("2006-01-29 00:00:00") + days(1)
endday <- as.POSIXct("2009-02-20 00:00:00") - days(1)
MCR.6 <- subset(MCR.6, MCR.6$Date.Time > startday & MCR.6$Date.Time < endday)
MCR.6 <- MCR.6[,c(2,7)]
colnames(MCR.6)[2] <- "MCR6"
# plot(MCR.6$Date.Time,MCR.6$MCR6)

#MCR.temp <- MCR.6

temp.all <- join_all(list(Site.1,Site.2,Site.3,Site.7,Site.8,Site.9),by="Date.Time",type='full')

#remove lines where data is not found for all sites
temp.all <- na.omit(temp.all)

# Calculate summary statistics for each site
# Note that commented lines were tried in the original processing, but eliminated for repetitiveness
temp.summ <- data.frame(mean=apply(temp.all[,2:7], 2, FUN=mean, na.rm=T),
                        # med=apply(temp.all[,2:7], 2, FUN=median, na.rm=T),
                        # sd=apply(temp.all[,2:7], 2, FUN=sd, na.rm=T),
                        var=apply(temp.all[,2:7], 2, FUN=var, na.rm=T),
                        min=apply(temp.all[,2:7], 2, FUN=min, na.rm=T),
                        max=apply(temp.all[,2:7], 2, FUN=max, na.rm=T),
                        # range=apply(temp.all[,2:7], 2, FUN=function(x) diff(range(x, na.rm=T))),
                        skew=apply(temp.all[,2:7], 2, FUN=skewness, na.rm=T),
                        # kurt=apply(temp.all[,2:7], 2, FUN=function(x) kurtosis(na.omit(x))-3),
                        # hskew=apply(temp.all[,2:7], 2, FUN=hyperskewness),
                        # hflat=apply(temp.all[,2:7], 2, FUN=hyperflatness),
                        dip=apply(temp.all[,2:7], 2, FUN=function(x) dip(na.omit(x))))
temp.summ



temp.all$Date <- as.Date(temp.all$Date.Time)

temp.daily.mean<-aggregate(cbind(temp.all$Site.1,temp.all$Site.2,temp.all$Site.3,temp.all$Site.7,temp.all$Site.8,temp.all$Site.9) ~ temp.all$Date, FUN=mean)
colnames(temp.daily.mean) <- c("Date","Site.1","Site.2","Site.3","Site.7","Site.8","Site.9")

temp.daily.max<-aggregate(cbind(temp.all$Site.1,temp.all$Site.2,temp.all$Site.3,temp.all$Site.7,temp.all$Site.8,temp.all$Site.9) ~ temp.all$Date, FUN=max)
colnames(temp.daily.max) <- c("Date","Site.1","Site.2","Site.3","Site.7","Site.8","Site.9")

temp.daily.min<-aggregate(cbind(temp.all$Site.1,temp.all$Site.2,temp.all$Site.3,temp.all$Site.7,temp.all$Site.8,temp.all$Site.9) ~ temp.all$Date, FUN=min)
colnames(temp.daily.min) <- c("Date","Site.1","Site.2","Site.3","Site.7","Site.8","Site.9")

temp.daily.range<- temp.daily.max - temp.daily.min
temp.daily.range$Date <- temp.daily.max$Date

temp.daysover30 <- temp.daily.max
temp.daysover30$Site.1 <- temp.daily.max$Site.1>30
temp.daysover30$Site.2 <- temp.daily.max$Site.2>30
temp.daysover30$Site.3 <- temp.daily.max$Site.3>30
temp.daysover30$Site.7 <- temp.daily.max$Site.7>30
temp.daysover30$Site.8 <- temp.daily.max$Site.8>30
temp.daysover30$Site.9 <- temp.daily.max$Site.9>30

temp.daysover30.sum <- data.frame(Site.1=sum(temp.daysover30$Site.1),Site.2=sum(temp.daysover30$Site.2),Site.3=sum(temp.daysover30$Site.3),Site.7=sum(temp.daysover30$Site.7),Site.8=sum(temp.daysover30$Site.8),Site9=sum(temp.daysover30$Site.9))

temp.daysover31 <- temp.daily.max
temp.daysover31$Site.1 <- temp.daily.max$Site.1>31
temp.daysover31$Site.2 <- temp.daily.max$Site.2>31
temp.daysover31$Site.3 <- temp.daily.max$Site.3>31
temp.daysover31$Site.7 <- temp.daily.max$Site.7>31
temp.daysover31$Site.8 <- temp.daily.max$Site.8>31
temp.daysover31$Site.9 <- temp.daily.max$Site.9>31

temp.daysover31.sum <- data.frame(Site.1=sum(temp.daysover31$Site.1),Site.2=sum(temp.daysover31$Site.2),Site.3=sum(temp.daysover31$Site.3),Site.7=sum(temp.daysover31$Site.7),Site.8=sum(temp.daysover31$Site.8),Site9=sum(temp.daysover31$Site.9))

temp.daysunder27 <- temp.daily.max
temp.daysunder27$Site.1 <- temp.daily.max$Site.1<27
temp.daysunder27$Site.2 <- temp.daily.max$Site.2<27
temp.daysunder27$Site.3 <- temp.daily.max$Site.3<27
temp.daysunder27$Site.7 <- temp.daily.max$Site.7<27
temp.daysunder27$Site.8 <- temp.daily.max$Site.8<27
temp.daysunder27$Site.9 <- temp.daily.max$Site.9<27

temp.daysunder27.sum <- data.frame(Site.1=sum(temp.daysunder27$Site.1),Site.2=sum(temp.daysunder27$Site.2),Site.3=sum(temp.daysunder27$Site.3),Site.7=sum(temp.daysunder27$Site.7),Site.8=sum(temp.daysunder27$Site.8),Site9=sum(temp.daysunder27$Site.9))

temp.daysunder27.5 <- temp.daily.max
temp.daysunder27.5$Site.1 <- temp.daily.max$Site.1<27.5
temp.daysunder27.5$Site.2 <- temp.daily.max$Site.2<27.5
temp.daysunder27.5$Site.3 <- temp.daily.max$Site.3<27.5
temp.daysunder27.5$Site.7 <- temp.daily.max$Site.7<27.5
temp.daysunder27.5$Site.8 <- temp.daily.max$Site.8<27.5
temp.daysunder27.5$Site.9 <- temp.daily.max$Site.9<27.5

temp.daysunder27.5.sum <- data.frame(Site.1=sum(temp.daysunder27.5$Site.1),Site.2=sum(temp.daysunder27.5$Site.2),Site.3=sum(temp.daysunder27.5$Site.3),Site.7=sum(temp.daysunder27.5$Site.7),Site.8=sum(temp.daysunder27.5$Site.8),Site9=sum(temp.daysunder27.5$Site.9))


temp.daysunder28 <- temp.daily.max
temp.daysunder28$Site.1 <- temp.daily.max$Site.1<28
temp.daysunder28$Site.2 <- temp.daily.max$Site.2<28
temp.daysunder28$Site.3 <- temp.daily.max$Site.3<28
temp.daysunder28$Site.7 <- temp.daily.max$Site.7<28
temp.daysunder28$Site.8 <- temp.daily.max$Site.8<28
temp.daysunder28$Site.9 <- temp.daily.max$Site.9<28

temp.daysunder28.sum <- data.frame(Site.1=sum(temp.daysunder28$Site.1),Site.2=sum(temp.daysunder28$Site.2),Site.3=sum(temp.daysunder28$Site.3),Site.7=sum(temp.daysunder28$Site.7),Site.8=sum(temp.daysunder28$Site.8),Site9=sum(temp.daysunder28$Site.9))

temp.summ$daily.mean.min <- colMeans(temp.daily.min[2:7])
temp.summ$daily.mean.max <- colMeans(temp.daily.max[2:7])
temp.summ$daily.mean.range <- colMeans(temp.daily.range[2:7])
temp.summ$daysover30 <- t(temp.daysover30.sum)
temp.summ$daysover31 <- t(temp.daysover31.sum)
temp.summ$daysunder27 <- t(temp.daysunder27.sum)
temp.summ$daysunder27.5 <- t(temp.daysunder27.5.sum)
temp.summ$daysunder28 <- t(temp.daysunder28.sum)

ggplot(data=temp.daily.max, aes(temp.daily.max$Site.1)) + geom_histogram()
ggplot(data=temp.daily.max, aes(temp.daily.max$Site.2)) + geom_histogram()
ggplot(data=temp.daily.max, aes(temp.daily.max$Site.3)) + geom_histogram()
ggplot(data=temp.daily.max, aes(temp.daily.max$Site.7)) + geom_histogram()
ggplot(data=temp.daily.max, aes(temp.daily.max$Site.8)) + geom_histogram()
ggplot(data=temp.daily.max, aes(temp.daily.max$Site.9)) + geom_histogram()

save(temp.all,temp.summ,file="RAnalysis/Data/tempdata.RData")
