#!/bin/bash
#SBATCH --job-name=window_removal
#SBATCH --partition=colella
#SBATCH --time=600:00:00
#SBATCH --mem=60G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=out.%j.window.removal.txt

# Input FASTA file
input_fasta="/kuhpc/work/colella/a733h002/neotoma/00_mask_windows/Nanotoma.masked.windows.external.masked5.fa"

# Output FASTA file
output_fasta="/kuhpc/work/colella/a733h002/neotoma/00_window_removal/filtered_40kb_loci.nuc.mito.fasta"

# Window to remove
window_to_remove=">Nlep_chromosome_17:199634-239634"

# Temporary file to store intermediate results
temp_fasta=$(mktemp)

# Remove the specified window from the FASTA file
awk -v window="$window_to_remove" '{
    if ($0 ~ /^>/) {
        if ($0 == window) {
            remove = 1
        } else {
            remove = 0
        }
    }
    if (!remove) {
        print $0
    }
}' "$input_fasta" > "$temp_fasta"

# Move the temporary file to the output location
mv "$temp_fasta" "$output_fasta"

echo "The specified window has been removed. Output saved to $output_fasta"

