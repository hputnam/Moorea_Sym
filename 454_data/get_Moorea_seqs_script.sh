#!/bin/bash

#Deleted all entries in Yost_1944F.txt and Yost_2172.txt that were NOT Moorea samples, leaving only the Moorea samples present - saved as Yost_1944F_M.txt and Yost_2172_M.txt

# Get lists of only Moorea sample ids
cut -f1 454_data/Yost_1944FFasta/Yost_1944F_M.txt | tail -n +2 > 454_data/Yost_1944FFasta/Moorea_sample_ids.txt
cut -f1 454_data/Yost_2172FFasta/Yost_2172F_M.txt | tail -n +2 > 454_data/Yost_2172FFasta/Moorea_sample_ids.txt

# Change sample names so qiime can read them for filtering
sed 's/::/_/; s/137_is_really_127/137isreally127/' 454_data/Yost_1944FFasta/Yost_1944F.fna > 454_data/Yost_1944FFasta/Yost_1944F_qiime.fna
sed 's/::/_/' 454_data/Yost_2172FFasta/Yost_2172F.fna > 454_data/Yost_2172FFasta/Yost_2172F_qiime.fna

# Filter out only Moorea samples
filter_fasta.py -f 454_data/Yost_1944FFasta/Yost_1944F_qiime.fna --sample_id_fp 454_data/Yost_1944FFasta/Moorea_sample_ids.txt -o 454_data/Yost_1944FFasta/Moorea.fasta
filter_fasta.py -f 454_data/Yost_2172FFasta/Yost_2172F_qiime.fna --sample_id_fp 454_data/Yost_2172FFasta/Moorea_sample_ids.txt -o 454_data/Yost_2172FFasta/Moorea.fasta

# Combine sequences from both runs
cat 454_data/Yost_1944FFasta/Moorea.fasta 454_data/Yost_2172FFasta/Moorea.fasta > 454_data/Moorea.fasta

# Make pretty...
# Get rid of M's
sed 's/>\(...\)\M/>\1/' 454_data/Moorea.fasta > 454_data/Moorea2.fasta
# Get rid of -ITSDF
sed 's/-ITSDF//' 454_data/Moorea2.fasta > 454_data/Moorea3.fasta
# Changes first underscore to space
sed 's/_/\ /' 454_data/Moorea3.fasta > 454_data/Moorea4.fasta

# Add numbers to count sequences within each sample
python 454_data/deal_with_texas.py -f 454_data/Moorea4.fasta -o 454_data/Moorea_seqs.fasta



# Compress..
tar -czvf 454_data/Moorea_seqs.tar.gz 454_data/Moorea_seqs.fasta
# Copy to Bioinf directory
cp 454_data/Moorea_seqs.tar.gz Bioinf

# Clean up
rm 454_data/Yost_1944FFasta/Yost_1944F_qiime.fna
rm 454_data/Yost_1944FFasta/Moorea.fasta
rm 454_data/Yost_2172FFasta/Yost_2172F_qiime.fna
rm 454_data/Yost_2172FFasta/Moorea.fasta
rm 454_data/Moorea.fasta
rm 454_data/Moorea2.fasta
rm 454_data/Moorea3.fasta
rm 454_data/Moorea4.fasta
rm 454_data/Moorea_seqs.fasta
