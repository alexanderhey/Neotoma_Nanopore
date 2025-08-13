#!/bin/bash


# Load required modules (adjust module names as needed for your system)
module load java
module load bcftools

# Define output directory
output_dir="AddOrReplace"

# Path to reference genome (UPDATE THIS PATH)
reference="path/to/your/reference_genome.fasta"

# Path to Picard JAR file (UPDATE THIS PATH)
picard_jar="path/to/picard.jar"

# Path to BCFtools executable (UPDATE THIS PATH if not using module)
bcftools_path="bcftools"

# VCF output directory
vcf_output_dir="variant_calling_output"

# Ensure output directories exist
mkdir -p $output_dir $vcf_output_dir

# Array of input BAM files (UPDATE THESE PATHS)
input_bams=(
    "path/to/sample1.bam"
    "path/to/sample2.bam"
)

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error during $1. Exiting."
        exit 1
    fi
}

# Process BAM files to add or replace read groups
processed_bams=()

for input_bam in "${input_bams[@]}"; do
    # Extract the base name from the filename without extension
    base_name=$(basename "$input_bam" .bam)
    
    # Add or Replace Read Groups with a unique RGSM
    processed_bam="$output_dir/${base_name}_add.bam"
    java -jar "$picard_jar" AddOrReplaceReadGroups \
        I="$input_bam" \
        O="$processed_bam" \
        RGID=3 \
        RGLB=Lib1 \
        RGPL=MinION \
        RGPU=1 \
        RGSM="${base_name}" \
        VALIDATION_STRINGENCY=LENIENT
    check_error "AddOrReplaceReadGroups"
    echo "AddOrReplaceReadGroups completed for $input_bam"
    
    # Add processed BAM to array for variant calling
    processed_bams+=("$processed_bam")
done

echo "Read group processing completed for all samples."
echo "Processed BAM files are stored in: $output_dir"

# === VARIANT CALLING WITH BCFTOOLS === #
echo "Starting variant calling..."

# Convert BAM array into space-separated string
input_bams_str=$(IFS=" "; echo "${processed_bams[*]}")

# === RUN MPILEUP AND CALL ALL SITES === #
echo "Running mpileup..."
all_sites_vcf="$vcf_output_dir/all_sites.vcf.gz"
$bcftools_path mpileup --threads 12 -q 30 -Q 30 -f "$reference" -Ou $input_bams_str | $bcftools_path call --multiallelic-caller -Oz -f GQ -o "$all_sites_vcf"
check_error "mpileup and calling"
echo "All sites VCF generated: $all_sites_vcf"

# === FILTER VARIANT AND INVARIANT SITES === #
echo "Extracting variant sites..."
variant_vcf="$vcf_output_dir/variants.vcf.gz"
$bcftools_path view -v snps "$all_sites_vcf" -o "$variant_vcf"
check_error "extracting variant sites"
echo "Variant sites extracted: $variant_vcf"

echo "Extracting invariant sites..."
invariant_vcf="$vcf_output_dir/invariants.vcf.gz"
$bcftools_path view --max-alleles 1 "$all_sites_vcf" -o "$invariant_vcf"
check_error "extracting invariant sites"
echo "Invariant sites extracted: $invariant_vcf"

echo "Pipeline completed successfully!"
echo "Output files:"
echo "  - All sites: $all_sites_vcf"
echo "  - Variants: $variant_vcf"
echo "  - Invariants: $invariant_vcf"