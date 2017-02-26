#Deleted all entries in Yost_1944F.txt that were NOT Moorea samples, leaving only the Moorea samples present - saved as Yost_1944F_M.txt

# Get list of only Moorea sample ids
cut -f1 Yost_1944F_M.txt | tail -n +2 > Moorea_sample_ids.txt

# Change sample names so qiime can read them for filtering
sed 's/::/_/; s/137_is_really_127/137isreally127/' Yost_1944F.fna > Yost_1944F_qiime.fna

# Filter out only Moorea samples
filter_fasta.py -f Yost_1944F_qiime.fna --sample_id_fp Moorea_sample_ids.txt -o Moorea.fasta


# Make pretty...
# Get rid of M's
sed 's/>\(...\)\M/>\1/' Moorea.fasta > Moorea2.fasta
# Get rid of -ITSDF
sed 's/-ITSDF//' Moorea2.fasta > Moorea3.fasta
# Changes first underscore to space
sed 's/_/\ /' Moorea3.fasta > Moorea4.fasta

# Add numbers to count sequences within each sample
python deal_with_texas.py -f Moorea4.fasta -o Moorea_seqs.fasta



# Compress..
tar -czvf Moorea_seqs.tar.gz Moorea_seqs.fasta

# Clean up
rm Yost_1944F_qiime.fna
rm Moorea.fasta
rm Moorea2.fasta
rm Moorea3.fasta
rm Moorea4.fasta
