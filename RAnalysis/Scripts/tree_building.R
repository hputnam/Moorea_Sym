setwd("/Users/hputnam/MyProjects/Moorea_Sym/RAnalysis/Data/")

library(seqinr)

#https://rdrr.io/rforge/seqinr/man/dist.alignment.html
#returns sqrt of pairwise genetic distance, then squared the matrices
A.seqs <- read.alignment(file = "A_tree_seqs_aligned.fasta", format= "fasta")
A.dis <- (as.matrix(dist.alignment(A.seqs, matrix = "identity" )))^2
write.csv(A.dis, file="A.dis.matx.csv")

C.seqs <- read.alignment(file = "C_tree_seqs_aligned.fasta", format= "fasta")
C.dis <- (as.matrix(dist.alignment(C.seqs, matrix = "identity" )))^2
write.csv(C.dis2, file="C.dis.matx.csv")

D.seqs <- read.alignment(file = "D_tree_seqs_aligned.fasta", format= "fasta")
D.dis <- (as.matrix(dist.alignment(D.seqs, matrix = "identity" )))^2
write.csv(D.dis, file="D.dis.matx.csv")

A_C <- 0.1960
A_D <- 0.1775
C_D <- 0.1520
  
#build matrix

#build tree

#use tree and OTU table for calculating beta_diversity.py
#http://qiime.org/scripts/beta_diversity.html
  
  
  