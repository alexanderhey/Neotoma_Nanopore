#!/bin/bash
# 02_variant_to_iqtree.sh
# Generates consensus sequences and builds phylogenetic tree from mitochondrial alignments

# Load required modules
module load muscle
module load iqtree

# Define tool paths (UPDATE THESE PATHS)
samtools_path="samtools"  # or full path: "path/to/samtools"

# Define input and output directories (UPDATE THESE PATHS)
bam_dir="path/to/sorted_bam_files"
consensus_dir="./consensus_sequences"
alignment_dir="./alignment"
tree_dir="./tree"

# Create output directories
mkdir -p "$consensus_dir" "$alignment_dir" "$tree_dir"

# Step 1: Generate consensus sequences from BAM files
echo "Generating consensus sequences..."
for bam_file in "$bam_dir"/*.bam; do
    if [ ! -f "$bam_file" ]; then
        echo "No BAM files found in $bam_dir"
        exit 1
    fi
    
    sample_name=$(basename "${bam_file%.bam}")
    consensus_fasta="${consensus_dir}/${sample_name}_consensus.fasta"
    
    echo "Generating consensus for $sample_name..."
    
    $samtools_path consensus \
        -f fasta \
        --min-MQ 30 \
        --min-BQ 20 \
        --ambig \
        -a \
        -o "$consensus_fasta" \
        "$bam_file"
    
    if [ $? -ne 0 ]; then
        echo "Error generating consensus for $sample_name"
        continue
    fi
    
    # Check for empty consensus
    if [ ! -s "$consensus_fasta" ]; then
        echo "Consensus FASTA for $sample_name is empty. Skipping..."
        continue
    fi
    
    # Post-process: uppercase and replace underscores with gaps
    sed -i 's/[a-z]/\U&/g; s/_/-/g' "$consensus_fasta"
    
    echo "Consensus generated for $sample_name"
done

# Step 2: Combine all consensus sequences
echo "Combining consensus sequences..."
combined_fasta="${alignment_dir}/combined_consensus.fasta"

# Create or clear the combined FASTA file
> "$combined_fasta"

# Combine all FASTA files
for fasta_file in "${consensus_dir}"/*.fasta; do
    if [ ! -f "$fasta_file" ]; then
        echo "No consensus FASTA files found"
        exit 1
    fi
    
    sample_name=$(basename "${fasta_file%.fasta}")
    
    # Rename headers and append to combined file
    awk -v name="$sample_name" '/^>/ {print ">" name; next} {print}' "$fasta_file" >> "$combined_fasta"
done

echo "Combined consensus sequences: $combined_fasta"

# Step 3: Align sequences with MUSCLE
echo "Aligning sequences with MUSCLE..."
aligned_fasta="${alignment_dir}/aligned_sequences.fasta"
muscle -in "$combined_fasta" -out "$aligned_fasta"

if [ $? -ne 0 ]; then
    echo "Error during sequence alignment"
    exit 1
fi

echo "Sequence alignment complete: $aligned_fasta"

# Step 4: Build phylogenetic tree with IQ-TREE
echo "Building phylogenetic tree with IQ-TREE..."
iqtree2 -s "$aligned_fasta" -m MFP -st DNA -bb 1000 -alrt 1000 -nt AUTO -pre "${tree_dir}/mito_tree_with_bootstrap"

if [ $? -ne 0 ]; then
    echo "Error during phylogenetic tree construction"
    exit 1
fi

echo "Phylogenetic tree construction complete."
echo "Results are in: $tree_dir"
echo "Tree file: ${tree_dir}/mito_tree_with_bootstrap.treefile"

# Explanation of samtools consensus flags:
# -f fasta: Output format as FASTA
# --min-MQ 30: Minimum mapping quality of 30
# --min-BQ 20: Minimum base quality of 20
# --ambig: Use IUPAC ambiguity codes for heterozygous positions
# -a: Output all bases, including regions with no coverage
# -o: Output file for consensus sequence