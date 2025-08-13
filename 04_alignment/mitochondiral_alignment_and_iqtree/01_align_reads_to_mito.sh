#!/bin/bash
# 01_align_reads_to_mito.sh
# Aligns basecalled reads to mitochondrial reference genome

# Load required modules
module load java
module load bcftools
module load samtools

# Define tool paths (UPDATE THESE PATHS)
dorado_path="path/to/dorado/bin/dorado"
mito_reference="path/to/mitochondrial_reference.fasta"

# Create output directories
alignment_dir="./alignment_results"
sorted_dir="./sorted_bam_files"
mkdir -p "$alignment_dir" "$sorted_dir"

# Define sample mapping (UPDATE THESE MAPPINGS)
# Format: [input_filename]="sample_name"
declare -A sample_map=(
    ["sample1_basecalled.bam"]="Sample_1"
    ["sample2_basecalled.bam"]="Sample_2"
    ["sample3_basecalled.bam"]="Sample_3"
    ["sample4_basecalled.bam"]="Sample_4"
    ["sample5_basecalled.bam"]="Sample_5"
)

# Define input BAM files (UPDATE THESE PATHS)
input_bams=(
    "path/to/sample1_basecalled.bam"
    "path/to/sample2_basecalled.bam"
    "path/to/sample3_basecalled.bam"
    "path/to/sample4_basecalled.bam"
    "path/to/sample5_basecalled.bam"
)

# Process each BAM file
for bam_file in "${input_bams[@]}"; do
    # Extract filename
    filename=$(basename "$bam_file")
    
    # Get sample name from mapping
    sample_name=${sample_map[$filename]}
    
    if [ -n "$sample_name" ]; then
        # Define output files
        aligned_bam="${alignment_dir}/${sample_name}_mito_aligned.bam"
        sorted_bam="${sorted_dir}/${sample_name}_mito_sorted.bam"
        
        # Run alignment
        echo "Aligning $bam_file to mitochondrial reference as $aligned_bam"
        $dorado_path aligner "$mito_reference" "$bam_file" > "$aligned_bam"
        
        if [ $? -ne 0 ]; then
            echo "Error during alignment of $bam_file"
            continue
        fi
        
        # Sort aligned BAM
        echo "Sorting $aligned_bam to $sorted_bam"
        samtools sort -o "$sorted_bam" "$aligned_bam"
        
        if [ $? -ne 0 ]; then
            echo "Error during sorting of $aligned_bam"
            continue
        fi
        
        # Index sorted BAM
        echo "Indexing $sorted_bam"
        samtools index "$sorted_bam"
        
        if [ $? -ne 0 ]; then
            echo "Error during indexing of $sorted_bam"
            continue
        fi
        
        echo "Successfully processed $sample_name"
    else
        echo "No sample mapping found for $filename. Skipping."
    fi
done

echo "Mitochondrial alignment, sorting, and indexing complete."

