# Read Group Addition and Variant Calling Pipeline

This SLURM batch script performs joint variant calling on multiple BAM files using a two-step approach:

1. **Read Group Addition**: Uses Picard's AddOrReplaceReadGroups to add proper sample identification metadata to BAM files
2. **Variant Calling**: Performs joint variant calling using BCFtools mpileup and call, then separates variants and invariants into separate VCF files

## Requirements
- Java (for Picard)
- BCFtools
- Picard JAR file
- Reference genome FASTA file

## Usage
Update the following paths in the script before running:
- `reference`: Path to your reference genome
- `picard_jar`: Path to Picard JAR file
- `input_bams`: Array of input BAM file paths
- `--partition`: Your SLURM partition name

## Output
- `AddOrReplace/`: BAM files with added read groups
- `variant_calling_output/`: VCF files containing all sites, variants only, and invariants only

Submit with: `sbatch script_name.sh`