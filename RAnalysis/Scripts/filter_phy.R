library(phyloseq)
options(stringsAsFactors = FALSE)

# Get command line arguments
args = commandArgs(trailingOnly=TRUE)

# Load 97%-within-sample OTUs as phyloseq object named phy.f
load(args[1])  

# Filter OTUs by minimum count
# Set threshold count
n <- 10
# Identify OTUs below threshold count
taxa <- taxa_sums(phy.f)[which(taxa_sums(phy.f) >= n)]
# Remove taxa below threshold count
phy.f <- prune_taxa(names(taxa), phy.f)

# Filter samples by minimum count
# Set threshold number of reads
sn <- 300
# Remove samples with fewer reads than threshold
phy.f <- prune_samples(sample_sums(phy.f)>=sn, phy.f)

# Filter OTUs by minimum count again in case any dropped below threshold after filtering samples
# Identify OTUs below threshold count
taxa <- taxa_sums(phy.f)[which(taxa_sums(phy.f) >= n)]
# Remove taxa below threshold count
phy.f <- prune_taxa(names(taxa), phy.f)

# Label clades and subtypes for filtered phyloseq object tax_tables
get.st <- function(df) {
  within(df, {
    Clade <- substr(hit, 1, 1)
    Subtype <- gsub(hit, pattern="_[A-Z]{2}[0-9]{6}", replacement="")
    Subtype <- gsub(Subtype, pattern="_multiple", replacement="")
    Subtype2 <- ifelse(as.numeric(sim)==100, paste0("'", Subtype, "'"),
                       paste0("'[", rep(rle(sort(Subtype))$values, times=rle(sort(Subtype))$lengths), "]'^", 
                              unlist(lapply(rle(sort(Subtype))$lengths, seq_len)))[order(order(Subtype))])
    #Subtype <- ifelse(as.numeric(sim)==100, Subtype, paste("*", Subtype, sep=""))
  })
}

tax_table(phy.f) <- as.matrix(get.st(data.frame(tax_table(phy.f), stringsAsFactors=FALSE)))

# Save filtered phyloseq object
save(phy.f, file = args[2])
