#!/bin/bash
# 03_index_all.sh
# Creates BAM index files for sorted BAM files

# Load samtools module (or ensure samtools is in PATH)
module load samtools

# Define directory containing sorted BAM files (UPDATE THIS PATH)
bam_dir="path/to/sorted_bams"

# List of sorted BAM files to index (UPDATE THESE FILENAMES)
bam_files=(
    "sorted_sample1_aligned.bam"
    "sorted_sample2_aligned.bam"
    "sorted_sample3_aligned.bam"
)

# Index each BAM file
for bam_file in "${bam_files[@]}"; do
    bam_path="$bam_dir/$bam_file"
    
    echo "Indexing BAM file: $bam_file"
    
    # Create BAM index
    samtools index "$bam_path"
    
    if [ $? -eq 0 ]; then
        echo "$bam_file indexed successfully"
    else
        echo "Error indexing $bam_file"
        exit 1
    fi
done

echo "All BAM files indexed successfully"