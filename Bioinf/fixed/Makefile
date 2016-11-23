all: Moorea_sym.RData

# Filter out sequences that are not Symbiodinium
Moorea_sym.RData: Moorea.RData
	R --vanilla < ~/SymITS2/filter_notsym.R --args Moorea.RData clust/all_rep_set_rep_set.fasta Moorea_sym.RData

# Build phyloseq object
Moorea.RData: clust/all_rep_set_rep_set_nw_tophits.tsv clust/97_otus_bysample.tsv Moorea_sample_info.tsv 
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	clust/all_rep_set_rep_set_nw_tophits.tsv \
	Moorea_sample_info.tsv \
	clust/97_otus_bysample.tsv \
	ITS2db_trimmed_notuniques_otus.txt \
	Moorea.RData

# Assign taxonomy using Needleman-Wunsch global alignment to database
clust/all_rep_set_rep_set_nw_tophits.tsv: clust/all_rep_set_rep_set.fasta ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $< ITS2db_trimmed_derep.fasta
	

# Cluster at 97% within samples
clust/all_rep_set_rep_set.fasta: Moorea_fixed.fasta
	~/SymITS2/otus_97_bysample.sh Moorea_fixed.fasta clust

# Uncompress sequences
Moorea_fixed.fasta: Moorea_fixed.tar.gz
	tar -xzvf Moorea_fixed.tar.gz -m
	

	
	