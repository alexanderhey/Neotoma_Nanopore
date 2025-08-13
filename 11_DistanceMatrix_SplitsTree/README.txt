# Splits Network Analysis

## Overview
This R script calculates Nei's genetic distances between individuals from VCF data and exports a distance matrix for phylogenetic network analysis in SplitsTree.

## Required Software
- R with packages: `vcfR`, `adegenet`, `ggplot2`, `StAMPP`, `reshape2`
- SplitsTree (external software for network visualization)

## Required R Packages Installation
```r
install.packages(c("vcfR", "adegenet", "ggplot2", "StAMPP", "reshape2"))
```

## Input Files
- **VCF file**: High-quality filtered SNP data 

## Analysis Steps

### Step 1: Data Loading and Conversion
- Loads VCF file using vcfR
- Converts VCF to genlight object for population genetics analysis
- Extracts and cleans sample IDs (removes file path prefixes)

### Step 2: Population Assignment
- Maps samples to predefined populations
- Creates population mapping dataframe
- Assigns population labels to genlight object

### Step 3: Distance Calculation
- Calculates Nei's genetic distances between all pairs of individuals
- Uses StAMPP package for distance computation
- Generates pairwise distance matrix suitable for network analysis

### Step 4: Export for SplitsTree
- Exports distance matrix in PHYLIP format
- Creates file compatible with SplitsTree software
- Maintains sample names for network node labeling

## Output Files
- PHYLIP format distance matrix for SplitsTree

## SplitsTree Analysis
After running this script:
1. Open SplitsTree software
2. Import the generated distance matrix file (PHYLIP format)
3. Visualize in Splitnetwork
