
#!/bin/bash
# 02_sort.sh
# Sorts aligned BAM files by genomic coordinates

# Load samtools module (or ensure samtools is in PATH)
module load samtools

# Define input and output directories (UPDATE THESE PATHS)
input_dir="path/to/aligned_bams"
output_dir="path/to/sorted_bams"

# Create output directory if it doesn't exist
mkdir -p $output_dir

# List of BAM files to sort (UPDATE THESE FILENAMES)
bam_files=(
    "sample1_aligned.bam"
    "sample2_aligned.bam"
    "sample3_aligned.bam"
)

# Sort each BAM file
for bam_file in "${bam_files[@]}"; do
    # Define input and output paths
    input_path="$input_dir/$bam_file"
    output_path="$output_dir/sorted_$bam_file"
    
    echo "Sorting BAM file: $bam_file"
    
    # Sort the BAM file by genomic coordinates
    samtools sort -o "$output_path" "$input_path"
    
    if [ $? -eq 0 ]; then
        echo "$bam_file sorted successfully"
    else
        echo "Error sorting $bam_file"
        exit 1
    fi
done

echo "All BAM files sorted successfully in: $output_dir"