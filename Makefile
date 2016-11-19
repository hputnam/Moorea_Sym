all: RAnalysis/Data/Moorea.RData
	
# Build phyloseq object
RAnalysis/Data/Moorea.RData: Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv Bioinf/clust/97_otus_bysample.tsv RAnalysis/Data/Moorea_sample_info.tsv
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv \
	RAnalysis/Data/Moorea_sample_info.tsv \
	Bioinf/clust/97_otus_bysample.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea.RData

# Assign taxonomy using Needleman-Wunsch global alignment to database
Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv: Bioinf/clust/all_rep_set_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $< Bioinf/ITS2db_trimmed_derep.fasta
	
# Cluster at 97% within samples
Bioinf/clust: Bioinf/Moorea_seqs.fasta
	~/SymITS2/otus_97_bysample.sh Bioinf/Moorea_seqs.fasta Bioinf/clust
	
# Uncompress sequences
Bioinf/Moorea_seqs.fasta: Bioinf/Moorea_seqs.tar.gz
	tar -xzvf Bioinf/Moorea_seqs.tar.gz -m
	

	
	