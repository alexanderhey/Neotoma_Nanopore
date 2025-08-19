# Principal Component Analysis (PCA) for Population Structure

## Overview
This R script performs Principal Component Analysis on filtered genomic SNP data to visualize population genetic structure and differentiation among samples.

## Required Libraries
- `vcfR`, `SNPfiltR`, `reshape2`, `ggplot2`, `adegenet`

## Input Files
 - High-quality filtered VCF file


### 1. Data Preparation
- Loads filtered VCF file
- Extracts sample IDs and creates population mapping
- Converts VCF to `genlight` object for population genetics analysis

### 2. Principal Component Analysis
- Performs PCA using `glPca()` function with 6 principal components
- Extracts PCA scores and variance explained by each component
- Assigns samples to populations based on predefined mapping

### 3. Visualization
- Creates publication-ready PCA plot with custom color scheme
- Displays PC1 vs PC2 with variance explained percentages
- Uses distinct colors for each population for clear differentiation
- Applies clean theme suitable for publication

### 4. Color Scheme
Custom colors assigned to populations

## Output Files
- PCA PDF
