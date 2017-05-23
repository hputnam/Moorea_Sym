rm(list=ls())
library(lubridate)
library(hydroTSM)

MCR.1 <- read.csv("/Data/MCR_LTER01_BottomMountThermistors_20150818.csv")
MCR.1 <- subset(MCR.1, reef_type_code=="BAK")
colnames(MCR.1)[2] <- "Date.Time"
MCR.1$Date.Time <- as.POSIXct(MCR.1$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
MCR.1 <- MCR.1[,c(2,7)]
colnames(MCR.1)[2] <- "MCR1"
# # plot(MCR.1$Date.Time,MCR.1$MCR1)

zoo.MCR1 <- zoo(MCR.1$MCR1,MCR.1$Date.Time)
# monthly.avg <- apply.monthly(zoo.MCR.6, mean) # This does each month separately
MCR1.monthlymeans <- monthlyfunction(zoo.MCR1, FUN=mean, na.rm=TRUE)
MMM.MCR1 <- MCR1.monthlymeans[which(MCR1.monthlymeans==max(MCR1.monthlymeans))]
hotspot.MCR1 <- MMM.MCR1 + 1

MCR.6 <- read.csv("/Data/MCR_LTER06_BottomMountThermistors_20150818.csv")
MCR.6 <- subset(MCR.6, reef_type_code=="BAK")
colnames(MCR.6)[2] <- "Date.Time"
MCR.6$Date.Time <- as.POSIXct(MCR.6$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
MCR.6 <- MCR.6[,c(2,7)]
colnames(MCR.6)[2] <- "MCR6"
# plot(MCR.6$Date.Time,MCR.6$MCR6)

zoo.MCR6 <- zoo(MCR.6$MCR6,MCR.6$Date.Time)
# monthly.avg <- apply.monthly(zoo.MCR.6, mean) # This does each month separately
MCR6.monthlymeans <- monthlyfunction(zoo.MCR6, FUN=mean, na.rm=TRUE)
MMM.MCR6 <- MCR6.monthlymeans[which(MCR6.monthlymeans==max(MCR6.monthlymeans))]
hotspot.MCR6 <- MMM.MCR6 + 1

mean.MMM <- mean(x= c(MMM.MCR1,MMM.MCR6))
mean.hotspot <- mean(x = c(hotspot.MCR1,hotspot.MCR6))
