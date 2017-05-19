library(seqinr)
library(phangorn) 
library(caroline)

#https://rdrr.io/rforge/seqinr/man/dist.alignment.html
#returns sqrt of pairwise genetic distance, then squared the matrices
A.seqs <- read.alignment(file = "Data/A_tree_seqs_aligned_clean.fasta", format= "fasta")
A.dis <- (as.matrix(dist.alignment(A.seqs, matrix = "identity" )))^2
write.csv(A.dis, file="Data/A.dis.matx.csv")

C.seqs <- read.alignment(file = "Data/C_tree_seqs_aligned_clean.fasta", format= "fasta")
C.dis <- (as.matrix(dist.alignment(C.seqs, matrix = "identity" )))^2
write.csv(C.dis2, file="Data/C.dis.matx.csv")

D.seqs <- read.alignment(file = "Data/D_tree_seqs_aligned_clean.fasta", format= "fasta")
D.dis <- (as.matrix(dist.alignment(D.seqs, matrix = "identity" )))^2
write.csv(D.dis, file="D.dis.matx.csv")

A_C <- matrix(0.1960, ncol=ncol(A.dis), nrow=nrow(C.dis), dimnames=list(rownames(C.dis), colnames(A.dis)))
A_D <- matrix(0.1775, ncol=ncol(A.dis), nrow=nrow(D.dis), dimnames=list(rownames(D.dis), colnames(A.dis)))
C_D <- matrix(0.1520, ncol=ncol(C.dis), nrow=nrow(D.dis), dimnames=list(rownames(D.dis), colnames(C.dis)))
  
#build ACD matrix
col1 <- rbind(A.dis, A_C, A_D)
col2 <- rbind(matrix(NA, nrow=nrow(A.dis), ncol=ncol(C.dis), dimnames=list(rownames(A.dis), colnames(C.dis))), C.dis, C_D)
col3 <- rbind(matrix(NA, nrow=nrow(A.dis)+nrow(C.dis), ncol=ncol(D.dis), dimnames=list(c(rownames(A.dis), rownames(C.dis)), colnames(D.dis))), D.dis)

ubermatrix <- cbind(col1, col2, col3)
dim(ubermatrix)

#build tree
uber.tree <- upgma(ubermatrix)
plot(uber.tree, main="UPGMA")

#write tree to file
write.tree(uber.tree, file="uber.tre")

#use tree and OTU table for calculating beta_diversity.py
#http://qiime.org/scripts/beta_diversity.html

write.delim(data.frame(otu_table(phy.f)), "otu_table.tsv", quote = FALSE, row.names = T, sep = "\t")


  
  