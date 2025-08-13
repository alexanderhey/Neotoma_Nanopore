# VCF SNP Filtering and Analysis Pipeline

## Overview
This R script performs quality control filtering on genomic variant data (VCF format) and conducts Principal Component Analysis (PCA) to visualize population structure.

## Required Libraries
- `vcfR` 
- `SNPfiltR`
- `reshape2`
- `ggplot2` 
- `gsheet`
- `dplyr`

## Input Files
- `step3_mac2.vcf.gz` - Input VCF file containing SNP data

## Analysis Steps

### 1. Data Loading and Population Setup
- Loads VCF file and extracts genotype matrix
- Defines 9 populations: Douglas Co FLO, Hamilton Mic, Aetna Micro, El Paso LEU, Hamilton Leu, Mexico Leu, Hamilton FLO, Hamilton Micro, Texas Micro
- Creates population map linking sample IDs to populations

### 2. Quality Control Filtering
Sequential filtering steps applied:
- **Depth filtering**: Minimum depth of 5 reads
- **Allele balance filtering**: Removes sites with poor allelic balance
- **Maximum depth filtering**: Caps depth at 100 reads
- **Minor allele count filtering**: 
  - MAC ≥ 1 (removes invariant sites)
  - MAC ≥ 2 (removes singletons)

### 3. Distance-Based Thinning
- **100bp thinning**: Removes SNPs within 100bp of each other
- **40kb thinning**: Retains one SNP per 40kb window for phylogenetic analysis


### 5. Visualization
- Generates PCA plots at multiple filtering stages
- Final plot shows population structure with sample labels

## Output Files
- vcf