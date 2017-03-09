all: RAnalysis/Data/Moorea_sym.RData RAnalysis/Data/Moorea_sym100.RData

# Filter out sequences that are not Symbiodinium from 97% OTUs
RAnalysis/Data/Moorea_sym.RData: RAnalysis/Data/Moorea.RData Bioinf/clust/all_rep_set_rep_set.fasta
	R --vanilla < ~/SymITS2/filter_notsym.R --args $^ RAnalysis/Data/Moorea_sym.RData /Volumes/NGS_DATA/ncbi_nt/nt/nt

# Build phyloseq object for 97% OTUs
RAnalysis/Data/Moorea.RData: Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv RAnalysis/Data/Moorea_sample_info.tsv 
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv \
	RAnalysis/Data/Moorea_sample_info.tsv \
	Bioinf/clust/97_otus_bysample.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea.RData
	
# Filter out sequences that are not Symbiodinium from 100% OTUs
RAnalysis/Data/Moorea_sym100.RData: RAnalysis/Data/Moorea_100.RData Bioinf/clust100/100_otus_rep_set.fasta
	R --vanilla < ~/SymITS2/filter_notsym.R --args $^ RAnalysis/Data/Moorea_sym100.RData /Volumes/NGS_DATA/ncbi_nt/nt/nt

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
	R --vanilla < ~/SymITS2/run_nw.R --args $^
	
# Assign taxonomy using Needleman-Wunsch global alignment to database for 100% clustering
Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv: Bioinf/clust100/100_otus_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $^

# Cluster at 97% within samples
Bioinf/clust/all_rep_set_rep_set.fasta: Bioinf/Moorea_seqs_trimmed.fasta
	~/SymITS2/otus_97_bysample.sh $< Bioinf/clust
	
# Cluster at 100%
Bioinf/clust100/100_otus_rep_set.fasta: Bioinf/Moorea_seqs_trimmed.fasta
	~/SymITS2/otus_100.sh $< Bioinf/clust100

# Trim adapters and barcodes
cutadapt -g GTGAATTGCAGAACTCCGTG -e 0.15 -O 18 --discard-untrimmed Moorea_seqs.fasta -o Moorea_seqs_trimF.fasta	
cutadapt -g GTGAATTGCAGAACTCCGTG -e 0.15 -O 18 Moorea_seqs_trimF.fasta	 -o Moorea_seqs_trimF2.fasta	
cutadapt -a AAGCATATAAGTAAGCGGAGG -e 0.15 -O 18 Moorea_seqs_trimF2.fasta -o Moorea_seqs_trimF2_trimR.fasta
cutadapt -a AAGCATATAAGTAAGCGGAGG -e 0.15 -O 18 Moorea_seqs_trimF2_trimR.fasta -o Moorea_seqs_trimmed.fasta
