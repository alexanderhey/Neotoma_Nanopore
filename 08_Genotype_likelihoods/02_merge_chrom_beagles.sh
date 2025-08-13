#!/bin/bash
#SBATCH --job-name=merge_beagle
#SBATCH --partition=bi
#SBATCH --time=12:00:00
#SBATCH --mem=60G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=merge_beagle.%j.log

# Load modules (bgzip is part of htslib, often available via bioconda)
module load bioconda
conda activate bioconda  # make sure bgzip is available

# Define input and output paths
INPUT_DIR="/kuhpc/work/colella/a733h002/neotoma/05ANGSD/ANGSD_BY_CHROM_MININD9_MINDEPTH9"
OUTPUT_FILE="/kuhpc/work/colella/a733h002/neotoma/05ANGSD/ANGSD_BY_CHROM_MININD9_MINDEPTH9/genolike_merged_minind9_mindepth9.beagle.gz"

# Find all Beagle files, sorted
FILES=$(ls ${INPUT_DIR}/genolike_Nlep_chromosome_*.beagle.gz | sort)

# Temporary merged output
TEMP_FILE="merged.genolike.temp"

# Use first file to get header and data
FIRST_FILE=$(echo $FILES | awk '{print $1}')
echo "Using first file: $FIRST_FILE"
zcat $FIRST_FILE > $TEMP_FILE

# Append only the data (skip header) from remaining files
for f in $FILES; do
    if [ "$f" != "$FIRST_FILE" ]; then
        echo "Merging file: $f"
        zcat $f | awk 'NR>1' >> $TEMP_FILE
    fi
done

# Compress merged file
echo "Compressing final output..."
bgzip -c $TEMP_FILE > $OUTPUT_FILE
rm $TEMP_FILE

echo "✅ Beagle files merged into: $OUTPUT_FILE"
