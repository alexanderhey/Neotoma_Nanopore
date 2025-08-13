# Joint Variant Calling Pipeline

## Overview
This bash script performs joint variant calling on 9 BAM files using bcftools, restricted to specific genomic windows defined in a BED file.

## Required Software
- bcftools

## Input Files
- BAM files 
- Reference genome
- BED file (defines target genomic windows)

## Analysis
The script runs two parallel variant calling processes:
1. **Variable sites**: Calls SNPs only (excludes indels)
2. **Invariant sites**: Calls monomorphic sites within target regions

Both analyses use quality filters (MAPQ ≥ 20, base quality ≥ 20) and cap read depth at 500x.

## Output Files
- `all_samples_var_only_window_snps.raw.vcf.gz` - Variable SNP sites
- `all_samples_inv_only_window_snps.raw.vcf.gz` - Invariant sites

## Usage

## Notes
- Runtime: ~100 hours with 120GB memory allocation
- Generates complementary datasets for population genetic analyses
- Restricted to predefined genomic windows for computational efficiency