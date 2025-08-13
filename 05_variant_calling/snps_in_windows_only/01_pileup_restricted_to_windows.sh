#!/bin/bash

# SLURM job submission parameters
#SBATCH --job-name=Variant_Calling_Pipeline_Restricted      # Job name for queue
#SBATCH --partition=bi                                       # Partition/queue to submit to
#SBATCH --time=100:00:00                                     # Maximum wall time (100 hours)
#SBATCH --mem=120G                                           # Memory allocation (120 GB)
#SBATCH --nodes=1                                            # Number of compute nodes
#SBATCH --ntasks=10                                          # Number of CPU cores
#SBATCH --output=variant_calling_pipeline_restricted.log    # Output log file

# Load required software modules
module load bioconda

# Define input and output directories
fix_mate_dir="AddOrReplace"                                  # Directory containing processed BAM files
vcf_output_dir="vcfs_restricted_to_wondows_final"           # Output directory for VCF files
reference="/kuhpc/work/colella/ben/007.neotoma.panel/01.reference.genome/Neotoma_lepida.Chromosomes.fasta"  # Reference genome
bed_file="/kuhpc/work/colella/a733h002/neotoma/00_window_removal/filtered_40kb_loci_fixed.bed"              # BED file defining genomic regions

# Create output directory if it doesn't exist
mkdir -p $vcf_output_dir

# Array of processed BAM files (post-MarkDuplicates and FixMateInformation)
processed_bams=(
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_FN2395_aligned_ind_sup_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_FN2989_aligned_ind_sup_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_FN3258_ind_sup_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_ASK15335_aligned_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_FN2980_aligned_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_MSB274024_aligned_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_FN1560_aligned_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_FN2976_aligned_add.bam"
    "/kuhpc/work/colella/a733h002/neotoma/VCFTOOLS_FOR_ALL/AddOrReplace/sorted_NK305240_aligned_add.bam"
)

# Convert array to space-separated string for bcftools input
processed_bams_str=$(IFS=" "; echo "${processed_bams[*]}")

# VARIANT SITES CALLING (SNPs only, excluding indels)
echo "Starting variant sites calling..."
bcftools mpileup \
    --threads 4 \                                            # Use 4 CPU threads for parallel processing
    -d 500 \                                                 # Maximum read depth per sample (cap at 500x)
    -q 20 \                                                  # Minimum mapping quality for reads (MAPQ = 20)
    -Q 20 \                                                  # Minimum base quality for bases (QUAL = 20)
    -R "$bed_file" \                                         # Restrict analysis to regions in BED file
    -Ou \                                                    # Output uncompressed BCF format (for piping)
    -a "FORMAT/AD,FORMAT/DP,FORMAT/SP,INFO/AD" \            # Include allelic depth, read depth, strand bias, and info allelic depth
    -f "$reference" \                                        # Reference genome FASTA file
    $processed_bams_str | \                                  # Input BAM files
bcftools call \
    -mv \                                                    # Call multiallelic variants (-m) and variant sites only (-v)
    -V indels \                                              # Exclude indels, keep only SNPs
    -Oz \                                                    # Output compressed VCF format (.vcf.gz)
    -o "$vcf_output_dir/all_samples_var_only_window_snps.raw.vcf.gz"  # Output file path

echo "Variant sites calling completed"

# INVARIANT SITES CALLING (monomorphic sites within specified regions)
echo "Starting invariant sites calling..."
bcftools mpileup \
    --threads 4 \                                            # Use 4 CPU threads for parallel processing
    -d 500 \                                                 # Maximum read depth per sample (cap at 500x)
    -q 20 \                                                  # Minimum mapping quality for reads (MAPQ = 20)
    -Q 20 \                                                  # Minimum base quality for bases (QUAL = 20)
    -R "$bed_file" \                                         # Restrict analysis to regions in BED file
    -Ou \                                                    # Output uncompressed BCF format (for piping)
    -a "FORMAT/AD,FORMAT/DP,FORMAT/SP,INFO/AD" \            # Include allelic depth, read depth, strand bias, and info allelic depth
    -f "$reference" \                                        # Reference genome FASTA file
    $processed_bams_str | \                                  # Input BAM files
bcftools call \
    -mv \                                                    # Call multiallelic variants (-m) and variant sites only (-v)
    -V snps \                                                # Exclude SNPs, keep only invariant sites
    -Ov \                                                    # Output uncompressed VCF format
    -o "$vcf_output_dir/all_samples_inv_only_window_snps.raw.vcf.gz"  # Output file path

echo "Invariant sites calling completed"

# Note: The script generates two separate VCF files:
# 1. all_samples_var_only_window_snps.raw.vcf.gz - Contains only variable SNP sites
# 2. all_samples_inv_only_window_snps.raw.vcf.gz - Contains only invariant sites
# Both are restricted to the genomic windows defined in the BED file