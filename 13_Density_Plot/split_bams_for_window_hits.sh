#!/bin/bash
#SBATCH --job-name=split_bam_by_windows
#SBATCH --partition=colella
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --output=split_bam_by_windows.log

# Load necessary modules
module load conda
conda activate bioconda

# Define input variables
WINDOWS_BED="/kuhpc/work/colella/a733h002/neotoma/00_window_removal/filtered_40kb_loci_fixed.bed"
OUTPUT_DIR="/kuhpc/work/colella/a733h002/neotoma/Window_Quality_Reports/split_bams_out"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# List of BAM files
BAM_FILES=(
"/kuhpc/work/colella/a733h002/neotoma/Second_Run_Nanopore/02_alignment/sorted_FN2395_aligned_ind_sup.bam"
"/kuhpc/work/colella/a733h002/neotoma/Second_Run_Nanopore/02_alignment/sorted_FN2989_aligned_ind_sup.bam"
"/kuhpc/work/colella/a733h002/neotoma/Second_Run_Nanopore/02_alignment/sorted_FN3258_ind_sup.bam"
"/kuhpc/work/colella/a733h002/neotoma/Third_Run_Nanopore_Leucodons/02_align_and_sort/sort_out/sorted_MSB274024_aligned.bam"
"/kuhpc/work/colella/a733h002/neotoma/Third_Run_Nanopore_Leucodons/02_align_and_sort/sort_out/sorted_FN2980_aligned.bam"
"/kuhpc/work/colella/a733h002/neotoma/Third_Run_Nanopore_Leucodons/02_align_and_sort/sort_out/sorted_ASK15335_aligned.bam"
"/kuhpc/work/colella/a733h002/neotoma/Fourth_run_final_run/02_alignment/sort_out/sorted_FN1560_aligned.bam"
"/kuhpc/work/colella/a733h002/neotoma/Fourth_run_final_run/02_alignment/sort_out/sorted_FN2976_aligned.bam"
"/kuhpc/work/colella/a733h002/neotoma/Fourth_run_final_run/02_alignment/sort_out/sorted_NK305240_aligned.bam"
)

# Process each BAM file
for BAM in "${BAM_FILES[@]}"; do
    # Get filename
    BASENAME=$(basename "$BAM" .bam)

    # Define output files
    IN_WINDOWS_BAM="${OUTPUT_DIR}/${BASENAME}_in_windows.bam"
    OUT_WINDOWS_BAM="${OUTPUT_DIR}/${BASENAME}_out_windows.bam"

    # Step 1: Identify reads that overlap with windows
    bedtools intersect -a $BAM -b $WINDOWS_BED -wa > $IN_WINDOWS_BAM
    samtools index $IN_WINDOWS_BAM  # Index the BAM

    # Step 2: Identify reads **not in** IN_WINDOWS_BAM (fully outside windows)
    bedtools intersect -a $BAM -b $WINDOWS_BED -v > $OUT_WINDOWS_BAM
    samtools index $OUT_WINDOWS_BAM  # Index the BAM

    echo "Processed: $BAM -> $IN_WINDOWS_BAM & $OUT_WINDOWS_BAM"
done

echo "All BAM files have been split and indexed successfully."

