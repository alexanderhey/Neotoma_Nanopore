#!/bin/bash
#SBATCH --job-name=mask
#SBATCH --partition=colella
#SBATCH --time=10:00:00
#SBATCH --mem=120G
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --output=02.output_mask_external.%j.txt

module load python
module load samtools
module load bedtools
module load bowtie

./mask_external.sh /kuhpc/work/colella/ben/007.neotoma.panel/01.reference.genome/indexes/Neotoma_lepida.Chromosomes Nanotoma.masked.windows.mask29.fa 50 5 128 Nanotoma.masked.windows.external.

#1 full_bowtie - bowtie prefix of index search for repeats of sequences in the target
#2 target_fa   - FASTA file of the target reference
#3 min_len     - minimum repeat length
#4 min_copy    - minimum repeat copy number
#5 threads     - number of threads to use for bowtie
#6 out_prefix  - output prefix for all output files (default: working directory)
