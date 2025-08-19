# Nanopore Preprocessing Pipeline

Three-step pipeline for preprocessing Nanopore sequencing data:

1. **01_align.sh**: Aligns basecalled reads to reference genome using Dorado (requires GPU)
2. **02_sort.sh**: Sorts aligned BAM files by genomic coordinates using SAMtools
3. **03_index_all.sh**: Creates BAM index files for sorted BAM files
