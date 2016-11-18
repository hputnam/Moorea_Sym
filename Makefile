# Cluster at 97% within samples
Bioinf/clust: Bioinf/Moorea_seqs.fasta
	~/SymITS2/otus_97_bysample.sh Bioinf/Moorea_seqs.fasta Bioinf/clust
	
# Uncompress sequences
Bioinf/Moorea_seqs.fasta: Bioinf/Moorea_seqs.tar.gz
	tar -xzvf Bioinf/Moorea_seqs.tar.gz -m
	

	
	