#!/bin/bash
# dorado_basecalling.sh
# Performs super accurate basecalling from raw POD5 files using Dorado

# Load Dorado module (or ensure dorado is in PATH)
module load dorado

# Define paths and parameters (UPDATE THESE PATHS)
dorado_model="dna_r10.4.1_e8.2_400bps_sup@v4.3.0"  # Update model as needed
input_base_dir="path/to/pod5_pass"  # Base directory containing RAW Nanopore reads split by barcode
output_dir="path/to/basecalling_output"  # Output directory for BAM files

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Define barcodes to process (UPDATE THESE BARCODES)
barcodes=(
    "barcode01"
    "barcode02"
    "barcode03"
    "barcode04"
    "barcode05"
)

# Define output file naming pattern (UPDATE AS NEEDED)
# This creates files like: sample1_sup.bam, sample2_sup.bam, etc.
declare -A output_names=(
    ["barcode01"]="sample1_sup.bam"
    ["barcode02"]="sample2_sup.bam"
    ["barcode03"]="sample3_sup.bam"
    ["barcode04"]="sample4_sup.bam"
    ["barcode05"]="sample5_sup.bam"
)

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error during basecalling for $1. Exiting."
        exit 1
    fi
}

# Process each barcode
for barcode in "${barcodes[@]}"; do
    # Define input and output paths
    input_path="$input_base_dir/$barcode"
    output_file="$output_dir/${output_names[$barcode]}"
    
    # Check if input directory exists
    if [ ! -d "$input_path" ]; then
        echo "Warning: Input directory $input_path does not exist. Skipping $barcode."
        continue
    fi
    
    echo "Starting basecalling for $barcode..."
    echo "Input: $input_path"
    echo "Output: $output_file"
    
    # Run Dorado basecalling
    dorado basecaller "$dorado_model" "$input_path" > "$output_file"
    check_error "$barcode"
    
    echo "Basecalling completed for $barcode: $output_file"
    echo "----------------------------------------"
done

echo "All basecalling jobs completed successfully!"
echo "Output files are in: $output_dir"

# Notes:
# - Super accurate (sup) basecaller provides highest accuracy but is slower
# - Dorado automatically detects and removes adapters/barcodes by default
# - Ensure sufficient disk space as output BAM files can be large
# - Consider running individual barcodes separately if processing time is long