# source("http://bioconductor.org/biocLite.R") 
# biocLite(c("AnnotationDbi", "impute", "GO.db", "preprocessCore")) 
# biocLite("Biostrings")
# install.packages("WGCNA")
library(WGCNA)

options(stringsAsFactors = FALSE); # Make sure to do this!

# Read in 100% OTU table
Moorea <- read.table("Bioinf/clust100/100_otus.tsv", sep="\t",check.names=FALSE,header=T, row.names=1, skip=1, comment.char="")
disableWGCNAThreads() # Disable WGCNA threads, this allows it to work in R Studio. Ok to enable if running as a script in R

# Subset samples to only look at Diploria strigosa
# Moorea.f <- Moorea[,c("44","64","54","72","80","7","29","10","36")]

tophits <- read.table("Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv", sep="\t")
Cs <- tophits$otu[grep("^C",tophits$hit)]
Moorea.f <- Moorea[rownames(Moorea) %in% Cs,]

# Remove any OTUs whos total abundance is <10 seqs
Moorea.f <- Moorea.f[rowSums(Moorea.f)>10,]
# Remove any samples whos total sequence count is <10
Moorea.f <- Moorea.f[,colSums(Moorea.f)>10]

# Transpose the data frame for downstream analysis
Moorea.f <- as.data.frame(t(Moorea.f))

# Check to see if all OTUs are complete to use in downstream analysis
gsg = goodSamplesGenes(Moorea.f, verbose = 3);
# Check if all "genes" (OTUs) are good. If the output is "TRUE", good to move on to the next step. If the output is "FALSE" check the WGCNA website for next steps
gsg$allOK

# Create the sampleTree
sampleTree = hclust(dist(Moorea.f), method = "average");
# Plot the sample tree: Open a graphic output window of size 12 by 9 inches
# The user should change the dimensions if the window is too large or too small.
sizeGrWindow(12,9)
par(cex = 0.6);
par(mar = c(0,4,2,0))
plot(sampleTree, main = "Sample clustering to detect outliers", sub="", xlab="", cex.lab = 1.5,
     cex.axis = 1.5, cex.main = 2)
# The goal of this plot is to manually detect and remove outlier samples. We do not currently know enough to decide when and how to make this decision, and thus did not remove any samples at thist step

# Choose a set of soft-thresholding powers
# We chose the range to try from the tutorial, could be changed in the future
powers = c(c(1:10), seq(from = 12, to=20, by=2))
# Call the network topology analysis function
sft = pickSoftThreshold(Moorea.f, powerVector = powers, verbose = 5)
# Plot the results:
sizeGrWindow(9, 5)
par(mfrow = c(1,2));
cex1 = 0.9;
# Scale-free topology fit index as a function of the soft-thresholding power
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     labels=powers,cex=cex1,col="red");
# this line corresponds to using an R^2 cut-off of h
abline(h=0.90,col="red")
# Mean connectivity as a function of the soft-thresholding power
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")

# Create the net object, which contains all information necessary to create dendrogram, etc.
net = blockwiseModules(Moorea.f, power = 1,
                       TOMType = "unsigned", minModuleSize = 30,
                       reassignThreshold = 0, mergeCutHeight = 0.25,
                       numericLabels = TRUE, pamRespectsDendro = FALSE,
                       saveTOMs = TRUE,
                       saveTOMFileBase = "MooreaTOM",
                       verbose = 3)

# Check how many OTUs are in each of the modules (each module is a different color)
table(net$colors)

# Open a graphics window
sizeGrWindow(12, 9)
# Convert labels to colors for plotting
mergedColors = labels2colors(net$colors)

# Open a png to write the dendrogram to
png("Bioinf/dendro_C.png",height=4, width=12,units="in",res=300)

# Plot the dendrogram and the module colors underneath
plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)
dev.off() # Close the png

# Write net$colors to "membership.txt" for downstream analysis. This file shows which module each OTU belongs to
write.table(net$colors, file="Bioinf/membership_C.txt")
mem <- net$colors

seqs <- readDNAStringSet("Bioinf/clust100/100_otus_rep_set.fasta")
names(seqs) <- gsub(" .*$", "", names(seqs))

for (cluster in levels(factor(mem))) {
  Cnames <- colnames(Moorea.f)[mem==cluster]
  Cseqs <- subset(seqs, names(seqs) %in% Cnames)
  writeXStringSet(Cseqs, filepath=paste(cluster,"_C.fasta",sep=""),append=FALSE,compress=FALSE,compression_level=NA, format="fasta")
  print(cluster)
  system(paste("R --vanilla < /Users/Danielle/Documents/Data_Analysis/KI_Platy/data/run_nw.R --args",
               paste(cluster, "_C.fasta",sep=""),
               "/Users/Danielle/Documents/Data_Analysis/KI_Platy/data/ITS2db_trimmed_derep.fasta"))
}

map <- data.frame(seq=colnames(Moorea.f), clust=mem, col=mergedColors)
cols <- aggregate(data.frame(col=map$col), by=list(clust=map$clust), FUN=unique)

mod_otu <- aggregate(t(Moorea.f), by=list(map$clust), FUN=sum)
mod_otu <- as.matrix(mod_otu[,2:ncol(mod_otu)])
mod_otu_rel <- apply(mod_otu, 2, function(x) x/sum(x))

png("Bioinf/barplot_C.png",height=4, width=10,units="in",res=300)
barplot(mod_otu_rel,col=cols$col,cex.names=0.5)
dev.off()
graphics.off()


# Calculate topological overlap anew: this could be done more efficiently by saving the TOM
# calculated during module detection, but let us do it again here.
dissTOM = 1-TOMsimilarityFromExpr(Moorea.f, power = 6);
# Transform dissTOM with a power to make moderately strong connections more visible in the heatmap
plotTOM = dissTOM^7;
# Set diagonal to NA for a nicer plot
diag(plotTOM) = NA;
# Call the plot function
sizeGrWindow(9,9)
# Set module colors
moduleColors = labels2colors(net$colors)
# Make network heatmap plot for all OTUs
pdf("TOMplot2.pdf")
TOMplot(plotTOM, net$dendrograms[[1]], moduleColors, main = "Network heatmap plot, all OTUs")
dev.off()


# Order correlations (TOMs?) and plot image
colnames(plotTOM) <- map$seq
rownames(plotTOM) <- map$seq
ordcor <- 1-plotTOM[order(net$colors), order(net$colors)]
image(ordcor)
# Get order of modules
mord <- net$colors[order(net$colors)]
# Get matrix of TOMs between module 1 and all OTHER modules
m1.bm <- ordcor[mord==1, mord!=1]
image(m1.bm)

graphics.off()
hist(apply(m1.bm, MARGIN = 1, FUN=mean))
head(m1.bm)
rownames(m1.bm)[rowSums(m1.bm) > 74]
median(m1.bm["denovo336356",])
colnames(Moorea.f)
map
