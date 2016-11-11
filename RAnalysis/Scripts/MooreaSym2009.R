########################################################################################
#Copyright 2016 HM Putnam
#Use of this code must be accompanied by a citation to XXXX
#Data should not be used without permission from HM Putnam
#Readme
#Description


########################################################################################

rm (list = ls ()) #clears all variables

########################################################################################

#Read in libraries
library("ggplot2") #load ggplot2 used for advanced plotting
library("vegan") #load vegan used for MDS and multivariate stats
library("gplots") #load gplots
library("plyr") #load plyr
library("data.table") #load datatable
library("reshape")
library("scales")
library("phyloseq")
library("dplyr")
library("tidyr")

#############################################################

#Required Files

#Load the sample data
OTUs <- read.csv("Data/Moorea_otu_table.csv", header=TRUE, sep=",", row.names=1)
info <- read.csv("Data/Moorea_sample_info.csv", header=TRUE, sep=",")
taxa <- read.csv("Data/Moorea_rep_set_tax_assignments.csv", header=TRUE, sep=",")

#remove the no hit or non-Symbiodinium OTUs from OTUs and taxa dataframes
OTU.data <- droplevels(OTUs[-which(taxa$Clade == "No blast hit"), ] )
taxa.data <- droplevels(taxa[-which(taxa$Clade == "No blast hit"), ] )

#Describe sequence summary
type <- taxa.data$Type #assign factor
clade <- taxa.data$Clade #assign factor
Species <- info$Species #assign factor
Site <- info$Site #assign factor

clade.totals <-  by(OTU.data, clade, FUN=sum) # calculating the clade sums for each clade
clade.totals #view clade totals


