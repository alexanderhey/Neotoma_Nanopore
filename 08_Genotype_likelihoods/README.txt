# ANGSD Genotype Likelihood Analysis Pipeline

## Overview
This three-script pipeline runs ANGSD to compute genotype likelihoods from BAM files, merges results across chromosomes, and performs Principal Component Analysis for population structure visualization.

## Required Software
- ANGSD 
- PCAngsd (conda environment)
- bgzip/htslib (for file compression)

## Input Files
- `bam_list.txt` - Text file listing paths to BAM files (one per line)
- Reference genome

## Key Parameters
- **Minimum individuals**: 9 (sites must have data from ≥9 samples)
- **Minimum depth**: 9 reads total across all samples
- **Minimum MAF**: 0.05 (5% minor allele frequency)
- **Quality thresholds**: MAPQ ≥30, base quality ≥20
- **SNP p-value**: 1e-6 (stringent SNP calling)

## Pipeline Steps

### Step 1: ANGSD Analysis (01_angsd_by_chr_minInd9_minDepth9.sh)
- Processes chromosomes individually for memory efficiency
- Computes genotype likelihoods using SAMtools model
- Outputs BEAGLE format for downstream analysis
- Applies multiple quality filters and BAQ correction
- Infers major/minor alleles and calculates MAF

### Step 2: Merge BEAGLE Files (02_merge_chrom_beagles.sh)
- Combines per-chromosome BEAGLE files into single dataset
- Preserves header from first file, appends data from remaining files
- Compresses final merged output for storage efficiency

### Step 3: Principal Component Analysis (03_pcANGSD.sh)
- Runs PCAngsd on merged BEAGLE file
- Performs PCA for population structure analysis
- Applies MAF filter (≥0.05) during analysis

## Output Files

### Step 1 Output (per chromosome):
- `genolike_[CHR].beagle.gz` - Genotype likelihoods in BEAGLE format
- `genolike_[CHR].mafs.gz` - Minor allele frequencies
- `genolike_[CHR].arg` - Analysis parameters and summary

### Step 2 Output:
- `genolike_merged_minind9_mindepth9.beagle.gz` - Merged BEAGLE file across all chromosomes

### Step 3 Output:
- `pcangsd_minind9_mindepth9_output.cov` - Covariance matrix
- `pcangsd_minind9_mindepth9_output.eigenvals` - Eigenvalues for PCA
- `pcangsd_minind9_mindepth9_output.eigenvecs` - Eigenvectors for PCA
