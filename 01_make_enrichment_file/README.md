The following scripts take an input .fasta reference file, in this case it is ASM167557v1 NCBI reference number of Neotoma lepida.
The first script will grab all annotation lines from the gff file followed by taking only the annotations labeled gene. 
The third script gives you the genes at least 100kb apart. 
The fourth script chooses 998 random genes from that subset from before. 
The fifth script identifies the center of each of your 998 genes and creates a 40kb window around that in a .fasta format.
The 6th script adds the mitogenome reference (FN237_NEFL.fasta) to your 40kb window file 
The resulting file is titled 40kb_loci.nuc.mito.fasta