#!/bin/bash
#SBATCH --job-name=mask
#SBATCH --partition=sixhour
#SBATCH --time=6:00:00
#SBATCH --mem=120G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=01.output_mask_internal.%j.txt

module load python
module load jellyfish

./mask_internal.sh /kuhpc/work/colella/ben/007.neotoma.panel/Neotoma_reference_files/40kb_loci.nuc.mito.fasta 10 30 Nanotoma.masked.windows.






#1 reference  - fasta file of the reference to mask
#2 k          - k-mer length
#3 iters      - number of masking iterations to run
#4 out_prefix - output prefix for all output files
