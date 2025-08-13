#!/bin/bash
#SBATCH --job-name=mask
#SBATCH --partition=colella
#SBATCH --time=10:00:00
#SBATCH --mem=120G
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --output=02.output_mask_external.%j.txt

# File paths
input_fasta="/kuhpc/work/colella/a733h002/neotoma/00_mask_windows/Nanotoma.masked.windows.external.masked5.fa"
output_file="/kuhpc/work/colella/a733h002/neotoma/00_mask_windows/masked_proportions.txt"

# Initialize the output file
echo -e "Window\tMasked_Bases" > $output_file

# Read the fasta file and process each window
awk '
  BEGIN { OFS="\t" }
  /^>/ {
    if (seq) {
      print header, seq_length - gsub(/N/, "", seq)
    }
    header = substr($0, 2)
    seq = ""
  }
  !/^>/ {
    seq = seq $0
    seq_length = length(seq)
  }
  END {
    if (seq) {
      print header, seq_length - gsub(/N/, "", seq)
    }
  }
' $input_fasta >> $output_file

echo "Counting masked bases completed. Results are saved in masked_proportions.txt"

