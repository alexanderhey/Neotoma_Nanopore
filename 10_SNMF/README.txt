# Population Structure Analysis (SNMF)

## Overview
This pipeline converts VCF files to STRUCTURE format and performs population structure analysis using sNMF (sparse Non-negative Matrix Factorization) with LEA package, providing admixture coefficient visualization across multiple K values.

## Required Software
- R with packages: `LEA`, `vcfR`, `ggplot2`, `reshape2`, `dplyr`, `RColorBrewer`
- Bioconductor (for LEA installation)

## Required R Packages Installation
```r
# Install Bioconductor and LEA
source("http://bioconductor.org/biocLite.R")
BiocManager::install("LEA")

# Install other dependencies
install.packages(c("vcfR", "ggplot2", "reshape2", "dplyr", "RColorBrewer"))
```

## Input Files
- **VCF file**: High-quality filtered SNP data
- **Population map**: Sample IDs matched to population assignments

## Pipeline Steps

### Step 1: VCF to STRUCTURE Conversion (vcftostr.R)
- Converts VCF format to STRUCTURE format
- Extracts genotype matrix and handles missing data
- Creates population mapping for samples
- Outputs STRUCTURE-formatted file (.str)

### Step 2: STRUCTURE to GENO Conversion (neotoma_structure_swag.R)
- Converts STRUCTURE format to GENO format for LEA analysis
- Handles diploid data with proper formatting
- Removes header rows and processes sample labels

### Step 3: sNMF Analysis
- Tests multiple K values (1-10) with 100 replicates each
- Uses cross-entropy to determine optimal K
- Runs sparse Non-negative Matrix Factorization
- Parallel processing with multiple CPU cores

### Step 4: Visualization and Results
- Plots cross-entropy values across K values
- Generates admixture barplots for optimal K
- Creates multi-K comparison plots
- Reorders samples for publication-ready figures

## Output Files

### Intermediate Files:
- STRUCTURE format file
- GENO format for LEA analysis
- `*.snmfProject` - sNMF project files with all runs

### Manual step required:
Delete the header row from the .str file before proceeding with LEA analysis.

## Sample Ordering
The pipeline includes custom sample ordering for publication