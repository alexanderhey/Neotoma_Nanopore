#!/bin/bash

for name in 10kb_loci 20kb_loci 30kb_loci 40kb_loci 50kb_loci 60kb_loci
do

  cat $name.fasta FN237_NEFL.fasta > $name.nuc.mito.fasta

done



