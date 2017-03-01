all: RAnalysis/Data/Moorea_sym.RData RAnalysis/Data/Moorea_sym100.RData

# Filter out sequences that are not Symbiodinium from 97% OTUs
RAnalysis/Data/Moorea_sym.RData: RAnalysis/Data/Moorea.RData
	R --vanilla < ~/SymITS2/filter_notsym.R --args RAnalysis/Data/Moorea.RData Bioinf/clust/all_rep_set_rep_set.fasta RAnalysis/Data/Moorea_sym.RData

# Build phyloseq object for 97% OTUs
RAnalysis/Data/Moorea.RData: Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv RAnalysis/Data/Moorea_sample_info.tsv 
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv \
	RAnalysis/Data/Moorea_sample_info.tsv \
	Bioinf/clust/97_otus_bysample.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea.RData
	
# Filter out sequences that are not Symbiodinium from 100% OTUs
RAnalysis/Data/Moorea_sym100.RData: RAnalysis/Data/Moorea_100.RData
	R --vanilla < ~/SymITS2/filter_notsym.R --args RAnalysis/Data/Moorea_100.RData Bioinf/clust100/100_otus_rep_set.fasta RAnalysis/Data/Moorea_sym100.RData

# Build phyloseq object for 100% OTUs
RAnalysis/Data/Moorea_100.RData: Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv RAnalysis/Data/Moorea_sample_info.tsv 
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv \
	RAnalysis/Data/Moorea_sample_info.tsv \
	Bioinf/clust100/100_otus.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea_100.RData

# Assign taxonomy using Needleman-Wunsch global alignment to database for 97% within sample clustering
Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv: Bioinf/clust/all_rep_set_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $< Bioinf/ITS2db_trimmed_derep.fasta
	
# Assign taxonomy using Needleman-Wunsch global alignment to database for 100% clustering
Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv: Bioinf/clust100/100_otus_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta Bioinf/clust100/Moorea_seqs_otus.txt
	R --vanilla < ~/SymITS2/run_nw.R --args $< Bioinf/ITS2db_trimmed_derep.fasta

# Cluster at 97% within samples
Bioinf/clust/all_rep_set_rep_set.fasta: Bioinf/Moorea_seqs.fasta
	~/SymITS2/otus_97_bysample.sh Bioinf/Moorea_seqs.fasta Bioinf/clust
	
# Cluster at 100%
Bioinf/clust100/100_otus_rep_set.fasta: Bioinf/Moorea_seqs.fasta
	~/SymITS2/otus_100.sh Bioinf/Moorea_seqs.fasta Bioinf/clust100

# Uncompress sequences
Bioinf/Moorea_seqs.fasta: Bioinf/Moorea_seqs.tar.gz
	tar -xzvf Bioinf/Moorea_seqs.tar.gz -m -C Bioinf/
	

	
	
