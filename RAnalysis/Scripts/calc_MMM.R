## MOOREA CALCULATE Mean Monthly Maximum (MMM)

# Clear your environment
rm(list=ls())

# Load necessary packages
library(lubridate)
library(hydroTSM)

# Read in Moorea LTER Site 1 temperature data
MCR.1 <- read.csv("Data/MCR_LTER01_BottomMountThermistors_20150818.csv")
# Subset by reef_type_code=BAK
MCR.1 <- subset(MCR.1, reef_type_code=="BAK")
# Rename Date.Time column
colnames(MCR.1)[2] <- "Date.Time"
# Format Date.Time column to POSIXct
MCR.1$Date.Time <- as.POSIXct(MCR.1$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
# Subset columns
MCR.1 <- MCR.1[,c(2,7)]
# Rename temperature column to site name
colnames(MCR.1)[2] <- "MCR1"
# # plot(MCR.1$Date.Time,MCR.1$MCR1)

# Make a zoo object with the temperature and the Date.Time
zoo.MCR1 <- zoo(MCR.1$MCR1,MCR.1$Date.Time)
# monthly.avg <- apply.monthly(zoo.MCR.6, mean) # This does each month separately
# Calculate monthly means
MCR1.monthlymeans <- monthlyfunction(zoo.MCR1, FUN=mean, na.rm=TRUE)
# Select the Month and temperature value for the hottest month
MMM.MCR1 <- MCR1.monthlymeans[which(MCR1.monthlymeans==max(MCR1.monthlymeans))]
# Define hotspot as MMM + 1 degree
hotspot.MCR1 <- MMM.MCR1 + 1

# Read in Moorea LTER Site 6 temperature data
MCR.6 <- read.csv("Data/MCR_LTER06_BottomMountThermistors_20150818.csv")
# Subset by reef_type_code=BAK
MCR.6 <- subset(MCR.6, reef_type_code=="BAK")
# Rename Date.Time column
colnames(MCR.6)[2] <- "Date.Time"
# Format Date.Time column to POSIXct
MCR.6$Date.Time <- as.POSIXct(MCR.6$Date.Time, format="%Y-%m-%d %T", tz="Pacific/Tahiti")
# Subset columns
MCR.6 <- MCR.6[,c(2,7)]
# Rename temperature column to site name
colnames(MCR.6)[2] <- "MCR6"
# plot(MCR.6$Date.Time,MCR.6$MCR6)

# Make a zoo object with the temperature and the Date.Time
zoo.MCR6 <- zoo(MCR.6$MCR6,MCR.6$Date.Time)
# monthly.avg <- apply.monthly(zoo.MCR.6, mean) # This does each month separately
# Calculate monthly means
MCR6.monthlymeans <- monthlyfunction(zoo.MCR6, FUN=mean, na.rm=TRUE)
# Select the Month and temperature value for the hottest month
MMM.MCR6 <- MCR6.monthlymeans[which(MCR6.monthlymeans==max(MCR6.monthlymeans))]
# Define hotspot as MMM + 1 degree
hotspot.MCR6 <- MMM.MCR6 + 1

# Calculate mean MMM from both long-term sites together
mean.insitu.MMM <- mean(x= c(MMM.MCR1,MMM.MCR6))
# Calculate hotspot value from both long-term sites together
mean.insitu.hotspot <- mean(x = c(hotspot.MCR1,hotspot.MCR6))


# Satellite.MMM is calculated with DC+JJS satellite_coral_stress code (currently in review) 
# Satellite data are at a 0.25 degree grid, from AVHRR OI 1982-2014.

# Month that includes MMM is March for both sites 1,2,3 and 7,8,9
satellite.MMM.123 <- 28.7351 # MMM calculated from lat/long -17.522, -149.916  (center sites 1,2,3)
satellite.MMM.789 <- 28.7244 # MMM calculated from lat/long -17.478, -149.842 (center sites 7,8,9)

# Calculate mean MMM from both satellite locations together
satellite.MMM <- mean(x=c(satellite.MMM.123,satellite.MMM.789))

# Save MMMs to RData file for later use
save(mean.insitu.MMM,mean.insitu.hotspot,satellite.MMM,file="../Moorea_MMM.RData")
