# Mitochondrial Phylogenetic Analysis Pipeline

Two-step pipeline for mitochondrial genome analysis and phylogenetic tree construction:

1. **01_align_reads_to_mito.sh**: Aligns basecalled reads to mitochondrial reference, sorts and indexes BAM files
2. **02_variant_to_iqtree.sh**: Generates consensus sequences from alignments and builds phylogenetic tree

