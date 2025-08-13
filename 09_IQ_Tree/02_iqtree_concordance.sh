#!/bin/bash
#SBATCH --job-name=vcf_to_treetoma
#SBATCH --partition=sixhour
#SBATCH --time=6:00:00
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --output=tree_to_concordance.%j.txt

module load bioconda

# Define file paths
vcf_file="/kuhpc/work/colella/a733h002/neotoma/IQ_TREE_FORALL/thebestvcf_nomissing_depth5_100distfilt_minmac2.vcf.gz"
phylip_output="thebestvcf_nomissing_depth5_100distfilt_minmac2.min4.phy"
tree_output="/kuhpc/work/colella/a733h002/neotoma/IQ_TREE_FORALL/thebestvcf_concordance"
tree_file="/kuhpc/work/colella/a733h002/neotoma/IQ_TREE_FORALL/final_iq_out_no_process_or_missing_dist100/finaltree.treefile"
# Define the custom Python path
export PATH=/kuhpc/work/colella/lab_software/python/bin:$PATH

# Step 2: Convert VCF to PHYLIP format using vcf2phylip.py with custom Python path
#python3 vcf2phylip.py -i "$vcf_file" -o "$phylip_output"

# Step 3: Build a phylogenetic tree with IQ-TREE
mkdir -p "$tree_output"


#this is to make the treefile
#iqtree2 -s "minmac2_noprocess_depth5_no_missingness.min4.phy" -m MFP -st DNA -bb 1000 -alrt 1000 -pre "$tree_output/tree" -nt AUTO

#-alrt is bootstrap replicates for SH-alrt
#-bb is ultrafast
#Numbers in parentheses are SH-aLRT support (%) / ultrafast bootstrap support (%) 

#this is run after the treefile is made and i want concordance factors
iqtree2 -te "$tree_file" -s "thebestvcf_nomissing_depth5_100distfilt_minmac2.min4.phy" --scfl 100 --prefix "$tree_output/tree"

