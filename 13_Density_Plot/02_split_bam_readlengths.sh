#!/bin/bash
#SBATCH --job-name=read_length_distribution
#SBATCH --partition=sixhour
#SBATCH --time=6:00:00
#SBATCH --mem=30G
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --output=read_length_distribution.log

# Activate conda environment with samtools
module load samtools

# Set directories
BAM_DIR="/kuhpc/work/colella/a733h002/neotoma/Window_Quality_Reports/split_bams_out"
OUTPUT_DIR="/kuhpc/work/colella/a733h002/neotoma/Window_Quality_Reports/read_length_plots_out"
mkdir -p $OUTPUT_DIR

# Process each BAM file
for bamfile in $BAM_DIR/*.bam; do
    # Extract filename without path and extension
    filename=$(basename "$bamfile" .bam)
    
    # Extract read lengths and count occurrences
    samtools view "$bamfile" | awk '{print length($10)}' | sort | uniq -c | awk '{print $2"\t"$1}' > "$OUTPUT_DIR/${filename}_lengths.tsv"

    echo "Processed $bamfile -> $OUTPUT_DIR/${filename}_lengths.tsv"
done

echo "All BAM files processed. Output saved in $OUTPUT_DIR"

# ----------------- Explanation of the for loop -----------------
# 1. The loop iterates over all BAM files in the specified directory.
# 2. For each BAM file:
#    - It extracts the filename without the path and extension for naming output files.
#    - It uses `samtools view` to extract the reads from the BAM file.
#    - The `awk '{print length($10)}'` command calculates the length of each read.
#    - The `sort | uniq -c` command counts the occurrences of each read length.
#    - The `awk '{print $2"\t"$1}'` reformats the output as "ReadLength<TAB>Count".
# 3. The processed read length distribution is saved in a TSV file inside the output directory.
# 4. The script prints a confirmation message for each processed BAM file.
# 5. After all BAM files are processed, a final message confirms the completion of the job.
