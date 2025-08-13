#!/bin/bash
#SBATCH --job-name=angsd_chr_minind9_mindepth9
#SBATCH --partition=colella
#SBATCH --time=500:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=15
#SBATCH --output=angsd_chr_minind9_mindepth9.%j.log

# Load conda environment with ANGSD
module load bioconda

# Define input/output paths and key parameters
BAM_LIST="bam_list.txt"
REFERENCE_GENOME="/kuhpc/work/colella/ben/007.neotoma.panel/01.reference.genome/Neotoma_lepida.Chromosomes.fasta"
OUTPUT_DIR="/kuhpc/work/colella/a733h002/neotoma/05ANGSD/ANGSD_BY_CHROM_MININD9_MINDEPTH9"

MIN_IND=9          # Require data from at least 9 individuals at a site
MIN_MAF=0.05       # Minimum minor allele frequency
MIN_MAPQ=30        # Minimum mapping quality
MIN_BASEQ=20       # Minimum base quality
SET_MIN_DEPTH=9    # Minimum total depth across all samples
N_CORES=10         # Number of threads for ANGSD

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Generate list of chromosomes/scaffolds
grep "^>" "${REFERENCE_GENOME}" | cut -d' ' -f1 | sed 's/^>//' > chrom_list.txt

# Run ANGSD per chromosome
while read CHR; do
    echo "Processing chromosome: ${CHR}"

    angsd -b "${BAM_LIST}" \
        -ref "${REFERENCE_GENOME}" \
        -r "${CHR}" \
        -out "${OUTPUT_DIR}/genolike_${CHR}" \
        -nThreads "${N_CORES}" \
        -GL 1 \
        -doGlf 2 \
        -doMajorMinor 1 \
        -doMaf 1 \
        -SNP_pval 1e-6 \
        -minMapQ "${MIN_MAPQ}" \
        -minQ "${MIN_BASEQ}" \
        -minInd "${MIN_IND}" \
        -minMaf "${MIN_MAF}" \
        -baq 1 \
        -C 50 \
        -doCounts 1 \
        -setMinDepth "${SET_MIN_DEPTH}"

    if [ $? -ne 0 ]; then
        echo "ERROR: ANGSD failed on chromosome ${CHR}"
        exit 1
    fi
done < chrom_list.txt

echo "✅ Completed ANGSD run for all chromosomes with -minInd=${MIN_IND} and -setMinDepth=${SET_MIN_DEPTH}."

####################################################################
# ANGSD Flag Descriptions:
#
# -b <file>               : File containing list of BAM files to use.
# -ref <fasta>            : Reference genome in FASTA format.
# -r <region>             : Specific chromosome or scaffold to analyze.
# -out <prefix>           : Prefix for output files.
# -nThreads <int>         : Number of CPU threads to use (parallel processing).
#
# --- Genotype Likelihood Estimation ---
# -GL 1                   : Use SAMtools model for computing genotype likelihoods.
#
# --- Output Format ---
# -doGlf 2                : Output genotype likelihoods in BEAGLE format (useful for NGSadmix).
#
# --- Allele Inference ---
# -doMajorMinor 1         : Infer major and minor alleles from the data.
# -doMaf 1                : Calculate minor allele frequency (MAF).
# -SNP_pval 1e-6          : SNP calling p-value threshold; lower = more stringent.
#
# --- Read and Base Quality Filters ---
# -minMapQ <int>          : Minimum mapping quality score for a read to be considered.
# -minQ <int>             : Minimum base quality score for a base to be used.
#
# --- Individual/Sample Filters ---
# -minInd <int>           : Minimum number of individuals with data required at a site.
#
# --- Allele Frequency Filters ---
# -minMaf <float>         : Minimum minor allele frequency to retain a site (filters out rare alleles).
#
# --- Alignment-Based Filters ---
# -baq 1                  : Apply BAQ (Base Alignment Quality) computation to reduce false SNPs near indels.
# -C 50                   : Adjust mapping quality for excessive mismatches (higher = stricter).
#
# --- Depth Filters ---
# -doCounts 1             : Count read depth per site and individual (needed for depth-based filters).
# -setMinDepth <int>      : Minimum combined read depth across all samples required to retain a site.
#
####################################################################
