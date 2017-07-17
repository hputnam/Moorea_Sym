all: RAnalysis/Data/Moorea_97glo_sym.RData RAnalysis/Data/Moorea_sym.RData RAnalysis/Data/Moorea_sym100.RData

RAnalysis/data_analysis.html: RAnalysis/data_analysis.Rmd
	R -e 'if(Sys.info()[["sysname"]]=="Darwin") { Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc") } else { Sys.setenv(RSTUDIO_PANDOC="/usr/lib/rstudio/bin/pandoc") }; rmarkdown::render("RAnalysis/data_analysis.Rmd")'

RAnalysis/Data/A_tree_seqs_aligned_clean.fasta: RAnalysis/Scripts/build.phy.tree.txt
	bash RAnalysis/Scripts/build.phy.tree.txt
	
RAnalysis/Data/tax.table.txt:
	R -e 'load("RAnalysis/Data/Moorea_sym_f.RData"); write.table(data.frame(phyloseq::tax_table(phy.f)), "RAnalysis/Data/tax.table.txt", row.names=T, quote=F)'

RAnalysis/Data/tempdata.RData: RAnalysis/Scripts/temperature_analysis.R
	R --vanilla < RAnalysis/Scripts/temperature_analysis.R

# Filter out low read count taxa and samples from 97% within-sample OTUs
RAnalysis/Data/Moorea_sym_f.RData: RAnalysis/Data/Moorea_sym.RData
	R --vanilla < Bioinf/filter_phy.R --args $< RAnalysis/Data/Moorea_sym_f.RData

# Filter out low read count taxa and samples from 100% within-sample OTUs
RAnalysis/Data/Moorea_sym100_f.RData: RAnalysis/Data/Moorea_sym100.RData
	R --vanilla < Bioinf/filter_phy.R --args $< RAnalysis/Data/Moorea_sym100_f.RData

# Filter out sequences that are not Symbiodinium from 97% within-sample OTUs
RAnalysis/Data/Moorea_sym.RData: RAnalysis/Data/Moorea.RData Bioinf/clust/all_rep_set_rep_set.fasta
	R --vanilla < ~/SymITS2/filter_notsym.R --args $^ RAnalysis/Data/Moorea_sym.RData $NT_PATH

# Build phyloseq object for 97% within-sample OTUs
RAnalysis/Data/Moorea.RData: Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv RAnalysis/Data/Moorea_sample_info.tsv 
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv \
	RAnalysis/Data/Moorea_sample_info.tsv \
	Bioinf/clust/97_otus_bysample.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea.RData
	
# Filter out sequences that are not Symbiodinium from 100% OTUs
RAnalysis/Data/Moorea_sym100.RData: RAnalysis/Data/Moorea_100.RData Bioinf/clust100/100_otus_rep_set.fasta
	R --vanilla < ~/SymITS2/filter_notsym.R --args $^ RAnalysis/Data/Moorea_sym100.RData $NT_PATH

# Build phyloseq object for 100% OTUs
RAnalysis/Data/Moorea_100.RData: Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv RAnalysis/Data/Moorea_sample_info.tsv 
	R --vanilla < ~/SymITS2/build_phyloseq.R --args \
	Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv \
	RAnalysis/Data/Moorea_sample_info.tsv \
	Bioinf/clust100/100_otus.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea_100.RData

# Filter out sequences that are not Symbiodinium from 97% global OTUs
RAnalysis/Data/Moorea_97glo_sym.RData: RAnalysis/Data/Moorea_97glo.RData Bioinf/clust97glo/97_otus_rep_set.fasta
	R --vanilla < ~/SymITS2/filter_notsym.R --args $^ RAnalysis/Data/Moorea_97glo_sym.RDada "${NT_PATH}"

# Build phyloseq object for 97% global OTUs
RAnalysis/Data/Moorea_97glo.RData: Bioinf/clust97glo/97_otus_rep_set_nw_tophits.tsv RAnalysis/Data/Moorea_sample_info.tsv
	R --vanilla < ~/SymITS2/build_phyloseq.R --args $^ \
	Bioinf/clust97glo/97_otus.tsv \
	Bioinf/ITS2db_trimmed_notuniques_otus.txt \
	RAnalysis/Data/Moorea_97glo.RData

# Assign taxonomy using Needleman-Wunsch global alignment to database for 97% within sample clustering
Bioinf/clust/all_rep_set_rep_set_nw_tophits.tsv: Bioinf/clust/all_rep_set_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $^
	
# Assign taxonomy using Needleman-Wunsch global alignment to database for 100% clustering
Bioinf/clust100/100_otus_rep_set_nw_tophits.tsv: Bioinf/clust100/100_otus_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $^

# Assign taxonomy using Needleman-Wunsch global alignment to database for 97% global clustering
Bioinf/clust97glo/97_otus_rep_set_nw_tophits.tsv: Bioinf/clust97glo/97_otus_rep_set.fasta Bioinf/ITS2db_trimmed_derep.fasta
	R --vanilla < ~/SymITS2/run_nw.R --args $^

# Cluster at 97% within samples
Bioinf/clust/all_rep_set_rep_set.fasta: Bioinf/Moorea_seqs_trimmed.fasta
	~/SymITS2/otus_97_bysample.sh $< Bioinf/clust
	
# Cluster at 100%
Bioinf/clust100/100_otus_rep_set.fasta: Bioinf/Moorea_seqs_trimmed.fasta
	~/SymITS2/otus_100.sh $< Bioinf/clust100

# Cluster at 97% globally
Bioinf/clust97glo/97_otus_rep_set.fasta: Bioinf/Moorea_seqs_trimmed.fasta
	~/SymITS2/otus_97.sh $< Bioinf/clust97glo

# Trim adapters and barcodes
Bioinf/Moorea_seqs_trimmed.fasta: Bioinf/Moorea_seqs.fasta
	cutadapt -g GTGAATTGCAGAACTCCGTG -e 0.15 -O 18 --discard-untrimmed Bioinf/Moorea_seqs.fasta -o Bioinf/Moorea_seqs_trimF.fasta	
	cutadapt -g GTGAATTGCAGAACTCCGTG -e 0.15 -O 18 Bioinf/Moorea_seqs_trimF.fasta	 -o Bioinf/Moorea_seqs_trimF2.fasta	
	cutadapt -a AAGCATATAAGTAAGCGGAGG -e 0.15 -O 18 Bioinf/Moorea_seqs_trimF2.fasta -o Bioinf/Moorea_seqs_trimF2_trimR.fasta
	cutadapt -a AAGCATATAAGTAAGCGGAGG -e 0.15 -O 18 Bioinf/Moorea_seqs_trimF2_trimR.fasta -o Bioinf/Moorea_seqs_trimmed.fasta

# Uncompress sequences
Moorea_seqs.fasta: Moorea_seqs.tar.gz
	tar -xzvf Moorea_seqs.tar.gz -m
