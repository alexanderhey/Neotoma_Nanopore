#!/bin/bash
#SBATCH --job-name=vcf_to_treetoma
#SBATCH --partition=sixhour
#SBATCH --time=6:00:00
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --output=vcf_to_tree.%j.txt

module load bioconda

# Define file paths
vcf_file="/kuhpc/work/colella/a733h002/neotoma/IQ_TREE_FORALL/thebestvcf_nomissing_depth5_100distfilt_minmac2.vcf.gz"
phylip_output="/kuhpc/work/colella/a733h002/neotoma/IQ_TREE_FORALL/thebestvcf_nomissing_depth5_100distfilt_minmac2.phy"
tree_output="/kuhpc/work/colella/a733h002/neotoma/IQ_TREE_FORALL/final_iq_out_no_process_or_missing_dist100"

# Define the custom Python path
export PATH=/kuhpc/work/colella/lab_software/python/bin:$PATH

# Step 2: Convert VCF to PHYLIP format using vcf2phylip.py with custom Python path
#python3 vcf2phylip.py -i "$vcf_file" -o "$phylip_output"

# Step 3: Build a phylogenetic tree with IQ-TREE
mkdir -p "$tree_output"

iqtree2 -s "thebestvcf_nomissing_depth5_100distfilt_minmac2.min4.phy" -m MFP -st DNA -bb 1000 -alrt 1000 -pre "$tree_output/finaltree" -nt AUTO

#-alrt is bootstrap replicates for SH-alrt
#-bb is ultrafast
#Numbers in parentheses are SH-aLRT support (%) / ultrafast bootstrap support (%) 


