# Phylogenetic Analysis Pipeline

## Overview
This pipeline converts filtered VCF files to phylogenetic format and constructs maximum likelihood trees with IQ-TREE, including concordance factor analysis for branch support assessment.

## Required Software
- IQ-TREE2 (phylogenetic inference)
- Python 3 (for VCF conversion)

## Input Files
- High-quality filtered VCF file
- `vcf2phylip.py` - Python script for format conversion

## Pipeline Steps

### Step 1: Format Conversion (01_iqtree.sh)
- Converts VCF to PHYLIP format using vcf2phylip.py
- Applies minimum sample filter (default: 4 samples per locus)
- Handles missing data and maintains sample names

### Step 2: Tree Construction (01_iqtree.sh)
- Runs IQ-TREE2 with model selection (MFP - ModelFinder Plus)
- Performs ultrafast bootstrap analysis (1000 replicates)
- Calculates SH-aLRT support values (1000 replicates)
- Uses automatic thread detection for optimal performance

### Step 3: Concordance Factor Analysis (02_iqtree_concordance.sh)
- Calculates site concordance factors (sCF) using the constructed tree
- Assesses support for each branch based on individual site patterns
- Provides additional measures of phylogenetic confidence

## Key Parameters

### VCF to PHYLIP Conversion:
- **Minimum samples per locus**: 4 individuals required
- **Missing data handling**: IUPAC ambiguity codes for heterozygotes
- **Output format**: PHYLIP alignment suitable for IQ-TREE

### IQ-TREE Analysis:
- **Model selection**: MFP (tests all available models)
- **Bootstrap replicates**: 1000 ultrafast bootstrap
- **SH-aLRT**: 1000 replicates for additional support
- **Data type**: DNA sequences
- **Threading**: Automatic optimization

### Concordance Factors:
- **Site concordance**: 100 quartets sampled
- **Input tree**: Uses tree from Step 2
- **Output**: Branch support based on concordant sites

## Output Files

### Step 1 & 2 Output:
- `*.phy` - PHYLIP alignment
- `finaltree.treefile` - Best ML tree in Newick format
- `finaltree.iqtree` - Detailed analysis log
- `finaltree.log` - IQ-TREE run log
- `finaltree.bionj` - Starting BioNJ tree
- `finaltree.mldist` - Maximum likelihood distances

### Step 3 Output:
- `tree.cf.tree` - Tree with concordance factors
- `tree.cf.stat` - Concordance statistics
- `tree.iqtree` - Analysis summary
