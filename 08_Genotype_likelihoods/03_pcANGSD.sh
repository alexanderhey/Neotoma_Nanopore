#!/bin/bash
#SBATCH --job-name=pcangsd_pca
#SBATCH --partition=bi
#SBATCH --time=24:00:00
#SBATCH --mem=60G
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --output=pcangsd_pca.%j.log

# Load conda and activate PCAngsd environment
module load conda
conda activate pcangsd

# Define input and output paths
INPUT_BEAGLE="/kuhpc/work/colella/a733h002/neotoma/05ANGSD/ANGSD_BY_CHROM_MININD9_MINDEPTH9/genolike_merged_minind9_mindepth9.beagle.gz"
OUTPUT_DIR="/kuhpc/work/colella/a733h002/neotoma/05ANGSD/PCA_MDS_FROM_BEAGLE"
OUTPUT_PREFIX="${OUTPUT_DIR}/pcangsd_minind9_mindepth9_output"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run PCAngsd
echo "?? Running PCAngsd..."
pcangsd -b $INPUT_BEAGLE -o $OUTPUT_PREFIX -t 10 --maf 0.05

echo "? PCAngsd analysis complete. Results saved to $OUTPUT_PREFIX.*"
