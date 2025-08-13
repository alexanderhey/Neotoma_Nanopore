#!/bin/bash
#SBATCH --job-name=bowtiebuild
#SBATCH --partition=colella
#SBATCH --time=6:00:00
#SBATCH --mem=120G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=01.output.bowtie.%j.txt

# Load necessary modules (if required)
module load bowtie

# Define the input and output files
INPUT_FASTA="/kuhpc/work/colella/ben/007.neotoma.panel/01.reference.genome/Neotoma_lepida.Chromosomes.fasta"
OUTPUT_INDEX="/kuhpc/work/colella/ben/007.neotoma.panel/01.reference.genome/Neotoma_lepida.Chromosomes"

# Run bowtie-build
bowtie-build $INPUT_FASTA $OUTPUT_INDEX

